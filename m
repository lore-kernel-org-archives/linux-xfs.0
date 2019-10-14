Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9857ECE58F
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7D852067B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbfJNSNB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:13:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731926AbfJNSNB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Oct 2019 14:13:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 21769301D678
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4BDC5D6A3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 18:13:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 1/3] xfs: temporarily bypass oneshot grant tail verification
Date:   Mon, 14 Oct 2019 14:12:58 -0400
Message-Id: <20191014181300.15494-2-bfoster@redhat.com>
In-Reply-To: <20191014181300.15494-1-bfoster@redhat.com>
References: <20191014181300.15494-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Temporary hack to xlog_verify_grant_tail() to never set the
XLOG_TAIL_WARN oneshot warning flag. This results in a warning for
each instance of grant reservation tail overrun. For experimental
purposes only.

Not-signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 641d07f30a27..045ab648ca96 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3742,15 +3742,17 @@ xlog_verify_grant_tail(
 		if (cycle - 1 != tail_cycle &&
 		    !(log->l_flags & XLOG_TAIL_WARN)) {
 			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: cycle - 1 != tail_cycle", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
+				"%s: cycle - 1 (%d) != tail_cycle (%d)",
+				__func__, cycle - 1, tail_cycle);
+			//log->l_flags |= XLOG_TAIL_WARN;
+			return;
 		}
 
 		if (space > BBTOB(tail_blocks) &&
 		    !(log->l_flags & XLOG_TAIL_WARN)) {
 			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: space > BBTOB(tail_blocks)", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
+				"%s: space (%d) > BBTOB(tail_blocks) (%d)", __func__, space, BBTOB(tail_blocks));
+			//log->l_flags |= XLOG_TAIL_WARN;
 		}
 	}
 }
-- 
2.20.1

