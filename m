Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BA5223DC0
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838228; cv=none; b=I43RAyEyFdsNrgpoh4EZtrptCSl6JUwQh1L0cS4kxhMTpXjC2z/Hrarm9QuVm4upamFr9inZrlxks8UsC1NqwH7ax/Iu4BmITfqa/gOGW2Vj3jHzbn11jtamGEHuraSIrkdmWMcC3Y62rM/KR2hHvRABjjHrLD8yCDEA+N4ST4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838228; c=relaxed/simple;
	bh=3AloyVglmOTk+TiFMUOT0YM4XZ0tQXtc4q0G2lCx1OU=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXnz+Hqr8DSW0+tGyzSiE3RwxjaPENnlpRR0BIaxiFghpUGKToNOIu2NJkyvvhV7y5Kk2S6aqzdQUUg4S+uq8diZ5Ez7Mkms5/vBXnrcxZWT3ogOdl1VCZ/fQEtp28ddpgacxN/GRJ++rP86IGGlIX7oHg9l/TeGhtPm8ruQV8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K47hRVk1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K47hRVk1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761838226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TUu1yBTNL4cBNSwGdAYBFfnUHF6zEEDgoeLt2AaYzLc=;
	b=K47hRVk1NwQ7CKxZBKvYU+HJw6NOsnhD8IDoWIp00U4S5ThzJD4STw6jeGoWK0UdVNVt6b
	YmoYRp5iJwZDSUOPUVL3lIvkfLEoRpXoNF8SEPGVT7XN4QPAMQRI/UK7rDFO5v/GwCR5tF
	WvB0COQC7MiA+KqL59i+Q7AELxhidAc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-Ita3XkB2P1eZCBrlZZyDVg-1; Thu, 30 Oct 2025 11:30:23 -0400
X-MC-Unique: Ita3XkB2P1eZCBrlZZyDVg-1
X-Mimecast-MFC-AGG-ID: Ita3XkB2P1eZCBrlZZyDVg_1761838222
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4770e0910e4so8771595e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 08:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761838222; x=1762443022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUu1yBTNL4cBNSwGdAYBFfnUHF6zEEDgoeLt2AaYzLc=;
        b=eA/1guuXKJA9FJp4YtfB5BwaoNvpdWZ0eu2/e87CohV9tnUXs3ldnSGfdbA+YzXw7n
         7wq/a63SDSvvwY9OMSxvs64sjdcTTj+MduTfkajITI6xx31mO/Dfei2sWUJPJFIopgRH
         2RCBHqHBbwfqWCXTeeMCsz4WyRrZF/vqxzXz5aECtk6DtTwpNZ+co/o73GVuSriB79yE
         zd9n8+BT1/AHmEFsIniEkI16HOv4/FNQmNoPFuuD2Ccsql1Zm4W/AbWIxLHxfXaofvep
         xpKv2GA25j/7CS/H8i4iG+JxHK8Pm0eUfcrbRyJru39lI/pcRtDhIeKWAEFu38lfBBnW
         Mkxg==
X-Gm-Message-State: AOJu0YzH3zAbRQbx0eMg6x/K45K/UOIsHM2KCipvGoOm24KbDfghGUAL
	X9+mhFsv4a1igUstJUy2HDam1oDR8wH7I5wWkmnCZxixbNzihssMytNGJHf2t1zKPtjIhEjH7up
	Mx+uN3yCkolf6g2q6aTHHwiaSXfH+Rlog8MDYWQz/aB9LSeF5UmOHxr1iXf4ee3/1Ykvyw0QC0u
	u160+bwns1eVFkLJ8jIQr6r774aDd3KfM6yTxkACljSp23
X-Gm-Gg: ASbGncuM2qad2mi96RqlbnDxkj1RfYdXcxuRcSXkJkf7ubyQTnFzCy4KFLXv6E1Aw8g
	1rcAc7+8rpThBGGe7wGHy4c0Ll4EGbPLIItoXDU9r7yNJib9I+ZKKx/W3693fnM6/JhCbxHuTuj
	xwh7kHn8upg7KWuN+5QbBSjMO0s1dAfbp8XrxVvZMdPayIlknmpDUbDI40ohvdesiB56HVIuruQ
	0Z86EeTWFr41g32/bMU0mEkvYTi9ZUVks46rHaoN0fJd24hlL5+z63VL6o6RK81i35nLIOohs/v
	5//f0dw4VRJEqYf/hvX7iJTEKNW0u/7ud6RAHNak6AxcdlUwZJgVQz4BjIQSI592
X-Received: by 2002:a05:600c:190e:b0:46e:1cc6:25f7 with SMTP id 5b1f17b1804b1-47730801f19mr1120055e9.9.1761838221718;
        Thu, 30 Oct 2025 08:30:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEE8jDLUAXDGJEJfUwRsC6CCUCM4/AEui3HqIXh7PfXdY52cNBdW1IYjgugolZtyPVJoR2KGg==
X-Received: by 2002:a05:600c:190e:b0:46e:1cc6:25f7 with SMTP id 5b1f17b1804b1-47730801f19mr1119675e9.9.1761838221131;
        Thu, 30 Oct 2025 08:30:21 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477285d1e43sm57176465e9.0.2025.10.30.08.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 08:30:20 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 30 Oct 2025 16:30:20 +0100
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com, 
	djwong@kernel.org, aalbersh@kernel.org
Subject: [PATCH v2 1/2] generic/772: require filesystem to support
 file_[g|s]etattr
Message-ID: <lwdr5ntyyszcvqe75ljcqtpcrtjioopoa3abm4fjrdupfmrmx7@2jebme2cchx7>
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

Add _require_* function to check that filesystem support these syscalls
on regular and special files.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 common/rc         | 32 ++++++++++++++++++++++++++++++++
 tests/generic/772 |  4 +---
 tests/xfs/648     |  6 ++----
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/common/rc b/common/rc
index 462f433197..be3cdd8d64 100644
--- a/common/rc
+++ b/common/rc
@@ -6032,6 +6032,38 @@
 	esac
 }
 
+# Require filesystem to support file_getattr()/file_setattr() syscalls on
+# regular files
+_require_file_attr()
+{
+	local test_file="$TEST_DIR/foo"
+	touch $test_file
+
+	$here/src/file_attr --set --set-nodump $TEST_DIR ./foo &>/dev/null
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
+	local test_file="$TEST_DIR/fifo"
+	mkfifo $test_file
+
+	$here/src/file_attr --set --set-nodump $TEST_DIR ./fifo &>/dev/null
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
index cdadf09ff2..dba1ee7f50 100755
--- a/tests/generic/772
+++ b/tests/generic/772
@@ -17,6 +17,7 @@
 _require_test_program "file_attr"
 _require_symlinks
 _require_mknod
+_require_file_attr
 
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
@@ -43,9 +44,6 @@
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
-file_attr --get $projectdir ./fifo &>/dev/null || \
-	_notrun "file_getattr not supported on $FSTYP"
-
 echo "Error codes"
 # wrong AT_ flags
 file_attr --get --invalid-at $projectdir ./foo
diff --git a/tests/xfs/648 b/tests/xfs/648
index e3c2fbe00b..58e5aa8c5b 100755
--- a/tests/xfs/648
+++ b/tests/xfs/648
@@ -20,7 +20,8 @@
 _require_test_program "file_attr"
 _require_symlinks
 _require_mknod
-
+_require_file_attr
+_require_file_attr_special
 _scratch_mkfs >>$seqres.full 2>&1
 _qmount_option "pquota"
 _scratch_mount
@@ -47,9 +48,6 @@
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
-$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
-	_notrun "file_getattr not supported on $FSTYP"
-
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \

-- 
- Andrey

