Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47210 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753060AbeEOTz5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 May 2018 15:55:57 -0400
References: 
Subject: [GRUB PATCH] xfs: accept filesystem with sparse inodes
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ce584ae1-ee62-2dcb-9366-eb0a6df6e98e@sandeen.net>
Date: Tue, 15 May 2018 14:55:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: grub-devel@gnu.org
Cc: dkiper@net-space.pl, Peter Jones <pjones@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Chris Murphy <lists@colorremedies.com>

The sparse inode metadata format became a mkfs.xfs default in
xfsprogs-4.16.0, and such filesystems are now rejected by grub as
containing an incompatible feature.

In essence, this feature allows xfs to allocate inodes into fragmented
freespace.  (Without this feature, if xfs could not allocate contiguous
space for 64 new inodes, inode creation would fail.)

In practice, the disk format change is restricted to the inode btree,
which as far as I can tell is not used by grub.  If all you're doing
today is parsing a directory, reading an inode number, and converting
that inode number to a disk location, then ignoring this feature
should be fine, so I've added it to XFS_SB_FEAT_INCOMPAT_SUPPORTED

I did some brief testing of this patch by hacking up the regression
tests to completely fragment freespace on the test xfs filesystem, and
then write a large-ish number of inodes to consume any existing
contiguous 64-inode chunk.  This way any files the grub tests add and
traverse would be in such a fragmented inode allocation.  Tests passed,
but I'm not sure how to cleanly integrate that into the test harness.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/grub-core/fs/xfs.c b/grub-core/fs/xfs.c
index c6031bd3f..effe9de17 100644
--- a/grub-core/fs/xfs.c
+++ b/grub-core/fs/xfs.c
@@ -79,9 +79,18 @@ GRUB_MOD_LICENSE ("GPLv3+");
  #define XFS_SB_FEAT_INCOMPAT_SPINODES   (1 << 1)        /* sparse inode chunks */
  #define XFS_SB_FEAT_INCOMPAT_META_UUID  (1 << 2)        /* metadata UUID */
  
-/* We do not currently verify metadata UUID so it is safe to read such filesystem */
+/*
+ * Directory entries with ftype are explicitly handled by grub code.
+ *
+ * We do not currently verify metadata UUID, so it is safe to read filesystems
+ * with the XFS_SB_FEAT_INCOMPAT_META_UUID feature.
+ *
+ * We do not currently read the inode btrees, so it is safe to read filesystems
+ * with the XFS_SB_FEAT_INCOMPAT_SPINODES feature.
+ */
  #define XFS_SB_FEAT_INCOMPAT_SUPPORTED \
  	(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+	 XFS_SB_FEAT_INCOMPAT_SPINODES | \
  	 XFS_SB_FEAT_INCOMPAT_META_UUID)
  
  struct grub_xfs_sblock

