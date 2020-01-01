Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09782C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD476206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ge6q/t75"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgAABQO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:16:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:16:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011GDCO095325
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ti1ISdlS4IVb78BMeGR08BEBlGC33bpvhyM+S3PfQlc=;
 b=ge6q/t75WPpW895/oe3nhBLRggtJJ+meBYWJw1QVJ3JENVcR78sdNY+hjz6YBMrHnHbC
 rtPlySaczP1zwnr+cgAsaWVCgzc+7bQzV5rhthJN5W1NFbGiwipoCUtV9lxXcxxMTV7C
 RZ2gmRNB1vnzM5JyiLMUbnSQWI7Ppbp62hdXEHHMC7u+de/8gXJp43r11L+nOFEjLe2r
 AJiR3ZmNaJbIKr561LZ4VKPTmgc6R2hF1xy5/czjHWzYY+HGujUsLDWtlJ3GEfJf9QwO
 PJO0xtRWL7uhr3RUExYNPOJJI53dCr6IcNnIOkOkWj4QVQObKJEM2bbXhFAAEBMTr06f JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vvQ172056
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x8gj91ahr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011GCAI030251
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:12 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:16:11 -0800
Subject: [PATCH 12/13] xfs: disable the agi rotor for metadata inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:16:07 -0800
Message-ID: <157784136771.1366873.13115777033543177268.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ideally, we'd put all the metadata inodes in one place if we could, so
that the metadata all stay reasonably close together instead of
spreading out over the disk.  Furthermore, if the log is internal we'd
probably prefer to keep the metadata near the log.  Therefore, disable
AGI rotoring for metadata inode allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c     |   48 ++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_ialloc.h     |   10 ++++----
 fs/xfs/libxfs/xfs_inode_util.c |    3 +--
 3 files changed, 37 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 85762f4cd8ae..6b04f5176482 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -943,20 +943,21 @@ xfs_ialloc_next_ag(
  */
 STATIC xfs_agnumber_t
 xfs_ialloc_ag_select(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_ino_t	parent,		/* parent directory inode number */
-	umode_t		mode)		/* bits set to indicate file type */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	umode_t			mode)
 {
-	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
-	xfs_agnumber_t	agno;		/* current ag number */
-	int		flags;		/* alloc buffer locking flags */
-	xfs_extlen_t	ineed;		/* blocks needed for inode allocation */
-	xfs_extlen_t	longest = 0;	/* longest extent available */
-	xfs_mount_t	*mp;		/* mount point structure */
-	int		needspace;	/* file mode implies space allocated */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
-	int		error;
+	struct xfs_mount	*mp;
+	struct xfs_perag	*pag;
+	xfs_ino_t		parent = pip ? pip->i_ino : 0;
+	xfs_agnumber_t		agcount;
+	xfs_agnumber_t		agno;
+	xfs_agnumber_t		pagno;
+	xfs_extlen_t		ineed;
+	xfs_extlen_t		longest = 0;	/* longest extent available */
+	int			needspace;	/* file mode implies space allocated */
+	int			flags;
+	int			error;
 
 	/*
 	 * Files of these types need at least one block if length > 0
@@ -965,9 +966,21 @@ xfs_ialloc_ag_select(
 	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
 	mp = tp->t_mountp;
 	agcount = mp->m_maxagi;
-	if (S_ISDIR(mode))
+	if (pip && xfs_is_metadata_inode(pip)) {
+		/*
+		 * Try to squash all the metadata inodes into the parent's
+		 * AG, or the one with the log if the log is internal, or
+		 * AG 0 if all else fails.
+		 */
+		if (xfs_verify_ino(mp, parent))
+			pagno = XFS_INO_TO_AGNO(mp, parent);
+		else if (mp->m_sb.sb_logstart != 0)
+			pagno = XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
+		else
+			pagno = 0;
+	} else if (S_ISDIR(mode)) {
 		pagno = xfs_ialloc_next_ag(mp);
-	else {
+	} else {
 		pagno = XFS_INO_TO_AGNO(mp, parent);
 		if (pagno >= agcount)
 			pagno = 0;
@@ -1755,13 +1768,14 @@ xfs_dialloc_ag(
 int
 xfs_dialloc(
 	struct xfs_trans	*tp,
-	xfs_ino_t		parent,
+	struct xfs_inode	*pip,
 	umode_t			mode,
 	struct xfs_buf		**IO_agbp,
 	xfs_ino_t		*inop)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*agbp;
+	xfs_ino_t		parent = pip ? pip->i_ino : 0;
 	xfs_agnumber_t		agno;
 	int			error;
 	int			ialloced;
@@ -1785,7 +1799,7 @@ xfs_dialloc(
 	 * We do not have an agbp, so select an initial allocation
 	 * group for inode allocation.
 	 */
-	start_agno = xfs_ialloc_ag_select(tp, parent, mode);
+	start_agno = xfs_ialloc_ag_select(tp, pip, mode);
 	if (start_agno == NULLAGNUMBER) {
 		*inop = NULLFSINO;
 		return 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 632f8ed0a228..cc854fea047b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -56,11 +56,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
  */
 int					/* error */
 xfs_dialloc(
-	struct xfs_trans *tp,		/* transaction pointer */
-	xfs_ino_t	parent,		/* parent inode (directory) */
-	umode_t		mode,		/* mode bits for new inode */
-	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
-	xfs_ino_t	*inop);		/* inode number allocated */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	struct xfs_inode	*pip,	/* parent inode (directory) */
+	umode_t			mode,	/* mode bits for new inode */
+	struct xfs_buf		**agbp,	/* buf for a.g. inode header */
+	xfs_ino_t		*inop);	/* inode number allocated */
 
 /*
  * Free disk inode.  Carefully avoids touching the incore inode, all
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 3bdbe7694499..742136f970d4 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -350,8 +350,7 @@ xfs_ialloc(
 	 * Call the space management code to pick
 	 * the on-disk inode to be allocated.
 	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
-			    ialloc_context, &ino);
+	error = xfs_dialloc(tp, pip, args->mode, ialloc_context, &ino);
 	if (error)
 		return error;
 	if (*ialloc_context || ino == NULLFSINO) {

