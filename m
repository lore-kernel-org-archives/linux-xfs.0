Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43502 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933631AbdKAVrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:35 -0400
Subject: [PATCH 10/14] xfs/122: add inode log formats
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:30 -0700
Message-ID: <150957285003.18388.10589231868037294926.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The inode log record formats have been standardized, so check them here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 9ca30b7..ad9a055 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -83,6 +83,8 @@ sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_icreate_log) = 28
+sizeof(struct xfs_inode_log_format) = 56
+sizeof(struct xfs_inode_log_format_32) = 52
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16

