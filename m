Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 760797F84
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 486BD8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dRWpGSdwNqbGjoEr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:20 -0700 (PDT)
Subject: [PATCH 19/25] xfs: cross-reference bnobt records with cntbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:15 -0700
Message-ID: <147216853554.3108.6115648994956205089.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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

Scrub should make sure that each bnobt record has a corresponding
cntbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 +-
 fs/xfs/libxfs/xfs_alloc.h |    7 +++++++
 fs/xfs/xfs_scrub.c        |   24 ++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0de83f5..a65cd8d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -170,7 +170,7 @@ xfs_alloc_lookup_ge(
  * Lookup the first record less than or equal to [bno, len]
  * in the btree given by cur.
  */
-static int				/* error */
+int					/* error */
 xfs_alloc_lookup_le(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index b740456..2afc024 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -189,6 +189,13 @@ xfs_free_extent(
 	enum xfs_ag_resv_type	type);	/* block reservation type */
 
 int				/* error */
+xfs_alloc_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat);	/* success/failure */
+
+int				/* error */
 xfs_alloc_lookup_ge(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 612d3c3..66365e2 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1096,9 +1096,14 @@ xfs_scrub_allocbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_btree_cur		*other_cur;
+	xfs_agblock_t			fbno;
 	xfs_agblock_t			bno;
+	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	int				has_otherrec;
 	int				error = 0;
+	int				err2;
 
 	bno = be32_to_cpu(rec->alloc.ar_startblock);
 	len = be32_to_cpu(rec->alloc.ar_blockcount);
@@ -1112,6 +1117,25 @@ xfs_scrub_allocbt_helper(
 	XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
 			be32_to_cpu(agf->agf_length));
 
+	/*
+	 * Ensure there's a corresponding cntbt/bnobt record matching
+	 * this bnobt/cntbt record, respectively.
+	 */
+	other_cur = (bs->cnt_cur ? bs->cnt_cur : bs->bno_cur);
+	err2 = xfs_alloc_lookup_le(other_cur, bno, len, &has_otherrec);
+	if (err2)
+		goto skip_freesp_xref;
+	XFS_BTREC_SCRUB_CHECK(bs, has_otherrec);
+	if (!has_otherrec)
+		goto skip_freesp_xref;
+	err2 = xfs_alloc_get_rec(other_cur, &fbno, &flen, &has_otherrec);
+	if (!err2) {
+		XFS_BTREC_SCRUB_CHECK(bs, has_otherrec);
+		XFS_BTREC_SCRUB_CHECK(bs, fbno == bno);
+		XFS_BTREC_SCRUB_CHECK(bs, flen == len);
+	}
+skip_freesp_xref:
+
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
