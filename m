Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0067271839;
	Wed, 12 Feb 2025 03:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331338; cv=none; b=FvZRE3c83AT20Vn73FRm/J4B7Nm67BBpAvHnh1D/nE36rNUSRpPj7H3ggNBZdfWfXmKSs9jkws/+mVwTV2MukrQXYpGBz9BOGxZrBKv0kagNKRZ+AX0WNu5ux9LKt8NKSTAZ2BoWC+kwPMAUzwWMekBou5kgddYKzcAhUIsBMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331338; c=relaxed/simple;
	bh=fho2Tjz4DlFgBkWtJufU20yltKFmv2Bf6orIOykdXDM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0U9yaOmqhqCg7T8SN8zk6/OBU9qAta7IvjKnMFVgJG+3i6npAFnjPXYgrVRwqNtZyqKei2pWuGXWydJZYRIrveSusodl6XDiDmVQ5Z1Gt2/NrYFuDHnkIDBq07/hgjpD8LtMBUEc/K8nG/nUssHofeHvq6WBH61wNdAmGLRIe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWT3inb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWT3inb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8063DC4CEDF;
	Wed, 12 Feb 2025 03:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331338;
	bh=fho2Tjz4DlFgBkWtJufU20yltKFmv2Bf6orIOykdXDM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WWT3inb+6dEDSveAZU2G9KWKHqKeYHrI1OMcUM8nH+i5qQY65etm1e3plfR7y78Yn
	 h/1FvYZHojRk1tZtQYTdBqEwdf6Ml05kyDygqgX7RScRV/MerpouXqJCnh39nexfUu
	 qAYo1aluTI7afjpzEhnb8IQzoXnc7wHWrvf6EW4DxCOK362mNx1PD+eaC3U0CRdtsz
	 OjgxGhBhlOCVoFfYdKoKDoSQQSGMxgIuOMZGQM6ZQiRFDY2dJTUECCve+CO+FtoQLz
	 Ik3pWHqgZnVZYYbMvfwEpnPRcI6NiHZ7aNjgY+ds4v4iwzWaTNUGL/Ys8oGKM5UvL4
	 ocQPxx7XT46OQ==
Date: Tue, 11 Feb 2025 19:35:38 -0800
Subject: [PATCH 19/34] mkfs: don't hardcode log size
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094646.1758477.1935957981353649901.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Commit 000813899afb46 hardcoded a log size of 256MB into xfs/501,
xfs/502, and generic/530.  This seems to be an attempt to reduce test
run times by increasing the log size so that more background threads can
run in parallel.  Unfortunately, this breaks a couple of my test
configurations:

 - External logs smaller than 256MB
 - Internal logs where the AG size is less than 256MB

For example, here's seqres.full from a failed xfs/501 invocation:

** mkfs failed with extra mkfs options added to " -m metadir=2,autofsck=1,uquota,gquota,pquota, -d rtinherit=1," by test 501 **
** attempting to mkfs using only test 501 options: -l size=256m **
size 256m specified for log subvolume is too large, maximum is 32768 blocks
<snip>
mount -ortdev=/dev/sdb4 -ologdev=/dev/sdb2 /dev/sda4 /opt failed
umount: /dev/sda4: not mounted.

Note that there's some formatting error here, so we jettison the entire
rt configuration to force the log size option, but then mount fails
because we didn't edit out the rtdev option there too.

Fortunately, mkfs.xfs already /has/ a few options to try to improve
parallelism in the filesystem by avoiding contention on the log grant
heads by scaling up the log size.  These options are aware of log and AG
size constraints so they won't conflict with other geometry options.

Use them.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 000813899afb46 ("fstests: scale some tests for high CPU count sanity")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc         |   27 +++++++++++++++++++++++++++
 tests/generic/530 |    6 +-----
 tests/generic/531 |    6 +-----
 tests/xfs/501     |    2 +-
 tests/xfs/502     |    2 +-
 5 files changed, 31 insertions(+), 12 deletions(-)


diff --git a/common/rc b/common/rc
index e3ad6db034dc69..70271ce1d55179 100644
--- a/common/rc
+++ b/common/rc
@@ -688,6 +688,33 @@ _test_cycle_mount()
     _test_mount
 }
 
+# Are there mkfs options to try to improve concurrency?
+_scratch_mkfs_concurrency_options()
+{
+	local nr_cpus=$(getconf _NPROCESSORS_CONF)
+
+	case "$FSTYP" in
+	xfs)
+		# If any concurrency options are already specified, don't
+		# compute our own conflicting ones.
+		echo "$SCRATCH_OPTIONS $MKFS_OPTIONS" | \
+			grep -q 'concurrency=' &&
+			return
+
+		local sections=(d r)
+
+		# -l concurrency does not work with external logs
+		test _has_logdev || sections+=(l)
+
+		for section in "${sections[@]}"; do
+			$MKFS_XFS_PROG -$section concurrency=$nr_cpus 2>&1 | \
+				grep -q "unknown option -$section" ||
+				echo "-$section concurrency=$nr_cpus "
+		done
+		;;
+	esac
+}
+
 _scratch_mkfs_options()
 {
     _scratch_options mkfs
diff --git a/tests/generic/530 b/tests/generic/530
index f2513156a920e8..b2aab4f354e9f3 100755
--- a/tests/generic/530
+++ b/tests/generic/530
@@ -25,11 +25,7 @@ _require_test_program "t_open_tmpfiles"
 # For XFS, pushing 50000 unlinked inode inactivations through a small xfs log
 # can result in bottlenecks on the log grant heads, so try to make the log
 # larger to reduce runtime.
-if [ "$FSTYP" = "xfs" ] && ! _has_logdev; then
-    _scratch_mkfs "-l size=256m" >> $seqres.full 2>&1
-else
-    _scratch_mkfs >> $seqres.full 2>&1
-fi
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) >> $seqres.full 2>&1
 _scratch_mount
 
 # Set ULIMIT_NOFILE to min(file-max / 2, 50000 files per LOAD_FACTOR)
diff --git a/tests/generic/531 b/tests/generic/531
index ed6c3f91153ecc..07dffd9fd5108d 100755
--- a/tests/generic/531
+++ b/tests/generic/531
@@ -23,11 +23,7 @@ _require_test_program "t_open_tmpfiles"
 
 # On high CPU count machines, this runs a -lot- of create and unlink
 # concurrency. Set the filesytsem up to handle this.
-if [ $FSTYP = "xfs" ]; then
-	_scratch_mkfs "-d agcount=32" >> $seqres.full 2>&1
-else
-	_scratch_mkfs >> $seqres.full 2>&1
-fi
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) >> $seqres.full 2>&1
 _scratch_mount
 
 # Try to load up all the CPUs, two threads per CPU.
diff --git a/tests/xfs/501 b/tests/xfs/501
index 678c51b52948c5..c62ec443848797 100755
--- a/tests/xfs/501
+++ b/tests/xfs/501
@@ -33,7 +33,7 @@ _require_xfs_sysfs debug/log_recovery_delay
 _require_scratch
 _require_test_program "t_open_tmpfiles"
 
-_scratch_mkfs "-l size=256m" >> $seqres.full 2>&1
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) >> $seqres.full 2>&1
 _scratch_mount
 
 # Set ULIMIT_NOFILE to min(file-max / 2, 30000 files per LOAD_FACTOR)
diff --git a/tests/xfs/502 b/tests/xfs/502
index 10b0017f6b2eb2..ebfb5ce883c378 100755
--- a/tests/xfs/502
+++ b/tests/xfs/502
@@ -23,7 +23,7 @@ _require_xfs_io_error_injection "iunlink_fallback"
 _require_scratch
 _require_test_program "t_open_tmpfiles"
 
-_scratch_mkfs "-l size=256m" | _filter_mkfs 2> $tmp.mkfs > /dev/null
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) | _filter_mkfs 2> $tmp.mkfs > /dev/null
 cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 

