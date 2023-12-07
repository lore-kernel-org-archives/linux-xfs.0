Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D92B15CE
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUsY4dbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4E3C433C7;
	Thu,  7 Dec 2023 02:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916098;
	bh=rMq1cfBvoEHe7PZznwMsuSY3GjW39YDkaYvP/1v0lEs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WUsY4dbRjuHnyaaZlJiCivqAjMU0VnnUHnoXhGivkx92FxFMFYMwoWpmDhyKMR90k
	 tnVP7TfJKExDGJZhulh6IdOjOKSWG/ATPbWJ4AZlB1UDrQSwKCSGSOPfl74McYnBzA
	 IUeyfs2eRau7JFDwybn8EUTcFWYklyp+UbUVfCdn9wMRHJmq69GkhNJ5pS132MIkVr
	 Wa4SOve4BGT9E5jGpSm3cJsVsWckb/GuvDtMGqIzAndORiIFwyAq2rsuaBpGrNQOH8
	 VByP0Gzi0y29XDhCiVsPo41ppb19pX0i9ShGDZu4yoP50FY/DO3TKdQ5KvtUU0ZuWw
	 7ZsI40rX8NIlw==
Date: Wed, 06 Dec 2023 18:28:17 -0800
Subject: [PATCH 3/3] xfs: don't allow overly small or large realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562923.1133665.501737558112367708.stgit@frogsfrogsfrogs>
In-Reply-To: <170191562871.1133665.6520990725805302209.stgit@frogsfrogsfrogs>
References: <170191562871.1133665.6520990725805302209.stgit@frogsfrogsfrogs>
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

Don't allow realtime volumes that are less than one rt extent long.
This has been broken across 4 LTS kernels with nobody noticing, so let's
just disable it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   13 +++++++++++++
 fs/xfs/libxfs/xfs_sb.c       |    3 ++-
 fs/xfs/xfs_rtalloc.c         |    2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 6e5bae324cc3..1c84b52de3d4 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -353,6 +353,18 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
@@ -372,6 +384,7 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_compute_rextslog(rtx)			(0)
+# define xfs_validate_rtextents(rtx)			(false)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index df12bf82ed18..4a9e8588f4c9 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -509,7 +509,8 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (sbp->sb_rextents != rexts ||
+		if (!xfs_validate_rtextents(rexts) ||
+		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7c5a50163d2d..8feb58c6241c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -963,6 +963,8 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
+	if (!xfs_validate_rtextents(nrextents))
+		return -EINVAL;
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
 	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;

