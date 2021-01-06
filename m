Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC52CC43333
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD30D22CA2
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbhAFRnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:43:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727875AbhAFRnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:43:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/uacKOgARRQKUpf7KUHRWduu3wo1FGWBcMaysfFF1yA=;
        b=TKn3Fj545OFnLHtnSiCP6a2eg2mpE1m7cydp1VrvC/dCpcmACyxQs0Apna005bFY+Jg07r
        nDl0S2AQPhYnc1wh2RE1TmCDrhHbq4yA60pfYyJDTHdhOnkYLyr5ML8PZ0ELDdjdHvPtgF
        rhNIkJMS5xg8ctPZqIVGJHhnXRrn13E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-uX9PXjCvO0Odpyo9I16VBA-1; Wed, 06 Jan 2021 12:41:32 -0500
X-MC-Unique: uX9PXjCvO0Odpyo9I16VBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A264B800D55
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:31 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6311819635
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:31 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: remove xfs_quiesce_attr()
Date:   Wed,  6 Jan 2021 12:41:26 -0500
Message-Id: <20210106174127.805660-9-bfoster@redhat.com>
In-Reply-To: <20210106174127.805660-1-bfoster@redhat.com>
References: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_quiesce_attr() is now a wrapper for xfs_log_clean(). Remove it
and call xfs_log_clean() directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c |  2 +-
 fs/xfs/xfs_super.c | 24 ++----------------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f97b82d0e30f..4a26b48b18e4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -946,7 +946,7 @@ xfs_mountfs(
 	 */
 	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
 							XFS_MOUNT_RDONLY) {
-		xfs_quiesce_attr(mp);
+		xfs_log_clean(mp);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8fc9044131fc..aedf622d221b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -867,26 +867,6 @@ xfs_restore_resvblks(struct xfs_mount *mp)
 	xfs_reserve_blocks(mp, &resblks, NULL);
 }
 
-/*
- * Trigger writeback of all the dirty metadata in the file system.
- *
- * This ensures that the metadata is written to their location on disk rather
- * than just existing in transactions in the log. This means after a quiesce
- * there is no log replay required to write the inodes to disk - this is the
- * primary difference between a sync and a quiesce.
- *
- * We cancel log work early here to ensure all transactions the log worker may
- * run have finished before we clean up and log the superblock and write an
- * unmount record. The unfreeze process is responsible for restarting the log
- * worker correctly.
- */
-void
-xfs_quiesce_attr(
-	struct xfs_mount	*mp)
-{
-	xfs_log_clean(mp);
-}
-
 /*
  * Second stage of a freeze. The data is already frozen so we only
  * need to take care of the metadata. Once that's done sync the superblock
@@ -909,7 +889,7 @@ xfs_fs_freeze(
 	flags = memalloc_nofs_save();
 	xfs_stop_block_reaping(mp);
 	xfs_save_resvblks(mp);
-	xfs_quiesce_attr(mp);
+	xfs_log_clean(mp);
 	ret = xfs_sync_sb(mp, true);
 	memalloc_nofs_restore(flags);
 	return ret;
@@ -1752,7 +1732,7 @@ xfs_remount_ro(
 	 */
 	xfs_save_resvblks(mp);
 
-	xfs_quiesce_attr(mp);
+	xfs_log_clean(mp);
 	mp->m_flags |= XFS_MOUNT_RDONLY;
 
 	return 0;
-- 
2.26.2

