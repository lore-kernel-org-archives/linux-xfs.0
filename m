Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1963514A639;
	Wed, 19 Feb 2025 01:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926972; cv=none; b=PRlJc+3m9KMYw9ECvKIH/yEXfYkNJJJ8nos61f8bprshSQhRRB4KvW5F1qmpAeEgtPOvGhyZV0EBrj2PmKU4z0MHbOAo6ZnjDSbXlV+cSOmQjQaSgZfvyggIQ6DQzxYOQRe40AfWx440MPAZPcHugpRGv/PlWOjugE9y16hVeW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926972; c=relaxed/simple;
	bh=wIg/zLzlgKO0y0Bw/UQosTbzRZ5SPp0XjQGQJ4qV8mc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HXOEH2cOOwHABmbrL/IKPIgjnmddiharqmf33WmiwJDNf2ubSlzfnMmudWL5zw+r+XKO1NomijTS0FkaT+GFf4rozlSV6OvIOhW7JS/nFao+OkQRqqZo3is2B+jK8znSLOHoV90qP78x+hW4P+og7fPI81oAy7dYHy8VAmYyPjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oR8QkuHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oR8QkuHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5114C4CEE2;
	Wed, 19 Feb 2025 01:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926972;
	bh=wIg/zLzlgKO0y0Bw/UQosTbzRZ5SPp0XjQGQJ4qV8mc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oR8QkuHJ2no+ItHKzz0WaWBLJFzDFcbDqlTGaieeW8K4bHTpAI+5BweeSAOj9+60l
	 ngOgsc9+3LshuJu2gomOotcg1862eROyk65q7XPQi9E5nirOz+fXrQDIjHgvgvkGxz
	 rf8qkFztqoy4kCyewp9eg2jeCQNQrPK7sfpHYRu2BBQaGRNB9Ry4MYpMTr/2dk2dB3
	 vVLDsLj6PVm2kZ0WDDe5Nta86IIenW+/F0g7os3dHbctxsluO5ltkHL71MTTtopYyN
	 nbVSCn6P+kXOeJIf1OWPl9MHqnh9L6a/9ySswCI8BpJjRtVtJiBDlQzyjPEljrak5C
	 FTBWhnDTMa3Ug==
Date: Tue, 18 Feb 2025 17:02:51 -0800
Subject: [PATCH 1/3] common: enable testing of realtime quota when supported
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992590313.4080282.15839149250128680885.stgit@frogsfrogsfrogs>
In-Reply-To: <173992590283.4080282.6960202898585263825.stgit@frogsfrogsfrogs>
References: <173992590283.4080282.6960202898585263825.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the kernel advertises realtime quota support, test it.

However, this has a plot twist -- because rt quota only works if the xfs
is formatted with rtgroups, we have to mount a filesystem to see if
rtquota is actually supported.  Since it's time consuming to format and
mount the scratch filesystem, we'll assume that the test and scratch
fses have the same support.

This will cause problems if one sets SCRATCH_RTDEV but not TEST_RTDEV.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   10 ++++++---
 common/quota    |   20 +++---------------
 common/xfs      |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 20 deletions(-)


diff --git a/common/populate b/common/populate
index a77d1b0f5f3873..ade3ace886f4d4 100644
--- a/common/populate
+++ b/common/populate
@@ -245,9 +245,13 @@ _populate_xfs_qmount_option()
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
 		# No quota support
 		return
-	elif [ "${USE_EXTERNAL}" = "yes" ] && [ ! -z "${SCRATCH_RTDEV}" ]; then
-		# Quotas not supported on rt filesystems
-		return
+	elif [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_RTDEV}" ]; then
+		# We have not mounted the scratch fs, so we can only check
+		# rtquota support from the test fs.  Skip the quota options if
+		# the test fs does not have an rt section.
+		test -n "${TEST_RTDEV}" || return
+		_xfs_kmod_supports_rtquota || return
+		_xfs_test_supports_rtquota || return
 	elif [ -z "${XFS_QUOTA_PROG}" ]; then
 		# xfs quota tools not installed
 		return
diff --git a/common/quota b/common/quota
index 4ef0d4775067ee..6735d0fec48991 100644
--- a/common/quota
+++ b/common/quota
@@ -23,12 +23,7 @@ _require_quota()
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
 	    _notrun "Installed kernel does not support XFS quotas"
         fi
-	if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
-	    _notrun "Quotas not supported on realtime test device"
-	fi
-	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
-	    _notrun "Quotas not supported on realtime scratch device"
-	fi
+	_require_xfs_rtquota_if_rtdev
 	;;
     *)
 	_notrun "disk quotas not supported by this filesystem type: $FSTYP"
@@ -44,12 +39,7 @@ _require_xfs_quota()
 {
     $here/src/feature -q $TEST_DEV
     [ $? -ne 0 ] && _notrun "Installed kernel does not support XFS quota"
-    if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
-	_notrun "Quotas not supported on realtime test device"
-    fi
-    if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
-	_notrun "Quotas not supported on realtime scratch device"
-    fi
+    _require_xfs_rtquota_if_rtdev
     [ -n "$XFS_QUOTA_PROG" ] || _notrun "XFS quota user tools not installed"
 }
 
@@ -153,11 +143,7 @@ _require_prjquota()
     fi
     $here/src/feature -P $_dev
     [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
-    if [ "$USE_EXTERNAL" = yes ]; then
-	if [ -n "$TEST_RTDEV" -o -n "$SCRATCH_RTDEV" ]; then
-	    _notrun "Project quotas not supported on realtime filesystem"
-	fi
-    fi
+    test "$FSTYP" = "xfs" && _require_xfs_rtquota_if_rtdev
 }
 
 #
diff --git a/common/xfs b/common/xfs
index aae8b427d25fe9..adad37ea0710e0 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2073,3 +2073,65 @@ _require_xfs_scratch_metadir()
 		_scratch_unmount
 	fi
 }
+
+# Does the xfs kernel module support realtime quota?
+_xfs_kmod_supports_rtquota() {
+	local xqmfile="/proc/fs/xfs/xqm"
+
+	test -e "$xqmfile" || modprobe xfs
+	test -e "$xqmfile" || return 1
+
+	grep -q -w rtquota "$xqmfile"
+}
+
+# Does this mounted filesystem support realtime quota?  This is the only way
+# to check that the fs really supports it because the kernel ignores quota
+# mount options for pre-rtgroups realtime filesystems.
+_xfs_fs_supports_rtquota() {
+	local mntpt="$1"
+	local dev="$2"
+	local rtdev="$3"
+
+	test -d "$mntpt" || \
+		echo "_xfs_fs_supports_rtquota needs a mountpoint"
+	test "$USE_EXTERNAL" == "yes" || \
+		echo "_xfs_fs_supports_rtquota needs USE_EXTERNAL=yes"
+	test -n "$rtdev" || \
+		echo "_xfs_fs_supports_rtquota needs an rtdev"
+
+	$here/src/feature -U $dev || \
+		$here/src/feature -G $dev || \
+		$here/src/feature -P $dev
+}
+
+# Do we support realtime quotas on the (mounted) test filesystem?
+_xfs_test_supports_rtquota() {
+	_xfs_fs_supports_rtquota "$TEST_DIR" "$TEST_DEV" "$TEST_RTDEV"
+}
+
+# Do we support realtime quotas on the (mounted) scratch filesystem?
+_xfs_scratch_supports_rtquota() {
+	_xfs_fs_supports_rtquota "$SCRATCH_MNT" "$SCRATCH_DEV" "$SCRATCH_RTDEV"
+}
+
+# Make sure that we're set up for realtime quotas if external rt devices are
+# configured.  The test filesystem has to be mounted before each test, so we
+# can check that quickly, and we make the bold assumption that the same will
+# apply to any scratch fs that might be created.
+_require_xfs_rtquota_if_rtdev() {
+	test "$USE_EXTERNAL" = "yes" || return
+
+	if [ -n "$TEST_RTDEV$SCRATCH_RTDEV" ]; then
+		_xfs_kmod_supports_rtquota || \
+			_notrun "Kernel driver does not support rt quota"
+	fi
+
+	if [ -n "$TEST_RTDEV" ]; then
+		_xfs_test_supports_rtquota || \
+			_notrun "Quotas not supported on realtime device"
+	fi
+
+	if [ -n "$SCRATCH_RTDEV" ] && [ -z "$TEST_RTDEV" ]; then
+		_notrun "Quotas probably not supported on realtime scratch device; set TEST_RTDEV"
+	fi
+}

