Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB4EC38142
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 00:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBAAvq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjBAAvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2023 19:51:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED9F53E53;
        Tue, 31 Jan 2023 16:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A26D1B81ED8;
        Wed,  1 Feb 2023 00:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44664C433D2;
        Wed,  1 Feb 2023 00:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675212701;
        bh=AAtrCUas7Irka0a64PakqXYTXN1sXTLTSrj94KA+lYI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kSkpNaT25+SmwYQNRPVA1st51vbuE6m2A++wPWGgz2F4fBELgxjC9mtyhNsHTvg6u
         8yhqpHmlm5dKvgdG3IkMmOsmUX2tBIgHR8USbWFlUAZ96OyNpciK5c8zSHyWUQ1us9
         /JOxKu2Pr+fUUmMgyhGQ9I0ofCYf77Rx9uRPKzx6lmbNKLGrIRaf7p09NPKZDEe0Is
         1tyHFr1GBwLd5w0fi1pfqpjgNgTTRFyeITmuIrQAlmTaaWsJwRfFHKqG6PCjAL2qKL
         XakMkQEuOJ53VG1GFc+TWRLOQ6kSgL1OEuq0JZoC/no6bhCOJfdofVwBFNzmSb0VpW
         SZTQAn64/TssA==
Subject: [PATCH 2/2] generic/500: skip this test if formatting fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Jan 2023 16:51:40 -0800
Message-ID: <167521270079.2382722.2799074346773170090.stgit@magnolia>
In-Reply-To: <167521268927.2382722.13701066927653225895.stgit@magnolia>
References: <167521268927.2382722.13701066927653225895.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This testcase exercises what happens when we race a filesystem
perforing discard operations against a thin provisioning device that has
run out of space.  To constrain runtime, it creates a 128M thinp volume
and formats it.

However, if that initial format fails because (say) the 128M volume is
too small, then the test fails.  This is really a case of test
preconditions not being satisfied, so let's make the test _notrun when
this happens.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmthin     |    7 ++++-
 common/rc         |   80 +++++++++++++++++++++++++++--------------------------
 tests/generic/500 |    3 +-
 3 files changed, 48 insertions(+), 42 deletions(-)


diff --git a/common/dmthin b/common/dmthin
index 91147e47ac..7107d50804 100644
--- a/common/dmthin
+++ b/common/dmthin
@@ -234,5 +234,10 @@ _dmthin_mount()
 _dmthin_mkfs()
 {
 	_scratch_options mkfs
-	_mkfs_dev $SCRATCH_OPTIONS $@ $DMTHIN_VOL_DEV
+	_mkfs_dev $SCRATCH_OPTIONS "$@" $DMTHIN_VOL_DEV
+}
+_dmthin_try_mkfs()
+{
+	_scratch_options mkfs
+	_try_mkfs_dev $SCRATCH_OPTIONS "$@" $DMTHIN_VOL_DEV
 }
diff --git a/common/rc b/common/rc
index 36eb90e1f1..376a0138b4 100644
--- a/common/rc
+++ b/common/rc
@@ -604,49 +604,49 @@ _test_mkfs()
     esac
 }
 
+_try_mkfs_dev()
+{
+    case $FSTYP in
+    nfs*)
+	# do nothing for nfs
+	;;
+    9p)
+	# do nothing for 9p
+	;;
+    fuse)
+	# do nothing for fuse
+	;;
+    virtiofs)
+	# do nothing for virtiofs
+	;;
+    overlay)
+	# do nothing for overlay
+	;;
+    pvfs2)
+	# do nothing for pvfs2
+	;;
+    udf)
+        $MKFS_UDF_PROG $MKFS_OPTIONS $*
+	;;
+    btrfs)
+        $MKFS_BTRFS_PROG $MKFS_OPTIONS $*
+	;;
+    ext2|ext3|ext4)
+	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $*
+	;;
+    xfs)
+	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $*
+	;;
+    *)
+	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $*
+	;;
+    esac
+}
+
 _mkfs_dev()
 {
     local tmp=`mktemp -u`
-    case $FSTYP in
-    nfs*)
-	# do nothing for nfs
-	;;
-    9p)
-	# do nothing for 9p
-	;;
-    fuse)
-	# do nothing for fuse
-	;;
-    virtiofs)
-	# do nothing for virtiofs
-	;;
-    overlay)
-	# do nothing for overlay
-	;;
-    pvfs2)
-	# do nothing for pvfs2
-	;;
-    udf)
-        $MKFS_UDF_PROG $MKFS_OPTIONS $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
-	;;
-    btrfs)
-        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
-	;;
-    ext2|ext3|ext4)
-	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* \
-		2>$tmp.mkfserr 1>$tmp.mkfsstd
-	;;
-    xfs)
-	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* \
-		2>$tmp.mkfserr 1>$tmp.mkfsstd
-	;;
-    *)
-	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* \
-		2>$tmp.mkfserr 1>$tmp.mkfsstd
-	;;
-    esac
-
-    if [ $? -ne 0 ]; then
+    if ! _try_mkfs_dev "$@" 2>$tmp.mkfserr 1>$tmp.mkfsstd; then
 	# output stored mkfs output
 	cat $tmp.mkfserr >&2
 	cat $tmp.mkfsstd
diff --git a/tests/generic/500 b/tests/generic/500
index bc84d219fa..1151c8f234 100755
--- a/tests/generic/500
+++ b/tests/generic/500
@@ -58,7 +58,8 @@ CLUSTER_SIZE=$((64 * 1024 / 512))		# 64K
 
 _dmthin_init $BACKING_SIZE $VIRTUAL_SIZE $CLUSTER_SIZE 0
 _dmthin_set_fail
-_dmthin_mkfs
+_dmthin_try_mkfs >> $seqres.full 2>&1 || \
+	_notrun "Could not format small thinp filesystem for test"
 _dmthin_mount
 
 # There're two bugs at here, one is dm-thin bug, the other is filesystem

