Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C2FC4BA10
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59B062176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aFzh6X04"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgBYXK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:10:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbgBYXK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EPUYC+s6pguYeMcjLej9GTQUeR8yhOlfX2zNBapNT5U=; b=aFzh6X04K4Af1QfGF3hz4zKxLp
        5dh4u1o+/0cyBVK1o/bWVFBnRz3+ogVdbbl7B/I20soDfz00X5cZJfp1BfCGPbfYfYUoJnpXbQBIj
        oL44cD0SVgMlQ/qCknxHlqrChjx9zgsClxHWLJgPp0uXr/lICZLslIr464rqFDIp6uGaMPssTjt7e
        I+LOWoPPuXlslQDsnngk6p+vq7JvQBUjOgADauZN/GBb4OOhcKOAfLUs747Ez6gILh5SuEqnIJAJs
        whaKyysNdSdKPR0xThK7ygqppYJY+iUrdrU3g2oBGfjaCirzYNZ/6QsKAIzhjxJMsIVL9T5hJuRrr
        j09wtyEQ==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLO-0003AG-74; Tue, 25 Feb 2020 23:10:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/30] xfs: remove the unused ATTR_ENTRY macro
Date:   Tue, 25 Feb 2020 15:10:00 -0800
Message-Id: <20200225231012.735245-19-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0c8f7c7a6b65..31c0ffde4f59 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -69,14 +69,6 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 	char	a_name[1];	/* attr name (NULL terminated) */
 } attrlist_ent_t;
 
-/*
- * Given a pointer to the (char*) buffer containing the attr_list() result,
- * and an index, return a pointer to the indicated attribute in the buffer.
- */
-#define	ATTR_ENTRY(buffer, index)		\
-	((attrlist_ent_t *)			\
-	 &((char *)buffer)[ ((attrlist_t *)(buffer))->al_offset[index] ])
-
 /*
  * Kernel-internal version of the attrlist cursor.
  */
-- 
2.24.1

