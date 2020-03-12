Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365C4C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 019942067C
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WFCX8RBX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCLOWs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:22:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbgCLOWs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=yMyCUi7jm4HgBG/N4uiwmW+lqLVNd4YrWMinJO7czzU=; b=WFCX8RBXLibhUnBcd27MGCNJBz
        6WyBlMD/f5WeKM2DoglOtJLEQyhdJfWdrw622H+gpwhrFa7Sx+FMuI+8d+E8G3yGecKbGtzSiVl6O
        067eedX2Lt+Dl70bncrCXvixYyGHa3AsGjwRQG4rkhudMGvFuxuFTlCfFCIC5wgATOAHmqF1GTYvO
        Lnn40XFdo5c8GB/2pRciQo19smeXN3KUpz+ZsIWLKA38w6hiom9+VjBS9XZsIpXBgEHyLJ3YJsZMH
        iTa6bM/63wqK8wnv7SFVm1aXxLAV2FSfSv7i1BMhVRbKXMNL6zjXanNsnIDrNwTIbGhu7/qol02E5
        k02GQDsA==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOjX-0003jF-NP
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:22:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: simplify di_flags2 inheritance in xfs_ialloc
Date:   Thu, 12 Mar 2020 15:22:34 +0100
Message-Id: <20200312142235.550766-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312142235.550766-1-hch@lst.de>
References: <20200312142235.550766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

di_flags2 is initialized to zero for v4 and earlier file systems.  This
means di_flags2 can only be non-zero for a v5 file systems, in which
case both the parent and child inodes can store the filed.  Remove the
extra di_version check, and also remove the rather pointless local
di_flags2 variable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index addc3ee0cb73..ebfd8efb0efa 100644
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

