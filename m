Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1565B2F658A
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968566; cv=none; b=cHDob0wltTqolmCjW+h3LJlkOd/PE3wFb7s3zcyYBUjYXW1nHcfjlasXZeT7JMf/tWgPx0Jxz2xd6jeV0dG5ePhK7GLhHH4jRiaTyP7lIUt3aORN6LbGJfRjkLP368w8+f961LGUPlSCysgkDcY2KUq/+4P+6QXUIciP9lVU/dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968566; c=relaxed/simple;
	bh=LiU1Kcnc/xXDInRfq9a5/iHVaT7mrnGXtbWirlJdHkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSQSQw12RW6PWiIA2DvqFSAEsauvl2LX2RMQ+SIav2o32N4X/XpWstjI3ItzlsUPsdwxd81AY3FspMCtNuNDmPreG6eaCnHwANVt2oOmPWRfZ9ddz6mY6aeYcziKI6s6+/JjjUYqUvnK0d9yBZw7LKK8akJIo9/0wNNhZk3YwZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WCPZ8VOd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WCPZ8VOd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760968564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WnVCSabx+0xkqqq3zNHBKS9lr9pABGnoboH7bSSoM4k=;
	b=WCPZ8VOdXE3Nzd4QXkKuRnk6DzQZY/0o3YzfDyO2CJno92uklFwpiglyWnShf9Kz8D1usT
	jqAigBudh6/raGRKFZICb3AgSdheAm/EqwjnzRVareuYSpQ17MEAuNuQ/FlDAh7xHOyCrh
	Qxll0AzTQpseGwqjD3bPnOL2cEadkas=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-CLpyd6w2NceOfgxhP2f1rA-1; Mon, 20 Oct 2025 09:56:02 -0400
X-MC-Unique: CLpyd6w2NceOfgxhP2f1rA-1
X-Mimecast-MFC-AGG-ID: CLpyd6w2NceOfgxhP2f1rA_1760968562
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso25991575e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 06:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968561; x=1761573361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnVCSabx+0xkqqq3zNHBKS9lr9pABGnoboH7bSSoM4k=;
        b=vx+hZkD+Yv6sv30zePXHodCDMiZKFUFKOc+MhiTn2CuZYOn5mCujifwXaNO7nA2m2o
         N5adiKk9IPsfQV8eC3UkQXjrrxWh0He98oQxUYK5oPMd2oYqfh5mikEv7YsODJrIDu0Y
         Kh1SOybcNbNGDtZp+AcXqmy5kRrwXmPUX7BxahoJuFRSCYi/vxDWSqkSKOGFMcUJdJWR
         MwjqSdzk/qspWmgT1uiMLquQbkt9OotQO0oS01tdz0u5uVi3k7Gtfh3rc1kKWd3YXEsR
         G/OjbImk2yIo+/cUQGTY4uK+WcVulqTW9Zonp3fuzh7/K4tRGqh44YOfLrLtclM4rOLm
         VRHw==
X-Gm-Message-State: AOJu0YxBTa6yTtU7yhCHAEvOhdyG03soTYouUHuqA9uBH6qjbKvaB8hm
	pjGPiXePI2RdyMzw1PMGKp9elsXEDjBIHVdhK+MQNEsL6ZAS+vanJMPCQzv3URYuT+/pt5gVJbU
	G9DyIjUAFWkGu80KZagjNc423JndhTDrnjbSsOkdn32kwAPhMQPQnOvLyt2DXccW79BIf/3u0Ks
	EAydWVerD7qfHbrnRK7Mk0vw7POWH+YhfRDYVrbD88Uw2j
X-Gm-Gg: ASbGnctUCMzvg8pTeR6ZDRnM+qMJjdI50gRA+P5NixqrcQYkaShT5AMcMEmg4tPEUPR
	BTvnDaCPPd31Z0quO3Hq+64qROJlsSAgR8wON3vs9LXTWufFZEvetHM2OY2wNfdgFvbYNfRMIpw
	n7eI95y28s9bN9f92nAHcCyKuDRMEkzKy7EeklZJxuaI+ImizZap6DR10cmXAosEqf3i4WblShC
	j3zZmLHwLgBCFU6nIdQdJFPR79JJjh/YVFlm6P652NX4IGDMiL+7rA0D8GNOmtuaVqPtPl6m+jW
	LiMHbumuje4bD6heqF7j4243XxHxeq8hpHoMTyXVxgNAMraqvpbyCgRBVm1iJnWTPKa6xctH/3g
	ZwAye0mBkcurSONDM8+ctkyZPEDjaWPcTGg==
X-Received: by 2002:a05:600c:681b:b0:46e:4921:9443 with SMTP id 5b1f17b1804b1-4711792a6bemr104228365e9.37.1760968561217;
        Mon, 20 Oct 2025 06:56:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWqnw97pmYKSKEGBfX2T590QI21UcBjSDyt1Nq7yFQpR4T8AIyPG4MYQImAMV81pZkhOIllw==
X-Received: by 2002:a05:600c:681b:b0:46e:4921:9443 with SMTP id 5b1f17b1804b1-4711792a6bemr104227955e9.37.1760968560517;
        Mon, 20 Oct 2025 06:56:00 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152959b55sm151404645e9.6.2025.10.20.06.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 06:56:00 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: djwong@kernel.org,
	zlang@redhat.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 2/3] generic/772: require filesystem to support file_[g|s]etattr
Date: Mon, 20 Oct 2025 15:55:29 +0200
Message-ID: <20251020135530.1391193-3-aalbersh@kernel.org>
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

Add _require_* function to check that filesystem support these syscalls
on regular and special files.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 common/rc         | 32 ++++++++++++++++++++++++++++++++
 tests/generic/772 |  5 ++---
 tests/xfs/648     |  7 +++----
 3 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/common/rc b/common/rc
index dcae5bc33b19..78928c27da97 100644
--- a/common/rc
+++ b/common/rc
@@ -5994,6 +5994,38 @@ _require_inplace_writes()
 	fi
 }
 
+# Require filesystem to support file_getattr()/file_setattr() syscalls on
+# regular files
+_require_file_attr()
+{
+	local test_file="$SCRATCH_MNT/foo"
+	touch $test_file
+
+	$here/src/file_attr --set --set-nodump $SCRATCH_MNT ./foo &>/dev/null
+	rc=$?
+	rm -f "$test_file"
+
+	if [ $rc -ne 0 ]; then
+		_notrun "file_getattr not supported for regular files on $FSTYP"
+	fi
+}
+
+# Require filesystem to support file_getattr()/file_setattr() syscalls on
+# special files (chardev, fifo...)
+_require_file_attr_special()
+{
+	local test_file="$SCRATCH_MNT/fifo"
+	mkfifo $test_file
+
+	$here/src/file_attr --set --set-nodump $SCRATCH_MNT ./fifo &>/dev/null
+	rc=$?
+	rm -f "$test_file"
+
+	if [ $rc -ne 0 ]; then
+		_notrun "file_getattr not supported for special files on $FSTYP"
+	fi
+}
+
 ################################################################################
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/772 b/tests/generic/772
index e68a67246544..bdd55b10f310 100755
--- a/tests/generic/772
+++ b/tests/generic/772
@@ -20,6 +20,8 @@ _require_mknod
 
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
+_require_file_attr
+_require_file_attr_special
 
 file_attr () {
 	$here/src/file_attr $*
@@ -43,9 +45,6 @@ touch $projectdir/bar
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
-file_attr --get $projectdir ./fifo &>/dev/null || \
-	_notrun "file_getattr not supported on $FSTYP"
-
 echo "Error codes"
 # wrong AT_ flags
 file_attr --get --invalid-at $projectdir ./foo
diff --git a/tests/xfs/648 b/tests/xfs/648
index e3c2fbe00b66..a268bfdb0e2d 100755
--- a/tests/xfs/648
+++ b/tests/xfs/648
@@ -20,10 +20,12 @@ _require_test_program "af_unix"
 _require_test_program "file_attr"
 _require_symlinks
 _require_mknod
-
 _scratch_mkfs >>$seqres.full 2>&1
 _qmount_option "pquota"
 _scratch_mount
+_require_file_attr
+_require_file_attr_special
+
 
 create_af_unix () {
 	$here/src/af_unix $* || echo af_unix failed
@@ -47,9 +49,6 @@ touch $projectdir/bar
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
-$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
-	_notrun "file_getattr not supported on $FSTYP"
-
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
-- 
2.50.1

