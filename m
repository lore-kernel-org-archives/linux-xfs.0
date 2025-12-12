Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378753081DF
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 08:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765527354; cv=none; b=WL0/+/F4RznIU3IXaRHNkxAlDmujmfEXmTHpiSpQZW8r96Mp8mZDN9Rl/vd/7QizmlAGtBxAy/imeQVwJ9ZNoYsQyN26T/IGaQSheW3rLS1TAQtwW6rzerqmDE2PaK9jnS32H1TZZ0efH3KfidYsTcYnYkqpMFzG9LmI4uur1Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765527354; c=relaxed/simple;
	bh=K7IgMmDXjYeGCTKF7rAaQaC64qxzY7H8rdKRk2r5MP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I+Y9vzjkRPvkkGE1jPy+t7coCZ0lJNGngHcM/OLH5+f6QLbg0UNyAxgENXRbiblAHvBlprIc7UDufeHFAvktUu+HhsBzB9dsCAu+EwyqBUJV5nlMD335LMt1JuK4S/GwP2uUfkFFIFmP5l3x5zspcv1lBQu2xf4eXCneZNCS61s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lkOmL02I; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkOmL02I"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso10126125e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 00:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765527348; x=1766132148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5VVVyT1Dshp6x5FlHJFJFHT5+KmTLwyp4Ij0FdnzT/o=;
        b=lkOmL02I5a8mRjz8hohcP935MyVS/Bi1IBPr1XfcgQ2qRYzP0toUM93Um//Pc2g/hH
         cXPB+4XLYRtSQ0jaChv+k/E6YWq6gFMMkKGcjiHJab0AAO8/RLK07/ZI+pWMdLYY0gVS
         qRvCZgcMoD76H2rlot9auGHkN+qapUB/7SxmKDFaX9zfJ7giRlZvpJUn0Y2Tlm9W0eKO
         5Mw3oXHdLmyc1Ua/320vvWAsPPzQPddg+fIN9n/CrYu/HeY2BpSoJQSX45SZ8rkPlUKg
         rrOkZfdzX+hBg1rZbUiVM9ZDbF34woSw2oKyXH0xhHIiHgZU51TGEiTHr3Yg5hKWaSkA
         MA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765527348; x=1766132148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VVVyT1Dshp6x5FlHJFJFHT5+KmTLwyp4Ij0FdnzT/o=;
        b=RPCK9R1U3frOeEA5t/Jy/8H6XVhO3SVKpAttaWWphIQbHN/nRHvMVjZM3pAM3Llu76
         yYzo6cDtQfLytG3HCPYdIy8OZvLSIK6hW7IWgLpPzA1P+riR1jkh1PJezdxiPZTz6Et8
         9kIr9MMOh1ts96dbkKr69Z+1UyiuoxZOdL7hPl33nmfdhYZB5sfgFIRJcnvrkilDEH9y
         qI0ouWHupJnD6qQrF6pDqvbWGSi7wUOwzRGHWFQrOy+kG56Xqq/2Y2TU4l2FsJlnPa8X
         cVAfz/5IbjhWhUL3ANzmuCzHXzxH6Qt+sNn6xJ8Q8vTzsR6ceMvqQK84zYHQB2X2MGY/
         jJew==
X-Gm-Message-State: AOJu0YzpnkzOQJqcGVkO2BR0g/6D19fIVFuXtRg30hdp4+o7E0F9k3Hj
	9o8ksCmdxRW8iPsTIzked84rzgUFmIqltSRA9tA9vuyVAb/QmpCmdHfOZh3Gdg==
X-Gm-Gg: AY/fxX5glhJ77wmeUOh1A/dLs9dxXSPgpKxp0zJPO8O2BoqegR+BotOuK6rZ8yS6MML
	aSfX2HvHfkyWHwzZ5IX63Q6r0EJcawVBrI63wVENTpo5woNL/mb848Op4rLZ3C/4Y0h3KGvf88I
	W0pyzdRoR117wIpQ8DNG15RZQ2enwnqvrMdIf3ex4hRwFWDFGH8k5DK0a756HmM4T9QCXsWsm2i
	4o/X09WLboaUvxwzLVaYMYt5N7KYVZcBB7N0HKoAUzoHp7opiiptAawIZFMKigG9DuiVl05lAES
	B9cvs54u6gCXyk9c1VpUyj+CvQdZ2NbcuYWldKtL5+69LegOyGOANWbUXJh6UpY0z3jBjD2DDIt
	blrzZqgzm9/lkV64OxYi8QV3hRl/asjoeqhbb20eFqxdFYIPZlV6jam8bK1R4wj01X1TLJblj5+
	tObabd3E41jchVpVZnHxlbw0VoZ0ZYCKWoS+ne
X-Google-Smtp-Source: AGHT+IGUakMm6R+lEwnBEqp/PKA8rqtcHw58N35Ii+YZ+PBRfBE3F1F+0/jz5/3YWglY3pGWTE9ebg==
X-Received: by 2002:a05:600c:4f0b:b0:477:95a0:fe95 with SMTP id 5b1f17b1804b1-47a8f9096c3mr9160425e9.24.1765527347946;
        Fri, 12 Dec 2025 00:15:47 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:dd42:7144:9aa4:2bfc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f6f1224sm6970405e9.12.2025.12.12.00.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 00:15:47 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>
Subject: [PATCH v2] xfs: test reproducible builds
Date: Fri, 12 Dec 2025 09:15:19 +0100
Message-ID: <20251212081519.627879-1-luca.dimaio1@gmail.com>
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
 tests/xfs/841     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |   3 +
 2 files changed, 174 insertions(+)
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out

diff --git a/tests/xfs/841 b/tests/xfs/841
new file mode 100755
index 00000000..e77533c3
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
+# Create a prototype directory with all file types supported by mkfs.xfs -p
+_create_proto_dir()
+{
+	rm -rf "$PROTO_DIR"
+	mkdir -p "$PROTO_DIR/subdir/nested"
+
+	# Regular files with different content
+	echo "test file content" > "$PROTO_DIR/regular.txt"
+	dd if=/dev/zero of="$PROTO_DIR/zeros" bs=1k count=4 2> /dev/null
+	echo "file in subdir" > "$PROTO_DIR/subdir/nested.txt"
+	echo "deeply nested" > "$PROTO_DIR/subdir/nested/deep.txt"
+
+	# Empty file
+	touch "$PROTO_DIR/empty"
+
+	# Symbolic links (file and directory)
+	ln -s regular.txt "$PROTO_DIR/symlink"
+	ln -s subdir "$PROTO_DIR/dirlink"
+
+	# Hardlink
+	ln "$PROTO_DIR/regular.txt" "$PROTO_DIR/hardlink"
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
+
+	# File with extended attributes
+	echo "file with xattrs" > "$PROTO_DIR/xattrfile"
+	setfattr -n user.testattr -v "testvalue" "$PROTO_DIR/xattrfile" 2> /dev/null || true
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

