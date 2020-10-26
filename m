Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D94C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3985207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YEkhw7Dh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406540AbgJZXe2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42948 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406526AbgJZXe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPwgF177218;
        Mon, 26 Oct 2020 23:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3VX5HxL8Xd8Mq98QR14M32nsPvNJBTOlzJe8A8FBjL8=;
 b=YEkhw7DhZ/4yjzQ8U76eObyAXjtsW+3OVwseOwvx8FVxrLDq1A2jB7kIB+ITEe/5K+hX
 pAsChoG+EXe+dCHd8I0AcE9HKRVgysJ+gFwjjXjbbyM104vmH+DPV9RClcLEGCc3Hank
 +bwS2gAAIbzopIcHIjYuopzoOUBGw/LtU37qvIIgWqDTUDW0dAHfqH1HcbAlSFd3oDhn
 dow2aEVTMbZlmzYI2VANcj789gKdlnW2SJ/i0PO3o3nyKM3aJopbD82LLcYHSDm6SY33
 mi2FcxVYB3KLRBItQUiaTksDF6AA0nb50Wy96ZMuYqo25grgmZ0NlGYFiwwyvae6DMv3 zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqd1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxBS110452;
        Mon, 26 Oct 2020 23:32:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wfqqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNWPix006610;
        Mon, 26 Oct 2020 23:32:25 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:25 -0700
Subject: [PATCH 5/5] xfs_repair: correctly detect partially written extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:24 -0700
Message-ID: <160375514426.879169.1166063350727282652.stgit@magnolia>
In-Reply-To: <160375511371.879169.3659553317719857738.stgit@magnolia>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Recently, I was able to create a realtime file with a 16b extent size
and the following data fork mapping:

data offset 0 startblock 144 (0/144) count 3 flag 0
data offset 3 startblock 147 (0/147) count 3 flag 1
data offset 6 startblock 150 (0/150) count 10 flag 0

Notice how we have a written extent, then an unwritten extent, and then
another written extent.  The current code in process_rt_rec trips over
that third extent, because repair only knows not to complain about inuse
extents if the mapping was unwritten.

This loop logic is confusing, because it tries to do too many things.
Move the phase3 and phase4 code to separate helper functions, then
isolate the code that handles a mapping that starts in the middle of an
rt extent so that it's clearer what's going on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |  180 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 112 insertions(+), 68 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index c89f21e08373..028a23cd5c8c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -176,76 +176,69 @@ verify_dfsbno_range(
 
 	return XR_DFSBNORANGE_VALID;
 }
+
 static int
-process_rt_rec(
+process_rt_rec_dups(
 	struct xfs_mount	*mp,
-	struct xfs_bmbt_irec	*irec,
 	xfs_ino_t		ino,
-	xfs_rfsblock_t		*tot,
-	int			check_dups)
+	struct xfs_bmbt_irec	*irec)
 {
-	xfs_fsblock_t		b, lastb;
+	xfs_fsblock_t		b;
 	xfs_rtblock_t		ext;
-	int			state;
-	int			pwe;		/* partially-written extent */
 
-	/*
-	 * check numeric validity of the extent
-	 */
-	if (!libxfs_verify_rtbno(mp, irec->br_startblock)) {
-		do_warn(
-_("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" PRIu64 "\n"),
-			ino,
-			irec->br_startblock,
-			irec->br_startoff);
-		return 1;
-	}
-
-	lastb = irec->br_startblock + irec->br_blockcount - 1;
-	if (!libxfs_verify_rtbno(mp, lastb)) {
-		do_warn(
-_("inode %" PRIu64 " - bad rt extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
-			ino,
-			lastb,
-			irec->br_startoff);
-		return 1;
-	}
-	if (lastb < irec->br_startblock) {
-		do_warn(
-_("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
-  "end %" PRIu64 ", offset %" PRIu64 "\n"),
-			ino,
-			irec->br_startblock,
-			lastb,
-			irec->br_startoff);
-		return 1;
-	}
-
-	/*
-	 * set the appropriate number of extents
-	 * this iterates block by block, this can be optimised using extents
-	 */
-	for (b = irec->br_startblock; b < irec->br_startblock +
-			irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {
+	for (b = rounddown(irec->br_startblock, mp->m_sb.sb_rextsize);
+	     b < irec->br_startblock + irec->br_blockcount;
+	     b += mp->m_sb.sb_rextsize) {
 		ext = (xfs_rtblock_t) b / mp->m_sb.sb_rextsize;
-		pwe = irec->br_state == XFS_EXT_UNWRITTEN &&
-				(b % mp->m_sb.sb_rextsize != 0);
-
-		if (check_dups == 1)  {
-			if (search_rt_dup_extent(mp, ext) && !pwe)  {
-				do_warn(
+		if (search_rt_dup_extent(mp, ext))  {
+			do_warn(
 _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
-  "off - %" PRIu64 ", start - %" PRIu64 ", count %" PRIu64 "\n"),
-					ino,
-					irec->br_startoff,
-					irec->br_startblock,
-					irec->br_blockcount);
-				return 1;
-			}
-			continue;
+"off - %" PRIu64 ", start - %" PRIu64 ", count %" PRIu64 "\n"),
+				ino,
+				irec->br_startoff,
+				irec->br_startblock,
+				irec->br_blockcount);
+			return 1;
 		}
+	}
 
+	return 0;
+}
+
+static int
+process_rt_rec_state(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_fsblock_t		b = irec->br_startblock;
+	xfs_rtblock_t		ext;
+	int			state;
+
+	do {
+		ext = (xfs_rtblock_t)b / mp->m_sb.sb_rextsize;
 		state = get_rtbmap(ext);
+
+		if ((b % mp->m_sb.sb_rextsize) != 0) {
+			/*
+			 * We are midway through a partially written extent.
+			 * If we don't find the state that gets set in the
+			 * other clause of this loop body, then we have a
+			 * partially *mapped* rt extent and should complain.
+			 */
+			if (state != XR_E_INUSE)
+				do_error(
+_("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
+					ino, ext, state, b);
+			b = roundup(b, mp->m_sb.sb_rextsize);
+			continue;
+		}
+
+		/*
+		 * This is the start of an rt extent.  Set the extent state if
+		 * nobody else has claimed the extent, or complain if there are
+		 * conflicting states.
+		 */
 		switch (state)  {
 		case XR_E_FREE:
 		case XR_E_UNKNOWN:
@@ -253,32 +246,83 @@ _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
 			break;
 		case XR_E_BAD_STATE:
 			do_error(
-_("bad state in rt block map %" PRIu64 "\n"),
+_("bad state in rt extent map %" PRIu64 "\n"),
 				ext);
 		case XR_E_FS_MAP:
 		case XR_E_INO:
 		case XR_E_INUSE_FS:
 			do_error(
-_("data fork in rt inode %" PRIu64 " found metadata block %" PRIu64 " in rt bmap\n"),
+_("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt bmap\n"),
 				ino, ext);
 		case XR_E_INUSE:
-			if (pwe)
-				break;
-			/* fall through */
 		case XR_E_MULT:
 			set_rtbmap(ext, XR_E_MULT);
 			do_warn(
-_("data fork in rt inode %" PRIu64 " claims used rt block %" PRIu64 "\n"),
-				ino, ext);
+_("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
+				ino, b);
 			return 1;
 		case XR_E_FREE1:
 		default:
 			do_error(
-_("illegal state %d in rt block map %" PRIu64 "\n"),
-				state, b);
+_("illegal state %d in rt extent %" PRIu64 "\n"),
+				state, ext);
 		}
+		b += mp->m_sb.sb_rextsize;
+	} while (b < irec->br_startblock + irec->br_blockcount);
+
+	return 0;
+}
+
+static int
+process_rt_rec(
+	struct xfs_mount	*mp,
+	struct xfs_bmbt_irec	*irec,
+	xfs_ino_t		ino,
+	xfs_rfsblock_t		*tot,
+	int			check_dups)
+{
+	xfs_fsblock_t		lastb;
+	int			bad;
+
+	/*
+	 * check numeric validity of the extent
+	 */
+	if (!libxfs_verify_rtbno(mp, irec->br_startblock)) {
+		do_warn(
+_("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" PRIu64 "\n"),
+			ino,
+			irec->br_startblock,
+			irec->br_startoff);
+		return 1;
 	}
 
+	lastb = irec->br_startblock + irec->br_blockcount - 1;
+	if (!libxfs_verify_rtbno(mp, lastb)) {
+		do_warn(
+_("inode %" PRIu64 " - bad rt extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
+			ino,
+			lastb,
+			irec->br_startoff);
+		return 1;
+	}
+	if (lastb < irec->br_startblock) {
+		do_warn(
+_("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
+  "end %" PRIu64 ", offset %" PRIu64 "\n"),
+			ino,
+			irec->br_startblock,
+			lastb,
+			irec->br_startoff);
+		return 1;
+	}
+
+	if (check_dups)
+		bad = process_rt_rec_dups(mp, ino, irec);
+	else
+		bad = process_rt_rec_state(mp, ino, irec);
+	if (bad)
+		return bad;
+
 	/*
 	 * bump up the block counter
 	 */

