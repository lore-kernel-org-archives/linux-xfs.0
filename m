Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921F4C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 736F56528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCIEjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCIEj2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F7765275;
        Tue,  9 Mar 2021 04:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264768;
        bh=9XRsAZ8FAxeuTStWvCNwZLRLqwqJnTLPKMn+T2un58c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CqWGaSnSdpBNOUwNaL0zT5MvgPSnl6oB/CN2BfAVqBWdqeuY2eWsxawaiptVoG32q
         BvacSqR/BB4uL3obZY98CTgucR4R5g6NBNqNTxlTrH3/VIY64A7l1WUoOSq28xwUCG
         goOpXO3kaZp1WMo50Syp5a+MJVcXrsCT6yqYc7FQi7ZFGPn60XPJM6Tidj8EWe4j80
         URiz2yabpDPqmUvEXSGW4gD9gagSyguuePRQO2ebNT2knMXrVZYzzN+AoYsYJPKhgv
         vaeeuLk0mYKL6go4cvYNZWzvgUXJJMDiIPv4rCgSYjaFcMCbN76Mh1i6fthmHRpukS
         FAA4Ndizz2YAQ==
Subject: [PATCH 4/4] common: capture qcow2 dumps of corrupt ext* filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:27 -0800
Message-ID: <161526476796.1212855.15194258148539741251.stgit@magnolia>
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

Create a new helper to use e2image to capture a qcow2 image of an ext*
filesystem and make _check_generic_filesystem use it to dump corrupt ext
images.  Refactor the single user of e2image to use the helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README          |    2 +-
 common/config   |    1 +
 common/populate |    2 +-
 common/rc       |   21 +++++++++++++++++++++
 4 files changed, 24 insertions(+), 2 deletions(-)


diff --git a/README b/README
index 3d369438..7a2638af 100644
--- a/README
+++ b/README
@@ -109,7 +109,7 @@ Preparing system for tests:
              - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
                it between test invocations.  This assumes that the name of
                the module is the same as FSTYP.
-             - Set DUMP_CORRUPT_FS=1 to record metadata dumps of XFS
+             - Set DUMP_CORRUPT_FS=1 to record metadata dumps of XFS or ext*
                filesystems if a filesystem check fails.
              - Set DUMP_COMPRESSOR to a compression program to compress
                metadumps of filesystems.  This program must accept '-f' and the
diff --git a/common/config b/common/config
index d4cf8089..a47e462c 100644
--- a/common/config
+++ b/common/config
@@ -225,6 +225,7 @@ export CC_PROG="$(type -P cc)"
 export FSVERITY_PROG="$(type -P fsverity)"
 export OPENSSL_PROG="$(type -P openssl)"
 export ACCTON_PROG="$(type -P accton)"
+export E2IMAGE_PROG="$(type -P e2image)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/populate b/common/populate
index b897922c..4135d89d 100644
--- a/common/populate
+++ b/common/populate
@@ -888,7 +888,7 @@ _scratch_populate_cached() {
 	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate $@
 		_scratch_ext4_populate_check
-		e2image -Q "${SCRATCH_DEV}" "${POPULATE_METADUMP}"
+		_ext4_metadump "${SCRATCH_DEV}" "${POPULATE_METADUMP}" compress
 		;;
 	*)
 		_fail "Don't know how to populate a ${FSTYP} filesystem."
diff --git a/common/rc b/common/rc
index 835c3c24..a460ec9c 100644
--- a/common/rc
+++ b/common/rc
@@ -585,6 +585,18 @@ _scratch_mkfs_ext4()
 	return $mkfs_status
 }
 
+_ext4_metadump()
+{
+	local device="$1"
+	local dumpfile="$2"
+	local compressopt="$3"
+
+	test -n "$E2IMAGE_PROG" || _fail "e2image not installed"
+	$E2IMAGE_PROG -Q "$device" "$dumpfile"
+	[ "$compressopt" = "compress" ] && [ -n "$DUMP_COMPRESSOR" ] &&
+		$DUMP_COMPRESSOR "$dumpfile" &>> "$seqres.full"
+}
+
 _test_mkfs()
 {
     case $FSTYP in
@@ -2730,6 +2742,15 @@ _check_generic_filesystem()
     fi
     rm -f $tmp.fsck
 
+    if [ $ok -eq 0 ] && [ -n "$DUMP_CORRUPT_FS" ]; then
+        case "$FSTYP" in
+        ext*)
+            local flatdev="$(basename "$device")"
+            _ext4_metadump "$seqres.$flatdev.check.qcow2" "$device" compress
+            ;;
+        esac
+    fi
+
     if [ $ok -eq 0 ]
     then
         echo "*** mount output ***"		>>$seqres.full

