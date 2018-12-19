Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48374 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbeLSTa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 14:30:28 -0500
Subject: [PATCH 8/8] xfs_repair: fix uninitialized variable warnings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 19 Dec 2018 11:30:23 -0800
Message-ID: <154524782350.28646.8296184601173040680.stgit@magnolia>
In-Reply-To: <154524776457.28646.3004453037075812416.stgit@magnolia>
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some uninitialized variable warnings because ASSERT disappears if
DEBUG is not defined.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index f670bf87..c0a56daa 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1176,8 +1176,8 @@ process_quota_inode(
 	struct xfs_buf		*bp;
 	xfs_filblks_t		dqchunklen;
 	uint			dqperchunk;
-	int			quota_type;
-	char			*quota_string;
+	int			quota_type = 0;
+	char			*quota_string = NULL;
 	xfs_dqid_t		dqid;
 	xfs_fileoff_t		qbno;
 	int			i;
