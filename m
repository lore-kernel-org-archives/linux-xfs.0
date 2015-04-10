Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 691707F9E
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 02:21:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5AF288F8040
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 00:21:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bzOHQWgLQVcsd17o for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 00:21:02 -0700 (PDT)
Date: Fri, 10 Apr 2015 17:21:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150410072100.GL13731@dastard>
References: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
	<20150410063210.GJ15810@dastard>
	<CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 09, 2015 at 11:51:17PM -0700, Shrinand Javadekar wrote:
> Thanks for the reply Dave!
> 
> >
> > Oh, right, it's that workqueue we removed in late 2012 (in the 3.7
> > cycle) because it was redundant. The only remaining fragment of it
> > is the xfslogd. What kernel are you running?
> 
> I am running 3.13.0-39-generic on Ubuntu 14.04.

You can't be running that kernel if you are seeing a process called
xfssyncd in your traces. 

$ gl -n 1 5889608
commit 5889608df35783590251cfd440fa5d48f1855179
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Oct 8 21:56:05 2012 +1100

    xfs: syncd workqueue is no more
    
    With the syncd functions moved to the log and/or removed, the syncd
    workqueue is the only remaining bit left. It is used by the log
    covering/ail pushing work, as well as by the inode reclaim work.
    
    Given how cheap workqueues are these days, give the log and inode
    reclaim work their own work queues and kill the syncd work queue.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

$ git describe --contains 5889608
for-linus-v3.8-rc1~71
$

Which, as you can see from the patch, the xfssyncd workqueue was
removed and they were separated into xfs-reclaim/<dev> and
xfs-log/<dev> work queues.

So, what exactly are you calling "xfssyncd"? Can you please post
copies of the output you are seeing that has lead you think this
kernel thread/workqueue exists in your kernel?

> >> I am seeing a behavior where the system pretty much stalls for ~5
> >> seconds after every 30 seconds. I see that the # of ios goes up but
> >> the actual write bandwidth during this 5 second period is very low
> >> (see attached images). After a fair bit of investigation, we've
> >> narrowed down the problem to XFS's syncd (fs.xfs.xfssyncd_centisecs).
> >> This runs at a default interval of 30 seconds.
> >
> > It's doing background inode reclaim which, under some circumstances,
> > involves truncating specualtive allocation beyond EOF before reclaim
> > occurs, which results in transactions and inode writeback. It was
> > highly inefficient, which is why we replaced it.
> 
> Oh.. I see. So, this isn't even actual filesystem metadata. And there
> is no option to turn the speculative allocation on/off?

You can turn it off, but now you're jumping to conclusions that this
is the cause of your problems. Perhaps you should do some
tracing/profiling whenthe system goes through these stalls to see
what is actually happening? "perf top" and trace-cmd are very useful
for this sort of investigation...

> What's the downside of not doing the truncation of the speculative
> allocation? Does that result in wasted disk space? If so, how much?

Start at:

http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_files_on_XFS_use_more_data_blocks_than_expected.3F

and read the next 4 FAQs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
