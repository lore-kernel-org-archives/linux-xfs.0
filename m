Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbeHFXV3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Aug 2018 19:21:29 -0400
From: Marco Benatto <mbenatto@redhat.com>
Subject: [PATCH] design: Document project quota inode
Date: Mon,  6 Aug 2018 18:10:32 -0300
Message-Id: <20180806211032.16777-1-mbenatto@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: mbenatto@redhat.com, darrick.wong@oracle.com

A project quota inode was introduced into V5 superblock allowing
project quotas and group quotas to be used simultaneously. However
on "Quota Inodes" section we still mention it's not possible to
use project and group quotas at sametime.

This patch documents this behavior for V5 and later superblocks,
while keeps documented the old behavior for earlier versions.

Signed-off-by: Marco Benatto <mbenatto@redhat.com>
---
 design/XFS_Filesystem_Structure/internal_inodes.asciidoc | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index f5c2654..b694e74 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -8,9 +8,12 @@ accessible from the superblock.
 [[Quota_Inodes]]
 == Quota Inodes
 
-If quotas are used, two inodes are allocated for user and group quota
-management. If project quotas are used, these replace the group quota management
-and therefore uses the group quota inode.
+If quotas are used, prior to version 5 superblocks, two inodes are allocated for
+user and group management. In this case if project quotas are used, these replace
+the group quota management and therefore uses the group quota inode.
+
+In version 5 superblock or later a third inode will be allocated to project quota
+management, making it possible to use group and project quotas management simultaneously.
 
 * Project quota's primary purpose is to track and monitor disk usage for
 directories. For this to occur, the directory inode must have the
@@ -28,7 +31,7 @@ multiplied by the size of +xfs_dqblk_t+ (136 bytes).
 .Quota inode layout
 image::images/76.png[]
 
-Quota information is stored in the data extents of the two reserved quota
+Quota information is stored in the data extents of the reserved quota
 inodes as an array of the +xfs_dqblk+ structures, where there is one array
 element for each ID in the system:
 
-- 
2.9.5

