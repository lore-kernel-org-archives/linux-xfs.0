Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C8429CCA;
	Wed, 29 Jul 2026 07:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785310479; cv=none; b=uHBTTBSnowZmsh8C2KjvK4JNeAa/DSwIy6LQHyLxAE23MciZWHWmcrlN0ltJZFDZvZ/K1ggBAACiaajUo5Sb1/71otujDKcRsb/ADBrlRUyR4sIFAI92JoTjuhamMaJHxULbqv5Y9DN+KMV7uYUywR2ofXXhoC6zlY3qiRJNyPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785310479; c=relaxed/simple;
	bh=A0LCttk13pqUaC0VE0JIX1r3j9yy23DpPh3p3jKYdlE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QxhDS3RS8ZHksoFIO35Prornhx608hzHWkwd+Z20Etl5YQYd8MBfGIOLxQGBpd9HSclJMjU4bdxBZYWIyMnO3eUk4kg4ytQA1en7gwshBee4JL7OmeiIBZBDFehhQcefWlTVfr85CZShUgET/JE8syCAa5LZoUwKanoXOSgak+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: eaffa1e48b1f11f1aa26b74ffac11d73-20260729
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:30f8dee8-1293-4e40-bcb3-c11f79e8bca9,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:adba2af4b4b1f36301da0a0235ecfe03,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: eaffa1e48b1f11f1aa26b74ffac11d73-20260729
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1031035095; Wed, 29 Jul 2026 15:34:22 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: cem@kernel.org,
	djwong@kernel.org,
	hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH v2] xfs: check split_sectors validity before bio_split call
Date: Wed, 29 Jul 2026 15:34:18 +0800
Message-Id: <20260729073418.63750-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the split_sectors check from !split_sectors to split_sectors <= 0
to make the error handling explicit. While bio_split_rw_at() cannot return
a negative error code for the current GC I/O path (GC I/O doesn't use
REQ_ATOMIC/REQ_NOWAIT flags and has proper alignment), making the check
explicit improves code clarity and makes the intent clear.

This also makes the code more robust for future maintenance if different
I/O patterns are introduced.

Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 Change in v2:
 -Remove Fixes tag as this is not a triggerable bug,suggested by
Christoph Hellwig.
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

