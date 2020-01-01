Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19119C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2C12072A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jYofaXmM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgAABGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:06:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbgAABGA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:06:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115tWe107649
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DNzbkvsr8ya2CZXVp9GaxHJFxqT6rcUh9MbLbrg9LEs=;
 b=jYofaXmMDT4w0W+gzCuMeAaXhs2ZT5+GBW2yrY1UyytqA/oZiRqqhbaJjlP3Y07Zdk40
 W1FlpIHLZRKUSvsizVRmsKOkxRBKhWlo4HDJr+0SKouE9AyoT9cLsNd8hlzhZTX2h/gM
 1sHGjiIcKDbiRXXXIpR+uTVAt9HnhCpq4ez6auwJA0xDw8+tlUKF1hc0A5ZZI8+26dfn
 nPvsvLTY5SVV6UzvMNPPXk6xeambQGMtWPBCfQW7D/ZSNR7qaCqYfo+vilXxo7jWZcV4
 VM9IsC77GJnFmdFI6gwcO3jSyf/ueX/zkoHHyYQSCAnUy+0uGD+bWNCDxNgE0HPqOH9q qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115Mw2039595
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medf9gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:54 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00115srH004580
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:54 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:05:53 -0800
Subject: [PATCH 10/10] xfs: report XFS_CORRUPT_ON errors to the health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:05:51 -0800
Message-ID: <157784075150.1360095.17877804254694178230.stgit@magnolia>
In-Reply-To: <157784067947.1360095.12276226432994685051.stgit@magnolia>
References: <157784067947.1360095.12276226432994685051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter XFS_CORRUPT_ON failures, we should report that to
the health monitoring system for later reporting.

I started with this and massaged everything until it built:

@@
expression mp, test;
@@

- if (XFS_CORRUPT_ON(mp, test)) return -EFSCORRUPTED;
+ if (XFS_CORRUPT_ON(mp, test)) { xfs_btree_mark_sick(cur); return -EFSCORRUPTED; }

@@
expression mp, test;
identifier label, error;
@@

- if (XFS_CORRUPT_ON(mp, test)) { error = -EFSCORRUPTED; goto label; }
+ if (XFS_CORRUPT_ON(mp, test)) { xfs_btree_mark_sick(cur); error = -EFSCORRUPTED; goto label; }

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |   96 +++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c       |   76 ++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_btree.c      |   14 +++++-
 fs/xfs/libxfs/xfs_ialloc.c     |   52 ++++++++++++++++++----
 fs/xfs/libxfs/xfs_refcount.c   |   30 +++++++++++++
 fs/xfs/libxfs/xfs_rmap.c       |   72 +++++++++++++++++++++++++++++-
 fs/xfs/scrub/refcount_repair.c |    4 ++
 fs/xfs/xfs_discard.c           |    2 +
 fs/xfs/xfs_iwalk.c             |    4 +-
 9 files changed, 316 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5097c188d1ba..8e9f49fc680d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -456,14 +456,18 @@ xfs_alloc_fixup_trees(
 		if (XFS_IS_CORRUPT(mp,
 				   i != 1 ||
 				   nfbno1 != fbno ||
-				   nflen1 != flen))
+				   nflen1 != flen)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, fbno, flen, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	/*
 	 * Look up the record in the by-block tree if necessary.
@@ -475,14 +479,18 @@ xfs_alloc_fixup_trees(
 		if (XFS_IS_CORRUPT(mp,
 				   i != 1 ||
 				   nfbno1 != fbno ||
-				   nflen1 != flen))
+				   nflen1 != flen)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(bno_cur, fbno, flen, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 #ifdef DEBUG
@@ -495,8 +503,10 @@ xfs_alloc_fixup_trees(
 
 		if (XFS_IS_CORRUPT(mp,
 				   bnoblock->bb_numrecs !=
-				   cntblock->bb_numrecs))
+				   cntblock->bb_numrecs)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 #endif
 
@@ -526,30 +536,40 @@ xfs_alloc_fixup_trees(
 	 */
 	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cnt_cur);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Add new by-size btree entry(s).
 	 */
 	if (nfbno1 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 0))
+		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	if (nfbno2 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 0))
+		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	/*
 	 * Fix up the by-block btree entry(s).
@@ -560,8 +580,10 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	} else {
 		/*
 		 * Update the by-block entry to start later|be shorter.
@@ -575,12 +597,16 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 0))
+		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	return 0;
 }
@@ -844,8 +870,10 @@ xfs_alloc_cur_check(
 	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(args->mp, i != 1))
+	if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Check minlen and deactivate a cntbt cursor if out of acceptable size
@@ -1051,6 +1079,7 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(ccur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1087,6 +1116,7 @@ xfs_alloc_ag_vextent_small(
 	if (XFS_IS_CORRUPT(args->mp,
 			   fbno >= be32_to_cpu(
 				   XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+		xfs_btree_mark_sick(ccur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -1245,6 +1275,7 @@ xfs_alloc_ag_vextent_exact(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+		xfs_btree_mark_sick(bno_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1526,8 +1557,10 @@ xfs_alloc_ag_vextent_lastblock(
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
 			if (error)
 				return error;
-			if (XFS_IS_CORRUPT(args->mp, i != 1))
+			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(acur->cnt);
 				return -EFSCORRUPTED;
+			}
 			if (*len >= args->minlen)
 				break;
 			error = xfs_btree_increment(acur->cnt, 0, &i);
@@ -1722,6 +1755,7 @@ xfs_alloc_ag_vextent_size(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1762,6 +1796,7 @@ xfs_alloc_ag_vextent_size(
 			   rlen != 0 &&
 			   (rlen > flen ||
 			    rbno + rlen > fbno + flen))) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1784,6 +1819,7 @@ xfs_alloc_ag_vextent_size(
 					&i)))
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1796,6 +1832,7 @@ xfs_alloc_ag_vextent_size(
 					   rlen != 0 &&
 					   (rlen > flen ||
 					    rbno + rlen > fbno + flen))) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1812,6 +1849,7 @@ xfs_alloc_ag_vextent_size(
 				&i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1838,6 +1876,7 @@ xfs_alloc_ag_vextent_size(
 
 	rlen = args->len;
 	if (XFS_IS_CORRUPT(args->mp, rlen > flen)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1858,6 +1897,7 @@ xfs_alloc_ag_vextent_size(
 			   args->agbno + args->len >
 			   be32_to_cpu(
 				   XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+		xfs_ag_mark_sick(args->pag, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1933,6 +1973,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1948,6 +1989,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, ltbno + ltlen > bno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1966,6 +2008,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &gtbno, &gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1981,6 +2024,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, bno + len > gtbno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2001,12 +2045,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2016,12 +2062,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2031,6 +2079,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2040,6 +2089,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2059,6 +2109,7 @@ xfs_free_ag_extent(
 					   i != 1 ||
 					   xxbno != ltbno ||
 					   xxlen != ltlen)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2083,12 +2134,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2099,6 +2152,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2118,12 +2172,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2146,6 +2202,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2158,12 +2215,14 @@ xfs_free_ag_extent(
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 0)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -3296,10 +3355,14 @@ __xfs_free_extent(
 		return -EIO;
 
 	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
-	if (error)
+	if (error) {
+		if (xfs_metadata_is_sick(error))
+			xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_BNOBT);
 		return error;
+	}
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto err;
 	}
@@ -3308,6 +3371,7 @@ __xfs_free_extent(
 	if (XFS_IS_CORRUPT(mp,
 			   agbno + len >
 			   be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length))) {
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto err;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7e9fd56b0edb..c0b8f20b2a0e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -387,6 +387,7 @@ xfs_bmap_check_leaf_extents(
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, bno))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -618,8 +619,10 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1)))
+	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
@@ -947,6 +950,7 @@ xfs_bmap_add_attrfork_btree(
 			goto error0;
 		/* must be at least one entry */
 		if (XFS_IS_CORRUPT(mp, stat != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1637,6 +1641,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1644,6 +1649,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1651,6 +1657,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1680,6 +1687,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1713,6 +1721,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1741,6 +1750,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1748,6 +1758,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1782,6 +1793,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1806,6 +1818,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1813,6 +1826,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1857,6 +1871,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1892,6 +1907,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1899,6 +1915,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1978,6 +1995,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1985,6 +2003,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2182,30 +2201,35 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2235,18 +2259,21 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2279,18 +2306,21 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2317,6 +2347,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2350,6 +2381,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2387,6 +2419,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2397,6 +2430,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2427,6 +2461,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2464,6 +2499,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2474,12 +2510,14 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2517,6 +2555,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2529,6 +2568,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2541,6 +2581,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2548,6 +2589,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2834,6 +2876,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2841,6 +2884,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2848,6 +2892,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2877,6 +2922,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2907,6 +2953,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2933,6 +2980,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2940,6 +2988,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5140,6 +5189,7 @@ xfs_bmap_del_extent_real(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -5167,6 +5217,7 @@ xfs_bmap_del_extent_real(
 		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -5241,6 +5292,7 @@ xfs_bmap_del_extent_real(
 				if (error)
 					goto done;
 				if (XFS_IS_CORRUPT(mp, i != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto done;
 				}
@@ -5261,6 +5313,7 @@ xfs_bmap_del_extent_real(
 				goto done;
 			}
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5747,21 +5800,27 @@ xfs_bmse_merge(
 	error = xfs_bmbt_lookup_eq(cur, got, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_btree_delete(cur, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	/* lookup and update size of the previous extent */
 	error = xfs_bmbt_lookup_eq(cur, left, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmbt_update(cur, &new);
 	if (error)
@@ -5809,8 +5868,10 @@ xfs_bmap_shift_update_extent(
 		error = xfs_bmbt_lookup_eq(cur, &prev, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 
 		error = xfs_bmbt_update(cur, got);
 		if (error)
@@ -5873,6 +5934,7 @@ xfs_bmap_collapse_extents(
 		goto del_cursor;
 	}
 	if (XFS_IS_CORRUPT(mp, isnullstartblock(got.br_startblock))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -6000,6 +6062,7 @@ xfs_bmap_insert_extents(
 		}
 	}
 	if (XFS_IS_CORRUPT(mp, isnullstartblock(got.br_startblock))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -6107,6 +6170,7 @@ xfs_bmap_split_extent_at(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6135,6 +6199,7 @@ xfs_bmap_split_extent_at(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6142,6 +6207,7 @@ xfs_bmap_split_extent_at(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 064670b85562..a0dd4d893c11 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1993,8 +1993,10 @@ xfs_btree_lookup(
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto error0;
-			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				return -EFSCORRUPTED;
+			}
 			*stat = 1;
 			return 0;
 		}
@@ -2450,6 +2452,7 @@ xfs_btree_lshift(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2620,6 +2623,7 @@ xfs_btree_rshift(
 		goto error0;
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -3477,6 +3481,7 @@ xfs_btree_insert(
 		}
 
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3884,6 +3889,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3892,12 +3898,14 @@ xfs_btree_delrec(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3945,6 +3953,7 @@ xfs_btree_delrec(
 		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
 			i = xfs_btree_firstrec(tcur, level);
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -3953,6 +3962,7 @@ xfs_btree_delrec(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -3970,6 +3980,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3979,6 +3990,7 @@ xfs_btree_delrec(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a185f2f5b7ff..4a8b995c91f9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -555,6 +555,7 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -571,10 +572,12 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
 		if (XFS_IS_CORRUPT(mp, rec.ir_startino != nrec->ir_startino)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -584,6 +587,7 @@ xfs_inobt_insert_sprec(
 		 * cannot merge, something is seriously wrong.
 		 */
 		if (XFS_IS_CORRUPT(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1076,8 +1080,10 @@ xfs_ialloc_next_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	return 0;
@@ -1101,8 +1107,10 @@ xfs_ialloc_get_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	return 0;
@@ -1183,6 +1191,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1191,6 +1200,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, j != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1349,6 +1359,7 @@ xfs_dialloc_ag_inobt(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1358,6 +1369,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1367,6 +1379,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1429,8 +1442,10 @@ xfs_dialloc_ag_finobt_near(
 		error = xfs_inobt_get_rec(lcur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(lcur->bc_mp, i != 1))
+		if (XFS_IS_CORRUPT(lcur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(lcur);
 			return -EFSCORRUPTED;
+		}
 
 		/*
 		 * See if we've landed in the parent inode record. The finobt
@@ -1454,12 +1469,14 @@ xfs_dialloc_ag_finobt_near(
 		if (error)
 			goto error_rcur;
 		if (XFS_IS_CORRUPT(lcur->bc_mp, j != 1)) {
+			xfs_btree_mark_sick(lcur);
 			error = -EFSCORRUPTED;
 			goto error_rcur;
 		}
 	}
 
 	if (XFS_IS_CORRUPT(lcur->bc_mp, i != 1 && j != 1)) {
+		xfs_btree_mark_sick(lcur);
 		error = -EFSCORRUPTED;
 		goto error_rcur;
 	}
@@ -1515,8 +1532,10 @@ xfs_dialloc_ag_finobt_newino(
 			error = xfs_inobt_get_rec(cur, rec, &i);
 			if (error)
 				return error;
-			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				return -EFSCORRUPTED;
+			}
 			return 0;
 		}
 	}
@@ -1527,14 +1546,18 @@ xfs_dialloc_ag_finobt_newino(
 	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_inobt_get_rec(cur, rec, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return 0;
 }
@@ -1556,14 +1579,18 @@ xfs_dialloc_ag_update_inobt(
 	error = xfs_inobt_lookup(cur, frec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 	ASSERT((XFS_AGINO_TO_OFFSET(cur->bc_mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 
@@ -1572,8 +1599,10 @@ xfs_dialloc_ag_update_inobt(
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
 			   rec.ir_free != frec->ir_free ||
-			   rec.ir_freecount != frec->ir_freecount))
+			   rec.ir_freecount != frec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_inobt_update(cur, &rec);
 }
@@ -1984,6 +2013,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1994,6 +2024,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2109,6 +2140,7 @@ xfs_difree_finobt(
 		 * something is out of sync.
 		 */
 		if (XFS_IS_CORRUPT(mp, ibtrec->ir_freecount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2135,6 +2167,7 @@ xfs_difree_finobt(
 	if (error)
 		goto error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -2145,6 +2178,7 @@ xfs_difree_finobt(
 	if (XFS_IS_CORRUPT(mp,
 			   rec.ir_free != ibtrec->ir_free ||
 			   rec.ir_freecount != ibtrec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 4ed0a24f6afb..af597f4496ab 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -203,6 +203,7 @@ xfs_refcount_insert(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -233,12 +234,14 @@ xfs_refcount_delete(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -361,6 +364,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -386,6 +390,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -428,6 +433,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -436,6 +442,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -445,6 +452,7 @@ xfs_refcount_merge_center_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -456,6 +464,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -498,6 +507,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -506,6 +516,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -517,6 +528,7 @@ xfs_refcount_merge_left_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -562,6 +574,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -570,6 +583,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -581,6 +595,7 @@ xfs_refcount_merge_right_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -630,6 +645,7 @@ xfs_refcount_find_left_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -651,6 +667,7 @@ xfs_refcount_find_left_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -719,6 +736,7 @@ xfs_refcount_find_right_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -740,6 +758,7 @@ xfs_refcount_find_right_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -967,6 +986,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				if (XFS_IS_CORRUPT(cur->bc_mp,
 						   found_tmp != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
@@ -1011,6 +1031,7 @@ xfs_refcount_adjust_extents(
 			if (error)
 				goto out_error;
 			if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -1330,6 +1351,7 @@ xfs_refcount_find_shared(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1345,6 +1367,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1376,6 +1399,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1481,6 +1505,7 @@ xfs_refcount_adjust_cow_extents(
 		/* Adding a CoW reservation, there should be nothing here. */
 		if (XFS_IS_CORRUPT(cur->bc_mp,
 				   agbno + aglen > ext.rc_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1496,6 +1521,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_tmp != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1503,14 +1529,17 @@ xfs_refcount_adjust_cow_extents(
 	case XFS_REFCOUNT_ADJUST_COW_FREE:
 		/* Removing a CoW reservation, there should be one extent. */
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_startblock != agbno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount != aglen)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_refcount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1522,6 +1551,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 29fb516743ee..c0c2c4acb61e 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -115,6 +115,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 0)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -128,6 +129,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -157,6 +159,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -165,6 +168,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -412,7 +416,7 @@ xfs_rmap_lookup_le_range(
  */
 static int
 xfs_rmap_free_check_owner(
-	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
 	xfs_filblks_t		len,
@@ -420,6 +424,7 @@ xfs_rmap_free_check_owner(
 	uint64_t		offset,
 	unsigned int		flags)
 {
+	struct xfs_mount	*mp = cur->bc_mp;
 	int			error = 0;
 
 	if (owner == XFS_RMAP_OWN_UNKNOWN)
@@ -429,12 +434,14 @@ xfs_rmap_free_check_owner(
 	if (XFS_IS_CORRUPT(mp,
 			   (flags & XFS_RMAP_UNWRITTEN) !=
 			   (rec->rm_flags & XFS_RMAP_UNWRITTEN))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
 	if (XFS_IS_CORRUPT(mp, owner != rec->rm_owner)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -446,16 +453,19 @@ xfs_rmap_free_check_owner(
 	if (flags & XFS_RMAP_BMBT_BLOCK) {
 		if (XFS_IS_CORRUPT(mp,
 				   !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
 	} else {
 		if (XFS_IS_CORRUPT(mp, rec->rm_offset > offset)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
 		if (XFS_IS_CORRUPT(mp,
 				   offset + len > ltoff + rec->rm_blockcount)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -518,6 +528,7 @@ xfs_rmap_unmap(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -526,6 +537,7 @@ xfs_rmap_unmap(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -546,6 +558,7 @@ xfs_rmap_unmap(
 		if (XFS_IS_CORRUPT(mp,
 				   bno <
 				   ltrec.rm_startblock + ltrec.rm_blockcount)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -572,6 +585,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -584,12 +598,13 @@ xfs_rmap_unmap(
 			   ltrec.rm_startblock > bno ||
 			   ltrec.rm_startblock + ltrec.rm_blockcount <
 			   bno + len)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Check owner information. */
-	error = xfs_rmap_free_check_owner(mp, ltoff, &ltrec, len, owner,
+	error = xfs_rmap_free_check_owner(cur, ltoff, &ltrec, len, owner,
 			offset, flags);
 	if (error)
 		goto out_error;
@@ -604,6 +619,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -799,6 +815,7 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, have_lt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -814,6 +831,7 @@ xfs_rmap_map(
 	if (XFS_IS_CORRUPT(mp,
 			   have_lt != 0 &&
 			   ltrec.rm_startblock + ltrec.rm_blockcount > bno)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -831,10 +849,12 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_IS_CORRUPT(mp, bno + len > gtrec.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -888,6 +908,7 @@ xfs_rmap_map(
 			if (error)
 				goto out_error;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -935,6 +956,7 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1030,6 +1052,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1038,6 +1061,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1074,12 +1098,14 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_IS_CORRUPT(mp,
 				   LEFT.rm_startblock + LEFT.rm_blockcount >
 				   bno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1102,6 +1128,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1114,10 +1141,12 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_IS_CORRUPT(mp, bno + len > RIGHT.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1148,6 +1177,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1167,6 +1197,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1178,6 +1209,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1185,6 +1217,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1196,6 +1229,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1203,6 +1237,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1226,6 +1261,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1233,6 +1269,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1252,6 +1289,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1263,6 +1301,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1270,6 +1309,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1340,6 +1380,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1382,6 +1423,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1397,6 +1439,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1430,6 +1473,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1443,6 +1487,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1455,6 +1500,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1527,6 +1573,7 @@ xfs_rmap_convert_shared(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1555,6 +1602,7 @@ xfs_rmap_convert_shared(
 		if (XFS_IS_CORRUPT(mp,
 				   LEFT.rm_startblock + LEFT.rm_blockcount >
 				   bno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1573,10 +1621,12 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_IS_CORRUPT(mp, bno + len > RIGHT.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1627,6 +1677,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1653,6 +1704,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1679,6 +1731,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1702,6 +1755,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1737,6 +1791,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1782,6 +1837,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1817,6 +1873,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1855,6 +1912,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1944,6 +2002,7 @@ xfs_rmap_unmap_shared(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1954,12 +2013,14 @@ xfs_rmap_unmap_shared(
 			   ltrec.rm_startblock > bno ||
 			   ltrec.rm_startblock + ltrec.rm_blockcount <
 			   bno + len)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
 	if (XFS_IS_CORRUPT(mp, owner != ltrec.rm_owner)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1968,16 +2029,19 @@ xfs_rmap_unmap_shared(
 	if (XFS_IS_CORRUPT(mp,
 			   (flags & XFS_RMAP_UNWRITTEN) !=
 			   (ltrec.rm_flags & XFS_RMAP_UNWRITTEN))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Check the offset. */
 	if (XFS_IS_CORRUPT(mp, ltrec.rm_offset > offset)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 	if (XFS_IS_CORRUPT(mp, offset > ltoff + ltrec.rm_blockcount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -2034,6 +2098,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2063,6 +2128,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2142,6 +2208,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2194,6 +2261,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index a4083c0f3feb..1b7f2d2cbce1 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -185,6 +186,7 @@ xrep_refc_next_rrm(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, !have_gt)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -311,6 +313,7 @@ xrep_refc_find_refcounts(
 		if (error)
 			goto out;
 		if (XFS_IS_CORRUPT(sc->mp, !have_gt)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -358,6 +361,7 @@ xrep_refc_find_refcounts(
 			if (error)
 				goto out;
 			if (XFS_IS_CORRUPT(sc->mp, !have_gt)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out;
 			}
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index cae613620175..c6a43b4bd9c2 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -18,6 +18,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 STATIC int
 xfs_trim_extents(
@@ -72,6 +73,7 @@ xfs_trim_extents(
 		if (error)
 			goto out_del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_del_cursor;
 		}
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index f2f89cae1f3c..5b1b025d9b85 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -298,8 +298,10 @@ xfs_iwalk_ag_start(
 	error = xfs_inobt_get_rec(*curpp, irec, has_more);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, *has_more != 1))
+	if (XFS_IS_CORRUPT(mp, *has_more != 1)) {
+		xfs_btree_mark_sick(*curpp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If the LE lookup yielded an inobt record before the cursor position,

