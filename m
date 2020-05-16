Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723B2C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D346207BB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kqedbKmc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgEPSnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 14:43:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45488 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgEPSnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 14:43:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GIbdx8123765;
        Sat, 16 May 2020 18:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cnVivOO3lOu/fWuKKy4oHChhfcd5Kb5H0+FvvKeiwTM=;
 b=kqedbKmcoQxeGPkkvbSpXytYlFmGGJ210/Tv3lfnIEvhKIlcDjvYAHtZBU+Q/9JRyMmo
 SmwHpZR/2DlZGnC9Jn+gPee+DFkhTFQEDYbo1/lrC+VS94xoUqpkaXB7YxXPPm5AY2w0
 C2z7lBmUY82rkvbnwi2RGOUmB/1jwdTqJexcDZIFqGJHJukNWeOfu/jLkmHwNTxBkmRx
 2rQmz+efb2vfJHolZl9ux0fpT53TCI0RVNDzjuf6gMkw7HSUPEN53+GIxVTZjYaXk1Jq
 LQGcQZxoNIM0xeoWqXHwVqkOE1sB51+XnJNfrDlNybdn4D5OVJVHkfCW85MUU/OA63oK cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3128tn1e19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 18:43:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GIcG0d106488;
        Sat, 16 May 2020 18:43:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 312679ek9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 18:43:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GIh2Ja029098;
        Sat, 16 May 2020 18:43:02 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 11:43:02 -0700
Date:   Sat, 16 May 2020 11:42:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: clean up xchk_bmap_check_rmaps usage of XFS_IFORK_Q
Message-ID: <20200516184259.GI6714@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510072404.986627-2-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS_IFORK_Q is supposed to be a predicate, not a function returning a
value.  Its usage is in xchk_bmap_check_rmaps is incorrect, but that
function only cares about whether or not the "size" of the data is zero
or not.  Convert that logic to use a proper boolean, and teach the
caller to skip the call entirely if the end result would be that we'd do
nothing anyway.  This avoids a crash later in this series.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index add8598eacd5..002f10944de7 100644
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
@@ -651,8 +647,9 @@ xchk_bmap(
 		}
 		break;
 	case XFS_ATTR_FORK:
+		/* No fork means no attr data at all. */
 		if (!ifp)
-			goto out_check_rmap;
+			goto out;
 		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
 		    !xfs_sb_version_hasattr2(&mp->m_sb))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
@@ -717,7 +714,6 @@ xchk_bmap(
 			goto out;
 	}
 
-out_check_rmap:
 	error = xchk_bmap_check_rmaps(sc, whichfork);
 	if (!xchk_fblock_xref_process_error(sc, whichfork, 0, &error))
 		goto out;
