Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161105AbeCATNN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 14:13:13 -0500
Subject: [PATCH 02/16] xfs_db: don't crash in ablock if there's no inode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Mar 2018 11:13:07 -0800
Message-ID: <151993158791.22223.3859108968502533810.stgit@magnolia>
In-Reply-To: <151993157539.22223.6269629008244777191.stgit@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we actually have an inode selected before trying to unwrap its
attribute fork.  Found via a crash in xfs/288 with project quotas
enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/block.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/db/block.c b/db/block.c
index 5ecd687..174e29a 100644
--- a/db/block.c
+++ b/db/block.c
@@ -84,6 +84,11 @@ ablock_f(
 	}
 	push_cur();
 	set_cur_inode(iocur_top->ino);
+	if (!iocur_top->data) {
+		pop_cur();
+		dbprintf(_("no current inode\n"));
+		return 0;
+	}
 	haveattr = XFS_DFORK_Q((xfs_dinode_t *)iocur_top->data);
 	pop_cur();
 	if (!haveattr) {

