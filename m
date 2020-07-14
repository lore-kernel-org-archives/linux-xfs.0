Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE15C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C10FC206F0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zf/on3fA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgGNVqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:46:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVqs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:46:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELbalo150159;
        Tue, 14 Jul 2020 21:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XqUbxm8yTcJeJ/XeIVvJXUsMtx4cYAjU3z2gaRUFDVg=;
 b=Zf/on3fAd+kS+AtcvpDcqzFNHRB5X3QxtwrTM+3CDH66p3VItwqbOBXAcjwuJ0ijJRdA
 mLWzDfmNvQ7CPELP71A1fz68F/yF1vUnsb5Z2lFbJvAi/NM5zNP9FOZIfUHwOkCPdWpc
 i+LTzA9pkqwSUG+ZG4uU0SFL1F9xxWT3Utxwc87gYNPqFfUyGokK5gl4Rwm8QAsVbq7Q
 y4Spkdb7hxbpv9mcHBtaRxEG06nFeUZsg8rP30FSPVPz/Xg8fHXvgt437Z0Abh+eojCv
 ADg6VsqTjyolDJj8lIXbwUXRthZHnGu190eW+l7/zJyo5nRsN8J5bbI8L+XF9uGDP8u2 Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cm80jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:46:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELgcIA088699;
        Tue, 14 Jul 2020 21:46:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 327qbygpq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06ELkiPw023260;
        Tue, 14 Jul 2020 21:46:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:44 -0700
Subject: [PATCH 1/3] xfs_db: stop misusing an onstack inode
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:43 -0700
Message-ID: <159476320311.3156851.15212854498898688157.stgit@magnolia>
In-Reply-To: <159476319690.3156851.8364082533532014066.stgit@magnolia>
References: <159476319690.3156851.8364082533532014066.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The onstack inode in xfs_check's process_inode is a potential landmine
since it's not a /real/ incore inode.  The upcoming 5.8 merge will make
this messier wrt inode forks, so just remove the onstack inode and
reference the ondisk fields directly.  This also reduces the amount of
thinking that I have to do w.r.t. future libxfs porting efforts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |  100 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 56 insertions(+), 44 deletions(-)


diff --git a/db/check.c b/db/check.c
index 12c03b6d..96abea21 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2707,7 +2707,6 @@ process_inode(
 {
 	blkmap_t		*blkmap;
 	xfs_fsblock_t		bno = 0;
-	struct xfs_inode	xino;
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
@@ -2724,6 +2723,12 @@ process_inode(
 	xfs_qcnt_t		rc = 0;
 	int			v = 0;
 	mode_t			mode;
+	uint16_t		diflags;
+	uint64_t		diflags2 = 0;
+	xfs_nlink_t		nlink;
+	xfs_dqid_t		uid;
+	xfs_dqid_t		gid;
+	xfs_dqid_t		prid;
 	static char		okfmts[] = {
 		0,				/* type 0 unused */
 		1 << XFS_DINODE_FMT_DEV,	/* FIFO */
@@ -2750,10 +2755,6 @@ process_inode(
 		"dev", "local", "extents", "btree", "uuid"
 	};
 
-	/* xfs_inode_from_disk expects to have an mp to work with */
-	xino.i_mount = mp;
-	libxfs_inode_from_disk(&xino, dip);
-
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
 	if (!isfree) {
 		id = find_inode(ino, 1);
@@ -2775,12 +2776,25 @@ process_inode(
 		error++;
 		return;
 	}
+	if (dip->di_version == 1) {
+		nlink = be16_to_cpu(dip->di_onlink);
+		prid = 0;
+	} else {
+		nlink = be32_to_cpu(dip->di_nlink);
+		prid = (xfs_dqid_t)be16_to_cpu(dip->di_projid_hi) << 16 |
+				   be16_to_cpu(dip->di_projid_lo);
+	}
+	uid = be32_to_cpu(dip->di_uid);
+	gid = be32_to_cpu(dip->di_gid);
+	diflags = be16_to_cpu(dip->di_flags);
+	if (xfs_sb_version_has_v3inode(&mp->m_sb))
+		diflags2 = be64_to_cpu(dip->di_flags2);
 	if (isfree) {
-		if (xino.i_d.di_nblocks != 0) {
+		if (be64_to_cpu(dip->di_nblocks) != 0) {
 			if (v)
 				dbprintf(_("bad nblocks %lld for free inode "
 					 "%lld\n"),
-					xino.i_d.di_nblocks, ino);
+					be64_to_cpu(dip->di_nblocks), ino);
 			error++;
 		}
 		if (dip->di_nlink != 0) {
@@ -2809,24 +2823,24 @@ process_inode(
 	 */
 	mode = be16_to_cpu(dip->di_mode);
 	if ((((mode & S_IFMT) >> 12) > 15) ||
-	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << xino.i_d.di_format)))) {
+	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << dip->di_format)))) {
 		if (v)
 			dbprintf(_("bad format %d for inode %lld type %#o\n"),
-				xino.i_d.di_format, id->ino, mode & S_IFMT);
+				dip->di_format, id->ino, mode & S_IFMT);
 		error++;
 		return;
 	}
 	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >= XFS_LITINO(mp)) {
 		if (v)
 			dbprintf(_("bad fork offset %d for inode %lld\n"),
-				xino.i_d.di_forkoff, id->ino);
+				dip->di_forkoff, id->ino);
 		error++;
 		return;
 	}
-	if ((unsigned int)xino.i_d.di_aformat > XFS_DINODE_FMT_BTREE)  {
+	if ((unsigned int)dip->di_aformat > XFS_DINODE_FMT_BTREE)  {
 		if (v)
 			dbprintf(_("bad attribute format %d for inode %lld\n"),
-				xino.i_d.di_aformat, id->ino);
+				dip->di_aformat, id->ino);
 		error++;
 		return;
 	}
@@ -2834,43 +2848,43 @@ process_inode(
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
-			id->ino, mode, fmtnames[(int)xino.i_d.di_format],
-			fmtnames[(int)xino.i_d.di_aformat],
-			xino.i_d.di_nextents,
-			xino.i_d.di_anextents,
-			xino.i_d.di_nblocks, xino.i_d.di_size,
-			xino.i_d.di_flags & XFS_DIFLAG_REALTIME ? " rt" : "",
-			xino.i_d.di_flags & XFS_DIFLAG_PREALLOC ? " pre" : "",
-			xino.i_d.di_flags & XFS_DIFLAG_IMMUTABLE? " imm" : "",
-			xino.i_d.di_flags & XFS_DIFLAG_APPEND   ? " app" : "",
-			xino.i_d.di_flags & XFS_DIFLAG_SYNC     ? " syn" : "",
-			xino.i_d.di_flags & XFS_DIFLAG_NOATIME  ? " noa" : "",
-			xino.i_d.di_flags & XFS_DIFLAG_NODUMP   ? " nod" : "");
+			id->ino, mode, fmtnames[(int)dip->di_format],
+			fmtnames[(int)dip->di_aformat],
+			be32_to_cpu(dip->di_nextents),
+			be16_to_cpu(dip->di_anextents),
+			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
+			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
+			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
+			diflags & XFS_DIFLAG_IMMUTABLE? " imm" : "",
+			diflags & XFS_DIFLAG_APPEND   ? " app" : "",
+			diflags & XFS_DIFLAG_SYNC     ? " syn" : "",
+			diflags & XFS_DIFLAG_NOATIME  ? " noa" : "",
+			diflags & XFS_DIFLAG_NODUMP   ? " nod" : "");
 	security = 0;
 	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		type = DBM_DIR;
-		if (xino.i_d.di_format == XFS_DINODE_FMT_LOCAL)
+		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			break;
-		blkmap = blkmap_alloc(xino.i_d.di_nextents);
+		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
 		break;
 	case S_IFREG:
-		if (xino.i_d.di_flags & XFS_DIFLAG_REALTIME)
+		if (diflags & XFS_DIFLAG_REALTIME)
 			type = DBM_RTDATA;
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
-			blkmap = blkmap_alloc(xino.i_d.di_nextents);
+			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
 			addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
-			blkmap = blkmap_alloc(xino.i_d.di_nextents);
+			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
-			blkmap = blkmap_alloc(xino.i_d.di_nextents);
+			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
 			addlink_inode(id);
 		}
 		else
@@ -2887,10 +2901,10 @@ process_inode(
 		break;
 	}
 
-	id->isreflink = !!(xino.i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
-	setlink_inode(id, VFS_I(&xino)->i_nlink, type == DBM_DIR, security);
+	id->isreflink = !!(diflags2 & XFS_DIFLAG2_REFLINK);
+	setlink_inode(id, nlink, type == DBM_DIR, security);
 
-	switch (xino.i_d.di_format) {
+	switch (dip->di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		process_lclinode(id, dip, type, &totdblocks, &totiblocks,
 			&nextents, &blkmap, XFS_DATA_FORK);
@@ -2906,7 +2920,7 @@ process_inode(
 	}
 	if (XFS_DFORK_Q(dip)) {
 		sbversion |= XFS_SB_VERSION_ATTRBIT;
-		switch (xino.i_d.di_aformat) {
+		switch (dip->di_aformat) {
 		case XFS_DINODE_FMT_LOCAL:
 			process_lclinode(id, dip, DBM_ATTR, &atotdblocks,
 				&atotiblocks, &anextents, NULL, XFS_ATTR_FORK);
@@ -2941,30 +2955,28 @@ process_inode(
 		default:
 			break;
 		}
-		if (ic) {
-			quota_add(&xino.i_d.di_projid, &VFS_I(&xino)->i_gid,
-				  &VFS_I(&xino)->i_uid, 0, bc, ic, rc);
-		}
+		if (ic)
+			quota_add(&prid, &gid, &uid, 0, bc, ic, rc);
 	}
 	totblocks = totdblocks + totiblocks + atotdblocks + atotiblocks;
-	if (totblocks != xino.i_d.di_nblocks) {
+	if (totblocks != be64_to_cpu(dip->di_nblocks)) {
 		if (v)
 			dbprintf(_("bad nblocks %lld for inode %lld, counted "
 				 "%lld\n"),
-				xino.i_d.di_nblocks, id->ino, totblocks);
+				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
 		error++;
 	}
-	if (nextents != xino.i_d.di_nextents) {
+	if (nextents != be32_to_cpu(dip->di_nextents)) {
 		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
-				xino.i_d.di_nextents, id->ino, nextents);
+				be32_to_cpu(dip->di_nextents), id->ino, nextents);
 		error++;
 	}
-	if (anextents != xino.i_d.di_anextents) {
+	if (anextents != be16_to_cpu(dip->di_anextents)) {
 		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
-				xino.i_d.di_anextents, id->ino, anextents);
+				be16_to_cpu(dip->di_anextents), id->ino, anextents);
 		error++;
 	}
 	if (type == DBM_DIR)

