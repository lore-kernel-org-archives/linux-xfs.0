Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D0EC43457
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 14:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F02222EB
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 14:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QHCGxvwZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388943AbgJIObt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388856AbgJIObM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 10:31:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1059CC0613D9;
        Fri,  9 Oct 2020 07:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qnANyeE8BGUfs9EI0mAgvyYgGmWNNC+tzF64JAGclAM=; b=QHCGxvwZzOX1kKFzij5mlSA/gw
        QTEkEHUkZeBUJ3wxqkKLJnb+bsoPZd4hqA4z6Fwej0ZQFO//xttCyk0G8YeGWpkWOR3Ke/QHezikU
        UDp2rHaCqzXEJaLyZsMKYIcB76E++KCon/B6LkQ7B4lkZm/QIUpuSjEl7+/dqENZ1ckEIQZVsUjZ7
        ks/g/Az4xPcjq9NueOILPQhW/QPHNUAt/TaqD3NrozoRyFrwY7lri5+g0QXxkQNUY8pwlwF5g61iK
        i1MIhRgWYaawB21c84FTADz1O9wLc66fLBSz21rg1EdS0WrlcP85GM4DMvNPwUHqexLNS+zDBNn2N
        9ny/3G4w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQtQM-0005vs-7D; Fri, 09 Oct 2020 14:31:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-um@lists.infradead.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        linux-xfs@vger.kernel.org
Subject: [PATCH v2 12/16] ubifs: Tell the VFS that readpage was synchronous
Date:   Fri,  9 Oct 2020 15:31:00 +0100
Message-Id: <20201009143104.22673-13-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201009143104.22673-1-willy@infradead.org>
References: <20201009143104.22673-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The ubifs readpage implementation was already synchronous, so use
AOP_UPDATED_PAGE to avoid cycling the page lock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/file.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index b77d1637bbbc..82633509c45e 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -772,7 +772,6 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct bu_info *bu,
 	if (err)
 		goto out_warn;
 
-	unlock_page(page1);
 	ret = 1;
 
 	isize = i_size_read(inode);
@@ -892,11 +891,16 @@ static int ubifs_bulk_read(struct page *page)
 
 static int ubifs_readpage(struct file *file, struct page *page)
 {
-	if (ubifs_bulk_read(page))
-		return 0;
-	do_readpage(page);
-	unlock_page(page);
-	return 0;
+	int err;
+
+	err = ubifs_bulk_read(page);
+	if (err == 0)
+		err = do_readpage(page);
+	if (err < 0) {
+		unlock_page(page);
+		return err;
+	}
+	return AOP_UPDATED_PAGE;
 }
 
 static int do_writepage(struct page *page, int len)
-- 
2.28.0

