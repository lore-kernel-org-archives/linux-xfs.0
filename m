Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5A2C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjARA5o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjARA5Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:57:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00555956C;
        Tue, 17 Jan 2023 16:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA91D61592;
        Wed, 18 Jan 2023 00:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D20C433EF;
        Wed, 18 Jan 2023 00:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002643;
        bh=xlgrdzowHa0D88KmjrXHgErPMZKHICtOq1WlCXG2X/w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oNFFrpkECNRg+qoSLeCZoRd+JLTXBmTDZ0FvJrt7LPS3p9gKlPWLs2sSLcADBakjQ
         9l9DI8BV57D0C+upwpohVT6gqkysr/xteL0B50AvuJ+UIyfuYNdOTOvcuCRXJmXFjB
         EhPQYtB6Z/ehu51YpFz3mNKiUtrNwFPj6mad5cqKOdfZnFryz34v1xz+vS+/1FRnmN
         FEHrjeYslf3QJ0RHM5BKuPZjWnlxvlO0xomAkBF2R1zfm+CG6wWVK6RbTRD+Z8jkJZ
         a+8H9xsA8kkVm6WZTKcZBwacpjwcTUKJ5XOYoX4iPiOEcTtSWzDjB/YIUdcjbOT2PF
         NyFZKDKOUmRtg==
Date:   Tue, 17 Jan 2023 16:44:02 -0800
Subject: [PATCH 2/4] populate: remove file creation loops that take forever
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com
Message-ID: <167400103070.1915094.18012675472928079868.stgit@magnolia>
In-Reply-To: <167400103044.1915094.5935980986164675922.stgit@magnolia>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the file creation loops with a perl script that does everything
we want from a single process.  This reduces the runtime of
_scratch_xfs_populate substantially by avoiding thousands of execve
overhead.  On my system, this reduces the runtime of xfs/349 (with scrub
enabled) from ~140s to ~45s.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   61 ++++++++++++++++++-----------------------------
 src/popdir.pl   |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 37 deletions(-)
 create mode 100755 src/popdir.pl


diff --git a/common/populate b/common/populate
index 84f4b8e374..180540aedd 100644
--- a/common/populate
+++ b/common/populate
@@ -11,6 +11,7 @@ _require_populate_commands() {
 	_require_xfs_io_command "falloc"
 	_require_xfs_io_command "fpunch"
 	_require_test_program "punch-alternating"
+	_require_test_program "popdir.pl"
 	case "${FSTYP}" in
 	"xfs")
 		_require_command "$XFS_DB_PROG" "xfs_db"
@@ -54,55 +55,50 @@ __populate_fragment_file() {
 
 # Create a large directory
 __populate_create_dir() {
-	name="$1"
-	nr="$2"
-	missing="$3"
+	local name="$1"
+	local nr="$2"
+	local missing="$3"
+	shift; shift; shift
 
 	mkdir -p "${name}"
-	seq 0 "${nr}" | while read d; do
-		creat=mkdir
-		test "$((d % 20))" -eq 0 && creat=touch
-		$creat "${name}/$(printf "%.08d" "$d")"
-	done
+	$here/src/popdir.pl --dir "${name}" --end "${nr}" "$@"
 
 	test -z "${missing}" && return
-	seq 1 2 "${nr}" | while read d; do
-		rm -rf "${name}/$(printf "%.08d" "$d")"
-	done
+	$here/src/popdir.pl --dir "${name}" --start 1 --incr 2 --end "${nr}" --remove "$@"
 }
 
 # Create a large directory and ensure that it's a btree format
 __populate_xfs_create_btree_dir() {
 	local name="$1"
 	local isize="$2"
-	local missing="$3"
+	local dblksz="$3"
+	local missing="$4"
 	local icore_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
 	# We need enough extents to guarantee that the data fork is in
 	# btree format.  Cycling the mount to use xfs_db is too slow, so
 	# watch for when the extent count exceeds the space after the
 	# inode core.
 	local max_nextents="$(((isize - icore_size) / 16))"
-	local nr=0
+	local nr
+	local incr
+
+	# Add about one block's worth of dirents before we check the data fork
+	# format.
+	incr=$(( (dblksz / 8) / 100 * 100 ))
 
 	mkdir -p "${name}"
-	while true; do
-		local creat=mkdir
-		test "$((nr % 20))" -eq 0 && creat=touch
-		$creat "${name}/$(printf "%.08d" "$nr")"
+	for ((nr = 0; ; nr += incr)); do
+		$here/src/popdir.pl --dir "${name}" --start "${nr}" --end "$((nr + incr - 1))"
+
 		# Extent count checks use data blocks only to avoid the removal
 		# step from removing dabtree index blocks and reducing the
 		# number of extents below the required threshold.
-		if [ "$((nr % 40))" -eq 0 ]; then
-			local nextents="$(xfs_bmap ${name} | grep -v hole | wc -l)"
-			[ "$((nextents - 1))" -gt $max_nextents ] && break
-		fi
-		nr=$((nr+1))
+		local nextents="$(xfs_bmap ${name} | grep -v hole | wc -l)"
+		[ "$((nextents - 1))" -gt $max_nextents ] && break
 	done
 
 	test -z "${missing}" && return
-	seq 1 2 "${nr}" | while read d; do
-		rm -rf "${name}/$(printf "%.08d" "$d")"
-	done
+	$here/src/popdir.pl --dir "${name}" --start 1 --incr 2 --end "${nr}" --remove
 }
 
 # Add a bunch of attrs to a file
@@ -224,9 +220,7 @@ _scratch_xfs_populate() {
 
 	# Fill up the root inode chunk
 	echo "+ fill root ino chunk"
-	seq 1 64 | while read f; do
-		$XFS_IO_PROG -f -c "truncate 0" "${SCRATCH_MNT}/dummy${f}"
-	done
+	$here/src/popdir.pl --dir "${SCRATCH_MNT}" --start 1 --end 64 --format "dummy%u" --file-mult 1
 
 	# Regular files
 	# - FMT_EXTENTS
@@ -261,7 +255,7 @@ _scratch_xfs_populate() {
 
 	# - BTREE
 	echo "+ btree dir"
-	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
+	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" "$dblksz" true
 
 	# Symlinks
 	# - FMT_LOCAL
@@ -340,14 +334,7 @@ _scratch_xfs_populate() {
 	local rec_per_btblock=16
 	local nr="$(( 2 * (blksz / rec_per_btblock) * ino_per_rec ))"
 	local dir="${SCRATCH_MNT}/INOBT"
-	mkdir -p "${dir}"
-	seq 0 "${nr}" | while read f; do
-		touch "${dir}/${f}"
-	done
-
-	seq 0 2 "${nr}" | while read f; do
-		rm -f "${dir}/${f}"
-	done
+	__populate_create_dir "${dir}" "${nr}" true --file-mult 1
 
 	# Reverse-mapping btree
 	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
diff --git a/src/popdir.pl b/src/popdir.pl
new file mode 100755
index 0000000000..dc0c046b7d
--- /dev/null
+++ b/src/popdir.pl
@@ -0,0 +1,72 @@
+#!/usr/bin/perl -w
+
+# Copyright (c) 2023 Oracle.  All rights reserved.
+# SPDX-License-Identifier: GPL-2.0
+#
+# Create a bunch of files and subdirs in a directory.
+
+use Getopt::Long;
+use File::Basename;
+
+$progname=$0;
+GetOptions("start=i" => \$start,
+	   "end=i" => \$end,
+	   "file-mult=i" => \$file_mult,
+	   "incr=i" => \$incr,
+	   "format=s" => \$format,
+	   "dir=s" => \$dir,
+	   "remove!" => \$remove,
+	   "help!" => \$help,
+	   "verbose!" => \$verbose);
+
+
+# check/remove output directory, get filesystem info
+if (defined $help) {
+  # newline at end of die message suppresses line number
+  print STDERR <<"EOF";
+Usage: $progname [options]
+Options:
+  --dir             chdir here before starting
+  --start=num       create names starting with this number (0)
+  --incr=num        increment file number by this much (1)
+  --end=num         stop at this file number (100)
+  --file-mult       create a regular file when file number is a multiple
+                    of this quantity (20)
+  --remove          remove instead of creating
+  --format=str      printf formatting string for file name ("%08d")
+  --verbose         verbose output
+  --help            this help screen
+EOF
+  exit(1) unless defined $help;
+  # otherwise...
+  exit(0);
+}
+
+if (defined $dir) {
+	chdir($dir) or die("chdir $dir");
+}
+$start = 0 if (!defined $start);
+$end = 100 if (!defined $end);
+$file_mult = 20 if (!defined $file_mult);
+$format = "%08d" if (!defined $format);
+$incr = 1 if (!defined $incr);
+
+for ($i = $start; $i <= $end; $i += $incr) {
+	$fname = sprintf($format, $i);
+
+	if ($remove) {
+		$verbose && print "rm $fname\n";
+		unlink($fname) or rmdir($fname) or die("unlink $fname");
+	} elsif ($file_mult == 0 or ($i % $file_mult) == 0) {
+		# create a file
+		$verbose && print "touch $fname\n";
+		open(DONTCARE, ">$fname") or die("touch $fname");
+		close(DONTCARE);
+	} else {
+		# create a subdir
+		$verbose && print "mkdir $fname\n";
+		mkdir($fname, 0755) or die("mkdir $fname");
+	}
+}
+
+exit(0);

