Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4619C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 17:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346812AbiDRRGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 13:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346820AbiDRRGj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 13:06:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B96F2FE45
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 10:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650301438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynMYRsy4QOwHFHNC5oAc1huaHjMmia79YF1LVwQSJMY=;
        b=GBuVTbozje9altUo1bORfHkQqF9j+XGjlW5WzNS2r4TP+bhUW3Z6ZFc9r8FkuG9DVArKmE
        sLcK8EDJ45VJ0bFKX88nxqx2fvQMT6/vPhZK6ReF/Y8+m49o5C/yM8fXR9ifKLWjbvQcoU
        JjIAF8XTrqQmyxlAPSa2s1XGNXENNaE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-V_3s8TJLPD6Ddu5HrDTBzg-1; Mon, 18 Apr 2022 13:03:54 -0400
X-MC-Unique: V_3s8TJLPD6Ddu5HrDTBzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E69C85A5A8;
        Mon, 18 Apr 2022 17:03:54 +0000 (UTC)
Received: from zlang-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84DC740D2826;
        Mon, 18 Apr 2022 17:03:51 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@redhat.com
Subject: [PATCH v3 1/2] fstests: remove _wipe_fs from dump testing entirely
Date:   Tue, 19 Apr 2022 01:03:25 +0800
Message-Id: <20220418170326.425762-2-zlang@redhat.com>
In-Reply-To: <20220418170326.425762-1-zlang@redhat.com>
References: <20220418170326.425762-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The _wipe_fs function in common/dump is a historical remnant of
xfstests, it's easy to cause confusion now. Now xfstests tend to
call `require_scratch && scratch_mkfs && scratch_mount` in each case
itself, we don't need to use a function to do that specially, so
remove _wipe_fs entirely.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 common/dump   | 17 -----------------
 tests/xfs/022 |  3 +++
 tests/xfs/023 |  3 +++
 tests/xfs/024 |  3 +++
 tests/xfs/025 |  3 +++
 tests/xfs/026 |  3 +++
 tests/xfs/027 |  3 +++
 tests/xfs/028 |  7 +++----
 tests/xfs/035 |  3 +++
 tests/xfs/036 |  3 +++
 tests/xfs/037 |  3 +++
 tests/xfs/038 |  3 +++
 tests/xfs/039 |  3 +++
 tests/xfs/043 |  5 ++++-
 tests/xfs/046 |  3 +++
 tests/xfs/047 |  7 +++----
 tests/xfs/055 |  4 ++++
 tests/xfs/056 |  3 +++
 tests/xfs/059 |  3 +++
 tests/xfs/060 |  3 +++
 tests/xfs/061 |  3 +++
 tests/xfs/063 |  3 +++
 tests/xfs/064 |  3 +++
 tests/xfs/065 |  3 ++-
 tests/xfs/066 |  3 +++
 tests/xfs/068 |  3 +++
 tests/xfs/266 |  3 +++
 tests/xfs/267 |  4 +++-
 tests/xfs/268 |  4 +++-
 tests/xfs/281 |  4 +++-
 tests/xfs/282 |  4 +++-
 tests/xfs/283 |  4 +++-
 tests/xfs/296 |  4 ++--
 tests/xfs/301 |  2 ++
 tests/xfs/302 |  3 ++-
 35 files changed, 100 insertions(+), 35 deletions(-)

diff --git a/common/dump b/common/dump
index ea16d442..6de7dab4 100644
--- a/common/dump
+++ b/common/dump
@@ -217,14 +217,6 @@ _require_tape()
     _set_variable
 }
 
-_wipe_fs()
-{
-    _require_scratch
-
-    _scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
-    _scratch_mount >>$seqres.full
-}
-
 #
 # Cleanup created dirs and files
 # Called by trap
@@ -289,7 +281,6 @@ _create_dumpdir_stress_num()
     echo "Creating directory system to dump using fsstress."
 
     _count=$1
-    _wipe_fs
 
     _param="-f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10"
     rm -rf $dump_dir
@@ -567,7 +558,6 @@ End-of-File
 
 _create_dumpdir_largefile()
 {
-    _wipe_fs
     mkdir -p $dump_dir || _fail "cannot mkdir \"$dump_dir\""
     _largesize=4294967297
     _largefile=$dump_dir/largefile
@@ -579,7 +569,6 @@ _create_dumpdir_largefile()
 
 _create_dumpdir_fill()
 {
-    _wipe_fs
     _mk_fillconfig1
     _do_create_dumpdir_fill
     _stable_fs
@@ -587,7 +576,6 @@ _create_dumpdir_fill()
 
 _create_dumpdir_fill2()
 {
-    _wipe_fs
     _mk_fillconfig2
     _do_create_dumpdir_fill
     _stable_fs
@@ -595,7 +583,6 @@ _create_dumpdir_fill2()
 
 _create_dumpdir_fill_perm()
 {
-    _wipe_fs
     _mk_fillconfig_perm
     _do_create_dumpdir_fill
     _stable_fs
@@ -603,7 +590,6 @@ _create_dumpdir_fill_perm()
 
 _create_dumpdir_fill_ea()
 {
-    _wipe_fs
     _mk_fillconfig_ea
     _do_create_dumpdir_fill
     _stable_fs
@@ -615,7 +601,6 @@ _create_dumpdir_fill_ea()
 #
 _create_dumpdir_fill_multi()
 {
-    _wipe_fs
     _mk_fillconfig_multi
     _do_create_dumpdir_fill
     _stable_fs
@@ -720,7 +705,6 @@ End-of-File
 
 _create_dumpdir_symlinks()
 {
-    _wipe_fs
     _mk_symlink_config
     _do_create_dump_symlinks
     _stable_fs
@@ -771,7 +755,6 @@ _modify_level()
 _create_dumpdir_hardlinks()
 {
     _numsets=$1
-    _wipe_fs
     echo "Creating directory system of hardlinks to incrementally dump."
 
     mkdir -p $dump_dir || _fail "cannot mkdir \"$dump_dir\""
diff --git a/tests/xfs/022 b/tests/xfs/022
index 9334bc41..2f011b28 100755
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -29,6 +29,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 # note: fsstress uses an endian dependent random number generator, running this
 # will produce different output for big/little endian machines.
diff --git a/tests/xfs/023 b/tests/xfs/023
index 1ff406a6..f6f6503a 100755
--- a/tests/xfs/023
+++ b/tests/xfs/023
@@ -28,6 +28,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_hard
 _do_dump_sub
diff --git a/tests/xfs/024 b/tests/xfs/024
index a277c83f..83a8882c 100755
--- a/tests/xfs/024
+++ b/tests/xfs/024
@@ -26,6 +26,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 # ensure file/dir timestamps precede dump timestamp
 sleep 2
diff --git a/tests/xfs/025 b/tests/xfs/025
index b7a5b3bb..bafe82d7 100755
--- a/tests/xfs/025
+++ b/tests/xfs/025
@@ -26,6 +26,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_hard
 _do_dump_min
diff --git a/tests/xfs/026 b/tests/xfs/026
index 29ebb5aa..fba385dc 100755
--- a/tests/xfs/026
+++ b/tests/xfs/026
@@ -24,6 +24,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill
 _do_dump_file
diff --git a/tests/xfs/027 b/tests/xfs/027
index a0dcf8b3..16cd203d 100755
--- a/tests/xfs/027
+++ b/tests/xfs/027
@@ -24,6 +24,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill
 _do_dump_restore
diff --git a/tests/xfs/028 b/tests/xfs/028
index b7c9d16b..1ff9d7d2 100755
--- a/tests/xfs/028
+++ b/tests/xfs/028
@@ -24,10 +24,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-
-# wipe test dir clean first
-# so dump can be real quick
-_wipe_fs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 #
 # Create 5 dumps
diff --git a/tests/xfs/035 b/tests/xfs/035
index 03cb7a76..d23cca95 100755
--- a/tests/xfs/035
+++ b/tests/xfs/035
@@ -25,6 +25,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_hard
 _do_dump -L $seq.1
diff --git a/tests/xfs/036 b/tests/xfs/036
index 191345c5..73eb7cd5 100755
--- a/tests/xfs/036
+++ b/tests/xfs/036
@@ -25,6 +25,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $RMT_IRIXTAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_soft
 _do_dump_min -o -F
diff --git a/tests/xfs/037 b/tests/xfs/037
index b3fbbedd..b19ba9e9 100755
--- a/tests/xfs/037
+++ b/tests/xfs/037
@@ -24,6 +24,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $RMT_TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_soft
 _do_dump_min -o -F
diff --git a/tests/xfs/038 b/tests/xfs/038
index 633c51e0..397c354d 100755
--- a/tests/xfs/038
+++ b/tests/xfs/038
@@ -24,6 +24,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $RMT_TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_hard
 _do_dump
diff --git a/tests/xfs/039 b/tests/xfs/039
index e3a98921..d54e9975 100755
--- a/tests/xfs/039
+++ b/tests/xfs/039
@@ -25,6 +25,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $RMT_IRIXTAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_soft
 _do_dump -o -F
diff --git a/tests/xfs/043 b/tests/xfs/043
index 5b198dde..415ed16e 100755
--- a/tests/xfs/043
+++ b/tests/xfs/043
@@ -26,7 +26,10 @@ _cleanup()
 # real QA test starts here
 _supported_fs xfs
 
-_require_tape $TAPE_DEV 
+_require_tape $TAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 _erase_hard
 _do_dump_sub
diff --git a/tests/xfs/046 b/tests/xfs/046
index 94d1c051..48daff87 100755
--- a/tests/xfs/046
+++ b/tests/xfs/046
@@ -22,6 +22,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_symlinks
 _do_dump_file
diff --git a/tests/xfs/047 b/tests/xfs/047
index f83a2c94..6d0dc5f7 100755
--- a/tests/xfs/047
+++ b/tests/xfs/047
@@ -22,10 +22,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-
-# wipe test dir clean first
-# so dump can be real quick
-_wipe_fs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 #
 # Create 5 dumps
diff --git a/tests/xfs/055 b/tests/xfs/055
index 1e3ba6ac..c6ecae3d 100755
--- a/tests/xfs/055
+++ b/tests/xfs/055
@@ -25,6 +25,10 @@ _cleanup()
 _supported_fs xfs
 
 _require_tape $RMT_TAPE_USER@$RMT_IRIXTAPE_DEV
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
+
 _create_dumpdir_fill
 _erase_soft
 _do_dump -o -F
diff --git a/tests/xfs/056 b/tests/xfs/056
index 4ee473f6..f742f419 100755
--- a/tests/xfs/056
+++ b/tests/xfs/056
@@ -25,6 +25,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill_perm
 _do_dump_file
diff --git a/tests/xfs/059 b/tests/xfs/059
index 4bbfb5f5..515ef2a4 100755
--- a/tests/xfs/059
+++ b/tests/xfs/059
@@ -26,6 +26,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_multi_stream
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill_multi
 _do_dump_multi_file --multi 4
diff --git a/tests/xfs/060 b/tests/xfs/060
index 4b15c6c2..0c0dc981 100755
--- a/tests/xfs/060
+++ b/tests/xfs/060
@@ -26,6 +26,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_multi_stream
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill_multi
 _do_dump_multi_file --multi 4
diff --git a/tests/xfs/061 b/tests/xfs/061
index c5d4a2d1..0b20cc30 100755
--- a/tests/xfs/061
+++ b/tests/xfs/061
@@ -24,6 +24,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 # src/dumpfile based on dumping from
 # _create_dumpdir_fill_perm (small dump)
diff --git a/tests/xfs/063 b/tests/xfs/063
index 2d1d2cbc..660b300f 100755
--- a/tests/xfs/063
+++ b/tests/xfs/063
@@ -26,6 +26,9 @@ _cleanup()
 _supported_fs xfs
 
 _require_attrs trusted user
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 # create files with EAs
 _create_dumpdir_fill_ea
diff --git a/tests/xfs/064 b/tests/xfs/064
index e4e713cd..a81b226b 100755
--- a/tests/xfs/064
+++ b/tests/xfs/064
@@ -36,6 +36,9 @@ _ls_size_filter()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_hardlinks 9
 
diff --git a/tests/xfs/065 b/tests/xfs/065
index 0df7477f..8485dee6 100755
--- a/tests/xfs/065
+++ b/tests/xfs/065
@@ -70,7 +70,8 @@ _scratch_unmount
 # files and directories
 #
 
-_wipe_fs
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 mkdir -p $dump_dir || _fail "cannot mkdir \"$dump_dir\""
 cd $dump_dir
 
diff --git a/tests/xfs/066 b/tests/xfs/066
index 5f0a74e3..2c369ad7 100755
--- a/tests/xfs/066
+++ b/tests/xfs/066
@@ -24,6 +24,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs xfs
 _require_test
+_require_scratch
 
 _my_stat_filter()
 {
@@ -37,6 +38,8 @@ else
 	_notrun "Installed libc doesn't correctly handle setrlimit/ftruncate64"
 fi
 
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_largefile
 echo "ls dumpdir/largefile"
 stat $dump_dir/largefile | _my_stat_filter
diff --git a/tests/xfs/068 b/tests/xfs/068
index 103466c3..f80b53e5 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -28,6 +28,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_stress_num 4096
 
diff --git a/tests/xfs/266 b/tests/xfs/266
index 549fff3b..eeca8822 100755
--- a/tests/xfs/266
+++ b/tests/xfs/266
@@ -50,12 +50,15 @@ filter_cumulative_quota_updates() {
 
 # real QA test starts here
 _supported_fs xfs
+_require_scratch
 
 $XFSDUMP_PROG -h 2>&1 | grep -q -e -D
 if [ $? -ne 0 ]; then
     _notrun "requires xfsdump -D"
 fi
 
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 _create_dumpdir_fill
 # ensure file/dir timestamps precede dump timestamp
 sleep 2
diff --git a/tests/xfs/267 b/tests/xfs/267
index 62d39aba..89b968be 100755
--- a/tests/xfs/267
+++ b/tests/xfs/267
@@ -34,7 +34,6 @@ _create_files()
 biggg		41943040	$nobody	$nobody  777    attr1 some_text1  root
 End-of-File
 
-    _wipe_fs
     _do_create_dumpdir_fill
     _stable_fs
 }
@@ -48,6 +47,9 @@ _supported_fs xfs
 
 _require_tape $TAPE_DEV
 _require_attrs trusted
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_files
 _erase_hard
diff --git a/tests/xfs/268 b/tests/xfs/268
index b1dd312d..8c991fba 100755
--- a/tests/xfs/268
+++ b/tests/xfs/268
@@ -37,7 +37,6 @@ bigg1		12582912	$nobody	$nobody  777    attr1 some_text1  root
 bigg2		12582912	$nobody	$nobody  777    attr2 some_text2  user
 End-of-File
 
-    _wipe_fs
     _do_create_dumpdir_fill
     _stable_fs
 }
@@ -51,6 +50,9 @@ _supported_fs xfs
 
 _require_tape $TAPE_DEV
 _require_attrs trusted user
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_files
 _erase_hard
diff --git a/tests/xfs/281 b/tests/xfs/281
index ea114761..6b148a94 100755
--- a/tests/xfs/281
+++ b/tests/xfs/281
@@ -22,8 +22,10 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-
 _require_legacy_v2_format
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill
 
diff --git a/tests/xfs/282 b/tests/xfs/282
index 07a4623a..50303b08 100755
--- a/tests/xfs/282
+++ b/tests/xfs/282
@@ -24,8 +24,10 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-
 _require_legacy_v2_format
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill
 # ensure file/dir timestamps precede dump timestamp
diff --git a/tests/xfs/283 b/tests/xfs/283
index 47fd4c3a..59ea5f3b 100755
--- a/tests/xfs/283
+++ b/tests/xfs/283
@@ -24,8 +24,10 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-
 _require_legacy_v2_format
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 _create_dumpdir_fill
 # ensure file/dir timestamps precede dump timestamp
diff --git a/tests/xfs/296 b/tests/xfs/296
index 4eaf049b..efd303e2 100755
--- a/tests/xfs/296
+++ b/tests/xfs/296
@@ -28,8 +28,8 @@ _supported_fs xfs
 _require_scratch
 _require_command "$SETCAP_PROG" setcap
 _require_command "$GETCAP_PROG" getcap
-
-_wipe_fs
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 mkdir -p $dump_dir
 echo test > $dump_dir/testfile
diff --git a/tests/xfs/301 b/tests/xfs/301
index d44533d6..71ec1420 100755
--- a/tests/xfs/301
+++ b/tests/xfs/301
@@ -27,6 +27,8 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs xfs
 _require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 # Extended attributes
 attr_name=attrname
diff --git a/tests/xfs/302 b/tests/xfs/302
index 6587a6e6..2e16890c 100755
--- a/tests/xfs/302
+++ b/tests/xfs/302
@@ -26,9 +26,10 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs xfs
 _require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
 
 echo "Silence is golden."
-_wipe_fs
 mkdir $dump_dir >> $seqres.full 2>&1 || _fail "mkdir \"$dump_dir\" failed"
 for i in `seq 1 4`; do
 	$XFS_IO_PROG -f -c "truncate 1t" $dump_dir/sparsefile$i \
-- 
2.31.1

