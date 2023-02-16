Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057B0C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjBPVOL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPVOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:14:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1393A48E22;
        Thu, 16 Feb 2023 13:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA6D5B828F3;
        Thu, 16 Feb 2023 21:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B52C433D2;
        Thu, 16 Feb 2023 21:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582046;
        bh=B0zkU+dGalY1AAWY8KrhS+F0tQByZ/7/s3aIpszdE7c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VPnknRifRHDvINUQ8Svv76p5FmdC7OA7W1LOasLuPytJRcbUKuCqgfbfjdZSDeHMA
         V/yRGvoO79FivHSvF67A8hUyuYY30KHRN/GpRxv5FPKPZByQ9cpfAVSubWKhbqd6R7
         RhXyXIkC2IO0vK49alvHIOB1tloZ2B3Ulit2X9Q7T9etWSZNhBwvP7k+fvfE2XWuL2
         LQn3KLQHIGtbpsEIBV1x6f5l48UhT/Jkb1Y2+e89fDz0m5OB1GL43gtz3arab5xgor
         R8lKNVyzhY0tv8oAF/TZHYFdf0EHltrLx25XgQzqU2kPUDtg7F/o3QGS8GBUokhjz1
         xToxs6Hg7dIUQ==
Date:   Thu, 16 Feb 2023 13:14:05 -0800
Subject: [PATCH 02/14] populate: create hardlinks for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884512.3481377.8617616742438614085.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create some hardlinked files so that we can exercise parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   38 ++++++++++++++++++++++++++++++++++++++
 src/popdir.pl   |   11 +++++++++++
 2 files changed, 49 insertions(+)


diff --git a/common/populate b/common/populate
index 389a762329..d52167964c 100644
--- a/common/populate
+++ b/common/populate
@@ -376,6 +376,7 @@ _scratch_xfs_populate() {
 	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
 	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
+	is_pptr="$(_xfs_has_feature "$SCRATCH_MNT" parent -v)"
 
 	# Reverse-mapping btree
 	if [ $is_rmapbt -gt 0 ]; then
@@ -412,6 +413,43 @@ _scratch_xfs_populate() {
 		cp --reflink=always "${SCRATCH_MNT}/REFCOUNTBT" "${SCRATCH_MNT}/REFCOUNTBT2"
 	fi
 
+	# Parent pointers
+	if [ $is_pptr -gt 0 ]; then
+		echo "+ parent pointers"
+
+		# Create a couple of parent pointers
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" 1 '' --hardlink --format "two_%d"
+
+		# Create one xattr leaf block of parent pointers
+		nr="$((blksz * 2 / 16))"
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "many%04d"
+
+		# Create multiple xattr leaf blocks of large parent pointers
+		nr="$((blksz * 16 / 16))"
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "y%0254d"
+
+		# Create multiple paths to a file
+		local moof="${SCRATCH_MNT}/PPTRS/moofile"
+		touch "${moof}"
+		for ((i = 0; i < 4; i++)); do
+			mkdir -p "${SCRATCH_MNT}/PPTRS/SUB${i}"
+			ln "${moof}" "${SCRATCH_MNT}/PPTRS/SUB${i}/moofile"
+		done
+
+		# Create parent pointers of various lengths
+		touch "${SCRATCH_MNT}/PPTRS/vlength"
+		local len_len
+		local tst
+		local fname
+		ln "${SCRATCH_MNT}/PPTRS/vlength" "${SCRATCH_MNT}/PPTRS/b"
+		for len in 32 64 96 128 160 192 224 250 255; do
+			len_len="${#len}"
+			tst="$(perl -e "print \"b\" x (${len} - (${len_len} + 1))")"
+			fname="v${tst}${len}"
+			ln "${SCRATCH_MNT}/PPTRS/vlength" "${SCRATCH_MNT}/PPTRS/${fname}"
+		done
+	fi
+
 	# Copy some real files (xfs tests, I guess...)
 	echo "+ real files"
 	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
diff --git a/src/popdir.pl b/src/popdir.pl
index dc0c046b7d..950503c621 100755
--- a/src/popdir.pl
+++ b/src/popdir.pl
@@ -17,6 +17,7 @@ GetOptions("start=i" => \$start,
 	   "dir=s" => \$dir,
 	   "remove!" => \$remove,
 	   "help!" => \$help,
+	   "hardlink!" => \$hardlink,
 	   "verbose!" => \$verbose);
 
 
@@ -36,6 +37,7 @@ Options:
   --format=str      printf formatting string for file name ("%08d")
   --verbose         verbose output
   --help            this help screen
+  --hardlink        hardlink subsequent files to the first one created
 EOF
   exit(1) unless defined $help;
   # otherwise...
@@ -51,12 +53,21 @@ $file_mult = 20 if (!defined $file_mult);
 $format = "%08d" if (!defined $format);
 $incr = 1 if (!defined $incr);
 
+if ($hardlink) {
+	$file_mult = 0;
+	$link_fname = sprintf($format, $start);
+}
+
 for ($i = $start; $i <= $end; $i += $incr) {
 	$fname = sprintf($format, $i);
 
 	if ($remove) {
 		$verbose && print "rm $fname\n";
 		unlink($fname) or rmdir($fname) or die("unlink $fname");
+	} elsif ($hardlink && $i > $start) {
+		# hardlink the first file
+		$verbose && print "ln $link_fname $fname\n";
+		link $link_fname, $fname;
 	} elsif ($file_mult == 0 or ($i % $file_mult) == 0) {
 		# create a file
 		$verbose && print "touch $fname\n";

