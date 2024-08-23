Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8318115BB
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371986; cv=none; b=IJJ5KqVEyI/aFR0ma1I1aOkU6zMDsHq9ei5kmBU1P0v2ZGSiE5sAdo+45ZMoAUOt3VVUT+NU0WyzOgBTAdZ7XRx6hqzHIlW1l2YUK6ErqF10V6J+DUgq//BewnWJDsi42LIb/S/USe0vxTlNLQR5xAxS+7E+yc1oWPpfidDwT2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371986; c=relaxed/simple;
	bh=aAdcm9+Wu73/u5NcBqmeqIwK3dPCgLoXA1mteEvUzJw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBaS82YBppXqeg1niKLy00hpwRhLW03aJ6WxUs57mtcAgg3syYDFQ1CiY25BrUhf+Y6axO0wHlGezFS0XiocZqEH/gsyE7Pck4G71LBbe7oVTkycyh3HNR/JvPZ6Gmw2ZjzFAaVRAaxdDB76mG8hWBrv2pQ6BM+RL5G+ypQ7N6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5SwUw0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5SwUw0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD77C32782;
	Fri, 23 Aug 2024 00:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371986;
	bh=aAdcm9+Wu73/u5NcBqmeqIwK3dPCgLoXA1mteEvUzJw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L5SwUw0L9uqQKEQ7C0veuI/DjiMHIKRqFFgvVh70tyMnLuA5Xgg17FmcsVxzrPziR
	 eIynUsfr+Mrw1awLzfY7HY9jw6efy9QJWBegoIuYx60Do2UMCdI6CVVnpomJIFakgx
	 CdZW5zLLNTeMchvGiD3nCPuRRH/9XSyPzIpheH1rZz5VBN8mCEQrdbQilb88iXlxW0
	 3dUv6EGbnhbeQ4dHfQqlsu1HuZPJGK2gFme7I22pO3Ku6jVhiSrtlswqCUszRffzPV
	 0e6WP8Vceqr4zbPIkIg+KfPBsqR/gAwOBR4Z5JZb8v9GlJ6pJeRBr6FKF8OUmr52sC
	 +Robk4jW8Hq5A==
Date: Thu, 22 Aug 2024 17:13:05 -0700
Subject: [PATCH 04/10] xfs: don't scan off the end of the rt volume in
 xfs_rtallocate_extent_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086686.59070.3726598549775443534.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
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

The loop conditional here is not quite correct because an rtbitmap block
can represent rtextents beyond the end of the rt volume.  There's no way
that it makes sense to scan for free space beyond EOFS, so don't do it.
This overrun has been present since v2.6.0.

Also fix the type of bestlen, which was incorrectly converted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3d78dc0940190..7e45e1c74c027 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -231,22 +231,20 @@ xfs_rtallocate_extent_block(
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_rtxnum_t		besti;	/* best rtext found so far */
-	xfs_rtxnum_t		bestlen;/* best length found so far */
+	xfs_rtxnum_t		besti = -1; /* best rtext found so far */
 	xfs_rtxnum_t		end;	/* last rtext in chunk */
-	int			error;
 	xfs_rtxnum_t		i;	/* current rtext trying */
 	xfs_rtxnum_t		next;	/* next rtext to try */
+	xfs_rtxlen_t		bestlen = 0; /* best length found so far */
 	int			stat;	/* status from internal calls */
+	int			error;
 
 	/*
-	 * Loop over all the extents starting in this bitmap block,
-	 * looking for one that's long enough.
+	 * Loop over all the extents starting in this bitmap block up to the
+	 * end of the rt volume, looking for one that's long enough.
 	 */
-	for (i = xfs_rbmblock_to_rtx(mp, bbno), besti = -1, bestlen = 0,
-		end = xfs_rbmblock_to_rtx(mp, bbno + 1) - 1;
-	     i <= end;
-	     i++) {
+	end = min(mp->m_sb.sb_rextents, xfs_rbmblock_to_rtx(mp, bbno + 1)) - 1;
+	for (i = xfs_rbmblock_to_rtx(mp, bbno); i <= end; i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
 		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
 

