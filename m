Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628781;
	b=FCt/H3DjSIaKkpeIAw/42sSaV/CZltwaeX0NSIJJdD4ws+j8Pnndc3zw7sYJiwvsHo6l
	 ZEG2udQghLk9Z1uJPiHIsdRwSxnHLNAjoufjswrv45bPWdAlpx30NRgnjVte0sfsWK1kg
	 Z6eyiNIogWzPiVbpu3QsRkUpVIb/i2EosShNhqQV2dRABCybW8M8m5k+qUGpA1bbc4V9d
	 JHtUadupN/71Cv1OQXz/gkbWR40WJXGOfRNUIXGjG7+kHi7qLfDmM0PeiEwt21Zfuhatx
	 WS516pVPsgzVUh5d6zMJ95DuXH3qNYyiDoukh25hxQc1r6FQNwHuxFiypVjWJyLD07A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CZMVuuW8Z0sZJ+4aQAdQdzXUhgbrzBTT6X7icn2CvQs=;
	b=nPae8Y/b4a0r49uEFKBT0bkzT19UKzUzK2o+6urcKHhgJdsVyvNYG9+2hdq2rBNnCKZS
	 42aNBn02gXwEQ3a/BY+kh1eybkqDF+nRHtc6vOtfFHUzuJJMtlZqGClEWEfvAeyKv02+i
	 SiorjXc8FTEyt3zJ6FGw1pzjnKIgOBIq0cGtCix/d4L7gxNB5V1C+fvahx4BDM827p5qn
	 tQkHPdgHN/LRJRJRL+/K5O9nlYkCEoauZa9GUYhXzrlQO9glemgrYjeMPbGRusVyU8pBP
	 zDhslxjeJgyXm8WLTQdjKsgBA5dleKMmrn+awIBK+hu8Uic3XtYTgSCbQqhBfQlZHKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUNnJIS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B55606A321;
	Wed, 25 Nov 2026 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUNnJIS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779801F000CA;
	Wed, 25 Nov 2026 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628780;
	bh=CZMVuuW8Z0sZJ+4aQAdQdzXUhgbrzBTT6X7icn2CvQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUNnJIS4rVyaQunswSKTxipnPr62OzyIrx5hI3OyVeJz5DItVwoZ8FskEVPL/mWht
	 maAyYnzZNyBf5auwxI2bAXBcJg+jTxpx5RraQbsNqLzQC29jY6qb5/bbB/D9wdfsg5
	 Fb7irujXGZDAWz1Hc1eqC2t0yA+iqjSpYFjhvn8k8IOUnJj+Zlub5h4JG8ST80oE5g
	 fJvpnihCwtdq6Ea0/ibzedEmOo3Kq6AAECs5Tk43NuSXHCVsEPJkiuy7alb6Ubv6ep
	 i485jz4x6OxIKMSGKlmsgNEqYT/pdpBPCl1aLBj8isoocILXUZj6TZq/SR/bSSe3E9
	 MZEyInZaHJ3zQ==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] xfs: force all shared extent swap to use rmap shared path
Date: Wed, 25 Nov 2026 18:46:00 +0100
Message-ID: <20261125174607.135959-3-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125174607.135959-1-cem@kernel.org>
References: <20261125174607.135959-1-cem@kernel.org>
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
---
V3: Remove redundant code I forgot to remove on V2...

V2: Use a transaction roll when setting reflink flag to the inodes if we
need to do update flags. I was initially avoiding doing so but seems
like any attempt to fix it without logging the change always risks to
leave a timebomb behind.

 fs/xfs/xfs_bmap_util.c | 60 +++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73e7db3203c0..4808bb728a95 100644
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
@@ -1713,14 +1739,6 @@ xfs_swap_extents(
 	if (error)
 		goto out_trans_cancel;
 
-	/* Either inode may now own shared blocks; flag both, with CoW forks. */
-	if ((ip->i_diflags2 | tip->i_diflags2) & XFS_DIFLAG2_REFLINK) {
-		ip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
-		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
-		xfs_ifork_init_cow(ip);
-		xfs_ifork_init_cow(tip);
-	}
-
 	/* Swap the cow forks. */
 	if (xfs_has_reflink(mp)) {
 		ASSERT(!ip->i_cowfp ||
-- 
2.56.1

