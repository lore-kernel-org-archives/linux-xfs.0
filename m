Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5D1C35254
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAB2520578
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kRsHNVt8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgBQNA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:00:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBQNA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HJxCQifA5sx79hyDW26wnE67+82eo0XvI6JbN1jN/u8=; b=kRsHNVt8ntOteXKFrUymCq96P0
        NqLK2h7uk20XZEKq9Gh/jWwN0xyQN1Jiag+gK+wp65z741kji3OLuxIMbBTPWcGyDMFdbWedMKGRL
        Sc9c9YGUUQApcGAsBDs6YS/1OCOMeoysUS1QO0BrecxJYgKgiIxr1tg9VKhCRKydInqxhUpwT2Zq6
        cn0qSp6HWp1z0/BI5pFkG0XiE8vehx5ofrv9wgXzm1b2nrqfb39aCC/+Bi9HS5/8B2yPZ09ZWznlM
        vbMFyzrFTeyndUq3jkzcLerHjtr2USvlWqmTMDUqpleG9d+lK0ocHKQhh8NMWK8Scxg735dazhedF
        Z5NP71rg==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g1C-0001xH-NG; Mon, 17 Feb 2020 13:00:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 20/31] xfs: open code ATTR_ENTSIZE
Date:   Mon, 17 Feb 2020 13:59:46 +0100
Message-Id: <20200217125957.263434-21-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
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
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
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

