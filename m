Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BFFC4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 049FE2072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H8vBh8WP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbgBZUZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:25:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35158 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:25:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OpgTOPfh/FXY91xlRqPpUljinbiPGBdHV/SyaavTQsk=; b=H8vBh8WPjndsRkyyOEdDCppdtg
        WyMKeVVUssTGNNoO2+wTqsu3WUMFkmoZAkfANqEN86DH42TSYR1d3qXzZjE2G/s0N8iDQpH2my9Dm
        Olyh65FlgjRIvLBqLnGTiSIovbRntCzsblnRxnZKZ2mDansDsZ5MeoUmQPjCFWL7nJ0WluRZzuFZo
        hmp7/tm638q/2OtXy8VXWM92+fr8bb0GJ/xnSCbzgU1mi5V5LIUuZzZvAl4eyMOH9ocsFT40JZXy3
        kPPNoR0YPYRwINJ42VU1hBlX87QVOpIptM6+3xUNodSu3I3bEgmRugYr+WVtE24KiN/FzTdjctD2u
        dpFZq2xw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73FK-0001Lg-Ae; Wed, 26 Feb 2020 20:25:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/32] xfs: clean up the ATTR_REPLACE checks
Date:   Wed, 26 Feb 2020 12:23:00 -0800
Message-Id: <20200226202306.871241-27-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove superflous braces, elses after return statements and use a goto
label to merge common error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3b1db2afb104..495364927ea0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,9 +423,9 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	trace_xfs_attr_sf_addname(args);
 
 	retval = xfs_attr_shortform_lookup(args);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
 		return retval;
-	} else if (retval == -EEXIST) {
+	if (retval == -EEXIST) {
 		if (args->flags & ATTR_CREATE)
 			return retval;
 		retval = xfs_attr_shortform_remove(args);
@@ -489,14 +489,11 @@ xfs_attr_leaf_addname(
 	 * the given flags produce an error or call for an atomic rename.
 	 */
 	retval = xfs_attr3_leaf_lookup_int(bp, args);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
-		xfs_trans_brelse(args->trans, bp);
-		return retval;
-	} else if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE) {	/* pure create op */
-			xfs_trans_brelse(args->trans, bp);
-			return retval;
-		}
+	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
+		goto out_brelse;
+	if (retval == -EEXIST) {
+		if (args->flags & ATTR_CREATE)	/* pure create op */
+			goto out_brelse;
 
 		trace_xfs_attr_leaf_replace(args);
 
@@ -637,6 +634,9 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 	}
 	return error;
+out_brelse:
+	xfs_trans_brelse(args->trans, bp);
+	return retval;
 }
 
 /*
@@ -763,9 +763,9 @@ xfs_attr_node_addname(
 		goto out;
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
 		goto out;
-	} else if (retval == -EEXIST) {
+	if (retval == -EEXIST) {
 		if (args->flags & ATTR_CREATE)
 			goto out;
 
-- 
2.24.1

