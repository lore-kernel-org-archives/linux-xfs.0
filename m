Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D86EC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ACA8214F1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:39:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtOc7RxC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHZOi4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 10:38:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20447 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726690AbgHZOiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 10:38:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598452702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NHE/nZbwiOoblJJMtTZR2g1xUXRlA7Vnz3roC9Mkkck=;
        b=OtOc7RxC1NTDu2WGmi6/kSvhF2rwElB/H0ybn131+7B6ZlzLSGI6u/DX0T6Gmi7mx5vb6n
        YpZ5EEzQL9nHB1rn8xoGHvYnkiuPH8wejkWU8yR6itxa+0FxTCUqyWUPYjkkEQMF34EDVJ
        /aLAkmNMPAJM7CR+Z4qmaGmyJXjurWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-TNWqgDd0MJ6JOm2Ac0bUdA-1; Wed, 26 Aug 2020 10:38:18 -0400
X-MC-Unique: TNWqgDd0MJ6JOm2Ac0bUdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E70B85C734;
        Wed, 26 Aug 2020 14:38:17 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C484650EB6;
        Wed, 26 Aug 2020 14:38:16 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] generic/457: use thin volume for dmlogwrites target device
Date:   Wed, 26 Aug 2020 10:38:14 -0400
Message-Id: <20200826143815.360002-4-bfoster@redhat.com>
In-Reply-To: <20200826143815.360002-1-bfoster@redhat.com>
References: <20200826143815.360002-1-bfoster@redhat.com>
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
 tests/generic/457 | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/tests/generic/457 b/tests/generic/457
index 82367304..42a064d8 100755
--- a/tests/generic/457
+++ b/tests/generic/457
@@ -16,6 +16,7 @@ status=1	# failure is the default!
 _cleanup()
 {
 	_log_writes_cleanup
+	_dmthin_cleanup
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
@@ -23,6 +24,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/filter
 . ./common/reflink
+. ./common/dmthin
 . ./common/dmlogwrites
 
 # real QA test starts here
@@ -32,6 +34,7 @@ _require_test
 _require_scratch_reflink
 _require_cp_reflink
 _require_log_writes
+_require_dm_target thin-pool
 
 rm -f $seqres.full
 
@@ -44,13 +47,12 @@ check_files()
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
 
@@ -58,8 +60,16 @@ SANITY_DIR=$TEST_DIR/fsxtests
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
 
@@ -92,14 +102,13 @@ _log_writes_mark last
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
@@ -107,8 +116,8 @@ done
 
 # Check the end
 echo "checking post umount" >> $seqres.full
-_log_writes_replay_log end $SCRATCH_DEV
-_scratch_mount
+_log_writes_replay_log end $DMTHIN_VOL_DEV
+_dmthin_mount
 for j in `seq 0 $((NUM_FILES-1))`; do
 	md5=$(_md5_checksum $SCRATCH_MNT/testfile$j)
 	[ "${md5}" != "${test_md5[$j]}" ] && _fail "testfile$j end md5sum mismatched"
-- 
2.25.4

