Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50B82253EF
	for <linux-xfs@vger.kernel.org>; Sun, 18 Jan 2026 19:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768763913; cv=none; b=RrLDjm030tetwbtYLO8BKN0hqvDdTNLfJ1uOVSU32xFNfiJ24f6pmwAO/CxAaNqrHfj5ZnRS4NgcrtwK1BYhtG6IEVR2dV4ekjIGhrpul4lngivo4eH9n0YMcS59Bb3oAp0Jb+nrHVIxnZSveA0ZFYWKkg5Yruqy53P+rVU32iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768763913; c=relaxed/simple;
	bh=HwAjIbwgoh7+sEP7Bh4D4N1zateilLLQ1qr4qfEyiMo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qweySAYvH59UjRScgQGttz4zM5eqjjMXd9DkFYtiEmdLsuSe6yckrlhjCi2Jnh9/L2mpl8mPO5T3UXB/1yQZGfI3aG8/7kvPauMUBtrrq9uObM0s1mpDb1BnzLMqbwX9z/eRfC4G5RLTNwfBzCjXvHRIbqhHTtaLWLj4QI4TU10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=im9jkZr8; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="im9jkZr8"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-432d2c96215so2972966f8f.3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Jan 2026 11:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768763910; x=1769368710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CtmORjNTrE4g7l2ECOXWpp2iAzgvLNSGbf1oku8deUw=;
        b=im9jkZr8EWspf56ObRiALL81EgJVp21x/tvWTT8+NHgJU0vQPGfurkVBb5eP1+5mrf
         yhThy3kVt07Mxuwc9/7iB90jypFcsLzp3zzU8Nt9Tnj5vZaV4g+4LrkKu5HUY98x6+Op
         NJlY+5RW6BSU5K+kbyLUepnBmxFQy5Rd6T4RfoG/aMPIut1tPOf5eMVyMwo79cIe6eRn
         HMcN3BeMs9z9CjKxJ02i+L9vU7nu6EWzKm2AiLZLWRXkx7Zz7lN7TJC477Tmk7JcMPl5
         r/o7UL2KAJeAdDX5l3WW1ycjvPGOW6ZqjgmceLlsndwK6G9TUjpe293LthflEZCdzeG4
         ju3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768763910; x=1769368710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtmORjNTrE4g7l2ECOXWpp2iAzgvLNSGbf1oku8deUw=;
        b=JhbtLnLwhguw8jF87CC/yrIJDmLjImEwXkHVL4uGjzBuhWhZ2JTUcWidWffWBLMsZR
         Aty5I/auM6cuBXfLQJWgo4KekL5FJf5OSn004cCO9LyoQhoC0wDHJ78X4W5yecrAtjeA
         QbGuHM/s4yU1jd+MTi+4VN5TPje7zZF/44vNEN+DLp0DdFVM7zZaMNys9Dk5Y3plaiHz
         1IPMzkffi12gMmf1kKy/Ylly57c3SqgJi9u4P6HlUBnkJx43HW65IYQFS3olMv0Yh3iy
         th97e6jO5TtQ3kG5QNUqqM8y71gvArxLRNuuGc5RM9reUe9I0NqKeJchPAQ5913n8v/P
         BkzA==
X-Gm-Message-State: AOJu0YwFMMz8sxPTmXBbzD66dygqyZDOx58lhZbXQhy7IrjZe/3Xbh0D
	JSzjAVOts9h/VBHUCwPCRwBG13lmbESVu+NAQmSozDIapqoPpohPvoG+czSHZQ==
X-Gm-Gg: AY/fxX7HBty1HiBdHVPSTzCcU3cvUR1YSWTQBzYUV0J2eO+X7Nxh0YNwShPiSUCwCc3
	+Z96DQ/kcrurE0rpXv2u0lsaxd1hk4aeuAMGuFKX8R15q1NuKycZlUCvdfN5yqqn1JtKR1bAjxJ
	TEWf3gS/EHw9AhuBa/1IaBHj0qg1ql7nb/0SdqlbHZCmMOtuaxBGuPPYb7GVeUjdyfwVzqIzxxA
	zhJeBZe2RN73z+j2tzfSHej14EgcTti3qlWrGvTBQlus6dhGrv8v7U2CnKqdyn/VTxacb+jhSRU
	0o36nYwrhOX9RtCSO2GhGC7evf0s2OEhyCof7v1x1he2bIFjKILbkkgD+VboVl/Lwehy9vzPAyC
	Vbu6P62WQpNrRDWM0KHR9Sn0ZumF7gJ4y27pMeFPw55bvekxkaPpfWveFpWvVEnhNPgVJtSsuxH
	jYKy2Xa0dTPT0dLhbUWJvvlHD2Dg==
X-Received: by 2002:a05:6000:200b:b0:430:fbe1:382a with SMTP id ffacd0b85a97d-43569bd49e1mr12027072f8f.54.1768763909888;
        Sun, 18 Jan 2026 11:18:29 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:f108:9c47:a37e:e4a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996cf58sm18391193f8f.22.2026.01.18.11.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 11:18:29 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	djwong@kernel.org,
	hch@infradead.org,
	david@fromorbit.com,
	zlang@redhat.com
Subject: [PATCH v7] xfs: test reproducible builds
Date: Sun, 18 Jan 2026 20:17:21 +0100
Message-ID: <20260118191721.1354833-1-luca.dimaio1@gmail.com>
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

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---

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
v4 -> v5
- copy _cleanup from common/preamble
v5 -> v6
- remove debug typo/leftover
v6 -> v7
- adjust commit message

 tests/xfs/841     | 173 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |   3 +
 2 files changed, 176 insertions(+)
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out

diff --git a/tests/xfs/841 b/tests/xfs/841
new file mode 100755
index 00000000..5f981d0a
--- /dev/null
+++ b/tests/xfs/841
@@ -0,0 +1,173 @@
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
+	cd /
+	command -v _kill_fsstress &>/dev/null && _kill_fsstress
+	rm -r -f $tmp.* "$PROTO_DIR" "$IMG_FILE"
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
+	$FSSTRESS_PROG -d $PROTO_DIR -s 1 -n 2000 -p 2 -z \
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

