Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580921BAF1
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191778; cv=none; b=DvmMLf43TNJPtxh4FPZYjdm9W5lny8cef/VCCeI+jZgKEs5/BlCt/I/n19fbMiEahjaVmhZZP1W+2ZZAVbygGh5PAz5amOAqYrofjWfu8iMuY1yEd1DXRVSdVLveLtnYwBIociYMaBu8+xdxUm8ZeMQcxBt7VyIyUhOx1p5dOMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191778; c=relaxed/simple;
	bh=g43W6Gf8r8714Oo/QOsTCnIkIoQtL69sglPqxiJAHtM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qblqK3mUw8SA1wa5X/4o7M3uIx7eiKGf8Tgv8RdAq0DYHX5J42BPDK0BK4XXhbxkmpZoREsSkmDSb8oP747Btplj61FUsXGYdhywvKEwoTfz0CEyyoOzaAMYtlcbK59jM3q/RQIjZfIw2UlI01X69vsH54DuwMdr+eCfeacNSFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3Tp2SM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3Tp2SM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EA5C4CEC3;
	Thu, 17 Oct 2024 19:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191777;
	bh=g43W6Gf8r8714Oo/QOsTCnIkIoQtL69sglPqxiJAHtM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T3Tp2SM3NDovdPdJKuzTsl3hi9euacoGFib+Z6zlEosVE8Cj35eAEtmWjTtC/JP77
	 npLjtzmRUru8saFCsL61E5Be5FnzSW3+k4juyTmwEcpYYrJTix/jKCZfU9qhEHAzMv
	 kKGeuEvyDzY1k2Pul9Jf9eUcv3cEbBIYcfou70uEuuCGKvhN41E2EjGG7uCiQjAu+o
	 rqJDhEOjZU4FbBmnVWSDEvh/y7/z7qYMcH16JNsdl88ZtbZw692DO2rVjrEYtZ1970
	 giUOMW77B1xdwTjtQfXjIuST3oIlGRW82w+/3h8wp6EVPGtWwruR9Ko8njRbtFavCk
	 3icjPp0nn+MXA==
Date: Thu, 17 Oct 2024 12:02:57 -0700
Subject: [PATCH 18/21] xfs: factor out a xfs_growfs_check_rtgeom helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070708.3452315.4183118504832655461.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Split the check that the rtsummary fits into the log into a separate
helper, and use xfs_growfs_rt_alloc_fake_mount to calculate the new RT
geometry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: avoid division for the 0-rtx growfs check]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16d633da1614c3..785ff3e49295b5 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1023,6 +1023,31 @@ xfs_growfs_rtg(
 	return error;
 }
 
+static int
+xfs_growfs_check_rtgeom(
+	const struct xfs_mount	*mp,
+	xfs_rfsblock_t		rblocks,
+	xfs_extlen_t		rextsize)
+{
+	struct xfs_mount	*nmp;
+	int			error = 0;
+
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
+	if (!nmp)
+		return -ENOMEM;
+
+	/*
+	 * New summary size can't be more than half the size of the log.  This
+	 * prevents us from getting a log overflow, since we'll log basically
+	 * the whole summary file at once.
+	 */
+	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
+		error = -EINVAL;
+
+	kfree(nmp);
+	return error;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -1031,9 +1056,6 @@ xfs_growfs_rt(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
-	xfs_rtxnum_t		nrextents;
-	xfs_extlen_t		nrbmblocks;
-	xfs_extlen_t		nrsumblocks;
 	struct xfs_buf		*bp;
 	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
 	int			error;
@@ -1082,20 +1104,13 @@ xfs_growfs_rt(
 	/*
 	 * Calculate new parameters.  These are the final values to be reached.
 	 */
-	nrextents = div_u64(in->newblocks, in->extsize);
 	error = -EINVAL;
-	if (nrextents == 0)
+	if (in->newblocks < in->extsize)
 		goto out_unlock;
-	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
-	nrsumblocks = xfs_rtsummary_blockcount(mp,
-			xfs_compute_rextslog(nrextents) + 1, nrbmblocks);
 
-	/*
-	 * New summary size can't be more than half the size of
-	 * the log.  This prevents us from getting a log overflow,
-	 * since we'll log basically the whole summary file at once.
-	 */
-	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
+	/* Make sure the new fs size won't cause problems with the log. */
+	error = xfs_growfs_check_rtgeom(mp, in->newblocks, in->extsize);
+	if (error)
 		goto out_unlock;
 
 	error = xfs_growfs_rtg(mp, in->newblocks, in->extsize);

