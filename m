Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9A2CA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBA1A214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aagcFgas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfJ0Oz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:55:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37556 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0Oz4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JTaj6XYcaxkhPNoyboyxA+ASdk2d2DJk+EsNV6331Io=; b=aagcFgasQFt+RY9s1Gm09xpgTw
        WgLco8flNzthtDvb79ugeBmlUJ+oeFvxBe8FkArty/Ox/CzUrgzWPLijPHwCOFr5fVeDYaCXy5kmW
        sA9BtlDcMAVMYM0bpZaOpSqL5fY9Zd5H+A9N32CJliDEU2cRgZVzyde52ouB/U/QBjBriCtxsbsat
        1c4YNpOIz4G3wjJfWwzKLMg/BS2Wdiu9vpiUne182KyGUNa7YTCA7IJhNodg0LmK0ElJahmApZ3tR
        ZBfkf4LakZKT8MeUEfF36h0ephizwQiCClMM2P/Go3faqT1uKkiexkTzedP5D8ywvPJxEd9K/cbOg
        A3xiGfZg==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxT-0005Ll-Ih; Sun, 27 Oct 2019 14:55:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/12] xfs: remove the dsunit and dswidth variables in xfs_parseargs
Date:   Sun, 27 Oct 2019 15:55:37 +0100
Message-Id: <20191027145547.25157-3-hch@lst.de>
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

There is no real need for the local variables here - either they
are applied to the mount structure, or if the noalign mount option
is set the mount will fail entirely if either is set.  Removing
them helps cleaning up the mount API conversion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_super.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 589c080cabfe..4089de3daded 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -159,8 +159,6 @@ xfs_parseargs(
 	const struct super_block *sb = mp->m_super;
 	char			*p;
 	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
 	int			iosize = 0;
 	uint8_t			iosizelog = 0;
 
@@ -252,11 +250,11 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_SWALLOC;
 			break;
 		case Opt_sunit:
-			if (match_int(args, &dsunit))
+			if (match_int(args, &mp->m_dalign))
 				return -EINVAL;
 			break;
 		case Opt_swidth:
-			if (match_int(args, &dswidth))
+			if (match_int(args, &mp->m_swidth))
 				return -EINVAL;
 			break;
 		case Opt_inode32:
@@ -350,7 +348,8 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
+	    (mp->m_dalign || mp->m_swidth)) {
 		xfs_warn(mp,
 	"sunit and swidth options incompatible with the noalign option");
 		return -EINVAL;
@@ -363,30 +362,20 @@ xfs_parseargs(
 	}
 #endif
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
+	if ((mp->m_dalign && !mp->m_swidth) ||
+	    (!mp->m_dalign && mp->m_swidth)) {
 		xfs_warn(mp, "sunit and swidth must be specified together");
 		return -EINVAL;
 	}
 
-	if (dsunit && (dswidth % dsunit != 0)) {
+	if (mp->m_dalign && (mp->m_swidth % mp->m_dalign != 0)) {
 		xfs_warn(mp,
 	"stripe width (%d) must be a multiple of the stripe unit (%d)",
-			dswidth, dsunit);
+			mp->m_swidth, mp->m_dalign);
 		return -EINVAL;
 	}
 
 done:
-	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
-		/*
-		 * At this point the superblock has not been read
-		 * in, therefore we do not know the block size.
-		 * Before the mount call ends we will convert
-		 * these to FSBs.
-		 */
-		mp->m_dalign = dsunit;
-		mp->m_swidth = dswidth;
-	}
-
 	if (mp->m_logbufs != -1 &&
 	    mp->m_logbufs != 0 &&
 	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
-- 
2.20.1

