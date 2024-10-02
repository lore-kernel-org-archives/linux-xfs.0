Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C96979CC
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831396; cv=none; b=prkPbhmCpndtc/jW8k0CQjXyZwdnjtAouJX+f9y85KD1eYhVJy17iJjw2JrUkCUGf9YgfhGD/jC2LtB3fVMFRuXLT18j8eZrr5t8OmuXbGiw/E8ms6oHZZXWu9n8w5iYLBMCsoPlX1Nu7nIo74a816Sut959MKVF3kkQn8LFgrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831396; c=relaxed/simple;
	bh=AxgnwK6sWQ+Fbyld1/qyEDa5CiLvk2ZHBrEa/xNwqmo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eO7ag11GXOkUKYq9ihZ0Czb8zxgiY8X5HfQ4WOAgJXpCROAjqGCTo6pESH68cEhRMtRCp1jPeXrDB7RkQjtdvLDKP83W5VXFfWqGHv85kP9ytsDhLPQFlddUMyxeOnVzDp6quQhGBpBr058Vt6Eon9b2N7/RksdJmlPt3mrU9r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDCb9mCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDCb9mCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D3BC4CEC6;
	Wed,  2 Oct 2024 01:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831396;
	bh=AxgnwK6sWQ+Fbyld1/qyEDa5CiLvk2ZHBrEa/xNwqmo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YDCb9mClstmNxmTwrKZ49l+ZYpd/VTmiOrUNjsSdseVTp2y1NnEUzEXMW9Uer4Trv
	 Px0E6CNKgr7qdocw/nsd+w3qMrol/c8eNXG+Ix6Ap5+K5AWfZzFa/hqmXVlf7oYJjC
	 gHQ6ejOhaSX14JvHKJeJdkdzt9IP4kxjDEQEfsAnKUzmNkhX+Ckr/fGXMHqPpXK2cg
	 5CJ8+c3v0DkyTA11g0zp+CFVZvlkxXTAvH/uXu3i27Rc3lhi+PDIcmZdsbeCV77cg2
	 prKqJCtLgzuowdC7pSN/6Iri61eGxiJlQbG6I3AR0w5vtk46I7N3UXmiMgxwfkfrTt
	 kohRrbJGYr64A==
Date: Tue, 01 Oct 2024 18:09:55 -0700
Subject: [PATCH 08/64] libxfs: pass IGET flags through to xfs_iread
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783101902.4036371.12068791279134429342.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Change the lock_flags parameter to iget_flags so that we can supply
XFS_IGET_ flags in future patches.  All callers of libxfs_iget and
libxfs_trans_iget pass zero for this parameter and there are no inode
locks in xfsprogs, so there's no behavior change here.

Port the kernel's version of the xfs_inode_from_disk callsite.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index fffca7761..2af7e8fe9 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -298,11 +298,10 @@ libxfs_iget(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
-	uint			lock_flags,
+	uint			flags,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_inode	*ip;
-	struct xfs_buf		*bp;
 	struct xfs_perag	*pag;
 	int			error = 0;
 
@@ -327,18 +326,35 @@ libxfs_iget(
 	if (error)
 		goto out_destroy;
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
-	if (error)
-		goto out_destroy;
+	/*
+	 * For version 5 superblocks, if we are initialising a new inode and we
+	 * are not utilising the XFS_MOUNT_IKEEP inode cluster mode, we can
+	 * simply build the new inode core with a random generation number.
+	 *
+	 * For version 4 (and older) superblocks, log recovery is dependent on
+	 * the di_flushiter field being initialised from the current on-disk
+	 * value and hence we must also read the inode off disk even when
+	 * initializing new inodes.
+	 */
+	if (xfs_has_v3inodes(mp) &&
+	    (flags & XFS_IGET_CREATE) && !xfs_has_ikeep(mp)) {
+		VFS_I(ip)->i_generation = get_random_u32();
+	} else {
+		struct xfs_buf		*bp;
 
-	error = xfs_inode_from_disk(ip,
-			xfs_buf_offset(bp, ip->i_imap.im_boffset));
-	if (!error)
-		xfs_buf_set_ref(bp, XFS_INO_REF);
-	xfs_trans_brelse(tp, bp);
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
+		if (error)
+			goto out_destroy;
 
-	if (error)
-		goto out_destroy;
+		error = xfs_inode_from_disk(ip,
+				xfs_buf_offset(bp, ip->i_imap.im_boffset));
+		if (!error)
+			xfs_buf_set_ref(bp, XFS_INO_REF);
+		xfs_trans_brelse(tp, bp);
+
+		if (error)
+			goto out_destroy;
+	}
 
 	*ipp = ip;
 	return 0;

