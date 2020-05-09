Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E04C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2182184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TTiam2tD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgEIQbR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49948 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQbR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgk3072364;
        Sat, 9 May 2020 16:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yWBFdkd+DNqSoqE0nFsLFgOqVs3wQ2lUD7iFo+mXkU0=;
 b=TTiam2tDhAYfiY1cfUZicC5YinVz9ZPG7aC3Y75SXqNXXMjdC3OZt+L2GPUpmTWN8/jB
 8fISRLCYPioF5ujIPWOzo+hcGChvtrEmgh4jrvqPgBw2r5UnQ8BytWiolSqh1zX7GISF
 DVfxYIV7KkgwQVvtKhjjZz+lq8tQWNoOGbTUZS7UOvQcFjx2gFtw9Q+e3cPkyYXMmV4d
 72v2qcDextL0NTHupJaoceoQP4tl617iPG4kMmsA+NZughwwSMQr8USYHQARQh3Oc9JY
 7OcZZubZcykfl7saXmjdedRVzUVHDA6ZWRxa0ew+oYQznEwLqzSNwF4Z/eFprN1pB3rs KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30wkxqs6fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTu8w112530;
        Sat, 9 May 2020 16:31:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30wx11cvcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GVERp026015;
        Sat, 9 May 2020 16:31:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:13 -0700
Subject: [PATCH 12/16] xfs_repair: remove verify_aginum
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:31:14 -0700
Message-ID: <158904187403.982941.11165171953121545705.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace this homegrown inode pointer verification function with the
libxfs checking helper.  This one is a little tricky because this
function (unlike all of its verify_* siblings) returned 1 for bad and 0
for good, so we must invert the checking logic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dino_chunks.c     |    6 +++--
 repair/dinode.c          |   51 ----------------------------------------------
 repair/dinode.h          |    5 -----
 repair/scan.c            |    4 ++--
 5 files changed, 6 insertions(+), 61 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 69f79a08..be06c763 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -182,6 +182,7 @@
 #define xfs_trans_roll			libxfs_trans_roll
 
 #define xfs_verify_agbno		libxfs_verify_agbno
+#define xfs_verify_agino		libxfs_verify_agino
 #define xfs_verify_cksum		libxfs_verify_cksum
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
 #define xfs_verify_fsbno		libxfs_verify_fsbno
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 6685a4d2..399d4998 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -1124,7 +1124,7 @@ check_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 
 			agino = i + irec->ino_startnum;
 
-			if (verify_aginum(mp, agno, agino))
+			if (!libxfs_verify_agino(mp, agno, agino))
 				continue;
 
 			if (nrec != NULL && nrec->ino_startnum <= agino &&
@@ -1133,7 +1133,7 @@ check_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 				continue;
 
 			if ((nrec = find_inode_rec(mp, agno, agino)) == NULL)
-				if (!verify_aginum(mp, agno, agino))
+				if (libxfs_verify_agino(mp, agno, agino))
 					if (verify_aginode_chunk(mp, agno,
 							agino, &start))
 						got_some = 1;
@@ -1215,7 +1215,7 @@ process_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 			 * good tree), bad inode numbers, and inode numbers
 			 * pointing to bogus inodes
 			 */
-			if (verify_aginum(mp, agno, agino))
+			if (!libxfs_verify_agino(mp, agno, agino))
 				continue;
 
 			if (nrec != NULL && nrec->ino_startnum <= agino &&
diff --git a/repair/dinode.c b/repair/dinode.c
index 67adddd7..526ecde3 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -152,57 +152,6 @@ clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
  * misc. inode-related utility routines
  */
 
-/*
- * verify_ag_bno is heavily used. In the common case, it
- * performs just two number of compares
- * Returns 1 for bad ag/bno pair or 0 if it's valid.
- */
-static __inline int
-verify_ag_bno(xfs_sb_t *sbp,
-		xfs_agnumber_t agno,
-		xfs_agblock_t agbno)
-{
-	if (agno < (sbp->sb_agcount - 1))
-		return (agbno >= sbp->sb_agblocks);
-	if (agno == (sbp->sb_agcount - 1))
-		return (agbno >= (sbp->sb_dblocks -
-				((xfs_rfsblock_t)(sbp->sb_agcount - 1) *
-				 sbp->sb_agblocks)));
-	return 1;
-}
-
-/*
- * have a separate routine to ensure that we don't accidentally
- * lose illegally set bits in the agino by turning it into an FSINO
- * to feed to the above routine
- */
-int
-verify_aginum(xfs_mount_t	*mp,
-		xfs_agnumber_t	agno,
-		xfs_agino_t	agino)
-{
-	xfs_agblock_t	agbno;
-	xfs_sb_t	*sbp = &mp->m_sb;;
-
-	/* range check ag #, ag block.  range-checking offset is pointless */
-
-	if (agino == 0 || agino == NULLAGINO)
-		return(1);
-
-	/*
-	 * agino's can't be too close to NULLAGINO because the min blocksize
-	 * is 9 bits and at most 1 bit of that gets used for the inode offset
-	 * so if the agino gets shifted by the # of offset bits and compared
-	 * to the legal agbno values, a bogus agino will be too large.  there
-	 * will be extra bits set at the top that shouldn't be set.
-	 */
-	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno == 0)
-		return 1;
-
-	return verify_ag_bno(sbp, agno, agbno);
-}
-
 #define XR_DFSBNORANGE_VALID	0
 #define XR_DFSBNORANGE_BADSTART	1
 #define XR_DFSBNORANGE_BADEND	2
diff --git a/repair/dinode.h b/repair/dinode.h
index 4bf7affd..1bd0e0b7 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -68,11 +68,6 @@ verify_uncertain_dinode(xfs_mount_t *mp,
 		xfs_agnumber_t agno,
 		xfs_agino_t ino);
 
-int
-verify_aginum(xfs_mount_t	*mp,
-		xfs_agnumber_t	agno,
-		xfs_agino_t	agino);
-
 int
 process_uncertain_aginodes(xfs_mount_t		*mp,
 				xfs_agnumber_t	agno);
diff --git a/repair/scan.c b/repair/scan.c
index dcd4864d..76079247 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1561,7 +1561,7 @@ verify_single_ino_chunk_align(
 	 * (NULLAGINO). if it gets closer, the agino number will be illegal as
 	 * the agbno will be too large.
 	 */
-	if (verify_aginum(mp, agno, ino)) {
+	if (!libxfs_verify_agino(mp, agno, ino)) {
 		do_warn(
 _("bad starting inode # (%" PRIu64 " (0x%x 0x%x)) in %s rec, skipping rec\n"),
 			lino, agno, ino, inobt_name);
@@ -1569,7 +1569,7 @@ _("bad starting inode # (%" PRIu64 " (0x%x 0x%x)) in %s rec, skipping rec\n"),
 		return ++suspect;
 	}
 
-	if (verify_aginum(mp, agno,
+	if (!libxfs_verify_agino(mp, agno,
 			ino + XFS_INODES_PER_CHUNK - 1)) {
 		do_warn(
 _("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in %s rec, skipping rec\n"),

