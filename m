Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUPS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 11:18:59 -0400
Date: Fri, 21 Jun 2019 08:18:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190621151835.GX5387@magnolia>
References: <20190522180546.17063-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:35PM -0400, Brian Foster wrote:
> Hi all,
> 
> This is v2 of the extent allocation rework series. The changes in this
> version are mostly associated with code factoring, based on feedback to
> v1. The small mode helper refactoring has been isolated and pulled to
> the start of the series. The active flag that necessitated the btree
> cursor container structure has been pushed into the xfs_btree_cur
> private area. The resulting high level allocation code in
> xfs_ag_alloc_vextent() has been cleaned up to remove an unnecessary
> level of abstraction. Finally, there are various minor cleanups and
> fixes.

Hmmm.  Just for fun I decided to apply this series to see what would
happen, and on a 1k block filesystem shook out a test failure that seems
like it could be related?

MKFS_OPTIONS='-f -m reflink=1,rmapbt=1 -i sparse=1, -b size=1024, /dev/sdf'
MOUNT_OPTIONS='-o usrquota,grpquota,prjquota /dev/sdf /opt'

--D

--- generic/223.out
+++ generic/223.out.bad
@@ -48,7 +48,7 @@
 === Testing size 1g falloc on 8k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 8k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 2
 === mkfs with su 4 blocks x 4 ===
 === Testing size 1*16k on 16k stripe ===
 SCRATCH_MNT/file-1-16384-falloc: well-aligned
@@ -98,7 +98,7 @@
 === Testing size 1g falloc on 16k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 16k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 4
 === mkfs with su 8 blocks x 4 ===
 === Testing size 1*32k on 32k stripe ===
 SCRATCH_MNT/file-1-32768-falloc: well-aligned
@@ -148,7 +148,7 @@
 === Testing size 1g falloc on 32k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 32k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 8
 === mkfs with su 16 blocks x 4 ===
 === Testing size 1*64k on 64k stripe ===
 SCRATCH_MNT/file-1-65536-falloc: well-aligned
@@ -198,7 +198,7 @@
 === Testing size 1g falloc on 64k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 64k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197665 not multiple of sunit 16
 === mkfs with su 32 blocks x 4 ===
 === Testing size 1*128k on 128k stripe ===
 SCRATCH_MNT/file-1-131072-falloc: well-aligned
