Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275842;
	b=BWnqh3CdcID2jVJet5lwyuRFqdvXt5FzG0Mg/93ZxMALZDucuSBP39fIw6QKGUls/xxQ
	 KK7Cfu2pz1VWFubKoFYTn8kLJvDdFpep/xzl0GW6J5gAQSdqQ20pLQcqc68uOqsNZvKsx
	 9cqw4x3Te/SyPHEhg8Fs2WLT6QDP/znrjg1IyHCW/MJr0VMLySd65IaEomZCWUdOJVRjq
	 1CPiYtIO/doSEdeBhjLnl9bav8eXSAOTalKWdwBjKrdTzNxwlOSOLQDiK/nzGOITsiJHz
	 dUZtFIhDptLOd8L4/BaXnTyJaAqdk3DRxhVoL0TLm0MMGpoNVg318joltLvKa/0qJKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OQp0mPafTFgeX159a8LupPrIcT1v0CqVwk1A3RhozUk=;
	b=MXF9dqhr06D+5pl6S4mOHsIFImc2Ccq/UvT2M0xeeevJP9reydDrc3K01evlSge3DWK3
	 cujuKGgXmAIJYZITES24eQELMPT+4pOuLQ6pUYoevc8A9JNnN6neuH78jjyiaEbfmMVSp
	 7YPBXaqcVLKOAPYtLGQPNp6MMCCaUV9PYfaUeKcensahujmc6kQkGNhNiCDnn4itDuZEY
	 PWD8FroFEl9oBi5BGSPkvBDNHtHY3ST4FTdP99Nwp7LZ+Ew9xdSsM6fqBceR06m8GkeEo
	 pQicGB3xG0v5+o584tkkSzXhJOIl2nW7Nm6pMiuMKmntdd03eCd2thJfYRhvxq/MNcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NN33xr9J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B8E606A31D
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NN33xr9J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7651F01825;
	Thu, 29 Oct 2026 12:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275841;
	bh=OQp0mPafTFgeX159a8LupPrIcT1v0CqVwk1A3RhozUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NN33xr9JsDRRPKy7DC+34i0Qv0/9VY29AhTZ2wVH8dDNCW6L5tB/8c1uh+olWJqyB
	 n7kczAV/QpOAa5XAJSOWgwn2/+ypbkqHKS/YPa5cIyr0RVkyBi0R/a4XXGe1P8VT96
	 y5pK/dPxIFpIFskWQjjW+MaqQsRdz6lYg6QLLh1MGb1qTn6gmoc2+mQRfjrlf603fG
	 K7fhsN4aSHLRwbN2kid332a06ZUK3v7QNtUtjvqjYAFfewNxyS9+WHWCCyI+0pSZJU
	 bi3qDEs52lfygTgjo1GMTBztc7SukgKGXl9d+JB7/rujsbMlWxmsTkTcCdbzlJ5iFF
	 LhiSRrh5cYexw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 18/28] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
Date: Thu, 29 Oct 2026 13:06:15 +0100
Message-ID: <20261029120631.803074-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: aa301322f72f82f26e4ba0826018d41388ab9896

The _maxlevels_ondisk functions are used to compute the size of
in-memory btree cursors for each btree type.  Unfortunately, LOLLM
noticed that the rtrmap and rtrefcount versions of these functions
forget to account for the inode root, which means that we could access
beyond the end of the cursor given a sufficiently large btree.  Fix
this.

Fixes: 9abe03a0e4f978 ("xfs: introduce realtime refcount btree ondisk definitions")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtrefcount_btree.c | 7 +++++--
 libxfs/xfs_rtrmap_btree.c     | 4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 22acc1411aac..e2950dbe2068 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -489,8 +489,11 @@ xfs_rtrefcountbt_maxlevels_ondisk(void)
 	minrecs[0] = xfs_rtrefcountbt_block_maxrecs(blocklen, true) / 2;
 	minrecs[1] = xfs_rtrefcountbt_block_maxrecs(blocklen, false) / 2;
 
-	/* We need at most one record for every block in an rt group. */
-	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+	/*
+	 * We need at most one record for every block in an rt group, and
+	 * one extra level for the inode root.
+	 */
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS) + 1;
 }
 
 int __init
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index c264bc5651c0..0cb2113d5b40 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -716,10 +716,12 @@ xfs_rtrmapbt_maxlevels_ondisk(void)
 	 * happens, which means that we must compute the max height based on
 	 * what the btree will look like if it consumes almost all the blocks
 	 * in the data device due to maximal sharing factor.
+	 *
+	 * Add one extra level for the inode root.
 	 */
 	max_dblocks = -1U; /* max ag count */
 	max_dblocks *= XFS_MAX_CRC_AG_BLOCKS;
-	return xfs_btree_space_to_height(minrecs, max_dblocks);
+	return xfs_btree_space_to_height(minrecs, max_dblocks) + 1;
 }
 
 int __init
-- 
2.54.0

