Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57830 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbeACSkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 13:40:22 -0500
Subject: [PATCH 2/5] xfs_db: check should deal with cow staging events
 correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Jan 2018 10:40:19 -0800
Message-ID: <151500481975.7713.14990901464976914162.stgit@magnolia>
In-Reply-To: <151500479880.7713.6538509149156363572.stgit@magnolia>
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach xfs_check to record cow staging events correctly.  This means that
we strip off the high bit before using startblock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)


diff --git a/db/check.c b/db/check.c
index 3afde02..2f8dee5 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4730,13 +4730,24 @@ scanfunc_refcnt(
 		lastblock = 0;
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
 			if (be32_to_cpu(rp[i].rc_refcount) == 1) {
-				dbprintf(_(
-		"leftover CoW extent (%u/%u) len %u\n"),
+				xfs_agblock_t	agbno;
+				char		*msg;
+
+				agbno = be32_to_cpu(rp[i].rc_startblock);
+				if (agbno >= XFS_REFC_COW_START) {
+					agbno -= XFS_REFC_COW_START;
+					msg = _(
+		"leftover CoW extent (%u/%u) len %u\n");
+				} else {
+					msg = _(
+		"leftover CoW extent at unexpected address (%u/%u) len %u\n");
+				}
+				dbprintf(msg,
 					seqno,
-					be32_to_cpu(rp[i].rc_startblock),
+					agbno,
 					be32_to_cpu(rp[i].rc_blockcount));
 				set_dbmap(seqno,
-					be32_to_cpu(rp[i].rc_startblock),
+					agbno,
 					be32_to_cpu(rp[i].rc_blockcount),
 					DBM_COWDATA, seqno, bno);
 			} else {

