Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B29C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 472CD207D8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QNWCQJj0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgERHeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 03:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgERHeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 03:34:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B361AC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 00:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IdzjbTA24niYxoFjUJLB7LyVXPVPRMOzIl8TYpWteHI=; b=QNWCQJj0f4u8Ui6JPkdOnDaWDv
        qcizUPeoP0Qfiqa6iwKRShDbWeauJ2I19zJ/+HLt3cl5YgeuVWhjQa5vTp1I6AmFbqO+z7ZJrT4cS
        p21vmQcG5n9Ng5znxQ4kiEXygp06+YMpu1QanACxWG0ObFKjzybJ7RoWbh/kuRvALLdt1LRSlPtfW
        gfetKuhDak+G7gdiYkV/2dazDtA6sEm1BkdKsG3arHtiloiJVKwJklqEDnnqxQxgjFsoktjV6B0mB
        LxkBrmSzBh41qkKNeA9uAsgY5rjtGJfuYd5jRfTcoK+4JxZHqRlEehJJvglcFLjFWNI5F9/1722jG
        AAy+y66A==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaaHq-0002rV-29; Mon, 18 May 2020 07:34:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/6] xfs: remove xfs_ifree_local_data
Date:   Mon, 18 May 2020 09:33:55 +0200
Message-Id: <20200518073358.760214-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518073358.760214-1-hch@lst.de>
References: <20200518073358.760214-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_ifree only need to free inline data in the data fork, as we've
already taken care of the attr fork before (and in fact freed the
fork structure).  Just open code the freeing of the inline data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 549ff468b7b60..7d3144dc99b72 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2711,24 +2711,6 @@ xfs_ifree_cluster(
 	return 0;
 }
 
-/*
- * Free any local-format buffers sitting around before we reset to
- * extents format.
- */
-static inline void
-xfs_ifree_local_data(
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	struct xfs_ifork	*ifp;
-
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
-		return;
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
-}
-
 /*
  * This is called to return an inode to the inode free list.
  * The inode should already be truncated to 0 length and have
@@ -2765,8 +2747,16 @@ xfs_ifree(
 	if (error)
 		return error;
 
-	xfs_ifree_local_data(ip, XFS_DATA_FORK);
-	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
+	/*
+	 * Free any local-format data sitting around before we reset the
+	 * data fork to extents format.  Note that the attr fork data has
+	 * already been freed by xfs_attr_inactive.
+	 */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+		kmem_free(ip->i_df.if_u1.if_data);
+		ip->i_df.if_u1.if_data = NULL;
+		ip->i_df.if_bytes = 0;
+	}
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_d.di_flags = 0;
-- 
2.26.2

