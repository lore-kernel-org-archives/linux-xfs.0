Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AACAC4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B9A23A32
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L8zlEmE+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgI0XlY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:41:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46102 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI0XlY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:41:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNe0E7081009;
        Sun, 27 Sep 2020 23:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2IRRA8bHrxQSlmjyWNPk4HLiuJwyV0DksJGT4g8fCgg=;
 b=L8zlEmE+JsC/pLOeS1PovdVjOx+4LdsE6Q3ai0fFGXLLw2AnMju6NAYtQ7lRT/gSA2Mi
 7ZC1bV8QLL6bQk01Oj1sHltPBlkS+AtHOy2K03nvLB9YFwMz7Ra/McnhoLAx31xot7aU
 4Du38o3ZlGuEm1vT4YCVcW5cj/XrLD5fiq6PXjWwNW3yPoNGuOYgCyjQqUpe0mnl7RE5
 CQo3wSEEtl8HZYNLQGd+hpgwdIbt9lXE90+fZJVuWuetgA6Jl1ItdFr74A0cO/EH1L9f
 BAXL6EDoz5htaAelWqOyl6FZbbJ+VBliB5X3DQIzVhuA1jwDlUAJLqMCR1Kq1zytKCHt SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5ajme2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:41:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNeJAL041612;
        Sun, 27 Sep 2020 23:41:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfhvkrc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:41:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08RNfFtA002098;
        Sun, 27 Sep 2020 23:41:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:41:15 -0700
Subject: [PATCH 1/4] xfs: remove xfs_defer_reset
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Sun, 27 Sep 2020 16:41:14 -0700
Message-ID: <160125007449.174438.15988765709988942671.stgit@magnolia>
In-Reply-To: <160125006793.174438.10683462598722457550.stgit@magnolia>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=3 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove this one-line helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 29e9762f3b77..36c103c14bc9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -312,22 +312,6 @@ xfs_defer_trans_roll(
 	return error;
 }
 
-/*
- * Reset an already used dfops after finish.
- */
-static void
-xfs_defer_reset(
-	struct xfs_trans	*tp)
-{
-	ASSERT(list_empty(&tp->t_dfops));
-
-	/*
-	 * Low mode state transfers across transaction rolls to mirror dfops
-	 * lifetime. Clear it now that dfops is reset.
-	 */
-	tp->t_flags &= ~XFS_TRANS_LOWMODE;
-}
-
 /*
  * Free up any items left in the list.
  */
@@ -477,7 +461,10 @@ xfs_defer_finish(
 			return error;
 		}
 	}
-	xfs_defer_reset(*tp);
+
+	/* Reset LOWMODE now that we've finished all the dfops. */
+	ASSERT(list_empty(&(*tp)->t_dfops));
+	(*tp)->t_flags &= ~XFS_TRANS_LOWMODE;
 	return 0;
 }
 
@@ -551,8 +538,7 @@ xfs_defer_move(
 	 * that behavior.
 	 */
 	dtp->t_flags |= (stp->t_flags & XFS_TRANS_LOWMODE);
-
-	xfs_defer_reset(stp);
+	stp->t_flags &= ~XFS_TRANS_LOWMODE;
 }
 
 /*

