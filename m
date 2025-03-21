Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D521EF08D;
	Fri, 21 Mar 2025 21:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592428; cv=none; b=qNpO6Np5qWusuX6dWtfT0v6xfElrSna7Oebh61MjE9QFZpm3q9W7NbY8eHZwnbceKYx3XTFpZFNMLIWaNcubla+ULwRdSJf/wmnMh7px4Bxg2VDIA1zXNxDfZXNXr0UaoC4NCIV6SgtQ5NbMwaGFDu6jAn8iCynWwfEvi+p2KpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592428; c=relaxed/simple;
	bh=ZlbfBRg8UbigtWdBK+NmCEhwVvSxtr9Y2QhCjqCrN54=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7t4LXXsvbQk27cBh2gmzoyeGx2NTJtSpLX4LPpKGNm2JJiKAZNNZgcvsBv4MOmcfSSPAELrIIWgbOyTv0fmvuswiVylIbHfrj8BYTjJ9dkEC6/gxQMENf7v3456Nc8wug2LhAL6DYqyJDlK4y7HEbRUFcK9CJ3P2qaYrGT/WrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCO2hhQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCO2hhQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB96C4CEE3;
	Fri, 21 Mar 2025 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592427;
	bh=ZlbfBRg8UbigtWdBK+NmCEhwVvSxtr9Y2QhCjqCrN54=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TCO2hhQq49nk9FGLvfZDnjoFKmmbUrqx/KM+Fh9ABGn1Cw11/KpcEbvOgl73lzW4d
	 1FPwycYWf6T7yDmhUOk6Syk5EQy2otp9x/rpjJlQenP4T/fZLWSB0c4H0+17pMgb4c
	 UFtjj0xHtD3reBqF2AgFpBA4z7M0/X+cyRBwolBMHhyRqhuOaHU8cyAqtStikyL9cB
	 8ZObA0serAu8u7lDeVIFdjUcxDTsikWa8htWh3CUvZJc2te/UOuZl6j9LQrNmfwFrH
	 y/6TZrVgfml93yT2UyY/3xnJFsvxhu6qDeFyIxRvX7VDhoeb4ycSMQhZ+ZDPYSlSc1
	 NHCcSKG8WfpXw==
Date: Fri, 21 Mar 2025 14:27:07 -0700
Subject: [PATCH 1/1] xfs: test filesystem recovery with rdump
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174259233533.743419.11473495762149004746.stgit@frogsfrogsfrogs>
In-Reply-To: <174259233514.743419.14108043386932063353.stgit@frogsfrogsfrogs>
References: <174259233514.743419.14108043386932063353.stgit@frogsfrogsfrogs>
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

