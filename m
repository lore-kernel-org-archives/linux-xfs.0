Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA24DCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjJSQWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjJSQWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:22:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0B99B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:22:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC3FC433C9;
        Thu, 19 Oct 2023 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732539;
        bh=7McOPZfqc8EEyo+/6dbVp3nTlVHS5ZDz9avnfURbZRM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GfAdHLmmt+f03PWXJsXY7jG/A+pxYtRx+MMOiIIAt8p8j0nKSZ8bWymSD0yj/1QyT
         I2pUSu2HDzdVpWxDqgyUbvTKsDAQIvSd7Dk3xv82AAuwwLX4ZzDmO6VufQebwyotvP
         38Wa4YbXnz4oAW506zdNYGBGm1eX4QfbJlvT4jz9WiVsozdoYg8Jjn+8AHBGlonZvM
         8ZHFEQsIZss0N2kx2U+grKuCHa1x2KzatlW2WmzG47jdEw4jMxHfINhKzJUUezqw7F
         LPWo3nwZ4/iJB7i063s1ot/F3G++IsWnF7NjdUuWPOL4w06wSIa0JN1n4e7uxvIQ/U
         OTYnyR/ca/Ryg==
Date:   Thu, 19 Oct 2023 09:22:19 -0700
Subject: [PATCH 4/4] xfs: rt stubs should return negative errnos when rt
 disabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773209806.223190.16562654402106218983.stgit@frogsfrogsfrogs>
In-Reply-To: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
References: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When realtime support is not compiled into the kernel, these functions
should return negative errnos, not positive errnos.  While we're at it,
fix a broken macro declaration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3b2f1b499a11..65c284e9d33e 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -141,17 +141,17 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
-# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
-# define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
-# define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
-# define xfs_growfs_rt(mp,in)                           (ENOSYS)
-# define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)                 (ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
-# define xfs_verify_rtbno(m, r)			(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
-# define xfs_rtalloc_reinit_frextents(m)                (0)
+# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
+# define xfs_growfs_rt(mp,in)				(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_verify_rtbno(m, r)				(false)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+# define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
@@ -162,7 +162,7 @@ xfs_rtmount_init(
 	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return -ENOSYS;
 }
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 

