Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35649 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdG0Wmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:42:32 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMgVkP007112
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMgV17011204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:31 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMgUgv017553
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:30 GMT
Subject: [PATCH 08/26] xfs: scrub btree keys and records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:42:29 -0700
Message-ID: <150119534921.15159.6416391144951327158.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add to the btree scrubber the ability to check that the keys and
records are in the right order and actually call out to our record
iterator to do actual checking of the records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h |   44 +++++++++++++++++++
 2 files changed, 159 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 9a9a020..9470575 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -99,6 +99,104 @@ xfs_scrub_btree_check_ok(
 	return fs_ok;
 }
 
+/*
+ * Make sure this record is in order and doesn't stray outside of the parent
+ * keys.
+ */
+STATIC int
+xfs_scrub_btree_rec(
+	struct xfs_scrub_btree	*bs)
+{
+	struct xfs_btree_cur	*cur = bs->cur;
+	union xfs_btree_rec	*rec;
+	union xfs_btree_key	key;
+	union xfs_btree_key	hkey;
+	union xfs_btree_key	*keyp;
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*keyblock;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, 0, &bp);
+	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+
+	trace_xfs_scrub_btree_rec(bs->sc, cur, 0);
+
+	/* If this isn't the first record, are they in order? */
+	xfs_scrub_btree_check_ok(bs->sc, cur, 0, bs->firstrec ||
+			cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec));
+	bs->firstrec = false;
+	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
+
+	if (cur->bc_nlevels == 1)
+		return 0;
+
+	/* Is this at least as large as the parent low key? */
+	cur->bc_ops->init_key_from_rec(&key, rec);
+	keyblock = xfs_btree_get_block(cur, 1, &bp);
+	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
+	xfs_scrub_btree_check_ok(bs->sc, cur, 1,
+			cur->bc_ops->diff_two_keys(cur, &key, keyp) >= 0);
+
+	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+		return 0;
+
+	/* Is this no larger than the parent high key? */
+	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
+	xfs_scrub_btree_check_ok(bs->sc, cur, 1,
+			cur->bc_ops->diff_two_keys(cur, keyp, &hkey) >= 0);
+
+	return 0;
+}
+
+/*
+ * Make sure this key is in order and doesn't stray outside of the parent
+ * keys.
+ */
+STATIC int
+xfs_scrub_btree_key(
+	struct xfs_scrub_btree	*bs,
+	int			level)
+{
+	struct xfs_btree_cur	*cur = bs->cur;
+	union xfs_btree_key	*key;
+	union xfs_btree_key	*keyp;
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*keyblock;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, level, &bp);
+	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
+
+	trace_xfs_scrub_btree_key(bs->sc, cur, level);
+
+	/* If this isn't the first key, are they in order? */
+	xfs_scrub_btree_check_ok(bs->sc, cur, level, bs->firstkey[level] ||
+			cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key));
+	bs->firstkey[level] = false;
+	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
+
+	if (level + 1 >= cur->bc_nlevels)
+		return 0;
+
+	/* Is this at least as large as the parent low key? */
+	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
+	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+	xfs_scrub_btree_check_ok(bs->sc, cur, level,
+			cur->bc_ops->diff_two_keys(cur, key, keyp) >= 0);
+
+	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+		return 0;
+
+	/* Is this no larger than the parent high key? */
+	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+	xfs_scrub_btree_check_ok(bs->sc, cur, level,
+			cur->bc_ops->diff_two_keys(cur, keyp, key) >= 0);
+
+	return 0;
+}
+
 /* Check a btree pointer. */
 static int
 xfs_scrub_btree_ptr(
@@ -265,6 +363,7 @@ xfs_scrub_btree(
 	struct xfs_scrub_btree		bs = {0};
 	union xfs_btree_ptr		ptr;
 	union xfs_btree_ptr		*pp;
+	union xfs_btree_rec		*recp;
 	struct xfs_btree_block		*block;
 	int				level;
 	struct xfs_buf			*bp;
@@ -317,6 +416,17 @@ xfs_scrub_btree(
 				continue;
 			}
 
+			/* Records in order for scrub? */
+			error = xfs_scrub_btree_rec(&bs);
+			if (error)
+				goto out;
+
+			/* Call out to the record checker. */
+			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+			error = bs.scrub_rec(&bs, recp);
+			if (error < 0 ||
+			    error == XFS_BTREE_QUERY_RANGE_ABORT)
+				break;
 			if (xfs_scrub_should_terminate(&error))
 				break;
 
@@ -332,6 +442,11 @@ xfs_scrub_btree(
 			continue;
 		}
 
+		/* Keys in order for scrub? */
+		error = xfs_scrub_btree_key(&bs, level);
+		if (error)
+			goto out;
+
 		/* Drill another level deeper. */
 		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
 		error = xfs_scrub_btree_ptr(&bs, level, pp);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e857c66..f16431a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -277,6 +277,50 @@ TRACE_EVENT(xfs_scrub_incomplete,
 	{ XFS_BTNUM_FINO,	"finobt" }, \
 	{ XFS_BTNUM_REFC,	"refcountbt" }
 
+DECLARE_EVENT_CLASS(xfs_scrub_sbtree_class,
+	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+		 int level),
+	TP_ARGS(sc, cur, level),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, type)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, level)
+		__field(int, nlevels)
+		__field(int, ptr)
+	),
+	TP_fast_assign(
+		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->btnum = cur->bc_btnum;
+		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
+		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+		__entry->level = level;
+		__entry->nlevels = cur->bc_nlevels;
+		__entry->ptr = cur->bc_ptrs[level];
+	),
+	TP_printk("dev %d:%d type '%s' btnum '%s' agno %u agbno %u level %d nlevels %d ptr %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_DESC),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_DESC),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->level,
+		  __entry->nlevels,
+		  __entry->ptr)
+)
+#define DEFINE_SCRUB_SBTREE_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_sbtree_class, name, \
+	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur, \
+		 int level), \
+	TP_ARGS(sc, cur, level))
+
+DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_rec);
+DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_key);
+
 TRACE_EVENT(xfs_scrub_btree_op_error,
 	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
 		 int level, int error, void *ret_ip),

