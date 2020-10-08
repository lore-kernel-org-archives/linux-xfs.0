Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37D5C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58AA2085B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MdE2viE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgJHD4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:56:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60598 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgJHD4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 23:56:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983mvHM124491;
        Thu, 8 Oct 2020 03:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E+XbxTkCGoYDe4AVxbgiGv0okoYGTtADZEEHm8pfH54=;
 b=MdE2viE8tSM3oT7An/heDslJGtnBMxMjU72PHrz4BWU8VgD2lQPksgau1b4wKV57UNue
 Yh0Nd+6M6FLjBSVlUoqgNaQKnYDDmwfJDbkkf2s3+e153ypr6usi51ahco4DCmB6a4D3
 kXNmeI47V2Vrpf5iN+ENyBZrIud7TnFDKEj0t1FH7xesbZf6lPmOejGHjSOLladNVfZs
 zU49zwDvSYLpnjLqFUW+NmJK6jcCs/Rv9DwR9rQy5vgK96PfLslypOGebJwXGo7XYJHI
 09nWviowrIlKGS6pH5nqOlLcKtVXDNsznqWrD2PP9VV34sW506ynQoc5vioXbi0D0ML8 Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetb5g4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:56:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983kDt1018380;
        Thu, 8 Oct 2020 03:56:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33y380ep9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:56:14 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0983uDVV025180;
        Thu, 8 Oct 2020 03:56:13 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:56:13 -0700
Subject: [PATCH 2/2] xfs: make xfs_growfs_rt update secondary superblocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        sandeen@redhat.com
Date:   Wed, 07 Oct 2020 20:56:12 -0700
Message-ID: <160212937238.248573.3832120826354421788.stgit@magnolia>
In-Reply-To: <160212936001.248573.7813264584242634489.stgit@magnolia>
References: <160212936001.248573.7813264584242634489.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=3 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we call growfs on the data device, we update the secondary
superblocks to reflect the updated filesystem geometry.  We need to do
this for growfs on the realtime volume too, because a future xfs_repair
run could try to fix the filesystem using a backup superblock.

This was observed by the online superblock scrubbers while running
xfs/233.  One can also trigger this by growing an rt volume, cycling the
mount, and creating new rt files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rtalloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1c3969807fb9..5b2e68d9face 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -18,7 +18,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
-
+#include "xfs_sb.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1108,6 +1108,11 @@ xfs_growfs_rt(
 	 */
 	kmem_free(nmp);
 
+	/* Update secondary superblocks now the physical grow has completed */
+	error = xfs_update_secondary_sbs(mp);
+	if (error)
+		return error;
+
 	/*
 	 * If we had to allocate a new rsum_cache, we either need to free the
 	 * old one (if we succeeded) or free the new one and restore the old one

