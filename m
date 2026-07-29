Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636581A08AF;
	Wed, 29 Jul 2026 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306689; cv=none; b=TKKzUbCm3gNnXzFgxzEQsSBK4syHnsWwaldqR046e/58gfPAtsCgExjI7VR1oRQqbmRgmoMP8FthGevv1DrEAovA4SHB6TcwP2kWCaAJcNPUjqM5kSIpiqVbPvNidLHqkaZl+ZcmKajfWP4ykEZKGIltnFBSNHXidjtBCjlWvAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306689; c=relaxed/simple;
	bh=gUTYh0Nf+FvMntd5VMXKbgLAgeHymoh7X8wpr3EUajk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n1lBL9FYllz49FBF+HFvSX1QcyXlNz/lmaYsHThjVs7fJnfFhnOtvLklMvR//HGoGOpniOEN/rEjnuCHS8RBPfJ5CYDVJ1ObiYZ4FKXUv6ExRv9bmUFmixEyiLlIxa9yM7vV/iOWZXtjKTvIXNIPsUNZnlmSSVjU1+zHp2Wnp8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1d67b2ec8b1711f1aa26b74ffac11d73-20260729
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fc8b8ec1-0086-4275-a254-56c3f6e61208,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:f461e7ad2c77b19f132ccb11710806ba,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1d67b2ec8b1711f1aa26b74ffac11d73-20260729
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1149324875; Wed, 29 Jul 2026 14:31:21 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: cem@kernel.org,
	djwong@kernel.org,
	hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: check split_sectors validity before bio_split call
Date: Wed, 29 Jul 2026 14:31:17 +0800
Message-Id: <20260729063117.54540-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bio_split() returns ERR_PTR(-EINVAL) when called with sectors <= 0.
The current code only checks for !split_sectors (zero) but not for
negative values.

bio_split_rw_at() can return a negative error code (e.g., -EINVAL,
-EAGAIN) when the bio has alignment issues or REQ_NOWAIT is set.
A negative value bypasses the "!split_sectors" check because negative
values are non-zero.

If we proceed with a negative split_sectors, the left shift operation
(split_sectors << SECTOR_SHIFT) is undefined behavior for signed integers
in C. Even if the implementation somehow handles it, the subsequent
ALIGN_DOWN and bio_split() calls would receive invalid input.

Fix by changing the check from !split_sectors to split_sectors <= 0
immediately after bio_split_rw_at() and before any arithmetic operations.
This prevents both the negative error code propagation and the undefined
behavior from left-shifting negative values.

When NULL is returned, the caller's while loop naturally terminates,
which is the correct behavior for "cannot split" cases.

Fixes: 080d01c41d44f ("xfs: implement zoned garbage collection")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/xfs/xfs_zone_gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index f76a09130852..e00f4771e424 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -802,7 +802,7 @@ xfs_zone_gc_split_write(
 
 	split_sectors = bio_split_rw_at(&chunk->bio, lim, &nsegs,
 			lim->max_zone_append_sectors << SECTOR_SHIFT);
-	if (!split_sectors)
+	if (split_sectors <= 0)
 		return NULL;
 
 	/* ensure the split chunk is still block size aligned */
-- 
2.25.1

