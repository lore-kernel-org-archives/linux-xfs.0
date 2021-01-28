Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4F4C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4B664DE0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhA1GBz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhA1GBy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:01:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A337864DD8;
        Thu, 28 Jan 2021 06:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813673;
        bh=0RBRZ5HyilgkUx0k9CH+HmqaLC3fmXBlJFacKpKuWn8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DO01Ch7y3n0YYfhxCzww6gAD/08nk7i9cWExIdSG6wQ50h1XrtWIv2VjHh2rUSnDB
         5YluZd2OaiPIXgNp4mogmazK8zkv9+m8mc6mGOMjyycvqi0TlhKn2UqxgE7d/AkDBn
         2cbG6nv6kk6ufuO5eNJnWRaFX29nEmZI9eYGuXr07ARDAi1TGR4h0iDkhxky417zyM
         OyA5/xcIGfVgJFcsv8rD5pUfgZp3Sm+a1SFEmYKXuqWLwmUMjfy3SNawn8r0O+nTEh
         SFIOLGDU/MyhzFcsyMYBvTwFr+AMnhTA/iUqF1zXCp+2UF3CFqA7iX47yT7dTqEVId
         FtVxas30cAAXA==
Subject: [PATCH 01/13] xfs: clean up quota reservation callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:01:09 -0800
Message-ID: <161181366986.1523592.179804371678683555.stgit@magnolia>
In-Reply-To: <161181366379.1523592.9213241916555622577.stgit@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert a few xfs_trans_*reserve* callsites that are open-coding other
convenience functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    3 +--
 fs/xfs/xfs_bmap_util.c   |    4 ++--
 fs/xfs/xfs_reflink.c     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ba56554e8c05..0410627c6fcc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4937,8 +4937,7 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_trans_reserve_quota_nblks(NULL, ip,
-			-((long)del->br_blockcount), 0,
+	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
 			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f3f8c48ff5bf..792809debaaa 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -884,8 +884,8 @@ xfs_unmap_extent(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot, ip->i_gdquot,
-			ip->i_pdquot, resblks, 0, XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e1c98dbf79e4..183142fd0961 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -508,8 +508,8 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_trans_reserve_quota_nblks(NULL, ip,
-					-(long)del.br_blockcount, 0,
+			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
+					del.br_blockcount, 0,
 					XFS_QMOPT_RES_REGBLKS);
 			if (error)
 				break;

