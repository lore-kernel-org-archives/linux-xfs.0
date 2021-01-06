Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816FDC4332B
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637C523133
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbhAFRnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:43:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727205AbhAFRm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Q8UCL7XRaedMaQwrNPNwz6Urb6yL5+2LCXx/qBc+o8=;
        b=LpG+4F/yvOZblMXTbqMyjXb7kT748RuLJE2FzVy6de7waogvTfaC5/gZ+Y+HiJS2DIcVa4
        NEMaKAGabkxYI3Yk8x5P7gDUyTEdyKtxlPqizV462EqriXtXKTjT339wEslwhbX8c8cBBr
        +0h1HDqKVeHagVRNynCKdPaU0tjwYng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-6dJLWwpOMVm8wccS0ocueA-1; Wed, 06 Jan 2021 12:41:31 -0500
X-MC-Unique: 6dJLWwpOMVm8wccS0ocueA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7688E107ACF6
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:30 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A8E719635
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:30 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: don't reset log idle state on covering checkpoints
Date:   Wed,  6 Jan 2021 12:41:23 -0500
Message-Id: <20210106174127.805660-6-bfoster@redhat.com>
In-Reply-To: <20210106174127.805660-1-bfoster@redhat.com>
References: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
---
 fs/xfs/xfs_log.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f7b23044723d..9b8564f280b7 100644
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

