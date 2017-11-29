Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36400 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbdK2BZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:25:44 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1Phqp021192
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:25:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1Ph7o019439
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:25:43 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAT1Ph9d025609
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:25:43 GMT
Subject: [PATCH 03/16] xfs: add scrub cross-referencing helpers for the rmap
 btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 17:25:42 -0800
Message-ID: <151191874246.8553.7530122656707019889.stgit@magnolia>
In-Reply-To: <151191872395.8553.15627872818207535470.stgit@magnolia>
References: <151191872395.8553.15627872818207535470.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the rmap btrees that will be used
to cross-reference metadata against the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h |    5 ++++
 2 files changed, 63 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index dd019ce..e4e971b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2334,3 +2334,61 @@ xfs_rmap_compare(
 	else
 		return 0;
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.r.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.r.rm_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_record_exists(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo,
+	bool			*has_rmap)
+{
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags;
+	int			stat;
+	struct xfs_rmap_irec	irec;
+	int			error;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	error = xfs_rmap_get_rec(cur, &irec, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	*has_rmap = (irec.rm_owner == owner && irec.rm_startblock <= bno &&
+		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 466ede6..32c9382 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -219,5 +219,10 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
 
 #endif	/* __XFS_RMAP_H__ */

