Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065CD7F9;
	Mon,  1 Jan 2024 00:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Awqf3Hab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75003C433C7;
	Mon,  1 Jan 2024 00:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070288;
	bh=eGnebMU3AYPXGsWRbLGxfWhbyDb8nl/NZa+1tdT9atA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Awqf3Habpp0R6x8S1yMWwJw0BBqQKrj8aLXa8Mne7NP+57s9itKfezAVYk9gcSiex
	 Zg36EapZcm/QlZ1gzl9pIri3qt+ILN6V1FYznItFNdt3jdRlLyfaSMAOcOblnDTRgb
	 Um3gEoA4B785m7It9Wdk8FI9qD9yAQ4+ew9O2XBd30KTeZ37IsHrXg/fboOq1lX+BW
	 D5yKzelNnUG52AVWEkFbpxhijgYQzS8kimSWIfwZJWchM3PhMf3eUgKpqYQ/6i2oVa
	 1ZefG7Ehpz+HMpjxXivz8AxhfKDNgZSdZ848WZrDxRC5/QhSke6B1Z98Glp52Tayhy
	 JaGClCPDvm4xg==
Date: Sun, 31 Dec 2023 16:51:28 +9900
Subject: [PATCH 06/11] xfs/{050,144,153,299,330}: update quota reports to
 handle metadir trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029929.1826032.12064629466073994470.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

Prior to the new metadir feature in XFS, the rtbitmap and rtsummary
files were included in icount, though their bcount contribution is zero
due to rt and quota not being supported together.  With the new metadir
feature in XFS, no files in the metadata directory tree are counted in
quota.

Hence we must adjust the icount of any quota report down by two to avoid
breaking golden outputs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/filter |    7 +++++--
 common/xfs    |   29 +++++++++++++++++++++++++++++
 tests/xfs/050 |    5 +++++
 tests/xfs/153 |    5 +++++
 tests/xfs/299 |    1 +
 tests/xfs/330 |    6 +++++-
 6 files changed, 50 insertions(+), 3 deletions(-)


diff --git a/common/filter b/common/filter
index 509ee95039..904263b3e7 100644
--- a/common/filter
+++ b/common/filter
@@ -618,11 +618,14 @@ _filter_getcap()
 
 # Filter user/group/project id numbers out of quota reports, and standardize
 # the block counts to use filesystem block size.  Callers must set the id and
-# bsize variables before calling this function.
+# bsize variables before calling this function.  The HIDDEN_QUOTA_FILES variable
+# (by default zero) is the number of root files to filter out of the inode
+# count part of the quota report.
 _filter_quota_report()
 {
 	test -n "$id" || echo "id must be set"
 	test -n "$bsize" || echo "block size must be set"
+	test -n "$HIDDEN_QUOTA_FILES" || HIDDEN_QUOTA_FILES=0
 
 	tr -s '[:space:]' | \
 	perl -npe '
@@ -630,7 +633,7 @@ _filter_quota_report()
 		s/^\#0 \d+ /[ROOT] 0 /g;
 		s/6 days/7 days/g' |
 	perl -npe '
-		$val = 0;
+		$val = '"$HIDDEN_QUOTA_FILES"';
 		if ($ENV{'LARGE_SCRATCH_DEV'}) {
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
diff --git a/common/xfs b/common/xfs
index 007c8704ce..c6a60119f9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1884,3 +1884,32 @@ _scratch_xfs_force_no_metadir()
 		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
 	fi
 }
+
+# Decide if a mount filesystem has metadata directory trees.
+_xfs_mount_has_metadir() {
+	local mount="$1"
+
+	# spaceman (and its info command) predate metadir
+	test ! -e "$XFS_SPACEMAN_PROG" && return 1
+	$XFS_SPACEMAN_PROG -c "info" "$mount" | grep -q 'metadir=1'
+}
+
+# Compute the number of files that are not counted in quotas.
+_xfs_calc_hidden_quota_files() {
+	local mount="$1"
+
+	if _xfs_mount_has_metadir "$mount"; then
+		# Prior to the metadir feature, the realtime bitmap and summary
+		# file were "owned" by root and hence accounted to the root
+		# dquots.  The metadata directory feature stopped accounting
+		# metadata files to quotas, so we must subtract 2 inodes from
+		# the repquota golden outputs to keep the tests going.
+		#
+		# We needn't adjust the block counts because the kernel doesn't
+		# support rt quota and hence the rt metadata files will always
+		# be zero length.
+		echo -2
+	else
+		echo 0
+	fi
+}
diff --git a/tests/xfs/050 b/tests/xfs/050
index 2220e47016..10294e3f6d 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -32,9 +32,14 @@ _require_scratch
 _require_xfs_quota
 
 _scratch_mkfs >/dev/null 2>&1
+orig_mntopts="$MOUNT_OPTIONS"
+_qmount_option "uquota"
 _scratch_mount
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+# needs quota enabled to compute the number of metadata dir files
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 _scratch_unmount
+MOUNT_OPTIONS="$orig_mntopts"
 
 bsoft=$(( 200 * $bsize ))
 bhard=$(( 1000 * $bsize ))
diff --git a/tests/xfs/153 b/tests/xfs/153
index dbe26b6803..9def579bba 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -37,9 +37,14 @@ _require_idmapped_mounts
 _require_test_program "vfs/mount-idmapped"
 
 _scratch_mkfs >/dev/null 2>&1
+orig_mntopts="$MOUNT_OPTIONS"
+_qmount_option "uquota"
 _scratch_mount
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+# needs quota enabled to compute the number of metadata dir files
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 _scratch_unmount
+MOUNT_OPTIONS="$orig_mntopts"
 
 bsoft=$(( 200 * $bsize ))
 bhard=$(( 1000 * $bsize ))
diff --git a/tests/xfs/299 b/tests/xfs/299
index 4b9df3c6aa..49a6527255 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -159,6 +159,7 @@ _qmount_option "uquota,gquota,pquota"
 _qmount
 
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 
 bsoft=$(( 100 * $bsize ))
 bhard=$(( 500 * $bsize ))
diff --git a/tests/xfs/330 b/tests/xfs/330
index c6e74e67e8..7ebbffff2a 100755
--- a/tests/xfs/330
+++ b/tests/xfs/330
@@ -26,7 +26,10 @@ _require_nobody
 
 do_repquota()
 {
-	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r
+	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r | \
+	perl -npe '
+		$val = '"$HIDDEN_QUOTA_FILES"';
+		s/(^root\s+--\s+\S+\s+\S+\s+\S+\s+)(\S+)/$1@{[$2 - $val]}/g'
 }
 
 rm -f "$seqres.full"
@@ -35,6 +38,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> "$seqres.full" 2>&1
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 

