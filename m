Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E5BB7F8A
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:39:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C09C1AC003
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:39:33 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FCc36VbDXcyUdXJV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:39:31 -0700 (PDT)
Subject: [PATCH 02/14] libxfs: adjust refcounts in reflink btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:23 -0700
Message-ID: <20150625233923.4992.89446.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Provide a function to adjust the reference counts for a range of
blocks in the reflink btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_reflink_btree.c |  406 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_reflink_btree.h |    4 
 2 files changed, 410 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_reflink_btree.c b/fs/xfs/libxfs/xfs_reflink_btree.c
index 8a0fa5d..380ed72 100644
--- a/fs/xfs/libxfs/xfs_reflink_btree.c
+++ b/fs/xfs/libxfs/xfs_reflink_btree.c
@@ -529,3 +529,409 @@ xfs_reflinkbt_delete(
 error0:
 	return error;
 }
+
+#ifdef REFLINK_DEBUG
+static void
+dump_cur_loc(
+	struct xfs_btree_cur	*cur,
+	const char		*str,
+	int			line)
+{
+	xfs_agblock_t		gbno;
+	xfs_extlen_t		glen;
+	xfs_nlink_t		gnr;
+	int			i;
+
+	xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+	printk(KERN_INFO "%s(%d) cur[%d]:[%u,%u,%u,%d] ", str, line,
+	       cur->bc_ptrs[0], gbno, glen, gnr, i);
+	if (i && cur->bc_ptrs[0]) {
+		cur->bc_ptrs[0]--;
+		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+		printk("left[%d]:[%u,%u,%u,%d] ", cur->bc_ptrs[0],
+		       gbno, glen, gnr, i);
+		cur->bc_ptrs[0]++;
+	}
+
+	if (i && cur->bc_ptrs[0] < xfs_reflinkbt_get_maxrecs(cur, 0)) {
+		cur->bc_ptrs[0]++;
+		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+		printk("right[%d]:[%u,%u,%u,%d] ", cur->bc_ptrs[0],
+		       gbno, glen, gnr, i);
+		cur->bc_ptrs[0]--;
+	}
+	printk("\n");
+}
+#else
+# define dump_cur_loc(c, s, l)
+#endif
+
+/*
+ * Adjust the ref count of a range of AG blocks.
+ */
+int						/* error */
+xfs_reflinkbt_adjust_refcount(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agf structure */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_agblock_t		agbno,		/* start of range */
+	xfs_extlen_t		aglen,		/* length of range */
+	int			adj)		/* how much to change refcnt */
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+	int			i, have;
+	bool			real_crl;	/* cbno/clen is on disk? */
+	xfs_agblock_t		lbno, cbno, rbno;	/* rlextent start */
+	xfs_extlen_t		llen, clen, rlen;	/* rlextent length */
+	xfs_nlink_t		lnr, cnr, rnr;		/* rlextent refcount */
+
+	xfs_agblock_t		bno;		/* ag bno in the loop */
+	xfs_agblock_t		agbend;		/* end agbno of the loop */
+	xfs_extlen_t		len;		/* remaining len to add */
+	xfs_nlink_t		new_cnr;	/* new refcount */
+
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, aglen);
+	ASSERT(adj == -1 || adj == 1);
+
+	/*
+	 * Allocate/initialize a cursor for the by-number freespace btree.
+	 */
+	cur = xfs_reflinkbt_init_cursor(mp, tp, agbp, agno);
+
+	/*
+	 * Split a left rlextent that crosses agbno.
+	 */
+	error = xfs_reflink_lookup_le(cur, agbno, &have);
+	if (error)
+		goto error0;
+	if (have) {
+		error = xfs_reflink_get_rec(cur, &lbno, &llen, &lnr, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr, error0);
+		if (lbno < agbno && lbno + llen > agbno) {
+			dbg_printk("split lext crossing agbno [%u:%u:%u]\n",
+				   lbno, llen, lnr);
+			error = xfs_reflinkbt_update(cur, lbno, agbno - lbno,
+					lnr);
+			if (error)
+				goto error0;
+
+			error = xfs_btree_increment(cur, 0, &i);
+			if (error)
+				goto error0;
+
+			error = xfs_reflinkbt_insert(cur, agbno,
+					llen - (agbno - lbno), lnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		}
+	}
+
+	/*
+	 * Split a right rlextent that crosses agbno.
+	 */
+	agbend = agbno + aglen - 1;
+	error = xfs_reflink_lookup_le(cur, agbend, &have);
+	if (error)
+		goto error0;
+	if (have) {
+		error = xfs_reflink_get_rec(cur, &rbno, &rlen, &rnr, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, rbno, rlen, rnr, error0);
+		if (agbend + 1 != mp->m_sb.sb_agblocks &&
+		    agbend + 1 < rbno + rlen) {
+			dbg_printk("split rext crossing agbend [%u:%u:%u]\n",
+				   rbno, rlen, rnr);
+			error = xfs_reflinkbt_update(cur, agbend + 1,
+					rlen - (agbend - rbno + 1), rnr);
+			if (error)
+				goto error0;
+
+			error = xfs_reflinkbt_insert(cur, rbno,
+					agbend - rbno + 1, rnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		}
+	}
+
+	/*
+	 * Start iterating the range we're adjusting.  rlextent boundaries
+	 * should be at agbno and agbend.
+	 */
+	bno = agbno;
+	len = aglen;
+	while (len > 0) {
+		llen = clen = rlen = 0;
+		real_crl = false;
+		/*
+		 * Look up the current and left rlextents.
+		 */
+		error = xfs_reflink_lookup_le(cur, bno, &have);
+		if (error)
+			goto error0;
+		if (have) {
+			error = xfs_reflink_get_rec(cur, &cbno, &clen, &cnr,
+						    &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, cbno, clen, cnr,
+						      error0);
+			if (cbno != bno) {
+				/*
+				 * bno points to a hole; this is the left rlext.
+				 */
+				ASSERT((unsigned long long)lbno + llen <= bno);
+				lbno = cbno;
+				llen = clen;
+				lnr = cnr;
+
+				cbno = bno;
+				clen = len;
+				cnr = 1;
+			} else {
+				real_crl = true;
+				/*
+				 * Go find the left rlext.
+				 */
+				error = xfs_btree_decrement(cur, 0, &have);
+				if (error)
+					goto error0;
+				if (have) {
+					error = xfs_reflink_get_rec(cur, &lbno,
+							&llen, &lnr, &i);
+					if (error)
+						goto error0;
+					XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i,
+							lbno, llen, lnr,
+							error0);
+					ASSERT((unsigned long long)lbno + llen <= bno);
+				}
+				error = xfs_btree_increment(cur, 0, &have);
+				if (error)
+					goto error0;
+			}
+		} else {
+			/*
+			 * No left extent; just invent our current rlextent.
+			 */
+			cbno = bno;
+			clen = len;
+			cnr = 1;
+		}
+
+		/*
+		 * If the left rlext isn't adjacent, forget about it.
+		 */
+		if (llen > 0 && lbno + llen != bno)
+			llen = 0;
+
+		/*
+		 * Look up the right rlextent.
+		 */
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto error0;
+		if (have) {
+			error = xfs_reflink_get_rec(cur, &rbno, &rlen, &rnr,
+						    &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, rbno, rlen, rnr,
+						      error0);
+			if (agbno + aglen < rbno)
+				rlen = 0;
+			if (!real_crl)
+				clen = min(clen, rbno - cbno);
+			ASSERT((unsigned long long)cbno + clen <= rbno);
+		}
+
+		/*
+		 * Point the cursor to cbno (or where it will be inserted).
+		 */
+		if (real_crl) {
+			error = xfs_btree_decrement(cur, 0, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		}
+		ASSERT(clen > 0);
+		ASSERT(cbno == bno);
+		ASSERT(cbno >= agbno);
+		ASSERT((unsigned long long)cbno + clen <=
+		       (unsigned long long)agbno + aglen);
+		if (real_crl)
+			ASSERT(cnr > 1);
+		else
+			ASSERT(cnr == 1);
+		new_cnr = cnr + adj;
+
+#ifdef REFLINK_DEBUG
+		{
+		xfs_agblock_t gbno;
+		xfs_extlen_t glen;
+		xfs_nlink_t gnr;
+		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+		printk(KERN_ERR "%s: insert ag=%u [%u:%u:%d] ", __func__,
+		       agno, agbno, agbend, adj);
+		if (llen)
+			printk("l:[%u,%u,%u] ", lbno, llen, lnr);
+		printk("[%u,%u,%u,%d] ", cbno, clen, cnr, real_crl);
+		if (rlen)
+			printk("r:[%u,%u,%u] ", rbno, rlen, rnr);
+		printk("\n");
+		dump_cur_loc(cur, "cur", __LINE__);
+		}
+#endif
+		/*
+		 * Nothing to do when unmapping a range of blocks with
+		 * a single owner.
+		 */
+		if (new_cnr == 0) {
+			dbg_printk("single-owner blocks; ignoring");
+			goto advloop;
+		}
+
+		/*
+		 * These blocks have hit MAXRLCOUNT; keep it that way.
+		 */
+		if (cnr == MAXRLCOUNT) {
+			dbg_printk("hit MAXRLCOUNT; moving on");
+			goto advloop;
+		}
+
+		/*
+		 * Try to merge with left and right rlexts outside range.
+		 */
+		if (llen > 0 && rlen > 0 &&
+		    lbno + llen == agbno &&
+		    rbno == agbend + 1 &&
+		    lbno + llen + clen == rbno &&
+		    (unsigned long long)llen + clen + rlen < MAXRLEXTLEN &&
+		    lnr == rnr &&
+		    lnr == new_cnr) {
+			dbg_printk("merge l/c/rext\n");
+			error = xfs_reflinkbt_delete(cur, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			if (real_crl) {
+				error = xfs_reflinkbt_delete(cur, &i);
+				if (error)
+					goto error0;
+				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			}
+
+			error = xfs_btree_decrement(cur, 0, &have);
+			if (error)
+				goto error0;
+			error = xfs_reflinkbt_update(cur, lbno,
+					llen + clen + rlen, lnr);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, have == 1, error0);
+			break;
+		}
+
+		/*
+		 * Try to merge with left rlext outside the range.
+		 */
+		if (llen > 0 &&
+		    lbno + llen == agbno &&
+		    lnr == new_cnr &&
+		    (unsigned long long)llen + clen < MAXRLEXTLEN) {
+			dbg_printk("merge l/cext\n");
+			if (real_crl) {
+				error = xfs_reflinkbt_delete(cur, &i);
+				if (error)
+					goto error0;
+				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			}
+
+			error = xfs_btree_decrement(cur, 0, &have);
+			if (error)
+				goto error0;
+			error = xfs_reflinkbt_update(cur, lbno,
+					llen + clen, lnr);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, have == 1, error0);
+			goto advloop;
+		}
+
+		/*
+		 * Try to merge with right rlext outside the range.
+		 */
+		if (rlen > 0 &&
+		    rbno == agbend + 1 &&
+		    rnr == new_cnr &&
+		    cbno + clen == rbno &&
+		    (unsigned long long)clen + rlen < MAXRLEXTLEN) {
+			dbg_printk("merge c/rext\n");
+			if (real_crl) {
+				error = xfs_reflinkbt_delete(cur, &i);
+				if (error)
+					goto error0;
+				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			}
+
+			error = xfs_reflinkbt_update(cur, cbno,
+					clen + rlen, rnr);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, have == 1, error0);
+			break;
+		}
+
+		/*
+		 * rlext is no longer reflinked; remove it from tree.
+		 */
+		if (new_cnr == 1 && adj < 0) {
+			dbg_printk("remove cext\n");
+			ASSERT(real_crl == true);
+			error = xfs_reflinkbt_delete(cur, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			goto advloop;
+		}
+
+		/*
+		 * rlext needs to be added to the tree.
+		 */
+		if (new_cnr == 2 && adj > 0) {
+			dbg_printk("insert cext\n");
+			error = xfs_reflinkbt_insert(cur, cbno, clen,
+					new_cnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			goto advloop;
+		}
+
+		/*
+		 * Update rlext.
+		 */
+		dbg_printk("update cext\n");
+		ASSERT(new_cnr >= 2);
+		error = xfs_reflinkbt_update(cur, cbno, clen, new_cnr);
+		if (error)
+			goto error0;
+
+advloop:
+		bno += clen;
+		len -= clen;
+	}
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_reflink_btree.h b/fs/xfs/libxfs/xfs_reflink_btree.h
index a27588a..d0785ff 100644
--- a/fs/xfs/libxfs/xfs_reflink_btree.h
+++ b/fs/xfs/libxfs/xfs_reflink_btree.h
@@ -67,4 +67,8 @@ extern int xfs_reflink_lookup_ge(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 extern int xfs_reflink_get_rec(struct xfs_btree_cur *cur, xfs_agblock_t *bno,
 		xfs_extlen_t *len, xfs_nlink_t *nlink, int *stat);
 
+extern int xfs_reflinkbt_adjust_refcount(struct xfs_mount *, struct xfs_trans *,
+		struct xfs_buf *, xfs_agnumber_t, xfs_agblock_t, xfs_extlen_t,
+		int);
+
 #endif	/* __XFS_REFLINK_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
