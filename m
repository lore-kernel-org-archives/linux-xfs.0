Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49D9278E75
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307787; cv=none; b=sxfTUcFVQqAHALZuupvw+0XbhSGSwtyuR/9ZeZJXjxj06FHAn+jOkcH20jbuMmsTShd/JCiD5AC2gvw87HVp12sYJBc7FCRGgC9FquxoKiRDCNjn2hAQMatVBTKx2OatHLcLwxjYTmwk+OalYn12QHCCCqO4Ed/A/VJ8bHwt2pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307787; c=relaxed/simple;
	bh=EKtLHze8So6WUwBeCGYvWIDThXsFt85olQKCz11qkBs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m0SVC3MtHcXs8BqZREbz2Ug/ADQmw30rxwFeH7Z6TdWjB7nWFvdYur04gs7fmk3sT9TdMNTeH91L5alalIdAMqLRrJOyw0Esdc26Kd1Rx/st1bWupnPy3cjrNH1G7kJAG40F5X2o6i5bNmiKdiyIUNcekTb+BQx/be6K3Clm9fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EPyWREx+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPyWREx+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756307784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BV+p7m0Dv5f14C4RYwZJ2/Ia3hKRo6NVSiFGkyaqpBQ=;
	b=EPyWREx+ph9fOkUVvJueh0Bu3/S47zh+Ots7ky37whBpbYw5KDIfSR533FOo98d/0r1VsT
	E5qK9VzKLYKeiocpHlnbksCmoKdO6DUD06iWEuaMKXhe2flC5mckI7FuSQu9RVn6DODt/7
	zS5pdIE63Xb/zPxvvDvQeVSR+qf7FIE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-Z66WKZtNMW60hcTRFLZ4Vw-1; Wed, 27 Aug 2025 11:16:23 -0400
X-MC-Unique: Z66WKZtNMW60hcTRFLZ4Vw-1
X-Mimecast-MFC-AGG-ID: Z66WKZtNMW60hcTRFLZ4Vw_1756307782
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so35676765e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307782; x=1756912582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BV+p7m0Dv5f14C4RYwZJ2/Ia3hKRo6NVSiFGkyaqpBQ=;
        b=WWarHIm5TK9PoIt4Z9TyRjrgAjvoRjG31VwQfIJdSAuzFhxmIir7qGYhCpFBx55LBP
         rZL2DOhHCm6ieEPQpZbsfGjmMFAE4RWnDEnw8Goyld3fkiJjuMVxZ3GBdnD6zt94T8e2
         ucOCEEFARJm1XEV/CLvM430n+/bhqFcyIUu+hPMvZyso6kD44kmXPoE5i49Z7iB5eGUq
         x7RpK9FAq2kfJAhJDDffooKSPD0N4dHhb+Z8qLqWBfrqxxa6AC1BrtSU1FRFvOY30nhW
         7aZUpcKpbzfZZH6lZ1WSz/xRPr0KUj8h6sWmOrxP0wR0n/46nii1+jYV51sgQtSklOZB
         c0Wg==
X-Forwarded-Encrypted: i=1; AJvYcCWNw5Z/pqCG+70EWiROSRArkTwy6lJraD9GSnWXwjyNE7onWzfbEAqacjaJrjoG+ju3rJ62bXqE2OU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzupiEbYzK5su4NHEF8xWKC9+dmLOOz4xK2UaDS6702yWNmq38l
	L3yxUc1Dpa6mzCxUEmB8VMD6rq0enKrJcQTTI89GcPFfxHKjV8pvUqZNNvRCiCYvZKpbRwVev7D
	mHTQVF0sbjdiE/uKRrYT6/+xfAD+y0g6bb3h3G9uG0BMKDc3z0ovF5EVV7+JuagSB3Gns
X-Gm-Gg: ASbGnctbdBmU3yvSyBhnjVGalss1GZ6eRxMkHy53VPI3tiuAWEQAO/WvRlRF4ft2c9L
	KYPdVWCqyFRlYDb3TfrBWro/9rXw6770T9hIqceOZk5aQhdkOFGIL12GpaVIBf+FjLJ3mhXpfj1
	wxau4zF/wm6gldDXs8jWFPhjCnXEPbGBfFAdjGMSr1OfC2wlJep7uUNYbGeM6Qq/7xurFFDfMHh
	Es1fqJHtZ9CmOSwNNURWgbZvsHg1BEWTTH3sqUiH/PFY+lDBQWPCV8y8sXJ+GMAFTUr6d50k1u5
	v6GX/QkZUcfY/Zcx+g==
X-Received: by 2002:a05:600c:198f:b0:458:7005:2ac3 with SMTP id 5b1f17b1804b1-45b5f8479f3mr92185165e9.21.1756307781790;
        Wed, 27 Aug 2025 08:16:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELU4+6F1S678j95SdMA6OY3/DfDJZhH5js7Av/EdAUN7bwmtPlPDIWnqwHtzHSRy9qbral0g==
X-Received: by 2002:a05:600c:198f:b0:458:7005:2ac3 with SMTP id 5b1f17b1804b1-45b5f8479f3mr92184895e9.21.1756307781351;
        Wed, 27 Aug 2025 08:16:21 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm35019145e9.1.2025.08.27.08.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 08:16:20 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 27 Aug 2025 17:16:16 +0200
Subject: [PATCH v2 2/3] generic: introduce test to test
 file_getattr/file_setattr syscalls
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-xattrat-syscall-v2-2-ba489b5bc17a@kernel.org>
References: <20250827-xattrat-syscall-v2-0-ba489b5bc17a@kernel.org>
In-Reply-To: <20250827-xattrat-syscall-v2-0-ba489b5bc17a@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5281; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=EKtLHze8So6WUwBeCGYvWIDThXsFt85olQKCz11qkBs=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtYrOv2v26zkU6zCd9vJXuv+S+4n2zbEb5nyy1M4I
 K71s/WlB4odpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJjKRn+F//IK9VQxCh6VX
 /LSzjmy3UkyZce/qtr5tluGpG61n92hsZ/ifPePIJ42qn60PXkXEzJDY80trWm7A5A256csYfm2
 YueksCwA3BknC
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add a test to test basic functionality of file_getattr() and
file_setattr() syscalls. Most of the work is done in file_attr
utility.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tests/generic/2000     | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2000.out |  37 +++++++++++++++++
 2 files changed, 146 insertions(+)

diff --git a/tests/generic/2000 b/tests/generic/2000
new file mode 100755
index 000000000000..b03e9697bb14
--- /dev/null
+++ b/tests/generic/2000
@@ -0,0 +1,109 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test No. 2000
+#
+# Test file_getattr/file_setattr syscalls
+#
+. ./common/preamble
+_begin_fstest auto
+
+. ./common/filter
+
+# Modify as appropriate.
+_require_scratch
+_require_test_program "af_unix"
+_require_test_program "file_attr"
+_require_symlinks
+_require_mknod
+
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
+echo "Error codes"
+# wrong AT_ flags
+file_attr --get --invalid-at $projectdir ./foo
+file_attr --set --invalid-at $projectdir ./foo
+# wrong fsxattr size (too big, too small)
+file_attr --get --too-big-arg $projectdir ./foo
+file_attr --get --too-small-arg $projectdir ./foo
+file_attr --set --too-big-arg $projectdir ./foo
+file_attr --set --too-small-arg $projectdir ./foo
+# out of fsx_xflags mask
+file_attr --set --new-fsx-flag $projectdir ./foo
+
+echo "Initial attributes state"
+file_attr --get $projectdir | _filter_scratch
+file_attr --get $projectdir ./fifo
+file_attr --get $projectdir ./chardev
+file_attr --get $projectdir ./blockdev
+file_attr --get $projectdir ./socket
+file_attr --get $projectdir ./foo
+file_attr --get $projectdir ./symlink
+
+echo "Set FS_XFLAG_NODUMP (d)"
+file_attr --set --set-nodump $projectdir
+file_attr --set --set-nodump $projectdir ./fifo
+file_attr --set --set-nodump $projectdir ./chardev
+file_attr --set --set-nodump $projectdir ./blockdev
+file_attr --set --set-nodump $projectdir ./socket
+file_attr --set --set-nodump $projectdir ./foo
+file_attr --set --set-nodump $projectdir ./symlink
+
+echo "Read attributes"
+file_attr --get $projectdir | _filter_scratch
+file_attr --get $projectdir ./fifo
+file_attr --get $projectdir ./chardev
+file_attr --get $projectdir ./blockdev
+file_attr --get $projectdir ./socket
+file_attr --get $projectdir ./foo
+file_attr --get $projectdir ./symlink
+
+echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
+file_attr --set --set-nodump $projectdir ./broken-symlink
+file_attr --get $projectdir ./broken-symlink
+
+file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
+file_attr --get --no-follow $projectdir ./broken-symlink
+
+cd $SCRATCH_MNT
+touch ./foo2
+echo "Initial state of foo2"
+file_attr --get --at-cwd ./foo2
+echo "Set attribute relative to AT_FDCWD"
+file_attr --set --at-cwd --set-nodump ./foo2
+file_attr --get --at-cwd ./foo2
+
+echo "Set attribute on AT_FDCWD"
+mkdir ./bar
+file_attr --get --at-cwd ./bar
+cd ./bar
+file_attr --set --at-cwd --set-nodump ""
+file_attr --get --at-cwd .
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/2000.out b/tests/generic/2000.out
new file mode 100644
index 000000000000..11b1fcbb630b
--- /dev/null
+++ b/tests/generic/2000.out
@@ -0,0 +1,37 @@
+QA output created by 2000
+Error codes
+Can not get fsxattr on ./foo: Invalid argument
+Can not get fsxattr on ./foo: Invalid argument
+Can not get fsxattr on ./foo: Argument list too long
+Can not get fsxattr on ./foo: Invalid argument
+Can not get fsxattr on ./foo: Argument list too long
+Can not get fsxattr on ./foo: Invalid argument
+Can not set fsxattr on ./foo: Invalid argument
+Initial attributes state
+----------------- SCRATCH_MNT/prj 
+----------------- ./fifo 
+----------------- ./chardev 
+----------------- ./blockdev 
+----------------- ./socket 
+----------------- ./foo 
+----------------- ./symlink 
+Set FS_XFLAG_NODUMP (d)
+Read attributes
+------d---------- SCRATCH_MNT/prj 
+------d---------- ./fifo 
+------d---------- ./chardev 
+------d---------- ./blockdev 
+------d---------- ./socket 
+------d---------- ./foo 
+------d---------- ./symlink 
+Set attribute on broken link with AT_SYMLINK_NOFOLLOW
+Can not get fsxattr on ./broken-symlink: No such file or directory
+Can not get fsxattr on ./broken-symlink: No such file or directory
+------d---------- ./broken-symlink 
+Initial state of foo2
+----------------- ./foo2 
+Set attribute relative to AT_FDCWD
+------d---------- ./foo2 
+Set attribute on AT_FDCWD
+----------------- ./bar 
+------d---------- . 

-- 
2.49.0

