Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37B9C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjBPVH5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjBPVH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:07:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5C0199F6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:07:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94F69CE2BC8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF51C433D2;
        Thu, 16 Feb 2023 21:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581671;
        bh=EUAr39oe7Du2JPgfNdZAlUlzUDZkn2D5v7uFc79MWJI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WYoE32kH59eLARNwHV7/U9DzoHCt78wkfKfALjRhkNuJp7fcgenhETPfGMIAbfBXm
         Nj+zlKh9SPRcGbUhtzFFS/r+PKHlAqHFugSww/kkn66EIwZdCG7FkzqzYmDnbnLkx6
         Z8joGsn75dVg7a632byJ0gCRUMTMrez4rxJouiSH75dJuOZRms1HTBFmlIC2tGsIan
         gVbldiGKGDGOOPIkHYpDZaIoHpLDw1hIldl0cLU9rHrzbe9tEmxRuQBHpHDUrvao6N
         klBq/+ULjbHQuS7juzGTVbDSrOv0UeqcUmNZZl0CS9Es8JIh5PfWel4kEwgNLm9MHY
         +5ekrtL4gIYOg==
Date:   Thu, 16 Feb 2023 13:07:51 -0800
Subject: [PATCH 1/1] xfs: deferred scrub of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881370.3477633.6392153315886851865.stgit@magnolia>
In-Reply-To: <167657881358.3477633.3415293053198592445.stgit@magnolia>
References: <167657881358.3477633.3415293053198592445.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the trylock-based dirent check fails, retain those parent pointers
and check them at the end.  This may involve dropping the locks on the
file being scanned, so yay.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_parent.c |   38 ++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |   10 ++++++++++
 2 files changed, 48 insertions(+)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 980f0b82..1598158f 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -299,3 +299,41 @@ xfs_pptr_calc_space_res(
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
 }
 
+/*
+ * Look up the @name associated with the parent pointer (@pptr) of @ip.  Caller
+ * must hold at least ILOCK_SHARED.  Returns the length of the dirent name, or
+ * a negative errno.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	unsigned char			*name,
+	unsigned int			namelen,
+	struct xfs_parent_scratch	*scr)
+{
+	int				error;
+
+	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.op_flags	= XFS_DA_OP_OKNOENT;
+	scr->args.trans		= tp;
+	scr->args.valuelen	= namelen;
+	scr->args.value		= name;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+
+	scr->args.hashval = xfs_da_hashname(scr->args.name, scr->args.namelen);
+
+	error = xfs_attr_get_ilocked(&scr->args);
+	if (error)
+		return error;
+
+	return scr->args.valuelen;
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 4eb92fb4..cd1b1351 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -103,4 +103,14 @@ xfs_parent_finish(
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
 
+/* Scratchpad memory so that raw parent operations don't burn stack space. */
+struct xfs_parent_scratch {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr, unsigned char *name,
+		unsigned int namelen, struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */

