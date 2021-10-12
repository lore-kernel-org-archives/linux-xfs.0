Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FE0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 16:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D38D603E8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 16:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhJLQyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 12:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231368AbhJLQyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 12:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634057526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C8DgAKQt+g0xpzeemZnygAEnsbkFdNdKw/wLUefKWtM=;
        b=dYGojYq+0UdyFQCgU01QoV30Y3ABQmiYVshvYQe0hqoBYWrr6lmP2PjeVX3BDaF1CC5bOr
        A9s47BBvV/4ApHm3Ht9mEBIlGx0dL8N6U7Mm5mhztz32DlfGx2/G2MpXYPAIz9Ku4z5TYv
        sPFKWKiY35AjrQzxXPsiyxlRDJgDdo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-JWMwRC-IOse9sSA8Zf8kWA-1; Tue, 12 Oct 2021 12:52:05 -0400
X-MC-Unique: JWMwRC-IOse9sSA8Zf8kWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EEEC800FF0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Oct 2021 16:52:04 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.18.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DFEA51F38
        for <linux-xfs@vger.kernel.org>; Tue, 12 Oct 2021 16:52:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/4] xfs: fold perag loop iteration logic into helper function
Date:   Tue, 12 Oct 2021 12:52:00 -0400
Message-Id: <20211012165203.1354826-2-bfoster@redhat.com>
In-Reply-To: <20211012165203.1354826-1-bfoster@redhat.com>
References: <20211012165203.1354826-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fold the loop iteration logic into a helper in preparation for
further fixups. No functional change in this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..48eb22e8d717 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -124,12 +124,22 @@ void xfs_perag_put(struct xfs_perag *pag);
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
+	return xfs_perag_get(mp, *next_agno);
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

