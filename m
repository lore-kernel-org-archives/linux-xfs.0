Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6237C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC76610E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhJNUTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhJNUTR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C836161019;
        Thu, 14 Oct 2021 20:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242631;
        bh=GLKE5RFYJf2M0rN0DhZ2BpC7FT+K4U9qO41LG/xj1mI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DjDf3uX00lqpXIT0+sRhM5BO7QiLqkfAyPwYdp00d5z+wh4kbdKxc+9/NG7h8tOAi
         XochDnLwP4AlLpmq5GtnFCJ50cJV/L6gG7T4zJTDe1b01I9/60bsy1lkLmOJUV0vvh
         3cz0c5EkfWps+Hmx0wluXD+IYbLPkNqw+BxAAg0/Dsf+hpu7s8zH5S8ic2SPFQQPTB
         sQqr3WDummMZXcJe+njkjkSG48ROErgARsh78Z/q7/Ko+6NbJSYf4AP+sje6UxqtYU
         CTuXqRVwVxclUZ6M+ZojtzfG7YjEcBut66LNJYNmCVFQvgQ/9axAFkpPkSTHybqd9P
         I1GGgvxYwqulg==
Subject: [PATCH 03/17] xfs: reduce the size of nr_ops for refcount btree
 cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:11 -0700
Message-ID: <163424263151.756780.8007377786471235053.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

