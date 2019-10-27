Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BAACA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DEC0214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="alDrcAZ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfJ0O4Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bmzzPqxKN/2BqLOsiLuKF4o6Vroe5WrWSf+s4epREQM=; b=alDrcAZ1U+fxHXzbhooJiup7gC
        tULvHpdteQyO2TKsEDqBXbAxNAeZtG1jwi0XwoL56qFCjkQm55o7aKFa5nQ4u7lrrrxlCtjg2fFzh
        +l+ElqzxJaGLJMpV688WHKGGgYF5v4AFEiGVhBeMUrUEZLyaXfDIW6yCIMNC4o8iTa5w8c3eOMZSx
        wue/yebanpj2dk2fTlu0y6d9wgmGmH/70iPAA/6EKtHyQvd6HcbMquKZJeIuIwnAQhQ4VbIdoQ73D
        klZxchSt15j7komQ6f5rnSUlriO4+v5JJfhQu5zufV53fJ5aFhpd5C4+nLtCWLLOt90KSQsbjPYo6
        kLHpusbQ==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxw-0005Pr-BI; Sun, 27 Oct 2019 14:56:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 12/12] xfs: merge xfs_showargs into xfs_fs_show_options
Date:   Sun, 27 Oct 2019 15:55:47 +0100
Message-Id: <20191027145547.25157-13-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027145547.25157-1-hch@lst.de>
References: <20191027145547.25157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No need for a trivial wrapper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0e8942bbf840..bcb1575a5652 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -406,10 +406,10 @@ struct proc_xfs_info {
 	char		*str;
 };
 
-STATIC void
-xfs_showargs(
-	struct xfs_mount	*mp,
-	struct seq_file		*m)
+static int
+xfs_fs_show_options(
+	struct seq_file		*m,
+	struct dentry		*root)
 {
 	static struct proc_xfs_info xfs_info_set[] = {
 		/* the few simple ones we can get from the mount struct */
@@ -427,6 +427,7 @@ xfs_showargs(
 		{ XFS_MOUNT_DAX,		",dax" },
 		{ 0, NULL }
 	};
+	struct xfs_mount	*mp = XFS_M(root->d_sb);
 	struct proc_xfs_info	*xfs_infop;
 
 	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
@@ -478,6 +479,8 @@ xfs_showargs(
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
+
+	return 0;
 }
 
 static uint64_t
@@ -1378,15 +1381,6 @@ xfs_fs_unfreeze(
 	return 0;
 }
 
-STATIC int
-xfs_fs_show_options(
-	struct seq_file		*m,
-	struct dentry		*root)
-{
-	xfs_showargs(XFS_M(root->d_sb), m);
-	return 0;
-}
-
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock _has_ now been read in.
-- 
2.20.1

