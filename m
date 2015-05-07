Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FAD67F37
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 17:55:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 813A830404E
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 15:55:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	g4aq2NEY1VZxkiuy for <xfs@oss.sgi.com>;
	Thu, 07 May 2015 15:55:23 -0700 (PDT)
Date: Fri, 8 May 2015 08:55:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Valid Benchmark Value & Methods
Message-ID: <20150507225521.GB16689@dastard>
References: <554B4B59.6000706@xtremenitro.org> <2204700.QypQcg3ER3@merkaba>
	<554B5782.4040303@xtremenitro.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <554B5782.4040303@xtremenitro.org>
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
To: Dewangga <dewanggaba@xtremenitro.org>
Cc: xfs@oss.sgi.com

On Thu, May 07, 2015 at 07:16:02PM +0700, Dewangga wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello Martin,
> Thanks for your reply, yes I've read that link, but another question,
> is noatime,nodiratime,etc still valid for performance tuning guidance?

You may have read it, but I don't think it sunk in....

> Even the default mount options only "rw,inode64,seclabel,attr2".

Where's relatime(*)? That's been a default for a lot longer than
inode64...

$ grep "root " /proc/mounts
/dev/root / xfs rw,relatime,attr2,inode64,noquota 0 0
$

> Is it still increase the performance if the additional mount options
> added?

Depends on your workload, which is more critical to understand than
anything else. Why? because it's your workload that is going to
determine if twiddling a knob is going to have any effect on
performance. Once you understand the workload and what the
bottlenecks are, then you can look at what knobs the filesystem
provides to alleviate those bottlenecks.

IOWs, asking the question "how do I tune my filesystem for best
performance" is, fundamentally, the wrong way to go about obtaining
best filesystem performance.  The questions that need to be answered
are "what bottlenecks does my application have?" followed by "what
does the filesystem provide to alleviate those bottlenecks".

i.e. understand the problem you need to solve *before* you try to
solve it, otherwise you "solve" the wrong problem...

Cheers,

Dave.

(*) An example of exactly what I'm talking abou there. The default
option of relatime gets >95% of the benefit of noatime onmost
workloads compared to the old strictatime behaviour, but unlike
noatime it still retains atime updates. IOWs there's a pretty good
chance that noatime has little measurable impact on your
application's performance, but understanding and benchmarking
anything other than your application won't tell you this.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
