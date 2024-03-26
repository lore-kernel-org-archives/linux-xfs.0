Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29951C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422373; cv=none; b=Tp9gibPXCFbyhPVaRGaNxFTfPrVjeMHQBZJRPaL9VsV1YP7MTITNhr93tXZ1+LDn0Wt8j79cjmKzmxeviA9NyiDysvlF20n12FBE2/Uicp68XdNeQtGFBCkkEXyd+J76Jo2RiN8Ma/7mzGvoDLJNXRoLwYbBu4KmnneW9ZcH/8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422373; c=relaxed/simple;
	bh=zFeRu/sXavAMNJiN96+e+Qxs6SObXlXmba8jwSNRmDQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZuQ6zclidCZ91KhbU2UHxED26inqMLLiAlKz1QIzX7THF/f0WKfTwKK1gajt1WzefeU7gM62BQqNN89mp2ghmMLXWcMPBVcqLatgtH1Bll4HyYuDYqvhwF5ogBj/3681uvRP+bkMpMbdr07ITVRh6UnSlw19V3fydIJ4+rq79NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rCmz1/+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rCmz1/+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEA6C433C7;
	Tue, 26 Mar 2024 03:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422373;
	bh=zFeRu/sXavAMNJiN96+e+Qxs6SObXlXmba8jwSNRmDQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rCmz1/+g14S3UycmvZjzgNQDH+dzh0v/i3nGxXx1PXDnjhJV3N1neWGqBkWkGXgYE
	 BkAxpb4JrH7zMdOR3z4h6M/hGPnWKrWJSBb6axqbOxrSy/YzhjUcSVcoI81cxkVmvz
	 NSY5s3vbZ6i6QFzJ5bRabQ2x4TEtc8dOkJfp+mkCS34NTWzNPFz9su2L3+sFb3bPPD
	 BiueW/uvPO/ZZGbtJihxB5vyHUbaNv46quVEj9p0CxQvGEg/31TsPFDMtjeClcVpOE
	 A1sL0RRR3W4EoP4ZAW5QHEzHrq916LCnipNJSeboJT/qk6J+MIIFLeiduFtYCVQnS6
	 m4Fwh1ze2tkrw==
Date: Mon, 25 Mar 2024 20:06:13 -0700
Subject: [PATCH 13/67] xfs: don't allow overly small or large realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127150.2212320.11987210332474896828.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: e14293803f4e84eb23a417b462b56251033b5a66

Don't allow realtime volumes that are less than one rt extent long.
This has been broken across 4 LTS kernels with nobody noticing, so let's
just disable it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_rtbitmap.h |   13 +++++++++++++
 libxfs/xfs_sb.c       |    3 ++-
 mkfs/xfs_mkfs.c       |    5 +++++
 repair/sb.c           |    3 +++
 4 files changed, 23 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 6e5bae324cc3..1c84b52de3d4 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 95a29bf1ffcf..7a72d5a17910 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -507,7 +507,8 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (sbp->sb_rextents != rexts ||
+		if (!xfs_validate_rtextents(rexts) ||
+		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index abea61943652..1a0a71dbec78 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3025,6 +3025,11 @@ reported by the device (%u).\n"),
 	}
 
 	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
+	if (cfg->rtextents == 0) {
+		fprintf(stderr,
+_("cannot have an rt subvolume with zero extents\n"));
+		usage();
+	}
 	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
 						NBBY * cfg->blocksize);
 }
diff --git a/repair/sb.c b/repair/sb.c
index 384840db1cec..faf79d9d0835 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -475,6 +475,9 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if (sb->sb_rblocks / sb->sb_rextsize != sb->sb_rextents)
 			return(XR_BAD_RT_GEO_DATA);
 
+		if (sb->sb_rextents == 0)
+			return XR_BAD_RT_GEO_DATA;
+
 		if (sb->sb_rextslog != libxfs_compute_rextslog(sb->sb_rextents))
 			return(XR_BAD_RT_GEO_DATA);
 

