Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02111C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 20:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2E7520719
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 20:18:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HJFI7b4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgJBUSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 16:18:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgJBUSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 16:18:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092KDn9Y039134;
        Fri, 2 Oct 2020 20:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=IEL5XIh4SiW3SMpgBncyZxukrFrLGz0cNvjny1W2xPA=;
 b=HJFI7b4puVU60KaKAdqMsNulZUARvVLICRlyfpLYA1tXoaCjbrIKLFmZsZnzgiaqOhBa
 /RlO8KzyRYi6JqTK5jU9eMAKxdZ3nLtyL8+SaPQaFvyfOEhsXFTK39BHkPTKJipf0bhP
 r7+ehgT00Cal3o6l9LBCqryalhAC5CC41vg8+DvBi5aCswSBetCclvwyNM4cn0xXIAc/
 A65ozZYIrRaqnfgKgWhg+62ojK98jStUkeGUio6N7ukUrxWGvpATCMJnNPkkJzZ/epkh
 NjADVfSL/MjoP37fW0oO5/cn6JDJPQKOZEey/TPXLDbldjdUG4C2YUMIkn6DWgi5GiHT Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkmcrug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 20:18:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092KFtA5151563;
        Fri, 2 Oct 2020 20:18:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33tfk40aqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 20:18:33 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092KIWZt002376;
        Fri, 2 Oct 2020 20:18:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 13:18:32 -0700
Date:   Fri, 2 Oct 2020 13:18:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs_repair: coordinate parallel updates to the rt bitmap
Message-ID: <20201002201831.GA49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020147
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually take the rt lock before updating the bitmap from multiple
threads.  This fixes an infrequent corruption problem when running
generic/013 and rtinherit=1 is set on the root dir.

Fixes: 2556c98bd9e6 ("Perform true sequential bulk read prefetching in xfs_repair Merge of master-melb:xfs-cmds:29147a by kenmcd.")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix review comments per hch
---
 repair/dinode.c  |   16 ++++++++--------
 repair/globals.c |    1 +
 repair/globals.h |    1 +
 repair/incore.c  |    1 +
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index f65a614702fd..c89f21e08373 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -323,6 +323,7 @@ process_bmbt_reclist_int(
 	xfs_extlen_t		blen;
 	xfs_agnumber_t		locked_agno = -1;
 	int			error = 1;
+	int			error2;
 
 	if (type == XR_INO_RTDATA)
 		ftype = ftype_real_time;
@@ -383,14 +384,14 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 		}
 
 		if (type == XR_INO_RTDATA && whichfork == XFS_DATA_FORK) {
+			pthread_mutex_lock(&rt_lock.lock);
+			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups);
+			pthread_mutex_unlock(&rt_lock.lock);
+			if (error2)
+				return error2;
+
 			/*
-			 * realtime bitmaps don't use AG locks, so returning
-			 * immediately is fine for this code path.
-			 */
-			if (process_rt_rec(mp, &irec, ino, tot, check_dups))
-				return 1;
-			/*
-			 * skip rest of loop processing since that'irec.br_startblock
+			 * skip rest of loop processing since the rest is
 			 * all for regular file forks and attr forks
 			 */
 			continue;
@@ -442,7 +443,6 @@ _("inode %" PRIu64 " - extent exceeds max offset - start %" PRIu64 ", "
 		}
 
 		if (blkmapp && *blkmapp) {
-			int	error2;
 			error2 = blkmap_set_ext(blkmapp, irec.br_startoff,
 					irec.br_startblock, irec.br_blockcount);
 			if (error2) {
diff --git a/repair/globals.c b/repair/globals.c
index 299bacd13132..110d98b6681e 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -110,6 +110,7 @@ uint32_t	sb_unit;
 uint32_t	sb_width;
 
 struct aglock	*ag_locks;
+struct aglock	rt_lock;
 
 int		report_interval;
 uint64_t	*prog_rpt_done;
diff --git a/repair/globals.h b/repair/globals.h
index 953e3dfbb4f2..1d397b351276 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -154,6 +154,7 @@ struct aglock {
 	pthread_mutex_t	lock __attribute__((__aligned__(64)));
 };
 extern struct aglock	*ag_locks;
+extern struct aglock	rt_lock;
 
 extern int		report_interval;
 extern uint64_t		*prog_rpt_done;
diff --git a/repair/incore.c b/repair/incore.c
index 1374ddefe06e..4ffe18aba839 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -290,6 +290,7 @@ init_bmaps(xfs_mount_t *mp)
 		btree_init(&ag_bmap[i]);
 		pthread_mutex_init(&ag_locks[i].lock, NULL);
 	}
+	pthread_mutex_init(&rt_lock.lock, NULL);
 
 	init_rt_bmap(mp);
 	reset_bmaps(mp);
