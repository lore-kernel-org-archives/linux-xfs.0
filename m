Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67FBC3A59D
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 02:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D79E21019
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 02:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hgLkPVOA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfHQCGy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 22:06:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52342 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfHQCGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 22:06:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H243su022922
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2019 02:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=iPoE6kDLq8B/Al/oQssxWALhE4tnDZ82NzXl6629WzA=;
 b=hgLkPVOA/GBerjqlqbRklxzTfWxTIgxpGF5GZPjZ3TEhPqKfIU1mINay2o19sC57vkTR
 lZvUsqpUI0Th5mkRa/4hP/Fx45p/ZBsrntKJ2tkHzqBwvC5/TCLiZahVc9kKdOjtEUPN
 Z9Zqhx43C2HZsOpnwNQSiSVjSRx+TTTZsF3lo8TCoo8D0TTg7+6J9+FqoxH7XWgUyf3e
 WVlRVtsDPlufhQqCyuXEZbTEy9yZ9+jcyuysznZJ3cfu8h4l1D/4EzFIM3crFrghHjbR
 0wgXS6EiPJp4SPn8tY3AINtEs1RSpNnNo9N4jAmQe4YiriMLI1RyJmRFQdq5pqrsxIjU Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjr385r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2019 02:06:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H22xJ6147222
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2019 02:06:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2udgqgs54n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2019 02:06:52 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7H26q08002561
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2019 02:06:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 19:06:51 -0700
Date:   Fri, 16 Aug 2019 19:06:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: bmap scrub should only scrub records once
Message-ID: <20190817020651.GH752159@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908170020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908170020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The inode block mapping scrub function does more work for btree format
extent maps than is absolutely necessary -- first it will walk the bmbt
and check all the entries, and then it will load the incore tree and
check every entry in that tree.

Reduce the run time of the ondisk bmbt walk if the incore tree is loaded
by checking that the incore tree has an exact match for the bmbt extent.
Similarly, skip the incore tree walk if we have to load it from the
bmbt, since we just checked that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |   40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 1bd29fdc2ab5..6170736fa94f 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -384,6 +384,7 @@ xchk_bmapbt_rec(
 	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_btree_block	*block;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
 	uint64_t		owner;
 	int			i;
 
@@ -402,8 +403,30 @@ xchk_bmapbt_rec(
 		}
 	}
 
-	/* Set up the in-core record and scrub it. */
+	/*
+	 * If the incore bmap cache is already loaded, check that it contains
+	 * an extent that matches this one exactly.  We validate those cached
+	 * bmaps later, so we don't need to check here.
+	 *
+	 * If the cache is /not/ loaded, we need to validate the bmbt records
+	 * now.
+	 */
 	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+        if (ifp->if_flags & XFS_IFEXTENTS) {
+		struct xfs_bmbt_irec	iext_irec;
+		struct xfs_iext_cursor	icur;
+
+		if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
+					&iext_irec) ||
+		    irec.br_startoff != iext_irec.br_startoff ||
+		    irec.br_startblock != iext_irec.br_startblock ||
+		    irec.br_blockcount != iext_irec.br_blockcount ||
+		    irec.br_state != iext_irec.br_state)
+			xchk_fblock_set_corrupt(bs->sc, info->whichfork,
+					irec.br_startoff);
+		return 0;
+	}
+
 	return xchk_bmap_extent(ip, bs->cur, info, &irec);
 }
 
@@ -671,11 +694,22 @@ xchk_bmap(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
-	/* Now try to scrub the in-memory extent list. */
+	/*
+	 * If the incore bmap cache isn't loaded, then this inode has a bmap
+	 * btree and we already walked it to check all of the mappings.  Load
+	 * the cache now and skip ahead to rmap checking (which requires the
+	 * bmap cache to be loaded).  We don't need to check twice.
+	 *
+	 * If the cache /is/ loaded, then we haven't checked any mappings, so
+	 * iterate the incore cache and check the mappings now, because the
+	 * bmbt iteration code skipped the checks, assuming that we'd do them
+	 * here.
+	 */
         if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(sc->tp, ip, whichfork);
 		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
 			goto out;
+		goto out_check_rmap;
 	}
 
 	/* Find the offset of the last extent in the mapping. */
@@ -689,7 +723,7 @@ xchk_bmap(
 	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
-			break;
+			goto out;
 		if (isnullstartblock(irec.br_startblock))
 			continue;
 		if (irec.br_startoff >= endoff) {
