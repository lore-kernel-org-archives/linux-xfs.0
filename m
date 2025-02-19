Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA001DFE1;
	Wed, 19 Feb 2025 01:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927347; cv=none; b=Z7A5o8vrFma5s4PCD+v7gxEeLGQpWA2YW5bq8f13VYNwUVfOBVyaGPb8foNB7SKsTqjuD7xZyB/tqE/aN88BfgvaqOHGePLP9mO8WYki7b85I+8ccbv6vaS64AYGnO8G+d0yIY8pfoTFkLP1PzDiER9PaiHdOCu9Fs7apGicJno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927347; c=relaxed/simple;
	bh=oV2/YZxntInAHxJi1yvW6fVV28EawJ2PeZ1fJIK0qy8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrtCZdfy1HcUlDMqmuxhEFgPZoW86SKZwYbe0HFKFZQ+2K7jrJCp94TNww904g8lcAk2XCrbDZ/4EKea3qTep5imwpKXy0E3anfqb5T2r2ZGb139sQWjA9/wOoSTAPxzUjsBYWBbrKuH52hB8irNMtMl1ZEE4oWhFShFB+sGMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWOZGtSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWOZGtSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF94C4CEE6;
	Wed, 19 Feb 2025 01:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927347;
	bh=oV2/YZxntInAHxJi1yvW6fVV28EawJ2PeZ1fJIK0qy8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZWOZGtSxFJJneX2np/TR4TRbqb801e8/tptLZQcas9WNJ8zPq7nU4sh3m2tNdTG9U
	 Lydwg0y2GvlWyRzu+qVXkhdvT5kZqfTtapK44ex8zdrpALP4h4yhYvYeH0q56gKjrx
	 DaYih2JjxPYs1EVF9cxI8HReHg1RzpvE3pjBfJ4nx3Wbda2U6dzeb12MoQBGBpnNX0
	 smx1bwnLnilEhS4Yysnke6EUZuyDkBlpHmuB9S8hu3PPl6FH5l364hjp1S5+8kCE+o
	 x9faptUBVKkDhkMHPewmepVakBeDk2R8gv4y718d/4OOT+cGIK3Dq+HUbAJgIe22AW
	 11AhTKY2R7Vhg==
Date: Tue, 18 Feb 2025 17:09:07 -0800
Subject: [PATCH 1/1] xfs: test filesystem recovery with rdump
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992592231.4081406.4124909331519241647.stgit@frogsfrogsfrogs>
In-Reply-To: <173992592211.4081406.17974627498372247228.stgit@frogsfrogsfrogs>
References: <173992592211.4081406.17974627498372247228.stgit@frogsfrogsfrogs>
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

