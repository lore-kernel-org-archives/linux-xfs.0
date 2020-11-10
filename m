Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31833C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA13F20797
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m6qwFRtT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgKJSD4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKJSD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxx66119657;
        Tue, 10 Nov 2020 18:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YZu/M8AjjhTpEM04zYHY1t+TM74AstFK37Z7bGd6tjA=;
 b=m6qwFRtT45oRLwXG45E+1ilO+gYtdF/38OcDukiXpsChiglJePuLY8hu5deOH78YpbJy
 7hrpRutHaS70HVmoEQBGUGrhNlLCi5T6YGYcyo+8UeG6w+kMF+ecAErLVXN/mrK7tkbG
 UxBje0ZmgRSWZq2Z1XSOVtksP2JwylSpwzKl0EousGSG7XrJOtr9sgAB0AyfCKzNQlDW
 FZwY7e1I1hJbWgyxwhe4/e4y2esDzLvLHdM/FwMWKNmIuGKjAfBXObzw2C33vtRlwcx6
 rlUyOZk+aMeelXXtpWqKD2C4d/PJzDnqCCXrFFKIZSRmCs3jLrmsH5bwNs81AGtdp4NP bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhkw1ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI17Nb092801;
        Tue, 10 Nov 2020 18:03:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp76me7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:50 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAI3n8c012655;
        Tue, 10 Nov 2020 18:03:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:48 -0800
Subject: [PATCH 7/9] xfs_repair: correctly detect partially written extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:47 -0800
Message-ID: <160503142782.1201232.6736994012975595971.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=2 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

