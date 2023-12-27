Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747FA1375;
	Mon,  1 Jan 2024 01:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEBrf9i9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAC4C433C7;
	Mon,  1 Jan 2024 01:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071134;
	bh=uQgqtH9eeWV39z+CWK1TSEIoF1SZ0iUAoOrg3IIv73A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fEBrf9i9U+WzoFwDmtPCO0hrsYpO5JDgfmpS+vIaiKw+aKUCSiBYCFFmYzwPheBfd
	 A0RGs3J2frksRDa4xBdemNs/InRNIdjNCScD7o7KamMvReEa7wa6fgpimor+kWTOaj
	 rjY1LCpnrH8AXv01sLn8KnP+iNKm8CsFQKR2Mm+OffuI8dedNTbQjKUh5+6fu1M2bR
	 gpUOLcOOvle4lO9kVOXYA/eU2Qj9A4HCAsisLrKK1yKyHJzVpzsOqBTpdEN+r/dA3D
	 aDFxOpUvRNv5YsubvrLho4o9+a0hzSZxWvAHLbZ2mMT61XpzFzohl6LwAMO8++mSS7
	 mZ0KDSYFnNprw==
Date: Sun, 31 Dec 2023 17:05:33 +9900
Subject: [PATCH 1/3] common: enable testing of realtime quota when supported
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405033132.1827880.10074394252232670734.stgit@frogsfrogsfrogs>
In-Reply-To: <170405033118.1827880.4279631111094836504.stgit@frogsfrogsfrogs>
References: <170405033118.1827880.4279631111094836504.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 common/quota    |   12 ++++++------
 common/xfs      |   12 ++++++++++++
 3 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/common/populate b/common/populate
index 1e51eedddc..538cbc86fc 100644
--- a/common/populate
+++ b/common/populate
@@ -240,7 +240,7 @@ _populate_xfs_qmount_option()
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
 		# No quota support
 		return
-	elif [ "${USE_EXTERNAL}" = "yes" ] && [ ! -z "${SCRATCH_RTDEV}" ]; then
+	elif [ "${USE_EXTERNAL}" = "yes" ] && [ ! -z "${SCRATCH_RTDEV}" ] && ! _xfs_supports_rtquota; then
 		# Quotas not supported on rt filesystems
 		return
 	elif [ -z "${XFS_QUOTA_PROG}" ]; then
diff --git a/common/quota b/common/quota
index 6b529bf4b4..565057d932 100644
--- a/common/quota
+++ b/common/quota
@@ -23,10 +23,10 @@ _require_quota()
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
 	    _notrun "Installed kernel does not support XFS quotas"
         fi
-	if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
+	if [ "$USE_EXTERNAL" = yes ] && [ -n "$TEST_RTDEV" ] && ! _xfs_supports_rtquota; then
 	    _notrun "Quotas not supported on realtime test device"
 	fi
-	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+	if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && ! _xfs_supports_rtquota; then
 	    _notrun "Quotas not supported on realtime scratch device"
 	fi
 	;;
@@ -44,10 +44,10 @@ _require_xfs_quota()
 {
     $here/src/feature -q $TEST_DEV
     [ $? -ne 0 ] && _notrun "Installed kernel does not support XFS quota"
-    if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
+    if [ "$USE_EXTERNAL" = yes ] && [ -n "$TEST_RTDEV" ] && ! _xfs_supports_rtquota; then
 	_notrun "Quotas not supported on realtime test device"
     fi
-    if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+    if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && ! _xfs_supports_rtquota; then
 	_notrun "Quotas not supported on realtime scratch device"
     fi
     [ -n "$XFS_QUOTA_PROG" ] || _notrun "XFS quota user tools not installed"
@@ -153,8 +153,8 @@ _require_prjquota()
     fi
     $here/src/feature -P $_dev
     [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
-    if [ "$USE_EXTERNAL" = yes ]; then
-	if [ -n "$TEST_RTDEV" -o -n "$SCRATCH_RTDEV" ]; then
+    if [ "$FSTYP" = "xfs" ] && [ "$USE_EXTERNAL" = yes ]; then
+	if [ -n "$TEST_RTDEV" -o -n "$SCRATCH_RTDEV" ] && ! _xfs_supports_rtquota; then
 	    _notrun "Project quotas not supported on realtime filesystem"
 	fi
     fi
diff --git a/common/xfs b/common/xfs
index 69a0eb620c..56c4b20889 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2194,3 +2194,15 @@ _scratch_find_rt_metadir_entry() {
 
 	return 1
 }
+
+_xfs_supports_rtquota() {
+	test "$FSTYP" = "xfs" || return 1
+
+	local xqmfile="/proc/fs/xfs/xqm"
+
+	test -e "$xqmfile" || modprobe xfs
+	test -e "$xqmfile" || return 1
+
+	local rtquota="$(cat "$xqmfile" | awk '{print $5}')"
+	test "$rtquota" = "1"
+}

