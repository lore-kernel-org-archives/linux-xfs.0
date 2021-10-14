Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8041AC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6526B61152
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJNSBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 14:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhJNSBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 14:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634234347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GVJvKnAoK21JZkJlCWiIrcRBgTaMqs7HQ0BrYyZO1FA=;
        b=H/Y+bJDSEGUM43EttPMd2vIFsilVOwXPgPll+wOlCSeW76wW7T5KtWQA/vpIkZ275MVlAe
        fFZvIsfw156IRdArtoyfwzTOYJZRbRKrrGa/cTcTRGpWycWmq1aPW6TPQtQmkDPT5K4Wzk
        TK0EK8JaoQPIn8RJb9ayT1cAF1+I89Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-ZqRHA6wINAul5XgeUOiEKg-1; Thu, 14 Oct 2021 13:59:05 -0400
X-MC-Unique: ZqRHA6wINAul5XgeUOiEKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03B691006AB1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 17:59:05 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6EBBB8549
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 17:59:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/4] xfs: terminate perag iteration reliably on agcount
Date:   Thu, 14 Oct 2021 13:59:01 -0400
Message-Id: <20211014175902.1519172-4-bfoster@redhat.com>
In-Reply-To: <20211014175902.1519172-1-bfoster@redhat.com>
References: <20211014175902.1519172-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The for_each_perag_from() iteration macro relies on sb_agcount to
process every perag currently within EOFS from a given starting
point. It's perfectly valid to have perag structures beyond
sb_agcount, however, such as if a growfs is in progress. If a perag
loop happens to race with growfs in this manner, it will actually
attempt to process the post-EOFS perag where ->pag_agno ==
sb_agcount. This is reproduced by xfs/104 and manifests as the
following assert failure in superblock write verifier context:

 XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22

Update the corresponding macro to only process perags that are
within the current sb_agcount.

Fixes: 58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 134e8635dee1..4585ebb3f450 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -142,7 +142,7 @@ xfs_perag_next(
 		(pag) = xfs_perag_next((pag), &(agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.31.1

