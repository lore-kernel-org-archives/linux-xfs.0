Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48A91A275
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 13:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763990424; cv=none; b=IdemAJyMkDdh17L/cAJamnhnVBncHXdqE3YScB/0C5Z0f0H961C5sgpudo7i+pmmsJojeEq9DEmrFCtGNOBLYq36s954YYKpqXJ6VvFZrA/21O/JDAHbY/ZNlw82HEavT3cdoTiCYFSo6yDpCVfHV4cZJTcK8WC730JGpsiNOKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763990424; c=relaxed/simple;
	bh=8cEVA4q5ZHQ+hr5gifg8ACuEi5xp9kCN/TI1goGswI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ghp1fQPEt5wC3Oi42K67/eIj8CPc6bC0wQgiN8iuZDgilDsToWqupkpc/Mo/qdRDxdQu8tHb011pI80w5s+lTbCIZG3vaW027MXeMtA7Xlhkqq1gc/fUyFZcLhKx4E621a3ciVpJZnroHgRrhcsw495GVdO5DWffRtzMTI3Yx7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LMmj0gVa; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LMmj0gVa"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso46505425e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 05:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763990420; x=1764595220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q/isk8s+NNhtumspmAWAcqJr8SZvKeuAWhZEZe4B8kU=;
        b=LMmj0gVaFyb8jCBj4iCcLhXhZtePBtnUTRctUpLHYEhLs5AWOM4eHrUUeBcHa6ft8K
         3IuQDfYNWwG1Qai4OG3D8cLy3oGa87JVvq3oSnPy6TEUTpQxWgTGBq1JG2YJJ8ZWe4UP
         4hEoyizJ8euFQ2Umh7LvzZKa7Ao9WkWAW+68vu7Y/onwEgXPolKvd/tFtfbjQJak7qfe
         G/82Cl8WI3375138LFyFf5Nx5NbefMPGY5IlSUVvS477AZfuZlAma5KgXaslOGDGTmnK
         sdyTpdT1bMF6Xq1LxaXKJnnW7r5Ocv+lfn75DT5VK+MpmpbTRDpJQ3jE8FLcMqoL2NZj
         95gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763990420; x=1764595220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/isk8s+NNhtumspmAWAcqJr8SZvKeuAWhZEZe4B8kU=;
        b=DY3GTVYaasP0QHUwcpNLhrWzSc4p8Ygra79BnNKm4v1b4Mtk+Fa4KH31D2ZvlOhQND
         FgZZ1ibbM3JblyFM1FKH81B1nyH8IHoVnW8NCB/yUDkv2miGou2nXU0/PALMTiWF/irt
         +HGjLi8wYFEf3Nmcr1Czd3ZDtYnwuk/yiX3fTVCbicqG2GmZnFSMQLpT0ZtvKVwLNoKW
         TUkfhEgeE6Jasl4oD/xYvMd80Qevzl1xHLie9ynNYTgkZNLv2tgPj0pHxE5uS9E8Px5J
         /fkicLJEWvS5x8DPyQPlEfXENviQS7L7ZZ+gDiUqX5STJQdUTpBlV0G/xCqaj65DtpBh
         JqWA==
X-Forwarded-Encrypted: i=1; AJvYcCUFKKoIjUf8EmGx887+tyBDcnpMbOtCP53o9SCGgg03foRF51L5oh/2RRgW3ognq0ey81PMSi+/UKE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz273/aX6Z18uY6w+siRMOj55ReliyZSvWV1OuMlUWAxr8QixHN
	m40nt+t8BvpfhL3w9fdY6vCvWXtA9eJBOvCCIBgkqk8eOUh/YmUsS/pBdTBrNjxB4ck=
X-Gm-Gg: ASbGncu4qOHcLanoT7D/5g5gv7zgPJvBXUZVqRnQdW3NeKKo/aQZjcN7CmpPhmCn/yi
	SwvHlCXJAL6H3/3K5yzFkluXfbWC61+UTtf7R/XFcNKzM8DXCy1KVMPR8eJHv5ugj/MecXyXz07
	f/fGBgZjD68TrGxfP5FNJQYLZXS1/8nUdZQQy7lBywczT0Tz0TGkWDu2ElAuy359LdRCf38JzGm
	U8vvrVywN/5onM4vaZwa5slNZI+AEwj2vcQ0W5B3yGnggyxsbJTA2WnTDX7w1SmEW1JQxOzm4HB
	05mNSo0SpinNbZBO5fwK8/INIE9NDRLOiA4DWsAwCz0sJJ+32WYqvpRUXqIJXBY/9fvHHk6kJJS
	k/J0lXxli7FDvpT3mqj6aNqbwvdyM8naq/VD0DJwFioauOlyjXUu1WTc5xkEbo1Eyq1Awq2uoAg
	msdPkNtuRFD2UW0WIZBlhqPKhP6y82GiW9MFPpTg==
X-Google-Smtp-Source: AGHT+IHgUGp4XaDDyqrMS/EIn2pms/acven8AxxWB4zO6hMRWGBdsiNeKGsTxhL2WUvooMOUZamzJg==
X-Received: by 2002:a05:600c:1f94:b0:477:af07:dd21 with SMTP id 5b1f17b1804b1-477c1123edfmr96289885e9.25.1763990420240;
        Mon, 24 Nov 2025 05:20:20 -0800 (PST)
Received: from MacBookPro.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc3d0bb6sm73035838eec.2.2025.11.24.05.20.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 24 Nov 2025 05:20:19 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: l@damenly.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] generic: use _qmount_option and _qmount
Date: Mon, 24 Nov 2025 21:20:04 +0800
Message-ID: <20251124132004.23965-1-glass.su@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many generic tests call `_scratch_mount -o usrquota` then
chmod 777, quotacheck and quotaon.
It can be simpilfied to _qmount_option and _qmount. The later
function already calls quotacheck, quota and chmod.

Convertaions can save a few lines. tests/generic/380 is an exception
because it tests chown.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 tests/generic/082 |  9 ++-------
 tests/generic/219 | 11 ++++-------
 tests/generic/230 | 11 ++++++-----
 tests/generic/231 |  6 ++----
 tests/generic/232 |  6 ++----
 tests/generic/233 |  6 ++----
 tests/generic/234 |  5 ++---
 tests/generic/235 |  5 ++---
 tests/generic/244 |  1 -
 tests/generic/270 |  6 ++----
 tests/generic/280 |  5 ++---
 tests/generic/400 |  2 +-
 12 files changed, 27 insertions(+), 46 deletions(-)

diff --git a/tests/generic/082 b/tests/generic/082
index f078ef2ffff9..6bb9cf2a22ae 100755
--- a/tests/generic/082
+++ b/tests/generic/082
@@ -23,13 +23,8 @@ _require_scratch
 _require_quota
 
 _scratch_mkfs >>$seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-
-# xfs doesn't need these setups and quotacheck even fails on xfs, so just
-# redirect the output to $seqres.full for debug purpose and ignore the results,
-# as we check the quota status later anyway.
-quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
-quotaon $SCRATCH_MNT >>$seqres.full 2>&1
+_qmount_option 'usrquota,grpquota'
+_qmount "usrquota,grpquota"
 
 # first remount ro with a bad option, a failed remount ro should not disable
 # quota, but currently xfs doesn't fail in this case, the unknown option is
diff --git a/tests/generic/219 b/tests/generic/219
index 642823859886..a2eb0b20f408 100755
--- a/tests/generic/219
+++ b/tests/generic/219
@@ -91,25 +91,22 @@ test_accounting()
 
 _scratch_unmount 2>/dev/null
 _scratch_mkfs >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
+_qmount_option "usrquota,grpquota"
+_qmount
 _force_vfs_quota_testing $SCRATCH_MNT
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon $SCRATCH_MNT 2>/dev/null
 _scratch_unmount
 
 echo; echo "### test user accounting"
-export MOUNT_OPTIONS="-o usrquota"
+_qmount_option "usrquota"
 _qmount
-quotaon $SCRATCH_MNT 2>/dev/null
 type=u
 test_files
 test_accounting
 _scratch_unmount 2>/dev/null
 
 echo; echo "### test group accounting"
-export MOUNT_OPTIONS="-o grpquota"
+_qmount_option "grpquota"
 _qmount
-quotaon $SCRATCH_MNT 2>/dev/null
 type=g
 test_files
 test_accounting
diff --git a/tests/generic/230 b/tests/generic/230
index a8caf5a808c3..0a680dbc874b 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -99,7 +99,8 @@ grace=2
 _qmount_option 'defaults'
 
 _scratch_mkfs >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
+_qmount_option "usrquota,grpquota"
+_qmount
 _force_vfs_quota_testing $SCRATCH_MNT
 BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
@@ -113,8 +114,8 @@ setquota -g -t $grace $grace $SCRATCH_MNT
 _scratch_unmount
 
 echo; echo "### test user limit enforcement"
-_scratch_mount "-o usrquota"
-quotaon $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota"
+_qmount
 type=u
 test_files
 test_enforcement
@@ -122,8 +123,8 @@ cleanup_files
 _scratch_unmount 2>/dev/null
 
 echo; echo "### test group limit enforcement"
-_scratch_mount "-o grpquota"
-quotaon $SCRATCH_MNT 2>/dev/null
+_qmount_option "grpquota"
+_qmount
 type=g
 test_files
 test_enforcement
diff --git a/tests/generic/231 b/tests/generic/231
index ce7e62ea1886..02910523d0b5 100755
--- a/tests/generic/231
+++ b/tests/generic/231
@@ -47,10 +47,8 @@ _require_quota
 _require_user
 
 _scratch_mkfs >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-chmod 777 $SCRATCH_MNT
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon -u -g $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota,grpquota"
+_qmount
 
 if ! _fsx 1; then
 	_scratch_unmount 2>/dev/null
diff --git a/tests/generic/232 b/tests/generic/232
index c903a5619045..21375809d299 100755
--- a/tests/generic/232
+++ b/tests/generic/232
@@ -44,10 +44,8 @@ _require_scratch
 _require_quota
 
 _scratch_mkfs > $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-chmod 777 $SCRATCH_MNT
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon -u -g $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota,grpquota"
+_qmount
 
 _fsstress
 _check_quota_usage
diff --git a/tests/generic/233 b/tests/generic/233
index 3fc1b63abb24..4606f3bde2ab 100755
--- a/tests/generic/233
+++ b/tests/generic/233
@@ -59,10 +59,8 @@ _require_quota
 _require_user
 
 _scratch_mkfs > $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-chmod 777 $SCRATCH_MNT
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon -u -g $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota,grpquota"
+_qmount
 setquota -u $qa_user 32000 32000 1000 1000 $SCRATCH_MNT 2>/dev/null
 
 _fsstress
diff --git a/tests/generic/234 b/tests/generic/234
index 4b25fc6507cc..2c596492a3e0 100755
--- a/tests/generic/234
+++ b/tests/generic/234
@@ -66,9 +66,8 @@ _require_quota
 
 
 _scratch_mkfs >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon -u -g $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota,grpquota"
+_qmount
 test_setting
 _scratch_unmount
 
diff --git a/tests/generic/235 b/tests/generic/235
index 037c29e806db..7a616650fc8f 100755
--- a/tests/generic/235
+++ b/tests/generic/235
@@ -25,9 +25,8 @@ do_repquota()
 
 
 _scratch_mkfs >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota,grpquota"
+_qmount
 
 touch $SCRATCH_MNT/testfile
 chown $qa_user:$qa_user $SCRATCH_MNT/testfile
diff --git a/tests/generic/244 b/tests/generic/244
index b68035129c82..989bb4f5385e 100755
--- a/tests/generic/244
+++ b/tests/generic/244
@@ -66,7 +66,6 @@ done
 # remount just for kicks, make sure we get it off disk
 _scratch_unmount
 _qmount
-quotaon $SCRATCH_MNT 2>/dev/null
 
 # Read them back by iterating based on quotas returned.
 # This should match what we set, even if we don't directly
diff --git a/tests/generic/270 b/tests/generic/270
index c3d5127a0b51..9ac829a7379f 100755
--- a/tests/generic/270
+++ b/tests/generic/270
@@ -62,10 +62,8 @@ _require_command "$SETCAP_PROG" setcap
 _require_attrs security
 
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-chmod 777 $SCRATCH_MNT
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon -u -g $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota,grpquota"
+_qmount
 
 if ! _workout; then
 	_scratch_unmount 2>/dev/null
diff --git a/tests/generic/280 b/tests/generic/280
index 3108fd23fb70..fae0a02145cf 100755
--- a/tests/generic/280
+++ b/tests/generic/280
@@ -34,9 +34,8 @@ _require_freeze
 
 _scratch_unmount 2>/dev/null
 _scratch_mkfs >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
-quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-quotaon $SCRATCH_MNT 2>/dev/null
+_qmount_option "usrquota,grpquota"
+_qmount
 xfs_freeze -f $SCRATCH_MNT
 setquota -u root 1 2 3 4 $SCRATCH_MNT &
 pid=$!
diff --git a/tests/generic/400 b/tests/generic/400
index 77970da69a41..ef27c254167c 100755
--- a/tests/generic/400
+++ b/tests/generic/400
@@ -22,7 +22,7 @@ _require_scratch
 
 _scratch_mkfs >> $seqres.full 2>&1
 
-MOUNT_OPTIONS="-o usrquota,grpquota"
+_qmount_option "usrquota,grpquota"
 _qmount
 _require_getnextquota
 
-- 
2.48.1

