Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD44C55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDAC6206CD
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VyJlir4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgD0Nwh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgD0Nwh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 09:52:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E44DC0610D5
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 06:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=C5PDjyTjD0O+q57mswgJ8Lt7r8FfyWPj/1l9tKP6JgU=; b=VyJlir4pm0jsKL2YVIEPBO5uwH
        +sBdNbmPYCpNKDNi9ZWv7WuVwa7VgioKelPWgUSDW/hMbX96I/ItATTo+xauWHUpxPDhhx5Ep27Sk
        jFHgEC9z4VxTQgI1e3i4gLm12cuA349GZGGKWmLOL+oqBhQwjr9g8mjbNM36qRn1pNQHG4fQrpYy7
        hlxIYDG6hud0ohleNRFtGyCbmZA19xIQAUP2nThxDivVEEU7ZsxQkJKnLbkINMvb4BnWnjHzwZncl
        VPw0X/pLz49wtdsVt6CBnYWOJnCtrUBIDl2XmB6PcC4OAcDwIZFB/1kPoAbRls9n+8Z3/HIYGyRHP
        ZnD+sfPw==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jT4BY-0003w0-OP
        for linux-xfs@vger.kernel.org; Mon, 27 Apr 2020 13:52:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: rename inode_list xlog_recover_reorder_trans
Date:   Mon, 27 Apr 2020 15:52:29 +0200
Message-Id: <20200427135229.1480993-3-hch@lst.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427135229.1480993-1-hch@lst.de>
References: <20200427135229.1480993-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This list contains pretty much everything that is not a buffer.  The
comment calls it item_list, which is a much better name than inode
list, so switch the actual variable name to that as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 750a81b941ea4..33cac61570abe 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1847,7 +1847,7 @@ xlog_recover_reorder_trans(
 	LIST_HEAD(cancel_list);
 	LIST_HEAD(buffer_list);
 	LIST_HEAD(inode_buffer_list);
-	LIST_HEAD(inode_list);
+	LIST_HEAD(item_list);
 
 	list_splice_init(&trans->r_itemq, &sort_list);
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
@@ -1883,7 +1883,7 @@ xlog_recover_reorder_trans(
 		case XFS_LI_BUD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
-			list_move_tail(&item->ri_list, &inode_list);
+			list_move_tail(&item->ri_list, &item_list);
 			break;
 		default:
 			xfs_warn(log->l_mp,
@@ -1904,8 +1904,8 @@ xlog_recover_reorder_trans(
 	ASSERT(list_empty(&sort_list));
 	if (!list_empty(&buffer_list))
 		list_splice(&buffer_list, &trans->r_itemq);
-	if (!list_empty(&inode_list))
-		list_splice_tail(&inode_list, &trans->r_itemq);
+	if (!list_empty(&item_list))
+		list_splice_tail(&item_list, &trans->r_itemq);
 	if (!list_empty(&inode_buffer_list))
 		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
 	if (!list_empty(&cancel_list))
-- 
2.26.1

