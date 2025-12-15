Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99A422126D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813569; cv=none; b=Gu8ifp5vMUpXnN1P7AyjtKmhjSvU65isy5/wfOawsRISZXRf6xEoUqeabMlPZ3es7rxQhgswoMtBGNhmug+diWyWX74jf7llnHRVAj43rjyVv8z4aJZH9q2l2g0lKKzjSxs3T6H4L5DWkcVeOW3OewDZ7Y2NdxRD+OEtFbB7qOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813569; c=relaxed/simple;
	bh=2QcRqgqmZWgj1AYUSrx8bMVGhrfNgsftfY548Q5zN5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GYaI7x5UzF9vDasANiBNjlIgia2+2nEZmvpB0cmu3/ZFGzIeT1CVdRtfH7yFu1ll1RYjeB4kpjnUn9KHmlOdzEqKBKXyvlZKrfCaO8bnUKZzl5uuaaaeGcAuCWBKPMPc81Q9nEacvFOKAEgKHob8lI3MfbDsqVKrMZvJDtd55bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3jpL922; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3jpL922"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso16074125e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 07:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765813566; x=1766418366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FUJ3z3S8PhNYx2m1T8x8M0Abp7w89aQZwcjDcYj9LXs=;
        b=Q3jpL922LQLaaKtgBO/yn3WTUD9fPNFBE2gSb3Sv0H+ZhzPvEzuNXoQUlOZytpaWGb
         Z4iHOZFnUwT7bcacadLq+Fllw8awIkSoCKJtndkNLm7HewR+DsAHohJRu+MYF9xKQWNI
         A7IOs9+9Ag5YOiXEsbtU4TSNtVSzVIY2qhW0zela98gy2XisiLOX7ZeM92SVGEwWSH1f
         zoDcRHgBHe4uZ4l22f+d9sN5DYyQvj2cw0mGLcKKxh/jz0k/qS3hjPMjFEG2ymhrjfts
         GFuQyN+eYD8PWPP4HfbpPdXo8gih1hYvNgA6/O+hofoyxWHQR1W0k5k36UpDNn7d/jbx
         VHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813566; x=1766418366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUJ3z3S8PhNYx2m1T8x8M0Abp7w89aQZwcjDcYj9LXs=;
        b=G/qR0ogrcpktfcB2G2u7L+0zhOKpuICpoP6zpAQH0OB+UcVpy5bmt+Ruw7S/B7yM8y
         ZIdjna4N2LCsT5jMWB+UTV4u2YMrNgLGFm9IGEiVHOWiSsmKQs80hQWNZZsRrtN95b6R
         gV3F6oT78+o0+vbw9Y9cXGOnCPd4jG0gq8NLjXUp7vy7ERF2BvcjY2wdMhghlyLIglvx
         5bR51g+k1d3HZdeJylRnrMXnsO0frziYq3t2Db0Ih9uRS+higKc+G/nzSpyf/PTICVA+
         E6fNeQfc642rjkjov/4CcTjORDnNzgGw43btx49/3hE8pdI/N6PkVXXyZX7ucaF0UnAE
         fNmw==
X-Gm-Message-State: AOJu0YyE2kLToMo+Ar9DLqvmffQ7NUlnNNxblkrdprm7jHuXYrff1unU
	0UOoY5u7UmD138rgGPccRQhXKizr3U2sBwBIZ3ezkUV6VaEdwKHfTpA25b4iQsfZ
X-Gm-Gg: AY/fxX6wGHhBX9g6tP0kx6weq1qR7moUQigTH5w+h+AHH85DDGxLjF7l7+ncpJ9QIZW
	uGNldXHnpI4CuAWwi14Mipa9acJZCwmn5JO1Qi1vvIJxqsTuLGaW50n7XFUgFYCykkJCYzimnCP
	I2HXZIR1jF97jZPj4Mt3oAqYcDVrww2pasnbpE8/qOvd9uujM+8gwUPSrKRuXiqJeM/gfubwJNO
	RgbPZbM7fSWZiuWSWKdKvtV72s6uSCPaH8HH1/jaC+2Z/XNMJ5/x2h6IwewHdru2kIg3EzosDv4
	x4vD3eFHofQwJF8ZTL0S+HAYqxOhwwM/OHlOaBMLRC+Flhekh67kkulkdGIscLsSd/h2MBRLeJN
	MUdIAtWRwqgI5dXlUR/6sRqoOp7oQr83Gz10xUXPJw7nsm37rW9bQZs9gpiDOwQBnMtX6vZpEes
	tjC3RZIhh4l628MYb3hMkx2+asxQ==
X-Google-Smtp-Source: AGHT+IESI+/YZvr2h1ga/Id9P5N3gXU17d6jmZrhDepPPbuv0WQckpb5Ow8PqxGdWsdUuv/iASYY8w==
X-Received: by 2002:a05:600c:470b:b0:479:2a09:9262 with SMTP id 5b1f17b1804b1-47a8f8c00d1mr102368735e9.9.1765813565674;
        Mon, 15 Dec 2025 07:46:05 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:d056:b665:7783:f98d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f4f424bsm195067285e9.10.2025.12.15.07.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 07:46:05 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	djwong@kernel.org
Subject: [PATCH v3] xfs: test reproducible builds
Date: Mon, 15 Dec 2025 16:45:29 +0100
Message-ID: <20251215154529.2011487-1-luca.dimaio1@gmail.com>
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

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 tests/xfs/841     | 167 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |   3 +
 2 files changed, 170 insertions(+)
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out

diff --git a/tests/xfs/841 b/tests/xfs/841
new file mode 100755
index 00000000..9a8816ef
--- /dev/null
+++ b/tests/xfs/841
@@ -0,0 +1,167 @@
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

