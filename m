Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0097C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF35521882
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XZzoubpf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbfKHFLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:11:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfKHFLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 00:11:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA85B9R6166079;
        Fri, 8 Nov 2019 05:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=8GWRoS/GxXB2K8S1oy7WSGsmhUI7VC/zoT/9cHq3BMU=;
 b=XZzoubpfQxqPN2K3pIaHQWOc3rCqpuf0IHLwOo3FRsvpTN82Ts/9VO0J2qpQ8cL2zM/2
 bOLU2YhTreqLzT7m48TfCQ7xa6zsbpHM+xrKCRtgFM1Dd4Fzc0/WZj94ohJC3Y5c4B64
 fx/1idgVmuWjDUeBYZnRpjqnlE88wyYQPzow/6qVxjuN96un39dKOWsJxXCFzsYvK0mi
 h+coz+BtZnWHzTUPEzttDix9fyoPT5pfrkYxeU62ALKNdQvb8KU2DWcqnGxM+MSVxKGF
 EB5vFD5fdNIN6lGlJkq/rdJBvJK53sBm4u/pBPHuGQcmbR2SSpYVZkdDcGgMnsEkO/Bf sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w12vws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 05:11:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8510A9156901;
        Fri, 8 Nov 2019 05:11:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w50m452dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 05:11:30 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA85BTL2002033;
        Fri, 8 Nov 2019 05:11:29 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 21:11:28 -0800
Date:   Fri, 8 Nov 2019 08:11:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ian Kent <raven@themaw.net>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: remove a stray tab in xfs_remount_rw()
Message-ID: <20191108051121.GA26279@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extra tab makes the code slightly confusing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b3188ea49413..ede6fac47c56 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1599,7 +1599,7 @@ xfs_remount_rw(
 	if (error) {
 		xfs_err(mp,
 			"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}
 	xfs_start_block_reaping(mp);
-- 
2.20.1

