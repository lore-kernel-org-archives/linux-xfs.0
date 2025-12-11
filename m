Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1468932D7DE
	for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765473988; cv=none; b=b6mL7ynlvXgWBpQGfFzo6yPVvLPiW9pSmZWpddJ36/naFsEoHnG20k2zTMr03a8218iFqIm69Itqgqm/jcblOLSD4urJ++QjGYspS4gJUQGHK86IY9z1qX/hOGCTQymr4NkrWKWN0nsIJS8D2TgziZiIpiKZOOYRcbfE6Dl4+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765473988; c=relaxed/simple;
	bh=DIuHSY/0L7s7RL2+8kxXPMgftOYybCVZbaIEn42Be1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cmRF8U3DH+uFiy678LjwttxrWJVbOq+2ng7YOn09tybloZxajQY/TsEHyksFCEVeeQp/F++sjtGOtuRTNniklYriLPQtdBzYNWvmKXg8fQNS9ZMv3h7DPUUDRSvdIptPG73GM1Z39iFd5jTDVqL8s668QV5mKI7lXwbAgrAsZsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFsYfY5O; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFsYfY5O"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so4450145e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 09:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765473985; x=1766078785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nkGFZXCXGUeJ9ZdNuV/+YgrSUPn9DrE/VoJiIeufmMo=;
        b=gFsYfY5OKdhJv0sdbKu486Ffi80QCd1LA8w4i9CvrS2s6kyjWedqbF6Q55P9t5/l3J
         SZxnKmno9bBCS7GL5lznBaxu5S0fRuMKWmjVGNS0/NW2RZK7aJV97hIn32mhfH2M3eEe
         iAwdwvAIl23GTAJFw1TyjC2quOEJLgcSxS+1I20+gnioamoIA+AP4PraMkF7E+I40O9V
         iQWifOgPGTx9U6vyAlWQ7d4xCcQ0yZHaI81O+Y/zFGzg1k9l5ttzTRcCMghFMobiFezn
         ckuI5Gul2WkQ/qgvM/R8BSCBG79Fq1i0pDv67TaP4o5rdY2ntjVTuL+/NFyb5VWrU0U/
         sbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765473985; x=1766078785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkGFZXCXGUeJ9ZdNuV/+YgrSUPn9DrE/VoJiIeufmMo=;
        b=opMyq1JJB0AUyf9z9SAy2P9z+RXjGeipDsdATtZFEOyo/fbcqjYwgd7wR6p+qgZhtz
         EjngpbanRgJn8qJ2iiEG4qjn/MLxYhIhjcXkZ8CrvZbQbvpqSOWG11p0IDFUlwVnJMWS
         AGdaqOWepLR0ShmU+/q+G1guho3uZ03jTRiS42+GdL5jPqDJWBNPCFx7EsF8M6lIDrAE
         BLTqchaxOckqV99qfHml5kw36KMhfQ9WfK+wXV8XTseXZj2JpzwHCmsFbLHM+zAKejYJ
         HBETKW1rPjQabDOJ1PYm+PyAyZzny/87wB9TiimyBdEZhOtVrlZ/GcsgslE8nqbpouik
         0B9A==
X-Gm-Message-State: AOJu0YxiZdsYVYxmhoj337bttBheeLiKi1oQYW14fL0eo5hix8E5CEWl
	NHmQHKzU41I3fxUVspKhQsUw199YLKM9aAeiIpvMJEYzW786/HrhR/HVWxbZMg==
X-Gm-Gg: AY/fxX7NR4QMQyCpOQC1SPCVX8/VY0UiXkKBBs7uOGn2k0N6EnWdWquvXdwyZcbXHZl
	sfuqB5Gkrw+6O9NUJCBllvzYEn8lwbGbbmfJLchSB4D42G+4pf/Ghpn8UaJwvCxhe/5Fpy3zsoc
	/SXflM/xbBsxnCj9DUU+TEOlJ5HYQIUZrDHLgXnk0oUy6unkRh5R/Uogl27Sj9OB81r8syaWDFf
	19Bv0wRw1GzMwKHLn0UK9ErQ4wYSH2Et+HUMzOTwn2oRol0Mdi+Wi6FQ7s1nOhZ5dQgpZYFgAKi
	e74YMQZhSvx6VLumg4XjE2bU6qUUQt1DroS/h510T3YsgCJQYlswN/Jhtq7HtcY0nloO1DyxSaY
	lqxgEnPv7/qp4ZSTm7ld5k/+LxpDZ+WmuvfhvTjhJ4LNLwm+z8xDI+56gowlxXJe7zp3/hBQs3R
	e/ggympT4Bp8d9NMluho6K5oXO4o/DHOOJoA==
X-Google-Smtp-Source: AGHT+IGvc/OcveKj8beKKI4Yq4WN0PBuBCD5711jssGpapsl95zTtY61CWmkPjBur0+gFrcfW8HTTw==
X-Received: by 2002:a05:600c:3b0f:b0:477:a36f:1a57 with SMTP id 5b1f17b1804b1-47a837456d6mr65380235e9.3.1765473985086;
        Thu, 11 Dec 2025 09:26:25 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:56ab:ea48:efb:f41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a89ed69bbsm16553465e9.13.2025.12.11.09.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 09:26:24 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v1] xfs: test reproducible builds
Date: Thu, 11 Dec 2025 18:25:31 +0100
Message-ID: <20251211172531.334474-1-luca.dimaio1@gmail.com>
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
 tests/xfs/841     | 141 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |   3 +
 2 files changed, 144 insertions(+)
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out

diff --git a/tests/xfs/841 b/tests/xfs/841
new file mode 100755
index 00000000..70c0028d
--- /dev/null
+++ b/tests/xfs/841
@@ -0,0 +1,141 @@
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
+#
+# parent pointer inject test
+#
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/inject
+. ./common/parent
+
+# Image file settings
+IMG_SIZE="512M"
+IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
+PROTO_DIR="$(dirname "$0")"
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
+		-N "$check_img" &>/dev/null
+	local uuid_support=$?
+
+	# Check -p support (protofile/directory population)
+	$MKFS_XFS_PROG 2>&1 | grep populate &>/dev/null
+	local proto_support=$?
+
+	rm -f "$check_img"
+
+	if [ $uuid_support -ne 0 ]; then
+		_notrun "mkfs.xfs does not support -m uuid= option"
+	fi
+	if [ $proto_support -ne 0 ]; then
+		_notrun "mkfs.xfs does not support -p option for directory population"
+	fi
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
+	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544) instead of getrandom()
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
+	md5sum "$1" | awk '{print $1}'
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
+# Verify prototype directory exists
+if [ ! -d "$PROTO_DIR" ]; then
+	_fail "Prototype directory $PROTO_DIR does not exist"
+fi
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
+	echo "Hash 1: $hash1"
+	echo "Hash 2: $hash2"
+	echo "Hash 3: $hash3"
+	_fail "Reproducibility test failed - images are not identical"
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

