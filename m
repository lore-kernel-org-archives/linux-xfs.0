Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0B01BF31
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 04:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710891; cv=none; b=U2jOew+mKO8VnKIpVzUAEFh1ip3EPHFULVij4wlAT07BWUlX5Fw1IoIFpdRpKYcc69abJAXBfnb3H33Tu3PC4ldrDJMkFNDUjCKgQW8seoA/ij+62U1Dv+foffQS0xNT6vgZmUO9gJ5btf55g7f1Z3zrJej89xXKcEmsgpTWGxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710891; c=relaxed/simple;
	bh=BLdTENdYkrpfml9Wv7RH+R+5BciiKxjUJxBqxz4S2so=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJE1eq0QuDMAPDW7B/bKQ/KBajx5NEPRGlqDMnatRi1NDTAP5wBp2JuaFPGACBQ5q2CIxxmXfAaPNIHq0fKOeW8PYzIwFP0OcvMQx9K5WEymm1nJWEiRd7zmW72F+vMPSAp29ZRxJBVE7rG+Acvwj4+oZ1KmnF74ppuoL0F9jUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSVffHnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSVffHnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439BEC116B1;
	Fri,  3 May 2024 04:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714710891;
	bh=BLdTENdYkrpfml9Wv7RH+R+5BciiKxjUJxBqxz4S2so=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VSVffHnC63MmJJt0yx1R9zJGSSYsoB0MAYXltP11ZGLqhWpzfKTg/KIzEKtZYSRiR
	 t5/WOhvvJshK9epW/GdbsUVRfp8KwlSqeCYNAgOlLd6Tl4dGol4fU1Z3UHQvMxAGG3
	 BVLerDyrf8rncqJMfuWbmirxPp/2FB2G9+bxzlL6Om4wTOfKUy/8fPUTHoq7qqkHSt
	 zYn1ZSIoszYQ/5QWLSSOis1cw64YWTJUyDbHGG2fS0JgDvuh37n5/ndzHk5NUXWRar
	 Lf0rjcTh4wirmyHSt7FDC3OfSk1YhZs9W06z094l71IaQ9Cp5B4hc3ONbPA1NoS7aY
	 OlhhwuCvJ6OTw==
Date: Thu, 02 May 2024 21:34:50 -0700
Subject: [PATCH 5/5] xfs: widen flags argument to the xfs_iflags_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <171471075406.2662283.13086623086879689775.stgit@frogsfrogsfrogs>
In-Reply-To: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
References: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
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

xfs_inode.i_flags is an unsigned long, so make these helpers take that
as the flags argument instead of unsigned short.  This is needed for the
next patch.

While we're at it, remove the iflags variable from xfs_iget_cache_miss
because we no longer need it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_icache.c |    4 +---
 fs/xfs/xfs_inode.h  |   14 +++++++-------
 2 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 74f1812b03cb..0953163a2d84 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -613,7 +613,6 @@ xfs_iget_cache_miss(
 	struct xfs_inode	*ip;
 	int			error;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
-	int			iflags;
 
 	ip = xfs_inode_alloc(mp, ino);
 	if (!ip)
@@ -693,13 +692,12 @@ xfs_iget_cache_miss(
 	 * memory barrier that ensures this detection works correctly at lookup
 	 * time.
 	 */
-	iflags = XFS_INEW;
 	if (flags & XFS_IGET_DONTCACHE)
 		d_mark_dontcache(VFS_I(ip));
 	ip->i_udquot = NULL;
 	ip->i_gdquot = NULL;
 	ip->i_pdquot = NULL;
-	xfs_iflags_set(ip, iflags);
+	xfs_iflags_set(ip, XFS_INEW);
 
 	/* insert the new inode */
 	spin_lock(&pag->pag_ici_lock);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9fd4d29a5713..292b90b5f2ac 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -207,13 +207,13 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
  * i_flags helper functions
  */
 static inline void
-__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+__xfs_iflags_set(xfs_inode_t *ip, unsigned long flags)
 {
 	ip->i_flags |= flags;
 }
 
 static inline void
-xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_set(xfs_inode_t *ip, unsigned long flags)
 {
 	spin_lock(&ip->i_flags_lock);
 	__xfs_iflags_set(ip, flags);
@@ -221,7 +221,7 @@ xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline void
-xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_clear(xfs_inode_t *ip, unsigned long flags)
 {
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags &= ~flags;
@@ -229,13 +229,13 @@ xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline int
-__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+__xfs_iflags_test(xfs_inode_t *ip, unsigned long flags)
 {
 	return (ip->i_flags & flags);
 }
 
 static inline int
-xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_test(xfs_inode_t *ip, unsigned long flags)
 {
 	int ret;
 	spin_lock(&ip->i_flags_lock);
@@ -245,7 +245,7 @@ xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline int
-xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned long flags)
 {
 	int ret;
 
@@ -258,7 +258,7 @@ xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline int
-xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned long flags)
 {
 	int ret;
 

