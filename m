Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3801E7C19
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838234; cv=none; b=fw7KASjb+QYmfby6OlTFu2K+3Re/yNp4bkgyzgsVTRTvZuIFDBDeVNd9bLQEly/ja6WXSV3+RZaDacddn4+0xW1W/GMFL87xs+o/H38nDxkM3Dv0raP8qFZKwen8yDMB+QMQtqX6ug0o6565UCVRG5w0AfrPd/eKvpwt0ttlQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838234; c=relaxed/simple;
	bh=y9wdbUTHkqT9Vh2IUZ2SdxVFjx9A+aSbN1irkrdsrPc=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Og9hOQ/1ODY2iPxB7kBW4I4/l8zWrX9Fm1Mm0gHIltGMaoApLnUkoxhyq9K3RD9mUrHJx2i9AtG4xbssoSvlGBKfc39fvvaVXV/l8ME8zNw4SEJ8Rsapde2+VznG79fpni+71iFTecieNW4tS7qgmPU/tVfqo8CAI06/qzmc1s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C369B3fV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C369B3fV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761838231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cmSTtO/yIrjp5i1xpsckmQG948fxkODEHcCeNBoVMZ0=;
	b=C369B3fVpR0vFHOEMlGgncN5eCK/UaqedIl9mo9biiYfdcl0g9t4etIalX8f2mD7tcMgYi
	4o2vjzAqjibF+hD9SY8/mG7QzC/Zgi9BIZibU+Est1iwJQKv/ODYaG94sFLHrq2qf9SoTk
	UV2muTQvFg3cEAc5c3F8SaVoxID1SEc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-k5B6fWhwNve_acTMaau0TA-1; Thu, 30 Oct 2025 11:30:29 -0400
X-MC-Unique: k5B6fWhwNve_acTMaau0TA-1
X-Mimecast-MFC-AGG-ID: k5B6fWhwNve_acTMaau0TA_1761838228
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-429a7f1ed1bso527056f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 08:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761838227; x=1762443027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmSTtO/yIrjp5i1xpsckmQG948fxkODEHcCeNBoVMZ0=;
        b=W8N+V6Ajz8tLRBl291OKp75CLu8BykAClNpw4bbfhRNnPOHAiZs2eHXQAj11+9vuhr
         N3vhgNBP5JJSVrVgD1PKCf/jZ4uyogpEKkltz4StksvcDEDJ2yJt3GzPG8jQWs8Dr78Z
         WFnBfOe8eZHC+jDkiOwNdnrxnUY3cuTgdQv25kv9smi3cczu1gPl/ojrFjUE0GvKVDLw
         qjfHveK6XCSGRLxks6xfdzq8nJKxKcyqSEF5wtQ6euKR8l7/KuFpK4O0kopNaBZtd+wE
         xGUwgvXc74bpimaYzoi+fhxE7+7Iwet/fhsd9SKPWHFGxbvdHrITA6+whvLHNOR2LW+L
         Ydhw==
X-Gm-Message-State: AOJu0YxcBWnooOAr5amdkkh5dTx7t3BuxDb/MP7HoVIvoqDFtTjNmZHQ
	VGfS/hNaF9m4y+DvKKpSTuK6TaUBsS0wkTK2iSCaI0gwupj9Fh+CntZhQwwxJmBBb7tY4TAtoTY
	p7K2onxO3n7LwQqhPHzNQ+WWTrkXP+/VLsexgIfvTM/iqDSgOBJ7nNqSir6M0Ulx4gVHz8ZPFdA
	5grqpaCkQcu95hL+stDzblMrzqnjzDAZga7cXmhg3MiCT8
X-Gm-Gg: ASbGnctoVk8WXgpVhGkobi4xoIZgP/DMsA47zySgEF42D2EMUQdgxnU60Phd4GbWsYW
	5iqAiLsTofAASPBx25Iig2qQf2fhyw2S8qAXpkY6vRNR6dUT/NRCAdyz3M4GhL9t2wpLIachaI9
	AsIjYQWG4gZeL7Rt3Y756JVnyh1XVBhAJieK1LbjHg7CnfG0pY2hdHRfh7P8bTVdZCH2WwBjBnq
	mcy4IWyGGOdN07WOlM9TZSfwlhsEwKZlm2MWd1W4resExrJg8uO7kFrTjqpwHxZLoSBB84+9cUZ
	30HU1cm6a45C9VdiWtPmDD4TRFg4+CqHpDTUgTSXCbhs5AE9RwE4TBYvF+XYGBhb
X-Received: by 2002:a05:6000:43c5:20b0:429:b2ad:f31e with SMTP id ffacd0b85a97d-429b2adf486mr4295964f8f.35.1761838227487;
        Thu, 30 Oct 2025 08:30:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3woqljz1uP79EA7XykDMZOrkSzKqy6nBDITTPLHmdZAidKudAIEA9O9Iyg0W9BCcS79tj9w==
X-Received: by 2002:a05:6000:43c5:20b0:429:b2ad:f31e with SMTP id ffacd0b85a97d-429b2adf486mr4295927f8f.35.1761838226867;
        Thu, 30 Oct 2025 08:30:26 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b7b43sm32771745f8f.6.2025.10.30.08.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 08:30:26 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 30 Oct 2025 16:30:25 +0100
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com, 
	djwong@kernel.org, aalbersh@kernel.org
Subject: [PATCH v2 2/2] generic/772: split this test into 772 and 779 for
 regular and special files
Message-ID: <2khwdfurulcjiyxj3pwga6dollogx6dnamiwidr72jmbdceaqk@6ozmpwvnzd5q>
References: <cover.1761838171.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1761838171.patch-series@thinky>

Not all filesystem support setting file attributes on special files. The
syscalls would still work for regular files. Let's split this test into
two to make it obvious if only special files support is missing.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/772     | 37 +---------------------
 tests/generic/772.out | 14 --------
 tests/generic/779     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/779.out | 20 ++++++++++++
 4 files changed, 107 insertions(+), 50 deletions(-)

diff --git a/tests/generic/772 b/tests/generic/772
index dba1ee7f50..8346de8961 100755
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
@@ -13,7 +13,6 @@
 
 # Modify as appropriate.
 _require_scratch
-_require_test_program "af_unix"
 _require_test_program "file_attr"
 _require_symlinks
 _require_mknod
@@ -26,23 +25,11 @@
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
@@ -58,37 +45,15 @@
 
 echo "Initial attributes state"
 file_attr --get $projectdir | _filter_scratch | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./fifo | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./chardev | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./blockdev | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./socket | _filter_vfs_file_attributes ~d
 file_attr --get $projectdir ./foo | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./symlink | _filter_vfs_file_attributes ~d
 
 echo "Set FS_XFLAG_NODUMP (d)"
 file_attr --set --set-nodump $projectdir
-file_attr --set --set-nodump $projectdir ./fifo
-file_attr --set --set-nodump $projectdir ./chardev
-file_attr --set --set-nodump $projectdir ./blockdev
-file_attr --set --set-nodump $projectdir ./socket
 file_attr --set --set-nodump $projectdir ./foo
-file_attr --set --set-nodump $projectdir ./symlink
 
 echo "Read attributes"
 file_attr --get $projectdir | _filter_scratch | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./fifo | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./chardev | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./blockdev | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./socket | _filter_vfs_file_attributes ~d
 file_attr --get $projectdir ./foo | _filter_vfs_file_attributes ~d
-file_attr --get $projectdir ./symlink | _filter_vfs_file_attributes ~d
-
-echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
-file_attr --set --set-nodump $projectdir ./broken-symlink
-file_attr --get $projectdir ./broken-symlink
-
-file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
-file_attr --get --no-follow $projectdir ./broken-symlink | _filter_vfs_file_attributes ~d
 
 cd $SCRATCH_MNT
 touch ./foo2
diff --git a/tests/generic/772.out b/tests/generic/772.out
index f7c23d94da..c89dbcf5d6 100644
--- a/tests/generic/772.out
+++ b/tests/generic/772.out
@@ -9,25 +9,11 @@
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
diff --git a/tests/generic/779 b/tests/generic/779
new file mode 100755
index 0000000000..3a5bc34d56
--- /dev/null
+++ b/tests/generic/779
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat.  All Rights Reserved.
+#
+# FS QA Test No. 779
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
+_require_file_attr
+_require_file_attr_special
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
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
+file_attr --get $projectdir | _filter_scratch | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./fifo | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./chardev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./blockdev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./socket | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./symlink | _filter_vfs_file_attributes ~d
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
+file_attr --get $projectdir | _filter_scratch | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./fifo | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./chardev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./blockdev | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./socket | _filter_vfs_file_attributes ~d
+file_attr --get $projectdir ./symlink | _filter_vfs_file_attributes ~d
+
+echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
+file_attr --set --set-nodump $projectdir ./broken-symlink
+file_attr --get $projectdir ./broken-symlink
+
+file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
+file_attr --get --no-follow $projectdir ./broken-symlink | \
+	_filter_vfs_file_attributes ~d
+
+# optional stuff if your test has verbose output to help resolve problems
+#echo
+#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
+
+# success, all done
+_exit 0
diff --git a/tests/generic/779.out b/tests/generic/779.out
new file mode 100644
index 0000000000..d40376fa42
--- /dev/null
+++ b/tests/generic/779.out
@@ -0,0 +1,20 @@
+QA output created by 779
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
- Andrey

