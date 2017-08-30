Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20687 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdH3WcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 18:32:07 -0400
Date: Wed, 30 Aug 2017 15:32:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/4] xfs/122: fix the size of fsop_ag_resblks structure
Message-ID: <20170830223203.GC4754@magnolia>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150406805060.31349.16766271336969357123.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

The size of the structure used to retrieve per-AG reserved blocks status
has changed (it's not in a released upstream), so update xfs/122.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 168cfd5..9ca30b7 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -81,7 +81,7 @@ sizeof(struct xfs_dsymlink_hdr) = 56
 sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
-sizeof(struct xfs_fsop_ag_resblks) = 32
+sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
