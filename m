Received: from shadowice.org (shadowice.org [95.216.8.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45012BE7BC
	for <linux-xfs@vger.kernel.org>; Sat,  9 Aug 2025 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.8.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754761220; cv=none; b=Y8Kzt7CVWcUI8RWFA2VYBR+/TJIirzA5QETgFrGrL/J67y6nzwdy5UBzXmVu4HCIOd+egCK1nFN4Lhyf0CbL4ammGUPJXcqW9y5kPfhbTaCbYMhy1KwwhUE/fuZLDjBOGgDHfRU44uhn+3Hbl8ZcdO46IfHe77wwPi66sx39+dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754761220; c=relaxed/simple;
	bh=YsU2RVwcf0yIYDvqC7y7fx6uEUQxhIN4JEVtMwyzQZc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SGIQ0tc1ueTepwLWzuEaMzu9FW1NddaqSsTsMJqgvghNcAs0uYDbF4zg4SysYwP20gGdgYR/abj5SVwp+o/UKeSyDR4sRk++X+QJdAcTi+C3iLO74NiYEu6cML/zA7gQd6eTKusC/AvFOk/sr/yNzEEVUjpSLl6nhkNKz0OaQKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nixdorf.dev; spf=none smtp.mailfrom=nixdorf.dev; dkim=fail (0-bit key) header.d=nixdorf.dev header.i=@nixdorf.dev header.b=pFz28NVf reason="key not found in DNS"; arc=none smtp.client-ip=95.216.8.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nixdorf.dev
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=nixdorf.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=nixdorf.dev header.i=@nixdorf.dev header.b="pFz28NVf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=YsU2RVwcf0yI
	YDvqC7y7fx6uEUQxhIN4JEVtMwyzQZc=; h=cc:to:in-reply-to:references:
	subject:date:from; d=nixdorf.dev; b=pFz28NVf7nelg2cJUtgjuyHROCr/pfny75
	mo0l4TV5aHkANSIYvfbkO9gzn+wu2XP/TnaTP5E+N+GGTq2ZgKpz6oUUWlvVeIRf+X5pHB
	nxvJFdwV9HGAiHPAA4Im8ZyPLml5yLraBrktqstqgbVG5KDlTCML4vM6M1CK/Gcsmd0=
Received: from [127.0.0.1] (p5b09f668.dip0.t-ipconnect.de [91.9.246.104])
	by shadowice.org (OpenSMTPD) with ESMTPSA id 80264994 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 9 Aug 2025 19:13:30 +0200 (CEST)
From: Johannes Nixdorf <johannes@nixdorf.dev>
Date: Sat, 09 Aug 2025 19:13:08 +0200
Subject: [PATCH 2/2] libfrog: Define STATX__RESERVED if not provided by the
 system
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250809-musl-fixes-v1-2-d0958fffb1af@nixdorf.dev>
References: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
In-Reply-To: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
To: XFS Development Team <linux-xfs@vger.kernel.org>
Cc: Johannes Nixdorf <johannes@nixdorf.dev>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754759609; l=1270;
 i=johannes@nixdorf.dev; s=20250722; h=from:subject:message-id;
 bh=YsU2RVwcf0yIYDvqC7y7fx6uEUQxhIN4JEVtMwyzQZc=;
 b=FIT2NHsPuReFES7xVnxmuc/aWWW6tmaf4zRMAJKc6TWm/+w+KdBZQ0esaYBDdObzZ4W/nSd1E
 pGj4JhLqW87C4kgIDBMn/fH8tBDCvptXLQPu4BhUwJ+WuJGqYosdgrF
X-Developer-Key: i=johannes@nixdorf.dev; a=ed25519;
 pk=6Mv9a34ZxWm/f3K6MdzLRKgty83xawuXPS5bMkbLzWs=

This define is not provided by musl libc. Use the fallback that is
already provided if statx and its types (tested on STATX_TYPE) are
not defined in the general case.

This fixes one cause for failing to compile against musl libc.

Signed-off-by: Johannes Nixdorf <johannes@nixdorf.dev>
---
 libfrog/statx.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libfrog/statx.h b/libfrog/statx.h
index e11e2d8f49fa5fabf546fcdce8f4f9e2047300f2..9fb15adcfc1f765f7a242b9bfbc53d281e8dcaed 100644
--- a/libfrog/statx.h
+++ b/libfrog/statx.h
@@ -191,7 +191,6 @@ statx(
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
-#define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
 /*
  * This is deprecated, and shall remain the same value in the future.  To avoid
@@ -221,6 +220,10 @@ statx(
 
 #endif /* STATX_TYPE */
 
+#ifndef STATX__RESERVED
+#define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
+#endif
+
 #ifndef STATX_MNT_ID
 #define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
 #endif

-- 
2.50.1

