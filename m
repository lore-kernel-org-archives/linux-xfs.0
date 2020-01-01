Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E593CC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F382206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nqEqh9f9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAABRQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:17:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABRQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:17:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011E9qx092017
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=c6rLExFcHdUE5eFEHyjQspHCpHnTlvB/HkJMAHrG4PU=;
 b=nqEqh9f99QrXpbYhPLOUcqfpiompeyi5sLuIBAWTFav8diIs0+BZDboVWmAILJ4svPpe
 X1m3XBCU1aH9XUGQ93OYCqC5xLV7vGqvo1YNTiRW4i/mD7IxvWGjy31sLhZO9fkvmHdk
 SYlAXRSfQvxW+4jqMgzNz9VeHpyn2WcN5YonEKmYI0pqwOynxD9ibF1gKcgITV2ub/11
 jS7707Wj2xlRlzXRabuGb4IX+sdVlC7oZaAnxII2PD3Y+dAgqg2/evNc6N4oOdJ+kRi/
 0pFKiXFZX+JDFddqy0oP3H6/pUBxIj22XfrXfijUglhg643gTuABkbVpBXl32mUP8Jzk cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uX7045293
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfg4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011HC16016167
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:12 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:17:12 -0800
Subject: [PATCH 08/21] xfs: prepare rmap functions to deal with rtrmapbt
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:17:09 -0800
Message-ID: <157784142986.1368137.1557673190985306083.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Prepare the high-level rmap functions to deal with the new realtime
rmapbt and its slightly different conventions.  Provide the ability
to talk to either rmapbt or rtrmapbt formats from the same high
level code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |  174 +++++++++++++++++++++++++++-------------------
 1 file changed, 104 insertions(+), 70 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 03b2169d5ecf..15518f624396 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -23,6 +23,24 @@
 #include "xfs_inode.h"
 #include "xfs_health.h"
 
+/* By convention, the rtrmapbt's "AG" number is NULLAGNUMBER. */
+static xfs_agnumber_t
+xfs_rmap_cur_agno(
+	struct xfs_btree_cur	*cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+			NULLAGNUMBER : cur->bc_private.a.agno;
+}
+
+/* Return the maximum length of an rmap record. */
+static xfs_filblks_t
+xfs_rmap_len_max(
+	struct xfs_btree_cur	*cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+			XFS_RTRMAP_LEN_MAX : XFS_RMAP_LEN_MAX;
+}
+
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
  * in the btree given by cur.
@@ -80,19 +98,27 @@ xfs_rmap_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_rmap_update(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_rmap_update(cur->bc_mp, xfs_rmap_cur_agno(cur),
 			irec->rm_startblock, irec->rm_blockcount,
 			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
-	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
-	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
-	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
-	rec.rmap.rm_offset = cpu_to_be64(
-			xfs_rmap_irec_offset_pack(irec));
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		rec.rtrmap.rm_startblock = cpu_to_be64(irec->rm_startblock);
+		rec.rtrmap.rm_blockcount = cpu_to_be64(irec->rm_blockcount);
+		rec.rtrmap.rm_owner = cpu_to_be64(irec->rm_owner);
+		rec.rtrmap.rm_offset = cpu_to_be64(
+				xfs_rmap_irec_offset_pack(irec));
+	} else {
+		rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
+		rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
+		rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
+		rec.rmap.rm_offset = cpu_to_be64(
+				xfs_rmap_irec_offset_pack(irec));
+	}
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_rmap_update_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -108,7 +134,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_insert(rcur->bc_mp, xfs_rmap_cur_agno(rcur), agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -136,7 +162,7 @@ xfs_rmap_insert(
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(rcur), error, _RET_IP_);
 	return error;
 }
 
@@ -152,7 +178,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_delete(rcur->bc_mp, xfs_rmap_cur_agno(rcur), agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -175,7 +201,7 @@ xfs_rmap_delete(
 done:
 	if (error)
 		trace_xfs_rmap_delete_error(rcur->bc_mp,
-				rcur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(rcur), error, _RET_IP_);
 	return error;
 }
 
@@ -188,11 +214,20 @@ xfs_rmap_btrec_to_irec(
 {
 	int			error;
 
-	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
-	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
-	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
-	error = xfs_rmap_irec_offset_unpack(be64_to_cpu(rec->rmap.rm_offset),
-			irec);
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		irec->rm_startblock = be64_to_cpu(rec->rtrmap.rm_startblock);
+		irec->rm_blockcount = be64_to_cpu(rec->rtrmap.rm_blockcount);
+		irec->rm_owner = be64_to_cpu(rec->rtrmap.rm_owner);
+		error = xfs_rmap_irec_offset_unpack(
+				be64_to_cpu(rec->rtrmap.rm_offset), irec);
+	} else {
+		irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
+		irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
+		irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
+		error = xfs_rmap_irec_offset_unpack(
+				be64_to_cpu(rec->rmap.rm_offset), irec);
+	}
+
 	if (xfs_metadata_is_sick(error))
 		xfs_btree_mark_sick(cur);
 	return error;
@@ -288,7 +323,7 @@ xfs_rmap_find_left_neighbor_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			xfs_rmap_cur_agno(cur), rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -340,7 +375,7 @@ xfs_rmap_find_left_neighbor(
 	info.stat = stat;
 
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+			xfs_rmap_cur_agno(cur), bno, 0, owner, offset, flags);
 
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_find_left_neighbor_helper, &info);
@@ -348,7 +383,7 @@ xfs_rmap_find_left_neighbor(
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, irec->rm_startblock,
+				xfs_rmap_cur_agno(cur), irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -364,7 +399,7 @@ xfs_rmap_lookup_le_range_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			xfs_rmap_cur_agno(cur), rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -413,14 +448,14 @@ xfs_rmap_lookup_le_range(
 	info.stat = stat;
 
 	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
-			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+			xfs_rmap_cur_agno(cur), bno, 0, owner, offset, flags);
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_lookup_le_range_helper, &info);
 	if (error == -ECANCELED)
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_private.a.agno, irec->rm_startblock,
+				xfs_rmap_cur_agno(cur), irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -532,7 +567,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -558,7 +593,7 @@ xfs_rmap_unmap(
 		goto out_error;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, ltrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
 			ltrec.rm_offset, ltrec.rm_flags);
 	ltoff = ltrec.rm_offset;
@@ -627,7 +662,7 @@ xfs_rmap_unmap(
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				ltrec.rm_startblock, ltrec.rm_blockcount,
 				ltrec.rm_owner, ltrec.rm_offset,
 				ltrec.rm_flags);
@@ -706,7 +741,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur),
 				cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
@@ -718,11 +753,11 @@ xfs_rmap_unmap(
 	}
 
 out_done:
-	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_unmap_error(mp, xfs_rmap_cur_agno(cur),
 				error, _RET_IP_);
 	return error;
 }
@@ -813,7 +848,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
@@ -836,7 +871,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_private.a.agno, ltrec.rm_startblock,
+				xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -875,7 +910,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
@@ -902,8 +937,8 @@ xfs_rmap_map(
 		if (have_gt &&
 		    bno + len == gtrec.rm_startblock &&
 		    (ignore_off || offset + len == gtrec.rm_offset) &&
-		    (unsigned long)ltrec.rm_blockcount + len +
-				gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX) {
+		    ltrec.rm_blockcount + len + gtrec.rm_blockcount <=
+		    xfs_rmap_len_max(cur)) {
 			/*
 			 * right edge also contiguous, delete right record
 			 * and merge into left record.
@@ -914,7 +949,7 @@ xfs_rmap_map(
 			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
 			 */
 			ltrec.rm_blockcount += gtrec.rm_blockcount;
-			trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+			trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 					gtrec.rm_startblock,
 					gtrec.rm_blockcount,
 					gtrec.rm_owner,
@@ -966,7 +1001,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -978,11 +1013,11 @@ xfs_rmap_map(
 		}
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_map_error(mp, xfs_rmap_cur_agno(cur),
 				error, _RET_IP_);
 	return error;
 }
@@ -1056,7 +1091,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1082,7 +1117,7 @@ xfs_rmap_convert(
 		goto done;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, PREV.rm_startblock,
+			xfs_rmap_cur_agno(cur), PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
 			PREV.rm_offset, PREV.rm_flags);
 
@@ -1126,7 +1161,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, LEFT.rm_startblock,
+				xfs_rmap_cur_agno(cur), LEFT.rm_startblock,
 				LEFT.rm_blockcount, LEFT.rm_owner,
 				LEFT.rm_offset, LEFT.rm_flags);
 		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
@@ -1167,7 +1202,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				xfs_rmap_cur_agno(cur), RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (bno + len == RIGHT.rm_startblock &&
@@ -1181,11 +1216,11 @@ xfs_rmap_convert(
 			 RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG)) ==
 	    (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
 	     RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG) &&
-	    (unsigned long)LEFT.rm_blockcount + len +
-	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
+	    LEFT.rm_blockcount + len + RIGHT.rm_blockcount >
+	    xfs_rmap_len_max(cur))
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
+	trace_xfs_rmap_convert_state(mp, xfs_rmap_cur_agno(cur), state,
 			_RET_IP_);
 
 	/* reset the cursor back to PREV */
@@ -1217,7 +1252,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1237,7 +1272,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1269,7 +1304,7 @@ xfs_rmap_convert(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1309,7 +1344,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1390,7 +1425,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1449,7 +1484,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1481,7 +1516,7 @@ xfs_rmap_convert(
 		NEW = PREV;
 		NEW.rm_blockcount = offset - PREV.rm_offset;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur),
 				NEW.rm_startblock, NEW.rm_blockcount,
 				NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
@@ -1510,7 +1545,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno, len,
 				owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1535,12 +1570,12 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -1576,7 +1611,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1647,7 +1682,7 @@ xfs_rmap_convert_shared(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				xfs_rmap_cur_agno(cur), RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
@@ -1659,11 +1694,11 @@ xfs_rmap_convert_shared(
 			 RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG)) ==
 	    (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
 	     RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG) &&
-	    (unsigned long)LEFT.rm_blockcount + len +
-	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
+	    LEFT.rm_blockcount + len + RIGHT.rm_blockcount >
+	    xfs_rmap_len_max(cur))
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
+	trace_xfs_rmap_convert_state(mp, xfs_rmap_cur_agno(cur), state,
 			_RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
@@ -1962,12 +1997,12 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -2005,7 +2040,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -2162,12 +2197,12 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -2202,7 +2237,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
@@ -2229,7 +2264,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 
@@ -2323,12 +2358,12 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -2472,13 +2507,12 @@ xfs_rmap_finish_one(
 	if (XFS_TEST_ERROR(false, mp,
 			XFS_ERRTAG_RMAP_FINISH_ONE))
 		return -EIO;
-
 	/*
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
+	if (rcur != NULL && xfs_rmap_cur_agno(rcur) != agno) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;

