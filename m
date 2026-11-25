Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618761;
	b=Tk7Hbgo1EWQzD7OOCgYPxP0qi7d2zlwbPN4KLN2NXmt4Ra70HvgLo6brOu+6s9SzGCVy
	 MyMwGBfWrS6nBVNAZjROkn9boSc1c9VJg0J3yG7zUK6Ek/r19ZXAgCK54+/ND1HlbLtiH
	 XsGsL2HU3S4vQK9h5dbFHquPQe5ImM06ZtwH5UlKqRcsDbRhN2LtW2AB2hDGz4i+qXIzH
	 Ixz65Tt2mtcSN9Bh/Z+ro2Dh/zyUcW1x5srrOmNPE2TJI1Ye2BGAZeHJRKg07t+2Z/eZN
	 0gJ1jHiaQXXgIeP1AYHpg7Jfzr2HIEzLLNoVeuMk4CtkT1H6bVZ6sCY4ShTPPTzIUgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G1WLTqwmSyTBUQknFI33fJPnt2uNhUBrxEVeid1yTBo=;
	b=3GOB+0ZGsmPFrHq/yMILI7ZZ1qTEGJinQ1+pfdI6jnxq+9JQjFPXA+rX2+4iwHPGgmpr
	 uxqJ0MnXEVnS/NnSOFsndY9KMmIDZuLj7+5ooKbgt+NEYggG3M83INUHkv58MKieDgrtg
	 4/QZuTpAoiP0II9LuYDzNGIiE9iL65GCi2PNXa2NYicmLADWktleDafLK6nJIRM7NdJHM
	 uzQDhX4WEqL7+avCu6iAlZduVIKBqwvISjPToS8b+wSjAfze6Poc5f2asWt/1mnTg+pfH
	 mqZ/EwCkNDs14Cuaklixxt8nbbc/zZsM4rwXs8UkyIRZ3GqPytAwdUIgErQQveOrv+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYLFxmn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5115D606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYLFxmn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C01F000D2;
	Wed, 25 Nov 2026 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795618761;
	bh=G1WLTqwmSyTBUQknFI33fJPnt2uNhUBrxEVeid1yTBo=;
	h=From:To:Cc:Subject:Date;
	b=VYLFxmn0W3sbfaoBNVjIixqmODBqtjgdRlEwwwMhlxdNz/p/ktJg3/w/mzha6VjSF
	 5nxVjNl03NbQIlN5VICU9L4hN4yM1vbbjGl24goiUS/MghaWlNQD+Sxl9YYmB0ZSyD
	 wguWldMdKXAPSnrcM/JduHpxh66XT6yXM2lkZBcW41UYpDiWfThIE7AhuUreJKFQ5c
	 9Ivm/juftiOkoJeLFK7v9jeDLOaxJlOT6iBiZKplvwXtJEUqVf/SGDLPGxo7B06DSp
	 E61p4lJfSzk6Uj/KtlB9s6iLwp2Kt7VNdnHc9q04a1RDD1pW/oxQ+a1gBLmrPJq6xc
	 XJlMUuxERj+5A==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH RFC] xfs: force all shared extent swap to use rmap shared path
Date: Wed, 25 Nov 2026 15:59:10 +0100
Message-ID: <20261125145916.120730-1-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
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
target inode has shared extents, but we should also be using the rmap_shared
path for the case when only the source inode's extent is shared.

Reported-by: Lauri Gates <lauri.gates@gmail.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

This is a second idea for the fix I sent earlier, please feel free to
ignore this patch. I am mostly interested on what Sashiko's review will
find on it.

 fs/xfs/xfs_bmap_util.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73e7db3203c0..2b6d93cb8e8f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1303,16 +1303,20 @@ xfs_swap_extent_rmap(
 	xfs_filblks_t			rlen;
 	int				nimaps;
 	uint64_t			tip_flags2;
+	uint64_t			ip_flags2;
 
 	/*
-	 * If the source file has shared blocks, we must flag the donor
-	 * file as having shared blocks so that we get the shared-block
-	 * rmap functions when we go to fix up the rmaps.  The flags
-	 * will be switch for reals later.
+	 * If either file has shared blocks, flag both files as having shared
+	 * blocks so that we get the shared-block rmap functions when we remap
+	 * the extents to their new owners.
+	 * The flags will be switch for real later.
 	 */
 	tip_flags2 = tip->i_diflags2;
-	if (ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
+	ip_flags2 = ip->i_diflags2;
+	if ((ip->i_diflags2 | tip->i_diflags2) & XFS_DIFLAG2_REFLINK) {
+		ip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
+	}
 
 	offset_fsb = 0;
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
@@ -1400,11 +1404,13 @@ xfs_swap_extent_rmap(
 	}
 
 	tip->i_diflags2 = tip_flags2;
+	ip->i_diflags2 = ip_flags2;
 	return 0;
 
 out:
 	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
 	tip->i_diflags2 = tip_flags2;
+	ip->i_diflags2 = ip_flags2;
 	return error;
 }
 
-- 
2.56.1

