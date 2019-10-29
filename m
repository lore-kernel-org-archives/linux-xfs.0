Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B26ECA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E78218DE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QoTCYzZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfJ2XaP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:30:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfJ2XaP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:30:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNU30t011301
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=c9Qlx/2N3w0zUDdDyJJA5w9RN5KMAFmaQy7dlZKUxAU=;
 b=QoTCYzZMswgYO790xhpI4Ffp6HyM6N8usZ/5Yd9UGokazU0t3bxwrikoMypcG8BQphI2
 q9m/Dbjg5XzhKWLFDeprJuCEGaKqrP2Ww/qOFh8NB7hdz1OTWYWQXjeafEkkBYGLOKZw
 Avg/lYzND2nMbljGAk6sjGW6IfKBE6DyDNxjExXOYmRq7KBetAIPtmvAr7ItHSkwqf9k
 ZNfZ4h1LyDERbuybZ0A4wOVn6BPdVQJCDZut3bskd3dgXeSwskP1oxb56imBx5G1opyx
 xJj9FbciymtvdeGqFE4QtZ/yqEvFdFD0bJjvHraLdEy6gHny137sugntRHwZMKlaaiAY fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vxwhfgav4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSEjR039052
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vxwj8uy35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:12 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNUAMp006392
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:30:10 -0700
Subject: [PATCH 1/4] xfs: introduce fake roots for ag-rooted btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:30:09 -0700
Message-ID: <157239180957.1266747.9609472431653271537.stgit@magnolia>
In-Reply-To: <157239180345.1266747.1586648446090389492.stgit@magnolia>
References: <157239180345.1266747.1586648446090389492.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an in-core fake root for AG-rooted btree types so that callers
can generate a whole new btree using the upcoming btree bulk load
function without making the new tree accessible from the rest of the
filesystem.  It is up to the individual btree type to provide a function
to create a staged cursor (presumably with the appropriate callouts to
update the fakeroot) and then commit the staged root back into the
filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |  117 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |   42 ++++++++++++++--
 fs/xfs/xfs_trace.h        |   28 +++++++++++
 3 files changed, 182 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4fd89c80c821..ab0d459c10ea 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -384,6 +384,8 @@ xfs_btree_del_cursor(
 	/*
 	 * Free the cursor.
 	 */
+	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
+		kmem_free((void *)cur->bc_ops);
 	kmem_zone_free(xfs_btree_cur_zone, cur);
 }
 
@@ -4936,3 +4938,118 @@ xfs_btree_has_more_records(
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
+
+/* We don't allow staging cursors to be duplicated. */
+STATIC struct xfs_btree_cur *
+xfs_btree_fakeroot_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	ASSERT(0);
+	return NULL;
+}
+
+/* Refuse to allow regular block allocation for a staging cursor. */
+STATIC int
+xfs_btree_fakeroot_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start_bno,
+	union xfs_btree_ptr	*new_bno,
+	int			*stat)
+{
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+/* Refuse to allow block freeing for a staging cursor. */
+STATIC int
+xfs_btree_fakeroot_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+/* Initialize a pointer to the root block from the fakeroot. */
+STATIC void
+xfs_btree_fakeroot_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xbtree_afakeroot	*afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	afake = cur->bc_private.a.afake;
+	ptr->s = cpu_to_be32(afake->af_root);
+}
+
+/* Set the root block when our tree has a fakeroot. */
+STATIC void
+xfs_btree_afakeroot_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	afake->af_root = be32_to_cpu(ptr->s);
+	afake->af_levels += inc;
+}
+
+/*
+ * Initialize a AG-rooted btree cursor with the given AG btree fake root.  The
+ * btree cursor's @bc_ops will be overridden as needed to make the staging
+ * functionality work.  If @new_ops is not NULL, these new ops will be passed
+ * out to the caller for further overriding.
+ */
+void
+xfs_btree_stage_afakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xbtree_afakeroot		*afake,
+	struct xfs_btree_ops		**new_ops)
+{
+	struct xfs_btree_ops		*nops;
+
+	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
+	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
+
+	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
+	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
+	nops->free_block = xfs_btree_fakeroot_free_block;
+	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
+	nops->set_root = xfs_btree_afakeroot_set_root;
+	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
+
+	cur->bc_private.a.afake = afake;
+	cur->bc_nlevels = afake->af_levels;
+	cur->bc_ops = nops;
+	cur->bc_flags |= XFS_BTREE_STAGING;
+
+	if (new_ops)
+		*new_ops = nops;
+}
+
+/*
+ * Transform an AG-rooted staging btree cursor back into a regular cursor by
+ * substituting a real btree root for the fake one and restoring normal btree
+ * cursor ops.  The caller must log the btree root change prior to calling
+ * this.
+ */
+void
+xfs_btree_commit_afakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xfs_buf			*agbp,
+	const struct xfs_btree_ops	*ops)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	trace_xfs_btree_commit_afakeroot(cur);
+
+	kmem_free((void *)cur->bc_ops);
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_ops = ops;
+	cur->bc_flags &= ~XFS_BTREE_STAGING;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index bac15668aeee..39ca3f0a3bf8 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -185,6 +185,16 @@ union xfs_btree_cur_private {
 	} refc;
 };
 
+/* Private information for a AG-rooted btree. */
+struct xfs_btree_priv_ag {			/* needed for BNO, CNT, INO */
+	union {
+		struct xfs_buf		*agbp;	/* agf/agi buffer pointer */
+		struct xbtree_afakeroot	*afake;	/* fake ag header root */
+	};
+	xfs_agnumber_t			agno;	/* ag number */
+	union xfs_btree_cur_private	priv;
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -206,11 +216,7 @@ typedef struct xfs_btree_cur
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
 	union {
-		struct {			/* needed for BNO, CNT, INO */
-			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
-			xfs_agnumber_t	agno;	/* ag number */
-			union xfs_btree_cur_private	priv;
-		} a;
+		struct xfs_btree_priv_ag a;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
 			int		allocated;	/* count of alloced */
@@ -229,6 +235,12 @@ typedef struct xfs_btree_cur
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
 #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
+/*
+ * The root of this btree is a fakeroot structure so that we can stage a btree
+ * rebuild without leaving it accessible via primary metadata.  The ops struct
+ * is dynamically allocated and must be freed when the cursor is deleted.
+ */
+#define XFS_BTREE_STAGING		(1<<5)
 
 
 #define	XFS_BTREE_NOERROR	0
@@ -521,4 +533,24 @@ int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
 
+/* Fake root for an AG-rooted btree. */
+struct xbtree_afakeroot {
+	/* AG block number of the new btree root. */
+	xfs_agblock_t		af_root;
+
+	/* Height of the new btree. */
+	unsigned int		af_levels;
+
+	/* Number of blocks used by the btree. */
+	unsigned int		af_blocks;
+};
+
+/* Cursor interactions with with fake roots for AG-rooted btrees. */
+void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
+		struct xbtree_afakeroot *afake,
+		struct xfs_btree_ops **new_ops);
+void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur,
+		struct xfs_buf *agbp,
+		const struct xfs_btree_ops *ops);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaae275ed430..e04ed5324696 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3609,6 +3609,34 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
 DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
+TRACE_EVENT(xfs_btree_commit_afakeroot,
+	TP_PROTO(struct xfs_btree_cur *cur),
+	TP_ARGS(cur),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(unsigned int, levels)
+		__field(unsigned int, blocks)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->btnum = cur->bc_btnum;
+		__entry->agno = cur->bc_private.a.agno;
+		__entry->agbno = cur->bc_private.a.afake->af_root;
+		__entry->levels = cur->bc_private.a.afake->af_levels;
+		__entry->blocks = cur->bc_private.a.afake->af_blocks;
+	),
+	TP_printk("dev %d:%d btree %s ag %u levels %u blocks %u root %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->agno,
+		  __entry->levels,
+		  __entry->blocks,
+		  __entry->agbno)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

