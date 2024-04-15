Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F061598E4
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225246; cv=none; b=jTShjAXL6p+kDokKKZx6SuePW920uzTlgQ826OPgTPzgjZNG09xSXhjkiP6WNIwRF++IfMVJgmDGA6Pic8w7Ybi7Tr8yfqFpkJ5Ag1tZpq0kYIA6pcPGQnVPWURAzXWyw78BVWmlQZhAdN0eh7KYCsBXUOJTnUISR7PeAF2n1kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225246; c=relaxed/simple;
	bh=7VYnEMGlrDbat0JY2QY1EAxYhlZeIXjABUqWsL59eSg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VeM572nl8aAChAWM0g/wny2GdqTi+yOa66tUWKRgxCe+MUWZEYHWRvd/Io8VOV52sUqlzkK77XdtH4EikOcdVcErKyBL2S9VPO5W2Bg+5pHHMpvG2AJ1trXG/P1CMxwGEUOB7I33k8JD9nd4hWUlmZmYaqC2Mht43J9lRM4voPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o71dQAUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o71dQAUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16B1C113CC;
	Mon, 15 Apr 2024 23:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225245;
	bh=7VYnEMGlrDbat0JY2QY1EAxYhlZeIXjABUqWsL59eSg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o71dQAUpbAtffG9Vr67WRngCRfLQQ5KxYl0pIB4/53dQjt+pimk58PW8pH/rR4v43
	 5K+RECGdymbPcU5gJAH1XrQQC640bUkBlwvbidTGXX4Udq+uoXJRe/uSyKRHgFjHyr
	 ShGoqkOkw13ExVzLDCmVIB4L8Ex2/3PlfT3TeYrtLaUay2CA+19ucYUVt5Ub9RYAfL
	 KB41Aa7565qqBuyh0iyTK5tyVafsb15sZ5bpTBTI7yctpiQZhG+yOcKmPNjuexcSOp
	 fZVg5uzXh6UyTsi+E+GSjbcKjNYZzkcoP4B7vg9oQxImdOgioLGBMfJbc2dLjlIB4b
	 69XSctpOl4Evw==
Date: Mon, 15 Apr 2024 16:54:05 -0700
Subject: [PATCH 2/3] xfs: pass the owner to xfs_symlink_write_target
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322384684.89634.14911420684777375106.stgit@frogsfrogsfrogs>
In-Reply-To: <171322384642.89634.337913867524185398.stgit@frogsfrogsfrogs>
References: <171322384642.89634.337913867524185398.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 ++--
 fs/xfs/libxfs/xfs_symlink_remote.h |    4 ++--
 fs/xfs/xfs_symlink.c               |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index d150576ddd0a..f228127a88ff 100644
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
index 83b89a1deb9f..c1672fe1f17b 100644
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
index 3daeebff4bb4..fb060aaf6d40 100644
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

