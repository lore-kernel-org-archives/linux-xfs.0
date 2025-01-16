Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2436158520;
	Thu, 16 Jan 2025 23:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070067; cv=none; b=krTxJPbEVUdvPnmINUbRfdP4pMcKA6aL45DN6s9CKdIJniuyVSUPJudMCs+jqsj6Fw6hgIwgKhBM0MHsTXoB+BuTgOvRuudUoWm8W8YeDQ5DZxx9YQgVXsxOstsuSnmcK9hv/a4dQ/omWqAevWXQuhTfzs4+zrGPF+tsUrLh4Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070067; c=relaxed/simple;
	bh=z8/t7g12G3jvoVSPtvzo/jYuh8mMrxA863C0HdXkXmc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzkIwBJw4BrA0kdW9vDR2ccpcBe45M1h2d5FnIJVPVFydrq15qvHMrd3P3CNGJP0gqr0OOFLFgEvDEUWFgg4EYmDfowEZhGit8K2g97zTWEuhFnsG+gCUWd96iV2WMXDMNTN7VI+gXKV8HLARkqF8wiS2iw0jPR9jm/DzdcKiZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZmwXxU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZmwXxU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CC9C4CED6;
	Thu, 16 Jan 2025 23:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070067;
	bh=z8/t7g12G3jvoVSPtvzo/jYuh8mMrxA863C0HdXkXmc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OZmwXxU6qXfs5S6EX2IsYVFiZEOZkRWKSs4sVSNIzRq2a8DgWPWX7q/TGUCCErEhF
	 DDZ1eP0sSSj5u1+A62UZI6TiSIFNkEIlzez0F7btvGckbKplrNGSNV5T2USTYL4hwS
	 YA/Lc1Rs9R84FvkLKiMfIHG4cheqVH6uU4vqoLClq3WXRnhPwyqc2FPu+QL/CycnI1
	 7rrEebV8efdK4+H9xHr/YyGfBg9MF7vK8bq2LUpE2aY3Ljtm5myrCtk4X45cSGe/uy
	 W/ulBDHI/DZpgaSYHPgO0GCTEasub5yLoY1qC8nuAym2D4/jsWt3EJDiz/8uJZEqnJ
	 6VuVJ78FLEQiQ==
Date: Thu, 16 Jan 2025 15:27:46 -0800
Subject: [PATCH 10/23] mkfs: don't hardcode log size
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
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
---
 common/rc         |   27 +++++++++++++++++++++++++++
 tests/generic/530 |    6 +-----
 tests/generic/531 |    6 +-----
 tests/xfs/501     |    2 +-
 tests/xfs/502     |    2 +-
 5 files changed, 31 insertions(+), 12 deletions(-)


diff --git a/common/rc b/common/rc
index 9e34c301b0deb0..885669beeb5e26 100644
--- a/common/rc
+++ b/common/rc
@@ -689,6 +689,33 @@ _test_cycle_mount()
     _test_mount
 }
 
+# Are there mkfs options to try to improve concurrency?
+_scratch_mkfs_concurrency_options()
+{
+	local nr_cpus="$(( $1 * LOAD_FACTOR ))"
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
index f2513156a920e8..7413840476b588 100755
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
+_scratch_mkfs $(_scratch_mkfs_concurrency_options 32) >> $seqres.full 2>&1
 _scratch_mount
 
 # Set ULIMIT_NOFILE to min(file-max / 2, 50000 files per LOAD_FACTOR)
diff --git a/tests/generic/531 b/tests/generic/531
index ed6c3f91153ecc..3ba2790c923464 100755
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
+_scratch_mkfs $(_scratch_mkfs_concurrency_options 32) >> $seqres.full 2>&1
 _scratch_mount
 
 # Try to load up all the CPUs, two threads per CPU.
diff --git a/tests/xfs/501 b/tests/xfs/501
index 678c51b52948c5..4b29ef97d36c1a 100755
--- a/tests/xfs/501
+++ b/tests/xfs/501
@@ -33,7 +33,7 @@ _require_xfs_sysfs debug/log_recovery_delay
 _require_scratch
 _require_test_program "t_open_tmpfiles"
 
-_scratch_mkfs "-l size=256m" >> $seqres.full 2>&1
+_scratch_mkfs $(_scratch_mkfs_concurrency_options 32) >> $seqres.full 2>&1
 _scratch_mount
 
 # Set ULIMIT_NOFILE to min(file-max / 2, 30000 files per LOAD_FACTOR)
diff --git a/tests/xfs/502 b/tests/xfs/502
index 10b0017f6b2eb2..df3e7bcb17872d 100755
--- a/tests/xfs/502
+++ b/tests/xfs/502
@@ -23,7 +23,7 @@ _require_xfs_io_error_injection "iunlink_fallback"
 _require_scratch
 _require_test_program "t_open_tmpfiles"
 
-_scratch_mkfs "-l size=256m" | _filter_mkfs 2> $tmp.mkfs > /dev/null
+_scratch_mkfs $(_scratch_mkfs_concurrency_options 32) | _filter_mkfs 2> $tmp.mkfs > /dev/null
 cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 

