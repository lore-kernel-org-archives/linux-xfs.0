Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F6CC43461
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 19:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E984F61181
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 19:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhDITIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 15:08:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234924AbhDITIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 15:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617995317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o9bMIINc1pAmPlRPth03J9VBbjzDd5/4ifPrJwvc630=;
        b=iK3HUckxf9HvBEKOkSuyvkv3jxFBoUJLZzTzhj/xGuSswBImaoWbP4oX6tJDkrS5ccF8GI
        3eRbfCe97TMgMVRMnuxSUGOfqrL+Auf5kBlZVIzKrRUncMtRTpYqrL/x7GoFbHxodSesJP
        heJ1oyw3H3U/TQWxhkUHzdVrYj8Ic58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220--RGCpO2jNO6KFVyrTD9uqg-1; Fri, 09 Apr 2021 15:08:36 -0400
X-MC-Unique: -RGCpO2jNO6KFVyrTD9uqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52F1D8030B5;
        Fri,  9 Apr 2021 19:08:35 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2EAC5D9C0;
        Fri,  9 Apr 2021 19:08:34 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs/502: scale file count based on AG count to avoid thrashing
Date:   Fri,  9 Apr 2021 15:08:34 -0400
Message-Id: <20210409190834.1026968-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/502 currently creates a default of 30k unlinked files per CPU.
While this completes in a reasonable amount of time on systems with
lesser numbers of CPUs, this scales poorly on high CPU count systems
that are otherwise testing smaller default filesystems. For example,
on an 80xcpu box and a 15GB (4 AG) XFS filesystem, xfs/502 requires
3 hours to complete. The same test on a 4xcpu vm (or the 80xcpu
hardware with an 80AG filesystem instead of the default of 4AGs)
completes in a little over 5 minutes. This is a rather severe
thrashing breakdown that doesn't add much value to the test
coverage.

Address this problem by scaling the file count to the AG count of
the filesystem rather than the CPU count of the test system. Since
the AG count is likely to be less than the CPU count, bump the
default scaling factor a bit from 30k per CPU to 50k per AG. From
there, larger counts can still be exercised via the global load
factor configuration.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/502 | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/502 b/tests/xfs/502
index 337ae07e..202bfbc6 100755
--- a/tests/xfs/502
+++ b/tests/xfs/502
@@ -28,6 +28,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/inject
+. ./common/filter
 
 # real QA test starts here
 _supported_fs xfs
@@ -36,15 +37,21 @@ _require_scratch
 _require_test_program "t_open_tmpfiles"
 
 rm -f $seqres.full
-_scratch_mkfs >> $seqres.full 2>&1
+
+_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs > /dev/null
+cat $tmp.mkfs >> $seqres.full
+. $tmp.mkfs
+
 _scratch_mount
 
 # Load up all the CPUs, two threads per CPU.
 nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
 
-# Set ULIMIT_NOFILE to min(file-max / $nr_cpus / 2, 30000 files per cpu per LOAD_FACTOR)
+# Set ULIMIT_NOFILE to min(file-max / $nr_cpus / 2, 50000 files per AG per LOAD_FACTOR)
 # so that this test doesn't take forever or OOM the box
-max_files=$((30000 * LOAD_FACTOR))
+max_files=$((50000 * agcount * LOAD_FACTOR))
+max_files=$((max_files / $nr_cpus))
+
 max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / $nr_cpus / 2 ))
 test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
 	max_files=$max_allowable_files
-- 
2.26.3

