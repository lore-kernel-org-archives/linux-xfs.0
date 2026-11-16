Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871037;
	b=MHYPMePz9ckYgPE2C9pPfKHq6LHYHkU7kGZfOaQ4/JcgnMtLtguT1YKe/w1cpgPmSDjX
	 k6mit4P+42rSFF4ZQVaT0kejsZfG6B+SAnizpsHiXvnqETlgGOn3+71ryxhQYPKAUGSGJ
	 9fxlHsgu88uARIsGCFD2O4BLvjqKFZWInXUwq8TkxoUG6+yhOyIxt8F+Jk3ha+P00vu1s
	 qxmsOGB/ckivkajRceOxYcU1vT0Y/BfGZtPmkdv7FuezRoohrt8Cmg8/0xjF4TgxUeOuk
	 dOVO/eb7vucnCaVxrBnPDE15AQZ88JT1JsvDgq1XYrblZmZ4AhCX8WA2O/7SpGTeNeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zRk6XtMbqW059pASOn97GOOp5+jAoNK5MfTZMepaYdA=;
	b=EMCnpS4l/YlpSZ9jwCUcF/gFlJdQDvuuc3xgl+kEDDBpCiUpz/5vgVUXExCIJZQZKnoi
	 uoAqNgZ8GC6GrkAH9YdYswTRx4kMmcUClONR6f0uD4RjG7y+O7HayyClk3U1y7bIPbnEC
	 RCe7reHgBENcgBawkJH2I9i7JGAloSxIFz3elkZpAyjoWzhouLoKsRBSiBJMtiqJMeZ9D
	 RHMN/397jW5bzF2dQo6jk43aIMuvUWDurwDfB6j0ieV/w10qyzyFm/SHWFd0KQZKSD8Aw
	 A9oizYTGbg74/lIlwnzYwFrzk8X2qjmVYBDYD9ow0LretKdxozAf4n/WdMyJLnNTg4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LkE2Fcr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C354606A33F
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LkE2Fcr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB1F1F000C4;
	Mon, 16 Nov 2026 23:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871036;
	bh=zRk6XtMbqW059pASOn97GOOp5+jAoNK5MfTZMepaYdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkE2Fcr3z1KYHkoq1cc4RjscbKY2DNGZV9j6uL9iLJ3tk7QIFSaRx7I8NDHThhZMz
	 PgtL46Rybdi0HU5VgQOWFoz1S6+efLqqB8rKyWVn89RY9FrfV6vlWsGB7VlBc299Wh
	 L77dZ8Wn6b0wdOPdTKQgPziJOT/3UYhREp399dqNX2sVyXz08fKCkiWuHKGgJwDHeJ
	 bR0UXk613DaEoVkUHLkFjAFL6Kk+3DXmlikcTzObhM+DZFWOUfgaktkYVOZCmEJWqw
	 33Wl06wwIbl2Ib7NJnV7vOux1pEV0OnwgEPM5VWxiBXuDoOK0sO1b7v16xPUy+TpM/
	 YJXX6g+aIg0zA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 02/59] xfs: fix the rt rmap btree maximum level checks
Date: Tue, 17 Nov 2026 10:14:19 +1100
Message-ID: <20261116231707.3625263-3-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

m_rtrmap_maxlevels is the maximum height of the rt rmap btree, including the
inode root level. The deepest valid root level is therefore one less than
m_rtrmap_maxlevels. The root loader, the block verifier and the inode repair
code all reject only levels greater than m_rtrmap_maxlevels, so they accept a
root one level too deep.

This level mismatch results in the same off-by-one that commit cc3144da377d
fixed for the rt refcount btree when a cursor is built over a maximum height
btree. To avoid this out of bounds access past the end of the cursor, reject
levels at or above m_rtrmap_maxlevels instead.

There is a transient state on disk where an rtrmap inode has no contents,
because growfs can create rtrmap inodes dynamically. m_rtrmap_maxlevels is zero
until growfs adds the first realtime volume. The root loader and repair code
therefore accept an empty level zero root when m_rtrmap_maxlevels is zero. A
non-empty level zero root is a normal leaf root that is still checked to fit
within the inode fork.

Fixes: fc6856c6ff08 ("xfs: introduce realtime rmap btree ondisk definitions")
Fixes: f33659e8a114 ("xfs: wire up a new metafile type for the realtime rmap")
Fixes: 3dd3aba6b92b ("xfs: repair rmap btree inodes")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 29 ++++++++++++++++++++++++-----
 fs/xfs/scrub/inode_repair.c      |  7 ++++++-
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 2f00d0698ae1..ba0d4058e717 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -140,7 +140,7 @@ xfs_rtrmapbt_verify(
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
-	if (level > mp->m_rtrmap_maxlevels)
+	if (level >= mp->m_rtrmap_maxlevels)
 		return __this_address;
 
 	return xfs_btree_fsblock_verify(bp, mp->m_rtrmap_mxr[level != 0]);
@@ -692,17 +692,36 @@ xfs_iformat_rtrmap(
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (level > mp->m_rtrmap_maxlevels ||
-	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
-		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
-		return -EFSCORRUPTED;
+	if (level == 0) {
+		/*
+		 * rtrmap inodes can be dynamically created by growfs, resulting
+		 * in a transient state on disk where they can have no contents.
+		 * Hence a rtrmap inode with an empty level zero root is a valid
+		 * state. Until growfs adds the first realtime volume there is
+		 * nothing to map, so the root must be empty.
+		 */
+		if (mp->m_rtrmap_maxlevels == 0 && numrecs != 0)
+			goto out_corrupt;
+	} else if (level >= mp->m_rtrmap_maxlevels) {
+		/*
+		 * m_rtrmap_maxlevels includes the inode root level, so the
+		 * deepest valid root level is one less than that.
+		 */
+		goto out_corrupt;
 	}
 
+	if (xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+		goto out_corrupt;
+
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
 			xfs_rtrmap_broot_space_calc(level, numrecs));
 	if (broot)
 		xfs_rtrmapbt_from_disk(ip, dfp, dsize, broot);
 	return 0;
+
+out_corrupt:
+	xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+	return -EFSCORRUPTED;
 }
 
 /* Convert in-memory form of btree root to on-disk form. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a9ccf763c059..4486881329b9 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -969,8 +969,13 @@ xrep_dinode_bad_rtrmapbt_fork(
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (level > sc->mp->m_rtrmap_maxlevels)
+	/* Same root level rules as xfs_iformat_rtrmap(). */
+	if (level == 0) {
+		if (sc->mp->m_rtrmap_maxlevels == 0 && nrecs != 0)
+			return true;
+	} else if (level >= sc->mp->m_rtrmap_maxlevels) {
 		return true;
+	}
 	if (xfs_rtrmap_droot_space_calc(level, nrecs) > dfork_size)
 		return true;
 	if (level > 0 && nrecs == 0)
-- 
2.55.0

