Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E124C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phQxy+wM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE30C433C7;
	Sun, 31 Dec 2023 23:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065016;
	bh=gyPd66v7RNF6+yi8PcXJj8gKH1cXFM7Q6FgAa7civZ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=phQxy+wMtu+UpRTDoRA/VBvWYy/ByTDbCIQeaE5Cyik2/JKMF3sdl/hcfgcNiskWd
	 db3FSPWJ7UfrD+HMzw/VUat2SPshNC9B4qoMWnmE/y97/fV/LdxLUzzH8qhnJNHrQe
	 OnkLQmIgey9OEwacfelRabtPefu5uycX4CnCSlRkUxiUWazpbYMyJw9sO9/SXxStl9
	 I0axAAw2v6M29SnhuUhkdrXHCPgh+zM2ctoHAEJVnPxSATM1vxcl+Hs3yA27j16fKl
	 q7NRqjSDTxK4FBbja56rf6lSMD34cKBEF7jT3ZL0CjkudhMgbiyvCjwTMHZKx6pfQy
	 6I9T8KcuCDh0w==
Date: Sun, 31 Dec 2023 15:23:36 -0800
Subject: [PATCH 05/28] libxfs: pass IGET flags through to xfs_iread
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009244.1808635.13997520855418279132.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
index 2bed1c2022e..68e68ee83e3 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -295,11 +295,10 @@ libxfs_iget(
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
 
@@ -324,18 +323,35 @@ libxfs_iget(
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

