Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99875C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9F2206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XdMdYVkm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgIANrr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 09:47:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728252AbgIANrn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 09:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598968051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAjoWMEzpDcrIGtK3T9GxKod+8xS53mLbcVkLV2jYWg=;
        b=XdMdYVkmeQXEXK/9zVetiZWvNQy5mDKKcdRMHNqrXjG1H+WNe0LhSbjOeZywr66AlyHN4e
        dK+gToyy8bYK3EzbYfJHreGMscHAPjzQ4yLyZFd9CxoNKjZwtnPuJIEaYxqihBH4MaLG6c
        jBUs1H8m3Ru3eG8+r+tthudbUBz+brE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-KLO1mvKHO4m0x091pbNtqg-1; Tue, 01 Sep 2020 09:47:30 -0400
X-MC-Unique: KLO1mvKHO4m0x091pbNtqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5965D80F054;
        Tue,  1 Sep 2020 13:47:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0877D18B59;
        Tue,  1 Sep 2020 13:47:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/3] generic/455: use thin volume for dmlogwrites target device
Date:   Tue,  1 Sep 2020 09:47:26 -0400
Message-Id: <20200901134728.185353-2-bfoster@redhat.com>
In-Reply-To: <20200901134728.185353-1-bfoster@redhat.com>
References: <20200901134728.185353-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

dmlogwrites support for XFS depends on discard zeroing support of
the intended target device. Update the test to use a thin volume and
allow it to run consistently and reliably on XFS.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/455 | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/tests/generic/455 b/tests/generic/455
index 05621220..72a44fda 100755
--- a/tests/generic/455
+++ b/tests/generic/455
@@ -16,12 +16,14 @@ status=1	# failure is the default!
 _cleanup()
 {
 	_log_writes_cleanup
+	_dmthin_cleanup
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/dmthin
 . ./common/dmlogwrites
 
 # real QA test starts here
@@ -30,6 +32,7 @@ _supported_os Linux
 _require_test
 _require_scratch_nocheck
 _require_log_writes
+_require_dm_target thin-pool
 
 rm -f $seqres.full
 
@@ -42,13 +45,12 @@ check_files()
 		local filename=$(basename $i)
 		local mark="${filename##*.}"
 		echo "checking $filename" >> $seqres.full
-		_log_writes_replay_log $filename $SCRATCH_DEV
-		_scratch_mount
+		_log_writes_replay_log $filename $DMTHIN_VOL_DEV
+		_dmthin_mount
 		local expected_md5=$(_md5_checksum $i)
 		local md5=$(_md5_checksum $SCRATCH_MNT/$name)
 		[ "${md5}" != "${expected_md5}" ] && _fail "$filename md5sum mismatched"
-		_scratch_unmount
-		_check_scratch_fs
+		_dmthin_check_fs
 	done
 }
 
@@ -56,8 +58,16 @@ SANITY_DIR=$TEST_DIR/fsxtests
 rm -rf $SANITY_DIR
 mkdir $SANITY_DIR
 
+devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
+csize=$((1024*64 / 512))                # 64k cluster size
+lowspace=$((1024*1024 / 512))           # 1m low space threshold
+
+# Use a thin device to provide deterministic discard behavior. Discards are used
+# by the log replay tool for fast zeroing to prevent out-of-order replay issues.
+_dmthin_init $devsize $devsize $csize $lowspace
+
 # Create the log
-_log_writes_init $SCRATCH_DEV
+_log_writes_init $DMTHIN_VOL_DEV
 
 _log_writes_mkfs >> $seqres.full 2>&1
 
@@ -88,14 +98,13 @@ _log_writes_mark last
 _log_writes_unmount
 _log_writes_mark end
 _log_writes_remove
-_check_scratch_fs
+_dmthin_check_fs
 
 # check pre umount
 echo "checking pre umount" >> $seqres.full
-_log_writes_replay_log last $SCRATCH_DEV
-_scratch_mount
-_scratch_unmount
-_check_scratch_fs
+_log_writes_replay_log last $DMTHIN_VOL_DEV
+_dmthin_mount
+_dmthin_check_fs
 
 for j in `seq 0 $((NUM_FILES-1))`; do
 	check_files testfile$j
@@ -103,14 +112,13 @@ done
 
 # Check the end
 echo "checking post umount" >> $seqres.full
-_log_writes_replay_log end $SCRATCH_DEV
-_scratch_mount
+_log_writes_replay_log end $DMTHIN_VOL_DEV
+_dmthin_mount
 for j in `seq 0 $((NUM_FILES-1))`; do
 	md5=$(_md5_checksum $SCRATCH_MNT/testfile$j)
 	[ "${md5}" != "${test_md5[$j]}" ] && _fail "testfile$j end md5sum mismatched"
 done
-_scratch_unmount
-_check_scratch_fs
+_dmthin_check_fs
 
 echo "Silence is golden"
 status=0
-- 
2.25.4

