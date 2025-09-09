Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7334534F497
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 15:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431569; cv=none; b=UYLy8d2rr5EnQhSlmV5kK0ebDQde/89NNEvwQy9NDCe+xwzmmsuuzbJvgt6jvqzmK1lyODpbe0MVU4UzZz+UmkwdLGNz76OivQhpYK33xz0NsPnfwE8k3ZEj00sGIM9dHQ621dpJ5h0nXXMB7Q6Ndla+i1XFIxga+aOwRfwXgqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431569; c=relaxed/simple;
	bh=4dypLPu6DNf9DAMNJyF5UXwIvayiqJK8XG4EG3pgjZo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BaLnCjxcvjLzP3QZLnaU2T78NzSKqAx5J14W6UCOvupHBx4cdWALqCdBiPSbFnIEcCTrg+aQAAiwAOMEJIDTr8JprwAo+zNM4Coauhzm3xk9i37h5z/35QHTCrzjCUYU8jcZnJr8eQI6tS/fu6TPe8TazzZaE3zJMwEV+1kRGQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VpcgTUG8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VpcgTUG8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpNh9Npv8ACuKwnSClKnKFFRR5xgF6p+DJW3Gcbr8Pk=;
	b=VpcgTUG8F0w2uKzyhruLbhsKNRh9Keye9XTVQ16D/u783GevJMdMvVZ3Upf7qtWqNwcMd7
	iPP0wodUovt6Hn0wdW4E4UbVITpVM3ZcX/nS80nsX8bRrMXvYVwqqkFnIAa+HFdA9/XYSy
	e7NGOC7dKzNnG/fdibDcbF/58iplHSQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-zd9qS7EvP7Ol8ncFqBLU8A-1; Tue, 09 Sep 2025 11:26:05 -0400
X-MC-Unique: zd9qS7EvP7Ol8ncFqBLU8A-1
X-Mimecast-MFC-AGG-ID: zd9qS7EvP7Ol8ncFqBLU8A_1757431564
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e50783dda8so1971811f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 08:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431564; x=1758036364;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpNh9Npv8ACuKwnSClKnKFFRR5xgF6p+DJW3Gcbr8Pk=;
        b=sFUtf0Tjkc3EFGyLxHvE/GrdnqUldTGPdBjoCc1FG3RXI4aKY0n7jKzPNAQ6wg2ybt
         kEL+qN2ibEJ6gneoV4ygQjUzG5FvHOmt2TuOkqwCSWYW5XazynGQvzWAMTzaDxvQvJk7
         jLwhim+FbP4T9vo/t1eRlH6LNcVljb1KzR1PoFTOzbMa79dTxQ9rA2gFb2DrARH2LHI/
         albrrVeeU17Q3B1sqCwT/BfuyPHQgWw1IgrkfKOyoF3YtPPWGWc0nLVgZF3VAFzT2GKA
         M1AdOK8DNOdBEnVC/Yf2ElNQ3GtViW4bSfbJG3tFHgx6/aeh77ZnyoyC12Ck87w/TCBh
         WlGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXr7XxK9BSABQz+pSBeKE4JhVhW+b+++03mNxcGil7MRZOGlbVq9AtBMruGx5Z7jPnuRLdNuu/W9rc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0KzD6tgPLQAz/YzExLbQyjr2iWeyi7TxAp0LOSFcbPWy/1MTT
	jP2PR0GabdevEOw+F39PcfqLgl1d77di5Yjnt/ylctwE35ow8tiiiEF/NMQ0mnBebSzSQHzxrjO
	4WcI8PeInkgAnh+qOgPjZELU8Cnx0mj0ACP/G8wRH//QBOaws3D3KRQOIsRAZbHnJMHORhHEw5i
	7v6c6Swr474h28s82t81r8+u4Bp2iYEt7NUflgp98z+I+4Ng4=
X-Gm-Gg: ASbGncszY+tDeuwqDnaX1e01ozUOj1o4j4I9sVBmuKNHCfR7LZcAcoNScekXi07dOYQ
	C00+J0qrye2wbgIu8DcWQgF9yEw44cV9QnQZTz9Sty/UDZfQgpzbFR20J+/YZ0nVRaOTvokSCwj
	jNsc6fopbwpaKb7MuO4S32nrENI+Z5i2N4IZsliBMERgo4970luh0his762kMrthsrWeoy42eeN
	076MXj6SJAJgmdxgH4xfAldbSc6bcIn09smGnKVJ72KmyNWzH3ncJaBw2aeSgesi71KFcTsu0QQ
	JO9/6S4+D4CJVyR+hl2OoKwt/Zvqswj/kS/XBVw=
X-Received: by 2002:a05:6000:26c6:b0:3e7:4701:d1a3 with SMTP id ffacd0b85a97d-3e74701d5bamr8119825f8f.38.1757431563477;
        Tue, 09 Sep 2025 08:26:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+0/mzhErgMtuLp43Q9Ly+zDslZ5No/VC0mdy3h84qXsoOBvnDTW5JxZPf6YxuKLf2h/pD1Q==
X-Received: by 2002:a05:6000:26c6:b0:3e7:4701:d1a3 with SMTP id ffacd0b85a97d-3e74701d5bamr8119795f8f.38.1757431562945;
        Tue, 09 Sep 2025 08:26:02 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm348550005e9.21.2025.09.09.08.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:26:02 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 09 Sep 2025 17:25:58 +0200
Subject: [PATCH v3 3/3] xfs: test quota's project ID on special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-xattrat-syscall-v3-3-9ba483144789@kernel.org>
References: <20250909-xattrat-syscall-v3-0-9ba483144789@kernel.org>
In-Reply-To: <20250909-xattrat-syscall-v3-0-9ba483144789@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 Andrey Albershteyn <aalbersh@redhat.com>, 
 "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4010; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=NFXZJCDM6gddTTqUPtjzyqiRjXXUpTibfg7JUhy4vGI=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMg64swfpLLyvd6I3zdRwn2GD1S7PJbOmrdx6ILud5
 +ra3A6h+aUdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJhK0gOEP961fy42mbrda
 ob87ee28AtVu9vPll16dz2v+aBEcuoNLmJHhW0/xh+lz3fI2HDz59rvTYf8pry1eZxqVf7P9rja
 vlukoOwA7WEnr
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

