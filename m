Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323F4C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A462071C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N6MCqSu9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgEAIOz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgEAIOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4252DC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=YLLqktnD4kaxzrcADKhl1DKoZqrr5ItsJJbVrGGkknU=; b=N6MCqSu9YXBCi42WvKfj0a/tXf
        WGNLUadIea+M1dOPDb+vJiNUKTdM3xn13H+ob2RGZhV0vfyznpKtVItqysgUOGxuGx2CHCjbnyDEi
        aw0ebvX1rvWI23O8nYbw/PG4/E459ZvtLABX3iH360Rb2xeeEOmYfUBBSrit7w5htJ7H2qVw4J7Ek
        OPTX+QkCpN5z5uCWpOGE7d/9ab40nWGpLsP8oM8G0VdJos20VOrnkxonELzfx6OBFz8sOqOlLJOXY
        Fr7Qrgu9LfhdFW5DhF6v1EeB1ZMVIUGmxmIRHUF3YK62W82bvso06T1Ju6ovZHSSHpMlYc47vokno
        GPv2uuOw==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQow-0002xi-Ph
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: remove the NULL fork handling in xfs_bmapi_read
Date:   Fri,  1 May 2020 10:14:24 +0200
Message-Id: <20200501081424.2598914-13-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501081424.2598914-1-hch@lst.de>
References: <20200501081424.2598914-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that we fully verify the inode forks before they are added to the
inode cache, the crash reported in

  https://bugzilla.kernel.org/show_bug.cgi?id=204031

can't happen anymore, as we'll never let an inode that has inconsistent
nextents counts vs the presence of an in-core attr fork leak into the
inactivate code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 76be1a18e2442..4246f2fd5b144 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3891,7 +3891,8 @@ xfs_bmapi_read(
 	int			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp;
+	int			whichfork = xfs_bmapi_whichfork(flags);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec	got;
 	xfs_fileoff_t		obno;
 	xfs_fileoff_t		end;
@@ -3899,7 +3900,6 @@ xfs_bmapi_read(
 	int			error;
 	bool			eof = false;
 	int			n = 0;
-	int			whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
@@ -3915,21 +3915,6 @@ xfs_bmapi_read(
 
 	XFS_STATS_INC(mp, xs_blk_mapr);
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (!ifp) {
-		/*
-		 * A missing attr ifork implies that the inode says we're in
-		 * extents or btree format but failed to pass the inode fork
-		 * verifier while trying to load it.  Treat that as a file
-		 * corruption too.
-		 */
-#ifdef DEBUG
-		xfs_alert(mp, "%s: inode %llu missing fork %d",
-				__func__, ip->i_ino, whichfork);
-#endif /* DEBUG */
-		return -EFSCORRUPTED;
-	}
-
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, whichfork);
 		if (error)
-- 
2.26.2

