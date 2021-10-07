Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5CFC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B439C60FD9
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbhJGMxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:53:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232760AbhJGMxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 08:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633611067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1X29NduHXMgiV0ISMKmzr6nRLRp6vhOpuS9G47QepGk=;
        b=VKFKaa7nZrfTwSBTNCNQkCgVqCvre2U2ECPlQMf6yI0jnu4jII2Z0tG+pSBVmCi59efEXW
        OZlpjj5bYcz4fWE+oG49Y+COoPuuGye6umurbWVcHi2+zdHxCkkk9M+ST43qin7HLBRwew
        pt2iZPhNlI2wl6HG+UyY4DIrHGvCsio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-yMg5YMYiPeuSNzdXBf6QyA-1; Thu, 07 Oct 2021 08:50:58 -0400
X-MC-Unique: yMg5YMYiPeuSNzdXBf6QyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16E3C84A5F2
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:57 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.18.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C22292C175
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:56 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: rename the next_agno perag iteration variable
Date:   Thu,  7 Oct 2021 08:50:52 -0400
Message-Id: <20211007125053.1096868-3-bfoster@redhat.com>
In-Reply-To: <20211007125053.1096868-1-bfoster@redhat.com>
References: <20211007125053.1096868-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename the next_agno variable to be consistent across the several
iteration macros and shorten line length.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index d05a04f3c985..d05c9217c3af 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -127,23 +127,23 @@ void xfs_perag_put(struct xfs_perag *pag);
 static inline
 struct xfs_perag *xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*next_agno)
+	xfs_agnumber_t		*agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	*next_agno = pag->pag_agno + 1;
+	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
-	pag = xfs_perag_get(mp, *next_agno);
+	pag = xfs_perag_get(mp, *agno);
 	return pag;
 }
 
-#define for_each_perag_range(mp, next_agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL && (next_agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(next_agno)))
+#define for_each_perag_range(mp, agno, end_agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (agno)); \
+		(pag) != NULL && (agno) <= (end_agno); \
+		(pag) = xfs_perag_next((pag), &(agno)))
 
-#define for_each_perag_from(mp, next_agno, pag) \
-	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+#define for_each_perag_from(mp, agno, pag) \
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.31.1

