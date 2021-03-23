Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77D8C433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 13:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974A4619C0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 13:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhCWNxf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 09:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231833AbhCWNxV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 09:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616507600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dBPjKWQmA/uD5b4zv+pOMn4Fq9EOmM6hfrnKtfAI6m0=;
        b=MqZDkqYlAVrz86wideLdaRRWNFj3Isjelz2N2k+tHVDXcNhSFOaYP27a9vePJeMgd2HjmK
        MKPt7mMUA/MuiJlcBRlgTn8Sw0NBMarbmv37FQasaztW2bla4OBSmsNNfVKPDomdVEWoRZ
        LWvkHktNEPhc1bhR2hxmAZkxMhWHI1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-TbGS_QgxOHK4gTYFZ3IPRw-1; Tue, 23 Mar 2021 09:53:18 -0400
X-MC-Unique: TbGS_QgxOHK4gTYFZ3IPRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5E3983DD21
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 13:53:17 +0000 (UTC)
Received: from andromeda.redhat.com (unknown [10.40.193.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A01360918
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 13:53:16 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2] xfs_logprint: Fix buffer overflow printing quotaoff
Date:   Tue, 23 Mar 2021 14:53:14 +0100
Message-Id: <20210323135314.1595521-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
Changelog:

 - V2:
	Update strings removing the "QUOTA" of each printf, resulting
	in: "USER GROUP PROJECT"

 logprint/log_print_all.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 20f2a445..c9c453f6 100644
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
+		printf(" USER");
 	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
-		strcat(str, "GROUP QUOTA");
+		printf(" GROUP");
 	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
-		strcat(str, "PROJECT QUOTA");
-	printf(_("\tQUOTAOFF: #regs:%d   type:%s\n"),
-	       qoff_f->qf_size, str);
+		printf(" PROJECT");
+	printf("\n");
 }
 
 STATIC void
-- 
2.29.2

