Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283EB274B23
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 05:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780895096; cv=none; b=V4OyjoCe2QfFLq+0KFoT/W9DBr8a3f/wKMHHuJQcaFv0KFVpuVHEkq6Zv8ZHRokILqYXcdMT0ZiD991kzR7teTiA6O1zl8Ez94p54MdiMs/KnJA9t/fZSc+BwPNbpIL+SgDfIX9MMFrj6q8YGA/Nn7a3XpYvKYD3RTIBKpA40IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780895096; c=relaxed/simple;
	bh=yDKU6kGlrcd0AyzYCAzwxeXptDo7g0Gkdp78m99326s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K29BJRRJPuygP4ZNeRynoUANSQULkde+AriDAmjdmLV9sJpiM1o2P6hxLOySA7DTWi6xOB4m5WDlH/5wTQsuPIb/6ufvvIXttDJwz0MF1nX+8lypqMReHcJAQbddxIDigcNARwh5zwniIUj2JWzHqJOeZdiAk/RJ5cuoEl9K9Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q93UdRYJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q93UdRYJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7ep/qWfWmnykXcH0a9730TQk8nkuRdKtTPmbwpD8QY8=; b=q93UdRYJK+ziOq7LS8M0IzFiOm
	SYE8AB7OMfxMebqYRZVQvu7Qs2G/DzJz+QtreCX/o1cSmX9bMFe0YNidhlHklDySXnD+MepXFwC8F
	I7S6jAMTLeQ7jmyUdIto3yvDuMdoYbUo+4cR3c0mK6ll82KT3Ksk/0vWcPGSRjpp/gF5zu38MybXh
	S8j4LyJVGGwlx+cMnfM5xLXbcXIoxORXu+e1JiD2PHpJ1hkeAb8I/B4P02aCxeoS5bryadUGpIO3+
	BQVgpyKBYQIrCwyvFR09Ig3zMHjHWBgmOjJY2/aItkGj+tSmrimZcYv27t5zL7g3SL2+UDHeFRTJ4
	BsKKfrxA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWSAP-00000002oon-3RFD;
	Mon, 08 Jun 2026 05:04:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: move XFS_LSN_CMP to xfs_log_format.h
Date: Mon,  8 Jun 2026 07:04:51 +0200
Message-ID: <20260608050451.1203492-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Because CYCLE_LSN/BLOCK_LSN are defined in xfs_log_format.h, XFS_LSN_CMP
forces a xfs_log_format.h dependency in xfs_log.h.  Move XFS_LSN_CMP
to xfs_log_format.h and drop the macro/inline indirection to clean up
our header mess a little bit.

This also helps xfsprogs, which doesn't have xfs_log.h, but needs
XFS_LSN_CMP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 13 +++++++++++++
 fs/xfs/libxfs/xfs_parent.c     |  1 -
 fs/xfs/xfs_log.h               | 17 -----------------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 3f5a24dda907..a4e1b3eb425c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -52,6 +52,19 @@ typedef uint32_t xlog_tid_t;
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
 
+/*
+ * By comparing each component, we don't have to worry about extra endian issues
+ * in treating two 32 bit numbers as one 64 bit number
+ */
+static inline xfs_lsn_t XFS_LSN_CMP(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
+{
+	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
+		return CYCLE_LSN(lsn1) < CYCLE_LSN(lsn2) ? -999 : 999;
+	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
+		return BLOCK_LSN(lsn1) < BLOCK_LSN(lsn2) ? -999 : 999;
+	return 0;
+}
+
 /* this is used in a spot where we might otherwise double-endian-flip */
 #define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
 
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 3509cc4b2175..a902d6871ea0 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -23,7 +23,6 @@
 #include "xfs_attr_sf.h"
 #include "xfs_bmap.h"
 #include "xfs_defer.h"
-#include "xfs_log.h"
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 0f23812b0b31..ca66429bf6c9 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -80,23 +80,6 @@ xlog_format_copy(
 	return buf;
 }
 
-/*
- * By comparing each component, we don't have to worry about extra
- * endian issues in treating two 32 bit numbers as one 64 bit number
- */
-static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
-{
-	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
-		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
-
-	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
-		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
-
-	return 0;
-}
-
-#define	XFS_LSN_CMP(x,y) _lsn_cmp(x,y)
-
 /*
  * Flags to xfs_log_force()
  *
-- 
2.53.0

