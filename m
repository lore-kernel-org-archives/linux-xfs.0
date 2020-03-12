Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A97C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A495206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sz+NBCdJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbgCLDpn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:45:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36250 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:45:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3hBhC181522;
        Thu, 12 Mar 2020 03:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tSPULz0g6DfDdTB5mzr9exbY9ZXaSMUrdtAjfRLuIl4=;
 b=sz+NBCdJoTmJMIJ8lAS9Ye+fHB/+XCHgkpVsr9EBS24OhJdOLf88UliTH5br2MGG/762
 zDht94ckX/dE0ZXBjTBYSoqQYN6AHiI+UPbsWQuj/B8dlx/Lm6o/CHXWA2fNMkQplGs1
 obCAbwcH6ckO7yjeECiFowd6aGz3jmRtoUE415vtAca15Zsj/WCY9vPDYy3QAvRJbOaR
 sAt/IAU7diiXXL+1wpA+GkVESiFPskxC582N3k/6Jolw37ON/RIG3n8qStWJZSv8XBBo
 n3i8Y8fyjGgV+CJGBXZ1l3KSWJuuhri880D+VkSRjyEkoSiKlgXPmbHMZIAf8/ED2Vp9 Hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ym31uq78x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cEsC085509;
        Thu, 12 Mar 2020 03:45:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yp8q1vj5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3jc7P029294;
        Thu, 12 Mar 2020 03:45:38 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:38 -0700
Subject: [PATCH 1/7] xfs: introduce fake roots for ag-rooted btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 11 Mar 2020 20:45:37 -0700
Message-ID: <158398473702.1308059.5932849079464881055.stgit@magnolia>
In-Reply-To: <158398473036.1308059.18353233923283406961.stgit@magnolia>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=3 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
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
 fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |   30 ++++++++
 fs/xfs/xfs_trace.h        |   28 ++++++++
 3 files changed, 225 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4ef9f0b42c7f..085bc070e804 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -382,6 +382,8 @@ xfs_btree_del_cursor(
 	/*
 	 * Free the cursor.
 	 */
+	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
+		kmem_free((void *)cur->bc_ops);
 	kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
@@ -4908,3 +4910,169 @@ xfs_btree_has_more_records(
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
+
+/*
+ * Staging Cursors and Fake Roots for Btrees
+ * =========================================
+ *
+ * A staging btree cursor is a special type of btree cursor that callers must
+ * use to construct a new btree index using the btree bulk loader code.  The
+ * bulk loading code uses the staging btree cursor to abstract the details of
+ * initializing new btree blocks and filling them with records or key/ptr
+ * pairs.  Regular btree operations (e.g. queries and modifications) are not
+ * supported with staging cursors, and callers must not invoke them.
+ *
+ * Fake root structures contain all the information about a btree that is under
+ * construction by the bulk loading code.  Staging btree cursors point to fake
+ * root structures instead of the usual AG header or inode structure.
+ *
+ * Callers are expected to initialize a fake root structure and pass it into
+ * the _stage_cursor function for a specific btree type.  When bulk loading is
+ * complete, callers should call the _commit_staged_btree function for that
+ * specific btree type to commit the new btree into the filesystem.
+ */
+
+/*
+ * Don't allow staging cursors to be duplicated because they're supposed to be
+ * kept private to a single thread.
+ */
+STATIC struct xfs_btree_cur *
+xfs_btree_fakeroot_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	ASSERT(0);
+	return NULL;
+}
+
+/*
+ * Don't allow block allocation for a staging cursor, because staging cursors
+ * do not support regular btree modifications.
+ *
+ * Bulk loading uses a separate callback to obtain new blocks from a
+ * preallocated list, which prevents ENOSPC failures during loading.
+ */
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
+/*
+ * Don't allow block freeing for a staging cursor, because staging cursors
+ * do not support regular btree modifications.
+ */
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
+	afake = cur->bc_ag.afake;
+	ptr->s = cpu_to_be32(afake->af_root);
+}
+
+/*
+ * Bulk Loading for AG Btrees
+ * ==========================
+ *
+ * For a btree rooted in an AG header, pass a xbtree_afakeroot structure to the
+ * staging cursor.  Callers should initialize this to zero.
+ *
+ * The _stage_cursor() function for a specific btree type should call
+ * xfs_btree_stage_afakeroot to set up the in-memory cursor as a staging
+ * cursor.  The corresponding _commit_staged_btree() function should log the
+ * new root and call xfs_btree_commit_afakeroot() to transform the staging
+ * cursor into a regular btree cursor.
+ */
+
+/* Update the btree root information for a per-AG fake root. */
+STATIC void
+xfs_btree_afakeroot_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	afake->af_root = be32_to_cpu(ptr->s);
+	afake->af_levels += inc;
+}
+
+/*
+ * Initialize a AG-rooted btree cursor with the given AG btree fake root.  The
+ * btree cursor's bc_ops will be overridden as needed to make the staging
+ * functionality work.  If new_ops is not NULL, these new ops will be passed
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
+	ASSERT(cur->bc_tp == NULL);
+
+	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
+	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
+	nops->free_block = xfs_btree_fakeroot_free_block;
+	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
+	nops->set_root = xfs_btree_afakeroot_set_root;
+	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
+
+	cur->bc_ag.afake = afake;
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
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	const struct xfs_btree_ops	*ops)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(cur->bc_tp == NULL);
+
+	trace_xfs_btree_commit_afakeroot(cur);
+
+	kmem_free((void *)cur->bc_ops);
+	cur->bc_ag.agbp = agbp;
+	cur->bc_ops = ops;
+	cur->bc_flags &= ~XFS_BTREE_STAGING;
+	cur->bc_tp = tp;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0d10bbd5223a..aa4a7bd40023 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -179,7 +179,10 @@ union xfs_btree_irec {
 
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	struct xfs_buf		*agbp;
+	union {
+		struct xfs_buf		*agbp;
+		struct xbtree_afakeroot	*afake;	/* fake ag header root */
+	};
 	xfs_agnumber_t		agno;
 	union {
 		struct {
@@ -235,6 +238,12 @@ typedef struct xfs_btree_cur
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
@@ -515,4 +524,23 @@ xfs_btree_islastblock(
 	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
 }
 
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
+void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
+		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 059c3098a4a0..d8c229492973 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3605,6 +3605,34 @@ TRACE_EVENT(xfs_check_new_dalign,
 		  __entry->calc_rootino)
 )
 
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
+		__entry->agno = cur->bc_ag.agno;
+		__entry->agbno = cur->bc_ag.afake->af_root;
+		__entry->levels = cur->bc_ag.afake->af_levels;
+		__entry->blocks = cur->bc_ag.afake->af_blocks;
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

