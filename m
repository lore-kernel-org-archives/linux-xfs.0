Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C40A7CA0
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 03:55:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2D20304032
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 01:55:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id s89mSB50V0YsrBv5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 01:55:45 -0700 (PDT)
Date: Mon, 28 Mar 2016 04:55:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_repair fails after trying to format log cycle?
Message-ID: <20160328085541.GA27040@bfoster.bfoster>
References: <56F6DE67.60403@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56F6DE67.60403@shaw.ca>
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
To: Andrew Ryder <tireman@shaw.ca>
Cc: xfs@oss.sgi.com

On Sat, Mar 26, 2016 at 03:09:27PM -0400, Andrew Ryder wrote:
> Hello,
> 
> I have an mdadm array with a xfs v5 filesystem on it and its begun to give
> me issues when trying to mount it as well as complete xfs_repair. Not sure
> if anyone might be able to shed some light on what is going on or how to
> correct the issue?
> 
> When I try and mount the fs, it complains with:
> 
> [  388.479847] XFS (md2): Mounting V5 Filesystem
> [  388.494686] XFS (md2): metadata I/O error: block 0x15d6d39c0
> ("xlog_bread_noalign") error 5 numblks 8192
> [  388.495013] XFS (md2): failed to find log head
> [  388.495018] XFS (md2): log mount/recovery failed: error -5
> [  388.495090] XFS (md2): log mount failed
> 

So a read I/O error from the kernel...

> 
> This is where its not making any sense for me, If I try and run "xfs_repair
> /dev/md2" it fails with:
> 
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
> xfs_repair: read failed: Input/output error
> failed to find log head
> zero_log: cannot find log head/tail (xlog_find_tail=-5)
> 
> fatal error -- ERROR: The log head and/or tail cannot be discovered. Attempt
> to mount the
> filesystem to replay the log or use the -L option to destroy the log and
> attempt a repair.
> 

... similar read error from xfsprogs...

> 
> But if I run "xfs_repair -L /dev/md2" which gives:
> 
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
> xfs_repair: read failed: Input/output error
> failed to find log head
> zero_log: cannot find log head/tail (xlog_find_tail=-5)
> xfs_repair: libxfs_device_zero write failed: Input/output error
> 

... and it looks like it fails to write as well when trying to zero the
log...

> then try and re-run "xfs_repair /dev/md2" it starts traversing the
> filesystem all the way to "Phase 7" then errors with:
> 
> Phase 7 - verify and correct link counts...
>         - 14:36:55: verify and correct link counts - 33 of 33 allocation
> groups done
> Maximum metadata LSN (64:2230592) is ahead of log (0:0).
> Format log to cycle 67.
> xfs_repair: libxfs_device_zero write failed: Input/output error
> 
> 
> Yet at this point I can now mount the filesystem..
> 

... and this is effectively a repeat of the write error as we try to
format the log with a correct LSN based on the metadata LSN tracked by
the repair process. Your kernel is old enough that runtime probably
won't complain either way (note that 3.19 might be considered a fairly
early kernel for using CRC support). Perhaps the first write attempt
zeroed enough of the log before it failed that log recovery wasn't
required, and thus these problematic I/Os were avoided.

What's the history of this fs? Has it been working for some time, just
recently formatted? What lead to the need for log recovery? What's the
mdadm --detail info, member device size, total array size, xfs_info of
the filesystem, etc..?

Does xfs_repair run clean at this point? If so, does 'xfs_repair -L'
still reproduce the write error (note that I'm assuming you have a clean
log such that this command will not cause data loss). If so, an strace
of the repair process might be interesting...

Brian

> 
> Checking the drives with smartctl shows no errors nor does 'dmesg' show any
> hardware i/o or controller related errors...
> 
> I've tried scrubbing the array and no bad sectors are found either..
> 
> I'm running kernel 3.19.8 with xfsprogs 4.5.
> 
> Thanks,
> Andrew
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
