Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1F0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiLaCIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:08:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC4D140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:08:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46BE961CCE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CA1C433D2;
        Sat, 31 Dec 2022 02:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452495;
        bh=H+EcAR2ZdCeEoQ8JZiJIp4qEv0NEa5hwniJJSDUhis8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f0kBvZ/Zw6PeURL5fJK/Sw/9CVEah2/1IpiSnbpIb4rihvNh52/zdZdLE5/m1AFpy
         uBl1G2JSYagNGtMmAd5mxbW1sAHupAbhGnlRNiykTsz+tl2nkGFNdT+0OyHS2Nq9GU
         XVfxt7bYZiF9Sa04pecuDFAQbLxGZ5VpJwyXG1dtPd2685lwK50932E063s2a3GnWO
         lYj8CVEkKDDc6IcYGIERuZ3OQiR+8z/EcLt1k3kAuyFh5KJPMYkzkpHa4ZKaheJ2Es
         fRuQSFmRMdaSFNqU4wr3HB007GsMHtwmcMHNiWzYzAFfHPxuZg6OXE6ckZ/+6zzNXb
         qyU7dSgD+7UHw==
Subject: [PATCH 20/26] xfs: hoist inode free function to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875558.723621.14021574407372540466.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_util.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |    5 +++++
 2 files changed, 55 insertions(+)


diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index e12c43954cf..65c025f3573 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -643,3 +643,53 @@ xfs_bumplink(
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/* Mark an inode free on disk. */
+int
+xfs_dir_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	int			error;
+
+	/*
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
+	 */
+	error = xfs_difree(tp, pag, ip->i_ino, xic);
+	if (error)
+		return error;
+
+	error = xfs_iunlink_remove(tp, pag, ip);
+	if (error)
+		return error;
+
+	/*
+	 * Free any local-format data sitting around before we reset the
+	 * data fork to extents format.  Note that the attr fork data has
+	 * already been freed by xfs_attr_inactive.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		kmem_free(ip->i_df.if_u1.if_data);
+		ip->i_df.if_u1.if_data = NULL;
+		ip->i_df.if_bytes = 0;
+	}
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_diflags = 0;
+	ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	VFS_I(ip)->i_generation++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index f92b14a6fbe..fcddaa6f738 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_INODE_UTIL_H__
 #define	__XFS_INODE_UTIL_H__
 
+struct xfs_icluster;
+
 uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
 uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
@@ -56,6 +58,9 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_dir_ifree(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip, struct xfs_icluster *xic);
+
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);

