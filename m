Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ED6C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOrtUPRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141C9C433C7;
	Sun, 31 Dec 2023 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066689;
	bh=87heIjvLMtcOySi2Zq7DHyxy+el2mJbpo9GwbORnXVY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bOrtUPRcp4/FqQoe37d/SWleagusSpZvBfCSZQkkJLXUTryuf9GA5pG9fBQF4fQqW
	 hPG5Nyrm9pzfdwxwAozD7TXIpMJzQnpLTqeEzvXo0tm7COMXza/sDynAJfqX6HjiRT
	 5Y4thuSyms3i/1/V+vyqDXwMxeugdJSo38Go55cMAKZgHcOn+2L62CMkd8CeIA/knZ
	 ssa/ncd9z5v2XMllIGOBOalvqbJZhxo0MSVyOgnzCKZM+VRZO6IHcVv1Kp2FQo1DUg
	 Z4PCy0e5ZdHTH8Ro05AhjmPgzXf1zMW1omM5cPPFo+oxFkCECX0yEfRy63BcQ8HrQe
	 HH6CM5sE9hiXQ==
Date: Sun, 31 Dec 2023 15:51:28 -0800
Subject: [PATCH 15/52] xfs: add block headers to realtime summary blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012369.1811243.11813557824519880092.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Upgrade rtsummary blocks to have self describing metadata like most
every other thing in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h   |    1 +
 libxfs/xfs_rtbitmap.c |   18 +++++++++++++++---
 libxfs/xfs_rtbitmap.h |   19 +++++++++++++++++--
 libxfs/xfs_shared.h   |    1 +
 4 files changed, 34 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 77422fbd337..f2c70e1027e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1303,6 +1303,7 @@ static inline bool xfs_dinode_has_large_extent_counts(
  * RT bit manipulation macros.
  */
 #define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
+#define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
 
 struct xfs_rtbuf_blkinfo {
 	__be32		rt_magic;	/* validity check on block */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 3aa2c163725..7be1c0bdbea 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -49,7 +49,7 @@ xfs_rtbuf_verify_read(
 	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr->rt_lsn))) {
@@ -80,7 +80,7 @@ xfs_rtbuf_verify_write(
 	struct xfs_buf_log_item		*bip = bp->b_log_item;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	fa = xfs_rtbuf_verify(bp);
@@ -108,6 +108,14 @@ const struct xfs_buf_ops xfs_rtbitmap_buf_ops = {
 	.verify_struct	= xfs_rtbuf_verify,
 };
 
+const struct xfs_buf_ops xfs_rtsummary_buf_ops = {
+	.name		= "xfs_rtsummary",
+	.magic		= { 0, cpu_to_be32(XFS_RTSUMMARY_MAGIC) },
+	.verify_read	= xfs_rtbuf_verify_read,
+	.verify_write	= xfs_rtbuf_verify_write,
+	.verify_struct	= xfs_rtbuf_verify,
+};
+
 /* Release cached rt bitmap and summary buffers. */
 void
 xfs_rtbuf_cache_relse(
@@ -193,7 +201,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (xfs_has_rtgroups(mp) && !issum) {
+	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
 		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
@@ -1273,6 +1281,10 @@ xfs_rtsummary_blockcount(
 	unsigned long long	rsumwords;
 
 	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+
+	if (xfs_has_rtgroups(mp))
+		return howmany_64(rsumwords, mp->m_blockwsize);
+
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 588689e53ba..e8558db14b9 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -250,6 +250,9 @@ xfs_rtsumoffs_to_block(
 	struct xfs_mount	*mp,
 	xfs_rtsumoff_t		rsumoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rsumoff / mp->m_blockwsize;
+
 	return XFS_B_TO_FSBT(mp, rsumoff * sizeof(xfs_suminfo_t));
 }
 
@@ -264,6 +267,9 @@ xfs_rtsumoffs_to_infoword(
 {
 	unsigned int		mask = mp->m_blockmask >> XFS_SUMINFOLOG;
 
+	if (xfs_has_rtgroups(mp))
+		return rsumoff % mp->m_blockwsize;
+
 	return rsumoff & mask;
 }
 
@@ -273,7 +279,13 @@ xfs_rsumblock_infoptr(
 	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info = args->sumbp->b_addr;
+	union xfs_suminfo_raw	*info;
+	struct xfs_rtbuf_blkinfo *hdr = args->sumbp->b_addr;
+
+	if (xfs_has_rtgroups(args->mp))
+		info = (union xfs_suminfo_raw *)(hdr + 1);
+	else
+		info = args->sumbp->b_addr;
 
 	return info + index;
 }
@@ -307,8 +319,11 @@ xfs_rtblock_ops(
 	struct xfs_mount	*mp,
 	bool			issum)
 {
-	if (xfs_has_rtgroups(mp) && !issum)
+	if (xfs_has_rtgroups(mp)) {
+		if (issum)
+			return &xfs_rtsummary_buf_ops;
 		return &xfs_rtbitmap_buf_ops;
+	}
 	return &xfs_rtbuf_ops;
 }
 
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index f57788164a7..8ad4b67d6fe 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
+extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;

