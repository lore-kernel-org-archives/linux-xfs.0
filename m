Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDFA3FEC;
	Mon,  1 Jan 2024 01:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vPog9GEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEACC433C7;
	Mon,  1 Jan 2024 01:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071196;
	bh=L3IyL9qiRbRr6OTtYdsRANoECBYgNr2NR+Ny8H6ch+w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vPog9GEFTO/2FKpPC2mdYr8wEWQrftKm/9izVs91l0xcSdrbwDTSiEzXwLRRgu0AH
	 7QYaTIq2J1fC+UlnGDTfkpNnZR67oNOkgo9OavlzI/lDT9wjgHyYwiXlIyOF+EIVXd
	 gdq8NLtSSebfpqjNzgG/Cwz0wUL3Y5+/7S1vUQbGLl0LaRWNh0cf1IlyZkStryXRjB
	 5tJqIbrjp9W9z8ERjWb3GSRrVYFADwWeSM75K+Bx1iG4yQnijGyaJ0IivjuzWP7ltZ
	 RBsuxLdmhXOk6fOEc66iW+qvcpJGA3WEERtoR3yd5RkIUHtssBpGACgIco6BBFiQ/W
	 +SqE6v29gisRQ==
Date: Sun, 31 Dec 2023 17:06:35 +9900
Subject: [PATCH 2/2] xfs: test output of new FSREFCOUNTS ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405033759.1828671.9633159260296053871.stgit@frogsfrogsfrogs>
In-Reply-To: <170405033732.1828671.2206987916120651051.stgit@frogsfrogsfrogs>
References: <170405033732.1828671.2206987916120651051.stgit@frogsfrogsfrogs>
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

Make sure the cursors work properly and that refcounts are correct.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc           |    4 +
 doc/group-names.txt |    1 
 tests/xfs/1921      |  168 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1921.out  |    4 +
 4 files changed, 175 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1921
 create mode 100644 tests/xfs/1921.out


diff --git a/common/rc b/common/rc
index 2d67f7dff1..84e509e49b 100644
--- a/common/rc
+++ b/common/rc
@@ -2640,8 +2640,8 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Operation not supported" && \
 			_notrun "O_TMPFILE is not supported"
 		;;
-	"fsmap")
-		testio=`$XFS_IO_PROG -f -c "fsmap" $testfile 2>&1`
+	"fsmap"|"fsrefcounts")
+		testio=`$XFS_IO_PROG -f -c "$command" $testfile 2>&1`
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
diff --git a/doc/group-names.txt b/doc/group-names.txt
index 4676825faf..9aec4a4ff8 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -57,6 +57,7 @@ freeze			filesystem freeze tests
 fsck			general fsck tests
 fsmap			FS_IOC_GETFSMAP ioctl
 fsr			XFS free space reorganizer
+fsrefcounts		FS_IOC_GETFSREFCOUNTS ioctl
 fuzzers			filesystem fuzz tests
 growfs			increasing the size of a filesystem
 hardlink		hardlinks
diff --git a/tests/xfs/1921 b/tests/xfs/1921
new file mode 100755
index 0000000000..28c05e16c7
--- /dev/null
+++ b/tests/xfs/1921
@@ -0,0 +1,168 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1921
+#
+# Populate filesystem, check that fsrefcounts -n10000 matches fsrefcounts -n1,
+# then verify that the refcount information is consistent with the fsmap info.
+#
+. ./common/preamble
+_begin_fstest auto clone fsrefcounts fsmap
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.* $TEST_DIR/a $TEST_DIR/b
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_command "fsmap"
+_require_xfs_io_command "fsrefcounts"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+cpus=$(( $(src/feature -o) * 4))
+
+# Use fsstress to create a directory tree with some variability
+FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 4000 $FSSTRESS_AVOID)
+$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
+
+echo "Compare fsrefcounts" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsrefcounts -m -n 65536' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/a
+$XFS_IO_PROG -c 'fsrefcounts -m -n 1' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/b
+cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
+
+diff -uw $TEST_DIR/a $TEST_DIR/b
+
+echo "Compare fsrefcounts to fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -m -n 65536' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/b
+cat $TEST_DIR/b >> $seqres.full
+
+while IFS=',' read ext major minor pstart pend owners length crap; do
+	test "$ext" = "EXT" && continue
+
+	awk_args=(-'F' ',' '-v' "major=$major" '-v' "minor=$minor" \
+		  '-v' "pstart=$pstart" '-v' "pend=$pend" '-v' "owners=$owners")
+
+	if [ "$owners" -eq 1 ]; then
+		$AWK_PROG "${awk_args[@]}" \
+'
+BEGIN {
+	printf("Q:%s:%s:%s:%s:%s:\n", major, minor, pstart, pend, owners) > "/dev/stderr";
+	next_map = -1;
+}
+{
+	if ($2 != major || $3 != minor) {
+		next;
+	}
+	if ($5 <= pstart) {
+		next;
+	}
+
+	printf(" A:%s:%s:%s:%s\n", $2, $3, $4, $5) > "/dev/stderr";
+	if (next_map < 0) {
+		if ($4 > pstart) {
+			exit 1
+		}
+		next_map = $5 + 1;
+	} else {
+		if ($4 != next_map) {
+			exit 1
+		}
+		next_map = $5 + 1;
+	}
+	if (next_map >= pend) {
+		nextfile;
+	}
+}
+END {
+	exit 0;
+}
+' $TEST_DIR/b 2> $tmp.debug
+		res=$?
+	else
+		$AWK_PROG "${awk_args[@]}" \
+'
+function max(a, b) {
+	return a > b ? a : b;
+}
+function min(a, b) {
+	return a < b ? a : b;
+}
+BEGIN {
+	printf("Q:%s:%s:%s:%s:%s:\n", major, minor, pstart, pend, owners) > "/dev/stderr";
+	refcount_whole = 0;
+	aborted = 0;
+}
+{
+	if ($2 != major || $3 != minor) {
+		next;
+	}
+	if ($4 >= pend) {
+		nextfile;
+	}
+	if ($5 <= pstart) {
+		next;
+	}
+	if ($6 == "special_0:2") {
+		/* unknown owner means we cannot distinguish separate owners */
+		aborted = 1;
+		exit 0;
+	}
+
+	printf(" A:%s:%s:%s:%s -> %d\n", $2, $3, $4, $5, refcount_whole) > "/dev/stderr";
+	if ($4 <= pstart && $5 >= pend) {
+		/* Account for extents that span the whole range */
+		refcount_whole++;
+	} else {
+		/* Otherwise track refcounts per-block as we find them */
+		for (block = max($4, pstart); block <= min($5, pend); block++) {
+			refcounts[block]++;
+		}
+	}
+}
+END {
+	if (aborted) {
+		exit 0;
+	}
+	deficit = owners - refcount_whole;
+	printf(" W:%d:%d\n", owners, refcount_whole, deficit) > "/dev/stderr";
+	if (deficit == 0) {
+		exit 0;
+	}
+
+	refcount_slivers = 0;
+	for (block in refcounts) {
+		printf(" X:%s:%d\n", block, refcounts[block]) > "/dev/stderr";
+		if (refcounts[block] == deficit) {
+			refcount_slivers = deficit;
+		} else {
+			exit 1;
+		}
+	}
+
+	refcount_whole += refcount_slivers;
+	exit owners == refcount_whole ? 0 : 1;
+}
+' $TEST_DIR/b 2> $tmp.debug
+		res=$?
+	fi
+	if [ $res -ne 0 ]; then
+		echo "$major,$minor,$pstart,$pend,$owners not found in fsmap"
+		cat $tmp.debug >> $seqres.full
+		break
+	fi
+done < $TEST_DIR/a
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1921.out b/tests/xfs/1921.out
new file mode 100644
index 0000000000..f5ea660379
--- /dev/null
+++ b/tests/xfs/1921.out
@@ -0,0 +1,4 @@
+QA output created by 1921
+Format and mount
+Compare fsrefcounts
+Compare fsrefcounts to fsmap

