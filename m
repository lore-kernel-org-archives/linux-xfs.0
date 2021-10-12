Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51041C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 371C260F3A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhJLXer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234169AbhJLXer (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:34:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1461E60E53;
        Tue, 12 Oct 2021 23:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081565;
        bh=F4g2UazaWv01ejlMAQqqzohNcrUMXGAzdR+xqJn+Ol8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R4tOIeR1ubp/m5BtNwvPsrWBznwyKLBTIWmCrpuuUQ/8FzE+rTsitKAguV4MIG/xx
         3PrdpFpjJHWNI3xLNvfesW1gd9XPEI2ivgOUu+Aj/B2JC6M2+OSxyB6jN2ipt1UPI8
         U7DTOKN72A3m8MyZGqbyNvun0DErzPEkJtPIWA5f+47NWUNnPdliLMk0NwOFQWhfxY
         K7n7PFK9uOPAjrnMhv22xGx8cmgrFNDEieE47JjlEFbllZcPC9+BVqvQswo0gpptde
         LulRpL5DVxmMt/jfX/U1BxHmcTay7AXIGEDgIXs9JujBi/Nb5PDo9sxSsy9kPglJIT
         wsr0FAFlfg34Q==
Subject: [PATCH 02/15] xfs: reduce the size of nr_ops for refcount btree
 cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:32:44 -0700
Message-ID: <163408156479.4151249.4245850917668794754.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We're never going to run more than 4 billion btree operations on a
refcount cursor, so shrink the field to an unsigned int to reduce the
structure size.  Fix whitespace alignment too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 49ecc496238f..1018bcc43d66 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -181,18 +181,18 @@ union xfs_btree_irec {
 
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	struct xfs_perag	*pag;
+	struct xfs_perag		*pag;
 	union {
 		struct xfs_buf		*agbp;
 		struct xbtree_afakeroot	*afake;	/* for staging cursor */
 	};
 	union {
 		struct {
-			unsigned long nr_ops;	/* # record updates */
-			int	shape_changes;	/* # of extent splits */
+			unsigned int	nr_ops;	/* # record updates */
+			unsigned int	shape_changes;	/* # of extent splits */
 		} refc;
 		struct {
-			bool	active;		/* allocation cursor state */
+			bool		active;	/* allocation cursor state */
 		} abt;
 	};
 };

