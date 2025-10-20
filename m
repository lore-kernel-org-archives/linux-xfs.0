Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DE531D399
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968568; cv=none; b=NbFuo5lmTWDcl4rmbpZqk1fTJx5pyxrqkEC6TyF+U6JKUdDvXW/yEktB2VEXbM3k3GVe6YcbeTDSQtOYq6qKweZu8xBl4iyK8yt9Kem3PX32U7qfF7+a8/AV64WaOjJOLI2j3oMef2niYTAedprK066/PXKKGhxXPSDRRvUo/oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968568; c=relaxed/simple;
	bh=SR8wCX30+QkB0iU+zrhcQQx/iJ+D3afz0RlNOaH+QT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4I6FL1Y5g9p9nDkemoBdzl9JMzbkrHPaisl12OVhkWX1PKrDPPmblBakN1jxrilPAVmvgA9nkC1H0jUwDZKzWInJPdL2MizpsqcqSowfObkBAP48VTtcdBNcVBuxQSQOE5YP2TZLgtRkQ6LBntHT6zOckZYqpelJVhYxPjQKCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L8PYHREH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L8PYHREH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760968565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=875p7D2Av8YvXf4a6psXikjfo7RpKmIN6rgx7UM8SmI=;
	b=L8PYHREHvWrDRW8cJG2uDVgLS4ZNLg4Bf94JkK4TkvflU1RI/SdeYSu2NQsxgnxY0GtgGk
	E+1m56gA2V4kqvQ76n6n4Fif2idmbN4fuWMmHNF7ZQUALpZhEdmFwpZJgji7uAGTwo322L
	9H3bZBZloLdrWQ4sPvwJFLeeTv15+QY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-fsv7cIfcN_iNaneJlYiL4w-1; Mon, 20 Oct 2025 09:56:04 -0400
X-MC-Unique: fsv7cIfcN_iNaneJlYiL4w-1
X-Mimecast-MFC-AGG-ID: fsv7cIfcN_iNaneJlYiL4w_1760968563
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47111dc7bdbso33901405e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 06:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968562; x=1761573362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=875p7D2Av8YvXf4a6psXikjfo7RpKmIN6rgx7UM8SmI=;
        b=m+74n2ZjvIKcxbTFcptxt/Nhx9ZQ0QBsxMzZAuYJ8XdBa6IUsQOMML9tJRmaKt0hKj
         9GC+rOEU1XZ6ELe4H1bQ6EzEy3m4dp7TEmT8CqjGnyZ4eoVy96CQZMIYAv+Kt+iuc8AA
         pMDqSJuF2jPfr4rbhNlMCWmuhPrWm4oyXeiB9+DziO+41HIe0J7bp4rz0XI8ymDdoZHe
         j/hupnhRf3yh7kipWdDkSzLMV/X7AeBRsqWEPRc7X7RPBbA7YmXQFMcL3RXThga0754P
         lE6koBI9i+N1qFqNg3SXNp7Z9ZByuKEbQWMD/BTYQVXX20bqh2AqzQZYOK+PwEI/ndMT
         wyKw==
X-Gm-Message-State: AOJu0YxVXQObNLBrUnMp6G6GPU7dcEZFkj2G6K2nfekJMsCkU5rnMO1S
	EpyvP6UmVHcnRL1VV5hEiGgEl8ZpwF02BG0jjncK5YN2kbVKRVAsXhJuekQs9djklhwNd+dyQGd
	vZ5Z70Hjl1EqNKoiJiTxhGgV+v2Ni46CzU++5yq6ZlRkrIuUvqaVrtE6A349FYn7BUfAaHVFFwA
	AFQDSAlE77L0CTn4TSc0UPggyTQ7IupStXXNv5r+4sjCRN
X-Gm-Gg: ASbGncv4Vsz85dtMMiJGAX5aZHY7lXVClDKKElo6pS1S7r+XFZo363jsQPUyN6PH3lM
	MUujNCXnFdQI2YpXZaU0neS5qnTP84QsK31lU3bIbv/SRDuQrXW6BDiQelmGEF4gURBukBRl/sp
	P+UkJJF96qFvWyFKOcTKT4upNDSqoun2VuTAH1LJHrUSHNksdQ/ZSdnpT1orVQej6+jIzJIYaNj
	0HU24OlzTlytsQr0J+vSKRuHJfOW7rgULDQR1vzDXiG4TrvZ5xHxf9ztkFh0rOfpGw+0k7QIhg8
	WkOwptLxqnT5A0jBKrWBPnz8rruRDBzxBZfkRk4cL0XvmbiYuT1xiqL2NHiRvtt9eukFRqygZaM
	GDJPJaiD/NSFW20E15DZBFsD8s+ZCwxQdrA==
X-Received: by 2002:a05:600c:1907:b0:46e:206a:78cc with SMTP id 5b1f17b1804b1-4711791c3b0mr109779575e9.28.1760968562278;
        Mon, 20 Oct 2025 06:56:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGk/qhIVnAGUF8Og48owJjB6JYq3M5I50Lf8HpYpZqugR4s0ScDAGYP0s0KJX3z7TImCYbOrQ==
X-Received: by 2002:a05:600c:1907:b0:46e:206a:78cc with SMTP id 5b1f17b1804b1-4711791c3b0mr109779165e9.28.1760968561520;
        Mon, 20 Oct 2025 06:56:01 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152959b55sm151404645e9.6.2025.10.20.06.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 06:56:01 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: djwong@kernel.org,
	zlang@redhat.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 3/3] generic/772: split this test into 772 and 773 for regular and special files
Date: Mon, 20 Oct 2025 15:55:30 +0200
Message-ID: <20251020135530.1391193-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251020135530.1391193-1-aalbersh@kernel.org>
References: <20251020135530.1391193-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all filesystem support setting file attributes on special files. The
syscalls would still work for regular files. Let's split this test into
two to make it obvious if only special files support is missing.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tests/generic/772     | 38 +-------------------
 tests/generic/772.out | 14 --------
 tests/generic/773     | 84 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/773.out | 20 +++++++++++
 4 files changed, 105 insertions(+), 51 deletions(-)
 create mode 100755 tests/generic/773
 create mode 100644 tests/generic/773.out

diff --git a/tests/generic/772 b/tests/generic/772
index bdd55b10f310..0d5c4749b010 100755
--- a/tests/generic/772
+++ b/tests/generic/772
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 772
 #
-# Test file_getattr/file_setattr syscalls
+# Test file_getattr() and file_setattr() syscalls on regular files
 #
 . ./common/preamble
 _begin_fstest auto
@@ -13,7 +13,6 @@ _begin_fstest auto
 
 # Modify as appropriate.
 _require_scratch
-_require_test_program "af_unix"
 _require_test_program "file_attr"
 _require_symlinks
 _require_mknod
@@ -21,29 +20,16 @@ _require_mknod
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
 _require_file_attr
-_require_file_attr_special
 
 file_attr () {
 	$here/src/file_attr $*
 }
 
-create_af_unix () {
-	$here/src/af_unix $* || echo af_unix failed
-}
-
 projectdir=$SCRATCH_MNT/prj
 
 # Create normal files and special files
 mkdir $projectdir
-mkfifo $projectdir/fifo
-mknod $projectdir/chardev c 1 1
-mknod $projectdir/blockdev b 1 1
-create_af_unix $projectdir/socket
 touch $projectdir/foo
-ln -s $projectdir/foo $projectdir/symlink
-touch $projectdir/bar
-ln -s $projectdir/bar $projectdir/broken-symlink
-rm -f $projectdir/bar
 
 echo "Error codes"
 # wrong AT_ flags
@@ -59,37 +45,15 @@ file_attr --set --new-fsx-flag $projectdir ./foo
 
 echo "Initial attributes state"
 file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
-file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
-file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
-file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
-file_attr --get $projectdir ./socket | _filter_file_attributes ~d
 file_attr --get $projectdir ./foo | _filter_file_attributes ~d
-file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
 
 echo "Set FS_XFLAG_NODUMP (d)"
 file_attr --set --set-nodump $projectdir
-file_attr --set --set-nodump $projectdir ./fifo
-file_attr --set --set-nodump $projectdir ./chardev
-file_attr --set --set-nodump $projectdir ./blockdev
-file_attr --set --set-nodump $projectdir ./socket
 file_attr --set --set-nodump $projectdir ./foo
-file_attr --set --set-nodump $projectdir ./symlink
 
 echo "Read attributes"
 file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
-file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
-file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
-file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
-file_attr --get $projectdir ./socket | _filter_file_attributes ~d
 file_attr --get $projectdir ./foo | _filter_file_attributes ~d
-file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
-
-echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
-file_attr --set --set-nodump $projectdir ./broken-symlink
-file_attr --get $projectdir ./broken-symlink
-
-file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
-file_attr --get --no-follow $projectdir ./broken-symlink | _filter_file_attributes ~d
 
 cd $SCRATCH_MNT
 touch ./foo2
diff --git a/tests/generic/772.out b/tests/generic/772.out
index f7c23d94da4a..c89dbcf5d630 100644
--- a/tests/generic/772.out
+++ b/tests/generic/772.out
@@ -9,25 +9,11 @@ Can not get fsxattr on ./foo: Invalid argument
 Can not set fsxattr on ./foo: Invalid argument
 Initial attributes state
 ----------------- SCRATCH_MNT/prj
------------------ ./fifo
------------------ ./chardev
------------------ ./blockdev
------------------ ./socket
 ----------------- ./foo
------------------ ./symlink
 Set FS_XFLAG_NODUMP (d)
 Read attributes
 ------d---------- SCRATCH_MNT/prj
-------d---------- ./fifo
-------d---------- ./chardev
-------d---------- ./blockdev
-------d---------- ./socket
 ------d---------- ./foo
-------d---------- ./symlink
-Set attribute on broken link with AT_SYMLINK_NOFOLLOW
-Can not get fsxattr on ./broken-symlink: No such file or directory
-Can not get fsxattr on ./broken-symlink: No such file or directory
-------d---------- ./broken-symlink
 Initial state of foo2
 ----------------- ./foo2
 Set attribute relative to AT_FDCWD
diff --git a/tests/generic/773 b/tests/generic/773
new file mode 100755
index 000000000000..f633706a1455
--- /dev/null
+++ b/tests/generic/773
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat.  All Rights Reserved.
+#
+# FS QA Test 773
+#
+# Test file_getattr() and file_setattr() syscalls on special files (fifo,
+# socket, chardev...)
+#
+. ./common/preamble
+_begin_fstest quick
+
+# Import common functions.
+. ./common/filter
+
+# Modify as appropriate.
+_require_scratch
+_require_test_program "af_unix"
+_require_test_program "file_attr"
+_require_symlinks
+_require_mknod
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+_require_file_attr_special
+
+file_attr () {
+	$here/src/file_attr $*
+}
+
+create_af_unix () {
+	$here/src/af_unix $* || echo af_unix failed
+}
+
+projectdir=$SCRATCH_MNT/prj
+
+# Create normal files and special files
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
+echo "Initial attributes state"
+file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
+file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
+file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
+file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
+file_attr --get $projectdir ./socket | _filter_file_attributes ~d
+file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
+
+echo "Set FS_XFLAG_NODUMP (d)"
+file_attr --set --set-nodump $projectdir
+file_attr --set --set-nodump $projectdir ./fifo
+file_attr --set --set-nodump $projectdir ./chardev
+file_attr --set --set-nodump $projectdir ./blockdev
+file_attr --set --set-nodump $projectdir ./socket
+file_attr --set --set-nodump $projectdir ./symlink
+
+echo "Read attributes"
+file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
+file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
+file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
+file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
+file_attr --get $projectdir ./socket | _filter_file_attributes ~d
+file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
+
+echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
+file_attr --set --set-nodump $projectdir ./broken-symlink
+file_attr --get $projectdir ./broken-symlink
+
+file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
+file_attr --get --no-follow $projectdir ./broken-symlink | _filter_file_attributes ~d
+
+# optional stuff if your test has verbose output to help resolve problems
+#echo
+#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
+
+# success, all done
+_exit 0
diff --git a/tests/generic/773.out b/tests/generic/773.out
new file mode 100644
index 000000000000..46ea3baa66fd
--- /dev/null
+++ b/tests/generic/773.out
@@ -0,0 +1,20 @@
+QA output created by 773
+Initial attributes state
+----------------- SCRATCH_MNT/prj
+----------------- ./fifo
+----------------- ./chardev
+----------------- ./blockdev
+----------------- ./socket
+----------------- ./symlink
+Set FS_XFLAG_NODUMP (d)
+Read attributes
+------d---------- SCRATCH_MNT/prj
+------d---------- ./fifo
+------d---------- ./chardev
+------d---------- ./blockdev
+------d---------- ./socket
+------d---------- ./symlink
+Set attribute on broken link with AT_SYMLINK_NOFOLLOW
+Can not get fsxattr on ./broken-symlink: No such file or directory
+Can not get fsxattr on ./broken-symlink: No such file or directory
+------d---------- ./broken-symlink
-- 
2.50.1

