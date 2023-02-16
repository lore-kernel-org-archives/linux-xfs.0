Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD327C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjBPVIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjBPVIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:08:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097B82BEC4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:08:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF472B82844
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2D3C433D2;
        Thu, 16 Feb 2023 21:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581687;
        bh=JbmJ7u/FjcsDf2tz4FPyvoStKUeSlt7Sxcwhlo7rjRY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iWbzU1lv6+1i3iUs2h/caa9E9xRnt2XeAXtUaZgUnzClq8BwDvBb5M1tHVPBkodp5
         FOz7Klh52NpE3woB46T2zk3n4/xojKu6ane8VziblOFLOGnnpc5ieRZrzJr1s51EFa
         Xtrs56t0nqH0uHysJypiKFsIiWjstOq7DqbiCzbSlr4Ul2rha5836YU7O3MiZ1G5zA
         HsAB6whEsLNy0PGPRiNcN9NItQiYwcWz9TIzH/EtM4kQzlGVlQEC/+ggTkWEn24Wma
         9x5zuwsilELGGY9DFIRuuVLKkp9HCAV25Za/L3OrqT3wrtg7rk9P+N/mxDOWGnuGbW
         0h9+L4Kte+u6g==
Date:   Thu, 16 Feb 2023 13:08:07 -0800
Subject: [PATCH 1/2] xfs: repair parent pointers by scanning directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881668.3477709.11425532806934149908.stgit@magnolia>
In-Reply-To: <167657881656.3477709.1694162379388596172.stgit@magnolia>
References: <167657881656.3477709.1694162379388596172.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Walk the filesystem to rebuild parent pointer information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h |    6 ++++++
 libxfs/xfs_parent.c |   31 +++++++++++++++++++++++++++++--
 libxfs/xfs_parent.h |    4 ++++
 3 files changed, 39 insertions(+), 2 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index b0bba109..2bbda956 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -175,6 +175,12 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+/* convert from xfs inode to vfs inode */
+static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
 /* We only have i_size in the xfs inode in userspace */
 static inline loff_t i_size_read(struct inode *inode)
 {
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 1598158f..3ce30860 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -95,11 +95,11 @@ xfs_parent_valuecheck(
 static inline void
 xfs_init_parent_name_rec(
 	struct xfs_parent_name_rec	*rec,
-	struct xfs_inode		*ip,
+	const struct xfs_inode		*ip,
 	uint32_t			p_diroffset)
 {
 	xfs_ino_t			p_ino = ip->i_ino;
-	uint32_t			p_gen = VFS_I(ip)->i_generation;
+	uint32_t			p_gen = VFS_IC(ip)->i_generation;
 
 	rec->p_ino = cpu_to_be64(p_ino);
 	rec->p_gen = cpu_to_be32(p_gen);
@@ -337,3 +337,30 @@ xfs_parent_lookup(
 
 	return scr->args.valuelen;
 }
+
+/*
+ * Attach the parent pointer (@pptr -> @name) to @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  The update will not use logged
+ * xattrs.  This is for specialized repair functions only.  The scratchpad need
+ * not be initialized.
+ */
+int
+xfs_parent_set(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.valuelen	= pptr->p_namelen;
+	scr->args.value		= (void *)pptr->p_name;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index cd1b1351..effbccdf 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -113,4 +113,8 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr, unsigned char *name,
 		unsigned int namelen, struct xfs_parent_scratch *scratch);
 
+int xfs_parent_set(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */

