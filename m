Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47471F9D6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299434; cv=none; b=HL9Hw5Zed5VMGtg7qEPbzXQrFtOHjvv47LiWfJDHIsDm1QfWGMkjThLEhnQZ604bJ/of4RZbjF1mXA7jfc2E4VeWdzUWv9bAKFAyxBmnyV+Bs88ixNBPPSTnO1RYDLVK8fwGz4jWO3zvsfKvkatGQ72JCntXA7PmnsAbks6IHeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299434; c=relaxed/simple;
	bh=auztCkabC6+I7P34xpJHvvE+r80Z6f5LkqPGYiXeoW8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YWi0UawB+XlaTsuAoh7qGphgjRg2GB4D7LjIzz+fMdFa9v6ToKZxvagqkvdaB6vjctIQD1yMWZ+iUdaS7fzLkIwew1otJDfP4cniEp8i2Fw2ojtCCIq8mQzk+zk71PVE4J5arMh5Y6Wqtz1C9TORSkSCeM+S05m5H+0GdIxw89A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7clOb2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7clOb2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2B2C32786;
	Tue, 30 Jul 2024 00:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299433;
	bh=auztCkabC6+I7P34xpJHvvE+r80Z6f5LkqPGYiXeoW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g7clOb2bdvvgyb0hISgeyN61IvS95dQ0/to6phScrN3ts4d7bOxwfZvmBQBHtMojT
	 Q4dZlcssRj0Pii6IBYrkHu4X67MlCkZ2Yt3R7oJ+sWYlhbw5KpGiqElRKc3AZdcu64
	 r6iZNRJp5egE7GtoAxE3OGGwJDJRPLWw1ZcFCFG/VEuZoTHAIaLwbYr2DRMB/kpmpa
	 GdLEwGZQli6Y7UeHXA11c0XnbTVdUNCAkY11QAs7breE8nqpD0Qfa+DBuORqUyTxiY
	 mB7pgvkMu6quQ+ZwTUkPf9dOGQk6+HtsxmkfPSWNyGGy6rQnWBLF59DI7hIFIKInUr
	 hhB3Xbf3TyUSQ==
Date: Mon, 29 Jul 2024 17:30:33 -0700
Subject: [PATCH 026/115] xfs: pass the owner to xfs_symlink_write_target
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842810.1338752.14366833683859202866.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: ea8214c3195c2ed3a205dea42bbe7746712fc461

Require callers of xfs_symlink_write_target to pass the owner number
explicitly.  This sets us up for online repair to be able to write a
remote symlink target to sc->tempip with sc->ip's inumber in the block
heaader.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_symlink_remote.c |    4 ++--
 libxfs/xfs_symlink_remote.h |    4 ++--
 mkfs/proto.c                |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index fbcd1aebb..2ad586f39 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -308,6 +308,7 @@ int
 xfs_symlink_write_target(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	xfs_ino_t		owner,
 	const char		*target_path,
 	int			pathlen,
 	xfs_fsblock_t		fs_blocks,
@@ -362,8 +363,7 @@ xfs_symlink_write_target(
 		byte_cnt = min(byte_cnt, pathlen);
 
 		buf = bp->b_addr;
-		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset, byte_cnt,
-				bp);
+		buf += xfs_symlink_hdr_set(mp, owner, offset, byte_cnt, bp);
 
 		memcpy(buf, cur_chunk, byte_cnt);
 
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
index 83b89a1de..c1672fe1f 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
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
diff --git a/mkfs/proto.c b/mkfs/proto.c
index a923f9c10..5125ee44f 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -252,7 +252,8 @@ writesymlink(
 	xfs_extlen_t		nb = XFS_B_TO_FSB(mp, len);
 	int			error;
 
-	error = -libxfs_symlink_write_target(tp, ip, buf, len, nb, nb);
+	error = -libxfs_symlink_write_target(tp, ip, ip->i_ino, buf, len, nb,
+			nb);
 	if (error) {
 		fprintf(stderr,
 	_("%s: error %d creating symlink to '%s'.\n"), progname, error, buf);

