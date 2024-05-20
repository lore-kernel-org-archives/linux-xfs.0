Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92843DDDA
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716224452; cv=none; b=N/eHsrlk/Z9DVYBx4/NSBNArGZYmKGyYUvNCOsS1mcc6QDmGZtN7v1bGAGExAvr77BSKLBLx33r6jCOnTyAc+EG3d34dCJZk7fXghI28ZDtVw30DKkTidS0dLg6hupqgq4z3tOuxXbA5OWempFmcyIS4j85VVgBt15kmfT4rK1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716224452; c=relaxed/simple;
	bh=1APxhd3ckTAzVBTdLTLt3c5andKLLsC+U+pcDI4EGBM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kbWZfqa/3QZgfR9kvGFMN2PFM8SyQF64PYro+h5vqCXM64T0TLKxPY9UpCXfnXOtRCV6US2OSvQjTrhYM7uEIVnZ+eMbil74IY/l4Z+hKcYdumCUe3WOLJpZ2kWvaSy0KZUTGPFelmqodSJCBfAbnXQAjJ+Mi2TWM/wuOOgjI08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AnuVNP+f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AnuVNP+f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716224449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4qWhkh1epTlmJSat3qjeiKyBc/qMan6DIng62vymx/0=;
	b=AnuVNP+fdAEGQgL/hN92qAKsOo2wgQ/YM2uZBAC41m2OnVhoqgxkbQGzWnxqXQFMOo7KOZ
	YaHagy3ygmycex8hpCTuxmW4H+aOBCyjdAuRfCzp2qPKJNxm0na/rZ57NzKODSSPLaL2r7
	qiC0c1uy5SzMQGiTyANFqP6Djg8YifI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-vtybgwe7PjmD3bgfKEKCoA-1; Mon, 20 May 2024 13:00:47 -0400
X-MC-Unique: vtybgwe7PjmD3bgfKEKCoA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-51f8aadbf04so11543053e87.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 10:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716224446; x=1716829246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4qWhkh1epTlmJSat3qjeiKyBc/qMan6DIng62vymx/0=;
        b=X6PTWEL+rESlIwSFNDvr084B+6LxUryCjosYXR0QsJr17Z6X9O5AxH8fh6Hgm0aK1D
         P1xTnwxK9SdfXdTLT8pM10OXWtdC6LNVzlm0+5K7oI812iGIp72jnfRCyYstCKyVl4g/
         MoJBgTmOh/an2m9ByW7buJyJZlU/22Ay6zi7dD13A90WglrcwfK2txpFoVuLafkAcpe+
         EGi7BkZoQ2wcVWkV2VDLsFc6q7wZzRJgcVcAw5F7s3PfqHiisGr+bVqAuGgGtBZ++AD+
         CTQhmHZyYHBCVTrvwPuy/xkxLzbiCjiDtXCK4rjtm2zdYqC7pnbG/QLNX7vx0EhI9cgg
         C9Rw==
X-Forwarded-Encrypted: i=1; AJvYcCW+9Wt2ML/xRV26FatThFAKB1ld6bWBJSOpiQvV5xy7lxorxgvmJh5+JT64n2xt27O5jnvQIKe/RUV1x3T2RVxJj38DfkKnmJjU
X-Gm-Message-State: AOJu0YyvieUs4Qur0R7ETqvuo+jL9DG2Vh3I3PC+nwlC2wM7jq+1B4F9
	hJXQD06C0A89lMrtU5Dx62vjGL8/V5DUr/yije1nZRXghunInrY1jK4NaivVWeGArVlxQ+Ztt5D
	w+nid7+LYX2/sgPB4wF+Wb8RHhkSsU9nK8Xi8m/emkIF04VFF35PLXyef
X-Received: by 2002:a19:4309:0:b0:523:e073:36c6 with SMTP id 2adb3069b0e04-523e0733873mr5466677e87.48.1716224445960;
        Mon, 20 May 2024 10:00:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgR8006pqsvLSuExNivh1ntHtStjT+2FJZqDTI8e/r+3CL4gn8WqYjw0cmtsM+4aOotKUz3w==
X-Received: by 2002:a19:4309:0:b0:523:e073:36c6 with SMTP id 2adb3069b0e04-523e0733873mr5466658e87.48.1716224445257;
        Mon, 20 May 2024 10:00:45 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733c2cb54csm15074896a12.60.2024.05.20.10.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 10:00:44 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs: test quota's project ID on special files
Date: Mon, 20 May 2024 19:00:05 +0200
Message-ID: <20240520170004.669254-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With addition of FS_IOC_FSSETXATTRAT xfs_quota now can set project
ID on filesystem inodes behind special files. Previously, quota
reporting didn't count inodes of special files created before
project initialization. Only new inodes had project ID set.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---

Notes:
    This is part of the patchset which introduces
    FS_IOC_FS[GET|SET]XATTRAT:
    https://lore.kernel.org/linux-xfs/20240520164624.665269-2-aalbersh@redhat.com/T/#t
    https://lore.kernel.org/linux-xfs/20240520165200.667150-2-aalbersh@redhat.com/T/#u

 tests/xfs/608     | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/608.out | 10 +++++++
 2 files changed, 83 insertions(+)
 create mode 100755 tests/xfs/608
 create mode 100644 tests/xfs/608.out

diff --git a/tests/xfs/608 b/tests/xfs/608
new file mode 100755
index 000000000000..3573c764c5f4
--- /dev/null
+++ b/tests/xfs/608
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Red Hat.  All Rights Reserved.
+#
+# FS QA Test 608
+#
+# Test that XFS can set quota project ID on special files
+#
+. ./common/preamble
+_begin_fstest auto quota
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $tmp.proects $tmp.projid
+}
+
+
+# Import common functions.
+. ./common/quota
+. ./common/filter
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_scratch
+_require_xfs_quota
+_require_user
+
+_scratch_mkfs >/dev/null 2>&1
+_qmount_option "pquota"
+_scratch_mount
+_require_test_program "af_unix"
+_require_symlinks
+_require_mknod
+
+function create_af_unix () {
+	$here/src/af_unix $* || echo af_unix failed
+}
+
+function filter_quota() {
+	_filter_quota | sed "s~$tmp.proects~PROJECTS_FILE~"
+}
+
+projectdir=$SCRATCH_MNT/prj
+id=42
+
+mkdir $projectdir
+mkfifo $projectdir/fifo
+mknod $projectdir/chardev c 1 1
+mknod $projectdir/blockdev b 1 1
+create_af_unix $projectdir/socket
+touch $projectdir/foo
+ln -s $projectdir/foo $projectdir/symlink
+touch $projectdir/bar
+ln -s $projectdir/bar $projectdir/broken-symlink
+rm -f $projectdir/bar
+
+$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
+	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
+	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
+	-c "project -cp $projectdir $id" $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
+	-c "report -inN -p" $SCRATCH_DEV
+$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
+	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/608.out b/tests/xfs/608.out
new file mode 100644
index 000000000000..c3d56c3c7682
--- /dev/null
+++ b/tests/xfs/608.out
@@ -0,0 +1,10 @@
+QA output created by 608
+Setting up project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
+Checking project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
+#0                   3          0          0     00 [--------]
+#42                  8         20         20     00 [--------]
+
+Clearing project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
-- 
2.42.0

