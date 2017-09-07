Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40333 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753118AbdIGQNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 12:13:45 -0400
Date: Thu, 7 Sep 2017 09:13:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs clones crash issue - illegal state 13 in block map
Message-ID: <20170907161330.GA6540@magnolia>
References: <CAOQ4uxgCanEpWx20QvvLvwBbjJiJ2U3oz-e1ZXrv3ZV2d3EPRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgCanEpWx20QvvLvwBbjJiJ2U3oz-e1ZXrv3ZV2d3EPRQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Sep 07, 2017 at 03:58:56PM +0300, Amir Goldstein wrote:
> Hi guys,
> 
> I am getting these errors often when running the crash tests
> with cloned files (generic/502 in my xfstests patches).
> 
> Hitting these errors requires first fixing 2 other issues
> that shadow over this issue:
> "xfs: fix incorrect log_flushed on fsync" (in master)
> "xfs: fix leftover CoW extent after truncate"
> available on my tree based on Darrick's simple fix:
> https://github.com/amir73il/linux/commits/xfs-fsync
> 
> I get the errors more often (1 out of 5) on a 100G fs on spinning disk.
> On a 10G fs on SSD they are less frequent.
> The log in this email was captured on patched stable 4.9.47 kernel,
> but I am getting the same errors on patched upstream kernel.
> 
> I wasn't able to create a deterministic reproducer, so attaching
> the full log from a failed test along with an IO log that can be
> replayed on your disk to examine the outcome.
> 
> Following is the output of fsx process #5, which is the process
> that wrote the problematic testfile5.mark0 to the log.
> This process performs only read,zero,fsync before creating
> the log mark.
> The file testfile5 was cloned from an origin 256K file before
> running fsx.
> Later, I used the random seed 35484 in this log for all
> processes and it seemed to increase the probability for failure.
> 
> # /old/home/amir/src/xfstests-dev/ltp/fsx -N 100 -d -k -P
> /mnt/test/fsxtests -i /dev/mapper/logwrites-test -S 0 -j 5
> /mnt/scratch/testfile5
> Seed set to 35484
> file_size=262144
> 5: 1 read 0x3f959 thru 0x3ffff (0x6a7 bytes)
> 5: 2 zero from 0x3307e to 0x34f74, (0x1ef6 bytes)
> 5: 3 fsync
> 5: Dumped fsync buffer to testfile5.mark0
> 
> In order to get to the crash state you need to get my
> xfstests replay-log patches and replay the attached log
> on a >= 100G scratch device:
> 
> # ./src/log-writes/replay-log --log log.xfs.testfile5.mark0 --replay
> $SCRATCH_DEV --end-mark testfile5.mark0
> # mount $SCRATCH_DEV $SCRATCH_MNT
> # umount $SCRATCH_MNT
> # xfs_repair -n $SCRATCH_DEV
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> 
> fatal error -- illegal state 13 in block map 376
> 
> Can anyone provide some insight?

Looks like I missed a couple of extent states in process_bmbt_reclist_int.

What happens if you add the following (only compile tested) patch to
xfsprogs?

(Normally I'd say send a metadump too for us mere mortals to work with,
though I'm about to plunge into weddingland so I likely won't be able to
do much until the 18th.)

((Eric: If this doesn't turn out to be a totally garbage patch, feel
free to add it to xfsprogs.))

--D

xfs_repair: handle missing extent states

Missed a couple of the new extent states in the bmbt processing, so add
them to avoid aborting xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index f817b5a..b35a523 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -796,6 +796,7 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 			case XR_E_FS_MAP:
 			case XR_E_INO:
 			case XR_E_INUSE_FS:
+			case XR_E_REFC:
 				do_warn(
 _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 					forkname, ino, b);
@@ -812,6 +813,12 @@ _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
 					forkname, ftype, ino, b);
 				goto done;
 
+			case XR_E_COW:
+				do_warn(
+_("%s fork in %s inode %" PRIu64 " claims CoW block %" PRIu64 "\n"),
+					forkname, ftype, ino, b);
+				goto done;
+
 			default:
 				do_error(
 _("illegal state %d in block map %" PRIu64 "\n"),
