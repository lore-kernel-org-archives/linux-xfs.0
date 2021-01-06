Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C8AC43381
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BEF023136
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbhAFRnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:43:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727871AbhAFRm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0GvIwI2Qor+1fNDBqwTpxElA87sFRuBnPSYcewZ6CTs=;
        b=bGV6hxC3Wq+imDSekwwm1gDQA6uezHpyhWrlzNBLWfBm10JdP7DGyUZjIRXZMKV65njSjy
        d3+/5T3tyqQ+ZU/5MmqOOStCOkjLwOXO+MJ1W1nOygqKDAhFgzoitDiQ1afy5sIk8WEw/8
        d5GJyzVhONKdolmAyMQdfnGz8sw5Ke0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-t5tJQOIOMeeKAmDT_VDcRA-1; Wed, 06 Jan 2021 12:41:31 -0500
X-MC-Unique: t5tJQOIOMeeKAmDT_VDcRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1820618C8C03
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:30 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D085619635
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: cover the log during log quiesce
Date:   Wed,  6 Jan 2021 12:41:22 -0500
Message-Id: <20210106174127.805660-5-bfoster@redhat.com>
In-Reply-To: <20210106174127.805660-1-bfoster@redhat.com>
References: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The log quiesce mechanism historically terminates by marking the log
clean with an unmount record. The primary objective is to indicate
that log recovery is no longer required after the quiesce has
flushed all in-core changes and written back filesystem metadata.
While this is perfectly fine, it is somewhat hacky as currently used
in certain contexts. For example, filesystem freeze quiesces (i.e.
cleans) the log and immediately redirties it with a dummy superblock
transaction to ensure that log recovery runs in the event of a
crash.

While this functions correctly, cleaning the log from freeze context
is clearly superfluous given the current redirtying behavior.
Instead, the desired behavior can be achieved by simply covering the
log. This effectively retires all on-disk log items from the active
range of the log by issuing two synchronous and sequential dummy
superblock update transactions that serve to update the on-disk log
head and tail. The subtle difference is that the log technically
remains dirty due to the lack of an unmount record, though recovery
is effectively a no-op due to the content of the checkpoints being
clean (i.e. the unmodified on-disk superblock).

Log covering currently runs in the background and only triggers once
the filesystem and log has idled. The purpose of the background
mechanism is to prevent log recovery from replaying the most
recently logged items long after those items may have been written
back. In the quiesce path, the log has been deliberately idled by
forcing the log and pushing the AIL until empty in a context where
no further mutable filesystem operations are allowed. Therefore, we
can cover the log as the final step in the log quiesce codepath to
reflect that all previously active items have been successfully
written back.

This facilitates selective log covering from certain contexts (i.e.
freeze) that only seek to quiesce, but not necessarily clean the
log. Note that as a side effect of this change, log covering now
occurs when cleaning the log as well. This is harmless, facilitates
subsequent cleanups, and is mostly temporary as various operations
switch to use explicit log covering.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 49 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_log.h |  2 +-
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1b3227a033ad..f7b23044723d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -91,6 +91,9 @@ STATIC int
 xlog_iclogs_empty(
 	struct xlog		*log);
 
+static int
+xfs_log_cover(struct xfs_mount *);
+
 static void
 xlog_grant_sub_space(
 	struct xlog		*log,
@@ -936,10 +939,9 @@ xfs_log_unmount_write(
  * To do this, we first need to shut down the background log work so it is not
  * trying to cover the log as we clean up. We then need to unpin all objects in
  * the log so we can then flush them out. Once they have completed their IO and
- * run the callbacks removing themselves from the AIL, we can write the unmount
- * record.
+ * run the callbacks removing themselves from the AIL, we can cover the log.
  */
-void
+int
 xfs_log_quiesce(
 	struct xfs_mount	*mp)
 {
@@ -957,6 +959,8 @@ xfs_log_quiesce(
 	xfs_wait_buftarg(mp->m_ddev_targp);
 	xfs_buf_lock(mp->m_sb_bp);
 	xfs_buf_unlock(mp->m_sb_bp);
+
+	return xfs_log_cover(mp);
 }
 
 void
@@ -1092,6 +1096,45 @@ xfs_log_need_covered(
 	return needed;
 }
 
+/*
+ * Explicitly cover the log. This is similar to background log covering but
+ * intended for usage in quiesce codepaths. The caller is responsible to ensure
+ * the log is idle and suitable for covering. The CIL, iclog buffers and AIL
+ * must all be empty.
+ */
+static int
+xfs_log_cover(
+	struct xfs_mount	*mp)
+{
+	struct xlog		*log = mp->m_log;
+	int			error = 0;
+
+	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
+	        !xfs_ail_min_lsn(log->l_ailp)) ||
+	       XFS_FORCED_SHUTDOWN(mp));
+
+	if (!xfs_log_writable(mp))
+		return 0;
+
+	/*
+	 * To cover the log, commit the superblock twice (at most) in
+	 * independent checkpoints. The first serves as a reference for the
+	 * tail pointer. The sync transaction and AIL push empties the AIL and
+	 * updates the in-core tail to the LSN of the first checkpoint. The
+	 * second commit updates the on-disk tail with the in-core LSN,
+	 * covering the log. Push the AIL one more time to leave it empty, as
+	 * we found it.
+	 */
+	while (xfs_log_need_covered(mp)) {
+		error = xfs_sync_sb(mp, true);
+		if (error)
+			break;
+		xfs_ail_push_all_sync(mp->m_ail);
+	}
+
+	return error;
+}
+
 /*
  * We may be holding the log iclog lock upon entering this routine.
  */
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b0400589f824..044e02cb8921 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -138,7 +138,7 @@ void	xlog_cil_process_committed(struct list_head *list);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
-void	xfs_log_quiesce(struct xfs_mount *mp);
+int	xfs_log_quiesce(struct xfs_mount *mp);
 void	xfs_log_clean(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 bool	xfs_log_in_recovery(struct xfs_mount *);
-- 
2.26.2

