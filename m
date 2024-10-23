Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF41136331;
	Wed, 23 Oct 2024 10:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729679977; cv=none; b=O9Sfn7h3d9PFrZ9iJePs3x2/zHzbTKV5GgjlCMm+DoC/h6IXU03DBWFGFVGXwQWGvUbjtYtBL2cHn0qh+VEnoOPhBUYoC9vKP+iPPZSScwGDqC76LFE30uYHRMw1oET2jb8/f4TueGCj/iLw9jg4HFgfAsTAy9cp6+Z2EgnlXTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729679977; c=relaxed/simple;
	bh=Khnq2z+739cMbwfu27+o8gOWmPSgJ0FM4gCWfU1EGeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rfFrPCPlxnGyxZDn8RmG2iojazELHCZwAtYkLZUZMxWkpffS+yLPEsvPo8iiHoM9o6+A6MuVnaTN8n4SXAfx7q2nyU1wBW2wMDiMKiReNcbeNKr6JcdnlOdf3ngUXI/GSCUJL9+P+nMZ0yaS93RxflL58Z/xnd4x4j7P52OnH5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hhZUxxZl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hhZUxxZl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=n8ueNHK4ZpUivyR7Im3fE9aX3DpyAud3m3ChLRjWBnY=; b=hhZUxxZlW+qGisyDIej2ensfCO
	5VkEpdQ0XeM/Xsp9hmjcw5NGTTkE6VHt+FXqdMbsvbwDpHLdV84HZvCkzAyR7eJ49Aw1pH2mOMA21
	OQ2j8N8cc/1pEukH4rE9P8zR76E8xERf7wl3ehfcpfDoY0VwnwEHNZ+28HuXYsNnqIJmsJEFWRfgd
	balYne2P6L97NAoRI8LTWbj3GHBr0tZ8fwErDjHwlZhFlZZZ8AWZ3+UValG9+3e1Z1AYgA1ILQoJk
	mCH/tlLxA474CflbPt+l1LAQG+U5yyC6ginoF+zn2K7gnFXlxFW/2afQVy8Z2SksdcD1l90HF2PMj
	I8gCe3jA==;
Received: from 2a02-8389-2341-5b80-8c6c-e123-fc47-94a5.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c6c:e123:fc47:94a5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t3Ym5-0000000E0yQ-2i2O;
	Wed, 23 Oct 2024 10:39:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs: remove the post-EOF prealloc tests from the auto and quick groups
Date: Wed, 23 Oct 2024 12:39:30 +0200
Message-ID: <20241023103930.432190-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These fail for various non-default configs like DAX, alwayscow and
small block sizes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/629 | 2 +-
 tests/xfs/630 | 2 +-
 tests/xfs/631 | 2 +-
 tests/xfs/632 | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/629 b/tests/xfs/629
index 58beedc03a8b..e2f5af085b5f 100755
--- a/tests/xfs/629
+++ b/tests/xfs/629
@@ -8,7 +8,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto quick prealloc rw
+_begin_fstest prealloc rw
 
 . ./common/filter
 
diff --git a/tests/xfs/630 b/tests/xfs/630
index 939d8a4ac37f..df7ca60111d6 100755
--- a/tests/xfs/630
+++ b/tests/xfs/630
@@ -8,7 +8,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto quick prealloc rw
+_begin_fstest prealloc rw
 
 . ./common/filter
 
diff --git a/tests/xfs/631 b/tests/xfs/631
index 55a74297918a..1e50bc033f7c 100755
--- a/tests/xfs/631
+++ b/tests/xfs/631
@@ -8,7 +8,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto quick prealloc rw
+_begin_fstest prealloc rw
 
 . ./common/filter
 
diff --git a/tests/xfs/632 b/tests/xfs/632
index 61041d45a706..3b1c61fdc129 100755
--- a/tests/xfs/632
+++ b/tests/xfs/632
@@ -9,7 +9,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto prealloc rw
+_begin_fstest prealloc rw
 
 . ./common/filter
 
-- 
2.45.2

