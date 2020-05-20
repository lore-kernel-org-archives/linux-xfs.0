Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A89C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A1582075F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K/ua39KY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgETBrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:47:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:47:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1lDg6027034;
        Wed, 20 May 2020 01:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DjE1uIIFxQIQ8iwV/tXLez77VTzx8ScKw6GLf2vLddI=;
 b=K/ua39KYdV2nYxNV02YEZG2o1ZNfLEb97bEvNojouX4nX+NCxhh40z1LutWvfJORVVS0
 08lFB3OfD1JDbaxUMBXm2haHQNlfXRHBG7aPfwwrl7CA4/9wD1omCgU20TvPzvfBvLEN
 ivb3JB5asptpXOXhTRu9nyD15exP3MCGT1B4pvgCt9zCHZ0HqlyBqb1ZHfWiDlQ1tVjK
 RQse2MIc4IBogOVY3BHazpmNB/zTCvh6eolLYnPoIgSqvLzF4BC4yQrK5XnvoUzALAzL
 hRfwb7nuPpz3QZU3IiUYOWrkUXEQ8ay5EtNDyqp6HovAo81lDIiOzJCVUM7p4Gml4MoW bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127kr8jgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:47:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1h8ft032515;
        Wed, 20 May 2020 01:45:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 312sxtudv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:45:38 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1jcqJ024225;
        Wed, 20 May 2020 01:45:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:45:37 -0700
Subject: [PATCH 03/11] xfs: remove unused xfs_inode_ag_iterator function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:45:37 -0700
Message-ID: <158993913684.976105.8615567083408853948.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=3 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=3 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Not used by anyone, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   11 -----------
 fs/xfs/xfs_icache.h |    3 ---
 2 files changed, 14 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b1e2541810be..6aafb547f21a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -985,17 +985,6 @@ xfs_inode_ag_iterator_flags(
 	return last_error;
 }
 
-int
-xfs_inode_ag_iterator(
-	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip, int flags,
-					   void *args),
-	int			flags,
-	void			*args)
-{
-	return xfs_inode_ag_iterator_flags(mp, execute, flags, args, 0);
-}
-
 int
 xfs_inode_ag_iterator_tag(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index c13bc8a3e02f..0556fa32074f 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -71,9 +71,6 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
-int xfs_inode_ag_iterator(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, int flags, void *args),
-	int flags, void *args);
 int xfs_inode_ag_iterator_flags(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args, int iter_flags);

