Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A69C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 08:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB66320643
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 08:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgEQIFS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 04:05:18 -0400
Received: from verein.lst.de ([213.95.11.211]:34287 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgEQIFS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 May 2020 04:05:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5D32A68C4E; Sun, 17 May 2020 10:05:15 +0200 (CEST)
Date:   Sun, 17 May 2020 10:05:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: clean up xchk_bmap_check_rmaps usage of
 XFS_IFORK_Q
Message-ID: <20200517080514.GC30453@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-2-hch@lst.de> <20200516184259.GI6714@magnolia> <20200516200106.GA23621@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516200106.GA23621@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 16, 2020 at 10:01:06PM +0200, Christoph Hellwig wrote:
> >  	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> > @@ -651,8 +647,9 @@ xchk_bmap(
> >  		}
> >  		break;
> >  	case XFS_ATTR_FORK:
> > +		/* No fork means no attr data at all. */
> >  		if (!ifp)
> > -			goto out_check_rmap;
> > +			goto out;
> 
> Maybe lift the !ifp to before the switch statement, or even to just after
> assigning the value to ifp?  For the data fork it obviously won't be
> true, but it still looks simple than duplicating it for the attr and
> cow fork.
> 
> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

This is what I ended up with for my tree:

---
From a98ef6f4bbfe186a83d3384cbd0a0727c0e1ddee Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 16 May 2020 11:42:59 -0700
Subject: xfs: clean up xchk_bmap_check_rmaps usage of XFS_IFORK_Q

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
 fs/xfs/scrub/bmap.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index add8598eacd5d..93d5b8a9d7f74 100644
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
@@ -717,7 +710,6 @@ xchk_bmap(
 			goto out;
 	}
 
-out_check_rmap:
 	error = xchk_bmap_check_rmaps(sc, whichfork);
 	if (!xchk_fblock_xref_process_error(sc, whichfork, 0, &error))
 		goto out;
-- 
2.26.2

