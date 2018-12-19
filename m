Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725294AbeLSIbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 03:31:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBJ8SmXl088283
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 03:31:06 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2pffeufr38-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 03:31:06 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Dec 2018 08:31:04 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/9] xfs-5.0: inode scrubber fixes
Date: Wed, 19 Dec 2018 14:01:13 +0530
In-Reply-To: <154344761877.3835.7785580513047409388.stgit@magnolia>
References: <154344761877.3835.7785580513047409388.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1644698.IS83YqTc9I@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thursday, November 29, 2018 4:56:58 AM IST Darrick J. Wong wrote:
> Hi all,
> 
> Here are fixes for some problems with the inode btree scrub code, namely
> that the existing code does not handle the case where a single inode
> cluster is mapped by multiple inobt records.
> 
> Patch 1 teaches the inode record block counting code to handle the case
> where there's more than one inobt record per inode cluster.  We do this
> by counting inodes and converting to blocks only at the end.
> 
> Patch 2 corrects a condition where we needed to clamp the number of
> inodes checked for a given inobt record to the inode chunk size.
> 
> Patches 3-4 move the inobt record alignment checks to a separate
> function and enhance the function to check that when we have more than
> one inobt record per cluster we actually check that *all* of the
> necessary records are present and in the correct order.
> 
> Patches 5-7 reorganize the inobt free data checks to deal with the
> "multiple inobt records per icluster" situation.  In restructuring the
> code to do so, we also rename variables and functions to be less
> confusing about what they're there for.  We also fix the 'is the inode
> free?' check to calculate dinode buffer offsets correctly in the
> "multiple inobt records per icluster" situation.
> 
> Patch 8 aborts the xattr scrub loop if there are pending fatal signals.
> 
> Patch 9 checks that for any directory or attr fork there are no extent
> maps that stretch beyond what a xfs_dablk_t can map.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees.  The kernel patches[1] should apply against
> 4.20-rc4.
> 
> Comments and questions are, as always, welcome.

Hi Darrick,

I reviewed patches 1 through 7. The fixes look good.

I am not well versed with the XFS code that deals with xattrs &
directories. Hence I could not review patches 8 and 9.

I did a simple scrub test on a 64k blocksized filesystem running a kernel
having the following commit as the HEAD,

commit 6c4e1579b332e52566c11416e0dd0fa91a3b8f70 (HEAD -> djwong-devel, djwong-xfs-linux/djwong-devel)
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Thu Oct 18 17:35:49 2018 -0700

    xfs: repair quotas
    
    Fix anything that causes the quota verifiers to fail.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


Xfsprogs had the following as the topmost commit,

commit 633eec2a893c3be9796dad188144b00e084560ec (HEAD -> djwong-devel, djwong/djwong-devel)
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Tue Nov 13 17:38:31 2018 -0800

    xfs: repair extended attributes
    
    If the extended attributes look bad, try to sift through the rubble to
    find whatever keys/values we can, zap the attr tree, and re-add the
    values.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


The test filesystem had 2000 files with each being 64k in size.

root@ubuntu:~# xfs_scrub -d -n -v /mnt/
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Phase 1: Find filesystem geometry.
/mnt/: using 8 threads to scrub.
Phase 2: Check internal metadata.
Info: AG 1 superblock: Optimization is possible. (scrub.c line 269)
Info: AG 3 superblock: Optimization is possible. (scrub.c line 269)
Info: AG 2 superblock: Optimization is possible. (scrub.c line 269)
Error: AG 0 free inode btree: Repairs are required. (scrub.c line 253)
Phase 3: Scan all inodes.
Phase 5: Check directory tree.
Info: /mnt/: Filesystem has errors, skipping connectivity checks. (phase5.c line 295)
Phase 7: Check summary counters.
163.9MiB data used;  1.9K inodes used.
152.7MiB data found; 1.9K inodes found.
1.9K inodes counted; 1.9K inodes checked.
/mnt/: errors found: 1
/mnt/: Re-run xfs_scrub without -n.

Looks like we have a bug when scrubbing the Free inode btree. I will work on
figuring out the root cause and also plan to execute scrub tests shipped with
xfstests.

-- 
chandan
