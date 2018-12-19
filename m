Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726833AbeLSNPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 08:15:31 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBJDDal6129338
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 08:15:30 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2pfmskph0x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 08:15:29 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Dec 2018 13:15:17 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/9] xfs-5.0: inode scrubber fixes
Date: Wed, 19 Dec 2018 18:45:26 +0530
In-Reply-To: <1644698.IS83YqTc9I@localhost.localdomain>
References: <154344761877.3835.7785580513047409388.stgit@magnolia> <1644698.IS83YqTc9I@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <13458322.z1pYrAaifT@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wednesday, December 19, 2018 2:01:13 PM IST Chandan Rajendra wrote:
> On Thursday, November 29, 2018 4:56:58 AM IST Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here are fixes for some problems with the inode btree scrub code, namely
> > that the existing code does not handle the case where a single inode
> > cluster is mapped by multiple inobt records.
> > 
> > Patch 1 teaches the inode record block counting code to handle the case
> > where there's more than one inobt record per inode cluster.  We do this
> > by counting inodes and converting to blocks only at the end.
> > 
> > Patch 2 corrects a condition where we needed to clamp the number of
> > inodes checked for a given inobt record to the inode chunk size.
> > 
> > Patches 3-4 move the inobt record alignment checks to a separate
> > function and enhance the function to check that when we have more than
> > one inobt record per cluster we actually check that *all* of the
> > necessary records are present and in the correct order.
> > 
> > Patches 5-7 reorganize the inobt free data checks to deal with the
> > "multiple inobt records per icluster" situation.  In restructuring the
> > code to do so, we also rename variables and functions to be less
> > confusing about what they're there for.  We also fix the 'is the inode
> > free?' check to calculate dinode buffer offsets correctly in the
> > "multiple inobt records per icluster" situation.
> > 
> > Patch 8 aborts the xattr scrub loop if there are pending fatal signals.
> > 
> > Patch 9 checks that for any directory or attr fork there are no extent
> > maps that stretch beyond what a xfs_dablk_t can map.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees.  The kernel patches[1] should apply against
> > 4.20-rc4.
> > 
> > Comments and questions are, as always, welcome.
> 
> Hi Darrick,
> 
> I reviewed patches 1 through 7. The fixes look good.
> 
> I am not well versed with the XFS code that deals with xattrs &
> directories. Hence I could not review patches 8 and 9.
> 
> I did a simple scrub test on a 64k blocksized filesystem running a kernel
> having the following commit as the HEAD,
> 
> commit 6c4e1579b332e52566c11416e0dd0fa91a3b8f70 (HEAD -> djwong-devel, djwong-xfs-linux/djwong-devel)
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Thu Oct 18 17:35:49 2018 -0700
> 
>     xfs: repair quotas
>     
>     Fix anything that causes the quota verifiers to fail.
>     
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> Xfsprogs had the following as the topmost commit,
> 
> commit 633eec2a893c3be9796dad188144b00e084560ec (HEAD -> djwong-devel, djwong/djwong-devel)
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Tue Nov 13 17:38:31 2018 -0800
> 
>     xfs: repair extended attributes
>     
>     If the extended attributes look bad, try to sift through the rubble to
>     find whatever keys/values we can, zap the attr tree, and re-add the
>     values.
>     
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> The test filesystem had 2000 files with each being 64k in size.
> 
> root@ubuntu:~# xfs_scrub -d -n -v /mnt/
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Phase 1: Find filesystem geometry.
> /mnt/: using 8 threads to scrub.
> Phase 2: Check internal metadata.
> Info: AG 1 superblock: Optimization is possible. (scrub.c line 269)
> Info: AG 3 superblock: Optimization is possible. (scrub.c line 269)
> Info: AG 2 superblock: Optimization is possible. (scrub.c line 269)
> Error: AG 0 free inode btree: Repairs are required. (scrub.c line 253)
> Phase 3: Scan all inodes.
> Phase 5: Check directory tree.
> Info: /mnt/: Filesystem has errors, skipping connectivity checks. (phase5.c line 295)
> Phase 7: Check summary counters.
> 163.9MiB data used;  1.9K inodes used.
> 152.7MiB data found; 1.9K inodes found.
> 1.9K inodes counted; 1.9K inodes checked.
> /mnt/: errors found: 1
> /mnt/: Re-run xfs_scrub without -n.
> 
> Looks like we have a bug when scrubbing the Free inode btree. I will work on
> figuring out the root cause and also plan to execute scrub tests shipped with
> xfstests.
> 
> 

We do have an unaligned finobt record,

xfs_scrub 27247 [004] 18014.774762: probe:xchk_iallocbt_rec_alignment: (c00000000075941c) ir_startino=176960 ig_cluster_align_inodes=128 imask_u32=127
        c00000000075941c xchk_iallocbt_rec_alignment+0x10c (/boot/vmlinux)
        c00000000075966c xchk_iallocbt_rec+0x14c (/boot/vmlinux)
                       0 [unknown] ([unknown])
        c000000000752968 xchk_btree+0x288 (/boot/vmlinux)
        c0000000007598c4 xchk_iallocbt+0x64 (/boot/vmlinux)
        c00000000075dc1c xfs_scrub_metadata+0x4ac (/boot/vmlinux)
        c0000000006e4b88 xfs_ioc_scrub_metadata+0x68 (/boot/vmlinux)
        c0000000006e7d5c xfs_file_ioctl+0xbbc (/boot/vmlinux)
        c000000000425e04 do_vfs_ioctl+0xd4 (/boot/vmlinux)
        c000000000426874 ksys_ioctl+0x64 (/boot/vmlinux)
        c000000000426928 __se_sys_ioctl+0x28 (/boot/vmlinux)
        c00000000000bae4 system_call+0x5c (/boot/vmlinux)
            7ffff77d7694 __GI___ioctl+0x114 (/lib/powerpc64le-linux-gnu/libc-2.27.so)
               10000e4e0 xfs_check_metadata+0x100 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
               10000e484 xfs_check_metadata+0xa4 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
               10000ec48 xfs_scrub_metadata+0xd8 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
               100008dac xfs_scan_ag_metadata+0x12c (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
               1000198c8 workqueue_thread+0x108 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
            7ffff7f2885c start_thread+0x10c (/lib/powerpc64le-linux-gnu/libpthread-2.27.so)
            7ffff77e9028 __clone+0x98 (/lib/powerpc64le-linux-gnu/libc-2.27.so)

Maybe this is due to a bug in the finobt code. I will continue debugging and
report my findings.

-- 
chandan
