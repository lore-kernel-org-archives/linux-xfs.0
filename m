Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662CE3451C8
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 19:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827227; cv=none; b=QRTrprGaBhoYR/1uzzGefZp4S4Mxy+58AUiOPlFIWAy9THWZFk9C2VNIZkOfI5WmwNGKDnXO9K/D0F/11sHMBi4d83WRjBVx4VzGRTHWOv73FtpmLx8f2bqN07CQ8jvAFwysaTMBvf/wKwmTDw+91xeW6ULxlpG9EhlWgcpJzcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827227; c=relaxed/simple;
	bh=czBAiE/4fYQsFUv5ZaYdzY2QqyntrTRTbluyQNy9IW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tl/QvMvsfX3NmVa+WcmaAXv8lLM6tWEM224zweq6iGkwRbbNMxXcX9Hl0tEjtcWsqSwiDpgtaHC4yo1UB7wsahjc85YdyykrIqZJGNHVh06fJw5NgF7Pm2nQ9DYweAepaPj1eH4iMh/H5qlIsaxmND9xTmM6Ys18SmmaV6Of1gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J7GF6VCw; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7GF6VCw"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47755de027eso26586915e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 11:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765827224; x=1766432024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tAzWEVvN6bbrF/qLUTAf3M582VLyoyCCZHJjbAe8IYM=;
        b=J7GF6VCwPGwLAo84barYB6YC9h2+uMfnx31odHPI77He3PDaXkM4O0A1GBluhzp0pI
         1sHv0quv1U5J3wEE2sjjf1XAeq9dFeR6Ms6opGYmbN+U/XPogKmw8Ocp9zEqb0870VGT
         SZUNTupZFuuPJZPO2cyEiE9nqMIWJNNVJJRzeZkYW5TrLIVAUOBz2B+9LFbm9ixBGfy5
         c2nU+Imy2AwP+uzkqPVYm5kKpb2MIm7kJdiHe0U3y3SxOPnbCQvL/q+wHntX15sEJHNK
         MSlwhSukNsKnMqySgTEhlrAId7WmbAEAwv2FlLf6o78/xpPCOko5RxQJpB9zoDxl+bn4
         VtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765827224; x=1766432024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAzWEVvN6bbrF/qLUTAf3M582VLyoyCCZHJjbAe8IYM=;
        b=dDpgvpTIa/5H2EA01sEs2Zwd2rs0TMxWmgaD/RmV1798+M+yBK4VNpZX63rzBtx/aj
         +oNZtVclgL3sAA4nRMbYqBO+wEE48WEYLQsqm3TgfXue23qOaXYQwEXOfgvAvjiENkK0
         eaSycv40/HYQbnga6N8NIV3LD2dFE80EVPwbn6+PZaPB1ODM+lxRhHRHefzLrDWJUvQS
         AMAYl6H1yYRyEPKAf95rN1PobI6NONDs844cTbXNHlbgE6aud0l4SfjW8tWzO47lpC0T
         UrMmguUdNvTK+GNKWz1CD6O++h1vQiaxmtNyd/58h3tqgV6fo3ZriWFvbSqEB9G+3vgj
         HMtg==
X-Gm-Message-State: AOJu0Yw3T4MD6xbsVp0hxXdMq4pHHGLDep/1BMzI8mCaqYe1M0qOLS6N
	bZx/3r/lKLUSNAFW4gmHZEjtFy3aGi3LHNyAvmLriv9hBByURuN2gmcTeMi30DSF
X-Gm-Gg: AY/fxX5cUrjNhSjx2FBVlTyW3go3kqQW2EAwK1pOxCfWiu2uySoQMFy2YYgYzCYPwIw
	EvZSunn2YJXEA+kspM5vMcKpPfLXkEMxd1ZZudogazC7Ag0+j+JT4P9MN7abUw1TOPEoeqf/JQ9
	+tX9LDuEPyfSlKHQccJ6JPKW303MjV2AUYiqPPkzKXe+SSzWPYPZUpLfAw7+z9uGPnVGjrVWHkI
	DnIR6qwuzU9Es/bTPpW3pH9utLr3Few0Z6JhZyzQ3ObISdZLjcOYjvBD4l31/9OAsTH7CVyEgHG
	gWAGtysC2RW1+Sc8xjmas94QSb91KGx7y9rh/DcK9RJfuWV5p+mSny7FlDxiOTVPdeaLiLSDFzR
	xG6uC58wC0uVHjQ3m/+rz2dIEuX3UTLbblYHVLGpBLfB0nhGiBkEWPn71CgN8+WdjttaePAQiXc
	43a4WD84gwRbsYYqiazGxkvHyOcA==
X-Google-Smtp-Source: AGHT+IH/7JN0qArnr7ILK19daq4W+EP4RQNr3JaEKZP8vfp7PDH93CnPTbxjKLEidbA7+BrVZKVh3Q==
X-Received: by 2002:a05:600c:8b78:b0:475:e09c:960e with SMTP id 5b1f17b1804b1-47a8f9142a6mr124571795e9.32.1765827223511;
        Mon, 15 Dec 2025 11:33:43 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:d056:b665:7783:f98d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f8d9c6fsm205333745e9.11.2025.12.15.11.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 11:33:43 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	djwong@kernel.org
Subject: [PATCH v4] xfs: test reproducible builds
Date: Mon, 15 Dec 2025 20:33:13 +0100
Message-ID: <20251215193313.2098088-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
DETERMINISTIC_SEED support, it is possible to create fully reproducible
pre-populated filesystems. We should test them here.

v1 -> v2:
- Changed test group from parent to mkfs
- Fixed PROTO_DIR to point to a new dir
- Populate PROTO_DIR with relevant file types
- Move from md5sum to sha256sum
v2 -> v3
- Properly check if mkfs.xfs supports SOURCE_DATE_EPOCH and
  DETERMINISTIC_SEED
- use fsstress program to generate the PROTO_DIR content
- simplify test output
v3 -> v4
- Add _cleanup function

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 tests/xfs/841     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |   3 +
 2 files changed, 174 insertions(+)
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out

diff --git a/tests/xfs/841 b/tests/xfs/841
new file mode 100755
index 00000000..a75f5879
--- /dev/null
+++ b/tests/xfs/841
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Chainguard, Inc. All Rights Reserved.
+#
+# FS QA Test No. 841
+#
+# Test that XFS filesystems created with reproducibility options produce
+# identical images across multiple runs. This verifies that the combination
+# of SOURCE_DATE_EPOCH, DETERMINISTIC_SEED, and -m uuid= options result in
+# bit-for-bit reproducible filesystem images.
+
+. ./common/preamble
+_begin_fstest auto quick mkfs
+
+# Image file settings
+IMG_SIZE="512M"
+IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
+PROTO_DIR="$TEST_DIR/proto"
+
+# Fixed values for reproducibility
+FIXED_UUID="12345678-1234-1234-1234-123456789abc"
+FIXED_EPOCH="1234567890"
+
+_cleanup() {
+	rm -r -f "$PROTO_DIR" "$IMG_FILE"
+}
+
+# Check if mkfs.xfs supports required options
+_check_mkfs_xfs_options()
+{
+	local check_img="$TEST_DIR/mkfs_check.img"
+	truncate -s 64M "$check_img" || return 1
+
+	# Check -m uuid support
+	$MKFS_XFS_PROG -m uuid=00000000-0000-0000-0000-000000000000 \
+		-N "$check_img" &> /dev/null
+	local uuid_support=$?
+
+	# Check -p support (protofile/directory population)
+	$MKFS_XFS_PROG 2>&1 | grep populate &> /dev/null
+	local proto_support=$?
+
+	grep -q SOURCE_DATE_EPOCH "$MKFS_XFS_PROG"
+	local reproducible_support=$?
+
+	rm -f "$check_img"
+
+	if [ $uuid_support -ne 0 ]; then
+		_notrun "mkfs.xfs does not support -m uuid= option"
+	fi
+	if [ $proto_support -ne 0 ]; then
+		_notrun "mkfs.xfs does not support -p option for directory population"
+	fi
+	if [ $reproducible_support -ne 0 ]; then
+		_notrun "mkfs.xfs does not support env options for reproducibility"
+	fi
+}
+
+# Create a prototype directory with all file types supported by mkfs.xfs -p
+_create_proto_dir()
+{
+	rm -rf "$PROTO_DIR"
+	mkdir -p "$PROTO_DIR"
+
+	$FSSTRESS_PROG -d $PROTO_DIR -s 1 $F -n 2000 -p 2 -z \
+		-f creat=15 \
+		-f mkdir=8 \
+		-f write=15 \
+		-f truncate=5 \
+		-f symlink=8 \
+		-f link=8 \
+		-f setfattr=12 \
+		-f chown=3 \
+		-f rename=5 \
+		-f unlink=2 \
+		-f rmdir=1
+
+
+	# FIFO (named pipe)
+	mkfifo "$PROTO_DIR/fifo"
+
+	# Unix socket
+	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
+
+	# Block device (requires root)
+	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
+
+	# Character device (requires root)
+	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
+}
+
+_require_test
+_check_mkfs_xfs_options
+
+# Create XFS filesystem with full reproducibility options
+# Uses -p to populate from directory during mkfs (no mount needed)
+_mkfs_xfs_reproducible()
+{
+	local img=$1
+
+	# Create fresh image file
+	rm -f "$img"
+	truncate -s $IMG_SIZE "$img" || return 1
+
+	# Set environment variables for reproducibility:
+	# - SOURCE_DATE_EPOCH: fixes all inode timestamps to this value
+	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544) instead of
+	#   getrandom()
+	#
+	# mkfs.xfs options:
+	# - -m uuid=: fixed filesystem UUID
+	# - -p dir: populate filesystem from directory during creation
+	SOURCE_DATE_EPOCH=$FIXED_EPOCH \
+	DETERMINISTIC_SEED=1 \
+	$MKFS_XFS_PROG \
+		-f \
+		-m uuid=$FIXED_UUID \
+		-p "$PROTO_DIR" \
+		"$img" >> $seqres.full 2>&1
+
+	return $?
+}
+
+# Compute hash of the image file
+_hash_image()
+{
+	sha256sum "$1" | awk '{print $1}'
+}
+
+# Run a single reproducibility test iteration
+_run_iteration()
+{
+	local iteration=$1
+
+	echo "Iteration $iteration: Creating filesystem with -p $PROTO_DIR" >> $seqres.full
+	if ! _mkfs_xfs_reproducible "$IMG_FILE"; then
+		echo "mkfs.xfs failed" >> $seqres.full
+		return 1
+	fi
+
+	local hash=$(_hash_image "$IMG_FILE")
+	echo "Iteration $iteration: Hash = $hash" >> $seqres.full
+
+	echo $hash
+}
+
+# Create the prototype directory with various file types
+_create_proto_dir
+
+echo "Test: XFS reproducible filesystem image creation"
+
+# Run three iterations
+hash1=$(_run_iteration 1)
+[ -z "$hash1" ] && _fail "Iteration 1 failed"
+
+hash2=$(_run_iteration 2)
+[ -z "$hash2" ] && _fail "Iteration 2 failed"
+
+hash3=$(_run_iteration 3)
+[ -z "$hash3" ] && _fail "Iteration 3 failed"
+
+# Verify all hashes match
+if [ "$hash1" = "$hash2" ] && [ "$hash2" = "$hash3" ]; then
+	echo "All filesystem images are identical."
+else
+	echo "ERROR: Filesystem images differ!"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/841.out b/tests/xfs/841.out
new file mode 100644
index 00000000..3bdfbfda
--- /dev/null
+++ b/tests/xfs/841.out
@@ -0,0 +1,3 @@
+QA output created by 841
+Test: XFS reproducible filesystem image creation
+All filesystem images are identical.
-- 
2.51.0

