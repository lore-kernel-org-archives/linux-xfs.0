Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E865C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ADBF206F2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0ZAjN9SB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387676AbgCLDp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:45:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDp1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:45:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3dQiV123548;
        Thu, 12 Mar 2020 03:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=A5rO2uiNABAb17Fuf9bZuBFqdIdLK+SHaTDV4xuoSMc=;
 b=0ZAjN9SB9j1PxASTBLusdhVey0gYJAJMoGLIVNEQ0cLy8PG8zdCSbINwtMSBCV5kP+yp
 uY0II9Yk1qm9vdMJP+LIUmNaQI+s0R/pBLhmIyoW9QQ5R2foBfFRlY5uIMHCs9FIBXb5
 0fMGGnCxFJzzrdLrNMMIR1+H88O9NCj+NPCa0QWhS7vlmANBAIad6C7biHxMlEXRvKAk
 reWc6b1+TCKw/TwFY6Rspz+2bglq5ExkDthAp9WvK4TG6pMAPjezbZCjaenuqGKvKoql
 U+FkN16UG2LG8RtAzaWPwmHfVqMLHLaPPodISGCxHh6G8FVm727JS3wUCbKQYBuHc0X9 fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yp7hmbj5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cDYM096633;
        Thu, 12 Mar 2020 03:45:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yp8qyav6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3jL1i022319;
        Thu, 12 Mar 2020 03:45:21 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:21 -0700
Subject: [PATCH 6/7] xfs: make the btree cursor union members named structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 11 Mar 2020 20:45:20 -0700
Message-ID: <158398472029.1307855.3111787514328025615.stgit@magnolia>
In-Reply-To: <158398468107.1307855.8287106235853942996.stgit@magnolia>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

we need to name the btree cursor private structures to be able
to pull them out of the deeply nested structure definition they are
in now.

Based on code extracted from a patchset by Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 12a2bc93371d..9884f543eb51 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -188,6 +188,24 @@ union xfs_btree_cur_private {
 	} abt;
 };
 
+/* Per-AG btree information. */
+struct xfs_btree_cur_ag {
+	struct xfs_buf			*agbp;
+	xfs_agnumber_t			agno;
+	union xfs_btree_cur_private	priv;
+};
+
+/* Btree-in-inode cursor information */
+struct xfs_btree_cur_ino {
+	struct xfs_inode	*ip;
+	int			allocated;
+	short			forksize;
+	char			whichfork;
+	char			flags;
+#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)
+#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -209,21 +227,9 @@ typedef struct xfs_btree_cur
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
 	union {
-		struct {			/* needed for BNO, CNT, INO */
-			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
-			xfs_agnumber_t	agno;	/* ag number */
-			union xfs_btree_cur_private	priv;
-		} bc_ag;
-		struct {			/* needed for BMAP */
-			struct xfs_inode *ip;	/* pointer to our inode */
-			int		allocated;	/* count of alloced */
-			short		forksize;	/* fork's inode space */
-			char		whichfork;	/* data or attr fork */
-			char		flags;		/* flags */
-#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
-#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
-		} bc_ino;
-	};				/* per-btree type data */
+		struct xfs_btree_cur_ag	bc_ag;
+		struct xfs_btree_cur_ino bc_ino;
+	};
 } xfs_btree_cur_t;
 
 /* cursor flags */

