Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B034C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E171764E50
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhBJC5y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233689AbhBJC5x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7759764E2F;
        Wed, 10 Feb 2021 02:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925826;
        bh=fnidSCwyHYpkmrjKIOFgQsFly1KLTEmN/tNMdNdz6dY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qy2CJapuBYANVwdQEIA+t3YywT+4RVnd0RI8EbzAnCuf07Q6ySnwLlDMSDevFQNZA
         GKaQ6eVweE/W/jfWdmaYfV4jJv7jINt5Hn/dSbhN2mLQvxHmrizhbeW7i5pn1uk0Ke
         dshGz5Z8T/g+9LGpDzPPKsl2SzFWapoQ+j9BJtdKmnnAtHV2vUT+aOA5cx9kU6KNCA
         GtwTmvLWmpQ2dcz+LU7uBJX+x82uGoNd7ZQROkBg//69710DAx0y+AiA4bKqYN6dFU
         FKx0rfyqQZJHXA/8rAN439Y6Vgo7+VPyxs7Lwaq2k80j1N60q1qn4UoAapmlu7bm9A
         esURI/VQ42+pA==
Subject: [PATCH 2/2] common: remove _require_no_rtinherit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:57:06 -0800
Message-ID: <161292582611.3504701.17311358222740363123.stgit@magnolia>
In-Reply-To: <161292581498.3504701.4053663562108530233.stgit@magnolia>
References: <161292581498.3504701.4053663562108530233.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

All the remaining tests that use _require_no_rtinherit can be adapted to
ignore SCRATCH_RTDEV or to force files to be created on the data device.
This makes the helper unnecessary and increases test coverage, so remove
this helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc     |   10 ----------
 tests/xfs/205 |    5 ++++-
 tests/xfs/306 |    5 ++++-
 tests/xfs/318 |    5 ++++-
 tests/xfs/444 |    6 +++++-
 5 files changed, 17 insertions(+), 14 deletions(-)


diff --git a/common/rc b/common/rc
index ad54b3de..25cbac0b 100644
--- a/common/rc
+++ b/common/rc
@@ -6,16 +6,6 @@
 
 BC=$(which bc 2> /dev/null) || BC=
 
-# Some tests are not relevant or functional when testing XFS realtime
-# subvolumes along with the rtinherit=1 mkfs option.  In these cases,
-# this test will opt-out of the test.
-_require_no_rtinherit()
-{
-	[ "$FSTYP" = "xfs" ] && echo "$MKFS_OPTIONS" |
-		egrep -q "rtinherit([^=]|=1|$)" && \
-		_notrun "rtinherit mkfs option is not supported by this test."
-}
-
 _require_math()
 {
 	if [ -z "$BC" ]; then
diff --git a/tests/xfs/205 b/tests/xfs/205
index da022f19..1f7ce3d8 100755
--- a/tests/xfs/205
+++ b/tests/xfs/205
@@ -23,10 +23,13 @@ _supported_fs xfs
 
 # single AG will cause xfs_repair to fail checks.
 _require_scratch_nocheck
-_require_no_rtinherit
 
 rm -f $seqres.full
 
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming all the free space in our small data device.
+unset SCRATCH_RTDEV
+
 fsblksz=1024
 _scratch_mkfs_xfs -d size=$((32768*fsblksz)) -b size=$fsblksz >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/xfs/306 b/tests/xfs/306
index e1993c08..e98eda4b 100755
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -34,12 +34,15 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch_nocheck	# check complains about single AG fs
-_require_no_rtinherit
 _require_xfs_io_command "fpunch"
 _require_command $UUIDGEN_PROG uuidgen
 
 rm -f $seqres.full
 
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming all the free space in our small data device.
+unset SCRATCH_RTDEV
+
 # Create a small fs with a large directory block size. We want to fill up the fs
 # quickly and then create multi-fsb dirblocks over fragmented free space.
 _scratch_mkfs_xfs -d size=20m -n size=64k >> $seqres.full 2>&1
diff --git a/tests/xfs/318 b/tests/xfs/318
index 90771ade..07375b1f 100755
--- a/tests/xfs/318
+++ b/tests/xfs/318
@@ -32,7 +32,6 @@ _supported_fs xfs
 _require_scratch
 _require_error_injection
 _require_xfs_io_error_injection "rmap_finish_one"
-_require_no_rtinherit
 
 rm -f $seqres.full
 
@@ -43,6 +42,10 @@ echo "Format filesystem"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
 
+# This test depends on specific behaviors of the data device, so create all
+# files on it.
+$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 echo "Create files"
 touch $SCRATCH_MNT/file1
 
diff --git a/tests/xfs/444 b/tests/xfs/444
index f103b793..e4c987f8 100755
--- a/tests/xfs/444
+++ b/tests/xfs/444
@@ -39,11 +39,15 @@ _require_scratch
 _require_test_program "punch-alternating"
 _require_xfs_io_command "falloc"
 _require_xfs_db_write_array
-_require_no_rtinherit
 
 # This is only a v5 filesystem problem
 _require_scratch_xfs_crc
 
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming free space in our small data device and throwing off the
+# filestreams allocator.
+unset SCRATCH_RTDEV
+
 mount_loop() {
 	if ! _try_scratch_mount >> $seqres.full 2>&1; then
 		echo "scratch mount failed" >> $seqres.full

