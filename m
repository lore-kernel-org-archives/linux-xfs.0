Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0880F19CC03
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301451; cv=none; b=dYNPOtmkBJPT14siJ5MNB48qDyzDeOB7OgNeW73cif/5B+Ky4mfG7T9Jf/E2w0scG6dDALqRRO6O4mTgbpD3BcRb8Xeyzl6k1FmkXmSIqEwRXRtGCrVv2/qyk2Pohejk0I7fmko0GbivPxQAIa63J4LtC808x/92Z8cQGt+uQrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301451; c=relaxed/simple;
	bh=CVfftGum2GJoKIAbGyyglUwjm1hLQTgmOfgpqJ1bshY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWpxZAtC5exIuipdKpoxLWnYrrJDEtFV236D0PjNW37da5sl8+hbxIFheb59AiErY7knHhgMOlNXw1EEmt4LuH0sxp7Va+lUQhwOiggOZ4DFZAz2p2STfzcLxitAFb/+HiM9sfO60UVGtT4OhB+C1RZz5DfkRk+2ojEXB8y8JmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z25UDkoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z25UDkoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A16C4CEC2;
	Mon,  2 Sep 2024 18:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301450;
	bh=CVfftGum2GJoKIAbGyyglUwjm1hLQTgmOfgpqJ1bshY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z25UDkoAQucstqCJ5cuu87or1izcVqDxUSMXliBkKPgLnW+uH4y4jPmynxCyGxEUW
	 oEHSttWlNAoXJNexpt8oHEOcAkqdBUhLEc85Iq0qRHfDKxMX5u/VwkCwJqnryHWMfL
	 n0QMoNpEF/8fhpOhhBFy5TLJP8yXtQDdMdnXuVHwFIt4wHDVOgKDUa9GuWow7duMd2
	 diK7YOmu+DJagE4DJ8+do5G/jDl3P79rTWgnqrAkD0ZVJI6ayRaIg9EJMxZ0FzSFxD
	 57kP/QitNGOq3qcWQx3m9h1ocW8BDxuJ28si2dcFfMemrNE/yUE169Ofke6plSWmGM
	 5s7itjdYzJWOg==
Date: Mon, 02 Sep 2024 11:24:09 -0700
Subject: [PATCH 01/12] xfs: remove xfs_validate_rtextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105732.3325146.16253808020422691018.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Replace xfs_validate_rtextents with an open coded check for 0
rtextents.  The name for the function implies it does a lot more
than a zero check, which is more obvious when open coded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c    |    2 +-
 fs/xfs/libxfs/xfs_types.h |   12 ------------
 fs/xfs/xfs_rtalloc.c      |    2 +-
 3 files changed, 2 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6b56f0f6d4c1..f2fb6035fd21 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -514,7 +514,7 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (!xfs_validate_rtextents(rexts) ||
+		if (sbp->sb_rextents == 0 ||
 		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 76eb9e328835..a8cd44d03ef6 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -235,16 +235,4 @@ bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
 bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
 		xfs_fileoff_t len);
 
-/* Do we support an rt volume having this number of rtextents? */
-static inline bool
-xfs_validate_rtextents(
-	xfs_rtbxlen_t		rtextents)
-{
-	/* No runt rt volumes */
-	if (rtextents == 0)
-		return false;
-
-	return true;
-}
-
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ebeab8e4dab1..d28395abdd02 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -903,7 +903,7 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	if (!xfs_validate_rtextents(nrextents)) {
+	if (nrextents == 0) {
 		error = -EINVAL;
 		goto out_unlock;
 	}

