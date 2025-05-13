Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F3322EE5;
	Tue, 13 May 2025 05:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747113581; cv=none; b=a6+d9CHWb9JLBkxXAL/gwUulw6kXgDqk1SXKVx6U49MfkBqJqLxdpaSoRpzV82BXNWIaTg4rv+wL+COXHZBDqRsw5yGmyOUo1A4wwj3vJ7/YZpQ7TPz9DfgpMpitRDD5+znWKowj86BlhevUJx71Gk23BiauCWjBJYB/3MJe240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747113581; c=relaxed/simple;
	bh=lfsESqOgoRwfBiHv60b9CNrEZOrAqxPrD0gPOpU19+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z234IGW6SPiPAGge4Dq0jkqhmzVWblXoVqNPGCp06GkPc6Skm6sYeHegS7PBtUPulzHuuJRv5RlGhJukajkhCrKDdsoF1ORtzz1cE81eZQ7Fk/p05aiarQ3YoAeAiUmQJw++CGS2683IMjMHDjkFZqFYBHsCamD9G4IdGREBJH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yn4/2bYe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yn4/2bYe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=03K7m5a1W13fmTRWGaI0aim1lcedCpAINqDepMP0y3Y=; b=Yn4/2bYevrExt7x5XZ/qCZDZF0
	O15YaYQMx8fkGLspHEp7mOM262yLmG8bps8nI7RcIqlNvO/o/1cF0gtVVLdAGpG3QKh7GEE3rBDvH
	xrDbn0d3EuMlUVbX52I9pegPi/nvupTbFz/uus9dXKOVVED/nmVURdZCNmPIKcmMp+FPVpC4MlP7A
	sGGk+LNYLxj1apv88I5AHj0rRCHw74y80+b3Q+u71Y4EdGIPUDvItGdvOOgq4KZ+A4YaAyq8DPPrv
	r3MQKVwm/nbAzIn48iQ1bSbAiXF40BI28PS3UNChxUONGhEj/6RyRgZfl0D6vxgiGE3VwqjvXYPJw
	pt0RM1ng==;
Received: from 2a02-8389-2341-5b80-3c00-8f88-6e38-56f1.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3c00:8f88:6e38:56f1] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEi3F-0000000BNPY-1mBN;
	Tue, 13 May 2025 05:19:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs: skip test that want to mdrestore to block devices on zoned devices
Date: Tue, 13 May 2025 07:19:33 +0200
Message-ID: <20250513051933.752414-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

mdrestore doesn't work on zoned device, so skip tests using to
pre-populate a file system image.

This was previously papered over by requiring fallocate, which got
removed in commit eff1baf42a79 ("common/populate: drop fallocate mode 0
requirement").

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/populate |  2 +-
 common/xfs      | 14 ++++++++++++++
 tests/xfs/284   |  1 +
 tests/xfs/598   |  1 +
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index 50dc75d35259..1c0dd03e4ac7 100644
--- a/common/populate
+++ b/common/populate
@@ -19,7 +19,7 @@ _require_populate_commands() {
 	"xfs")
 		_require_command "$XFS_DB_PROG" "xfs_db"
 		_require_command "$WIPEFS_PROG" "wipefs"
-		_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
+		_require_scratch_xfs_mdrestore
 		;;
 	ext*)
 		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
diff --git a/common/xfs b/common/xfs
index 96c15f3c7bb0..4ac29a95812b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -772,6 +772,20 @@ _scratch_xfs_mdrestore()
 	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" "$@"
 }
 
+# Check if mdrestore to the scratch device is supported
+_require_scratch_xfs_mdrestore() {
+	_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
+
+	# mdrestore can't restore to zoned devices
+        _require_non_zoned_device $SCRATCH_DEV
+	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ]; then
+		_require_non_zoned_device $SCRATCH_LOGDEV
+	fi
+	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+		_require_non_zoned_device $SCRATCH_RTDEV
+	fi
+}
+
 # Do not use xfs_repair (offline fsck) to rebuild the filesystem
 _xfs_skip_offline_rebuild() {
 	touch "$RESULT_DIR/.skip_rebuild"
diff --git a/tests/xfs/284 b/tests/xfs/284
index 91c17690cabe..79bf80842234 100755
--- a/tests/xfs/284
+++ b/tests/xfs/284
@@ -27,6 +27,7 @@ _require_xfs_copy
 _require_test
 _require_scratch
 _require_no_large_scratch_dev
+_require_scratch_xfs_mdrestore
 
 function filter_mounted()
 {
diff --git a/tests/xfs/598 b/tests/xfs/598
index 20a80fcb6b91..82a9a79208ab 100755
--- a/tests/xfs/598
+++ b/tests/xfs/598
@@ -28,6 +28,7 @@ _require_test
 _require_scratch
 _require_xfs_mkfs_ciname
 _require_xfs_ciname
+_require_scratch_xfs_mdrestore
 
 _scratch_mkfs -n version=ci > $seqres.full
 _scratch_mount
-- 
2.47.2

