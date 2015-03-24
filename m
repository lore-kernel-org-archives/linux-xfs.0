Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97C157F3F
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 07:24:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83825304032
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:24:27 -0700 (PDT)
Received: from mail-we0-f173.google.com (mail-we0-f173.google.com
	[74.125.82.173]) by cuda.sgi.com with ESMTP id 0NxALIowPQ1jO8Nq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:24:26 -0700 (PDT)
Received: by weop45 with SMTP id p45so161929780weo.0
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:24:25 -0700 (PDT)
Message-ID: <55115776.4000006@plexistor.com>
Date: Tue, 24 Mar 2015 14:24:22 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfs: add DAX file operations support
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-6-git-send-email-david@fromorbit.com>
	<551153C4.6000808@plexistor.com>
In-Reply-To: <551153C4.6000808@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

On 03/24/2015 02:08 PM, Boaz Harrosh wrote:
> On 03/24/2015 12:51 PM, Dave Chinner wrote:
<>
> 
> Regarding splice_write:
> It looks to me like you left the vector at iter_file_splice_write().
> If I understand correctly I think you need to call default_file_splice_write()
> that uses memcpy, just as it was at the previous patches when you left
> the vector NULL. So I think you need the same switch for write
> as you do below for read.
> 

I take this back It looks like iter_file_splice_write() is perfectly usable
it relies on the source (Not us for write) being a page then kmaps and
calls one of f_op->write(file,..) or new_sync_write(file, ...) so
it looks like it all should work.

So the only bad thing is the comment it looks like splice should just
work also for dax.

Will be testing exact same thing for ext4 and report

Thanks
Boaz

> I'm doing the exact same code for ext4/2 right now and testing.
> (Thanks for the loop pointer).
> 
> Otherwise I have stared at this very carefully and it looks good
> Did not test yet.
> 
> Thanks
> Boaz
> 
<>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
