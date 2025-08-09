Received: from shadowice.org (shadowice.org [95.216.8.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C9F242D89
	for <linux-xfs@vger.kernel.org>; Sat,  9 Aug 2025 17:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.8.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754761219; cv=none; b=JX+OaWEJmste1iLM0qiiV6uRBEL3Yv6T6efaSP7dhWF1gGA3rXfGU5mf4O+ZnonWnbWjvKExQzilUWLntjh9OnldI4nd29KOjFW1O+7eT/3fgUNMql6AAAlNY4NuxizgoFrNNz2Ie6LxqKYiDNsTgsHD19XEoII589YWmhT357Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754761219; c=relaxed/simple;
	bh=kcL7ttZZrj14aGULrYrUsGbgJsuc+hXGC/9jWpZBODc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rzYPDSIDZjt2WBqqB/yZhSOsfizEijl0ela1AW8kExeraHfXeGKdJBlyf58Y/VC9U9ggnG8LriIlcDsI3u1sIGFrNhxzT0laUHVqO5KPGwFYi/G21M9Cslp6jLe0i8oAA8bVq0Wcg/bvww3jwxIy420On5frPKZQAhjqTUxBz/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nixdorf.dev; spf=none smtp.mailfrom=nixdorf.dev; dkim=fail (0-bit key) header.d=nixdorf.dev header.i=@nixdorf.dev header.b=IzsPjQ+s reason="key not found in DNS"; arc=none smtp.client-ip=95.216.8.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nixdorf.dev
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=nixdorf.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=nixdorf.dev header.i=@nixdorf.dev header.b="IzsPjQ+s"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=kcL7ttZZrj14
	aGULrYrUsGbgJsuc+hXGC/9jWpZBODc=; h=cc:to:in-reply-to:references:
	subject:date:from; d=nixdorf.dev; b=IzsPjQ+s9D/iZ6qGSvUW8rD1C6cBObJ0Bd
	BNCK+KLzfSyV2ND7MtVu0U5805cpaKBQkXU1tOu6Ed6NGELI7ErBxIHvb7kH0UyblDZr4M
	nzEygrak9rTJ+3kRhujV7dJmqAbDDgZbEdrweeyrY/WO0/24JDZuR6XXo+MMrv8nVLc=
Received: from [127.0.0.1] (p5b09f668.dip0.t-ipconnect.de [91.9.246.104])
	by shadowice.org (OpenSMTPD) with ESMTPSA id bace9a04 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 9 Aug 2025 19:13:29 +0200 (CEST)
From: Johannes Nixdorf <johannes@nixdorf.dev>
Date: Sat, 09 Aug 2025 19:13:07 +0200
Subject: [PATCH 1/2] configure: Base NEED_INTERNAL_STATX on libc headers
 first
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250809-musl-fixes-v1-1-d0958fffb1af@nixdorf.dev>
References: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
In-Reply-To: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
To: XFS Development Team <linux-xfs@vger.kernel.org>
Cc: Johannes Nixdorf <johannes@nixdorf.dev>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754759609; l=1128;
 i=johannes@nixdorf.dev; s=20250722; h=from:subject:message-id;
 bh=kcL7ttZZrj14aGULrYrUsGbgJsuc+hXGC/9jWpZBODc=;
 b=PrE+GYbRThQQA32OOXffinqFWZZ17qu94eZlmgnsfDXC284us4w48liHON0oDRdXAP2aFZVHu
 YA9a29lXFlXASRxjYhA85SmT/u0w8nwT3uNuaYpMt8Ylv+buqW15bIR
X-Developer-Key: i=johannes@nixdorf.dev; a=ed25519;
 pk=6Mv9a34ZxWm/f3K6MdzLRKgty83xawuXPS5bMkbLzWs=

At compile time the libc headers are preferred, and linux/stat.h is
only included if the libc headers don't provide a definition for statx
and its types (tested on STATX_TYPE). The configure test should be
based on the same logic.

This fixes one cause for failing to compile against musl libc.

Signed-off-by: Johannes Nixdorf <johannes@nixdorf.dev>
---
 m4/package_libcdev.m4 | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index b77ac1a7580a8089b8980cae4dcdbe69540c3482..650b8b7be389dd3ead7fe15de69806ddeb294509 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -129,7 +129,15 @@ AC_DEFUN([AC_NEED_INTERNAL_STATX],
         AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_max_opt,
           ,
           need_internal_statx=yes,
-          [#include <linux/stat.h>]
+          [[
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sys/stat.h>
+
+#ifndef STATX_TYPE
+#include <linux/stat.h>
+#endif
+]]
         )
       ],need_internal_statx=yes,
       [#include <linux/stat.h>]

-- 
2.50.1

