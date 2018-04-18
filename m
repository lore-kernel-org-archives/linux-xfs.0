Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49210 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:40:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2b6Jc168048
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:16 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hdrxn8jkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:16 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eFwn013723
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:15 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eFdp030419
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:15 GMT
Subject: [PATCH 06/11] xfs: quota scrub should use bmapbtd scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:14 -0700
Message-ID: <152401921403.11465.9618173695298878026.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the quota scrubber's open-coded data fork scrubber with a
redirected call to the bmapbtd scrubber.  This strengthens the quota
scrub to include all the cross-referencing that it does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c |   95 ++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 1068a91..67f94c4 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -207,65 +207,78 @@ xfs_scrub_quota_item(
 	return 0;
 }
 
-/* Scrub all of a quota type's items. */
-int
-xfs_scrub_quota(
+/* Check the quota's data fork. */
+STATIC int
+xfs_scrub_quota_data_fork(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_bmbt_irec		irec = { 0 };
-	struct xfs_scrub_quota_info	sqi;
-	struct xfs_mount		*mp = sc->mp;
-	struct xfs_quotainfo		*qi = mp->m_quotainfo;
+	struct xfs_iext_cursor		icur;
+	struct xfs_scrub_metadata	fake_sm;
+	struct xfs_scrub_metadata	*real_sm = sc->sm;
+	struct xfs_quotainfo		*qi = sc->mp->m_quotainfo;
+	struct xfs_ifork		*ifp;
 	xfs_fileoff_t			max_dqid_off;
-	xfs_fileoff_t			off = 0;
-	uint				dqtype;
-	int				nimaps;
 	int				error = 0;
 
-	dqtype = xfs_scrub_quota_to_dqtype(sc);
-
-	/* Look for problem extents. */
+	/* Quotas don't live on the rt device. */
 	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
 		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
-		goto out;
+		return 0;
 	}
+
+	/* Invoke the data fork scrubber. */
+	memcpy(&fake_sm, real_sm, sizeof(fake_sm));
+	fake_sm.sm_type = XFS_SCRUB_TYPE_BMBTD;
+	fake_sm.sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	sc->sm = &fake_sm;
+	error = xfs_scrub_bmap_data(sc);
+	sc->sm = real_sm;
+	if (error)
+		return error;
+	sc->sm->sm_flags |= (fake_sm.sm_flags & XFS_SCRUB_FLAGS_OUT);
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return error;
+
+	/* Check for data fork problems that apply only to quota files. */
 	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
-	while (1) {
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xfs_scrub_should_terminate(sc, &error))
 			break;
-
-		off = irec.br_startoff + irec.br_blockcount;
-		nimaps = 1;
-		error = xfs_bmapi_read(sc->ip, off, -1, &irec, &nimaps,
-				XFS_BMAPI_ENTIRE);
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, off,
-				&error))
-			goto out;
-		if (!nimaps)
-			break;
-		if (irec.br_startblock == HOLESTARTBLOCK)
-			continue;
-
-		/* Check the extent record doesn't point to crap. */
-		if (irec.br_startblock + irec.br_blockcount <=
-		    irec.br_startblock)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
-					irec.br_startoff);
-		if (!xfs_verify_fsbno(mp, irec.br_startblock) ||
-		    !xfs_verify_fsbno(mp, irec.br_startblock +
-					irec.br_blockcount - 1))
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
-					irec.br_startoff);
-
 		/*
-		 * Unwritten extents or blocks mapped above the highest
+		 * delalloc extents or blocks mapped above the highest
 		 * quota id shouldn't happen.
 		 */
 		if (isnullstartblock(irec.br_startblock) ||
 		    irec.br_startoff > max_dqid_off ||
-		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
+		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					irec.br_startoff);
+			break;
+		}
 	}
+
+	return error;
+}
+
+/* Scrub all of a quota type's items. */
+int
+xfs_scrub_quota(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_quota_info	sqi;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_quotainfo		*qi = mp->m_quotainfo;
+	uint				dqtype;
+	int				error = 0;
+
+	dqtype = xfs_scrub_quota_to_dqtype(sc);
+
+	/* Look for problem extents. */
+	error = xfs_scrub_quota_data_fork(sc);
+	if (error)
+		goto out;
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 

