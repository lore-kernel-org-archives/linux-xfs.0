Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED734F1F0
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513550; cv=none; b=Xw5kPch/EjiTYl9HqHXACabDG5xZkXN6/N4qQPRqhdvHgP9ZC52QMfgFvPepCexowy7IbyV/dsU6vWZ/XVGEbjS4VAl7n9Yu51M+nbQEPPhSs0GfBHQqaee+w+PiRIahzjm+NrPlWrB6lIIH08Ktq4N+u9Eb0GPtAMyCFM2hJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513550; c=relaxed/simple;
	bh=gGCTNVOz2SDrjMnSnDCEwbMRdSLQ8445DUhatEZqg4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JB6fwSO294sYcpzi3bn7Uk1LET7Dj26bukWfkhYMzVtKaZSeoSeQMsbHP/yKwcfFmUC37BnupnnUISWUtK2gv7Sq6/Hmxz6N04JmhKOUAcleMhrjizVhNe6ss7dLvj2Yx6YW0BjB5oPql/vJjfzqFKUNrQau/PaHfpI7Phea9Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QZDH+8Ii; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QZDH+8Ii"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6ppie2NHsZ5FCAguWyzq1Ky+Ah80JVNY2cU6pGHMgJs=; b=QZDH+8IiD8x9TLfQzXUFLzFI15
	GjUVmkWXJRYCumdA+Z+1WbERLU/CdMi/89GL0/v4aUA2ZUsH21I17MWGGIcCXrfs40hANUASnkuDh
	J/d+mGm3NTBKnyjel2YowMG4ENsARCCdslaTcv1K6XcW2vEpKnCkHO6k0pIFK0iFzfZB9Itj4vv/Y
	gwVCwX9auIYOYovgvXDiZKayMpdLI4KhE5WWCwuAtW8hZ4R/9yB0raS+EbWZK6HcwJiwYU5jzEoXg
	3d0P1D0ZOPTUPlOwe6ch6Nfly1zaEj1ywo5ShmF6Pg1sEaDQdiTNnKEITnBDLkw9ynp6WFLWhORVH
	18RKzdoA==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM84-0000000BcaK-2McQ;
	Mon, 29 Jan 2024 07:32:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/27] include: stop using SIZEOF_LONG
Date: Mon, 29 Jan 2024 08:31:52 +0100
Message-Id: <20240129073215.108519-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
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
---
 configure.ac               | 2 --
 include/platform_defs.h.in | 4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index 482b2452c..e4da95638 100644
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

