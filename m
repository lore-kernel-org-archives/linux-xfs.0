Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A48C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB6322CA2
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbhAFRm6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:42:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727612AbhAFRm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5uRh8ZnAK8DU4OwTrk3pl1V2M1XyupEIY9AH6DzF/4=;
        b=gSJa1RfVUm0i4FG/qXKlSWP0KaNZTVN41GsDjvjaL7pac6DS87zVDdKTDuEwtrS8i8YX28
        veHekkmo4MYJLeYqqE8M20/nTXMS4qFDHjTjwIQHoD6j2rGhp4VgJb0qazLV9J3uqWPONJ
        cBwN5IPuTixVvN0Fid1+cbgNDazjUpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-VxXF5VUXMU26PmfTpE9O0Q-1; Wed, 06 Jan 2021 12:41:30 -0500
X-MC-Unique: VxXF5VUXMU26PmfTpE9O0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2847B10054FF
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF41D19801
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: lift writable fs check up into log worker task
Date:   Wed,  6 Jan 2021 12:41:20 -0500
Message-Id: <20210106174127.805660-3-bfoster@redhat.com>
In-Reply-To: <20210106174127.805660-1-bfoster@redhat.com>
References: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The log covering helper checks whether the filesystem is writable to
determine whether to cover the log. The helper is currently only
called from the background log worker. In preparation to reuse the
helper from freezing contexts, lift the check into xfs_log_worker().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b445e63cbc3c..4137ed007111 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1050,13 +1050,11 @@ xfs_log_space_wake(
  * can't start trying to idle the log until both the CIL and AIL are empty.
  */
 static int
-xfs_log_need_covered(xfs_mount_t *mp)
+xfs_log_need_covered(
+	struct xfs_mount	*mp)
 {
-	struct xlog	*log = mp->m_log;
-	int		needed = 0;
-
-	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
-		return 0;
+	struct xlog		*log = mp->m_log;
+	int			needed = 0;
 
 	if (!xlog_cil_empty(log))
 		return 0;
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

