Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E29D8180
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:49:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 217B6304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id A12p0g0krjxufLgO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:45 -0700 (PDT)
Subject: [PATCH 30/71] xfs: support removing extents from CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:49:41 -0700
Message-ID: <147216898131.4420.12375167822640453648.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create a helper method to remove extents from the CoW fork without
any of the side effects (rmapbt/bmbt updates) of the regular extent
deletion routine.  We'll eventually use this to clear out the CoW fork
during ioend processing.

v2: Use bmapi_read to iterate and trim the CoW extents instead of
reading them raw via the iext code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h |    1 
 2 files changed, 177 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6503241..cb30099 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4975,6 +4975,7 @@ xfs_bmap_del_extent(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_iext_remove(ip, *idx, 1,
 				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
 		--*idx;
@@ -5192,6 +5193,181 @@ done:
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
+	int			eof;
+	xfs_extnum_t		eidx;
+
+	mp = ip->i_mount;
+	XFS_STATS_INC(mp, xs_del_exlist);
+
+	ep = xfs_bmap_search_extents(ip, del->br_startoff, XFS_COW_FORK, &eof,
+			&eidx, &got, &new);
+
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK); ifp = ifp;
+	ASSERT((eidx >= 0) && (eidx < ifp->if_bytes /
+		(uint)sizeof(xfs_bmbt_rec_t)));
+	ASSERT(del->br_blockcount > 0);
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
+		xfs_iext_remove(ip, eidx, 1, BMAP_COWFORK);
+		--eidx;
+		break;
+
+	case 2:
+		/*
+		 * Deleting the first part of the extent.
+		 */
+		trace_xfs_bmap_pre_update(ip, eidx, state, _THIS_IP_);
+		xfs_bmbt_set_startoff(ep, del_endoff);
+		temp = got.br_blockcount - del->br_blockcount;
+		xfs_bmbt_set_blockcount(ep, temp);
+		if (delay) {
+			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+				da_old);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
+			da_new = temp;
+			break;
+		}
+		xfs_bmbt_set_startblock(ep, del_endblock);
+		trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
+		break;
+
+	case 1:
+		/*
+		 * Deleting the last part of the extent.
+		 */
+		temp = got.br_blockcount - del->br_blockcount;
+		trace_xfs_bmap_pre_update(ip, eidx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(ep, temp);
+		if (delay) {
+			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+				da_old);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
+			da_new = temp;
+			break;
+		}
+		trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
+		break;
+
+	case 0:
+		/*
+		 * Deleting the middle of the extent.
+		 */
+		temp = del->br_startoff - got.br_startoff;
+		trace_xfs_bmap_pre_update(ip, eidx, state, _THIS_IP_);
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
+		trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
+		xfs_iext_insert(ip, eidx + 1, 1, &new, state);
+		++eidx;
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index c9f29b3..e60be02 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -224,6 +224,7 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
 		struct xfs_defer_ops *dfops, int *done);
+int	xfs_bunmapi_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *del);
 int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
