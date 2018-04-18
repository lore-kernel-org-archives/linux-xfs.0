Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46882 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:57 -0400
Subject: [PATCH 01/11] xfs_repair: examine all remote attribute blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:37 -0700
Message-ID: <152401959780.13319.9582448473529615015.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Examine all remote xattr values of a file, not just the XFS_ATTR_ROOT
values.  This enables us to detect and zap corrupt user xattrs, as
tested by xfs/404.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |    3 ---
 1 file changed, 3 deletions(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 8b1b8a7..bb5ab3d 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -537,9 +537,6 @@ process_leaf_attr_remote(
 		return -1;
 	}
 
-	if (!(entry->flags & XFS_ATTR_ROOT))
-		goto out;
-
 	value = malloc(be32_to_cpu(remotep->valuelen));
 	if (value == NULL) {
 		do_warn(

