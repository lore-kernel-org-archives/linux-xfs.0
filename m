Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3793F825F;
	Thu, 18 Jun 2026 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790338; cv=none; b=XRU1niZzGw3rOoVnvINFky5XWdfKtbcs1cuA5A+6PX9U49lrdhurUocFfcldPbwOcWiNL3FgCJBkysY1Wxp0vtN0KgoOfn/X+41XCNwE2EhUbwHBfbMBJon3LSIxQu4A6k5KX0f8aSvd6lkdw/Wsk9UB7HR4SiCw6bA5cOwgSmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790338; c=relaxed/simple;
	bh=K9Zz/7v26SvrB4zXq9MpOsa+2jzsrbDUio3lztW657M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PxF5J9ZxaZj9agv4E90OTc12IaPiHI/2ynETMxJU58qsHd6q9m5xkyoIPS0GpO+rAHHV4HQKChzHgNllx4Lvlx14y47Q1KE2yGyQ6d6ZMh/pJwlOVyWlW3KbaSYekNTE9z/kazaPPPla5F4r2uxnFkvCzZoyF4Jr6MRZ2lxOZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HakXRBOt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HakXRBOt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Apv4zh6EbP8jKEdx2cIAOflIjRa/LWfrNneWGMpi0Dk=; b=HakXRBOt2S5bYMpCHGPmmM/6+G
	Td0T8NyNgMRAwT2CtzuHUpKXDY5b2QbvlJhvJ63VE3DmC8shn4AAoLJds7ErSQL3cwvAFB7Ieh72l
	edQLD74FjuUq90xI7XfsAhgDvVxWie0cTIMPYAoKrfpALKu94F9vrUAiJO55SK5Vf5GgjluVbVR8j
	+SoyrPWUXNcsW31JNxcx+2YRVfxOHW4R7oGUiuVLpXG7FIczPs5CCcpHtCAJQpCdbmyC+oT3+tQW4
	arBby773G/mGpxw673IL7uy6+cEnHIvZs2txg429grlM3T6D56wkp6W4yc4TJNW18i5BcaIJpDXXc
	t+rrCNXA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waD3m-00000001NwY-0HTo;
	Thu, 18 Jun 2026 13:45:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove the v2log group
Date: Thu, 18 Jun 2026 15:45:28 +0200
Message-ID: <20260618134528.237508-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

v2log have been the default for more than a decade.  Merge all xfs log
tests into the log group instead of splitting them up (with a lot of
overlap).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 doc/group-names.txt | 1 -
 tests/generic/054   | 2 +-
 tests/generic/055   | 2 +-
 tests/xfs/095       | 2 +-
 tests/xfs/119       | 2 +-
 tests/xfs/135       | 2 +-
 tests/xfs/137       | 2 +-
 7 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/doc/group-names.txt b/doc/group-names.txt
index 158f84d36d31..424e2c4a1ca6 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -142,7 +142,6 @@ union			tests from the unionmount test suite
 unlink			O_TMPFILE unlinked files
 unreliable_in_parallel	randomly fail when run in parallel with other tests
 unshare			fallocate FALLOC_FL_UNSHARE_RANGE
-v2log			XFS v2 log format tests
 verity			fsverity
 volume			btrfs volume management
 whiteout		overlayfs whiteout functionality
diff --git a/tests/generic/054 b/tests/generic/054
index 0649b25930c6..f6eb8975b32e 100755
--- a/tests/generic/054
+++ b/tests/generic/054
@@ -9,7 +9,7 @@
 # In another qa test we can do more e.g. use fsstress.
 #
 . ./common/preamble
-_begin_fstest shutdown log v2log auto
+_begin_fstest shutdown log auto
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/generic/055 b/tests/generic/055
index e57f95faf897..f87fd7fb1850 100755
--- a/tests/generic/055
+++ b/tests/generic/055
@@ -9,7 +9,7 @@
 # * also can interrupt metadata with godown
 #
 . ./common/preamble
-_begin_fstest shutdown log v2log auto quota stress
+_begin_fstest shutdown log auto quota stress
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/095 b/tests/xfs/095
index da0d2ae4bb57..ab2ccfc7361c 100755
--- a/tests/xfs/095
+++ b/tests/xfs/095
@@ -7,7 +7,7 @@
 # Test upgrading the XFS log to v2
 #
 . ./common/preamble
-_begin_fstest log v2log auto
+_begin_fstest log auto
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/119 b/tests/xfs/119
index 7c1cd6a50ce5..e44d5a996a96 100755
--- a/tests/xfs/119
+++ b/tests/xfs/119
@@ -9,7 +9,7 @@
 # This can hang when things aren't working
 #
 . ./common/preamble
-_begin_fstest log v2log auto freeze
+_begin_fstest log auto freeze
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/135 b/tests/xfs/135
index ec0b54ab45c3..e8c490a0c13f 100755
--- a/tests/xfs/135
+++ b/tests/xfs/135
@@ -9,7 +9,7 @@
 # and verified with xfs_logprint.
 #
 . ./common/preamble
-_begin_fstest auto logprint quick v2log
+_begin_fstest auto logprint quick log
 
 # Import common functions.
 . ./common/log
diff --git a/tests/xfs/137 b/tests/xfs/137
index d97942bf671a..20d46f439b8a 100755
--- a/tests/xfs/137
+++ b/tests/xfs/137
@@ -12,7 +12,7 @@
 # xfs_repair detect the problem.
 #
 . ./common/preamble
-_begin_fstest auto metadata v2log
+_begin_fstest auto metadata log
 
 # Import common functions.
 
-- 
2.53.0

