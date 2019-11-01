Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7CFCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE6A721734
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Och8iAx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfKATY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 15:24:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfKATY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 15:24:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JNh1W194662;
        Fri, 1 Nov 2019 19:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Cll23umo2ngwh6jMjYSJV56gkI570Wso95sF4NHlZPY=;
 b=Och8iAx55XOPIizTbNCiddsATDwEX21g5Tc1QkNlswfNLSHufd+8njANJtzNRoUQKh80
 9aPHYfUv3gtFB/c83ZYNVPcYslsxtBBxdJb0f2ADUsdHZM0mXy4jr9RL7HZuhqngYRmk
 oGqDPoxWF1KW/CLhnj6bhBc8fsXkijJ5/Okl8wOwDB5lF1pEvUnYbOlDPhJmMnM60yUi
 lqJj4sb43yNW9J4p27TdsqUs9XfzDm3kBNsXQBcT/eWzzBctTkUsikLJrPrXS5Mcxb0p
 yhxBNZTqyX7Id1LsCG9O01M0S8NmwfPzIFFIn/VluHXBG6VjFFF82UVyRIfnDVEKCYT4 Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vxwhfur4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:24:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JOMNw108910;
        Fri, 1 Nov 2019 19:24:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vyv9jtkr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:24:24 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1JNSlb028146;
        Fri, 1 Nov 2019 19:23:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 11:52:45 -0700
Date:   Fri, 1 Nov 2019 11:52:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/5] mkfs: fix incorrect error message
Message-ID: <20191101185245.GC15222@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we encounter a failure while fixing the freelist during mkfs, we
shouldn't print a misleading message about space reservation.  Fix it so
that we print something about what we were trying to do when the error
happened.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 10a40cd4..18338a61 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3481,8 +3481,11 @@ initialise_ag_freespace(
 	libxfs_alloc_fix_freelist(&args, 0);
 	libxfs_perag_put(args.pag);
 	c = -libxfs_trans_commit(tp);
-	if (c)
-		res_failed(c);
+	if (c) {
+		errno = c;
+		perror(_("initializing AG free space list"));
+		exit(1);
+	}
 }
 
 /*
