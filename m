Return-Path: <SRS0=FSF3=YN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4ABCA9EA9
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 08:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 108A521928
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 08:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u15VhEV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfJTIV4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Oct 2019 04:21:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45844 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTIV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Oct 2019 04:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Zm2klC2elFQpqGjh37V2IiRLP0ADr3jKrUn50d0ZPTk=; b=u15VhEV7M6aIkWmg/ZX0/o3aO
        +Tn1G5S8suDaMunh6jsW19RqfJH0atepebdRSqQLTsPGpnZK0o8ujYAz4xXJNoKGWhhnikGgVJ8QE
        AW9aGl+mTVn2F00r4caLVvmh8U3eJIZNSyQNLQ+k7D8WJgupWczNzTXf6x7clIhZlj5T9djF7uoqS
        8UEa211jsmhvWTsJNLkx400jyQ3bvtTuoempN+FranIpNKFFe3YGiJQMjSZLNsi/q2fr9KfRVAyZ6
        mBoQy0UKXcMqaHjdzp+jt8wqJyx/fTDrTDai3RcLsYZVTXZzpjmnVpsLPgOvwvr2+y93QiOW7F98b
        eX708lDOQ==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iM6TL-0004e1-QK
        for linux-xfs@vger.kernel.org; Sun, 20 Oct 2019 08:21:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: don't reset the "inode core" in xfs_iread
Date:   Sun, 20 Oct 2019 10:21:44 +0200
Message-Id: <20191020082145.32515-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191020082145.32515-1-hch@lst.de>
References: <20191020082145.32515-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We have the exact same memset in xfs_inode_alloc, which is always called
just before xfs_iread.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 019c9be677cc..8afacfe4be0a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -631,8 +631,6 @@ xfs_iread(
 	if ((iget_flags & XFS_IGET_CREATE) &&
 	    xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
-		/* initialise the on-disk inode core */
-		memset(&ip->i_d, 0, sizeof(ip->i_d));
 		VFS_I(ip)->i_generation = prandom_u32();
 		ip->i_d.di_version = 3;
 		return 0;
-- 
2.20.1

