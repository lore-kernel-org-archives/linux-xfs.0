Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BC21E4A2;
	Mon, 29 Jul 2024 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722262829; cv=none; b=Gu6dSB5EblyYEPmCEE26IaQQ6DF6camCsE0bruq4TJEEfvP/xd8bVGvk69Q92BP1B4Cn+KqBRCbri2k+mHSLv/fEc0Ks032p0oVnd2Q8kgg6KOSEaVeGkooM/VFjXf/Lml8Vn30Do/W/819thcWo4dBzqS7RelhMdFkmkg7k+Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722262829; c=relaxed/simple;
	bh=s3KPtMyfDHTQx4hSXpmLY0LZKHCfrkDAnOouDtljBTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VwGP+eE3os5J7gNoK2XM94gkhzgjzKsBizjsCNoH0c8ru2sgRYxUcgERvT4c3eMZicWtzkailkiuq1UV0YdBnqG3TF6ZCpvfCKHwUyzCMsFSNU5Kp4gFhs+SNeq7gatuF07iWxJqA0fNW5WixORVzFhN6He8jlfI2ito1CyKNfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xj1JwYL/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xj1JwYL/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RCTs1ZUJhgxFYl+QLJ2yGZxAvgUX3GFd+e0yDZfbn7o=; b=Xj1JwYL/LVFqiruNfKbTk5f5VH
	F/Fc7BSEIdK9D7FVi0iE+jO0UQ/3gHyol3LC1kITuKeBWqmlGEEkzjBpyF2Fz6wNN6mMAQbM78tma
	19aUtpTTjRgOkuVCK+oNtP88k0E6h2enE0B7HTKyUi2lYfpaxsVj6H7tzO2c/es/r5qtSEZtOYYsT
	eN4JwLsgz4rbzlNqYVuHTg9hUvKCJ5wN9z0Zi3i+QiFUSWqESFreG/KE7iPDUULHVuOsRd2y99bJk
	dvEoTNiudFAQe1tUFQiBx5/m0l0Wpi9PEC7n+RiPC3bGEu4ztMvpEOL+UI1i+9vsN7teOvflxPViH
	9TI+Ylkg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYREh-0000000BXXh-47ea;
	Mon, 29 Jul 2024 14:20:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] add more tests to the growfs group
Date: Mon, 29 Jul 2024 07:20:26 -0700
Message-ID: <20240729142027.430744-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs/127 xfs/233 exercises growfs behavior, add them to the growfs group.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/127 | 2 +-
 tests/xfs/233 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/127 b/tests/xfs/127
index b690ab0d5..4f008efdb 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -7,7 +7,7 @@
 # Tests xfs_growfs on a reflinked filesystem
 #
 . ./common/preamble
-_begin_fstest auto quick clone
+_begin_fstest auto quick clone growfs
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/233 b/tests/xfs/233
index 1f691e20f..5d2c10e7d 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -7,7 +7,7 @@
 # Tests xfs_growfs on a rmapbt filesystem
 #
 . ./common/preamble
-_begin_fstest auto quick rmap
+_begin_fstest auto quick rmap growfs
 
 # Import common functions.
 . ./common/filter
-- 
2.43.0

