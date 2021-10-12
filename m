Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B377C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E7260FDA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhJLXfm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235840AbhJLXfm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2859D60EB6;
        Tue, 12 Oct 2021 23:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081620;
        bh=OIe+7+YYg/GpzE1UA5wn+g9fz8T9Bpxj0lWK+0UZGDk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O/z2C1+EiJ450qimvWdIlTz+5kk9YpYuYywfsOA4cvNYc9MMENuA1DBNnbAwZiytI
         DoTUvjqUhOEWm0U7iFJZLX7W525gDfCDajOIO79xGJuZr9HWQla/zsmAjJ47QqeFSl
         uWIkodmgn46+yJrrzVhax8+nph/A0ZxcQGHSHPxoDortRvDO0MvsGQ27gEKhoyBgYW
         CNllGYqg2lCwkoFl5rYLBXZStP+8vl0g8U4YzvJPUugO1HKjhRkM0TR/krU36nKgph
         +JJsHH0jYdOimRDPAz1ARa3rkkLpRaP/CWpzCQXJW4cjnajL3n3ApbigdKI2wjT2RV
         P7kl03EMPepOg==
Subject: [PATCH 12/15] xfs: kill XFS_BTREE_MAXLEVELS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:39 -0700
Message-ID: <163408161986.4151249.17284868227162995652.stgit@magnolia>
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

Nobody uses this symbol anymore, so kill it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index fccb374a8399..d5f03550cec9 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -92,8 +92,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
-#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
-
 /*
  * The btree cursor zone hands out cursors that can handle up to this many
  * levels.  This is the known maximum for all btree types.

