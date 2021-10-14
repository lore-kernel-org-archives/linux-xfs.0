Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACA4C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE598610EA
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhJNSBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 14:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233136AbhJNSBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 14:01:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634234348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DnwLH6v1rU2RnGOl6QGEKyBjIbo6ISfdN//eUJ8P14=;
        b=VY443z8PIQPxYX0os93lv1aO4L3XIqckrlwGM3fw+rYB3lyWCoF5CL72RmG8/H/OTw0dSL
        MiKFw9rsF9i3shVQZ/u5XBJTgN6PeQzgJaNSp/f8+Mv6EOPinygajqsv62LL97422dLcwx
        mekwkk5PDHhzGz/F83awqWIq5O45nkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-uBCFse1qNau7MndPWCfQ3Q-1; Thu, 14 Oct 2021 13:59:06 -0400
X-MC-Unique: uBCFse1qNau7MndPWCfQ3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E5D41006ABA
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 17:59:05 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CBC45C1A3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 17:59:05 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 4/4] xfs: fix perag reference leak on iteration race with growfs
Date:   Thu, 14 Oct 2021 13:59:02 -0400
Message-Id: <20211014175902.1519172-5-bfoster@redhat.com>
In-Reply-To: <20211014175902.1519172-1-bfoster@redhat.com>
References: <20211014175902.1519172-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The for_each_perag*() set of macros are hacky in that some (i.e.
those based on sb_agcount) rely on the assumption that perag
iteration terminates naturally with a NULL perag at the specified
end_agno. Others allow for the final AG to have a valid perag and
require the calling function to clean up any potential leftover
xfs_perag reference on termination of the loop.

Aside from providing a subtly inconsistent interface, the former
variant is racy with growfs because growfs can create discoverable
post-eofs perags before the final superblock update that completes
the grow operation and increases sb_agcount. This leads to the
following assert failure (reproduced by xfs/104) in the perag free
path during unmount:

 XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195

This occurs because one of the many for_each_perag() loops in the
code that is expected to terminate with a NULL pag (and thus has no
post-loop xfs_perag_put() check) raced with a growfs and found a
non-NULL post-EOFS perag, but terminated naturally based on the
end_agno check without releasing the post-EOFS perag.

Rework the iteration logic to lift the agno check from the main for
loop conditional to the iteration helper function. The for loop now
purely terminates on a NULL pag and xfs_perag_next() avoids taking a
reference to any perag beyond end_agno in the first place.

Fixes: f250eedcf762 ("xfs: make for_each_perag... a first class citizen")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4585ebb3f450..3f597cad2c33 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -116,30 +116,26 @@ void xfs_perag_put(struct xfs_perag *pag);
 
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
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*agno)
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		end_agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
+	if (*agno > end_agno)
+		return NULL;
 	return xfs_perag_get(mp, *agno);
 }
 
 #define for_each_perag_range(mp, agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (agno)); \
-		(pag) != NULL && (agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(agno)))
+		(pag) != NULL; \
+		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
 	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
-- 
2.31.1

