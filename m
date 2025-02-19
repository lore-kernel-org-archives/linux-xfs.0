Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC6A2557A;
	Wed, 19 Feb 2025 00:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926486; cv=none; b=EGxFNJ6RB2kER5KZhiCcI+LFqq/SHMgpPmbYpvPVOTtF7anHNQayAsDGEe4trnf5IMBZXeMpwkcVBLSL5i1zK20FSsYxec0WSllNeQvRWoyojmMtmUnASsoygkeIdoFVxb/OW+ul3HBtLMARq9vPIOBsgLdjiQvP4jKknJga7x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926486; c=relaxed/simple;
	bh=SUPpXk+a9ACYvbNJhaVSc67+FpracQl3j4z2TJNdYXM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LoJy75StxxHoAzSoKq6WYZPhowBGDdvURl4FkQb8TXZ8oh2Q5m7ii12ovcXYCP48S5NydtY1OHvEELVIgJ7V2CZ/M54hdbxLUlNDkkm3O2ha/ywMY6DOU65sHAcMXl5Iyn7m7WuCB01/2vwFpjyp97GBqJZVTDspUkmfSEJkUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/HMoQCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/HMoQCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5746C4CEE2;
	Wed, 19 Feb 2025 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926485;
	bh=SUPpXk+a9ACYvbNJhaVSc67+FpracQl3j4z2TJNdYXM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f/HMoQCYhBfFQKFyKim5ij/FV2wjM5v6PEJh6W5rZJquq5x4dRGptcsZ+TEzoc9iF
	 MDz5JC/hQsrLYlMwm6iOM+3cBlJrMcfQ/vrfW6HSIXb9DSs9gGgU85dX1PT0Es6CRP
	 RNa+tszCESR28wEbzTpo5oIWQc3DFMdaEreZyZe5c2agJrCirRoVoRKNE3DlvekZfm
	 D1YZZFEhTpGJEWxxwrlo/HDHN8JbOSXcMkWLISoL0HZexWdJaKYar3bemrjKE8QIt0
	 gl5zwokPnASEzobG/7x7ympOy2Ura2JNdfxnqbOceFoJ3HqYVfKd5GZ8hr8yJxhrgI
	 VAyecHLWUIUlw==
Date: Tue, 18 Feb 2025 16:54:45 -0800
Subject: [PATCH 05/12] xfs/{050,144,153,299,330}: update quota reports to
 handle metadir trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588153.4078751.7769762708703860765.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/filter |    7 +++++--
 common/xfs    |   29 +++++++++++++++++++++++++++++
 tests/xfs/050 |    5 +++++
 tests/xfs/153 |    5 +++++
 tests/xfs/299 |    1 +
 tests/xfs/330 |    6 +++++-
 6 files changed, 50 insertions(+), 3 deletions(-)


diff --git a/common/filter b/common/filter
index 7e02ded377cc9b..1ebfd27e898e01 100644
--- a/common/filter
+++ b/common/filter
@@ -624,11 +624,14 @@ _filter_getcap()
 
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
@@ -636,7 +639,7 @@ _filter_quota_report()
 		s/^\#0 \d+ /[ROOT] 0 /g;
 		s/6 days/7 days/g' |
 	perl -npe '
-		$val = 0;
+		$val = '"$HIDDEN_QUOTA_FILES"';
 		if ($ENV{'LARGE_SCRATCH_DEV'}) {
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
diff --git a/common/xfs b/common/xfs
index 85cd9a1348e385..eb4d99c91a8019 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1927,3 +1927,32 @@ _scratch_xfs_force_no_metadir()
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
index 78303bf784d05e..1e40ab90a843e8 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -30,9 +30,14 @@ _require_scratch
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
index d5e43082c1cd35..2ce22b8c44b298 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -35,9 +35,14 @@ _require_idmapped_mounts
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
index 710eb89c2ac0e7..3986f8fb904e5d 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -155,6 +155,7 @@ _qmount_option "uquota,gquota,pquota"
 _qmount
 
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 
 bsoft=$(( 100 * $bsize ))
 bhard=$(( 500 * $bsize ))
diff --git a/tests/xfs/330 b/tests/xfs/330
index d239a64085c76c..30c09ff5906e12 100755
--- a/tests/xfs/330
+++ b/tests/xfs/330
@@ -24,7 +24,10 @@ _require_nobody
 
 do_repquota()
 {
-	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r
+	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r | \
+	perl -npe '
+		$val = '"$HIDDEN_QUOTA_FILES"';
+		s/(^root\s+--\s+\S+\s+\S+\s+\S+\s+)(\S+)/$1@{[$2 - $val]}/g'
 }
 
 rm -f "$seqres.full"
@@ -33,6 +36,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> "$seqres.full" 2>&1
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 

