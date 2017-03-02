Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752090AbdCBRRM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 12:17:12 -0500
Date: Thu, 2 Mar 2017 11:29:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS kernel BUG during generic/270 with v4.10
Message-ID: <20170302162934.GM3213@bfoster.bfoster>
References: <20170222191300.GA29474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170222191300.GA29474@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Feb 22, 2017 at 12:13:00PM -0700, Ross Zwisler wrote:
> By running generic/270 in a loop on an XFS filesystem mounted with DAX I'm
> able to reliably generate the following kernel bug after a few (~10)
> iterations (output passed through kasan_symbolize.py):
> 
> run fstests generic/270 at 2017-02-22 12:01:05
> XFS (pmem0p2): Unmounting Filesystem
> XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> XFS (pmem0p2): Mounting V5 Filesystem
> XFS (pmem0p2): Ending clean mount
> XFS (pmem0p2): Quotacheck needed: Please wait.
> XFS (pmem0p2): Quotacheck: Done.
> XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 965

This means we've reclaimed an inode that still has delayed allocation
blocks, which shouldn't occur. We do have one recent fix in this area:
fa7f138 ("xfs: clear delalloc and cache on buffered write failure"). Do
you still reproduce this? If so, does it reproduce with that patch?

> ------------[ cut here ]------------
...
> ---[ end trace 384d06985052f068 ]---
> 
> Here's the xfstests run:
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 alara 4.10.0
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
> 
> generic/270 24s ..../check: line 596: 15817 Segmentation fault      ./$seq > $tmp.rawout 2>&1
>  [failed, exit status 139] - output mismatch (see /root/xfstests/results//generic/270.out.bad)
>     --- tests/generic/270.out	2016-10-21 15:31:10.568945780 -0600
>     +++ /root/xfstests/results//generic/270.out.bad	2017-02-22 12:01:29.272718284 -0700
>     @@ -3,6 +3,3 @@
>      Run fsstress
>      
>      Run dd writers in parallel
>     -Comparing user usage
>     -Comparing group usage
>     -Comparing filesystem consistency
>     ...
>     (Run 'diff -u tests/generic/270.out /root/xfstests/results//generic/270.out.bad'  to see the entire diff)
> 
> This was done in my normal test setup, which is a pair of PMEM disks that
> enable DAX.
> 

What I'm a little confused about though is that I thought DAX meant we
bypassed buffered I/O and always used direct I/O (which means you should
never perform delayed allocation). :/

Brian

> Here are the versions of xfstests and xfsprogs that I'm using:
> 
> xfstets: f438604 generic: test mmap io through DAX and non-DAX
> 
> xfsprogs: xfs_admin version 4.9.0
> This is just the xfsprogs that comes packaged with Fedora 25.
> 
> Thanks,
> - Ross
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
