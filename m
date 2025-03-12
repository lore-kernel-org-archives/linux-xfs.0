Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6E1B0406;
	Wed, 12 Mar 2025 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821062; cv=none; b=ehkWzTwHOa7Fri+11s1RhlQpGspWBiK0sZdTnZlShJGzrMihv7hBMhZ+JlZYW4lpC9NmwcCFn242vHWUjdmsnLahxSCSlKY7UWThnMy4lbTP9eGsT2HGnwodV7xISfHtpp7WvXhrm7JAbJTElWB9jjeOHCoKL0uCyAXX0oeoZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821062; c=relaxed/simple;
	bh=ZlbfBRg8UbigtWdBK+NmCEhwVvSxtr9Y2QhCjqCrN54=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzsi81ld+lO1f+jpVdUDHRhbMg65InFkWHkDHAIQVSnuHAy8OEKJHOMnK1G5BQ/Ku+3jqxp/nUv3OLiWZNvXwNGytNubH+yTXa4n8Kti4jE/GJimHlNuiCUjKRHoui9HS515S0IWqz718l8zoENXvOfgiDz3ZdUUUz/gdanc1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRJ2N/hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRJ2N/hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC03C4CEF0;
	Wed, 12 Mar 2025 23:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821062;
	bh=ZlbfBRg8UbigtWdBK+NmCEhwVvSxtr9Y2QhCjqCrN54=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bRJ2N/hII0KIsrZW8GG8GvJaZNgQLcG/vwPH0SAfh1HKTY6lMoRnYTy1G9NEchh7f
	 OD0QCRZqCdhOtUiWxKWSuM3uZ9H4juMN8OydRRFvoQMF1X3Epm9no4Z56WrER497Ea
	 5vZCAkXJ50SKx4gwmyaXs9D/RRXTQNuuIjI1Axc765DYl1GnAZo+UfoNWzYu/SHvFx
	 2WdtuBOXQRsmiYR7cL2+khEPOaUj07gLsM2EN0Rls3fEQBQjea6J7Xts9gJUvaRzyv
	 z6QSzuxJPKsfkPAbNOXSgTB0iEwhcFjDuxV1/Cas1EjHtmXp73QsXpNJD4ZMeZOFma
	 7PtMp0+OI61cA==
Date: Wed, 12 Mar 2025 16:11:01 -0700
Subject: [PATCH 1/1] xfs: test filesystem recovery with rdump
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182088702.1400513.11145934143899445451.stgit@frogsfrogsfrogs>
In-Reply-To: <174182088682.1400513.386501106506158468.stgit@frogsfrogsfrogs>
References: <174182088682.1400513.386501106506158468.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Test how well we can dump a fully populated filesystem's contents.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/1895     |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1895.out |    6 ++
 2 files changed, 159 insertions(+)
 create mode 100755 tests/xfs/1895
 create mode 100644 tests/xfs/1895.out


diff --git a/tests/xfs/1895 b/tests/xfs/1895
new file mode 100755
index 00000000000000..18b534d328e9fd
--- /dev/null
+++ b/tests/xfs/1895
@@ -0,0 +1,153 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1895
+#
+# Populate a XFS filesystem, ensure that rdump can "recover" the contents to
+# another directory, and compare the contents.
+#
+. ./common/preamble
+_begin_fstest auto scrub
+
+_cleanup()
+{
+	command -v _kill_fsstress &>/dev/null && _kill_fsstress
+	cd /
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
+_require_xfs_db_command "rdump"
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
+	# 		mtime
+	# 		name
+	# We can't directly control directory sizes so filter them.
+	# Too many things can bump (or not) atime so don't test that.
+	(cd $1 ; find . -print0 |
+		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' |
+		sed -e 's/ directory [1-9][0-9]* / directory SIZE /g' |
+		sort) > $tmp.stat.$2
+}
+
+cmp_stat()
+{
+	diff -u $tmp.stat.$1 $tmp.stat.$2
+}
+
+make_stat_files() {
+	for file in "${FILES[@]}"; do
+		find "$1/$file" -print0 | xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n'
+	done | sed \
+		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
+		-e "s| $1| DUMPDIR|g" \
+		| sort > $tmp.stat.files.$2
+}
+
+cmp_stat_files()
+{
+	diff -u $tmp.stat.files.$1 $tmp.stat.files.$2
+}
+
+make_stat_dir() {
+	find "$1" -print0 | \
+		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' | sed \
+		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
+		-e "s| $1| DUMPDIR|g" \
+		| sort > $tmp.stat.dir.$2
+}
+
+cmp_stat_dir()
+{
+	diff -u $tmp.stat.dir.$1 $tmp.stat.dir.$2
+}
+
+FILES=(
+	"/S_IFDIR.FMT_INLINE"
+	"/S_IFBLK"
+	"/S_IFCHR"
+	"/S_IFLNK.FMT_LOCAL"
+	"/S_IFIFO"
+	"/S_IFDIR.FMT_INLINE/00000001"
+	"/ATTR.FMT_EXTENTS_REMOTE3K"
+	"/S_IFREG.FMT_EXTENTS"
+	"/S_IFREG.FMT_BTREE"
+	"/BNOBT"
+	"/S_IFDIR.FMT_BLOCK"
+)
+DIR="/S_IFDIR.FMT_LEAF"
+
+testfiles=$TEST_DIR/$seq
+mkdir -p $testfiles
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+_scratch_mount
+
+_run_fsstress -n 500 -d $SCRATCH_MNT/newfiles
+
+make_stat $SCRATCH_MNT before
+make_md5 $SCRATCH_MNT before
+make_stat_files $SCRATCH_MNT before
+make_stat_dir $SCRATCH_MNT/$DIR before
+_scratch_unmount
+
+echo "Recover filesystem"
+dumpdir1=$testfiles/rdump
+dumpdir2=$testfiles/sdump
+dumpdir3=$testfiles/tdump
+rm -r -f $dumpdir1 $dumpdir2 $dumpdir3
+
+# as of linux 6.12 fchownat does not work on symlinks
+_scratch_xfs_db -c "rdump / $dumpdir1" | sed -e '/could not be set/d'
+_scratch_xfs_db -c "rdump ${FILES[*]} $dumpdir2" | sed -e '/could not be set/d'
+_scratch_xfs_db -c "rdump $DIR $dumpdir3" | sed -e '/could not be set/d'
+
+echo "Check file contents"
+make_stat $dumpdir1 after
+cmp_stat before after
+cmp_md5 $dumpdir1 before
+
+echo "Check selected files contents"
+make_stat_files $dumpdir2 after
+cmp_stat_files before after
+
+echo "Check single dir extraction contents"
+make_stat_dir $dumpdir3 after
+cmp_stat_dir before after
+
+# remount so we can check this fs
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1895.out b/tests/xfs/1895.out
new file mode 100644
index 00000000000000..de639ed3fc7e38
--- /dev/null
+++ b/tests/xfs/1895.out
@@ -0,0 +1,6 @@
+QA output created by 1895
+Format and populate
+Recover filesystem
+Check file contents
+Check selected files contents
+Check single dir extraction contents

