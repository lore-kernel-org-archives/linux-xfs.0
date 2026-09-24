Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641D745D5C2
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244419; cv=none; b=qpk0XhfA84EKRBEFbu6jTq1sRE3yjIekCoQfrK9+GzIXGE3+H6oQGVO54z0tQiQjMxpQWedpbwwc5ZkagjuoAykww40WrS5m9gpDQ9dK6QxeqmoRxpifsxEEFvwx3sn6Q7n1Yp1ZgEqKwq6kVdCZZ+q4XabFem5+Ixo6hAH5XZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244419; c=relaxed/simple;
	bh=GtupBUTWQQI/YphRj3//dgZoLOeZAA12hRrh3wv9Yg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOe1izvAUFCkmCRwu5M/8n0pBRzIVLRBcGX0ntrBD2Vz8Vne5bFWXrzRpbhEhgDcRg9fJox3Gkoktn9jKoM4fkAw8YBicOLt50jVqGwiqr+ql9r1NLdHWZTNqGwwuli74wqiz++Wx+E1xNTAQ3Wi88SFsEDAQ+meVKiBPZHyLV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n01KQOTN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n01KQOTN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wv2JBUiV6/L9++CERhDrGkcooU679ZBP83/AIqqdpJc=; b=n01KQOTNyY7KEh5X8fP9xzQWaR
	7+mjuJfSxEEVN8uyoYbh90pQEqV9yYS3Gqx5hUvnh0GQH+ll5K89jgITXSrwhWGzc9xynJTmVGWVh
	3oyEUvD+/6Mdoz8/rzHSPYO1f2/7scdu17l67hnU+afdmC+a+DiPegsQGFiCtOT7aVqMY4Yi/9hLi
	JFldmukPbbrw0a5PYvlv2JPprEdcZEEKxktY+H9l0ZEZcbuME8zI/++vm1OcTRXJ+nfB9AtGVFjZ4
	jSZC/dq0BO0/uC3JnRUEKRc3rEC7KYbx/KOy0zjZw9tTdZPxlzvtqDmeIA2h3V6WgF7iljJ43ZL31
	LqUIpKYw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLl-0000000AfRs-3y0m;
	Thu, 24 Sep 2026 10:06:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 22/32] FIXUP
Date: Thu, 24 Sep 2026 12:04:12 +0200
Message-ID: <20260924100512.2733748-23-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

---
 libxfs/Makefile       | 2 ++
 libxfs/xfs_platform.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 9795982b0e83..03e50ad42bed 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -67,6 +67,7 @@ HFILES = \
 	xfs_rtbitmap.h \
 	xfs_rtgroup.h \
 	xfs_rtrmap_btree.h \
+	xfs_rtcsumfile.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
@@ -139,6 +140,7 @@ CFILES = buf_mem.c \
 	xfs_rtbitmap.c \
 	xfs_rtgroup.c \
 	xfs_rtrmap_btree.c \
+	xfs_rtcsumfile.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
 	xfs_trans_inode.c \
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index d9cfcec4c1a0..1613dcf07986 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -64,6 +64,7 @@
 
 #include "xfs_fs.h"
 #include "libfrog/crc32c.h"
+#include "libfrog/crc64.h"
 
 #include <sys/xattr.h>
 
-- 
2.53.0

