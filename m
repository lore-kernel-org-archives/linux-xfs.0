Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:27968 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727028AbeJRJf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 05:35:59 -0400
Date: Thu, 18 Oct 2018 12:37:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181018013727.GE6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
> I have a user running a 1.7TB filesystem with ~10% usage (as shown
> by df), getting sporadic ENOSPC errors. The disk is mounted with
> inode64 and has a relatively small number of large files. The disk
> is a single-member RAID0 array, with 1MB chunk size. There are 32
> AGs. Running Linux 4.9.17.

ENOSPC on what operation? write? open(O_CREAT)? something else?

What's the filesystem config (xfs_info output)?

> The write load consists of AIO/DIO writes, followed by unlinks of
> these files. The writes are non-size-changing (we truncate ahead)
> and we use XFS_IOC_FSSETXATTR/XFS_FLAG_EXTSIZE with a hint size of
> 32MB. The errors happen on commit logs, which have a target size of
> 32MB (but may exceed it a little).
> 
> 
> The errors are sporadic and after restarting the workload they go
> away for a few hours to a few days, but then return. During one of
> the crashes I used xfs_db to look at fragmentation and saw that most
> AGs had free extents of size categories up to 128-255, but a few had
> more. I tried xfs_fsr but it did not help.

32MB extents are 8192 blocks. The bucket 128-255 records extents
between 512k and 1MB in size, so it sounds like free space has been
fragmented to death. Has xfs_fsr been run on this filesystem
regularly?

If the ENOSPC errors are only from files with a 32MB extent size
hints on them, then it may be that there isn't sufficient contiguous
free space to allocate an entire 32MB extent. I'm not sure what the
allocator behaviour here is (the code is a maze of twisty passages),
so I'll have to look more into this.

In the mean time, can you post the output of the freespace command
(both global and per-ag) so we can see just how much free space
there is and how badly fragmented it has become? I might be able to
reproduce the behaviour if I know the conditions under which it is
occuring.

> Is this a known issue? Would upgrading the kernel help?

Not that I know of. If it's an extszhint vs free space fragmentation
issue, then a kernel upgrade is unlikely to fix it.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
