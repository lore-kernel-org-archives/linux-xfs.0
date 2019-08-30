Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FCDC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 23:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6D0E23430
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 23:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aduxD+ps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfH3Xvo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 19:51:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfH3Xvo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 19:51:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UNmhha150747;
        Fri, 30 Aug 2019 23:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=csAMpsQG4wqPSZuDapV4gigjjJdT6pMsW/Vtki/ZK/U=;
 b=aduxD+psoRICz0c0thCC67zw7WIeRiAY4Ww2kzlc5nFUoVJtubKlCzKUEN/7ijarMORT
 PM0HkAVV6AnjtQG6v4xpAxiw8vH7lKZEQzdHDMTjMfa+m7y6G8NWLg67bRJZogpq01la
 w8MXKnxg58JnnSAg4uWFJcdeSLDmzvk2sX/tBvV1c6NQA0xKBzd5zxOEWb/dP3v03pLY
 YWytLgOG5W3ID8dRqDnp3CBrqQabKqtAAwkuka3MLvKuOdPjg33XFh0m59H66wyZKYm6
 D6UBsKDagdy28H6lWOJcsxnQORZDyNzC/U8WuSForEWkekPqpdxtRzfAwFnm85sCP3Dz Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uqdrc00c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:51:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UNmJht110344;
        Fri, 30 Aug 2019 23:51:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2upxaby7aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:51:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UNpe53015592;
        Fri, 30 Aug 2019 23:51:40 GMT
Received: from localhost (/10.159.246.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 16:51:40 -0700
Date:   Fri, 30 Aug 2019 16:51:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: define a flags field for the AG geometry ioctl structure
Message-ID: <20190830235139.GM5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=777
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=859 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define a flags field for the AG geometry ioctl structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 52d03a3a02a4..de2ead2039c5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -287,7 +287,7 @@ struct xfs_ag_geometry {
 	uint32_t	ag_ifree;	/* o: inodes free */
 	uint32_t	ag_sick;	/* o: sick things in ag */
 	uint32_t	ag_checked;	/* o: checked metadata in ag */
-	uint32_t	ag_reserved32;	/* o: zero */
+	uint32_t	ag_flags;	/* o: flags for this ag */
 	uint64_t	ag_reserved[12];/* o: zero */
 };
 #define XFS_AG_GEOM_SICK_SB	(1 << 0)  /* superblock */
