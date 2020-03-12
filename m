Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F088C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59020206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SN8Yvg2Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387658AbgCLDpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:45:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:45:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3dQkb123601;
        Thu, 12 Mar 2020 03:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pG3B3XTlUxnTDfKMG3mLcg2jPnn1mXEmCLguixsBGcw=;
 b=SN8Yvg2YtGEts2lUxMDA5OCr+LiJS0P41/KUOVOedgTKUluf+5Fd+rFGUg/TOA8WbT31
 XAxNuqB0Qqq+sx4X+8oZbqE+hOSrOuppyBSVorq3nRiFsBtG4FaXBYgTvYw08oeIXpej
 f2zWV6ibDry1RS8uL0fGHaWLJdS2uQ2xFeEBai8dKxlRJRDoBzpyjfc12z0BoTm3FRFI
 RGK6zFOa0bb2XdVPosHXFrQQYE7HJ6lNy5P3JzGy40NTjQ36MuAflh2lLYy1FuECt/ka
 duPACGAd71ooxzyzFtZ7b/OLbtMKZDQMcSDAIKwoT9uF8Re45foRDHuAOKSWmozY2cPO vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yp7hmbj5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3c8sm054793;
        Thu, 12 Mar 2020 03:45:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yp8p5qy7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:19 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3jIHS022315;
        Thu, 12 Mar 2020 03:45:19 GMT
Received: from localhost (/10.159.134.61) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 11 Mar 2020 20:45:15 -0700
USER-AGENT: StGit/0.17.1-dirty
MIME-Version: 1.0
Message-ID: <158398471398.1307855.8968898997868213653.stgit@magnolia>
Date:   Thu, 12 Mar 2020 03:45:14 +0000 (UTC)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5/7] xfs: make btree cursor private union anonymous
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
In-Reply-To: <158398468107.1307855.8287106235853942996.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxlogscore=892
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=952 suspectscore=1 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rename the union and it's internal structures to the new name and
remove the temporary defines that facilitated the change.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 00a58ac8b696..12a2bc93371d 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -213,7 +213,7 @@ typedef struct xfs_btree_cur
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
 			xfs_agnumber_t	agno;	/* ag number */
 			union xfs_btree_cur_private	priv;
-		} a;
+		} bc_ag;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
 			int		allocated;	/* count of alloced */
@@ -222,10 +222,8 @@ typedef struct xfs_btree_cur
 			char		flags;		/* flags */
 #define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
 #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
-		} b;
-	}		bc_private;	/* per-btree type data */
-#define bc_ag	bc_private.a
-#define bc_ino	bc_private.b
+		} bc_ino;
+	};				/* per-btree type data */
 } xfs_btree_cur_t;
 
 /* cursor flags */

