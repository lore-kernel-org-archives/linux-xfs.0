Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6FEC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjEZCaO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZCaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:30:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E65A19C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C026564C4C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2837EC433D2;
        Fri, 26 May 2023 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068210;
        bh=7TebJoaZKcLxKGGOmv0OsRF7e9qL4ew+Wlfaz5qISHY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oedQILQh40PUmd00dkA8N2JQnX6nGmPjNx+F1LXhGmc3TUTPc8RSqYYz8CxWNXnmL
         2y1V6XRvjrK2JSEQndD/FG+uifbzTtt9tB+UT5x+PZVaGc6V0R2OQEHXcP/xwIVEdD
         kbkiXDLwZHXEcLaKebb+a+fZc3KV4Tm7jWQHNg+/aM8kvJrMwXhKsnAmLdamrJh3nB
         FZooLOUZyrPpviDikufM/GS+5Rj58IYv8dDpmKfm6i0SKYS9s79tPi/IR8TOXii1i0
         YFXUfYAU4fNOP3HxAIj9dsUAmhLbhMoIzkHvgI1E09dVqYGGS28U/1PKkLrcX05QJZ
         goTj7P29CP3hQ==
Date:   Thu, 25 May 2023 19:30:09 -0700
Subject: [PATCH 02/14] xfs: check dirents have parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078623.3750196.17274476698965658069.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the fs has parent pointers, we need to check that each child dirent
points to a file that has a parent pointer pointing back at us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_parent.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |   10 ++++++++++
 2 files changed, 52 insertions(+)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index b1890f48722..fcf05dc5ed4 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -323,3 +323,45 @@ xfs_parent_irec_hashname(
 
 	irec->p_namehash = xfs_dir2_hashname(mp, &dname);
 }
+
+static inline void
+xfs_parent_scratch_init(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.op_flags	= XFS_DA_OP_NVLOOKUP;
+	scr->args.trans		= tp;
+	scr->args.value		= (void *)pptr->p_name;
+	scr->args.valuelen	= pptr->p_namelen;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
+					sizeof(struct xfs_parent_name_rec));
+}
+
+/*
+ * Look up the @name associated with the parent pointer (@pptr) of @ip.
+ * Caller must hold at least ILOCK_SHARED.  Returns 0 if the pointer is found,
+ * -ENOATTR if there is no match, or a negative errno.  The scratchpad need not
+ *  be initialized.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
+
+	return xfs_attr_get_ilocked(&scr->args);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 0f4808990ce..25bbb62fce5 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -98,4 +98,14 @@ void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec,
 void xfs_parent_irec_hashname(struct xfs_mount *mp,
 		struct xfs_parent_name_irec *irec);
 
+/* Scratchpad memory so that raw parent operations don't burn stack space. */
+struct xfs_parent_scratch {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */

