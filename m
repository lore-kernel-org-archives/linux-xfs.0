Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B15C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF82022CAF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbhAFRoC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:44:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727905AbhAFRnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:43:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSsPTF3UejAgkX4BWlxAdnPiK8QOL7CoO6EvpTCObN0=;
        b=LmdPooqp0qO23yQlqs/vfGBm8wtcTLoJIosevPsZC5nAafVjzcdmvtPqmZPh/T6OcaYj7u
        CAK3cDVAE02qHXxZMlBvJWIAkWZdwhsfh2r1dbRWFmszvV1SEG888jSLz4/7bZ7LjiLJIx
        FcC4B3nXWKTmmdBFIjWrG/1vjQVvls0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-6-q88f3LNKCXJhOoHJFb8Q-1; Wed, 06 Jan 2021 12:41:35 -0500
X-MC-Unique: 6-q88f3LNKCXJhOoHJFb8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFD7918C8C02
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:34 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7195318A9D
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: separate log cleaning from log quiesce
Date:   Wed,  6 Jan 2021 12:41:21 -0500
Message-Id: <20210106174127.805660-4-bfoster@redhat.com>
In-Reply-To: <20210106174127.805660-1-bfoster@redhat.com>
References: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Log quiesce is currently associated with cleaning the log, which is
accomplished by writing an unmount record as the last step of the
quiesce sequence. The quiesce codepath is a bit convoluted in this
regard due to how it is reused from various contexts. In preparation
to create separate log cleaning and log covering interfaces, lift
the write of the unmount record into a new cleaning helper and call
that wherever xfs_log_quiesce() is currently invoked. No functional
changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c   | 8 +++++++-
 fs/xfs/xfs_log.h   | 1 +
 fs/xfs/xfs_super.c | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4137ed007111..1b3227a033ad 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -957,7 +957,13 @@ xfs_log_quiesce(
 	xfs_wait_buftarg(mp->m_ddev_targp);
 	xfs_buf_lock(mp->m_sb_bp);
 	xfs_buf_unlock(mp->m_sb_bp);
+}
 
+void
+xfs_log_clean(
+	struct xfs_mount	*mp)
+{
+	xfs_log_quiesce(mp);
 	xfs_log_unmount_write(mp);
 }
 
@@ -972,7 +978,7 @@ void
 xfs_log_unmount(
 	struct xfs_mount	*mp)
 {
-	xfs_log_quiesce(mp);
+	xfs_log_clean(mp);
 
 	xfs_trans_ail_destroy(mp);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 98c913da7587..b0400589f824 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -139,6 +139,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
 void	xfs_log_quiesce(struct xfs_mount *mp);
+void	xfs_log_clean(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 bool	xfs_log_in_recovery(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 813be879a5e5..09d956e30fd8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -897,7 +897,7 @@ xfs_quiesce_attr(
 	if (error)
 		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
 				"Frozen image may not be consistent.");
-	xfs_log_quiesce(mp);
+	xfs_log_clean(mp);
 }
 
 /*
-- 
2.26.2

