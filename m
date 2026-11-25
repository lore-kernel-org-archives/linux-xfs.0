Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613536;
	b=vLT6Q4sUl8OwHHfVpjMaJlKieyS9YiBqiTypR12P7JSWiD5pM2OQGNqyaOwlGD8EBHh/
	 /s9D6KQoAMEZAfBYFCktvTVJdI9UwDrwZ1rfbJ2eewdlG8tZkSBCz/qdFqLb3yg0ILqQT
	 RtfAmLV+rj9S5dbs1IwlE/VQDMd8MA/1JCn7+EpCYeO3XrqsYARNXBXU5aVxRcFs2nYzw
	 q/01LbZCrX4D77ts5JDy3Uq95mM8zkyHIAeWjkLWd41CQ3WGNj5p/kS9Qf9vQ1ZUZFxl5
	 CVCpQYVEgDXCoiG/c2dU2zIc2CelBIs5but/aGNNJ9w2m0s+yFHN3/JtjOM3KxM5Aiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8NBVDhTV1qfvKnsU4Rq3rt4TPOz6d+la/snH88WC83k=;
	b=XJlftPVfjoMWZk/1zBHcGrAMk58D6jndjFF1fcvktU4vaoQz74WsyhAc9uasEX9J2dE9
	 XnXypXGz0g+2C7yLV9H51dllpJ2Xl4iOyMOzRk0wmoM7EuZzz2efdrm21Su5D0nwJ3VhB
	 hjcNFzzPS8SYStEUF+Qmk0hV0qfSUtwCJU7+Zcew0eWoTMHdu39XlVYLeNF9zjSiYpiF1
	 5h5wmePlsZLMPFO92kWNtb2SmQYsUOwdrSoUnpd+dTFpqUqm9WceKOm/hg3jCzcyU3Df7
	 DueyVpgeV593TI07SY9+Ly94nsH2vcPlRC66oC1AIVxLh7LySrrM4lf1A6yFP1t9L5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dIZpvFSt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF43606A31E;
	Wed, 25 Nov 2026 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dIZpvFSt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D581F000E6;
	Wed, 25 Nov 2026 13:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613535;
	bh=8NBVDhTV1qfvKnsU4Rq3rt4TPOz6d+la/snH88WC83k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIZpvFStwHwQHPKgkBzjqUOT2IEEl2yQaZxBOv4Iq3qF0zQ6XZh8cP/nxv+E8aIHs
	 gB4NFDhOYUXmibMlyudzr+pH39lLMZukLME4v+9+dGnFG4aoLxFejR6K2WHhtJ277y
	 XllzbJ9+f7glyZfTg9eO2l+ahJd0Wj1CmecXd1XI56bZ5HThu50FIlusjM/i/X22Ys
	 l30s7nOEWwxEGTPKh4DSs5co6cPVQlryAYU5YBga7Y1a16JH++KXMdMvh3XpM/m4bh
	 qXL35j63QPU8KHxaMuPqATobPsuljiRe0CB/YRj8b+Q5m/32W3TzxSAZKggC5bSOyC
	 f297zkvmLWJnA==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH 2/2] xfs: force all shared extent swap to use rmap shared path
Date: Wed, 25 Nov 2026 14:31:47 +0100
Message-ID: <20261125133204.113558-3-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125133204.113558-1-cem@kernel.org>
References: <20261125133204.113558-1-cem@kernel.org>
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
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73e7db3203c0..4704222d9544 100644
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
 
@@ -1705,14 +1692,6 @@ xfs_swap_extents(
 	src_log_flags = XFS_ILOG_CORE;
 	target_log_flags = XFS_ILOG_CORE;
 
-	if (xfs_has_rmapbt(mp))
-		error = xfs_swap_extent_rmap(&tp, ip, tip);
-	else
-		error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
-				&target_log_flags);
-	if (error)
-		goto out_trans_cancel;
-
 	/* Either inode may now own shared blocks; flag both, with CoW forks. */
 	if ((ip->i_diflags2 | tip->i_diflags2) & XFS_DIFLAG2_REFLINK) {
 		ip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
@@ -1721,6 +1700,14 @@ xfs_swap_extents(
 		xfs_ifork_init_cow(tip);
 	}
 
+	if (xfs_has_rmapbt(mp))
+		error = xfs_swap_extent_rmap(&tp, ip, tip);
+	else
+		error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
+				&target_log_flags);
+	if (error)
+		goto out_trans_cancel;
+
 	/* Swap the cow forks. */
 	if (xfs_has_reflink(mp)) {
 		ASSERT(!ip->i_cowfp ||
-- 
2.56.1

