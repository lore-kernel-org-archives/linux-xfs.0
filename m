Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E31FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 654F464F6A
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhCSGZY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 02:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbhCSGZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 02:25:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1921C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 23:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5VGW0HyQc8QrDKmo4ZTz5E0zhECU1dy8XxsDV+6Uiws=; b=LeckvZw1P9TntPtKL+3HosvcaN
        3pnCxWzbmptyYWLSsqyWAiS2rpyQH6SDAbaDririnVKFMWNQtDXUNNlwX1N+/q9jXrxc3RHKFbCt2
        j6PJXs7nh9t1PWC1Vyx7lcfc/ChGCkRv3j9ViSSXwQBmvJsAXnkkQx3rbNpxbUV04XosLe/yh0cL1
        Hpc/p0aSbrfM1hf5ZFHtxs3W6O20cFpyRMKC3VydnMmiDtwVDXKekPVH/SMOy0oU1XBeIUrpzbgyL
        n/VYOYL8wPVKhp5bCdRHvSpaWoHZBPok+pqozzSVNSyDcbQ5O9K2XYQkEUwTp1MW9NB6WX5yomnM8
        QI1FLF6Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lN8ZB-0042k8-RQ; Fri, 19 Mar 2021 06:25:10 +0000
Date:   Fri, 19 Mar 2021 06:25:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/3] xfs: remove tag parameter from xfs_inode_walk{,_ag}
Message-ID: <20210319062501.GC955126@infradead.org>
References: <161610681966.1887634.12780057277967410395.stgit@magnolia>
 <161610682523.1887634.9689710010549931486.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161610682523.1887634.9689710010549931486.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 03:33:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It turns out that there is a 1:1 mapping between the execute and tag
> parameters that are passed to xfs_inode_walk_ag:
> 
> 	xfs_dqrele_inode => XFS_ICI_NO_TAG
> 	xfs_blockgc_scan_inode => XFS_ICI_BLOCKGC_TAG
> 
> The radix tree tags are an implementation detail of the inode cache,
> which means that callers outside of xfs_icache.c have no business
> passing in radix tree tags.  Since we're about to get rid of the
> indirect calls in the BLOCKGC case, eliminate the extra argument in
> favor of computing the ICI tag from the execute argument passed into the
> function.

This seems backwards to me.  I'd rather deduce the function from the
talk, which seems like a more sensible pattern.

That being said, the quota inode walk is a little different in that it
doesn't use any tags, so switching it to a plain list_for_each_entry_safe
on sb->s_inodes would seems more sensible, something like this untested
patch:

---
From 9ae07b6bf8c6b1337a627c8f0ad619c56511b343 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 19 Mar 2021 07:16:31 +0100
Subject: xfs: use s_inodes in xfs_qm_dqrele_all_inodes

Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
given that function simplify wants to iterate all live inodes known
to the VFS.  Just iterate over the s_inodes list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm_syscalls.c | 50 +++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 11f1e2fbf22f44..4e33919ed04b56 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -748,41 +748,27 @@ xfs_qm_scall_getquota_next(
 	return error;
 }
 
-STATIC int
+static void
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	void			*args)
+	uint			flags)
 {
-	uint			*flags = args;
-
-	/* skip quota inodes */
-	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
-		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_pdquot == NULL);
-		return 0;
-	}
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
+	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
+	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
 		xfs_qm_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
 }
 
-
 /*
  * Go thru all the inodes in the file system, releasing their dquots.
  *
@@ -794,7 +780,29 @@ xfs_qm_dqrele_all_inodes(
 	struct xfs_mount	*mp,
 	uint			flags)
 {
+	struct super_block	*sb = mp->m_super;
+	struct inode		*inode, *old_inode = NULL;
+
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&flags, XFS_ICI_NO_TAG);
+
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		struct xfs_inode	*ip = XFS_I(inode);
+
+		if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+			continue;
+		if (!igrab(inode))
+			continue;
+		spin_unlock(&sb->s_inode_list_lock);
+
+		iput(old_inode);
+		old_inode = inode;
+
+		xfs_dqrele_inode(ip, flags);
+
+		spin_lock(&sb->s_inode_list_lock);
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+
+	iput(old_inode);
 }
-- 
2.30.1

