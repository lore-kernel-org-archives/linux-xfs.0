Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52C5129E06
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41F03304039
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:26:54 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id s2RhUKFhoVp7vCbI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:53 -0700 (PDT)
Subject: [PATCH 11/15] xfs_reflink: check the existing reflink btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:26:49 -0700
Message-ID: <20150630032649.572.32419.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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

Spot-check the reflink btree for obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |  181 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 181 insertions(+)


diff --git a/repair/scan.c b/repair/scan.c
index afb57f3..1661753 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1018,6 +1018,174 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 	}
 }
 
+static void
+scan_rlbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	int			suspect,
+	int			isroot,
+	__uint32_t		magic,
+	void			*priv)
+{
+	struct aghdr_cnts	*agcnts = priv;
+	const char		*name = "rl";
+	int			i;
+	xfs_reflink_ptr_t	*pp;
+	struct xfs_reflink_rec	*rp;
+	int			hdr_errors = 0;
+	int			numrecs;
+	int			state;
+	xfs_agblock_t		lastblock = 0;
+
+	if (magic != XFS_RLBT_CRC_MAGIC) {
+		name = "(unknown)";
+		assert(0);
+	}
+
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		do_warn(_("bad magic # %#x in bt%s block %d/%d\n"),
+			be32_to_cpu(block->bb_magic), name, agno, bno);
+		hdr_errors++;
+		if (suspect)
+			return;
+	}
+
+	/*
+	 * All reflink btree blocks except the roots are freed for a
+	 * fully empty filesystem, thus they are counted towards the
+	 * free data block counter.
+	 */
+	if (!isroot) {
+		agcnts->agfbtreeblks++;
+		agcnts->fdblocks++;
+	}
+
+	if (be16_to_cpu(block->bb_level) != level) {
+		do_warn(_("expected level %d got %d in bt%s block %d/%d\n"),
+			level, be16_to_cpu(block->bb_level), name, agno, bno);
+		hdr_errors++;
+		if (suspect)
+			return;
+	}
+
+	/* check for btree blocks multiply claimed */
+	state = get_bmap(agno, bno);
+	if (!(state == XR_E_UNKNOWN || state == XR_E_FS_MAP1))  {
+		set_bmap(agno, bno, XR_E_MULT);
+		do_warn(
+_("%s reflink btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
+				name, state, agno, bno, suspect);
+		return;
+	}
+	set_bmap(agno, bno, XR_E_FS_MAP);
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (level == 0) {
+		if (numrecs > mp->m_rlbt_mxr[0])  {
+			numrecs = mp->m_rlbt_mxr[0];
+			hdr_errors++;
+		}
+		if (isroot == 0 && numrecs < mp->m_rlbt_mnr[0])  {
+			numrecs = mp->m_rlbt_mnr[0];
+			hdr_errors++;
+		}
+
+		if (hdr_errors) {
+			do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs),
+				mp->m_rlbt_mnr[0], mp->m_rlbt_mxr[0],
+				name, agno, bno);
+			suspect++;
+		}
+
+		rp = XFS_REFLINK_REC_ADDR(block, 1);
+		for (i = 0; i < numrecs; i++) {
+			xfs_agblock_t		b, end;
+			xfs_extlen_t		len;
+			xfs_nlink_t		nr;
+
+			b = be32_to_cpu(rp[i].rr_startblock);
+			len = be32_to_cpu(rp[i].rr_blockcount);
+			nr = be32_to_cpu(rp[i].rr_nlinks);
+			end = b + len;
+
+			if (!verify_agbno(mp, agno, b)) {
+				do_warn(
+	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
+					b, i, name, agno, bno);
+				continue;
+			}
+			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
+				do_warn(
+	_("invalid length %u in record %u of %s btree block %u/%u\n"),
+					len, i, name, agno, bno);
+				continue;
+			}
+
+			if (nr < 2 || nr > MAXRLCOUNT) {
+				do_warn(
+	_("invalid reference count %u in record %u of %s btree block %u/%u\n"),
+					nr, i, name, agno, bno);
+				continue;
+			}
+
+			if (b && b <= lastblock) {
+				do_warn(_(
+	"out-of-order %s btree record %d (%u %u) block %u/%u\n"),
+					name, i, b, len, agno, bno);
+			} else {
+				lastblock = b;
+			}
+
+			/* XXX: probably want to mark the reflinked areas? */
+		}
+		return;
+	}
+
+	/*
+	 * interior record
+	 */
+	pp = XFS_REFLINK_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
+
+	if (numrecs > mp->m_rlbt_mxr[1])  {
+		numrecs = mp->m_rlbt_mxr[1];
+		hdr_errors++;
+	}
+	if (isroot == 0 && numrecs < mp->m_rlbt_mnr[1])  {
+		numrecs = mp->m_rlbt_mnr[1];
+		hdr_errors++;
+	}
+
+	/*
+	 * don't pass bogus tree flag down further if this block
+	 * looked ok.  bail out if two levels in a row look bad.
+	 */
+	if (hdr_errors)  {
+		do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs),
+			mp->m_rlbt_mnr[1], mp->m_rlbt_mxr[1],
+			name, agno, bno);
+		if (suspect)
+			return;
+		suspect++;
+	} else if (suspect) {
+		suspect = 0;
+	}
+
+	for (i = 0; i < numrecs; i++)  {
+		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+
+		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			scan_sbtree(bno, level, agno, suspect, scan_rlbt, 0,
+				    magic, priv, &xfs_reflinkbt_buf_ops);
+		}
+	}
+}
+
 static int
 scan_single_ino_chunk(
 	xfs_agnumber_t		agno,
@@ -1803,6 +1971,19 @@ validate_agf(
 		}
 	}
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		bno = be32_to_cpu(agf->agf_reflink_root);
+		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			scan_sbtree(bno,
+				    be32_to_cpu(agf->agf_reflink_level),
+				    agno, 0, scan_rlbt, 1, XFS_RLBT_CRC_MAGIC,
+				    agcnts, &xfs_reflinkbt_buf_ops);
+		} else  {
+			do_warn(_("bad agbno %u for rlbt root, agno %d\n"),
+				bno, agno);
+		}
+	}
+
 	if (be32_to_cpu(agf->agf_freeblks) != agcnts->agffreeblks) {
 		do_warn(_("agf_freeblks %u, counted %u in ag %u\n"),
 			be32_to_cpu(agf->agf_freeblks), agcnts->agffreeblks, agno);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
