Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AD9C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB41B207E8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dUnxiOJw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgEVCxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:53:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56154 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgEVCxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:53:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2meN4095043;
        Fri, 22 May 2020 02:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pq3cpaRo8gv66gwj4MvbFh0t/+6dAl3qbomFCMjzJWs=;
 b=dUnxiOJw1a2cJ8BH7KSLv0fnOMCm0rPQUmRRcpo8U/oIGNFgRpKaKGFJiDP38uKQPA+y
 iigNPtt0YWnDIa0MJdw+VVgj+PQZhp+jfjFqLM59snPvm53sAqc6hL9HWoxN8JkCe8lF
 1gCB4HS9YDK52qQnHk5qK7CGrMMFGgQpSKpzYy0ahM30ddwdbKnwIjkp7VBseiFnkqPZ
 abS6enkkbKeBJ+FerWuD0+6i59VvAMC8Rzgtg6ob+UmiVZlr77fRwUAHD7Vws3NaypQb
 5xVq/SRg59GDpFaEbFH7S8XALmN/4dGod0r22SME9t//60syxH0jhka2YGAHF1sJWQmD fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284mbj0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nHfd151985;
        Fri, 22 May 2020 02:53:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 315023h632-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2rm0o004666;
        Fri, 22 May 2020 02:53:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:47 -0700
Subject: [PATCH 03/12] xfs: remove unused xfs_inode_ag_iterator function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:53:46 -0700
Message-ID: <159011602645.77079.8961337594949586276.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=3 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Not used by anyone, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

