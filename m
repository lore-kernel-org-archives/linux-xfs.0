Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB621313E34
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 11:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765969692; cv=none; b=pH2fylVdcdK33TimBw4EoUkjjUdmNGlMtOhYRXTF4QAKt3yAx+5SV4XE6/IPPI45jonuRTduE+QMYahV3tsyJMl6IQ4m6CSmoM0m9yPLar/BlxVqUnK18sizIKI7uOl/E1mj071LCahQiNABnIVWsqeKiLgcv5IX+EYMNil7K5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765969692; c=relaxed/simple;
	bh=/Hamfa+ksUPdhkEmwzS5MOtzi1jBdH0AppoWRU6R3rU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=unJs7E/dBTAtXLBmEmAwyLbyIC0Veq5HPqYgaZ57/grzy0+l0vlG2Pj+0LoXpCJ8uCjB1zC9G5BHiHIxIFmFYaIShz0zbhB8KCJnUf+vEWVA2rwieh5Im2bitiTW9npqchVQns+pRbrcqO/NS1061YWQ0Sp7BEEyPKxSgmZTfHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyQhGvcK; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyQhGvcK"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42e33956e76so2594918f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 03:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765969689; x=1766574489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w2KXIuUHTxG+9PFYORsRCGlcPMBrjzhW5oYcDljb92E=;
        b=gyQhGvcKxDEXQCDLsSLxEWmkprkPU6qYX+C+Cd3fL/lqHE54xpTnZ7UUh1wXIxflAb
         sWTp73fZYVhymrGuSbvXhSlCQ/Huv1xbRKxgn1fIqYyMbvLcnqOlTSLrTF7JaxLZThEV
         sv6C7gQdOo4ErDQ0F79zvaQ+W+FH5Hh8Wr/PsLJ/zFl9VDcMu0+VVNnf7AiertFxgdLv
         NYtsoJNjNl2Fy6+kUq+rO2uxVQ5yomceqW9ETJunz7in47TIeylYOckhVZoi219jcG15
         h6IALuizX6irbnmPoxGJyjpsbkfabTZQ8uvL76f86PgaWNluRMUSj5ssxgHa1rhPyrYr
         GF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765969689; x=1766574489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2KXIuUHTxG+9PFYORsRCGlcPMBrjzhW5oYcDljb92E=;
        b=EVB+wmTmNf2qVUSSofo4q7qvHuR5mxddm571Mltg/dbhSVK7aWn77wdAFRCuJsYb0O
         CPoDBkmQsaMpX8dTy6IYOttnbZVhzkj7eKJt0HY00bVe109HOXraBxRd/r57PyZjgpoK
         unXI/JDHBrva26psUC0D7MISBycWW1Zs0iOpFTzg12z3u0mXcGj0eCyjQaB0waknPqPN
         HFtz2u/Wm/VhKNyN7TMtp0dsboeyv7pLSG3JV/bf1ylleJuNmhKE6CciFOeSiTbtKLS+
         l7yvQGPJYvHnMsIWM9hPxViBkGO/cy8eitmB7IA9EhqzAYWxJakyD2raX0XToeT/Ym8G
         Cnbw==
X-Gm-Message-State: AOJu0YxWnP5VsmxMA15jAusK+jggNeGQIKHaiudMkRXQ84eTTzovV4p0
	pqoLZ3lx1RbhU+6TdtsqfXyi3CA+geYKlMOuZTSWJUFiqmJtjE7TVZqbTBHMmvue
X-Gm-Gg: AY/fxX57XLaCfe89ehQ0PPLFeAQxYdBFMlO0Db38mvOQm3V2gq/jKQm0EzeBQ2fH24g
	X3YidwjfPLgRsJ+IifUvtrHSd2/Smrg+Y7t2yQVx4dhX0vBCNsav2Ds8YyGe7XiVwrlR3yzw9al
	5DcxmBghe5MWncFcp+WaecXR7bzrH9a/+JOadeRYYd6QwuiRJTAKNKbmy4y9TTFu611yQrLQvu9
	XZZwDcpKXadREWeMQpB4FEapAU+vVv/40xhD3+/GO4HpjykMPknogH+S/zPd+gtCql8Kjw5uojP
	CNUufyzfzciQ5R5ZYa033kZrOwNtUXacZRLCGE/48UqyrK1bYvFOnW+O2XWxhZAV42bdy+IVoFS
	rALmwcYUR7+732WJB8id+3zVYAXi3LSJslmqzWYfha6ickHpYXM9shWLG3fnZw9Uptc999T6mow
	TIwkzuiJ3xUMh8jihhQfuvux5W
X-Google-Smtp-Source: AGHT+IEcVr9Um4oTkJrJR6C/4as1vBkK1dDxZbVqhSEpOXb+50QRnO5wuBPyVokXqzgeKOhKUSrNrA==
X-Received: by 2002:a05:6000:4205:b0:431:66a:cbc2 with SMTP id ffacd0b85a97d-431066acffcmr5774700f8f.44.1765969688839;
        Wed, 17 Dec 2025 03:08:08 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:513a:a454:7a0:65ba])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310adf6eabsm3945879f8f.38.2025.12.17.03.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 03:08:08 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	djwong@kernel.org,
	hch@infradead.org,
	david@fromorbit.com
Subject: [PATCH v5] xfs: test reproducible builds
Date: Wed, 17 Dec 2025 12:06:53 +0100
Message-ID: <20251217110653.2969069-1-luca.dimaio1@gmail.com>
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
v4 -> v5
- copy _cleanup from common/preamble

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 tests/xfs/841     | 173 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |   3 +
 2 files changed, 176 insertions(+)
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out

diff --git a/tests/xfs/841 b/tests/xfs/841
new file mode 100755
index 00000000..60982a41
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
2.52.0

