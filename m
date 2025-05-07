Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086B28D84E
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746655206; cv=none; b=XOkNGjOD+8fMHQdK67SVsN/T0CHRyzZqUuYL/+nk3rrnOJJrMD4ofTriIy3llSQFc/YtRJtON1NsWOmlq2IkMwkEgKlwOZsSM2b78J14DoUjfMh7FSCDKtGDEELHvgz1pX5vX/mG8dPvysUf6CcwoX91hOrcjT5kFo8HAy7knbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746655206; c=relaxed/simple;
	bh=BMzHU7GhGg9vToBobDMLc7ZJXIZfJvyNae6Egkobg1g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYvvHh2rW0ouhcm+BL3z/KRM4bhdskzDctt8ol3Z/9t3bxd8wrm9F3dZKZo6GtFpmpLzdd5y3AiRrEKUNwB28lckWKfxxxrRfCIglkvn28ORsuSTohs1p3hARbk/dA//krcyQ73IpKLhOQB3daGd7EC8dldA/3fgRppS8yGmTc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hn13Hb1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn13Hb1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC941C4CEE2;
	Wed,  7 May 2025 22:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746655204;
	bh=BMzHU7GhGg9vToBobDMLc7ZJXIZfJvyNae6Egkobg1g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hn13Hb1u1O7+xPxR7Qc5is+lVGcOIYBwmtqsVxJXkdYiDRSWsbqB1Pu78fYmmu1nB
	 FOgeN0C2RY92ZcMZgnRZLf8AupbBSJN7x6s0DqIRrRIzjeoeY/7fN49w/jb4fYi45n
	 AqWfPBdq+uL/7ant/xsryNG7LFECd3Wk21nBdX2MMTUdD0NEl8IHczN8Zoi7gjESco
	 Eu5m1gYk0fXqb7dXgYj4FGeeIt7JwgiDZiB2NwZX83QWMxzz8jyCm2AZGv/SjxVF0M
	 t5K+Z5zLSsxS8ukI0JjsyThup/aknjwfGv9ukveWEuyzm37t5NbmYN86RSuoSlwDXB
	 yDcUiF7fCUhtw==
Date: Wed, 07 May 2025 15:00:04 -0700
Subject: [PATCH 2/3] xfs: remove the flags argument to xfs_buf_get_uncached
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <174665514973.2713379.1600602040418414466.stgit@frogsfrogsfrogs>
In-Reply-To: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
References: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b3f8f2903b8cd48b0746bf05a40b85ae4b684034

No callers passes flags to xfs_buf_get_uncached, which makes sense
given that the flags apply to behavior not used for uncached buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_io.h        |    2 +-
 libxfs/rdwr.c             |    1 -
 libxfs/xfs_ag.c           |    2 +-
 libxlog/xfs_log_recover.c |    2 +-
 mkfs/xfs_mkfs.c           |    4 ++--
 repair/rt.c               |    2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 99372eb6d3d13c..5562e2928254a8 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -254,7 +254,7 @@ xfs_buf_hold(struct xfs_buf *bp)
 void xfs_buf_lock(struct xfs_buf *bp);
 void xfs_buf_unlock(struct xfs_buf *bp);
 
-int libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags,
+int libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen,
 		struct xfs_buf **bpp);
 int libxfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
 		size_t bblen, int flags, struct xfs_buf **bpp,
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f06763b38bd88c..5c14dbb5c82b7c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -770,7 +770,6 @@ int
 libxfs_buf_get_uncached(
 	struct xfs_buftarg	*targ,
 	size_t			bblen,
-	int			flags,
 	struct xfs_buf		**bpp)
 {
 	*bpp = libxfs_getbufr_uncached(targ, XFS_BUF_DADDR_NULL, bblen);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 095b581a116180..ea64e9eac58945 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -299,7 +299,7 @@ xfs_get_aghdr_buf(
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0, &bp);
+	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, &bp);
 	if (error)
 		return error;
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 31b11fee9e4715..275593a3ac9148 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -69,7 +69,7 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	libxfs_buf_get_uncached(log->l_dev, nbblks, 0, &bp);
+	libxfs_buf_get_uncached(log->l_dev, nbblks, &bp);
 	return bp;
 }
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9192694dd59551..812241c49a5494 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -5208,7 +5208,7 @@ alloc_write_buf(
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = -libxfs_buf_get_uncached(btp, bblen, 0, &bp);
+	error = -libxfs_buf_get_uncached(btp, bblen, &bp);
 	if (error) {
 		fprintf(stderr, _("Could not get memory for buffer, err=%d\n"),
 				error);
@@ -5595,7 +5595,7 @@ write_rtsb(
 	}
 
 	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, 1), 0, &rtsb_bp);
+				XFS_FSB_TO_BB(mp, 1), &rtsb_bp);
 	if (error) {
 		fprintf(stderr,
  _("%s: couldn't grab realtime superblock buffer\n"), progname);
diff --git a/repair/rt.c b/repair/rt.c
index a2478fb635e33b..1ac2bf6fc454a7 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -618,7 +618,7 @@ rewrite_rtsb(
  _("couldn't grab primary sb to update realtime sb\n"));
 
 	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
-			XFS_FSB_TO_BB(mp, 1), 0, &rtsb_bp);
+			XFS_FSB_TO_BB(mp, 1), &rtsb_bp);
 	if (error)
 		do_error(
  _("couldn't grab realtime superblock\n"));

