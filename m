Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C177EE;
	Mon,  1 Jan 2024 00:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3C4JRiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208FFC433C8;
	Mon,  1 Jan 2024 00:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070398;
	bh=JrNNoZs4D4FgDGNVqNZm1bXpsajWMe9ooFf8O9bwEk0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U3C4JRiDUALn790u4GLFx1eQ1BPtYHu4e2mAzk52AmtmBchMHRasuqqffzohfdEsB
	 c7eDeq5nUGDT5VEbFeOMmv2FOmLshw28Bm/C4swNE7yYqsbYRUZOcPHAQp0ju2RukY
	 RI7cgR1Y518e3WCnlroU+txrk1jD4AEI+CROVDn+N2XWs93f7e/nCdyH7BMt/tW+TJ
	 bL+Cx8Y6/f4Jfn1yzXtzUAE0zccWO51j3YxPWPdN67bG39/Kx6mKzRnV/NmWZ+fpMy
	 2xtdHOdRTBgazDnDtXKPmskT/T81DaiJ/RcC34n5QUJBPzwcpg+rFncAMwSGAMf8RI
	 o3QpUiwib2/0Q==
Date: Sun, 31 Dec 2023 16:53:17 +9900
Subject: [PATCH 02/17] common/xfs: wipe external logs during mdrestore
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030363.1826350.16500443816959304020.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

The XFS metadump file format doesn't support the capture of external log
devices, which means that mdrestore ought to wipe the external log and
run xfs_repair to rewrite the log device as needed to get the restored
filesystem to work again.  The common/populate code could already do
this, so push it to the common xfs helper.

While we're at it, fix the uncareful usage of SCRATCH_LOGDEV in the
populate code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy    |    7 ++++++-
 common/populate |   19 ++++++-------------
 common/xfs      |   21 +++++++++++++++++++--
 3 files changed, 31 insertions(+), 16 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index b72b4a9fe7..b72ee3f67f 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -304,7 +304,12 @@ __scratch_xfs_fuzz_unmount()
 __scratch_xfs_fuzz_mdrestore()
 {
 	__scratch_xfs_fuzz_unmount
-	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" || \
+
+	local logdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		logdev=$SCRATCH_LOGDEV
+
+	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" "${logdev}" || \
 		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
 }
 
diff --git a/common/populate b/common/populate
index 72c88e0651..92a3c5e354 100644
--- a/common/populate
+++ b/common/populate
@@ -1011,21 +1011,14 @@ _scratch_populate_cache_tag() {
 _scratch_populate_restore_cached() {
 	local metadump="$1"
 
+	local logdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		logdev=$SCRATCH_LOGDEV
+
 	case "${FSTYP}" in
 	"xfs")
-		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		res=$?
-		test $res -ne 0 && return $res
-
-		# Cached images should have been unmounted cleanly, so if
-		# there's an external log we need to wipe it and run repair to
-		# format it to match this filesystem.
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			$WIPEFS_PROG -a "${SCRATCH_LOGDEV}"
-			_scratch_xfs_repair
-			res=$?
-		fi
-		return $res
+		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
 		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
diff --git a/common/xfs b/common/xfs
index b88491666d..77ba786ece 100644
--- a/common/xfs
+++ b/common/xfs
@@ -683,7 +683,8 @@ _xfs_metadump() {
 _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
-	shift; shift
+	local logdev="$3"
+	shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -697,6 +698,18 @@ _xfs_mdrestore() {
 	test -r "$metadump" || return 1
 
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
+	res=$?
+	test $res -ne 0 && return $res
+
+	# mdrestore does not know how to restore an external log.  If there is
+	# one, we need to erase the log header and run xfs_repair to format a
+	# new log header onto the log device.
+	if [ "$logdev" != "none" ]; then
+		$XFS_IO_PROG -d -c 'pwrite -S 0 -q 0 1m' "$logdev"
+		_scratch_xfs_repair >> $seqres.full 2>&1
+		res=$?
+	fi
+	return $res
 }
 
 # Snapshot the metadata on the scratch device
@@ -718,7 +731,11 @@ _scratch_xfs_mdrestore()
 	local metadump=$1
 	shift
 
-	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
+	local logdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		logdev=$SCRATCH_LOGDEV
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
 }
 
 # Do not use xfs_repair (offline fsck) to rebuild the filesystem

