Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4BBC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 14:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC1E22B4B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 14:53:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ayFr2/ag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgH0Oxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:53:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22930 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726246AbgH0Oxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 10:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2zilKfYwgjMrFuSV8fWV/l7TmFQQ3eWRspySIR0VXC0=;
        b=ayFr2/agddfhII4xlLkUfT8JXMKBWRcXxrjFs+6QuoR/pOK7dkJBxUUlLo3r9eicdkB0vP
        qWHOvLCOQY6xy7cM3F3dgSBGgTWw3roEEoxJpTcel2gqiIFKeC/42lPJwGDVYF7P/xKG7A
        5u+nlQsy4PM8275k1p7bggSJ8uyOPC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-1hFCRlCsP_SLRfFghfTjsg-1; Thu, 27 Aug 2020 10:53:31 -0400
X-MC-Unique: 1hFCRlCsP_SLRfFghfTjsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8289E100CEC0;
        Thu, 27 Aug 2020 14:53:30 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29151757F2;
        Thu, 27 Aug 2020 14:53:30 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic: disable dmlogwrites tests on XFS
Date:   Thu, 27 Aug 2020 10:53:29 -0400
Message-Id: <20200827145329.435398-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Several generic fstests use dm-log-writes to test the filesystem for
consistency at various crash recovery points. dm-log-writes and the
associated replay mechanism rely on discard to clear stale blocks
when moving to various points in time of the fs. If the storage
doesn't provide discard zeroing or the discard requests exceed the
hardcoded maximum (128MB) of the fallback solution to physically
write zeroes, stale blocks are left around in the target fs. This
causes issues on XFS if recovery observes metadata from a future
version of an fs that has been replayed to an older point in time.
This corrupts the filesystem and leads to spurious test failures
that are nontrivial to diagnose.

Disable the generic dmlogwrites tests on XFS for the time being.
This is intended to be a temporary change until a solution is found
that allows these tests to predictably clear stale data while still
allowing them to run in a reasonable amount of time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Drop all dmthinp changes. Unconditionally disable tests on XFS.
v1: https://lore.kernel.org/fstests/20200826143815.360002-2-bfoster@redhat.com/

 common/dmlogwrites | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 573f4b8a..b0a28ce8 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -9,6 +9,14 @@ _require_log_writes()
 	[ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
 		_notrun "This test requires a valid \$LOGWRITES_DEV"
 
+	# The logwrites mechanism relies on discard to provide zeroing behavior
+	# to clear out stale filesystem content. Discard doesn't reliably
+	# provide this behavior, and this leads to spurious corruptions on XFS
+	# filesystems by leaving out of order metadata in the fs. We must
+	# disable dmlogwrites on XFS until it implements a predictable mechanism
+	# to clear stale data.
+	[ $FSTYP == "xfs" ] && _notrun "dmlogwrites not supported on XFS"
+
 	_exclude_scratch_mount_option dax
 	_require_dm_target log-writes
 	_require_test_program "log-writes/replay-log"
@@ -39,6 +47,8 @@ _require_log_writes_dax_mountopt()
 	[ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
 		_notrun "This test requires a valid \$LOGWRITES_DEV"
 
+	[ $FSTYP == "xfs" ] && _notrun "dmlogwrites not supported on XFS"
+
 	_require_dm_target log-writes
 	_require_test_program "log-writes/replay-log"
 
-- 
2.25.4

