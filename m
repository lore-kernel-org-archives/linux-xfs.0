Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627479;
	b=fmqdsFbrxBxu5qdzsddjJPl3eJ/WSMry/JLkJBP/VlE6+25CdFyeOmX5vpJvmv6dPbsd
	 d3B/5ykuSqY4NWBHZzuXgQqvvtOx2H0m4EBZ4TtRjQaMhsVoExO+VDaQWqE4T9sp7jSbZ
	 G1+wQUew5iCzzJWdU96I1GrqmQD7Z1zFOwYaGcw94QA91yIKTMS0VXHB8SvJpk5bYU3pS
	 q8VLgj9j3rhJz5C3JsXj0WLgxbuMNT49GiPwpOlyr7TY9eQYadMZWMlXt6alG4tl5MXfU
	 LugL/faSQxOBIXu4WniZ1CFZTKV57YyzDCX6nNoWih7ne9L+Ql3bUg4oOByXdREd0HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=M888vKappwe2zYkS19VKvXfEjrIQNvRIDcpXUkuwOIE=;
	b=c9hd9fChUMBC5G2TPdJb3Bji8fVLCLGRpbBojFP/Scxxa0CKq9rH81wqpxWYMV8kca0+
	 wB4GOjti046wPnBnkdcELtGMCRHelC4I6PYqyZqvWCi83JQ0yJJieX0mJDGCYuN5HLmdb
	 C1YYkVbMaGsBxMkCTL0qHWjlOvI8nESsO4q0P29LYxYEvZp6BQYMRXHPMpzSgI8pUMRqj
	 b+GHBxdvU8WB0z5I8oRlB1yBRx5+kh5ho4cLb/dfYAPl5mi64mzEIcpXfJBXNQr+oVKup
	 1V8tn4ymCT3Fps0dzlfmZb9PkcM6Z/mVHe0myMs7CxyT516B8TxWHvv+rtG4yk/cyqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nNA12725;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40792606A31E;
	Wed, 25 Nov 2026 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nNA12725
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94D61F000D0;
	Wed, 25 Nov 2026 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795627478;
	bh=M888vKappwe2zYkS19VKvXfEjrIQNvRIDcpXUkuwOIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNA12725Eoq3tBPslRiyD0obv1bywzrdswxrL8Z+PO1YVzyvMSJ7fvk7SJ4nTYy+t
	 WNU87wsl5cZHxXXCmLCiHOoDb/CzhKjppuw+/yO0cZJF/9OrI1gQH7lkibYAtCyllI
	 vjK8nVoAiqchxxSFfI15kmqchVQF9fiBKSmdNzxSYx5CKXyDK9h9lpYO6wpLcURtDL
	 96QRrmw+iPbWH9jN3XKkn6HWnTndD+TQZZBGpBPNHS2mRhx1Eg4/enT6nQ30OIOAnN
	 7Ak7oSMAJD46GTfluerTW0Sb4gopl72AJ1VqsbllIoJK1p1S5U0l5hYMvM8D5hAOY7
	 p7Wx7y8tVQXOA==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: force all shared extent swap to use rmap shared path
Date: Wed, 25 Nov 2026 18:24:21 +0100
Message-ID: <20261125172426.132084-3-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125172426.132084-1-cem@kernel.org>
References: <20261125172426.132084-1-cem@kernel.org>
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

From: Carlos Maiolino <cem@kernel.org>

Currently when swapping inodes with shared extents in a rmap enabled FS,
we enforce the rmap updates to use the rmap_shared path only when the
target inode has shared extents, but we should also be using the
rmap_shared path for the case when only the source inode's extent is
shared.

Reported-by: Lauri Gates <lauri.gates@gmail.com>
Fixes: 1f08af52e7c9 ("xfs: implement swapext for rmap filesystems")
Cc: <stable@vger.kernel.org>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2: Use a transaction roll when setting reflink flag to the inodes if we
need to do update flags. I was initially avoiding doing so but seems
like any attempt to fix it without logging the change always risks to
leave a timebomb behind.

 fs/xfs/xfs_bmap_util.c | 52 +++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73e7db3203c0..2ba896f65e0f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1302,17 +1302,6 @@ xfs_swap_extent_rmap(
 	xfs_filblks_t			ilen;
 	xfs_filblks_t			rlen;
 	int				nimaps;
-	uint64_t			tip_flags2;
-
-	/*
-	 * If the source file has shared blocks, we must flag the donor
-	 * file as having shared blocks so that we get the shared-block
-	 * rmap functions when we go to fix up the rmaps.  The flags
-	 * will be switch for reals later.
-	 */
-	tip_flags2 = tip->i_diflags2;
-	if (ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
-		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 
 	offset_fsb = 0;
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
@@ -1399,12 +1388,10 @@ xfs_swap_extent_rmap(
 		offset_fsb += ilen;
 	}
 
-	tip->i_diflags2 = tip_flags2;
 	return 0;
 
 out:
 	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
-	tip->i_diflags2 = tip_flags2;
 	return error;
 }
 
@@ -1547,6 +1534,41 @@ xfs_swap_change_owner(
 	return error;
 }
 
+/*
+ * If either file has shared blocks, both may own shared blocks once the extents
+ * are exchanged, so set reflink flag on both and init the CoW fork.
+ *
+ * rmap code chooses how to process each extent based on the reflink flag on the
+ * inode being remapped.  Both at runtime and when log recovery attempts to
+ * replay deferred bmap intents.
+ */
+static int
+xfs_extents_set_reflink(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	struct xfs_inode	*tip)
+{
+	int			error;
+
+	if (xfs_is_reflink_inode(ip) == xfs_is_reflink_inode(tip))
+		return 0;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
+	tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
+	xfs_ifork_init_cow(ip);
+	xfs_ifork_init_cow(tip);
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(*tpp, tip, XFS_ILOG_CORE);
+
+	error = xfs_trans_roll(tpp);
+	if (error)
+		return error;
+
+	xfs_trans_ijoin(*tpp, ip, 0);
+	xfs_trans_ijoin(*tpp, tip, 0);
+	return 0;
+}
+
 int
 xfs_swap_extents(
 	struct xfs_inode	*ip,	/* target inode */
@@ -1705,6 +1727,10 @@ xfs_swap_extents(
 	src_log_flags = XFS_ILOG_CORE;
 	target_log_flags = XFS_ILOG_CORE;
 
+	error = xfs_extents_set_reflink(&tp, ip, tip);
+	if (error)
+		goto out_trans_cancel;
+
 	if (xfs_has_rmapbt(mp))
 		error = xfs_swap_extent_rmap(&tp, ip, tip);
 	else
-- 
2.56.1

