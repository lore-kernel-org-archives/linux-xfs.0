Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D06ECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FFC92190F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PKXGI7YN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfJIQsT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:48:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJIQsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:48:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjbED003507
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RsRT7CVvGZUQW/Me8foFlg0WNtpE/NX209Ez1r0QIpw=;
 b=PKXGI7YNoomwFGQVcJm2JjdMoNj8EUxhtgFcw2zCsOdIHKsew4fxSuus+mJ/XIsrfQaS
 ycIrW+KDDBXnA0Ka7nhFsu1303C6H9kyERPTAfn7uKYNJcGKOQ05He1hpJJP7qfpy54a
 vHSHFX/NNcsBrTFIGKQMOEWmb1+XyhmaRym9z3Ju/sfgIJsV3LTQ4RxFC8xp07N4bRWq
 7fOg7GarhYn7edADDFTMLUVbqMLSzEzU+laXhYAo++DZP2MSM50kIqTCueZ5Z9xVxQgb
 stQUCqZieo7gsBQJGT2nZLr6fHJ1witzy94+eAVYrO4j69iUfw5fynLf1esolGuYaryb qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4qnyne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiaLp174461
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vhhsmwxn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:17 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99GmDDL023298
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:48:13 -0700
Subject: [PATCH 2/4] xfs: introduce fake roots for inode-rooted btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:48:12 -0700
Message-ID: <157063969204.2912204.9712948486051523329.stgit@magnolia>
In-Reply-To: <157063967800.2912204.4012307770844087647.stgit@magnolia>
References: <157063967800.2912204.4012307770844087647.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
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
 fs/xfs/libxfs/xfs_btree.c |   63 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_btree.h |   53 +++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_trace.h        |   33 ++++++++++++++++++++++++
 3 files changed, 138 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7b18f0fa5e99..4b06d5d86834 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -646,6 +646,17 @@ xfs_btree_ptr_addr(
 		((char *)block + xfs_btree_ptr_offset(cur, n, level));
 }
 
+struct xfs_ifork *
+xfs_btree_ifork_ptr(
+	struct xfs_btree_cur	*cur)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+
+	if (cur->bc_flags & XFS_BTREE_STAGING)
+		return cur->bc_private.b.ifake->if_fork;
+	return XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+}
+
 /*
  * Get the root block which is stored in the inode.
  *
@@ -656,9 +667,8 @@ STATIC struct xfs_btree_block *
 xfs_btree_get_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
-	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
@@ -5045,3 +5055,52 @@ xfs_btree_commit_afakeroot(
 	cur->bc_ops = ops;
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
 }
+/*
+ * Initialize an inode-rooted btree cursor with the given fake root @ifake, and
+ * prepare @ops for overriding by duplicating them into @new_ops.  The caller
+ * can replace pointers in @new_ops as necessary once this call completes.
+ * Note that staging cursors can only be used for bulk loading.
+ */
+void
+xfs_btree_stage_ifakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xbtree_ifakeroot		*ifake,
+	const struct xfs_btree_ops	*ops,
+	struct xfs_btree_ops		**new_ops)
+{
+	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+
+	*new_ops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	memcpy(*new_ops, ops, sizeof(struct xfs_btree_ops));
+	(*new_ops)->alloc_block = xfs_btree_fakeroot_alloc_block;
+	(*new_ops)->free_block = xfs_btree_fakeroot_free_block;
+	(*new_ops)->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
+	(*new_ops)->dup_cursor = xfs_btree_fakeroot_dup_cursor;
+
+	cur->bc_private.b.ifake = ifake;
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ops = *new_ops;
+	cur->bc_flags |= XFS_BTREE_STAGING;
+}
+
+/*
+ * Transform an inode-rooted staging btree cursor back into a regular btree
+ * cursor.  Caller is responsible for logging changes before this.
+ */
+void
+xfs_btree_commit_ifakeroot(
+	struct xfs_btree_cur		*cur,
+	int				whichfork,
+	const struct xfs_btree_ops	*ops)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	trace_xfs_btree_commit_ifakeroot(cur);
+
+	kmem_free((void *)cur->bc_ops);
+	cur->bc_private.b.ifake = NULL;
+	cur->bc_private.b.whichfork = whichfork;
+	cur->bc_ops = ops;
+	cur->bc_flags &= ~XFS_BTREE_STAGING;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 453de8a49e96..a17becb72ab8 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -10,6 +10,7 @@ struct xfs_buf;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_ifork;
 
 extern kmem_zone_t	*xfs_btree_cur_zone;
 
@@ -195,6 +196,18 @@ struct xfs_btree_priv_ag {			/* needed for BNO, CNT, INO */
 	union xfs_btree_cur_private	priv;
 };
 
+/* Private information for an inode-rooted btree. */
+struct xfs_btree_priv_inode {			/* needed for BMAP */
+	struct xfs_inode	*ip;		/* pointer to our inode */
+	struct xbtree_ifakeroot	*ifake;		/* fake inode fork */
+	int			allocated;	/* count of alloced */
+	short			forksize;	/* fork's inode space */
+	char			whichfork;	/* data or attr fork */
+	char			flags;		/* flags */
+#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)	/* was delayed */
+#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)	/* for ext swap */
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -217,15 +230,7 @@ typedef struct xfs_btree_cur
 	int		bc_statoff;	/* offset of btre stats array */
 	union {
 		struct xfs_btree_priv_ag a;
-		struct {			/* needed for BMAP */
-			struct xfs_inode *ip;	/* pointer to our inode */
-			int		allocated;	/* count of alloced */
-			short		forksize;	/* fork's inode space */
-			char		whichfork;	/* data or attr fork */
-			char		flags;		/* flags */
-#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
-#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
-		} b;
+		struct xfs_btree_priv_inode b;
 	}		bc_private;	/* per-btree type data */
 } xfs_btree_cur_t;
 
@@ -525,6 +530,7 @@ union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
+struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 
 /* Fake root for an AG-rooted btree. */
 struct xbtree_afakeroot {
@@ -547,4 +553,33 @@ void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur,
 		struct xfs_buf *agbp,
 		const struct xfs_btree_ops *ops);
 
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
+		const struct xfs_btree_ops *ops,
+		struct xfs_btree_ops **new_ops);
+void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, int whichfork,
+		const struct xfs_btree_ops *ops);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e04ed5324696..a78055521fcd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3637,6 +3637,39 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
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
+					cur->bc_private.b.ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
+					cur->bc_private.b.ip->i_ino);
+		__entry->levels = cur->bc_private.b.ifake->if_levels;
+		__entry->blocks = cur->bc_private.b.ifake->if_blocks;
+		__entry->whichfork = cur->bc_private.b.whichfork;
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

