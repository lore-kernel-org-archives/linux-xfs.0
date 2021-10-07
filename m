Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA44AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB74610A2
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbhJGMxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:53:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240567AbhJGMxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 08:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633611076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TFYsXsjKHiwkpIeXVEQHtA3i5zfhA/KHpy7zFshdwUk=;
        b=fPB7aC43etkjYIhARwaApUX2HHnQK4h1W4ZSzEBM2qvViLUHMh7RlwcTOyE2SlgTn/ykeD
        ZauSenMV1+/uR8so0bpGGpzzZtZ+eNMPKBXfxPe+bAH9qh2o4s/vjTjHUA0savS0nHrgU5
        3Zsg1iTv4PFPxcrZFTdk/HZTh95GfCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-sG63N8YNPFiIUp5zv2uSNg-1; Thu, 07 Oct 2021 08:50:58 -0400
X-MC-Unique: sG63N8YNPFiIUp5zv2uSNg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E10A1B2C996
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:57 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.18.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 412C7652B4
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:57 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: terminate perag iteration reliably on end agno
Date:   Thu,  7 Oct 2021 08:50:53 -0400
Message-Id: <20211007125053.1096868-4-bfoster@redhat.com>
In-Reply-To: <20211007125053.1096868-1-bfoster@redhat.com>
References: <20211007125053.1096868-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The for_each_perag*() set of macros are hacky in that some (i.e. those
based on sb_agcount) rely on the assumption that perag iteration
terminates naturally with a NULL perag at the specified end agno. Others
allow for the final AG to have a valid perag and require the calling
function to clean up any potential leftover xfs_perag reference on
termination of the loop.

Aside from providing a subtly inconsistent interface, the former variant
is racy with a potential growfs in progress because growfs can create
discoverable post-eofs perags before the final superblock update that
completes the grow operation and increases sb_agcount. This leads to
unexpected assert failures (reproduced by xfs/104) such as the following
in the superblock buffer write verifier path:

 XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22

This occurs because the perag loop in xfs_icount_range() finds and
attempts to process a perag struct where pag_agno == sb_agcount.

The following assert failure occasionally triggers during the xfs_perag
free path on unmount, presumably because one of the many
for_each_perag() loops in the code that is expected to terminate with a
NULL pag raced with a growfs and actually terminated with a non-NULL
reference to post-eofs (at the time) perag.

 XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195

Rework the lower level perag iteration logic to explicitly terminate
on the specified end agno, not implicitly rely on pag == NULL as a
termination clause and thus avoid these problems. As of this change,
the remaining post-loop xfs_perag_put() checks that exist purely to
cover the natural termination case (i.e., not mid-loop breaks) are
spurious (yet harmless) and can be removed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index d05c9217c3af..edcdd4fbc225 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -116,34 +116,30 @@ void xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs
- *
- * XXX: for_each_perag_range() usage really needs an iterator to clean up when
- * we terminate at end_agno because we may have taken a reference to the perag
- * beyond end_agno. Right now callers have to be careful to catch and clean that
- * up themselves. This is not necessary for the callers of for_each_perag() and
- * for_each_perag_from() because they terminate at sb_agcount where there are
- * no perag structures in tree beyond end_agno.
  */
 static inline
 struct xfs_perag *xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*agno)
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		end_agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
-	pag = xfs_perag_get(mp, *agno);
+	pag = NULL;
+	if (*agno <= end_agno)
+		pag = xfs_perag_get(mp, *agno);
 	return pag;
 }
 
 #define for_each_perag_range(mp, agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (agno)); \
-		(pag) != NULL && (agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(agno)))
+		(pag) != NULL; \
+		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.31.1

