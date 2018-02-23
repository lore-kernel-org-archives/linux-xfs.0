Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWCGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:06:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N21nbI069911
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:06:00 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ga9bpg2js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:06:00 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N210fk019470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:00 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1N20xuH005885
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:00 GMT
Subject: [PATCH 5/8] xfs: inode scrubber shouldn't bother with raw checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:00:58 -0800
Message-ID: <151935125879.21842.10380711479854109278.stgit@magnolia>
In-Reply-To: <151935122813.21842.14996049216693190946.stgit@magnolia>
References: <151935122813.21842.14996049216693190946.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The inode scrubber tries to _iget the inode prior to running checks.
If that _iget call fails with corruption errors that's an automatic
fail, regardless of whether it was the inode buffer read verifier,
the ifork verifier, or the ifork formatter that errored out.

Therefore, get rid of the raw mode scrub code because it's not needed.
Found by trying to fix some test failures in xfs/379 and xfs/415.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c |   98 +++++---------------------------------------------
 1 file changed, 9 insertions(+), 89 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 21297be..0332a01 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -515,72 +515,6 @@ xfs_scrub_dinode(
 	}
 }
 
-/* Map and read a raw inode. */
-STATIC int
-xfs_scrub_inode_map_raw(
-	struct xfs_scrub_context	*sc,
-	xfs_ino_t			ino,
-	struct xfs_buf			**bpp,
-	struct xfs_dinode		**dipp)
-{
-	struct xfs_imap			imap;
-	struct xfs_mount		*mp = sc->mp;
-	struct xfs_buf			*bp = NULL;
-	struct xfs_dinode		*dip;
-	int				error;
-
-	error = xfs_imap(mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
-	if (error == -EINVAL) {
-		/*
-		 * Inode could have gotten deleted out from under us;
-		 * just forget about it.
-		 */
-		error = -ENOENT;
-		goto out;
-	}
-	if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
-			XFS_INO_TO_AGBNO(mp, ino), &error))
-		goto out;
-
-	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
-			NULL);
-	if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
-			XFS_INO_TO_AGBNO(mp, ino), &error))
-		goto out;
-
-	/*
-	 * Is this really an inode?  We disabled verifiers in the above
-	 * xfs_trans_read_buf call because the inode buffer verifier
-	 * fails on /any/ inode record in the inode cluster with a bad
-	 * magic or version number, not just the one that we're
-	 * checking.  Therefore, grab the buffer unconditionally, attach
-	 * the inode verifiers by hand, and run the inode verifier only
-	 * on the one inode we want.
-	 */
-	bp->b_ops = &xfs_inode_buf_ops;
-	dip = xfs_buf_offset(bp, imap.im_boffset);
-	if (xfs_dinode_verify(mp, ino, dip) != NULL ||
-	    !xfs_dinode_good_version(mp, dip->di_version)) {
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
-		goto out_buf;
-	}
-
-	/* ...and is it the one we asked for? */
-	if (be32_to_cpu(dip->di_gen) != sc->sm->sm_gen) {
-		error = -ENOENT;
-		goto out_buf;
-	}
-
-	*dipp = dip;
-	*bpp = bp;
-out:
-	return error;
-out_buf:
-	xfs_trans_brelse(sc->tp, bp);
-	return error;
-}
-
 /*
  * Make sure the finobt doesn't think this inode is free.
  * We don't have to check the inobt ourselves because we got the inode via
@@ -727,43 +661,29 @@ xfs_scrub_inode(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_dinode		di;
-	struct xfs_buf			*bp = NULL;
-	struct xfs_dinode		*dip;
-	xfs_ino_t			ino;
 	int				error = 0;
 
-	/* Did we get the in-core inode, or are we doing this manually? */
-	if (sc->ip) {
-		ino = sc->ip->i_ino;
-		xfs_inode_to_disk(sc->ip, &di, 0);
-		dip = &di;
-	} else {
-		/* Map & read inode. */
-		ino = sc->sm->sm_ino;
-		error = xfs_scrub_inode_map_raw(sc, ino, &bp, &dip);
-		if (error || !bp)
-			goto out;
+	/* iget failed means automatic fail. */
+	if (!sc->ip) {
+		xfs_scrub_ino_set_corrupt(sc, sc->sm->sm_ino, NULL);
+		return 0;
 	}
 
-	xfs_scrub_dinode(sc, bp, dip, ino);
+	/* Scrub the inode core. */
+	xfs_inode_to_disk(sc->ip, &di, 0);
+	xfs_scrub_dinode(sc, NULL, &di, sc->ip->i_ino);
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
-	/* Now let's do the things that require a live inode. */
-	if (!sc->ip)
-		goto out;
-
 	/*
 	 * Look for discrepancies between file's data blocks and the reflink
 	 * iflag.  We already checked the iflag against the file mode when
 	 * we scrubbed the dinode.
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
-		xfs_scrub_inode_check_reflink_iflag(sc, ino, bp);
+		xfs_scrub_inode_check_reflink_iflag(sc, sc->ip->i_ino, NULL);
 
-	xfs_scrub_inode_xref(sc, ino, dip);
+	xfs_scrub_inode_xref(sc, sc->ip->i_ino, &di);
 out:
-	if (bp)
-		xfs_trans_brelse(sc->tp, bp);
 	return error;
 }

