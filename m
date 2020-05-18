Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB278C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F7E207D8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XD8IWAAt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgERHeF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 03:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgERHeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 03:34:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EC2C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 00:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bi49TcrB3Lakyg89lihmwYrLki43wRaGo0o3rnDfjCU=; b=XD8IWAAtxipkORYwgKIO0d+STv
        EmpZH+K3CHX0L1uJapcLkZxlVM2xcZIEbUYjxsLnglPRA+cYouRnN3+DKY91fyJte9tq+oce5W2Qp
        wsOp86FhpfmpeZXb7TNJoFC1TedZXvjgVxjPVQWILZ5yxXxkpYKcCXGtecyt/W4a8WyTha1GqIVA2
        /Zuemt2HU0B9Plhx4CM7MYwNRrwGZB958TfXfhSZg+P9u6bK21HlT1ejEV1kTdCLwUhGQKvUiWLty
        F3f/K/kcVqg46sa5o7mCCEdxa7h88cC/g2SBRS126D+V79PZfkwrzsspkNotg8iz6rzOG+bbT+JG+
        MEu34Qqw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaaHk-0002q9-Dl; Mon, 18 May 2020 07:34:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/6] xfs: clean up xchk_bmap_check_rmaps usage of XFS_IFORK_Q
Date:   Mon, 18 May 2020 09:33:53 +0200
Message-Id: <20200518073358.760214-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518073358.760214-1-hch@lst.de>
References: <20200518073358.760214-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

XFS_IFORK_Q is supposed to be a predicate, not a function returning a
value.  Its usage is in xchk_bmap_check_rmaps is incorrect, but that
function only cares about whether or not the "size" of the data is zero
or not.  Convert that logic to use a proper boolean, and teach the
caller to skip the call entirely if the end result would be that we'd do
nothing anyway.  This avoids a crash later in this series.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: generalized the NULL ifor check]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index add8598eacd5d..d0daf3de9fde5 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -566,8 +566,8 @@ xchk_bmap_check_rmaps(
 	struct xfs_scrub	*sc,
 	int			whichfork)
 {
-	loff_t			size;
 	xfs_agnumber_t		agno;
+	bool			zero_size;
 	int			error;
 
 	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb) ||
@@ -579,6 +579,8 @@ xchk_bmap_check_rmaps(
 	if (XFS_IS_REALTIME_INODE(sc->ip) && whichfork == XFS_DATA_FORK)
 		return 0;
 
+	ASSERT(XFS_IFORK_PTR(sc->ip, whichfork) != NULL);
+
 	/*
 	 * Only do this for complex maps that are in btree format, or for
 	 * situations where we would seem to have a size but zero extents.
@@ -586,19 +588,13 @@ xchk_bmap_check_rmaps(
 	 * to flag this bmap as corrupt if there are rmaps that need to be
 	 * reattached.
 	 */
-	switch (whichfork) {
-	case XFS_DATA_FORK:
-		size = i_size_read(VFS_I(sc->ip));
-		break;
-	case XFS_ATTR_FORK:
-		size = XFS_IFORK_Q(sc->ip);
-		break;
-	default:
-		size = 0;
-		break;
-	}
+	if (whichfork == XFS_DATA_FORK)
+		zero_size = i_size_read(VFS_I(sc->ip)) == 0;
+	else
+		zero_size = false;
+
 	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    (size == 0 || XFS_IFORK_NEXTENTS(sc->ip, whichfork) > 0))
+	    (zero_size || XFS_IFORK_NEXTENTS(sc->ip, whichfork) > 0))
 		return 0;
 
 	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
@@ -627,12 +623,14 @@ xchk_bmap(
 	struct xchk_bmap_info	info = { NULL };
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_inode	*ip = sc->ip;
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		endoff;
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	/* Non-existent forks can be ignored. */
+	if (!ifp)
+		goto out;
 
 	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
 	info.whichfork = whichfork;
@@ -641,9 +639,6 @@ xchk_bmap(
 
 	switch (whichfork) {
 	case XFS_COW_FORK:
-		/* Non-existent CoW forks are ignorable. */
-		if (!ifp)
-			goto out;
 		/* No CoW forks on non-reflink inodes/filesystems. */
 		if (!xfs_is_reflink_inode(ip)) {
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
@@ -651,8 +646,6 @@ xchk_bmap(
 		}
 		break;
 	case XFS_ATTR_FORK:
-		if (!ifp)
-			goto out_check_rmap;
 		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
 		    !xfs_sb_version_hasattr2(&mp->m_sb))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
@@ -700,7 +693,6 @@ xchk_bmap(
 
 	/* Scrub extent records. */
 	info.lastoff = 0;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
 	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
@@ -717,7 +709,6 @@ xchk_bmap(
 			goto out;
 	}
 
-out_check_rmap:
 	error = xchk_bmap_check_rmaps(sc, whichfork);
 	if (!xchk_fblock_xref_process_error(sc, whichfork, 0, &error))
 		goto out;
-- 
2.26.2

