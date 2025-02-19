Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D152A14375D;
	Wed, 19 Feb 2025 01:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926939; cv=none; b=fkrwmPCUjlydLNLKPNgylJJCFWBFC/okawW5I02uouLkEtxujvY8cf7vOtXAC3bZYK2TOhhBNC+/6EZf3cG6QVvmLXBusNWEKWD4Mi7UhwFJ2SGT0WVJqF+QhtqheCWf/RfebjLGKepoPd7A5d/NFjgjJtBIcw2VIOqJVq/U2CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926939; c=relaxed/simple;
	bh=v0rTaWJCm8wqV+ua902nwh/+OI2d6hx3DxBHOWCRrCY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgjHE/o7Skjz1bV0yfXFEzEh9Hw+NKxzGkjcck1HJ/z98rETnWdZQp7mvUaLZQqbknXWxiwsx9J+5SPxzkdTeHMMJPWsxTUUI3qt0n3p7voO5s5bviZxUw+AvI2e8T7tAmPrTI1CPs1vphx7VZHdHAtyJiI35c312rQfZNVPvWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AB/8o1gZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AB/8o1gZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DC7C4CEE6;
	Wed, 19 Feb 2025 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926939;
	bh=v0rTaWJCm8wqV+ua902nwh/+OI2d6hx3DxBHOWCRrCY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AB/8o1gZqtjyygDpz6PX0DjCgdBCuZTKMbABTi1up4ZDv6Of92+Up24DejrnsvQ+n
	 fXgsezbPF/Yt1he7Z/11aqz6l+18rudPUDOee11AZ0Al7xudjYlS6Hb3ttCPPyy0kj
	 x+tqzQdbHW+Pfx5af2gk14I+S37H6RRKMmC5nBwoSgYaqj14Oh9ZKf6xotegxg/Uss
	 itCb5QaEHi73XSLOfrjPvu0pRNW31Me5jvYJI2HpsQiW5i0fiCPiXn+iCR3xXjuARc
	 JPHPiavOL24MdxkkNnGyjo+N8UBIJakZTRUnwbxHNseAaDkNhkZhgwUSyUwP3h0Va5
	 8X092GdCDNSkQ==
Date: Tue, 18 Feb 2025 17:02:19 -0800
Subject: [PATCH 3/4] xfs: fix quota detection in fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589897.4080063.9479673215974446416.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

With metadir, quota options persist until they are changed by mount
options.  Therefore, we can set the quota flags in MKFS_OPTIONS and
needn't supply them in MOUNT_OPTIONS.  Unfortunately, this means that we
cannot grep the MOUNT_OPTIONS anymore; we must mount the fs and run
src/feature to determine if quotas are enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/425 |    5 ++++-
 tests/xfs/426 |    5 ++++-
 tests/xfs/427 |    5 ++++-
 tests/xfs/428 |    5 ++++-
 tests/xfs/429 |    5 ++++-
 tests/xfs/430 |    5 ++++-
 tests/xfs/487 |    5 ++++-
 tests/xfs/488 |    5 ++++-
 tests/xfs/489 |    5 ++++-
 tests/xfs/779 |    5 ++++-
 tests/xfs/780 |    5 ++++-
 tests/xfs/781 |    5 ++++-
 12 files changed, 48 insertions(+), 12 deletions(-)


diff --git a/tests/xfs/425 b/tests/xfs/425
index 7ad53f97a6940c..77f86bcc398312 100755
--- a/tests/xfs/425
+++ b/tests/xfs/425
@@ -23,7 +23,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
+
+_scratch_mount
+$here/src/feature -U $SCRATCH_DEV || _notrun "user quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/426 b/tests/xfs/426
index 53bfd0d637fcb5..80f572eb8068a2 100755
--- a/tests/xfs/426
+++ b/tests/xfs/426
@@ -23,7 +23,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
+
+_scratch_mount
+$here/src/feature -U $SCRATCH_DEV || _notrun "user quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/427 b/tests/xfs/427
index 38de1360af6262..48b8d5e935abfe 100755
--- a/tests/xfs/427
+++ b/tests/xfs/427
@@ -23,7 +23,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
+
+_scratch_mount
+$here/src/feature -G $SCRATCH_DEV || _notrun "group quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/428 b/tests/xfs/428
index e112ccf84646c1..f87f0a98bae3e9 100755
--- a/tests/xfs/428
+++ b/tests/xfs/428
@@ -23,7 +23,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
+
+_scratch_mount
+$here/src/feature -G $SCRATCH_DEV || _notrun "group quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/429 b/tests/xfs/429
index ded8c3944a2648..426e716aa079bf 100755
--- a/tests/xfs/429
+++ b/tests/xfs/429
@@ -23,7 +23,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
+
+_scratch_mount
+$here/src/feature -P $SCRATCH_DEV || _notrun "project quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/430 b/tests/xfs/430
index 3e6527851069a9..b3a2c6dd1a5f6a 100755
--- a/tests/xfs/430
+++ b/tests/xfs/430
@@ -23,7 +23,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
+
+_scratch_mount
+$here/src/feature -P $SCRATCH_DEV || _notrun "project quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/487 b/tests/xfs/487
index 0a5403a25dfd82..809a4c6fd621cd 100755
--- a/tests/xfs/487
+++ b/tests/xfs/487
@@ -24,7 +24,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
+
+_scratch_mount
+$here/src/feature -U $SCRATCH_DEV || _notrun "user quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/488 b/tests/xfs/488
index 0e67889f26f7a0..a8144c9ce39b91 100755
--- a/tests/xfs/488
+++ b/tests/xfs/488
@@ -24,7 +24,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
+
+_scratch_mount
+$here/src/feature -G $SCRATCH_DEV || _notrun "group quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/489 b/tests/xfs/489
index ef65525c224764..cb24b444bcc919 100755
--- a/tests/xfs/489
+++ b/tests/xfs/489
@@ -24,7 +24,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
+
+_scratch_mount
+$here/src/feature -P $SCRATCH_DEV || _notrun "project quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/779 b/tests/xfs/779
index acce522995c693..e1e44c1928c67b 100755
--- a/tests/xfs/779
+++ b/tests/xfs/779
@@ -25,7 +25,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
+
+_scratch_mount
+$here/src/feature -U $SCRATCH_DEV || _notrunn "user quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/780 b/tests/xfs/780
index efcbeb8e147353..ebd25f8a13bab4 100755
--- a/tests/xfs/780
+++ b/tests/xfs/780
@@ -25,7 +25,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
+
+_scratch_mount
+$here/src/feature -G $SCRATCH_DEV || _notrun "group quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 
diff --git a/tests/xfs/781 b/tests/xfs/781
index 09d63bfeceb6e7..49920cd1215ec1 100755
--- a/tests/xfs/781
+++ b/tests/xfs/781
@@ -25,7 +25,10 @@ _require_quota
 
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
-echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
+
+_scratch_mount
+$here/src/feature -P $SCRATCH_DEV || _notrun "project quota disabled"
+_scratch_unmount
 
 _scratch_xfs_set_quota_fuzz_ids
 

