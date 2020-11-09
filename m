Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C08C388F7
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EC452068D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ybk9PBCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgKISR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:17:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKISR5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:17:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9I9Tiq113117;
        Mon, 9 Nov 2020 18:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LAHeBL8VavGGkUppb9tWEnlqFsTx11pgkS2t316R7tg=;
 b=ybk9PBCzPR4QxzwKK7/J6LgrRltsC9uilUO+FyNamn+ZlZGKj0IqFuGIyetLKYjaVaut
 6CpGYWrZjvJJitFAnD5BHNm2AvEEYvbl4WltVT6Gd/0q+6acfAU2cF9YjffD6RMe3TrV
 hUrsmJHqiqA0MO2KSpmBcurtxfZhKsn82flFxHsvoxUlr+LU9Oway25xkG+3KJ/8Buky
 LOcvGrmjoGVpa5j+A9oqyuWtDNcyILetoTDAK520+9UlzYuKGrXqF5rRIelECYtjXHx2
 QuG27zz8hh3/bjVro/vlSZPatqu1S+OMo7MXZW0WMeBdx7Anyu+Qm5k7H6CJ/AziTOuV jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72edmy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:17:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IB1mb136746;
        Mon, 9 Nov 2020 18:17:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34p5bqv1w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A9IHqHP020111;
        Mon, 9 Nov 2020 18:17:52 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:52 -0800
Subject: [PATCH 3/4] xfs: strengthen rmap record flags checking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:51 -0800
Message-ID: <160494587178.772802.7759758846362664950.stgit@magnolia>
In-Reply-To: <160494585293.772802.13326482733013279072.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We always know the correct state of the rmap record flags (attr, bmbt,
unwritten) so check them by direct comparison.

Fixes: d852657ccfc0 ("xfs: cross-reference reverse-mapping btree")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 412e2ec55e38..fed56d213a3f 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -218,13 +218,13 @@ xchk_bmap_xref_rmap(
 	 * which doesn't track unwritten state.
 	 */
 	if (owner != XFS_RMAP_OWN_COW &&
-	    irec->br_state == XFS_EXT_UNWRITTEN &&
-	    !(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
+	    !!(irec->br_state == XFS_EXT_UNWRITTEN) !=
+	    !!(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
-	if (info->whichfork == XFS_ATTR_FORK &&
-	    !(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
+	if (!!(info->whichfork == XFS_ATTR_FORK) !=
+	    !!(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (rmap.rm_flags & XFS_RMAP_BMBT_BLOCK)

