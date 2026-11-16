Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871091;
	b=jJ2p6ICo+ixmy3LSIrTeJs1+CLWf5lRKACCDsyXneg5DsFhSwtlxTkHe8+BWM7PW3l7P
	 EdNimmJSKrmfV7tfynhaiKx7pGmrW4sdvkMbOXaNtV68mMW2tBo3nIGk0q5GdnKqAWxVk
	 wSpEzYPFa9mCJPgfxx9notGDXnngVLzAQdF9h1qBBqeyAuXIWm//bQxtKGvb4sWFAEnzD
	 wg5e66j+z4rY9+FgNuFVJuyVzVRywWAZtaIKejyTQWCaFDvXnt7gULNOaYvFNyOT9sX8j
	 eStNtTSpXydalMFBzcDwYA+h0jy6ufeVOZ4IFjh5/lIFsIsvMe4TIPEDGHG6rVDwwPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ynW/zZJfbPbvAjeM5TWrSmRUB00sN22UmQKYu/wZpV4=;
	b=X/d1movivB6Ke2XvgIJ8v/JF0PJykfBejJ68ZJbOGSoB/NNFtcPB+VQgRhTm3szFxQWb
	 o1Sf6EbhIzllXp/hdTdy4E4fVAtKUwGrrNTvIZB7JGDaLDkNsLjsKQA34E8cG9Nac7a2+
	 TlP4NHObWFBAN/63NkrKYVt3l7BDYHLLS6AIfvJvX6WXOWefNVfVTVY3l8fWiElITdp3y
	 ikvjLCxY/BcB/J6n1m6q6ahEfRKMA6XorOasi67HnBzDkAjg9QMDaO19eX2zmMxIigKwA
	 pTEAykdFmSdbPIcD6bNdAZ2mlk0VbHnPPWMbu4tVvjDdpm7ikrMOffD9S+7h8sdThUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dt2SsJO1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E807606A335
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dt2SsJO1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBABD1F000C4;
	Mon, 16 Nov 2026 23:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871090;
	bh=ynW/zZJfbPbvAjeM5TWrSmRUB00sN22UmQKYu/wZpV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dt2SsJO1CO2n4A4nBF2VCjoWZVPFX4L+NgOO8tr5AM+GTQU7xVcCgmBPUlNsfmNBM
	 cfzzdj4OrcBpGr9PP7zLIFB9IQtCFiVr16jcDbNY79Q0QheV8yk0V7qq12IhIh4W7e
	 R6ahFHasMZ8J1P4HtYWG2Qal0q46jLk0VFHUGG+IjpxIN2hbFNxwCACx47JON+UHZS
	 RnEqWyhfCDUkphPE3BzSMgcnrXsptRhUw3QWKMcHpKNFEejGfPKsvQeA1f7NOHuMm1
	 4xqz0mEfnZ/0sML4L82wcCkGxjvspNQN3gs8/eOttyUbyZ2QMihl/Q0xUxEwuUvn1T
	 PNJ2Rb2kQ0W6w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 44/59] xfs: allow xfs_imap() to map without an inode btree lookup
Date: Tue, 17 Nov 2026 10:15:01 +1100
Message-ID: <20261116231707.3625263-45-dgc@kernel.org>
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

xfs_imap() maps an inode number to its cluster buffer location. For the common
inode cluster geometries it does this by arithmetic, but for the general case it
falls back to an inode btree lookup that reads the AGI and walks the inode
btree.

Some callers cannot allow that lookup. Log recovery in particular wants to
cross-check a logged inode buffer location against the one derived from the
inode number, but it runs before the filesystem is fully available and must not
issue btree lookups.

Add an XFS_IMAP_NO_LOOKUP flag. When it is set, xfs_imap() maps the inode by
arithmetic alone and returns -EAGAIN instead of performing the btree lookup, so
the caller can tell that arithmetic mapping was not possible for this geometry.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c | 7 +++++++
 fs/xfs/xfs_icache.h        | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ec0a37499f28..f57435f490c4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2435,6 +2435,10 @@ xfs_imap_lookup(
 
 /*
  * Return the location of the inode in imap, for mapping it into a buffer.
+ *
+ * If the caller cannot allow a btree lookup to be performed, then it should set
+ * XFS_IMAP_NO_LOOKUP. If arithmetic mapping cannot be performed, we return
+ * -EAGAIN to inform the caller mapping failed due to a lookup being required.
  */
 int
 xfs_imap(
@@ -2522,6 +2526,9 @@ xfs_imap(
 		 */
 	}
 
+	if (flags & XFS_IMAP_NO_LOOKUP)
+		return -EAGAIN;
+
 	error = xfs_imap_lookup(pag, tp, agino, agbno, &chunk_agbno,
 			&offset_agbno, flags);
 	if (error)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 905944dafbe5..a1386b16edcd 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -41,6 +41,8 @@ struct xfs_icwalk {
 #define XFS_IGET_INCORE		(1U << 3)
 /* Return -EAGAIN immediately if the inode is unavailable. */
 #define XFS_IGET_NORETRY	(1U << 4)
+/* Map the inode by arithmetic only, never by an inode btree lookup. */
+#define XFS_IMAP_NO_LOOKUP	(1U << 5)
 
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
-- 
2.55.0

