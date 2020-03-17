Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED92DC2BB1D
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB77C206EC
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="drhF4Dci"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCQTJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 15:09:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgCQTJC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 15:09:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=m63G/kxSsTYE8hCrv69pwU/zbf4nae+7p71arvDUb/c=; b=drhF4Dcipv4YHUnzqRl18CURip
        sZzt/09TBVMkbLPAU7GNxannmZ54tFe7MogCealahyn2fP2ZQk+y2qipbVDG77f2GlfgN2m9dL+dy
        37IgoVrL7sxbxueSJ4Bx4sdiy2FpnS8f6/Wu6aoxSMCH7oI7M/h2+3EQU2Nm6N11zxYsrLPH+VpC8
        40Rjwe7JJ9nR2qXCN1OgKi2ZoAIusX6DqUXLR7HaKEaq5t+wTqQgaIpOxx3bM+baEZ7Tc3hHStugF
        tYBdPktG+abd/5M1QHMNgBAcGosqHn31Eweal6Afnu416Go4Qq4wcBobZXFUtFtH/Ijr2UdQTqPlJ
        no81SMGA==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHaH-0004ff-NT; Tue, 17 Mar 2020 19:09:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 4/5] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
Date:   Tue, 17 Mar 2020 19:57:55 +0100
Message-Id: <20200317185756.1063268-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317185756.1063268-1-hch@lst.de>
References: <20200317185756.1063268-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Only v5 file systems can have the reflink feature, and those will
always use the large dinode format.  Remove the extra check for the
inode version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5a1d2b9cb05a..ad825ffa7e4c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1473,8 +1473,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
 		return -EINVAL;
 
 	if (fa->fsx_cowextsize == 0)
-- 
2.24.1

