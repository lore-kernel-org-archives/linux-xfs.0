Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C6C1BC094;
	Wed, 19 Feb 2025 00:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926642; cv=none; b=b8CEXs19AJedmS7JZA7YOSv+u+JSZNgmaebFujZwVmmCDg7QuG8Auld0tDEb7EQECrtrI3b5UJRmfCJR2dZhWGhAWQ+kjfLZ/ZY68ueVSF8cUg8S3erNIe7XhL6vdHjndAEzetfM/a8mOfC+jeKgOtd3lcJ+qDwQHj8pkFfu+Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926642; c=relaxed/simple;
	bh=nS/b5UpQ2XQSEk4en6oAUikBAu7RzUS1iB1OGcXPbrs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QnpmVVIL+TumCKgzyOW7aIBZGkHwSqbRzkysCiAhy+tJSL7DmNSNHP2tKrVqeIePdpEImd2H4qxapFKhes1RZE7GbeKfhBKxv5QfrRbusW9vsieZ3Mq/zz7MTrTHYBQTQLQDv32LE59cz95JUqZruLfYk139jQgvYnlTA38W5Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEnKk2kK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEnKk2kK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD7C4CEE2;
	Wed, 19 Feb 2025 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926642;
	bh=nS/b5UpQ2XQSEk4en6oAUikBAu7RzUS1iB1OGcXPbrs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HEnKk2kKwVotZJ9ErtFqAwfATCwYB9sTYrnep0v4RfLEmmOQfNDlTEgEp0JWAmFgG
	 st78QoHK6FpCsiiDwmdMRiKoL++4zf3JtvXyPFUnMo0f0bWv3uh5q1AUdM5aQWw3fT
	 6R4VgS4iwAdNWMyksdiLci54icNnj9QqQrWgN/P2IJ3z0QJS68NtUe3xLf3Mq0IJwC
	 EW77qoVZMyNb9tVDO2519FdJI1vti2KneO1g+bHa6Izh/PF3AAFkVQDN3GfQvD75oZ
	 Kk/6ioI0pOMdRgyIXrpkAw5iQt+Wxrin++Wv2KzusSK4x0P3WQX2DzyaYv9PKLCTY8
	 OCrwhPb+NvyDg==
Date: Tue, 18 Feb 2025 16:57:21 -0800
Subject: [PATCH 3/4] xfs: test filesystem creation with xfs_protofile
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588705.4079248.17487544777085276923.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
References: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Test how well we can format a fully populated filesystem with a
protofile that was generated with xfs_protofile.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/config      |    1 
 tests/xfs/1894     |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1894.out |    4 ++
 3 files changed, 114 insertions(+)
 create mode 100755 tests/xfs/1894
 create mode 100644 tests/xfs/1894.out


diff --git a/common/config b/common/config
index 193b7af432dc2b..da12399da421c7 100644
--- a/common/config
+++ b/common/config
@@ -161,6 +161,7 @@ export MKSWAP_PROG="$(type -P mkswap)"
 MKSWAP_PROG="$MKSWAP_PROG -f"
 
 export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
+export XFS_PROTOFILE_PROG="$(type -P xfs_protofile)"
 export XFS_REPAIR_PROG="$(type -P xfs_repair)"
 export XFS_DB_PROG="$(type -P xfs_db)"
 export XFS_METADUMP_PROG="$(type -P xfs_metadump)"
diff --git a/tests/xfs/1894 b/tests/xfs/1894
new file mode 100755
index 00000000000000..2f6beea2c433bf
--- /dev/null
+++ b/tests/xfs/1894
@@ -0,0 +1,109 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1894
+#
+# Populate a XFS filesystem, use xfs_protofile to recreate the filesystem, and
+# compare the contents.
+#
+. ./common/preamble
+_begin_fstest auto scrub
+
+_cleanup()
+{
+	command -v _kill_fsstress &>/dev/null && _kill_fsstress
+	cd /
+	test -e "$testfiles" && _unmount $testfiles/mount &>/dev/null
+	test -e "$testfiles" && rm -r -f $testfiles
+}
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_command "$XFS_PROTOFILE_PROG" xfs_protofile
+_require_test
+_require_scratch
+_require_scrub
+_require_populate_commands
+
+make_md5()
+{
+	(cd $1 ; find . -type f -print0 | xargs -0 md5sum) > $tmp.md5.$2
+}
+
+cmp_md5()
+{
+	(cd $1 ; md5sum --quiet -c $tmp.md5.$2)
+}
+
+make_stat()
+{
+	# columns:	raw mode in hex,
+	# 		major rdev for special
+	# 		minor rdev for special
+	# 		uid of owner
+	# 		gid of owner
+	# 		file type
+	# 		total size
+	# 		name
+	# We can't directly control directory sizes so filter them.
+	(cd $1 ; find . -print0 |
+		xargs -0 stat -c '%f %t:%T %u %g %F %s %n' |
+		sed -e 's/ directory [1-9][0-9]* / directory SIZE /g' |
+		sort) > $tmp.stat.$2
+}
+
+cmp_stat()
+{
+	diff -u $tmp.stat.$1 $tmp.stat.$2
+}
+
+testfiles=$TEST_DIR/$seq
+mkdir -p $testfiles/mount
+
+echo "Format and populate"
+_scratch_populate_cached nofill >> $seqres.full 2>&1
+_scratch_mount
+
+_run_fsstress -n 1000 -d $SCRATCH_MNT/newfiles
+
+make_stat $SCRATCH_MNT before
+make_md5 $SCRATCH_MNT before
+
+kb_needed=$(du -k -s $SCRATCH_MNT | awk '{print $1}')
+img_size=$((kb_needed * 2))
+test "$img_size" -lt $((300 * 1024)) && img_size=$((300 * 1024))
+
+echo "Clone image with protofile"
+$XFS_PROTOFILE_PROG $SCRATCH_MNT > $testfiles/protofile
+
+truncate -s "${img_size}k" $testfiles/image
+if ! _try_mkfs_dev -p $testfiles/protofile $testfiles/image &> $tmp.mkfs; then
+	cat $tmp.mkfs >> $seqres.full
+
+	# mkfs.xfs' protofile parser has some limitations in what it can copy
+	# in from the prototype files.  If a source file has more than 64k
+	# worth of xattr names then formatting will fail because listxattr
+	# cannot return that much information.
+	if grep -q 'Argument list too long' $tmp.mkfs; then
+		_notrun "source filesystem was too large"
+	fi
+	cat $tmp.mkfs
+fi
+
+_mount $testfiles/image $testfiles/mount
+
+echo "Check file contents"
+make_stat $testfiles/mount after
+cmp_stat before after
+cmp_md5 $testfiles/mount before
+_unmount $testfiles/mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1894.out b/tests/xfs/1894.out
new file mode 100644
index 00000000000000..5dd46993549187
--- /dev/null
+++ b/tests/xfs/1894.out
@@ -0,0 +1,4 @@
+QA output created by 1894
+Format and populate
+Clone image with protofile
+Check file contents

