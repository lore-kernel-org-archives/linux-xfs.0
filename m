Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F421AC4BA0F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C00F02176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dZ9ENFwa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgBYXK3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:10:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgBYXK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hgOI00QSO2OOUoBUAPD28REHlRO+qHzfg0pWMkdZOKk=; b=dZ9ENFwaVPP9C/x6Y9d5gJjE+Z
        LeIYUyFnMfAY0sNknZXpzy0IxF6EXbNhUL98hJ8T10eNiIz2J3lcRDsOtfyUUNIzuZuZ7GpkiAJeH
        2jZlGTF5DA0Fa2fxmrYiZE2/1QyPjpFbhIWLbLosRfsvtFb0i1t8rg7tiGL8SBPx2Nxuxs/zdQ/IP
        tdDWq8WisiXFemVKDdJLhpfR6v0U/CMsoDJkuSkVy8Ce8RqQvdA4mgf/EzUC/JILIrNT3xcbU/1Li
        SVHUjEDKJP5KTnBCgHGBQ/2k0lQUsnrgi0R1t+RbsNsyL7kyCTZ2B6S30uPLHo+xk8i+KMVemkoVj
        LrBZeKZg==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLO-0003AO-CK; Tue, 25 Feb 2020 23:10:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 19/30] xfs: open code ATTR_ENTSIZE
Date:   Tue, 25 Feb 2020 15:10:01 -0800
Message-Id: <20200225231012.735245-20-hch@lst.de>
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

Replace a single use macro containing open-coded variants of
standard helpers with direct calls to the standard helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_attr_list.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 0fe12474a952..c97e6806cf1f 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -545,12 +545,6 @@ xfs_attr_list_int(
 	return error;
 }
 
-#define	ATTR_ENTBASESIZE		/* minimum bytes used by an attr */ \
-	(((struct attrlist_ent *) 0)->a_name - (char *) 0)
-#define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
-	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(uint32_t)-1) \
-	 & ~(sizeof(uint32_t)-1))
-
 /*
  * Format an attribute and copy it out to the user's buffer.
  * Take care to check values and protect against them changing later,
@@ -586,7 +580,10 @@ xfs_attr_put_listent(
 
 	arraytop = sizeof(*alist) +
 			context->count * sizeof(alist->al_offset[0]);
-	context->firstu -= ATTR_ENTSIZE(namelen);
+
+	/* decrement by the actual bytes used by the attr */
+	context->firstu -= round_up(offsetof(struct attrlist_ent, a_name) +
+			namelen + 1, sizeof(uint32_t));
 	if (context->firstu < arraytop) {
 		trace_xfs_attr_list_full(context);
 		alist->al_more = 1;
-- 
2.24.1

