Received: from outbound.pv.icloud.com (p-west1-cluster2-host12-snip4-3.eps.apple.com [57.103.64.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60057225388
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 09:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.64.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747992589; cv=none; b=WD4m6Yb+WVN4V1qWvYQLhNITlJ8+xwtmPdWpXDULMN8sOaxcLo36ACgp/qgt10A9JSInOYkwzSYJ/NLNDdxjxKeNAgzPjB577nplB4l38j1RkRzznsXZqxqLvlkvxbRwUVqvR32pO+jJ10eloG8qXoxZ1pC+w+II9MqYknIWvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747992589; c=relaxed/simple;
	bh=OrYDeqLb9L3FqLqRI4fBgydGfOLxMj87fQRbRXEFWn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jIRdtDVAgP+KPCOy1M6S8xSKQv9i9ErO8FiDZSqXr4npmxaYvDx7uwOBmKm0c9atis3Hc4WJV3c+CDYaFVklGfHecCCOv/Cf+vzM5A8Nd7KNRz5mtm2WW2XETB/iTDlzDrWX0tTxfvffpi2vzBSn9AqBerbQ4gUY1DyzULSvH6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ai-sast.com; spf=pass smtp.mailfrom=ai-sast.com; dkim=pass (2048-bit key) header.d=ai-sast.com header.i=@ai-sast.com header.b=iLgNnpnO; arc=none smtp.client-ip=57.103.64.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ai-sast.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ai-sast.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ai-sast.com header.i=@ai-sast.com header.b="iLgNnpnO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ai-sast.com; s=sig1;
	bh=chPEdH003U8EyNzhIxlcFt/TxOyl8ajL3GUIh6TORUo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme;
	b=iLgNnpnOdzkDzLVZu/l74HuRNbsE7MyEsWMYLOBe4wZKJ9O3jyF4Z4tPalNZDDSsi
	 /CVz6xU5AlvqIP4Pn+CnargGffvQQ5G4oXQSfiBSx/Qf51I2yGRe4pGdBlLlYXvyF4
	 X5+MnsNBcn/UUxo8OinNWfa5ICCxQX6HA8vaNRWNxrYAVpGRHMVQBbxhxohhD17N+z
	 qnYE7IB1mM4uU7M/femB2tJlOAJbDzDWISk18Ci7TClnl65zsYh/c5l4AJufwRo7oC
	 UxelA/c79vJblZvG8eFmeOZAVw7O+/4goqCMbbbP1yVCu1hsWgBkX0LZ/RjDAueOQ1
	 WRJdji97R96+Q==
Received: from outbound.pv.icloud.com (localhost [127.0.0.1])
	by outbound.pv.icloud.com (Postfix) with ESMTPS id 04FF01801831;
	Fri, 23 May 2025 09:29:42 +0000 (UTC)
Received: from localhost.localdomain (pv-asmtp-me-k8s.p00.prod.me.com [17.56.9.36])
	by outbound.pv.icloud.com (Postfix) with ESMTPSA id 917EA1801EDD;
	Fri, 23 May 2025 09:29:40 +0000 (UTC)
From: Ye Chey <yechey@ai-sast.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ye Chey <yechey@ai-sast.com>
Subject: [PATCH] xfs: fix potential NULL pointer dereference in zone GC
Date: Fri, 23 May 2025 17:29:31 +0800
Message-ID: <20250523092931.16976-1-yechey@ai-sast.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 6Pywo7oa_3fGxJhUxNAAfz-4P7x8BNwc
X-Proofpoint-GUID: 6Pywo7oa_3fGxJhUxNAAfz-4P7x8BNwc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_02,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 phishscore=0 clxscore=1030 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2503310001 definitions=main-2505230082

Under memory pressure, bio_alloc_bioset() may fail and return NULL,
which could lead to a NULL pointer dereference in the zone GC code.
Add proper error handling to prevent this scenario by checking the
return value and cleaning up resources appropriately.

Signed-off-by: Ye Chey <yechey@ai-sast.com>
---
 fs/xfs/xfs_zone_gc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index d613a4094..ec87b5d6b 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -697,6 +697,11 @@ xfs_zone_gc_start_chunk(
 	}
 
 	bio = bio_alloc_bioset(bdev, 1, REQ_OP_READ, GFP_NOFS, &data->bio_set);
+	if (!bio) {
+		xfs_irele(ip);
+		xfs_open_zone_put(oz);
+		return false;
+	}
 
 	chunk = container_of(bio, struct xfs_gc_bio, bio);
 	chunk->ip = ip;
-- 
2.44.0

