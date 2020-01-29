Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F89C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F302070E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vCHYkrFw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgA2RED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:04:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2RED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:04:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yD1GJSqjZJoxnRGBpBoBf0LNPxhuQjjkLOdS6j/dkqE=; b=vCHYkrFwMRPETTuA47LOtlZqNL
        Ue2VRb8fbc53YUiBWK27qrggQZ5Su3QfuoEc7wAKur6SkbTIbClU/PBOkRfjN0cKkauBzIKzEsrMd
        EJXCpS5HNWAQJ5XBbPuubJ/2v52Nf/LVm72OfpoIdE2YJgAkWU/kKpw8Jj78vtcVJN/bmWYVcL2YZ
        WwxQ1bFDR/YeH26gOgf4MT3er1nxOGKCb1tmip5BLVE4VB4UeKLCfOWdVoToS5ZmX2JzP9TyddRNT
        pVU3sNim/8cxePtuMeZEeW5/5Xx7lV/g6Wm/4XZTMaqrOACsVzF7Wbop2PWZmPyoXDTEr/hRlywRc
        sjR7axvw==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwql0-0006xg-KC; Wed, 29 Jan 2020 17:04:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 20/30] xfs: open code ATTR_ENTSIZE
Date:   Wed, 29 Jan 2020 18:02:59 +0100
Message-Id: <20200129170310.51370-21-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace an opencoded offsetof and round_up hiden behind to macros
using the open code variant using the standard helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_list.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 9c4acb6dc856..f1ca8ef8be22 100644
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

