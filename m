Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61510C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDB8604E9
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbhIXB3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243758AbhIXB3V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:29:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C0ED610CB;
        Fri, 24 Sep 2021 01:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446869;
        bh=Ymy3G2Qj51L/OQVfytIqbBR4WOcDxpA2Sl84JCEZl3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fpz3JiBNJGp5cafsnietIZHXi5+tPKkrrTvH1B+nM6d1GnWwYDq5WFyMv98apabt3
         74ks9IaKYWyNvgI+sYQJ44hN4UsPy59v3i6anfyuI01Cm2i78nAGTAwvLlKtIBETma
         JILI2gIPuLUjVikwX+hK0bQDJJkAH2uNe55/BiMkoKT+40L5+oALcuQiR2kSGM3QCg
         W6sE80u1KOdPyWrIaZuCaMoQoqagws03n0PNvxgo69C/Svn21wg7HG/KsFW2fNMmXM
         6RKrOryoJQ38NtuzbV56+/UGmVOGyxIRqf84EqE/U4aw3DX1GHLThYTpFHd0ZHAU/L
         3fkjQmlXGGAUA==
Subject: [PATCH 2/4] xfs: reduce the size of nr_ops for refcount btree cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com,
        chandanrlinux@gmail.com, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:48 -0700
Message-ID: <163244686890.2701674.4993419808822985879.stgit@magnolia>
In-Reply-To: <163244685787.2701674.13029851795897591378.stgit@magnolia>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
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
index 527b90aa085b..57b7aa3f6366 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -185,18 +185,18 @@ union xfs_btree_irec {
 
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

