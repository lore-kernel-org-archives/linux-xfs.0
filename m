Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB20BA3F
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980082; cv=none; b=px07BK1BkCNL6473yqs963kXwX41WxyDQL7VhclV46ewPWMNsu7A53XECXFzeSwxSTF73olXDh6ylFnCwaCFwvbXAyceRQTuNlboEagPwR9g0CHvrRmo686lGJP1q6ZYsDEMKysBrwqNzk7ryAUNGMn89QkaFYzqqX3lw6lKwlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980082; c=relaxed/simple;
	bh=CHUi6T1xKZZycuZxzylHANLlcZJhKbmrEkNJZ66HaeQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fVBz49GiJB4MfpVKNIXaLAPd1fTziXdu7HNU2aUsl1YT0xeBmVCVsN8ykxYdzjmObJNf8sWxWVYJo7/1g6NJbvGVyuKv9AXECMH1JmCYKFGsS5ixvWwxcxpXDzauNCG2yKVNnQRRphK9ivybHcVSxBajRJjZ/y6Nomzr/UGPmhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xaDwoj2p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xaDwoj2p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vIvzgZsZoos8Y0hjCMNgp5GF4YHpiGSldziRr55us+s=; b=xaDwoj2pl2hx8n4Teky1UBSHz6
	cS+V+OAMJZ4KYmcTQBD51Uq7JVTIZkt7UuKFWDaP0RhyD3S4Gr2wj+pdzHKLhgohUDOstxoPwcdq2
	bUbclLxhc2t/IOJNLluygNAkVdRODR59t51Hxl7JqOM5yVd8n/HBQLIY6F/mjuY/fh6piy01dkQK+
	rQwtV/6MlIjOHSRJNyaY8AdlTyPyLtBGBGyFZoyQdSNFk89f5aCon7kSrNyc7/am4Wp2M4W4FJ/f4
	09+KxejJRoGnszcqPe5+LyevW3rnzWRDGnF9OY16kjiaMtVplbEzqlh2YFhLMbeagHhM8kKT7eLpJ
	xP+6g1gg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdo-0000000F9Bo-1l6y;
	Thu, 15 Feb 2024 06:54:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 04/26] include: stop using SIZEOF_LONG
Date: Thu, 15 Feb 2024 07:54:02 +0100
Message-Id: <20240215065424.2193735-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

SIZEOF_LONG together with the unused SIZEOF_CHAR_P is the last thing that
really needs a generated configuration header.  Switch to just using
sizeof(long) so that we can stop generating platform_defs.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac               | 2 --
 include/platform_defs.h.in | 4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index 9133f88d9..8e7e8b2ed 100644
--- a/configure.ac
+++ b/configure.ac
@@ -248,8 +248,6 @@ if test "$enable_lto" = "yes" && test "$have_lto" != "yes"; then
 	AC_MSG_ERROR([LTO not supported by compiler.])
 fi
 
-AC_CHECK_SIZEOF([long])
-AC_CHECK_SIZEOF([char *])
 AC_MANUAL_FORMAT
 AC_HAVE_LIBURCU_ATOMIC64
 
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 17262dcff..dce7154cd 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -26,9 +26,7 @@
 #include <urcu.h>
 
 /* long and pointer must be either 32 bit or 64 bit */
-#undef SIZEOF_LONG
-#undef SIZEOF_CHAR_P
-#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
+#define BITS_PER_LONG (sizeof(long) * CHAR_BIT)
 
 typedef unsigned short umode_t;
 
-- 
2.39.2

