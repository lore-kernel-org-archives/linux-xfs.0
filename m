Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FDDC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D9022C9F
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbhAUPu2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:50:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387525AbhAUPq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 10:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611243931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fFYYArRQ7zRGjgF5XCb4/AnkSM2O+auYOKo/MdsqwRU=;
        b=VcdZ8K81IvGOYaKus/DtuD4q6b0B8p7Udj7faIILu1otzG0gCv+kb6VMVLChO+StMEqqEN
        RGI1i3ToaT4Qq8e0y8B4qvy2uI/5Ne9oBVJkJ0qj0PS2TtStczNK13D4fa2/M62kQIXklO
        d//kFNLxIHkKSX6KN6DflVWJg4U5xNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108--kvHrUXdNq6EYY-Brmuk2w-1; Thu, 21 Jan 2021 10:45:29 -0500
X-MC-Unique: -kvHrUXdNq6EYY-Brmuk2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42CAA107ACE4
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:28 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 062CB1A3D8
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:27 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/9] xfs: lift writable fs check up into log worker task
Date:   Thu, 21 Jan 2021 10:45:19 -0500
Message-Id: <20210121154526.1852176-3-bfoster@redhat.com>
In-Reply-To: <20210121154526.1852176-1-bfoster@redhat.com>
References: <20210121154526.1852176-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The log covering helper checks whether the filesystem is writable to
determine whether to cover the log. The helper is currently only
called from the background log worker. In preparation to reuse the
helper from freezing contexts, lift the check into xfs_log_worker().

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b445e63cbc3c..7280d99aa19c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1049,14 +1049,12 @@ xfs_log_space_wake(
  * there's no point in running a dummy transaction at this point because we
  * can't start trying to idle the log until both the CIL and AIL are empty.
  */
-static int
-xfs_log_need_covered(xfs_mount_t *mp)
+static bool
+xfs_log_need_covered(
+	struct xfs_mount	*mp)
 {
-	struct xlog	*log = mp->m_log;
-	int		needed = 0;
-
-	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
-		return 0;
+	struct xlog		*log = mp->m_log;
+	bool			needed = false;
 
 	if (!xlog_cil_empty(log))
 		return 0;
@@ -1074,14 +1072,14 @@ xfs_log_need_covered(xfs_mount_t *mp)
 		if (!xlog_iclogs_empty(log))
 			break;
 
-		needed = 1;
+		needed = true;
 		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
 			log->l_covered_state = XLOG_STATE_COVER_DONE;
 		else
 			log->l_covered_state = XLOG_STATE_COVER_DONE2;
 		break;
 	default:
-		needed = 1;
+		needed = true;
 		break;
 	}
 	spin_unlock(&log->l_icloglock);
@@ -1271,7 +1269,7 @@ xfs_log_worker(
 	struct xfs_mount	*mp = log->l_mp;
 
 	/* dgc: errors ignored - not fatal and nowhere to report them */
-	if (xfs_log_need_covered(mp)) {
+	if (xfs_fs_writable(mp, SB_FREEZE_WRITE) && xfs_log_need_covered(mp)) {
 		/*
 		 * Dump a transaction into the log that contains no real change.
 		 * This is needed to stamp the current tail LSN into the log
-- 
2.26.2

