Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F58E246784;
	Fri, 16 Oct 2026 09:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142502; cv=none; b=K0PxNiF+UjciPiRfrJDJVQLXJ0zfE6cDeoOcbirS7bMhATKPYWr0LTlKG1ROdpe1SazFj+c0yDTgNpNQV5J7quHSR2C8SofPWXKvONTICv9MzdZZ/Y8prY2fXUH2n8bHXIf/1pPImWhu80KTEfcJ7QfMKjG4N+Z99R/YTxW9T2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142502; c=relaxed/simple;
	bh=+sjXJslH7VIEF9kQ28vk39tD3ASFN4q1ltHf5mgukHM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cYBRJZX5Aww3rUYe41SoHLXYkTBw3MW0A3Kc+gHlYIoGcJs5+vhxZVs9nCbYkPNA6mfOhY2PQx0MFpTdrqzrI9qb1e45ZJW95dMucd9wrL4tLvS5/ZIUU3xzIfecAcaOhJQC4wFsTlgaKslyROLKFOTDn2m9ztPBa+bvzNz5ZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id ACA0B180F2D2;
	Fri, 16 Oct 2026 11:21:26 +0200 (CEST)
Received: from trufa.redhat.corp ([172.16.31.30])
	by mx0.herbolt.com with ESMTPSA
	id BPr4Hpbs0Wo3MQoAKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 16 Oct 2026 11:21:26 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v2] lib/random.c fix undefined behavior on signed integer overflow.
Date: Fri, 16 Oct 2026 11:21:11 +0200
Message-ID: <20261016092111.296275-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The random.c now expects that signed integer to overflow and
triggers the  ^MASK branch. But signed int overflow is undefined
behavior and GCC can optimize this branch out with certain
CFLAGS/LDFLAGS. And cleaning up the dead code.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 lib/random.c | 34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/lib/random.c b/lib/random.c
index d5c81be817c8..558da4e6888d 100644
--- a/lib/random.c
+++ b/lib/random.c
@@ -162,38 +162,18 @@ static int32_t mt [128] =   {
           69069
 		};
 
-double 
-_random (int32_t is [2])
-{
-	int32_t it, leh, nit;
-
-	it = is [0];
-	leh = is [1];
-	if (it <= 0)	
-		it = (it + it) ^ MASK;
-	else
-		it = it + it;
-	nit = it - 1;
-/*	to ensure all-ones pattern omitted    */
-	leh = leh * mt[nit & 127] + nit;
-	is [0] = it;    is [1] = leh;
-	if (leh < 0) leh = ~leh;
-	return (SCALE * ((int32_t) (leh | 1)));
-}
-
-
-
 int32_t 
 _irandm (int32_t is [2])
 {
-	int32_t it, leh, nit;
-
+	int32_t it, leh, nit, apply_mask;
 	it = is [0];
 	leh = is [1];
-	if (it <= 0)	
-		it = (it + it) ^ MASK;
-	else
-		it = it + it;
+
+/* 	evaluate on original value - no UB here */
+	apply_mask = (it <= 0);
+/*	double via unsigned shift - well-defined */
+	it = (unsigned)it << 1;
+	if (apply_mask) it ^= MASK;
 	nit = it - 1;
 /*	to ensure all-ones pattern omitted    */
 	leh = leh * mt[nit & 127] + nit;
-- 
2.56.0

