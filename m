Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D57C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9ACD6109F
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhJGMwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:52:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232629AbhJGMwx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 08:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633611059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tadvme5Jxmpi9JOqIZ4BvdtN5Ln2rpgnY09NIIWhGc0=;
        b=EFpBQ0XGlpzrgQ+AT5fhN1r2K8JybC9cluovkz13Macyrfo0dpPMXUC0nOaKQuLRce3Jun
        +8ovGGhu1gkd42YGklOKW9b1QgDpFoQRZfqT+GhwfVCtsQePTt59r8Ab6VQ+3DJd/00/2H
        ymqchqk9lHO6oh814Ngl3IRB/W+86+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-5RBUTk3dP-24e8PmlVJFtQ-1; Thu, 07 Oct 2021 08:50:57 -0400
X-MC-Unique: 5RBUTk3dP-24e8PmlVJFtQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 986B5A40DC
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:56 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.18.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2182C6D98F
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:56 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: fold perag loop iteration logic into helper function
Date:   Thu,  7 Oct 2021 08:50:51 -0400
Message-Id: <20211007125053.1096868-2-bfoster@redhat.com>
In-Reply-To: <20211007125053.1096868-1-bfoster@redhat.com>
References: <20211007125053.1096868-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fold the loop iteration logic into a helper in preparation for
further fixups. No functional change in this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..d05a04f3c985 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -124,12 +124,23 @@ void xfs_perag_put(struct xfs_perag *pag);
  * for_each_perag_from() because they terminate at sb_agcount where there are
  * no perag structures in tree beyond end_agno.
  */
+static inline
+struct xfs_perag *xfs_perag_next(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*next_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*next_agno = pag->pag_agno + 1;
+	xfs_perag_put(pag);
+	pag = xfs_perag_get(mp, *next_agno);
+	return pag;
+}
+
 #define for_each_perag_range(mp, next_agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
 		(pag) != NULL && (next_agno) <= (end_agno); \
-		(next_agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get((mp), (next_agno)))
+		(pag) = xfs_perag_next((pag), &(next_agno)))
 
 #define for_each_perag_from(mp, next_agno, pag) \
 	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
-- 
2.31.1

