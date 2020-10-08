Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30E8C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 22:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6440722242
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 22:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GP2EJafe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgJHWTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 18:19:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHWTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 18:19:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098MA4D5127701;
        Thu, 8 Oct 2020 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3UbNGUcO3AZkRjnmcr9+UkVCY7ZYFjGifCn0x3IO+Zc=;
 b=GP2EJafeKDQFFmKu+rTg0e6evPGTrMrGVUw1iQo3sO+4Kbg1lrOWV4PyOmLcj4koji0Q
 m0fbYO9uExmpo+GJOZEYKxDzDm1SSD4Dm7NFgLSFCKqEL9thn44v6ag8Jfrx9saalMsR
 kWHVYr6Xjs1xXPwwpQYAv/wixqqyv+M+c4RgU3ryB4E5NTX9fHI09BYzJiPAT3/rNdaT
 hW1B8EL3fW4x8hEHOq/MVg8VVe25xi3Ga+hw9geg7tYBkOtmRGjP6LRFUV99oz00FdtK
 MgwdjQp9RV/67q3/LHkXA/eesKLNFQMt4us8+gmO7IpgTErHPsWusi0tfeGL02IP61N2 qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3429jurjgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 22:19:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098MFN1X126228;
        Thu, 8 Oct 2020 22:19:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3429khkejy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 22:19:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098MJ7dw007425;
        Thu, 8 Oct 2020 22:19:07 GMT
Received: from localhost (/10.159.154.159)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 15:19:06 -0700
Date:   Thu, 8 Oct 2020 15:19:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        sandeen@redhat.com
Subject: [PATCH v2.2 2/3] xfs: make xfs_growfs_rt update secondary superblocks
Message-ID: <20201008221905.GR6540@magnolia>
References: <160216932411.313389.9231180037053830573.stgit@magnolia>
 <160216933700.313389.9746852330724569803.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160216933700.313389.9746852330724569803.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=5 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010080155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 bulkscore=0 suspectscore=5 lowpriorityscore=0 spamscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010080154
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
v2.2: don't update on error, don't fail to free memory on error
---
 fs/xfs/xfs_rtalloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1c3969807fb9..f9119ba3e9d0 100644
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
@@ -1102,7 +1102,13 @@ xfs_growfs_rt(
 		if (error)
 			break;
 	}
+	if (error)
+		goto out_free;
 
+	/* Update secondary superblocks now the physical grow has completed */
+	error = xfs_update_secondary_sbs(mp);
+
+out_free:
 	/*
 	 * Free the fake mp structure.
 	 */
