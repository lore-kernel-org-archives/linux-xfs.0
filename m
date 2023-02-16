Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3BBC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBPVIg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjBPVIf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:08:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6D953805
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:08:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E722B828E1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAEEC433D2;
        Thu, 16 Feb 2023 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581703;
        bh=3ulhdd405Jer+FR7vk/V6kBH6Q8xP4f74fw1UBFnUJs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qF7pBUZpzeGeOyKj0iZRanCkNH5qCvVfgHmgdIyQmWLSU8Vuhgs0r3gHsbibwcUFA
         yeBTiJNJs5e6nsNQvviPCskLUoFf1Bv+mlyMBgExmgKpLNu+w3CcDZemtKvHUrUbL1
         n9lo2NmSQhDzujnvyWQ+PhUQ/bekiKW9Jglfs+cZ8IB6Vt+dzszJewsR/9h2F4Znc9
         bVNiba7mvuQ6Lw87hYhezKrnFcbPc2wEHP6TgrLHtGspTjz7e1we27XzwfEOf0Mu1Q
         tnquylk6qS9qWra3ehpiq6FpQUDXivLWnpGLptYjzrel4RlPuyT4KgAsCtPeg/KN1N
         7Ots6KucR9kWw==
Date:   Thu, 16 Feb 2023 13:08:22 -0800
Subject: [PATCH 2/2] xfs: repair parent pointers with live scan hooks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881681.3477709.6384263545279800861.stgit@magnolia>
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

Use the nlink hooks to keep our tempfile's parent pointers up to date.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_parent.c |   25 +++++++++++++++++++++++++
 libxfs/xfs_parent.h |    4 ++++
 2 files changed, 29 insertions(+)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 3ce30860..a7c5974c 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -364,3 +364,28 @@ xfs_parent_set(
 
 	return xfs_attr_set(&scr->args);
 }
+
+/*
+ * Remove the parent pointer (@rec -> @name) from @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  The update will not use logged
+ * xattrs.  This is for specialized repair functions only.  The scratchpad need
+ * not be initialized.
+ */
+int
+xfs_parent_unset(
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
+	scr->args.whichfork	= XFS_ATTR_FORK;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index effbccdf..a7fc621b 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -117,4 +117,8 @@ int xfs_parent_set(struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
+int xfs_parent_unset(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *rec,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */

