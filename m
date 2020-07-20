Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE5DC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 00:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C20A2177B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 00:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XJYPZYrF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGTAPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jul 2020 20:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgGTAPQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jul 2020 20:15:16 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC44C0619D2;
        Sun, 19 Jul 2020 17:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=lmPUz5RY+t3kg/qQNhfp48GVHKH8kF2wEhafpnF3ESY=; b=XJYPZYrFTuQsqM/t46dbY2ZbGR
        3ohJH+0xXg9SVHBdOQ7Zfk0Fs/qlOOIxPl/bItupy3eFHAjJQmWFHg0tZFgwujKx9uvJfafw1EcG/
        p7Kq/GP0sAIdhTYbHcFzSS99uKMz2geIL1Tqw6BGM4BUM0h09EbugVycJiYXo/Nt5ywSX3pp2EB1O
        QamqKrGP6syeWRh0IAOjvI7khJwXQNdhwK2RMvocLxrK3eCE7ir//T3QxcbWiplNF8iYiCisHKLa3
        UhCjnWbmom8tIWqSbJk3aoHvuZnir+xeExEYMl4PrO3yiHXE6CnPB8I8sHsrCvDvnYa8n2zZLEOj/
        XTmTulNg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxJSb-00042j-DW; Mon, 20 Jul 2020 00:15:13 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: xfs_btree_staging.h: delete duplicated words
Date:   Sun, 19 Jul 2020 17:15:09 -0700
Message-Id: <20200720001509.656-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Drop the repeated words "with" and "be" in comments.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
---
 fs/xfs/libxfs/xfs_btree_staging.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200717.orig/fs/xfs/libxfs/xfs_btree_staging.h
+++ linux-next-20200717/fs/xfs/libxfs/xfs_btree_staging.h
@@ -18,7 +18,7 @@ struct xbtree_afakeroot {
 	unsigned int		af_blocks;
 };
 
-/* Cursor interactions with with fake roots for AG-rooted btrees. */
+/* Cursor interactions with fake roots for AG-rooted btrees. */
 void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
 		struct xbtree_afakeroot *afake);
 void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
@@ -45,7 +45,7 @@ struct xbtree_ifakeroot {
 	unsigned int		if_extents;
 };
 
-/* Cursor interactions with with fake roots for inode-rooted btrees. */
+/* Cursor interactions with fake roots for inode-rooted btrees. */
 void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
 		struct xbtree_ifakeroot *ifake,
 		struct xfs_btree_ops **new_ops);
@@ -90,7 +90,7 @@ struct xfs_btree_bload {
 
 	/*
 	 * Number of free records to leave in each leaf block.  If the caller
-	 * sets this to -1, the slack value will be calculated to be be halfway
+	 * sets this to -1, the slack value will be calculated to be halfway
 	 * between maxrecs and minrecs.  This typically leaves the block 75%
 	 * full.  Note that slack values are not enforced on inode root blocks.
 	 */
