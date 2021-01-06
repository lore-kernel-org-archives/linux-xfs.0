Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CA6C43332
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEDF22313E
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbhAFRnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:43:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727876AbhAFRnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:43:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F/yO6kwTTBdqKThf5ShctnqEIuLi/6Y781n7Br/2ti0=;
        b=AebsRXo80ne9W9gziveXEYuaxdfN030hCYrPkiER51pxdrKHbwbLhByRSKQnMa1mn+27bZ
        8Lf9N2p/0xWprCKWs5AyrXIJ+YsLzI3CvKt5ZJ/nzKIISuQCThjxIGe7X30lgbVvK07gxe
        ujWSTvSXY89b2qlkYSkOIpfed4aE0fg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-u7PeSF5xOP-QXTZ2cRyJmQ-1; Wed, 06 Jan 2021 12:41:33 -0500
X-MC-Unique: u7PeSF5xOP-QXTZ2cRyJmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11C89800D53
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:32 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9AD519635
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:31 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: cover the log on freeze instead of cleaning it
Date:   Wed,  6 Jan 2021 12:41:27 -0500
Message-Id: <20210106174127.805660-10-bfoster@redhat.com>
In-Reply-To: <20210106174127.805660-1-bfoster@redhat.com>
References: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Filesystem freeze cleans the log and immediately redirties it so log
recovery runs if a crash occurs after the filesystem is frozen. Now
that log quiesce covers the log, there is no need to clean the log and
redirty it to trigger log recovery because covering has the same
effect. Update xfs_fs_freeze() to quiesce (and thus cover) the log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aedf622d221b..aed74a3fc787 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -889,8 +889,7 @@ xfs_fs_freeze(
 	flags = memalloc_nofs_save();
 	xfs_stop_block_reaping(mp);
 	xfs_save_resvblks(mp);
-	xfs_log_clean(mp);
-	ret = xfs_sync_sb(mp, true);
+	ret = xfs_log_quiesce(mp);
 	memalloc_nofs_restore(flags);
 	return ret;
 }
-- 
2.26.2

