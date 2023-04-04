Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C26C76188
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 23:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbjDDXRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235754AbjDDXRD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 19:17:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C384200;
        Tue,  4 Apr 2023 16:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E90B639B7;
        Tue,  4 Apr 2023 23:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E37C433D2;
        Tue,  4 Apr 2023 23:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680650221;
        bh=/nm612KZkoTN/JgnmYvXu87DPGq5WXcxJSyNQ90IAUU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mqu6ailpNyrIHStIl1xj+Lnd4Zjnoy4mKSyQCXTJ1GPUPDdCaa6Lww/CEsEhuloKf
         AIazlYdnOgHpbHeUCnZyOMvgKoPRsq/2XMyABkpYNcdjmgGJQi87NyOqbGKCKTI7oa
         4lxWX7fKKLnw1qy7KIiE1/MWk66gvRCpWDmXY10P8Wps5QsK7WbaPyShgc6kLaOtMI
         5TiQw6tOCh3iHgGChXcIVUFUMMPz/uMf3fO3k5nt5z8MuV+oBze1W/6UeqLsxXBHmk
         pIfClFt5OBpqgL/ryHa0nu2rHkN7rleEj5p7jGbSLZTtkKkST0U54SdrQHcdGwuQNm
         NfUyYdNPMYl8Q==
Subject: [PATCH 2/3] populate: create fewer subdirs when constructing
 directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 04 Apr 2023 16:17:00 -0700
Message-ID: <168065022088.494608.9054319548766410710.stgit@frogsfrogsfrogs>
In-Reply-To: <168065020955.494608.9615705289123811403.stgit@frogsfrogsfrogs>
References: <168065020955.494608.9615705289123811403.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Based on some surveys of aged filesystems, I've noticed that the
proportion of directory children that are subdirectories tends to be
more in the 5-10% range, not the 95% that the current code generates.
Rework popdir.pl so that we can specify arbitrary percentages of
children files, and lower the ratio dramatically.

This shouldn't have any substantive changes in the shape of the
directories that gets generated; it just gets us a more realistic
sample.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    4 ++--
 src/popdir.pl   |   15 ++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)


diff --git a/common/populate b/common/populate
index 144a3f5186..524e0c32cb 100644
--- a/common/populate
+++ b/common/populate
@@ -308,7 +308,7 @@ _scratch_xfs_populate() {
 
 	# Fill up the root inode chunk
 	echo "+ fill root ino chunk"
-	$here/src/popdir.pl --dir "${SCRATCH_MNT}" --start 1 --end 64 --format "dummy%u" --file-mult 1
+	$here/src/popdir.pl --dir "${SCRATCH_MNT}" --start 1 --end 64 --format "dummy%u" --file-pct 100
 
 	# Regular files
 	# - FMT_EXTENTS
@@ -422,7 +422,7 @@ _scratch_xfs_populate() {
 	local rec_per_btblock=16
 	local nr="$(( 2 * (blksz / rec_per_btblock) * ino_per_rec ))"
 	local dir="${SCRATCH_MNT}/INOBT"
-	__populate_create_dir "${dir}" "${nr}" true --file-mult 1
+	__populate_create_dir "${dir}" "${nr}" true --file-pct 100
 
 	# Reverse-mapping btree
 	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
diff --git a/src/popdir.pl b/src/popdir.pl
index dc0c046b7d..e89095aafe 100755
--- a/src/popdir.pl
+++ b/src/popdir.pl
@@ -11,7 +11,7 @@ use File::Basename;
 $progname=$0;
 GetOptions("start=i" => \$start,
 	   "end=i" => \$end,
-	   "file-mult=i" => \$file_mult,
+	   "file-pct=i" => \$file_pct,
 	   "incr=i" => \$incr,
 	   "format=s" => \$format,
 	   "dir=s" => \$dir,
@@ -30,8 +30,7 @@ Options:
   --start=num       create names starting with this number (0)
   --incr=num        increment file number by this much (1)
   --end=num         stop at this file number (100)
-  --file-mult       create a regular file when file number is a multiple
-                    of this quantity (20)
+  --file-pct        create this percentage of regular files (90 percent)
   --remove          remove instead of creating
   --format=str      printf formatting string for file name ("%08d")
   --verbose         verbose output
@@ -47,17 +46,23 @@ if (defined $dir) {
 }
 $start = 0 if (!defined $start);
 $end = 100 if (!defined $end);
-$file_mult = 20 if (!defined $file_mult);
+$file_pct = 90 if (!defined $file_pct);
 $format = "%08d" if (!defined $format);
 $incr = 1 if (!defined $incr);
 
+if ($file_pct < 0) {
+	$file_pct = 0;
+} elsif ($file_pct > 100) {
+	$file_pct = 100;
+}
+
 for ($i = $start; $i <= $end; $i += $incr) {
 	$fname = sprintf($format, $i);
 
 	if ($remove) {
 		$verbose && print "rm $fname\n";
 		unlink($fname) or rmdir($fname) or die("unlink $fname");
-	} elsif ($file_mult == 0 or ($i % $file_mult) == 0) {
+	} elsif (($i % 100) < $file_pct) {
 		# create a file
 		$verbose && print "touch $fname\n";
 		open(DONTCARE, ">$fname") or die("touch $fname");

