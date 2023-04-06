Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECBBC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238341AbjDFTnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbjDFTmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:42:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78D3AF21;
        Thu,  6 Apr 2023 12:42:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 716CB63464;
        Thu,  6 Apr 2023 19:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCECC433EF;
        Thu,  6 Apr 2023 19:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810149;
        bh=7PF2EEpRs6JgLEJTmsekk6am1aK5UgrLQ8er8AXE1TE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iprxTvo06+KvOuUtPH2PkDEgUewab56mmlyRIXopkEvwL7gViKIJ1i6bRibubC6iK
         T7YV8Jl7szlzkvlZyPWXsjoeTtX8/Oy/5M9tKwmEBVWNjAq6Jfm6V+tROvDM4gnRdE
         BxmvvE6HbtDXd6xce1KllbvAOUFo9Z1Snx026S7Ah6LmOzYMQMsfowDnZZuWIME/6I
         WlDMqr7ZSZR0Bt5sHkRHTTkl9nlwIzkmzWusxe46HQ9F1kYI+FXnDXciPglJMsXWgp
         UWCR2K3zrFH3NV8aIWxUHrdAM7rHGXt2JhzZoOdbTm58c9elYd3GjMFt4Wh5fXaI1H
         r7gbHXln2FR4A==
Date:   Thu, 06 Apr 2023 12:42:29 -0700
Subject: [PATCH 03/11] populate: create hardlinks for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829046.618488.15413517852580365869.stgit@frogsfrogsfrogs>
In-Reply-To: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
References: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
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
index 3d233073c9..c75253ff14 100644
--- a/common/populate
+++ b/common/populate
@@ -450,6 +450,44 @@ _scratch_xfs_populate() {
 		cp --reflink=always "${SCRATCH_MNT}/REFCOUNTBT" "${SCRATCH_MNT}/REFCOUNTBT2"
 	fi
 
+	# Parent pointers
+	is_pptr="$(_xfs_has_feature "$SCRATCH_MNT" parent -v)"
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
index e89095aafe..0104957a3c 100755
--- a/src/popdir.pl
+++ b/src/popdir.pl
@@ -17,6 +17,7 @@ GetOptions("start=i" => \$start,
 	   "dir=s" => \$dir,
 	   "remove!" => \$remove,
 	   "help!" => \$help,
+	   "hardlink!" => \$hardlink,
 	   "verbose!" => \$verbose);
 
 
@@ -35,6 +36,7 @@ Options:
   --format=str      printf formatting string for file name ("%08d")
   --verbose         verbose output
   --help            this help screen
+  --hardlink        hardlink subsequent files to the first one created
 EOF
   exit(1) unless defined $help;
   # otherwise...
@@ -56,12 +58,21 @@ if ($file_pct < 0) {
 	$file_pct = 100;
 }
 
+if ($hardlink) {
+	$file_pct = 100;
+	$link_fname = sprintf($format, $start);
+}
+
 for ($i = $start; $i <= $end; $i += $incr) {
 	$fname = sprintf($format, $i);
 
 	if ($remove) {
 		$verbose && print "rm $fname\n";
 		unlink($fname) or rmdir($fname) or die("unlink $fname");
+	} elsif ($hardlink && $i > $start) {
+		# hardlink everything after the first file
+		$verbose && print "ln $link_fname $fname\n";
+		link $link_fname, $fname;
 	} elsif (($i % 100) < $file_pct) {
 		# create a file
 		$verbose && print "touch $fname\n";

