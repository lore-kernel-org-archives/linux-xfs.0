Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72926466AEF;
	Tue,  6 Oct 2026 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791294745; cv=none; b=pDHNG0BfG0LUbNRwaOPAFHDxNg+odPmcGV+BGIzvO0HVY94iTOjLHmXb/O0/zu0Utz5JGr0RsG67k0WHhqsO80hISnmcaXUFdeEaSZTk6Drhbi9fpeFNiSm7WBHgBugWU4rqCkN+u9pfjXX70PT+8xLWhjAmtgvvtVcDIwgOYUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791294745; c=relaxed/simple;
	bh=EbcxPWVa8FF6hsmU5QOQwR3Xcj69xFHMOHzuqIPzfzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTJXocrTs86J+BKxV73Jnnpgx3LvVU8mVX/wHF0gtTTozQctlkpYEWLbI8E/ThPBpl4D/F6Rzoi8F06EuSwB4alcVPJmj3QLF71YYBGiHOzArIyIdEOik8gg3KTNPWHZfIj2KVT5Mp4a+ZLToR1yTR0YCYmHku/decmijJ/+raw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 246E9180F2E7;
	Tue, 06 Oct 2026 15:52:17 +0200 (CEST)
Received: from trufa.intra.herbolt.com ([172.16.31.30])
	by mx0.herbolt.com with ESMTPSA
	id NqUZMw79xGqI/wEAKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Tue, 06 Oct 2026 15:52:17 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 1/1] lib/random.c fix undefined behavior on signed integer overflow.
Date: Tue,  6 Oct 2026 15:51:52 +0200
Message-ID: <20261006135205.400485-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006135205.400485-1-lukas@herbolt.com>
References: <20261006135205.400485-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The random.c now expects that signed integer to overflow and
triggers the  ^MASK branch. But signed int overflow is undefined
behavior and GCC can optimize this branch out with certain
CFLAGS/LDFLAGS.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 lib/random.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/random.c b/lib/random.c
index d5c81be817c8..f767ed1d1337 100644
--- a/lib/random.c
+++ b/lib/random.c
@@ -186,14 +186,15 @@ _random (int32_t is [2])
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
+/* 	evaluate on original value — no UB here */
+	apply_mask = (it <= 0);
+/*	double via unsigned shift — well-defined */
+	it = (unsigned)it << 1;
+	if (apply_mask) it ^= MASK;
 	nit = it - 1;
 /*	to ensure all-ones pattern omitted    */
 	leh = leh * mt[nit & 127] + nit;
-- 
2.55.0

