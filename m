Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A496C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiLaAn6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbiLaAn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:43:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E321DDE2;
        Fri, 30 Dec 2022 16:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA9C0B81E6A;
        Sat, 31 Dec 2022 00:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44720C433D2;
        Sat, 31 Dec 2022 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447432;
        bh=1m5U7pR6fT3EIQAXb1UYoy3hoSENtTpY86vqUFcbIs0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n+Tl+mFhYcAQs0rvDGTDWMjcghS/9iE43a6PxhG182UtgipnAfvu6yb1vqKVt+Zbe
         CDTQQ1k+LHq2HJXNr8tRU3pwxfHvcrrafWvN9VfwIsRHfhxxrxMA57VbSPVugtgfp9
         r/e1oj/BjmyaahihwafPNpzRzsALdR2b7wMZBlY/Lw8e9O88frnqn55BAN3hUMCm9t
         9iUnQH5uHGQtEBoEmG8svZK/2+GrKnJTeC0vzsnfYS/c9IEZkKlyqc+wHF8Ym/ulBx
         CGr7gfsBCOOeqflzWI/X4eT+qH9s1REkoqJf3AAlem2ntowzheH6YuHufaxSvUCYlJ
         lShVHxl2Tz6vg==
Subject: [PATCH 1/2] populate: take a snapshot of the filesystem if creation
 fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877624.728350.10053982828600026086.stgit@magnolia>
In-Reply-To: <167243877612.728350.1799909806305296744.stgit@magnolia>
References: <167243877612.728350.1799909806305296744.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There have been a few bug reports filed about people not being able to
use the filesystem metadata population code to create filesystems with
all types of metadata on them.  Right now this is super-annoying to
debug because we don't capture a metadump for easy debugging.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   59 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 19 deletions(-)


diff --git a/common/populate b/common/populate
index 44b4af1667..e4090a29d3 100644
--- a/common/populate
+++ b/common/populate
@@ -40,6 +40,27 @@ __populate_create_file() {
 	$XFS_IO_PROG -f -c "pwrite -S 0x62 -W -b 1m 0 $sz" "${fname}"
 }
 
+# Fail the test if we failed to create some kind of filesystem metadata.
+# Create a metadata dump of the failed filesystem so that we can analyze
+# how things went rong.
+__populate_fail() {
+	local flatdev="$(basename "$SCRATCH_DEV")"
+	local metadump="$seqres.$flatdev.populate.md"
+
+	case "$FSTYP" in
+	xfs)
+		_scratch_unmount
+		_scratch_xfs_metadump "$metadump"
+		;;
+	ext4)
+		_scratch_unmount
+		_ext4_metadump "${SCRATCH_DEV}" "$metadump"
+		;;
+	esac
+
+	_fail "$@"
+}
+
 # Punch out every other hole in this file, if it exists.
 #
 # The goal here is to force the creation of a large number of metadata records
@@ -501,7 +522,7 @@ __populate_check_xfs_dformat() {
 	format="$2"
 
 	fmt="$(_scratch_xfs_db -c "inode ${inode}" -c 'p core.format' | sed -e 's/^.*(\([a-z]*\)).*$/\1/g')"
-	test "${format}" = "${fmt}" || _fail "failed to create ino ${inode} dformat expected ${format} saw ${fmt}"
+	test "${format}" = "${fmt}" || __populate_fail "failed to create ino ${inode} dformat expected ${format} saw ${fmt}"
 }
 
 # Check attr fork format of XFS file
@@ -510,7 +531,7 @@ __populate_check_xfs_aformat() {
 	format="$2"
 
 	fmt="$(_scratch_xfs_db -c "inode ${inode}" -c 'p core.aformat' | sed -e 's/^.*(\([a-z]*\)).*$/\1/g')"
-	test "${format}" = "${fmt}" || _fail "failed to create ino ${inode} aformat expected ${format} saw ${fmt}"
+	test "${format}" = "${fmt}" || __populate_fail "failed to create ino ${inode} aformat expected ${format} saw ${fmt}"
 }
 
 # Check structure of XFS directory
@@ -529,21 +550,21 @@ __populate_check_xfs_dir() {
 
 	case "${dtype}" in
 	"shortform"|"inline"|"local")
-		(test "${datab}" -eq 0 && test "${leafb}" -eq 0 && test "${freeb}" -eq 0) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
+		(test "${datab}" -eq 0 && test "${leafb}" -eq 0 && test "${freeb}" -eq 0) || __populate_fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
 	"block")
-		(test "${datab}" -eq 1 && test "${leafb}" -eq 0 && test "${freeb}" -eq 0) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
+		(test "${datab}" -eq 1 && test "${leafb}" -eq 0 && test "${freeb}" -eq 0) || __populate_fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
 	"leaf")
-		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 0) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
+		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 0) || __populate_fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
 	"leafn")
 		_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "p lhdr.info.hdr.magic" | grep -q '0x3dff' && return
 		_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "p lhdr.info.magic" | grep -q '0xd2ff' && return
-		_fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
+		__populate_fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
 	"node"|"btree")
-		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 1) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
+		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 1) || __populate_fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
 	*)
 		_fail "Unknown directory type ${dtype}"
@@ -563,13 +584,13 @@ __populate_check_xfs_attr() {
 
 	case "${atype}" in
 	"shortform"|"inline"|"local")
-		(test "${datab}" -eq 0 && test "${leafb}" -eq 0) || _fail "failed to create ${atype} attr ino ${inode} datab ${datab} leafb ${leafb}"
+		(test "${datab}" -eq 0 && test "${leafb}" -eq 0) || __populate_fail "failed to create ${atype} attr ino ${inode} datab ${datab} leafb ${leafb}"
 		;;
 	"leaf")
-		(test "${datab}" -eq 1 && test "${leafb}" -eq 0) || _fail "failed to create ${atype} attr ino ${inode} datab ${datab} leafb ${leafb}"
+		(test "${datab}" -eq 1 && test "${leafb}" -eq 0) || __populate_fail "failed to create ${atype} attr ino ${inode} datab ${datab} leafb ${leafb}"
 		;;
 	"node"|"btree")
-		(test "${datab}" -eq 1 && test "${leafb}" -eq 1) || _fail "failed to create ${atype} attr ino ${inode} datab ${datab} leafb ${leafb}"
+		(test "${datab}" -eq 1 && test "${leafb}" -eq 1) || __populate_fail "failed to create ${atype} attr ino ${inode} datab ${datab} leafb ${leafb}"
 		;;
 	*)
 		_fail "Unknown attribute type ${atype}"
@@ -605,7 +626,7 @@ __populate_check_xfs_agbtree_height() {
 			return 100
 		fi
 	done
-	test $? -eq 100 || _fail "Failed to create ${bt_type} of sufficient height!"
+	test $? -eq 100 || __populate_fail "Failed to create ${bt_type} of sufficient height!"
 	return 1
 }
 
@@ -678,13 +699,13 @@ __populate_check_ext4_dformat() {
 
 	case "${format}" in
 	"blockmap")
-		test "${extents}" -eq 0 || _fail "failed to create ino ${inode} with blockmap"
+		test "${extents}" -eq 0 || __populate_fail "failed to create ino ${inode} with blockmap"
 		;;
 	"extent"|"extents")
-		test "${extents}" -eq 1 || _fail "failed to create ino ${inode} with extents"
+		test "${extents}" -eq 1 || __populate_fail "failed to create ino ${inode} with extents"
 		;;
 	"etree")
-		(test "${extents}" -eq 1 && test "${etree}" -eq 1) || _fail "failed to create ino ${inode} with extent tree"
+		(test "${extents}" -eq 1 && test "${etree}" -eq 1) || __populate_fail "failed to create ino ${inode} with extent tree"
 		;;
 	*)
 		_fail "Unknown dformat ${format}"
@@ -702,10 +723,10 @@ __populate_check_ext4_aformat() {
 
 	case "${format}" in
 	"local"|"inline")
-		test "${ablock}" -eq 0 || _fail "failed to create inode ${inode} with ${format} xattr"
+		test "${ablock}" -eq 0 || __populate_fail "failed to create inode ${inode} with ${format} xattr"
 		;;
 	"block")
-		test "${extents}" -eq 1 || _fail "failed to create inode ${inode} with ${format} xattr"
+		test "${extents}" -eq 1 || __populate_fail "failed to create inode ${inode} with ${format} xattr"
 		;;
 	*)
 		_fail "Unknown aformat ${format}"
@@ -726,13 +747,13 @@ __populate_check_ext4_dir() {
 
 	case "${dtype}" in
 	"inline")
-		(test "${inline}" -eq 1 && test "${htree}" -eq 0) || _fail "failed to create ${dtype} dir ino ${inode} htree ${htree} inline ${inline}"
+		(test "${inline}" -eq 1 && test "${htree}" -eq 0) || __populate_fail "failed to create ${dtype} dir ino ${inode} htree ${htree} inline ${inline}"
 		;;
 	"block")
-		(test "${inline}" -eq 0 && test "${htree}" -eq 0) || _fail "failed to create ${dtype} dir ino ${inode} htree ${htree} inline ${inline}"
+		(test "${inline}" -eq 0 && test "${htree}" -eq 0) || __populate_fail "failed to create ${dtype} dir ino ${inode} htree ${htree} inline ${inline}"
 		;;
 	"htree")
-		(test "${inline}" -eq 0 && test "${htree}" -eq 1) || _fail "failed to create ${dtype} dir ino ${inode} htree ${htree} inline ${inline}"
+		(test "${inline}" -eq 0 && test "${htree}" -eq 1) || __populate_fail "failed to create ${dtype} dir ino ${inode} htree ${htree} inline ${inline}"
 		;;
 	*)
 		_fail "Unknown directory type ${dtype}"

