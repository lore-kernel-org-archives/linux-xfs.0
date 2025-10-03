Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDA12D94A0
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 09:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759484123; cv=none; b=mio6WgSWpF+TQS8OOYFauRlTiMOw+hzHvU8l6545HXgDQH6Bm8ZaQmENTKJDdqutQ3JyFy/L5QDipwiwqYzwpIiQKfXl6BwAM7H+HfD41SRMrvvupAVYNRw4pFwMglfJPcIHOiXHqUloHwYMmgmhn9Q1ZmF02Jrqt/kXZIG19bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759484123; c=relaxed/simple;
	bh=4dypLPu6DNf9DAMNJyF5UXwIvayiqJK8XG4EG3pgjZo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B1uh9aeRG0Rxrsbz5+9lNGAqprbfSDv4yIN+fijQPZXcJyfwtmf10wB00B5D3lJ/tnnfAM++j6Rorzl2dP1Qm2wBSmi0gkCCwQaOlemvmt9WGEbrzMktqYi7TyWITYHUKAnZB1xd8fQl1+kcEA0wvlFCzHQplwE8G1jsJEExmTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dkcfa04i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dkcfa04i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759484120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpNh9Npv8ACuKwnSClKnKFFRR5xgF6p+DJW3Gcbr8Pk=;
	b=dkcfa04idzpSJj40mlqf4g023WTI5d5jWdeQ5XTZb6yY1NEMbhH0QRjLE45tj9FVqEZxX/
	9uIW8I+XqGgtQ1+CrqqDCdv75bHqwv8JRVkUZS5yIjraGiprHfmp9wnmX50G1oIkIRqPLB
	GseLOl/3/KK+rQZLz2TmmECy+0peYfc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-qamR8_mFP8Om3V_FTiHZjA-1; Fri, 03 Oct 2025 05:35:19 -0400
X-MC-Unique: qamR8_mFP8Om3V_FTiHZjA-1
X-Mimecast-MFC-AGG-ID: qamR8_mFP8Om3V_FTiHZjA_1759484118
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e3ef2dd66so11561075e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 03 Oct 2025 02:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759484118; x=1760088918;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpNh9Npv8ACuKwnSClKnKFFRR5xgF6p+DJW3Gcbr8Pk=;
        b=AJON/461eY7l92a7hkASFris2b1ompE3DhU6yCB4ir4puaiy7Eh3bXnk+zjVy94aDj
         skxBrJ9KvXS+WL0hX97n64L9E+mp/9qfy6AxgzWwwC7wnAhVOOU2Om8h154bU9wRHUyZ
         ZByVz6nzoK8cM/yMfYQvvZTttW4X9Tmz7h1bDe4z8DrzD++apSG+BQ3hkovuPe4WgJBb
         PSaVq7tkPySKg0UFqDiQJYXFc2oZepWyMaWkbYMW3juYpLRp6o8myTD6bb2d0UWAlD+e
         ynRt8SLrpAW8TcrbX5bFjr96BjJymVlK+shkbIIiUj43n1tM3BrGmEXgGTp2VGQTPX1a
         Fz8g==
X-Forwarded-Encrypted: i=1; AJvYcCW/X8kryNJ9tfNz4nl9kHgcbrEU3leHNwa5vkrnPcu/ztRP14LMpZxTIhEThJT/rbZqcZEOZj97utQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgtgaXNSbrAlyYS9L7umkLPlv06TPg0a15lOCXBDC9HCgYcE8Y
	O6ww5LHi4HF9HzItiDHpkpenR8lMppHjzJxDStzlcMpeUA9ceMJWJe1pXhuPb8y0J+n5NrYGXNv
	8W9wmiKSywZ9EXSV8GRt5SU/b0U3mIZR2rFNBBhPobBMFZe4mGKJz3z3D0gIt
X-Gm-Gg: ASbGncv7yBOMMQ0fVq2w9REKb1o1JRtNLY4qSOV+0EAxJWpEKhWxwTfppgztMpUoFAJ
	Wbq/c4zxdNjLSE3qNMiw0aUMlhh/VCOQQwPtlmHSzxPyypbwph2XHOnPioEhfollSfwaPPmDjGk
	Fb0OH+kH+qRapgUp+mcL4ZrECskDdeC1Gtb6DqnzwoX3FsvGYIEDa4W1PGviUF9RnjY1JTjt9tM
	obat1Sc6c3rPYiFGwRXML6fna2Srzl2QW70GO/UIF09+sddTVP7QjBeTuyTtXSfpYs2DH6nl7ml
	oMRrQ4t9CrVuNX809OYOkwvC9HgRTDgrwLfiLAt1+ZshqcvnwKGFS+aIqrIXkMO5dCH4MIla
X-Received: by 2002:a05:600c:3e86:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-46e70c9bfc4mr17218255e9.11.1759484117791;
        Fri, 03 Oct 2025 02:35:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHaVK2zkQzqZL+45iS+eowvlr1TZYdXk2TM+UdvH8rZKcjeAYKqZl5Bkkez7g33XvcXMDW1g==
X-Received: by 2002:a05:600c:3e86:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-46e70c9bfc4mr17218095e9.11.1759484117313;
        Fri, 03 Oct 2025 02:35:17 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a020a3sm121695005e9.10.2025.10.03.02.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 02:35:16 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 03 Oct 2025 11:32:46 +0200
Subject: [PATCH v4 3/3] xfs: test quota's project ID on special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251003-xattrat-syscall-v4-3-1cfe6411c05f@kernel.org>
References: <20251003-xattrat-syscall-v4-0-1cfe6411c05f@kernel.org>
In-Reply-To: <20251003-xattrat-syscall-v4-0-1cfe6411c05f@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 Andrey Albershteyn <aalbersh@redhat.com>, 
 "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4010; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=NFXZJCDM6gddTTqUPtjzyqiRjXXUpTibfg7JUhy4vGI=;
 b=kA0DAAoWRqfqGKwz4QgByyZiAGjfmNGjEfRawp+TuEJCq7YK7NXEttgOFnnnI1oUi99RCp/hT
 Yh1BAAWCgAdFiEErhsqlWJyGm/EMHwfRqfqGKwz4QgFAmjfmNEACgkQRqfqGKwz4Qh9xwD+Nm5y
 0G9xcswpBLFUaAWc9n3mCZRuVoP0DyYJ85y/y54A/0d7ACTsygBK/TxnCKuH2DYoGTH5aol4X5z
 KDx/agcYH
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

With addition of file_getattr() and file_setattr(), xfs_quota now can
set project ID on filesystem inodes behind special files. Previously,
quota reporting didn't count inodes of special files created before
project initialization. Only new inodes had project ID set.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/2000     | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2000.out | 15 +++++++++++
 2 files changed, 88 insertions(+)

diff --git a/tests/xfs/2000 b/tests/xfs/2000
new file mode 100755
index 000000000000..413022dd5d8a
--- /dev/null
+++ b/tests/xfs/2000
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat.  All Rights Reserved.
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
2.50.1

