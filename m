Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFFFC4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE73E2076E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:02:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a40LyQqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgJHPCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 11:02:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43846 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbgJHPCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 11:02:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098F0RuA158382;
        Thu, 8 Oct 2020 15:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bnTMUVY0nKmxXNm0tm2ZViUAkInTgVseBfjcYvSi8/U=;
 b=a40LyQqbSXJsZFOXJMg4rRuDKEyxlleoXmv1KI9XsrPo7AwxZJZMKmRPIbsuReIqx+24
 bLrbls6cCKIq86ft1AcgfP0/kx5GHs8MM5clwx5+0YM3Yf+y5tECfULC2UHqBrRM1r62
 Y1oStEwYouxld55MbRjx1gS7rbKY+x4QHrNqYcJ37joVgwQ5LhnCv0Tcwpuq0nnisGdk
 ZmsQKiMTpAAp0ZyddtsvFDDClUnjRAwgmoV+YnuBmXNz6EK/6l6Eu04WrRpz46PfGoXf
 I8INEsOkXZpW8qOmdLu63pDoFUyC7qxYCA6b3hjvQ2uN1tXIoAQnObk7TNFrmXYVWXm3 yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33xetb8cf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 15:02:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098F1Gp9017171;
        Thu, 8 Oct 2020 15:02:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 341xnbt3qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 15:02:19 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098F2IEh023947;
        Thu, 8 Oct 2020 15:02:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 08:02:17 -0700
Subject: [PATCH 2/3] xfs: make xfs_growfs_rt update secondary superblocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        sandeen@redhat.com
Date:   Thu, 08 Oct 2020 08:02:17 -0700
Message-ID: <160216933700.313389.9746852330724569803.stgit@magnolia>
In-Reply-To: <160216932411.313389.9231180037053830573.stgit@magnolia>
References: <160216932411.313389.9231180037053830573.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080115
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
 fs/xfs/xfs_rtalloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1c3969807fb9..9de83723462c 100644
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
@@ -1102,7 +1102,15 @@ xfs_growfs_rt(
 		if (error)
 			break;
 	}
+	if (error)
+		goto out_free;
 
+	/* Update secondary superblocks now the physical grow has completed */
+	error = xfs_update_secondary_sbs(mp);
+	if (error)
+		return error;
+
+out_free:
 	/*
 	 * Free the fake mp structure.
 	 */

