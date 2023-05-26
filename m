Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F04C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjEZCC5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjEZCCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:02:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915D5A3;
        Thu, 25 May 2023 19:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170E464C49;
        Fri, 26 May 2023 02:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E744C433EF;
        Fri, 26 May 2023 02:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066573;
        bh=7PF2EEpRs6JgLEJTmsekk6am1aK5UgrLQ8er8AXE1TE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VXd6bJQiQuemmDi7HOTcQtg1nN/6XswRqxLUZNU2qmbyq2WyvtuoQa4syeOvnT12v
         EeoNzxAn0iwmzz0XI3FCpr7MYIuO1MGDxVFcYZPl9Y7wSzY80nD1P5dk6tO4rem7+0
         ll89BYX9FuIBIlBtuo7D+hG3l+obsaAA726vc+xt4DD+SzS3Rl9S2l/ViLWuZR9u7d
         OBocZSwUQgyvmbRF/Iv1gqqsghaUXMLMYvD8Blv0G2Y2+V+ou2jvBt1ZDUou0LPyiM
         Jh2d+22eTwNcMc0jY3mU+Brz7NjkURpfIQnWlGn6P21m84b1cTXZc2LbWO0beKFkQh
         /6u59J9bSjosQ==
Date:   Thu, 25 May 2023 19:02:53 -0700
Subject: [PATCH 03/11] populate: create hardlinks for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <168506060888.3732476.16059783773341686630.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
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

