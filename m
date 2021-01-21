Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C3EC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139F423A31
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387538AbhAUPuL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387537AbhAUPq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 10:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611243933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fv7jQQxjdjzToF25OI4PbimF9JtPTQ8Q8yiprj/ZhcY=;
        b=U21WL5Tbj5grfLw3jh4rTWJtJWJ6c2Lq/RE7xU3k1iT/uSxvUujxofJdHi09t6NfZlR0J6
        RP4JLVPyUd+223foH5S03MRHdI5+YPSCU8YkE+B+pr75w6zO9UcnI6qNKrIZSzf7yIxii1
        fKQobXGzj4ogkAMN+D8F2PdSAi7PeCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-HYB_7WYCNBKvmvcuIbwVnQ-1; Thu, 21 Jan 2021 10:45:30 -0500
X-MC-Unique: HYB_7WYCNBKvmvcuIbwVnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73C5451DF
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3203B46
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 5/9] xfs: don't reset log idle state on covering checkpoints
Date:   Thu, 21 Jan 2021 10:45:22 -0500
Message-Id: <20210121154526.1852176-6-bfoster@redhat.com>
In-Reply-To: <20210121154526.1852176-1-bfoster@redhat.com>
References: <20210121154526.1852176-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that log covering occurs on quiesce, we'd like to reuse the
underlying superblock sync for final superblock updates. This
includes things like lazy superblock counter updates, log feature
incompat bits in the future, etc. One quirk to this approach is that
once the log is in the IDLE (i.e. already covered) state, any
subsequent log write resets the state back to NEED. This means that
a final superblock sync to an already covered log requires two more
sb syncs to return the log back to IDLE again.

For example, if a lazy superblock enabled filesystem is mount cycled
without any modifications, the unmount path syncs the superblock
once and writes an unmount record. With the desired log quiesce
covering behavior, we sync the superblock three times at unmount
time: once for the lazy superblock counter update and twice more to
cover the log. By contrast, if the log is active or only partially
covered at unmount time, a final superblock sync would doubly serve
as the one or two remaining syncs required to cover the log.

This duplicate covering sequence is unnecessary because the
filesystem remains consistent if a crash occurs at any point. The
superblock will either be recovered in the event of a crash or
written back before the log is quiesced and potentially cleaned with
an unmount record.

Update the log covering state machine to remain in the IDLE state if
additional covering checkpoints pass through the log. This
facilitates final superblock updates (such as lazy superblock
counters) via a single sb sync without losing covered status. This
provides some consistency with the active and partially covered
cases and also avoids harmless, but spurious checkpoints when
quiescing the log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7c31b046e790..6db65a4513a6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2597,12 +2597,15 @@ xlog_covered_state(
 	int			iclogs_changed)
 {
 	/*
-	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
-	 * are done writing the dummy record.  If we are done with the second
-	 * dummy recored (DONE2), then we go to IDLE.
+	 * We go to NEED for any non-covering writes. We go to NEED2 if we just
+	 * wrote the first covering record (DONE). We go to IDLE if we just
+	 * wrote the second covering record (DONE2) and remain in IDLE until a
+	 * non-covering write occurs.
 	 */
 	switch (prev_state) {
 	case XLOG_STATE_COVER_IDLE:
+		if (iclogs_changed == 1)
+			return XLOG_STATE_COVER_IDLE;
 	case XLOG_STATE_COVER_NEED:
 	case XLOG_STATE_COVER_NEED2:
 		break;
-- 
2.26.2

