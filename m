Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF2D4D0CE8
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349544; cv=none; b=ajrnQXVfNGLWuzbywYvelzsNa23SUH5aeq1m3WMV3lo6PgQC2Sb1aSFrAPaRI6JkmdmNLwSi6Urloi/zxF4NDDoJ2G52YFDIJQZOT+Agx3LycxP0GO5wFdEvTf6inbFSd/jemYXmdRzYlb5Sc7DqPscncnYLMAigYLPAUN+TZTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349544; c=relaxed/simple;
	bh=UFxRK/EPb4mFJbcUvUoY6jYfrL7x7+ipI7vt0Or7Xtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFidj5PC/RRla6uePgrAkUc8E6MMKiL/vuBobAj0z2sZUIJUKhQ0LY008rdcHocMJJ7Rg3u8XqJ/GU7PuVGHTXBXciQ9+I5JBr0GlUkhH2NUJrGlD4P5SWIQ0Wd7IeUniUlM8VO2n1JnlcZ3VbTT0WPKlc43av1W/rS3QuHTou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IfEuF/75; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IfEuF/75"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GxB6fUA44E6Gk5fqjffKjGc7Nrbzf9mHfne6zKnU9JI=; b=IfEuF/758ocGreIctKNE50e6CS
	FGJOi9bZTXXpBImVzVvJgJIVqyNdstlnlLUaoZaV8DLZu6+RDzrZYkG21fF/u3EXHVvmZxhAzajL+
	HW8UkENPARu7BnAba6BLKXlwa75ZtmZKltiFmk62u9ApohBR5KodL7kgi2CfXixq3KSacLcWmNEY1
	BrnpFcPdjlg9nMYV6uPUiVE7OtF3JTdLn4gbjrWRTMqOTnLf3XlM/TqLh/oAzhb1M9lbcxuLNHoNk
	zTnXkMBaD9fCQqzQemGaOoEn948fMoeK9rtClNjtJ8xtkc8VaieLhxLZckiWuUJkdxXbgMbG0DwAF
	9yTSqzMg==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7hJ-0000000DlGH-3Whz;
	Fri, 25 Sep 2026 15:18:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: include <linux/iversion.h> in xfs_platform.h
Date: Fri, 25 Sep 2026 17:18:27 +0200
Message-ID: <20260925151841.3385994-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925151841.3385994-1-hch@lst.de>
References: <20260925151841.3385994-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This removes the only non-xfs inludes from libxfs/ and thus reduces the
differences between the kernel and userspace versions of these files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c   | 2 --
 fs/xfs/libxfs/xfs_inode_util.c  | 1 -
 fs/xfs/libxfs/xfs_trans_inode.c | 2 --
 fs/xfs/xfs_platform.h           | 1 +
 4 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b82f067ca5b1..282e78e5e3e8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -20,8 +20,6 @@
 #include "xfs_health.h"
 #include "xfs_metafile.h"
 
-#include <linux/iversion.h>
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 258ac3d0d486..16c4c2ccdbb8 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include <linux/iversion.h>
 #include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 1a0fdcbf39fa..e3dca0652d26 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -15,8 +15,6 @@
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 
-#include <linux/iversion.h>
-
 /*
  * Add a locked inode to the transaction.
  *
diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 745d715b4c64..7b63ea26b186 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -50,6 +50,7 @@
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/debugfs.h>
+#include <linux/iversion.h>
 #include <asm/page.h>
 #include <asm/div64.h>
 #include <asm/param.h>
-- 
2.53.0

