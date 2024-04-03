Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5B16AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121154; cv=none; b=SEnOjFL12KoElr2stQbxILbxg+SHAIdrP6MSdjJckirD83+roVcsAQ8KM7mRwdZpZ85rz4+r5ArhJFTjZywgwyL3XFnW9VUEOJVwjQcnOrtX7Nr0xZQqz7N5W1Aziji+9/hWRmQB7FARux4Fm7rAdttAkpuaBZmDIr4gTlLXRhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121154; c=relaxed/simple;
	bh=OAgFWFv3XYLx3WEiVUgCtWYYPCemyzb8kpJ5KIgvGZA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxBRqIhX6bwvsKPqNHWXZMZHAU//kxFdQ2/qXldpERfJPq7jf2tYZRXztUDlF6IfWy4EZ3dxxIssBdPnFTp5wTHQ37rt5qg5Yv6zgbAfVyLwh3gDCPe+wUOeDNTWz84TW9gIhZmyWq3/OSPSVrunVbfwnendXuG87D/rzZTbAEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMjRjZlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMjRjZlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C105C433F1;
	Wed,  3 Apr 2024 05:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712121154;
	bh=OAgFWFv3XYLx3WEiVUgCtWYYPCemyzb8kpJ5KIgvGZA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=WMjRjZlRIAXTyCifJ14u9fSNBvBVT2efFwjjXTrDqIxnDZLFefLMSfny9j9XHfNe+
	 eQdDeAG2+iF38/Qmv9hmuqXzhhG9QwTyvVFx6V3SRXkSoyR/DdWO0BCKcGPcpcNUxp
	 XJ90cGDeI9Q5wnBktpBCdxL0x/ZsxlArpXjsbXNuuZE6vHcMNle3QDC8Q5xDHWbj1N
	 MyA8d5kIrKG4FRMGF2h9KXaIOZqLOx7bKoPbxyeJJUfVgXa+lQ3VjCAcDqM6+zfzw8
	 OalHOrzrYMePCysORtjkp+HE7lGRW6ANDhk1y95SYFDU6Tao7LKFO4Z23DSy5xCPHr
	 cD03Q2ohUCG2A==
Subject: [PATCH 2/3] xfs: pass the owner to xfs_symlink_write_target
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Date: Tue, 02 Apr 2024 22:12:33 -0700
Message-ID: <171212115387.1525560.11209751388578651990.stgit@frogsfrogsfrogs>
In-Reply-To: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
References: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
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

Require callers of xfs_symlink_write_target to pass the owner number
explicitly.  This sets us up for online repair to be able to write a
remote symlink target to sc->tempip with sc->ip's inumber in the block
heaader.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 ++--
 fs/xfs/libxfs/xfs_symlink_remote.h |    4 ++--
 fs/xfs/xfs_symlink.c               |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index d150576ddd0af..f228127a88ff2 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -311,6 +311,7 @@ int
 xfs_symlink_write_target(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	xfs_ino_t		owner,
 	const char		*target_path,
 	int			pathlen,
 	xfs_fsblock_t		fs_blocks,
@@ -365,8 +366,7 @@ xfs_symlink_write_target(
 		byte_cnt = min(byte_cnt, pathlen);
 
 		buf = bp->b_addr;
-		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset, byte_cnt,
-				bp);
+		buf += xfs_symlink_hdr_set(mp, owner, offset, byte_cnt, bp);
 
 		memcpy(buf, cur_chunk, byte_cnt);
 
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index 83b89a1deb9f2..c1672fe1f17bb 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -21,8 +21,8 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
-		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
-		uint resblks);
+		xfs_ino_t owner, const char *target_path, int pathlen,
+		xfs_fsblock_t fs_blocks, uint resblks);
 int xfs_symlink_remote_truncate(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3daeebff4bb47..fb060aaf6d40f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -181,8 +181,8 @@ xfs_symlink(
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	resblks -= XFS_IALLOC_SPACE_RES(mp);
-	error = xfs_symlink_write_target(tp, ip, target_path, pathlen,
-			fs_blocks, resblks);
+	error = xfs_symlink_write_target(tp, ip, ip->i_ino, target_path,
+			pathlen, fs_blocks, resblks);
 	if (error)
 		goto out_trans_cancel;
 	resblks -= fs_blocks;

