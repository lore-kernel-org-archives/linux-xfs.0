Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84948C1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5049A20752
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:06:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yg9hYRze"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgCQTGt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 15:06:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57360 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQTGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 15:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lEQCS93+mpR6fCtUb/uKmpWPoU4p/88Ioq9y8tTKrag=; b=Yg9hYRzeNYTbztF5qA2GAf5qBZ
        HS8lYH33VYp6BNDdGdKYhbHC3mmkvexN3/oI/qYtgWAU77+IesDI+dLgthOJx0Ea1za3hA4IWNYJ2
        Bok1I1rIEEnEIFZ0ttAsnlfMUN+X7DN3crJWJ1itsNM3ILjO/D9TI7FaDmT3zIBLkmYb0wAzlFyUd
        99uKdeVIoUr1fs0Xs/z0+vy8/V5hrd4YQu4RkHvgs18vbUcF/rTpHwnPMitJ0cANZWJqhGfAVFJ83
        PlIvoVkJqkOPl0Tbpx9545+CGHje6XGbNav69ViY9i/wWanfTyfFVsT9ycBkXGv0GI42Z4QH6m5DU
        amvlSzaQ==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHY8-0004Y3-Ib; Tue, 17 Mar 2020 19:06:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 3/5] xfs: simplify di_flags2 inheritance in xfs_ialloc
Date:   Tue, 17 Mar 2020 19:57:54 +0100
Message-Id: <20200317185756.1063268-4-hch@lst.de>
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

di_flags2 is initialized to zero for v4 and earlier file systems.  This
means di_flags2 can only be non-zero for a v5 file systems, in which
case both the parent and child inodes can store the field.  Remove the
extra di_version check, and also remove the rather pointless local
di_flags2 variable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_inode.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d65d2509d5e0..dfb0a452a87d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -907,20 +907,13 @@ xfs_ialloc(
 
 			ip->i_d.di_flags |= di_flags;
 		}
-		if (pip &&
-		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
-		    pip->i_d.di_version == 3 &&
-		    ip->i_d.di_version == 3) {
-			uint64_t	di_flags2 = 0;
-
+		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
 			}
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				di_flags2 |= XFS_DIFLAG2_DAX;
-
-			ip->i_d.di_flags2 |= di_flags2;
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
-- 
2.24.1

