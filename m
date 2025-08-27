Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBED27584E
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307790; cv=none; b=JR/92TJAb/NIdJbePwe0ZKg22IsaXH5EIcAR/DQV2+IY+TMW4PKHcaIv0J5jvNtpIvP9TBb98eEgf1WyNVhcQtZHvQ1okid86n3YHcBnctrBoKlxJ9AKZnwvYe1MZFVCddETDq71Q2uHzKb+JFXXYVbIHOVCjTVYyrXwqgmhSKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307790; c=relaxed/simple;
	bh=kYbsGAy8GMeUA6lqVnw4fhaUnEOWu7NsbJ/bKKr/7v8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RHKQkX5pbVBdRiLK7jTA8S3G+9aW5JOvY0SflmWopnkiB4yr38W8D6gKuKcqnqzmrFi9knJ5Sz/NaCtA6+FsfBfEpAI9yFYWSSjFzzAvjwC/BpfCxPME4Vme5e8o0UQs5asOyMmC82mqDMbq+gKNDQ4WFM02dvlsV2D36+GNeic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YyB8fiKK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YyB8fiKK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756307787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XTUCl5n/kCYAs38Bk2khoNLAR3VoHOaPiVzysLhfkqM=;
	b=YyB8fiKK5VObIDnT/JyGZGNRGPu/Ika2y/28SFblj8tjDi+z0fuCJnwqkwgnxeotKfPVJI
	mJ8Qicy/4z25CjLULEm24C4H08KIRzM7lJT06llsSKuarxgM1EUun2dtIhR2Hx4xPJguPa
	VgbProw0dUltiUx4cGTwOW7iI9a/5rA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-TqKXqOvDO227OO2F6mGvwg-1; Wed, 27 Aug 2025 11:16:23 -0400
X-MC-Unique: TqKXqOvDO227OO2F6mGvwg-1
X-Mimecast-MFC-AGG-ID: TqKXqOvDO227OO2F6mGvwg_1756307783
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1ac1bf0dso6223625e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307782; x=1756912582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTUCl5n/kCYAs38Bk2khoNLAR3VoHOaPiVzysLhfkqM=;
        b=K61AtlL88nvOBBAR0rQWkpwzbdsmBvV21StmYGM9AmLwUkXwLPc/MUlMzENr6KaOM1
         gUa9R7wlBVf+90iQlYcWQErj2+bYHKmSloCXqIAjMdcsxseqZeBVM+QjzvWL0Y0bJZYj
         yoU7Qm4oAliI10XtbXYHX83Ox6GyQ9dkAfl0/CK8ezfNVtgT1I6T1WHEWwsEB8Op4itE
         RELrTUWp5nYRQ9w1flQJEqfOmmq3dN4zce+lEoRE/AqZFFGHyACTn6ZaEDyjfx/6ysbe
         ghkXrKuCFVwHZT5QNobIGPnS2hAkpS0tCSyIiD8ehdNgiVkfFU5RM/vW2utxpgraY6hk
         Qveg==
X-Forwarded-Encrypted: i=1; AJvYcCU7OycdQkwxaWUZp6U1aGiscSDkOCXrUKsAFX3yhQ/EWPi7usGwgJZ7aUGL3IJc4ykdYkCGnuKROLA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqNnsweXQsQ6eGquM8v8nh1ECgfEthPxWUlp/ioPoikCjxNmbB
	U6i3JmtiGhoWkTDEMlrhHia/DHzj4lkM4uwfEN/0PG+Kc8Mqevbt0kNzxhNXbJbtrbXrEd5+5pj
	TB3Zhqtl4WXopwR16h6TcRNotO/JWOYkH3Nd7v5qJ2atY2bzikbt/hBRYpbrz
X-Gm-Gg: ASbGncvZPiWystkf2Eq/7sptWo9Bv9Qql0BpCI72+/ZdVC99CyM+GyOW940j5UhDnuO
	Y4Lhrqr/20ju/uRoUDRZFr/KkAZn++Y4MR6D3+p5/kyrKEL2RPJUyLw6Bx6lgrFGKyJo7UhZP6n
	bhklZS7qZ1BDAoC0M/pnkVzVMeVjto1UrMB1QkCnMsuYYBawTNJDS29KGvWFi+LTdn8EzkcJ1Ib
	gFSrLHEpcj7oGh0D9kECkd6oPUWVTwrslpZ/iv5fGaakh1oebd7G/GPPWGH0kA7hBYHnm9fGaYd
	jWfoNOeZB+aa991kcA==
X-Received: by 2002:a05:600c:c0d9:b0:459:dbc2:201e with SMTP id 5b1f17b1804b1-45b6870dda4mr26737705e9.9.1756307782508;
        Wed, 27 Aug 2025 08:16:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPJoIJySLeawXgr/PUlSZfR/ZHT6IBnT2EEtKiU7dNbcjnC1lc9hzdIQdOtJCf9k0+zYGgNA==
X-Received: by 2002:a05:600c:c0d9:b0:459:dbc2:201e with SMTP id 5b1f17b1804b1-45b6870dda4mr26737515e9.9.1756307782002;
        Wed, 27 Aug 2025 08:16:22 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm35019145e9.1.2025.08.27.08.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 08:16:21 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 27 Aug 2025 17:16:17 +0200
Subject: [PATCH v2 3/3] xfs: test quota's project ID on special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-xattrat-syscall-v2-3-ba489b5bc17a@kernel.org>
References: <20250827-xattrat-syscall-v2-0-ba489b5bc17a@kernel.org>
In-Reply-To: <20250827-xattrat-syscall-v2-0-ba489b5bc17a@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3958; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=WxjcIOGrMxQ8fi2CDevfH6n7oBhoM80FQoibXLNSdqo=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtYrOq17uqvDwDGr7//vyMqzHbX11ob6lxITJ92bc
 W4X88fpbqs6SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATIT3BSPD6b6Onr03OWbW
 m77ZM4GrO+xi/GoHbQPrWx6u4U/Yl88/x/Df8UamnvP22w4cQTcj9+d489uYuGx47SudfIb9/Ht
 b+d+MANODR5E=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

With addition of file_getattr() and file_setattr(), xfs_quota now can
set project ID on filesystem inodes behind special files. Previously,
quota reporting didn't count inodes of special files created before
project initialization. Only new inodes had project ID set.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tests/xfs/2000     | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2000.out | 15 +++++++++++
 2 files changed, 88 insertions(+)

diff --git a/tests/xfs/2000 b/tests/xfs/2000
new file mode 100755
index 000000000000..7d45732bdbb7
--- /dev/null
+++ b/tests/xfs/2000
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Red Hat.  All Rights Reserved.
+#
+# FS QA Test No. 2000
+#
+# Test that XFS can set quota project ID on special files
+#
+. ./common/preamble
+_begin_fstest auto quota
+
+# Import common functions.
+. ./common/quota
+. ./common/filter
+
+# Modify as appropriate.
+_require_scratch
+_require_xfs_quota
+_require_test_program "af_unix"
+_require_test_program "file_attr"
+_require_symlinks
+_require_mknod
+
+_scratch_mkfs >>$seqres.full 2>&1
+_qmount_option "pquota"
+_scratch_mount
+
+create_af_unix () {
+	$here/src/af_unix $* || echo af_unix failed
+}
+
+filter_quota() {
+	_filter_quota | sed "s~$tmp.projects~PROJECTS_FILE~"
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
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "project -cp $projectdir $id" $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "report -inN -p" $SCRATCH_DEV | _filter_project_quota
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
+
+# Let's check that we can recreate the project (flags were cleared out)
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "report -inN -p" $SCRATCH_DEV | _filter_project_quota
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/2000.out b/tests/xfs/2000.out
new file mode 100644
index 000000000000..e53ceb959775
--- /dev/null
+++ b/tests/xfs/2000.out
@@ -0,0 +1,15 @@
+QA output created by 2000
+Setting up project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
+Checking project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
+#42 8 20 20 00 [--------]
+
+Clearing project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
+Setting up project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
+#42 8 20 20 00 [--------]
+
+Clearing project 42 (path SCRATCH_MNT/prj)...
+Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).

-- 
2.49.0

