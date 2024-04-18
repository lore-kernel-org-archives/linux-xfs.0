Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0BD6A342;
	Thu, 18 Apr 2024 07:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713426068; cv=none; b=kvNEWam4mh8+Vy9QFc0Bxcgvit58jkXW+AAAROMLA6jtyIpm06lj4+LAo6216IB2Oo2VIoRNvPkE/6LQiFoWciQQZYsUk3B+MbBEFiRl9dEmmU2u4+RaZqNmexMQptGgR3j5ch8vSVoRLT1Cbe0z4j6Mp6CkeQrpik2RutMSSws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713426068; c=relaxed/simple;
	bh=CToSS6I7amLm3aUdIcGGGg8WCvN7rg7XPN2G4GFgufQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KjuKcNGfbFnAusROqOG34dXnG9EIxt3yFMEeju4/08DUumYqhZpCtMqqdQYaHRmCN4kniqtXSQ+Nkdr6RLC6CENzZZLc5h2pwNgdlxuN+N47wAsyMIL0if2k3Ar09crhBRzXT4Y7c8xVfB1PJHAE991ZzT7wHT3rvA+CLf2+R1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vGKKfNoL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vGKKfNoL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h8UtT+bq6dMZ2LljslF41Fz9WxTreNCs14K/ecsAusM=; b=vGKKfNoLi5XU+rt+20p2kIHU6z
	nLb/6OXHdPXtb+kaiGCvG4ERwNhEa8/Djv6HoBAxIH0GfirRcapjnuRwN4Be5fpquO7zDbbgIITSd
	8giEowY2pEYwnCKnfyQYoBRou28WJCuyoMtMdrz+9JKf99SKKS5XalcX5rvFWW1D+o49LuP4+DvtA
	Sb37U5yqz5B2d+1zhsnzkPIoo/ZMUZDOKXd5FowdheiUDHNS6YT+e/fZfjvHq84R+JXSa5uiLJ62E
	7hgLusn8rHCl/PjoEck2/rEgfbmUTuFBtauFMD8J+L+Bp8SlZj500dYEe55WRqvhrJeRDSXV5BZnz
	/RytaEQQ==;
Received: from 3.95.143.157.bbcs.as8758.net ([157.143.95.3] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxMOF-00000001Ilm-3kAJ;
	Thu, 18 Apr 2024 07:41:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 4/5] xfs/{158,160}: split out v4 tests
Date: Thu, 18 Apr 2024 09:40:45 +0200
Message-Id: <20240418074046.2326450-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240418074046.2326450-1-hch@lst.de>
References: <20240418074046.2326450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the subtests that check we can't upgrade v4 file systems to a
separate test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/158     |  5 -----
 tests/xfs/158.out |  3 ---
 tests/xfs/160     |  5 -----
 tests/xfs/160.out |  3 ---
 tests/xfs/612     | 32 ++++++++++++++++++++++++++++++++
 tests/xfs/612.out |  7 +++++++
 6 files changed, 39 insertions(+), 16 deletions(-)
 create mode 100755 tests/xfs/612
 create mode 100644 tests/xfs/612.out

diff --git a/tests/xfs/158 b/tests/xfs/158
index 4440adf6e..9f03eb528 100755
--- a/tests/xfs/158
+++ b/tests/xfs/158
@@ -23,11 +23,6 @@ _require_xfs_repair_upgrade inobtcount
 _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
 	echo "Should not be able to format with inobtcount but not finobt."
 
-# Make sure we can't upgrade a V4 filesystem
-_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
-_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
-_check_scratch_xfs_features INOBTCNT
-
 # Make sure we can't upgrade a filesystem to inobtcount without finobt.
 _scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
 _scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
diff --git a/tests/xfs/158.out b/tests/xfs/158.out
index 5461031a3..3bc043e43 100644
--- a/tests/xfs/158.out
+++ b/tests/xfs/158.out
@@ -1,8 +1,5 @@
 QA output created by 158
 Running xfs_repair to upgrade filesystem.
-Inode btree count feature only supported on V5 filesystems.
-FEATURES: INOBTCNT:NO
-Running xfs_repair to upgrade filesystem.
 Inode btree count feature requires free inode btree.
 FEATURES: INOBTCNT:NO
 Fail partway through upgrading
diff --git a/tests/xfs/160 b/tests/xfs/160
index 399fe4bcf..d11eaba3c 100755
--- a/tests/xfs/160
+++ b/tests/xfs/160
@@ -22,11 +22,6 @@ _require_xfs_repair_upgrade bigtime
 date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
 	_notrun "Userspace does not support dates past 2038."
 
-# Make sure we can't upgrade a V4 filesystem
-_scratch_mkfs -m crc=0 >> $seqres.full
-_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
-_check_scratch_xfs_features BIGTIME
-
 # Make sure we're required to specify a feature status
 _scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
 _scratch_xfs_admin -O bigtime 2>> $seqres.full
diff --git a/tests/xfs/160.out b/tests/xfs/160.out
index 58fdd68da..9a7647f25 100644
--- a/tests/xfs/160.out
+++ b/tests/xfs/160.out
@@ -1,8 +1,5 @@
 QA output created by 160
 Running xfs_repair to upgrade filesystem.
-Large timestamp feature only supported on V5 filesystems.
-FEATURES: BIGTIME:NO
-Running xfs_repair to upgrade filesystem.
 Running xfs_repair to upgrade filesystem.
 Adding inode btree counts to filesystem.
 Adding large timestamp support to filesystem.
diff --git a/tests/xfs/612 b/tests/xfs/612
new file mode 100755
index 000000000..4ae4d3977
--- /dev/null
+++ b/tests/xfs/612
@@ -0,0 +1,32 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 612
+# 
+# Check that we can upgrade v5 only features on a v4 file system
+
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_inobtcount
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_xfs_repair_upgrade inobtcount
+
+# Make sure we can't upgrade to inobt on a V4 filesystem
+_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+_check_scratch_xfs_features INOBTCNT
+
+# Make sure we can't upgrade to bigtim on a V4 filesystem
+_scratch_mkfs -m crc=0 >> $seqres.full
+_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
+_check_scratch_xfs_features BIGTIME
+
+status=0
+exit
diff --git a/tests/xfs/612.out b/tests/xfs/612.out
new file mode 100644
index 000000000..6908c15f8
--- /dev/null
+++ b/tests/xfs/612.out
@@ -0,0 +1,7 @@
+QA output created by 612
+Running xfs_repair to upgrade filesystem.
+Inode btree count feature only supported on V5 filesystems.
+FEATURES: INOBTCNT:NO
+Running xfs_repair to upgrade filesystem.
+Large timestamp feature only supported on V5 filesystems.
+FEATURES: BIGTIME:NO
-- 
2.39.2

