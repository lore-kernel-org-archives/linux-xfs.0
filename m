Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C734C6FA82
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 21:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiI1VMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 17:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiI1VM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 17:12:28 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B77910B226;
        Wed, 28 Sep 2022 14:07:17 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id h28so8712951qka.0;
        Wed, 28 Sep 2022 14:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ooZR2YU2nQ8lFMMYZZVjgeUFJelu6/7ApndiUdTsin0=;
        b=L2AobJtj7kVtE6b2CFAs5tCB6if4KuHbDXAjLaLGEM+kJXGdY9L+y9XgnyBoB0MNh+
         xsz4wwM4D3ANhfQchsWX5/nkhD1mHiTsUMEfzyrnIILYlKmsFCB8sprqXRakad2FXC+R
         4tdZ48vq0mMVrVk+H+AupdL3gHj8oIz1SR8EKiXWEMfxDqcQxSgItnZTnp+j/vQZaTnS
         6Zjc9kN5UAS9ykyuvQVNshm8EL8YHNWBjenzzNOEuKVsmv5wIfMTv9wfcqeFKogLK/vO
         or278T+LExsWWfu1U4B9t7JUb8DlrkrVNZUxtTbZkPpbaaw8xGqn9qhxnlEnclBcDhVe
         V00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ooZR2YU2nQ8lFMMYZZVjgeUFJelu6/7ApndiUdTsin0=;
        b=tDePWgCQZObSAn7NBQFlE+sf8g+KqNN6febE2WSEntnqweUariHZCsfEbwVC6FuRt2
         0T8q5k/OrDBcaO63fjyoHuKuydzW8FxEGBosa/1i3LknrSCEsgQaY4jO/fRSUXFbXGep
         uYiRl0S+uUOkFN3O5v51aTPHNtZ+pNPv+okQLeoD4GscCgGeFqYBHsRe4ep7Vd+ZmQbW
         B7s1liRTCZ6FJauZ+FzV5QmtjOZvd0+kpLP21dTpK5kdCGiBE6o6NdJfgXkmaEg0x6iG
         fLRhu215+jvRCCrgNuGdUi0TfL3lkzrnsgHFaevrdEZRRyJHRNKXEYfHMQTTdaQLEITJ
         IlfQ==
X-Gm-Message-State: ACrzQf1V+4KLwodzZVx1OCiRYjP5Kdd3dVzKOl9qblX3k/eZsP6sUfq3
        RJYVpfF9Km1tZcmJhuKhWx+QAHzMzqga3mgl
X-Google-Smtp-Source: AMsMyM5WJ9T0H4NRCGydJVVF3volXE2A9lG/ekllG4xXXc8e9jJOWqHzBHbjkLaOyGreSTfUDE54/w==
X-Received: by 2002:a37:f71c:0:b0:6ce:e3f7:4438 with SMTP id q28-20020a37f71c000000b006cee3f74438mr23261501qkj.453.1664399151231;
        Wed, 28 Sep 2022 14:05:51 -0700 (PDT)
Received: from shiina-laptop.redhat.com ([2601:18f:801:e210:abfc:537a:d62c:c353])
        by smtp.gmail.com with ESMTPSA id ay33-20020a05620a17a100b006cf43968db6sm3962275qkb.76.2022.09.28.14.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 14:05:50 -0700 (PDT)
From:   Hironori Shiina <shiina.hironori@gmail.com>
X-Google-Original-From: Hironori Shiina <shiina.hironori@fujitsu.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: [RFC PATCH] xfs: test for fixing wrong root inode number
Date:   Wed, 28 Sep 2022 17:03:37 -0400
Message-Id: <20220928210337.417054-1-shiina.hironori@fujitsu.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test '-x' option of xfsrestore. With this option, a wrong root inode
number is corrected. A root inode number can be wrong in a dump created
by problematic xfsdump (v3.1.7 - v3.1.9) with blukstat misuse. This
patch adds a dump with a wrong inode number created by xfsdump 3.1.8.

Link: https://lore.kernel.org/linux-xfs/20201113125127.966243-1-hsiangkao@redhat.com/
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
---
 common/dump                    |   2 +-
 src/root-inode-broken-dumpfile | Bin 0 -> 21648 bytes
 tests/xfs/554                  |  37 +++++++++++++++++++++
 tests/xfs/554.out              |  57 +++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 src/root-inode-broken-dumpfile
 create mode 100644 tests/xfs/554
 create mode 100644 tests/xfs/554.out

diff --git a/common/dump b/common/dump
index 8e0446d9..50b2ba03 100644
--- a/common/dump
+++ b/common/dump
@@ -1003,7 +1003,7 @@ _parse_restore_args()
         --no-check-quota)
             do_quota_check=false
             ;;
-	-K|-R)
+	-K|-R|-x)
 	    restore_args="$restore_args $1"
             ;;
 	*)
diff --git a/src/root-inode-broken-dumpfile b/src/root-inode-broken-dumpfile
new file mode 100644
index 0000000000000000000000000000000000000000..9a42e65d8047497be31f3abbaf4223ae384fd14d
GIT binary patch
literal 21648
zcmeI)K}ge49KiAC_J<CEBr!0AwBf~zbCHB}5DyxL6eU8Jnqylvayj;2VuG+d)TN6;
z5J8vlAaw9hXi(UousT$Sin@BRJfwHM)O+*2*njz_zc+h*ckuV#@BMuKe;;JbgTL{<
z!SwZ9zC#ERe%reLe5&cz2e}qM<!i2dXQHt^{^`d1Qx{)MMzW#$%dR@J={0`IRsGx4
z(yn@Oi-nBqCOVIG?&{kpwnv~&w_>6_ozY1^fph=w8(=^oTg&wOe=(WQByyQ_Hfd|4
z^o76<0!zn#v>k3blbU)nzx=KF^}-G%R;OaQYsHwGDkO`kD^@q^(_Ac_8H<gKj^>a0
z6p*%BK>q#b>2EE%^!@f?Z`-p+tI@M}qmMm@zMJk>K1U^=d~G^NUG?X4vkvKtOf-3Y
zpVM9YgM9Y7{*P0ApJNUh^uk1wCnA6V0tg_000IagfB*srAb<b@2q1s}0tg_000Iag
zfB*srAb<b@2q1s}0tg_000IagfB*srAb<b@2q1s}0tg_000IagfB*srAb`MM1p>_h
z2-R=Q9ooK1{l9<Dy8IIMUVXr9BW9uI1x7};j+kij|5kLI^32no;n|PvqD74ZOlJ#n
z0-~CKSlx#liMS>jt232#==00xPqwp;gsZrjc?`PPxaCE~>3(^o5-%+Nj=HegJFK2b
z=l5zT4IDgO=sJ1zp=jyrALvcQJK|j;sN2_jUmobjN<!S6m1{G<LZ^+JP;T!|3{9)w
eGf&ioo}iw|li2&4IyG;z<}vrl)Mic2`t2{52##q0

literal 0
HcmV?d00001

diff --git a/tests/xfs/554 b/tests/xfs/554
new file mode 100644
index 00000000..13bc62c7
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
+#
+# FS QA Test No. 554
+#
+# Test restoring a dumpfile with a wrong root inode number created by
+# xfsdump 3.1.8.
+# This test restores the checked-in broken dump with '-x' flag.
+#
+
+. ./common/preamble
+_begin_fstest auto quick dump
+
+# Import common functions.
+. ./common/dump
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
+_scratch_mount
+
+# Create dumpdir for comparing with restoredir
+rm -rf $dump_dir
+mkdir $dump_dir || _fail "failed to mkdir $restore_dir"
+touch $dump_dir/FILE_1019
+
+_do_restore_toc -x -f $here/src/root-inode-broken-dumpfile
+
+_do_restore_file -x -f $here/src/root-inode-broken-dumpfile -L stress_545
+_diff_compare_sub
+_ls_nodate_compare_sub
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/554.out b/tests/xfs/554.out
new file mode 100644
index 00000000..40a3f3a4
--- /dev/null
+++ b/tests/xfs/554.out
@@ -0,0 +1,57 @@
+QA output created by 554
+Contents of dump ...
+xfsrestore  -x -f DUMP_FILE -t
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: searching media for dump
+xfsrestore: examining media file 0
+xfsrestore: dump description: 
+xfsrestore: hostname: xfsdump
+xfsrestore: mount point: SCRATCH_MNT
+xfsrestore: volume: SCRATCH_DEV
+xfsrestore: session time: TIME
+xfsrestore: level: 0
+xfsrestore: session label: "stress_545"
+xfsrestore: media label: "stress_tape_media"
+xfsrestore: file system ID: ID
+xfsrestore: session id: ID
+xfsrestore: media ID: ID
+xfsrestore: searching media for directory dump
+xfsrestore: reading directories
+xfsrestore: found fake rootino #128, will fix.
+xfsrestore: fix root # to 1024 (bind mount?)
+xfsrestore: 2 directories and 2 entries processed
+xfsrestore: directory post-processing
+xfsrestore: reading non-directory files
+xfsrestore: table of contents display complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+
+dumpdir/FILE_1019
+Restoring from file...
+xfsrestore  -x -f DUMP_FILE  -L stress_545 RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: searching media for dump
+xfsrestore: examining media file 0
+xfsrestore: found dump matching specified label:
+xfsrestore: hostname: xfsdump
+xfsrestore: mount point: SCRATCH_MNT
+xfsrestore: volume: SCRATCH_DEV
+xfsrestore: session time: TIME
+xfsrestore: level: 0
+xfsrestore: session label: "stress_545"
+xfsrestore: media label: "stress_tape_media"
+xfsrestore: file system ID: ID
+xfsrestore: session id: ID
+xfsrestore: media ID: ID
+xfsrestore: searching media for directory dump
+xfsrestore: reading directories
+xfsrestore: found fake rootino #128, will fix.
+xfsrestore: fix root # to 1024 (bind mount?)
+xfsrestore: 2 directories and 2 entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+Comparing dump directory with restore directory
+Files DUMP_DIR/FILE_1019 and RESTORE_DIR/DUMP_SUBDIR/FILE_1019 are identical
+Comparing listing of dump directory with restore directory
+Files TMP.dump_dir and TMP.restore_dir are identical
-- 
2.37.3

