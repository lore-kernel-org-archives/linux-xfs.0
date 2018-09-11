Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:3349 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727063AbeILDYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Sep 2018 23:24:46 -0400
Date: Wed, 12 Sep 2018 08:23:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to read ERROR properly?
Message-ID: <20180911222318.GI5631@dastard>
References: <AC8D9C98-0333-480A-9E1B-9923909F5868@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AC8D9C98-0333-480A-9E1B-9923909F5868@me.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hugo Kuo <tonytkdk@me.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 11, 2018 at 11:37:44AM -0700, Hugo Kuo wrote:
> Hi XFS team,
> 
> We have our storage with XFS. I wonder how’s the proper
> workflow for troubleshooting xfs_error that shows up in the kernel
> logs.
> 
> I’ve seen various different failed so far. It’s not easy
> to address the root cause by reading kernel logs. For this case,
> how can I know the meaning of Internal error
> XFS_WANT_CORRUPTED_RETURN at line 163 of file
> fs/xfs/xfs_dir2_data.c. Caller xfs_dir3_block_verify+0x7a/0x90
> [xfs] ?

Look at your kernel source. What failed at line 163 of
fs/xfs/xfs_dir2_data.c? I don't know what kernel you are running
(current TOT doesn't have XFS_WANT_CORRUPTED_RETURN() at that
location any more), so I can only guess that at the actual
corruption that was detected.

I'm guessing that it found a free space region in the directory
block that was longer than is recordeed in the best-free array,
but why that occurred is a mystery.

> [Mon Sep 10 07:34:14 2018] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 163 of file fs/xfs/xfs_dir2_data.c. Caller xfs_dir3_block_verify+0x7a/0x90 [xfs] 
> [Mon Sep 10 07:34:14 2018] [<ffffffffa040504b>] xfs_error_report+0x3b/0x40 [xfs] 
> [Mon Sep 10 07:34:14 2018] XFS (sdq): xfs_log_force: error 5 returned. 
> [Mon Sep 10 07:34:44 2018] XFS (sdq): xfs_log_force: error 5 returned.

You'er getting IO errors to journal writes, too? Can you post the
entire log so we can see all the messages and errors that were
emitted by the kernel leading up to this?

> * For the same case, it pop up an ERROR while running xfs_repair.
>
> [root@hugo-ubuntu ~]# xfs_repair /dev/sdq 
> Phase 1 - find and verify superblock... 
> - reporting progress in intervals of 15 minutes 
> Phase 2 - using internal log 
> - zero log... 
> ERROR: The filesystem has valuable metadata changes in a log which needs to 
> be replayed. Mount the filesystem to replay the log, and unmount it before 
> re-running xfs_repair. If you are unable to mount the filesystem, then use 
> the -L option to destroy the log and attempt a repair. 
> Note that destroying the log may cause corruption -- please attempt a mount 
> of the filesystem before doing this.

Did you follow the instructions and try to mount and unmount the
filesystem, then re-run xfs_repair?

> Is there any clue about how the disk run into bad situation?

No, not from the limited information you have provided.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
