Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F2DC433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A92214F1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PEh7ygZk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgHZOjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 10:39:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726875AbgHZOiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 10:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598452700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwdT6pP1ARAoldejuDU7IXe458pacNeduh1UlLpGpgA=;
        b=PEh7ygZkT+E09Ia34tyDLtJVzAKBzeJr7NS37KMJnXGX76lKXw86JDwIkyYovGQ6+rqLPz
        LH3fhi7Z/bfDjZzetz8xNw0dYzCKmi/x2m+OpelWTSPTNudzyqFnFwsd8jYOMzuEq1WJmY
        RFX9xEz6Cryo+2HW1ItM7ar9OQY67Ls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-R0V3_sMiMayfK_ZqWHjSsQ-1; Wed, 26 Aug 2020 10:38:18 -0400
X-MC-Unique: R0V3_sMiMayfK_ZqWHjSsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F69D81F02A;
        Wed, 26 Aug 2020 14:38:17 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4019150EB6;
        Wed, 26 Aug 2020 14:38:17 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] generic/470: use thin volume for dmlogwrites target device
Date:   Wed, 26 Aug 2020 10:38:15 -0400
Message-Id: <20200826143815.360002-5-bfoster@redhat.com>
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
 tests/generic/470 | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/tests/generic/470 b/tests/generic/470
index 707b6237..cb7ab484 100755
--- a/tests/generic/470
+++ b/tests/generic/470
@@ -20,12 +20,14 @@ _cleanup()
 {
 	cd /
 	_log_writes_cleanup
+	_dmthin_cleanup
 	rm -f $tmp.*
 }
 
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/dmthin
 . ./common/dmlogwrites
 
 # remove previous $seqres.full before test
@@ -35,11 +37,21 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os Linux
 _require_scratch
-_require_log_writes_dax_mountopt $SCRATCH_DEV "dax"
+_require_dm_target thin-pool
 _require_xfs_io_command "mmap" "-S"
 _require_xfs_io_command "log_writes"
 
-_log_writes_init $SCRATCH_DEV
+devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
+csize=$((1024*64 / 512))                # 64k cluster size
+lowspace=$((1024*1024 / 512))           # 1m low space threshold
+
+# Use a thin device to provide deterministic discard behavior. Discards are used
+# by the log replay tool for fast zeroing to prevent out-of-order replay issues.
+_dmthin_init $devsize $devsize $csize $lowspace
+
+_require_log_writes_dax_mountopt $DMTHIN_VOL_DEV "dax"
+
+_log_writes_init $DMTHIN_VOL_DEV
 _log_writes_mkfs >> $seqres.full 2>&1
 _log_writes_mount -o dax
 
@@ -52,14 +64,14 @@ $XFS_IO_PROG -t -c "truncate $LEN" -c "mmap -S 0 $LEN" -c "mwrite 0 $LEN" \
 # Unmount the scratch dir and tear down the log writes target
 _log_writes_unmount
 _log_writes_remove
-_check_scratch_fs
+_dmthin_check_fs
 
 # destroy previous filesystem so we can be sure our rebuild works
-_scratch_mkfs >> $seqres.full 2>&1
+_mkfs_dev $DMTHIN_VOL_DEV >> $seqres.full 2>&1
 
 # check pre-unmap state
-_log_writes_replay_log preunmap $SCRATCH_DEV
-_scratch_mount
+_log_writes_replay_log preunmap $DMTHIN_VOL_DEV
+_dmthin_mount
 
 # We should see $SCRATCH_MNT/test as having 1 MiB in block allocations
 du -sh $SCRATCH_MNT/test | _filter_scratch | _filter_spaces
-- 
2.25.4

