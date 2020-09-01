Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22144C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC68207D3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZCJv3YF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgIANrz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 09:47:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728261AbgIANrq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 09:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598968053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qgv/eZdubjSdzyFtA36yZA5ZIJFNBvPlf+GhEC11yX0=;
        b=JZCJv3YFHmlWBpDs35O0EuAjcqWAh9XDVyXq3a3nv7rJB0PzvuEz6tfn7pPULc9Dt8DB+p
        q6teUpKhL5If9zd/kItVe6mriKSbOAnKCtzKKfm2LbHEu/x412eWYoieoin4KbFBOMmyug
        wtbQO/JotRtCO4haRc0XdiSbFaGd8HE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-SvFhGqkIPRi2GJhX7PrrkQ-1; Tue, 01 Sep 2020 09:47:31 -0400
X-MC-Unique: SvFhGqkIPRi2GJhX7PrrkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B43D10ABDB7;
        Tue,  1 Sep 2020 13:47:30 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED0EE18B59;
        Tue,  1 Sep 2020 13:47:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/3] generic/470: use thin volume for dmlogwrites target device
Date:   Tue,  1 Sep 2020 09:47:28 -0400
Message-Id: <20200901134728.185353-4-bfoster@redhat.com>
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
 tests/generic/470 | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tests/generic/470 b/tests/generic/470
index fd6da563..c77499a2 100755
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
@@ -34,12 +36,21 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
-_require_scratch
+_require_scratch_nocheck
 _require_log_writes_dax_mountopt "dax"
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
+_log_writes_init $DMTHIN_VOL_DEV
 _log_writes_mkfs >> $seqres.full 2>&1
 _log_writes_mount -o dax
 
@@ -52,14 +63,14 @@ $XFS_IO_PROG -t -c "truncate $LEN" -c "mmap -S 0 $LEN" -c "mwrite 0 $LEN" \
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

