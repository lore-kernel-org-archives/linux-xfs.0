Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79472CA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177532190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qj6vDki6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfKCW0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:26:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfKCW0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:26:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MODCN061241
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=M8PpgeI99rK67FDjs+qk3GZRqL89+UBAQwGXCj2nW84=;
 b=qj6vDki6T/gTZHPHDXmtaYnkbCe5oZ7QBDIH7W50DG9oyLoyg8VBknABatvUOsAwCnjT
 WegLowGoVeMIt/VmyoniQdqhU5U0j7QLQ1vHjQU3ky34dCbM8gW6SlCdOc5tE1iwZqLH
 f7Oxwm6/TeCUZvCRWWJTt8CpXmzIluP3BngjlQK2MdBVyT/dC2VwBkMT9IEoRAo4TXs7
 jTQwNlZx0dWwg/B/GIT7xGp5qNyK6Nhmk+o+OEDqZWO2u9DJiE6fBTHIP0cCWajbVmg0
 itErYXFBr+kvP7oNIeBLrlWlJ3ZcDn1x5+lwQ+YhEAasejWKqx5yUnsMzCh0CA/A9C/3 Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w12eqv06m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOFxp071850
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w1ka8e80e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA3MPmC4032545
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:25:47 -0800
Subject: [PATCH 10/10] xfs: report XFS_CORRUPT_ON errors to the health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:25:46 -0800
Message-ID: <157281994640.4152102.15370774912529137865.stgit@magnolia>
In-Reply-To: <157281988489.4152102.1632857939932700344.stgit@magnolia>
References: <157281988489.4152102.1632857939932700344.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
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
 fs/xfs/libxfs/xfs_alloc.c    |   95 +++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c     |   76 +++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.c    |   14 ++++++
 fs/xfs/libxfs/xfs_ialloc.c   |   52 +++++++++++++++++++----
 fs/xfs/libxfs/xfs_refcount.c |   30 +++++++++++++
 fs/xfs/libxfs/xfs_rmap.c     |   72 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_discard.c         |    2 +
 fs/xfs/xfs_iwalk.c           |    4 +-
 8 files changed, 312 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 742ad359da6b..6c2f3fb68071 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -454,14 +454,18 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_get_rec(cnt_cur, &nfbno1, &nflen1, &i)))
 			return error;
 		if (XFS_CORRUPT_ON(mp,
-		    i != 1 || nfbno1 != fbno || nflen1 != flen))
+		    i != 1 || nfbno1 != fbno || nflen1 != flen)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, fbno, flen, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 1))
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	/*
 	 * Look up the record in the by-block tree if necessary.
@@ -471,14 +475,18 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_get_rec(bno_cur, &nfbno1, &nflen1, &i)))
 			return error;
 		if (XFS_CORRUPT_ON(mp,
-		    i != 1 || nfbno1 != fbno || nflen1 != flen))
+		    i != 1 || nfbno1 != fbno || nflen1 != flen)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(bno_cur, fbno, flen, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 1))
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 #ifdef DEBUG
@@ -490,8 +498,10 @@ xfs_alloc_fixup_trees(
 		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_bufs[0]);
 
 		if (XFS_CORRUPT_ON(mp,
-		    bnoblock->bb_numrecs != cntblock->bb_numrecs))
+		    bnoblock->bb_numrecs != cntblock->bb_numrecs)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 #endif
 
@@ -521,30 +531,40 @@ xfs_alloc_fixup_trees(
 	 */
 	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
-	if (XFS_CORRUPT_ON(mp, i != 1))
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cnt_cur);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Add new by-size btree entry(s).
 	 */
 	if (nfbno1 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 0))
+		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 1))
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	if (nfbno2 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 0))
+		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 1))
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	/*
 	 * Fix up the by-block btree entry(s).
@@ -555,8 +575,10 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 1))
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	} else {
 		/*
 		 * Update the by-block entry to start later|be shorter.
@@ -570,12 +592,16 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 0))
+		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 1))
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	return 0;
 }
@@ -839,8 +865,10 @@ xfs_alloc_cur_check(
 	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(args->mp, i != 1))
+	if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Check minlen and deactivate a cntbt cursor if out of acceptable size
@@ -1046,6 +1074,7 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error;
 		if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+			xfs_btree_mark_sick(ccur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1072,6 +1101,7 @@ xfs_alloc_ag_vextent_small(
 
 		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
 		if (XFS_CORRUPT_ON(args->mp, !bp)) {
+			xfs_btree_mark_sick(ccur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1081,6 +1111,7 @@ xfs_alloc_ag_vextent_small(
 	*flenp = args->len = 1;
 	if (XFS_CORRUPT_ON(args->mp,
 	    fbno >= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+		xfs_btree_mark_sick(ccur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -1239,6 +1270,7 @@ xfs_alloc_ag_vextent_exact(
 	if (error)
 		goto error0;
 	if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+		xfs_btree_mark_sick(bno_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1577,6 +1609,7 @@ xfs_alloc_ag_vextent_near(
 				if (error)
 					goto out;
 				if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+					xfs_btree_mark_sick(acur.cnt);
 					error = -EFSCORRUPTED;
 					goto out;
 				}
@@ -1705,6 +1738,7 @@ xfs_alloc_ag_vextent_size(
 			if (error)
 				goto error0;
 			if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1743,6 +1777,7 @@ xfs_alloc_ag_vextent_size(
 	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 	if (XFS_CORRUPT_ON(args->mp,
 	    rlen != 0 && (rlen > flen || rbno + rlen > fbno + flen))) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1765,6 +1800,7 @@ xfs_alloc_ag_vextent_size(
 					&i)))
 				goto error0;
 			if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1776,6 +1812,7 @@ xfs_alloc_ag_vextent_size(
 			if (XFS_CORRUPT_ON(args->mp,
 			    rlen != 0 &&
 			    (rlen > flen || rbno + rlen > fbno + flen))) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1792,6 +1829,7 @@ xfs_alloc_ag_vextent_size(
 				&i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1818,6 +1856,7 @@ xfs_alloc_ag_vextent_size(
 
 	rlen = args->len;
 	if (XFS_CORRUPT_ON(args->mp, rlen > flen)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1837,6 +1876,7 @@ xfs_alloc_ag_vextent_size(
 	if (XFS_CORRUPT_ON(args->mp,
 	    args->agbno + args->len >
 	    be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+		xfs_ag_mark_sick(args->pag, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1912,6 +1952,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1927,6 +1968,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_CORRUPT_ON(mp, ltbno + ltlen > bno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1945,6 +1987,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &gtbno, &gtlen, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1960,6 +2003,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_CORRUPT_ON(mp, bno + len > gtbno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1980,12 +2024,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1995,12 +2041,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2010,6 +2058,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2019,6 +2068,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2036,6 +2086,7 @@ xfs_free_ag_extent(
 				goto error0;
 			if (XFS_CORRUPT_ON(mp,
 			    i != 1 || xxbno != ltbno || xxlen != ltlen)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2060,12 +2111,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2076,6 +2129,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2095,12 +2149,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2123,6 +2179,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2135,12 +2192,14 @@ xfs_free_ag_extent(
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
 	if (XFS_CORRUPT_ON(mp, i != 0)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2323,6 +2382,7 @@ xfs_free_agfl_block(
 
 	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
 	if (XFS_CORRUPT_ON(tp->t_mountp, !bp)) {
+		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGFL);
 		return -EFSCORRUPTED;
 	}
 	xfs_trans_binval(tp, bp);
@@ -3266,10 +3326,14 @@ __xfs_free_extent(
 		return -EIO;
 
 	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
-	if (error)
+	if (error) {
+		if (xfs_metadata_is_sick(error))
+			xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_BNOBT);
 		return error;
+	}
 
 	if (XFS_CORRUPT_ON(mp, agbno >= mp->m_sb.sb_agblocks)) {
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto err;
 	}
@@ -3277,6 +3341,7 @@ __xfs_free_extent(
 	/* validate the extent size is legal now we have the agf locked */
 	if (XFS_CORRUPT_ON(mp,
 	    agbno + len > be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length))) {
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto err;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f3a6598d364a..b273b804d904 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -387,6 +387,7 @@ xfs_bmap_check_leaf_extents(
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (XFS_CORRUPT_ON(mp, !xfs_verify_fsbno(mp, bno))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -618,8 +619,10 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	if (XFS_CORRUPT_ON(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1)))
+	if (XFS_CORRUPT_ON(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
@@ -947,6 +950,7 @@ xfs_bmap_add_attrfork_btree(
 			goto error0;
 		/* must be at least one entry */
 		if (XFS_CORRUPT_ON(mp, stat != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1641,6 +1645,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1648,6 +1653,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1655,6 +1661,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1684,6 +1691,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1717,6 +1725,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1745,6 +1754,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1752,6 +1762,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1786,6 +1797,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1810,6 +1822,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1817,6 +1830,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1861,6 +1875,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1896,6 +1911,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1903,6 +1919,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1982,6 +1999,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1989,6 +2007,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2186,30 +2205,35 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2239,18 +2263,21 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2283,18 +2310,21 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2321,6 +2351,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2354,6 +2385,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2391,6 +2423,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2401,6 +2434,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2431,6 +2465,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2468,6 +2503,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2478,12 +2514,14 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2521,6 +2559,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2533,6 +2572,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2545,6 +2585,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2552,6 +2593,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2838,6 +2880,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2845,6 +2888,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2852,6 +2896,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2881,6 +2926,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2911,6 +2957,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2937,6 +2984,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2944,6 +2992,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5136,6 +5185,7 @@ xfs_bmap_del_extent_real(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -5163,6 +5213,7 @@ xfs_bmap_del_extent_real(
 		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -5237,6 +5288,7 @@ xfs_bmap_del_extent_real(
 				if (error)
 					goto done;
 				if (XFS_CORRUPT_ON(mp, i != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto done;
 				}
@@ -5257,6 +5309,7 @@ xfs_bmap_del_extent_real(
 				goto done;
 			}
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5740,21 +5793,27 @@ xfs_bmse_merge(
 	error = xfs_bmbt_lookup_eq(cur, got, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(mp, i != 1))
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_btree_delete(cur, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(mp, i != 1))
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	/* lookup and update size of the previous extent */
 	error = xfs_bmbt_lookup_eq(cur, left, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(mp, i != 1))
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmbt_update(cur, &new);
 	if (error)
@@ -5802,8 +5861,10 @@ xfs_bmap_shift_update_extent(
 		error = xfs_bmbt_lookup_eq(cur, &prev, &i);
 		if (error)
 			return error;
-		if (XFS_CORRUPT_ON(mp, i != 1))
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 
 		error = xfs_bmbt_update(cur, got);
 		if (error)
@@ -5866,6 +5927,7 @@ xfs_bmap_collapse_extents(
 		goto del_cursor;
 	}
 	if (XFS_CORRUPT_ON(mp, isnullstartblock(got.br_startblock))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -5993,6 +6055,7 @@ xfs_bmap_insert_extents(
 		}
 	}
 	if (XFS_CORRUPT_ON(mp, isnullstartblock(got.br_startblock))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -6102,6 +6165,7 @@ xfs_bmap_split_extent_at(
 		if (error)
 			goto del_cursor;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6130,6 +6194,7 @@ xfs_bmap_split_extent_at(
 		if (error)
 			goto del_cursor;
 		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6137,6 +6202,7 @@ xfs_bmap_split_extent_at(
 		if (error)
 			goto del_cursor;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index fee1dad5eab9..d5ecd6f84655 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2000,8 +2000,10 @@ xfs_btree_lookup(
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto error0;
-			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				return -EFSCORRUPTED;
+			}
 			*stat = 1;
 			return 0;
 		}
@@ -2457,6 +2459,7 @@ xfs_btree_lshift(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_CORRUPT_ON(tcur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2627,6 +2630,7 @@ xfs_btree_rshift(
 		goto error0;
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_CORRUPT_ON(tcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -3484,6 +3488,7 @@ xfs_btree_insert(
 		}
 
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3891,6 +3896,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3899,12 +3905,14 @@ xfs_btree_delrec(
 		if (error)
 			goto error0;
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3952,6 +3960,7 @@ xfs_btree_delrec(
 		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
 			i = xfs_btree_firstrec(tcur, level);
 			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -3960,6 +3969,7 @@ xfs_btree_delrec(
 			if (error)
 				goto error0;
 			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -3977,6 +3987,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3986,6 +3997,7 @@ xfs_btree_delrec(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 20d539923b2f..56cccdf6aa63 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -547,6 +547,7 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -563,10 +564,12 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
 		if (XFS_CORRUPT_ON(mp, rec.ir_startino != nrec->ir_startino)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -576,6 +579,7 @@ xfs_inobt_insert_sprec(
 		 * cannot merge, something is seriously wrong.
 		 */
 		if (XFS_CORRUPT_ON(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1068,8 +1072,10 @@ xfs_ialloc_next_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	return 0;
@@ -1093,8 +1099,10 @@ xfs_ialloc_get_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	return 0;
@@ -1175,6 +1183,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1183,6 +1192,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, j != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1341,6 +1351,7 @@ xfs_dialloc_ag_inobt(
 	if (error)
 		goto error0;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1350,6 +1361,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1359,6 +1371,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1421,8 +1434,10 @@ xfs_dialloc_ag_finobt_near(
 		error = xfs_inobt_get_rec(lcur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_CORRUPT_ON(lcur->bc_mp, i != 1))
+		if (XFS_CORRUPT_ON(lcur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(lcur);
 			return -EFSCORRUPTED;
+		}
 
 		/*
 		 * See if we've landed in the parent inode record. The finobt
@@ -1446,12 +1461,14 @@ xfs_dialloc_ag_finobt_near(
 		if (error)
 			goto error_rcur;
 		if (XFS_CORRUPT_ON(lcur->bc_mp, j != 1)) {
+			xfs_btree_mark_sick(lcur);
 			error = -EFSCORRUPTED;
 			goto error_rcur;
 		}
 	}
 
 	if (XFS_CORRUPT_ON(lcur->bc_mp, i != 1 && j != 1)) {
+		xfs_btree_mark_sick(lcur);
 		error = -EFSCORRUPTED;
 		goto error_rcur;
 	}
@@ -1507,8 +1524,10 @@ xfs_dialloc_ag_finobt_newino(
 			error = xfs_inobt_get_rec(cur, rec, &i);
 			if (error)
 				return error;
-			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				return -EFSCORRUPTED;
+			}
 			return 0;
 		}
 	}
@@ -1519,14 +1538,18 @@ xfs_dialloc_ag_finobt_newino(
 	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_inobt_get_rec(cur, rec, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return 0;
 }
@@ -1548,14 +1571,18 @@ xfs_dialloc_ag_update_inobt(
 	error = xfs_inobt_lookup(cur, frec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 	ASSERT((XFS_AGINO_TO_OFFSET(cur->bc_mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 
@@ -1564,8 +1591,10 @@ xfs_dialloc_ag_update_inobt(
 
 	if (XFS_CORRUPT_ON(cur->bc_mp,
 	    rec.ir_free != frec->ir_free ||
-	    rec.ir_freecount != frec->ir_freecount))
+	    rec.ir_freecount != frec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_inobt_update(cur, &rec);
 }
@@ -1976,6 +2005,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1986,6 +2016,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2101,6 +2132,7 @@ xfs_difree_finobt(
 		 * something is out of sync.
 		 */
 		if (XFS_CORRUPT_ON(mp, ibtrec->ir_freecount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2127,6 +2159,7 @@ xfs_difree_finobt(
 	if (error)
 		goto error;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -2137,6 +2170,7 @@ xfs_difree_finobt(
 	if (XFS_CORRUPT_ON(mp,
 	    rec.ir_free != ibtrec->ir_free ||
 	    rec.ir_freecount != ibtrec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 75c4f45e1221..131a65dc9736 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -203,6 +203,7 @@ xfs_refcount_insert(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -233,12 +234,14 @@ xfs_refcount_delete(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_CORRUPT_ON(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -361,6 +364,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -386,6 +390,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -428,6 +433,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -436,6 +442,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -445,6 +452,7 @@ xfs_refcount_merge_center_extents(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -456,6 +464,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -498,6 +507,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -506,6 +516,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -517,6 +528,7 @@ xfs_refcount_merge_left_extent(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -562,6 +574,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -570,6 +583,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -581,6 +595,7 @@ xfs_refcount_merge_right_extent(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -630,6 +645,7 @@ xfs_refcount_find_left_extents(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -651,6 +667,7 @@ xfs_refcount_find_left_extents(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -719,6 +736,7 @@ xfs_refcount_find_right_extents(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -740,6 +758,7 @@ xfs_refcount_find_right_extents(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -967,6 +986,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				if (XFS_CORRUPT_ON(cur->bc_mp,
 						   found_tmp != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
@@ -1011,6 +1031,7 @@ xfs_refcount_adjust_extents(
 			if (error)
 				goto out_error;
 			if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -1332,6 +1353,7 @@ xfs_refcount_find_shared(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1347,6 +1369,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1378,6 +1401,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1483,6 +1507,7 @@ xfs_refcount_adjust_cow_extents(
 		/* Adding a CoW reservation, there should be nothing here. */
 		if (XFS_CORRUPT_ON(cur->bc_mp,
 		    agbno + aglen > ext.rc_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1498,6 +1523,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_tmp != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1505,14 +1531,17 @@ xfs_refcount_adjust_cow_extents(
 	case XFS_REFCOUNT_ADJUST_COW_FREE:
 		/* Removing a CoW reservation, there should be one extent. */
 		if (XFS_CORRUPT_ON(cur->bc_mp, ext.rc_startblock != agbno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_CORRUPT_ON(cur->bc_mp, ext.rc_blockcount != aglen)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_CORRUPT_ON(cur->bc_mp, ext.rc_refcount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1524,6 +1553,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ac579cdcb885..237dcd7d149b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -115,6 +115,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 0)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -128,6 +129,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -157,6 +159,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -165,6 +168,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 1)) {
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
 	if (XFS_CORRUPT_ON(mp,
 	    (flags & XFS_RMAP_UNWRITTEN) !=
 	    (rec->rm_flags & XFS_RMAP_UNWRITTEN))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
 	if (XFS_CORRUPT_ON(mp, owner != rec->rm_owner)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -446,16 +453,19 @@ xfs_rmap_free_check_owner(
 	if (flags & XFS_RMAP_BMBT_BLOCK) {
 		if (XFS_CORRUPT_ON(mp,
 		    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
 	} else {
 		if (XFS_CORRUPT_ON(mp, rec->rm_offset > offset)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
 		if (XFS_CORRUPT_ON(mp,
 		    offset + len > ltoff + rec->rm_blockcount)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -518,6 +528,7 @@ xfs_rmap_unmap(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -526,6 +537,7 @@ xfs_rmap_unmap(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -545,6 +557,7 @@ xfs_rmap_unmap(
 	if (owner == XFS_RMAP_OWN_NULL) {
 		if (XFS_CORRUPT_ON(mp,
 		    bno < ltrec.rm_startblock + ltrec.rm_blockcount)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -571,6 +584,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -582,12 +596,13 @@ xfs_rmap_unmap(
 	if (XFS_CORRUPT_ON(mp,
 	    ltrec.rm_startblock > bno ||
 	    ltrec.rm_startblock + ltrec.rm_blockcount < bno + len)) {
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
@@ -602,6 +617,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -797,6 +813,7 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, have_lt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -811,6 +828,7 @@ xfs_rmap_map(
 
 	if (XFS_CORRUPT_ON(mp,
 	    have_lt != 0 && ltrec.rm_startblock + ltrec.rm_blockcount > bno)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -828,10 +846,12 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, have_gt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_CORRUPT_ON(mp, bno + len > gtrec.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -885,6 +905,7 @@ xfs_rmap_map(
 			if (error)
 				goto out_error;
 			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -932,6 +953,7 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1027,6 +1049,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1035,6 +1058,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1071,11 +1095,13 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_CORRUPT_ON(mp,
 		    LEFT.rm_startblock + LEFT.rm_blockcount > bno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1098,6 +1124,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1110,10 +1137,12 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_CORRUPT_ON(mp, bno + len > RIGHT.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1144,6 +1173,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1163,6 +1193,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1174,6 +1205,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1181,6 +1213,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1192,6 +1225,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1199,6 +1233,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1222,6 +1257,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1229,6 +1265,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1248,6 +1285,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1259,6 +1297,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1266,6 +1305,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1336,6 +1376,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1378,6 +1419,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1393,6 +1435,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1426,6 +1469,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1439,6 +1483,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1451,6 +1496,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1523,6 +1569,7 @@ xfs_rmap_convert_shared(
 	if (error)
 		goto done;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1550,6 +1597,7 @@ xfs_rmap_convert_shared(
 		state |= RMAP_LEFT_VALID;
 		if (XFS_CORRUPT_ON(mp,
 		    LEFT.rm_startblock + LEFT.rm_blockcount > bno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1568,10 +1616,12 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_CORRUPT_ON(mp, bno + len > RIGHT.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1622,6 +1672,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1648,6 +1699,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1674,6 +1726,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1697,6 +1750,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1732,6 +1786,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1777,6 +1832,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1812,6 +1868,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1850,6 +1907,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1939,6 +1997,7 @@ xfs_rmap_unmap_shared(
 	if (error)
 		goto out_error;
 	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1948,12 +2007,14 @@ xfs_rmap_unmap_shared(
 	if (XFS_CORRUPT_ON(mp,
 	    ltrec.rm_startblock > bno ||
 	    ltrec.rm_startblock + ltrec.rm_blockcount < bno + len)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
 	if (XFS_CORRUPT_ON(mp, owner != ltrec.rm_owner)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1962,16 +2023,19 @@ xfs_rmap_unmap_shared(
 	if (XFS_CORRUPT_ON(mp,
 	    (flags & XFS_RMAP_UNWRITTEN) !=
 	    (ltrec.rm_flags & XFS_RMAP_UNWRITTEN))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Check the offset. */
 	if (XFS_CORRUPT_ON(mp, ltrec.rm_offset > offset)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 	if (XFS_CORRUPT_ON(mp, offset > ltoff + ltrec.rm_blockcount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -2028,6 +2092,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2057,6 +2122,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2136,6 +2202,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, have_gt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2188,6 +2255,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 025af21be953..e131db9a0341 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -17,6 +17,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 STATIC int
 xfs_trim_extents(
@@ -71,6 +72,7 @@ xfs_trim_extents(
 		if (error)
 			goto out_del_cursor;
 		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_del_cursor;
 		}
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 9820037be458..c6f0618b1f0d 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -298,8 +298,10 @@ xfs_iwalk_ag_start(
 	error = xfs_inobt_get_rec(*curpp, irec, has_more);
 	if (error)
 		return error;
-	if (XFS_CORRUPT_ON(mp, *has_more != 1))
+	if (XFS_CORRUPT_ON(mp, *has_more != 1)) {
+		xfs_btree_mark_sick(*curpp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If the LE lookup yielded an inobt record before the cursor position,

