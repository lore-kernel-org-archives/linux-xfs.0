Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426EE8460
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371752; cv=none; b=OhnmrcM59ZBrdNvLMaoa6eC9wUJl42hgaM/reT/NAfR025NHiKz/9GIQEtgdwI/Z0Jk0J0rAseAxJvWbFosdXZmKfEfJYdiE5Z5/sI7sk0Dm6uT1gFWepJJYK3QzPg+aFUH4WPmUkfJupjNoyOTblqmJi16aOKVmYwiAhfKjijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371752; c=relaxed/simple;
	bh=XhduGXii+ygpCt2VdEygsatv8gUI8pz4yXFGXIvShZE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PejbLUDOnEWdqAtrFFM0/bFkWtvGiIjnE0PDFlRctW7nQCQzKzQYm10HtA7wNbbwfriW3Xn9x1w5ZhHd6nJUe8o1pPKOvByA4bgBbje5+ZrvlM/Phk0VgiJnLs6BMUfiY95xgIWuHOwWidNVumph04Ea5GvN09K7xWoXGGN2Y80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvC7bQc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvC7bQc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B742C32782;
	Fri, 23 Aug 2024 00:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371752;
	bh=XhduGXii+ygpCt2VdEygsatv8gUI8pz4yXFGXIvShZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VvC7bQc/KT6SdMg11BcVBnGtbkDHDKd+xFM22mLw8aRThgM8Oz1dFpN1eWRHctnDJ
	 9ANAcmrbiwNgvfgQ01a51KAQZqTK2E1sFjB20M+pcJVddjhl6kxuPaZcG+4ihqlbxS
	 M6RELZ7BH3qV+hQH4gOq00XD2/hGNKO6W5qpuUkVV0MxWWLoVIZC42b/dlih+0Uy0G
	 hkGoPern+Atm4Z+a6t9bp1FKIVk69aIHdgnFTmBRH1E28QmkFvaizAX5yU3fJXlDId
	 Dh+cRUYv5h0OZNHtUmMj/e2OLqNcgyxsoRfz5neh2k20vQdTf0hsRzMbWKmfNCSlFY
	 gQNthHoO+hk4Q==
Date: Thu, 22 Aug 2024 17:09:11 -0700
Subject: [PATCH 01/12] xfs: remove xfs_validate_rtextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086036.58604.3933092156936521313.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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
index 1dcbf8ade39f8..b781e5f836e4c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -516,7 +516,7 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (!xfs_validate_rtextents(rexts) ||
+		if (sbp->sb_rextents == 0 ||
 		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 76eb9e328835f..a8cd44d03ef64 100644
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
index b4c3c5a3171bf..2acb75336b7b9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -905,7 +905,7 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	if (!xfs_validate_rtextents(nrextents)) {
+	if (nrextents == 0) {
 		error = -EINVAL;
 		goto out_unlock;
 	}

