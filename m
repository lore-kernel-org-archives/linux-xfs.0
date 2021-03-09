Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA46C4332B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94EDD6528A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCIEjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhCIEjR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 333846523B;
        Tue,  9 Mar 2021 04:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264757;
        bh=/myM8H1fNfDvMNUu+T8UflMSvkyGle1dV9UqqSe/g5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pD93ivVzXHfaXaL8AtG5FGud9RpCcTzW5/YDjTqlFKe8gy0ZhLruzOYL91IAPNjld
         27+szvWtMDNGpLJaolqezpd09yDEnz+tLgVp9EA3YrMY02yiyONcHUTNq/IbAA8zEp
         1plsKkm9tZoFnQuwU27cuXJXMgdXbzsRbihxR1ZN3qFywoVnElIyYSYXxspjBEcqzA
         u4KasDTkOAsHBNA0gsmqtN+HFyD2upihAf3E+Bn2DI0mnGmmGI+j8M7P+Y72wLavOX
         Tj71a7iLIAYuuIwOBPOYVHngQ89Si6a2jpn8634o2wX3uakG4g5C8eXInettGoiQ5i
         ZYAgewixY2a1Q==
Subject: [PATCH 2/4] common: move _scratch_metadump to common/xfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:17 -0800
Message-ID: <161526475700.1212855.1193550819027912831.stgit@magnolia>
In-Reply-To: <161526474588.1212855.9208390435676413014.stgit@magnolia>
References: <161526474588.1212855.9208390435676413014.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

_scratch_metadump is really an xfs-specific dump helper, so move it to
common/xfs, add 'xfs' to the name, and convert all users.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 common/rc       |   12 ------------
 common/xfs      |   13 +++++++++++++
 tests/xfs/129   |    2 +-
 tests/xfs/234   |    2 +-
 tests/xfs/253   |    2 +-
 tests/xfs/284   |    4 ++--
 tests/xfs/291   |    2 +-
 tests/xfs/336   |    2 +-
 tests/xfs/432   |    2 +-
 tests/xfs/503   |    8 ++++----
 11 files changed, 26 insertions(+), 25 deletions(-)


diff --git a/common/populate b/common/populate
index f4ad8669..4e5b645f 100644
--- a/common/populate
+++ b/common/populate
@@ -866,7 +866,7 @@ _scratch_populate_cached() {
 	"xfs")
 		_scratch_xfs_populate $@
 		_scratch_xfs_populate_check
-		_scratch_metadump "${POPULATE_METADUMP}" -a -o
+		_scratch_xfs_metadump "${POPULATE_METADUMP}"
 		;;
 	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate $@
diff --git a/common/rc b/common/rc
index 0ce3cb0d..835c3c24 100644
--- a/common/rc
+++ b/common/rc
@@ -490,18 +490,6 @@ _scratch_do_mkfs()
 	return $mkfs_status
 }
 
-_scratch_metadump()
-{
-	local dumpfile=$1
-	shift
-	local options=
-
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
-		options="-l $SCRATCH_LOGDEV"
-
-	$XFS_METADUMP_PROG $options "$@" $SCRATCH_DEV $dumpfile
-}
-
 _setup_large_ext4_fs()
 {
 	local fs_size=$1
diff --git a/common/xfs b/common/xfs
index b30d289f..fe4dea99 100644
--- a/common/xfs
+++ b/common/xfs
@@ -453,6 +453,19 @@ _xfs_metadump() {
 	return $res
 }
 
+# Snapshot the metadata on the scratch device
+_scratch_xfs_metadump()
+{
+	local metadump=$1
+	shift
+	local logdev=none
+
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		logdev=$SCRATCH_LOGDEV
+
+	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" nocompress "$@"
+}
+
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
diff --git a/tests/xfs/129 b/tests/xfs/129
index 78baf5c4..513d2fdd 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -56,7 +56,7 @@ done
 
 echo "Create metadump file"
 _scratch_unmount
-_scratch_metadump $metadump_file
+_scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
diff --git a/tests/xfs/234 b/tests/xfs/234
index 14172c3d..a3a57f2d 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -56,7 +56,7 @@ done
 
 echo "Create metadump file"
 _scratch_unmount
-_scratch_metadump $metadump_file
+_scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
diff --git a/tests/xfs/253 b/tests/xfs/253
index 9d967a50..fb7fc80b 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -156,7 +156,7 @@ ls -R | od -c >> $seqres.full
 cd $here
 
 _scratch_unmount
-_scratch_metadump $METADUMP_FILE
+_scratch_xfs_metadump $METADUMP_FILE
 
 # Now restore the obfuscated one back and take a look around
 xfs_mdrestore "${METADUMP_FILE}" "${SCRATCH_DEV}"
diff --git a/tests/xfs/284 b/tests/xfs/284
index dbfd752b..cc9d723a 100755
--- a/tests/xfs/284
+++ b/tests/xfs/284
@@ -50,12 +50,12 @@ COPY_FILE="${TEST_DIR}/${seq}_copyfile"
 # xfs_metadump should refuse to dump a mounted device
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
-_scratch_metadump $METADUMP_FILE 2>&1 | filter_mounted
+_scratch_xfs_metadump $METADUMP_FILE 2>&1 | filter_mounted
 _scratch_unmount
 
 # Test restore to a mounted device
 # xfs_mdrestore should refuse to restore to a mounted device
-_scratch_metadump $METADUMP_FILE
+_scratch_xfs_metadump $METADUMP_FILE
 _scratch_mount
 xfs_mdrestore $METADUMP_FILE $SCRATCH_DEV 2>&1 | filter_mounted
 _scratch_unmount
diff --git a/tests/xfs/291 b/tests/xfs/291
index 6a507d58..c906f248 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -105,7 +105,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
 
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?
-_scratch_metadump $tmp.metadump || _fail "xfs_metadump failed"
+_scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
 xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
 [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
 	rt_repair_opts="-r $SCRATCH_RTDEV"
diff --git a/tests/xfs/336 b/tests/xfs/336
index a006938d..b35be8a0 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -66,7 +66,7 @@ _scratch_cycle_mount
 
 echo "Create metadump file"
 _scratch_unmount
-_scratch_metadump $metadump_file
+_scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
diff --git a/tests/xfs/432 b/tests/xfs/432
index f41ecfdb..7df74234 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -91,7 +91,7 @@ echo "qualifying extent: $extlen blocks" >> $seqres.full
 test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
 
 echo "Try to metadump"
-_scratch_metadump $metadump_file -w
+_scratch_xfs_metadump $metadump_file -w
 xfs_mdrestore $metadump_file $metadump_img
 
 echo "Check restored metadump image"
diff --git a/tests/xfs/503 b/tests/xfs/503
index edf546a2..20d9c83d 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -47,16 +47,16 @@ metadump_file_ag=${metadump_file}.ag
 copy_file=$testdir/copy.img
 
 echo metadump
-_scratch_metadump $metadump_file >> $seqres.full
+_scratch_xfs_metadump $metadump_file >> $seqres.full
 
 echo metadump a
-_scratch_metadump $metadump_file_a -a >> $seqres.full
+_scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
 
 echo metadump g
-_scratch_metadump $metadump_file_g -g >> $seqres.full
+_scratch_xfs_metadump $metadump_file_g -g >> $seqres.full
 
 echo metadump ag
-_scratch_metadump $metadump_file_ag -a -g >> $seqres.full
+_scratch_xfs_metadump $metadump_file_ag -a -g >> $seqres.full
 
 echo copy
 $XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full

