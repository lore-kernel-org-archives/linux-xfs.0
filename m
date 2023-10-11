Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25118CDB474
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjJKSCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbjJKSCi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:02:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9E5A4
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:02:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78050C433C8;
        Wed, 11 Oct 2023 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047355;
        bh=bQEmRifAo2XP2EPeShv2XrUJ0gcslBHS8QgKX6GWsMw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=B36d+mwENLc6G4CcG9Bc0x1N1S3fxDUgR2jHmdk2cU5w04l4IWNqgQjc0XmGIW85k
         v+oWHDo0Frk8tiJO9njmllZuZY18czgWcNSqfwUN/y3MpPw+Y1IkCIxIpA8GHlcWl1
         u0Dmj7O2r2broERVRBUMChR6QNdYRu33wNZev8M7oUiJquTzzw3nfXwpPHSW3f+hTe
         i0my/xOZFJc/Ujezr7HoIC3xx55iFHUAsN7pUkBJSpNnghm+rJ9uP7FU0tffDOJisN
         PryAs122UHK2Pdoz9JxQKXeKxSBbTSmJ3vkoELeSV9rZYv9Q8o2pmgpKj2HivXDe1X
         xHCPH7gck+N7g==
Date:   Wed, 11 Oct 2023 11:02:35 -0700
Subject: [PATCH 3/3] xfs: rt stubs should return negative errnos when rt
 disabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720379.1773263.4032428007620392316.stgit@frogsfrogsfrogs>
In-Reply-To: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
References: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_rtalloc.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index e440f793dd98f..e53bc52d81fd6 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -143,17 +143,17 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 int xfs_rtfile_convert_unwritten(struct xfs_inode *ip, loff_t pos,
 		uint64_t len);
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
@@ -164,7 +164,7 @@ xfs_rtmount_init(
 	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return -ENOSYS;
 }
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
 # define xfs_rtfile_convert_unwritten(ip, pos, len)	(0)
 #endif	/* CONFIG_XFS_RT */

