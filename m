Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AD1657C5
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389111; cv=none; b=L+tSphSkyvwYkCZzOtKQPxXzXBTECAs9gFVYaLuQ4xcBOupkYnH5ZepXA6izWjqt8197SFgyaxn8/HS1EbQN48cfXnna62palUWzZ8RBwUcNWfrs4xq8JiPtPkVjMj4vOLIM5DpclQO1b4sxz78KRi3Esob5MpJEp810uzTtUmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389111; c=relaxed/simple;
	bh=mFHIVljog5GbxlkZdPh2m3JYfSUUARIqdiQuG6Xe/X4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WayjYq+V3SZGMRIePYLHEKA3YiXkrbs/wdiSUvm5Wn9XmIN1fZnqhb1m1PYn+wePK7bfYl1vD0nBSWk3YtPIz0+4oeOk8lJu2Q0TktLfBA20Lz8Hax6r8fycjjLWX6bKnV33vMDoI30c69TKSZfSnjByRPeFcdfjfagKHRLGuaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjYqVKs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjYqVKs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF86C072AA;
	Wed, 17 Apr 2024 21:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389110;
	bh=mFHIVljog5GbxlkZdPh2m3JYfSUUARIqdiQuG6Xe/X4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EjYqVKs+thh4PRI2SmQrWoRzaGgsZbilXMpHuIjKqyuAHyxH6Rza1HhZRQeaz0hUX
	 CGBEh2stjxvZF8legdnoWZ6Guoypn06U/NhvOWgNGj/fsaW8199YcMIpvFhZwFiae/
	 mYpurzKIzCTK845NJiaUCM/u/jJjRqZ8Qnldbg/g/ye2lG2o3koz1UwGhaL5XmLPMH
	 gxGxm/YxuSp7Qo50U2bbYBl0medrMUAV4MQ7bNnAC3i4t7psxIjnwJ7Z9iHV00nbXo
	 kk3PEFrofNS91r3mHtYX52bKGAWwwGx8uWPfoo/Im5NI3l9LsOwetcYTHRLAQmwCBL
	 aviIww8SNzG6Q==
Date: Wed, 17 Apr 2024 14:25:09 -0700
Subject: [PATCH 13/67] xfs: don't allow overly small or large realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842535.1853449.6755368252304502824.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
index 6e5bae324..1c84b52de 100644
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
index 95a29bf1f..7a72d5a17 100644
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
index abea61943..1a0a71dbe 100644
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
index 384840db1..faf79d9d0 100644
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
 

