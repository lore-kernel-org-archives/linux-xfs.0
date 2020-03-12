Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3E7C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A849C206F2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yYXeabKT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbgCLDru (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:47:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37732 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDrt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:47:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3hBa2181498;
        Thu, 12 Mar 2020 03:47:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hPWk5NQFHsRdqi6A86TauYhnWbczrm8g2HI86oscW80=;
 b=yYXeabKTdKFgh6S0IpxwiccwDMdO6FrhyQ9rwJ/TKU4p/YyUgSRjhJsGfKN7gIFfCAB9
 iqb0DSpNc/CcHtU8uYfy5VhkHjYGrJ3vKRUIiAGB5mr2jvuzjJ2mSCLNt+sidzF2EurR
 ci4+TIZ/OsoGZxvzsI46dzxs7qzaLl7DZ8xCEkP2qtWTTOKenuke1X8pcT4l0+uFJfK+
 Toh37pdDoPqVVAvzRqNZe3nCtqBJxyHqT9+ZU+bWItenIpk01O9pK4/Rn5Byp7w5IDUq
 a/DvQHE7+qfuLIDrluP581mc+5d3GZvvB7Jsg2doE4hrRWuVNcH6ux6q/j2Uiy2vqMt2 IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ym31uq7d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:47:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cIu6096713;
        Thu, 12 Mar 2020 03:45:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yp8qyavkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:45 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3jiGE017086;
        Thu, 12 Mar 2020 03:45:44 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:44 -0700
Subject: [PATCH 2/7] xfs: introduce fake roots for inode-rooted btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 11 Mar 2020 20:45:43 -0700
Message-ID: <158398474334.1308059.3288197233526483322.stgit@magnolia>
In-Reply-To: <158398473036.1308059.18353233923283406961.stgit@magnolia>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=3 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
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

Create an in-core fake root for inode-rooted btree types so that callers
can generate a whole new btree using the upcoming btree bulk load
function without making the new tree accessible from the rest of the
filesystem.  It is up to the individual btree type to provide a function
to create a staged cursor (presumably with the appropriate callouts to
update the fakeroot) and then commit the staged root back into the
filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |  111 +++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_btree.h |   31 +++++++++++++
 fs/xfs/xfs_trace.h        |   33 +++++++++++++
 3 files changed, 171 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 085bc070e804..4e1d4f184d4b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -644,6 +644,17 @@ xfs_btree_ptr_addr(
 		((char *)block + xfs_btree_ptr_offset(cur, n, level));
 }
 
+struct xfs_ifork *
+xfs_btree_ifork_ptr(
+	struct xfs_btree_cur	*cur)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+
+	if (cur->bc_flags & XFS_BTREE_STAGING)
+		return cur->bc_ino.ifake->if_fork;
+	return XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
+}
+
 /*
  * Get the root block which is stored in the inode.
  *
@@ -654,9 +665,8 @@ STATIC struct xfs_btree_block *
 xfs_btree_get_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
-	ifp = XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
@@ -4985,8 +4995,17 @@ xfs_btree_fakeroot_init_ptr_from_cur(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	afake = cur->bc_ag.afake;
-	ptr->s = cpu_to_be32(afake->af_root);
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		/*
+		 * The root block lives in the inode core, so we zero the
+		 * pointer (like the bmbt code does) to make it obvious if
+		 * anyone ever tries to use this pointer.
+		 */
+		ptr->l = cpu_to_be64(0);
+	} else {
+		afake = cur->bc_ag.afake;
+		ptr->s = cpu_to_be32(afake->af_root);
+	}
 }
 
 /*
@@ -5076,3 +5095,87 @@ xfs_btree_commit_afakeroot(
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
 	cur->bc_tp = tp;
 }
+
+/*
+ * Bulk Loading for Inode-Rooted Btrees
+ * ====================================
+ *
+ * For a btree rooted in an inode fork, pass a xbtree_ifakeroot structure to
+ * the staging cursor.  This structure should be initialized as follows:
+ *
+ * - if_fork_size field should be set to the number of bytes available to the
+ *   fork in the inode.
+ *
+ * - if_fork should point to a freshly allocated struct xfs_ifork.
+ *
+ * - if_format should be set to the appropriate fork type (e.g.
+ *   XFS_DINODE_FMT_BTREE).
+ *
+ * All other fields must be zero.
+ *
+ * The _stage_cursor() function for a specific btree type should call
+ * xfs_btree_stage_ifakeroot to set up the in-memory cursor as a staging
+ * cursor.  The corresponding _commit_staged_btree() function should log the
+ * new root and call xfs_btree_commit_ifakeroot() to transform the staging
+ * cursor into a regular btree cursor.
+ */
+
+/*
+ * Initialize an inode-rooted btree cursor with the given inode btree fake
+ * root.  The btree cursor's bc_ops will be overridden as needed to make the
+ * staging functionality work.  If new_ops is not NULL, these new ops will be
+ * passed out to the caller for further overriding.
+ */
+void
+xfs_btree_stage_ifakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xbtree_ifakeroot		*ifake,
+	struct xfs_btree_ops		**new_ops)
+{
+	struct xfs_btree_ops		*nops;
+
+	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+	ASSERT(cur->bc_tp == NULL);
+
+	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
+	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
+	nops->free_block = xfs_btree_fakeroot_free_block;
+	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
+	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
+
+	cur->bc_ino.ifake = ifake;
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ops = nops;
+	cur->bc_flags |= XFS_BTREE_STAGING;
+
+	if (new_ops)
+		*new_ops = nops;
+}
+
+/*
+ * Transform an inode-rooted staging btree cursor back into a regular cursor by
+ * substituting a real btree root for the fake one and restoring normal btree
+ * cursor ops.  The caller must log the btree root change prior to calling
+ * this.
+ */
+void
+xfs_btree_commit_ifakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xfs_trans		*tp,
+	int				whichfork,
+	const struct xfs_btree_ops	*ops)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(cur->bc_tp == NULL);
+
+	trace_xfs_btree_commit_ifakeroot(cur);
+
+	kmem_free((void *)cur->bc_ops);
+	cur->bc_ino.ifake = NULL;
+	cur->bc_ino.whichfork = whichfork;
+	cur->bc_ops = ops;
+	cur->bc_flags &= ~XFS_BTREE_STAGING;
+	cur->bc_tp = tp;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index aa4a7bd40023..047067f52063 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -10,6 +10,7 @@ struct xfs_buf;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_ifork;
 
 extern kmem_zone_t	*xfs_btree_cur_zone;
 
@@ -198,6 +199,7 @@ struct xfs_btree_cur_ag {
 /* Btree-in-inode cursor information */
 struct xfs_btree_cur_ino {
 	struct xfs_inode	*ip;
+	struct xbtree_ifakeroot	*ifake;		/* fake inode fork */
 	int			allocated;
 	short			forksize;
 	char			whichfork;
@@ -506,6 +508,7 @@ union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
+struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 
 /* Does this cursor point to the last block in the given level? */
 static inline bool
@@ -543,4 +546,32 @@ void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
 void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
 		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
 
+/* Fake root for an inode-rooted btree. */
+struct xbtree_ifakeroot {
+	/* Fake inode fork. */
+	struct xfs_ifork	*if_fork;
+
+	/* Number of blocks used by the btree. */
+	int64_t			if_blocks;
+
+	/* Height of the new btree. */
+	unsigned int		if_levels;
+
+	/* Number of bytes available for this fork in the inode. */
+	unsigned int		if_fork_size;
+
+	/* Fork format. */
+	unsigned int		if_format;
+
+	/* Number of records. */
+	unsigned int		if_extents;
+};
+
+/* Cursor interactions with with fake roots for inode-rooted btrees. */
+void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
+		struct xbtree_ifakeroot *ifake,
+		struct xfs_btree_ops **new_ops);
+void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
+		int whichfork, const struct xfs_btree_ops *ops);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d8c229492973..05db0398f040 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3633,6 +3633,39 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 		  __entry->agbno)
 )
 
+TRACE_EVENT(xfs_btree_commit_ifakeroot,
+	TP_PROTO(struct xfs_btree_cur *cur),
+	TP_ARGS(cur),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(unsigned int, levels)
+		__field(unsigned int, blocks)
+		__field(int, whichfork)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->btnum = cur->bc_btnum;
+		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
+					cur->bc_ino.ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
+					cur->bc_ino.ip->i_ino);
+		__entry->levels = cur->bc_ino.ifake->if_levels;
+		__entry->blocks = cur->bc_ino.ifake->if_blocks;
+		__entry->whichfork = cur->bc_ino.whichfork;
+	),
+	TP_printk("dev %d:%d btree %s ag %u agino %u whichfork %s levels %u blocks %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __entry->levels,
+		  __entry->blocks)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

