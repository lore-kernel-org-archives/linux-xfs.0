Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E87C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 16:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF02603E8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 16:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhJLQyK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 12:54:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230420AbhJLQyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 12:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634057527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nSZJRM37+haN8nsUoFpm7I67aGA7NZS00864sIykFSk=;
        b=Lo0VSvYFRkxyEWIpdrvt8PdKJHZ2jzut/dd0THPgH7hlvW15xWBKe4cgY8skFaCX7jx6Mk
        zuv+BPgpHTJcfSliPP/OzK2xk4/L/HfoTkUsRtR6ElMxR1Gw4I1KG0AN6fOxWpD+Qz5BHW
        7lao9KxdeZbKp/wpya5QENzHbu/LhMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-hfw2QJEfMYi8pHeaLyikmg-1; Tue, 12 Oct 2021 12:52:06 -0400
X-MC-Unique: hfw2QJEfMYi8pHeaLyikmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E613101B4A0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Oct 2021 16:52:05 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.18.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBCBA51F0F
        for <linux-xfs@vger.kernel.org>; Tue, 12 Oct 2021 16:52:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/4] xfs: terminate perag iteration reliably on agcount
Date:   Tue, 12 Oct 2021 12:52:02 -0400
Message-Id: <20211012165203.1354826-4-bfoster@redhat.com>
In-Reply-To: <20211012165203.1354826-1-bfoster@redhat.com>
References: <20211012165203.1354826-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index cf8baae2ba18..b8cc5017efba 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -142,7 +142,7 @@ struct xfs_perag *xfs_perag_next(
 		(pag) = xfs_perag_next((pag), &(agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.31.1

