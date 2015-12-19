Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B490B80D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:02:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98513304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:59 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JDi4DTliopA8v1rZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:57 -0800 (PST)
Subject: [PATCH 58/76] xfs: support removing extents from CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:02:54 -0800
Message-ID: <20151219090254.12713.82017.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Create a helper method to remove extents from the CoW fork without
any of the side effects (rmapbt/bmbt updates) of the regular extent
deletion routine.  We'll eventually use this to clear out the CoW fork
during ioend processing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  173 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    2 +
 2 files changed, 175 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de0ac37..21548b9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5272,6 +5272,179 @@ done:
 }
 
 /*
+ * xfs_bunmapi_cow() -- Remove the relevant parts of the CoW fork.
+ *			See xfs_bmap_del_extent.
+ * @ip: XFS inode.
+ * @idx: Extent number to delete.
+ * @del: Extent to remove.
+ */
+int
+xfs_bunmapi_cow(
+	xfs_inode_t		*ip,
+	xfs_extnum_t		*idx,
+	xfs_bmbt_irec_t		*del)
+{
+	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
+	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
+	xfs_fsblock_t		del_endblock = 0;/* first block past del */
+	xfs_fileoff_t		del_endoff;	/* first offset past del */
+	int			delay;	/* current block is delayed allocated */
+	xfs_bmbt_rec_host_t	*ep;	/* current extent entry pointer */
+	int			error;	/* error return value */
+	xfs_bmbt_irec_t		got;	/* current extent entry */
+	xfs_fileoff_t		got_endoff;	/* first offset past got */
+	xfs_ifork_t		*ifp;	/* inode fork pointer */
+	xfs_mount_t		*mp;	/* mount structure */
+	xfs_filblks_t		nblks;	/* quota/sb block count */
+	xfs_bmbt_irec_t		new;	/* new record to be inserted */
+	/* REFERENCED */
+	uint			qfield;	/* quota field to update */
+	xfs_filblks_t		temp;	/* for indirect length calculations */
+	xfs_filblks_t		temp2;	/* for indirect length calculations */
+	int			state = BMAP_COWFORK;
+
+	mp = ip->i_mount;
+	XFS_STATS_INC(mp, xs_del_exlist);
+
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	ASSERT((*idx >= 0) && (*idx < ifp->if_bytes /
+		(uint)sizeof(xfs_bmbt_rec_t)));
+	ASSERT(del->br_blockcount > 0);
+	ep = xfs_iext_get_ext(ifp, *idx);
+	xfs_bmbt_get_all(ep, &got);
+	ASSERT(got.br_startoff <= del->br_startoff);
+	del_endoff = del->br_startoff + del->br_blockcount;
+	got_endoff = got.br_startoff + got.br_blockcount;
+	ASSERT(got_endoff >= del_endoff);
+	delay = isnullstartblock(got.br_startblock);
+	ASSERT(isnullstartblock(del->br_startblock) == delay);
+	qfield = 0;
+	error = 0;
+	/*
+	 * If deleting a real allocation, must free up the disk space.
+	 */
+	if (!delay) {
+		nblks = del->br_blockcount;
+		qfield = XFS_TRANS_DQ_BCOUNT;
+		/*
+		 * Set up del_endblock and cur for later.
+		 */
+		del_endblock = del->br_startblock + del->br_blockcount;
+		da_old = da_new = 0;
+	} else {
+		da_old = startblockval(got.br_startblock);
+		da_new = 0;
+		nblks = 0;
+	}
+	qfield = qfield;
+	nblks = nblks;
+
+	/*
+	 * Set flag value to use in switch statement.
+	 * Left-contig is 2, right-contig is 1.
+	 */
+	switch (((got.br_startoff == del->br_startoff) << 1) |
+		(got_endoff == del_endoff)) {
+	case 3:
+		/*
+		 * Matches the whole extent.  Delete the entry.
+		 */
+		xfs_iext_remove(ip, *idx, 1, BMAP_COWFORK);
+		--*idx;
+		break;
+
+	case 2:
+		/*
+		 * Deleting the first part of the extent.
+		 */
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_startoff(ep, del_endoff);
+		temp = got.br_blockcount - del->br_blockcount;
+		xfs_bmbt_set_blockcount(ep, temp);
+		if (delay) {
+			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+				da_old);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+			da_new = temp;
+			break;
+		}
+		xfs_bmbt_set_startblock(ep, del_endblock);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		break;
+
+	case 1:
+		/*
+		 * Deleting the last part of the extent.
+		 */
+		temp = got.br_blockcount - del->br_blockcount;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(ep, temp);
+		if (delay) {
+			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+				da_old);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+			da_new = temp;
+			break;
+		}
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		break;
+
+	case 0:
+		/*
+		 * Deleting the middle of the extent.
+		 */
+		temp = del->br_startoff - got.br_startoff;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(ep, temp);
+		new.br_startoff = del_endoff;
+		temp2 = got_endoff - del_endoff;
+		new.br_blockcount = temp2;
+		new.br_state = got.br_state;
+		if (!delay) {
+			new.br_startblock = del_endblock;
+		} else {
+			temp = xfs_bmap_worst_indlen(ip, temp);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			temp2 = xfs_bmap_worst_indlen(ip, temp2);
+			new.br_startblock = nullstartblock((int)temp2);
+			da_new = temp + temp2;
+			while (da_new > da_old) {
+				if (temp) {
+					temp--;
+					da_new--;
+					xfs_bmbt_set_startblock(ep,
+						nullstartblock((int)temp));
+				}
+				if (da_new == da_old)
+					break;
+				if (temp2) {
+					temp2--;
+					da_new--;
+					new.br_startblock =
+						nullstartblock((int)temp2);
+				}
+			}
+		}
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
+		++*idx;
+		break;
+	}
+
+	/*
+	 * Account for change in delayed indirect blocks.
+	 * Nothing to do for disk quota accounting here.
+	 */
+	ASSERT(da_old >= da_new);
+	if (da_old > da_new)
+		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
+
+	return error;
+}
+
+/*
  * Unmap (remove) blocks from a file.
  * If nexts is nonzero then the number of extents to remove is limited to
  * that value.  If not all extents in the block range can be removed then
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index fb68ac4..bfa0294 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -253,6 +253,8 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
 		struct xfs_bmbt_irec *mval, int *nmap,
 		struct xfs_bmap_free *flist);
+int	xfs_bunmapi_cow(struct xfs_inode *ip, xfs_extnum_t *idx,
+		struct xfs_bmbt_irec *del);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
