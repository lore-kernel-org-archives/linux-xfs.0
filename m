Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89A7C35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B27822073A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dFmYi+0e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgBUOMB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:12:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbgBUOL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hgOI00QSO2OOUoBUAPD28REHlRO+qHzfg0pWMkdZOKk=; b=dFmYi+0eDnuCr0DaWyy4uVcDau
        D8849c1o9FYw6vz5tnk9igfqODmKEg4ewr4KoIhakMiyx1MnRdUQlqUZR2ClgZ6vM4ZYTARsUZahu
        7qwDdym17g0m3YvyYnWnYIvj6k9Dfinrxj5ZYBf5pTIkVM4R172o8hz8IMdTMRC6O3cYdQccWVHmi
        OB12MrlWnM/qVSuF9G51GTYEHYlDa1LGiavPguRki6kPun3laGAZampBgal71j8PjJZI1mlmKIW9P
        UJu4CW0VSExrw0o6lumOAx+wHss6MlS2mTPBBZexOVjMvyXwn3KVX2+2NCdACvQWLnUeCFjlO/rXa
        nzqDDqUw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5927-0000JT-94; Fri, 21 Feb 2020 14:11:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 20/31] xfs: open code ATTR_ENTSIZE
Date:   Fri, 21 Feb 2020 06:11:43 -0800
Message-Id: <20200221141154.476496-21-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
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

