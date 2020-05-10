Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A30C54E8A
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F3520731
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="spDXbHYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgEJHYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:24:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F320CC061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=6/JLRqXeEe8d2+EUBG/nnNZO56yjjBd9N85bsQ2y7IU=; b=spDXbHYNKX3pymgQvxFyXGY868
        sFnoCQdtfyqgS2H+oEIdRPOR6q+1mNo0Y8skYjzffpVdDdLXmC9HtydZSZNjBUvyaCkMmdQCCD/Cd
        a5t/J0p5CGNnhomTFlBEO2Gcvn9X5fcoVeaQid1nJacGhguu9l+zgxj36pBXD3/i9O+tbtilWCFWy
        neEAZv0fjvP8OvcwJxOPqQrDrlBxhrso45UpcGAIok67l18M3fmveKF9PtyN6E96C3+FRL1Z6zUyV
        4ATzIe9Ao+wsqDNjK2kegbr5UXWYAWJOj2hT4fWgrQYBwey9qlSjGvZtHHyFn6S6AnIrxgRkeQAR0
        GWnN6m8Q==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgJo-0004vB-Fi
        for linux-xfs@vger.kernel.org; Sun, 10 May 2020 07:24:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: remove the XFS_DFORK_Q macro
Date:   Sun, 10 May 2020 09:24:00 +0200
Message-Id: <20200510072404.986627-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200510072404.986627-1-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just checking di_forkoff directly is a little easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h    | 5 ++---
 fs/xfs/libxfs/xfs_inode_buf.c | 6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 045556e78ee2c..3cc352000b8a1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -964,13 +964,12 @@ enum xfs_dinode_fmt {
 /*
  * Inode data & attribute fork sizes, per inode.
  */
-#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
 #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
+	((dip)->di_forkoff ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
 #define XFS_DFORK_ASIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
+	((dip)->di_forkoff ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_DFORK_DSIZE(dip, mp) : \
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 05f939adea944..5547bbb3cf945 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -265,7 +265,7 @@ xfs_inode_from_disk(
 	error = xfs_iformat_data_fork(ip, from);
 	if (error)
 		return error;
-	if (XFS_DFORK_Q(from)) {
+	if (from->di_forkoff) {
 		error = xfs_iformat_attr_fork(ip, from);
 		if (error)
 			goto out_destroy_data_fork;
@@ -435,7 +435,7 @@ xfs_dinode_verify_forkoff(
 	struct xfs_dinode	*dip,
 	struct xfs_mount	*mp)
 {
-	if (!XFS_DFORK_Q(dip))
+	if (!dip->di_forkoff)
 		return NULL;
 
 	switch (dip->di_format)  {
@@ -538,7 +538,7 @@ xfs_dinode_verify(
 		return __this_address;
 	}
 
-	if (XFS_DFORK_Q(dip)) {
+	if (dip->di_forkoff) {
 		fa = xfs_dinode_verify_fork(dip, mp, XFS_ATTR_FORK);
 		if (fa)
 			return fa;
-- 
2.26.2

