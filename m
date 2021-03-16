Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF20CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 09:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C41664F42
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 09:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhCPJEU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 05:04:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233947AbhCPJEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 05:04:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615885447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WbWouV3oBylU0UQr8ZfOx+0w+ZGgnwEJUL9PeGSirW4=;
        b=RQo4dmSOScS+ZxsQsnvySN/bD4C1D0q9lNW5Ud5tVBLj/zj7ZEShNGkkfotGHIEn+iGFr2
        7p9HXwk+wuC2hibHCkb/+VYBazBZoIOlzZl/zp28QVAhyrev7Kg4mwhLq7/+hZ3ZnX0aVl
        9qJZ3v/Gffo/8hBg5TFIUQZZ95xTK20=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-z-EJPW_JM9uVQCkuBrP7rA-1; Tue, 16 Mar 2021 05:04:03 -0400
X-MC-Unique: z-EJPW_JM9uVQCkuBrP7rA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16702100B381
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 09:04:03 +0000 (UTC)
Received: from andromeda.lan (unknown [10.40.194.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7806C62691
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 09:04:02 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_logprint: Fix buffer overflow printing quotaoff
Date:   Tue, 16 Mar 2021 10:04:00 +0100
Message-Id: <20210316090400.35180-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xlog_recover_print_quotaoff() was using a static buffer to aggregate
quota option strings to be printed at the end. The buffer size was
miscalculated and when printing all 3 flags, a buffer overflow occurs
crashing xfs_logprint, like:

QOFF: cnt:1 total:1 a:0x560530ff3bb0 len:160
*** buffer overflow detected ***: terminated
Aborted (core dumped)

Fix this by removing the static buffer and using printf() directly to
print each flag. Also add a trailling space before each flag, so they
are a bit more readable on the output.

Reported-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 logprint/log_print_all.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 20f2a445..03a32331 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -186,18 +186,18 @@ xlog_recover_print_quotaoff(
 	struct xlog_recover_item *item)
 {
 	xfs_qoff_logformat_t	*qoff_f;
-	char			str[32] = { 0 };
 
 	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].i_addr;
+
 	ASSERT(qoff_f);
+	printf(_("\tQUOTAOFF: #regs:%d   type:"), qoff_f->qf_size);
 	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
-		strcat(str, "USER QUOTA");
+		printf(" USER QUOTA");
 	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
-		strcat(str, "GROUP QUOTA");
+		printf(" GROUP QUOTA");
 	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
-		strcat(str, "PROJECT QUOTA");
-	printf(_("\tQUOTAOFF: #regs:%d   type:%s\n"),
-	       qoff_f->qf_size, str);
+		printf(" PROJECT QUOTA");
+	printf("\n");
 }
 
 STATIC void
-- 
2.29.2

