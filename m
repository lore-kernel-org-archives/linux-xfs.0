Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A41C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 18:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1AE420732
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 18:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SVoDsdXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgFRSUd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 14:20:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgFRSUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 14:20:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IIHIn6180207;
        Thu, 18 Jun 2020 18:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=R3RQDLVlaWCx+1dmZiq631hLJ1oOAzhA17m9pziAYMA=;
 b=SVoDsdXU1zbdxUviqA5QpQBrtIQXBrh4pon8xIVJ0cIr1Z3SYOWiEddbxmwjBbp3zuis
 H5LUCCuuqZ1kaHsPNK4D9q+LE+Jins8566lfx5KtWQdKiubypga0eDXfgslpIxYQXxEJ
 fs0B28YdDdXSHBKiMT+qcOn1Y7Wmjzsge2Brw2Bd8CsZ3xfBJNR3sI6Tf3nCLlBv2lCR
 NavMKfWJonR0sAsZnjAzlSF17H2lMNnyQu4jQDytq1uN8gFsf+Bga7lDyEPIc8StYyLo
 iJzsFrfMemAIyAgE875MFvMP2RYC/dXooh7Cao1m9rX7OgzgWkT09cNYPtkWlHKmm8h5 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31qecm1aw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 18:20:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IIDGaK194739;
        Thu, 18 Jun 2020 18:18:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31q66sxjg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 18:18:29 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05IIISQB005509;
        Thu, 18 Jun 2020 18:18:28 GMT
Received: from localhost (/10.159.234.138)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 11:18:28 -0700
Date:   Thu, 18 Jun 2020 11:18:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v3] xfs_copy: flush target devices before exiting
Message-ID: <20200618181825.GY11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 malwarescore=0
 clxscore=1015 adultscore=0 suspectscore=1 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Flush the devices we're copying to before exiting, so that we can report
any write errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: flush before we yell about copies failing to complete
v2: fix thinko in v1 patch
---
 copy/xfs_copy.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2d087f71..38a20d37 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -12,6 +12,7 @@
 #include <stdarg.h>
 #include "xfs_copy.h"
 #include "libxlog.h"
+#include "libfrog/platform.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
@@ -138,6 +139,14 @@ check_errors(void)
 	int	i, first_error = 0;
 
 	for (i = 0; i < num_targets; i++)  {
+		if (target[i].state != INACTIVE) {
+			if (platform_flush_device(target[i].fd, 0)) {
+				target[i].error = errno;
+				target[i].state = INACTIVE;
+				target[i].err_type = 2;
+			}
+		}
+
 		if (target[i].state == INACTIVE)  {
 			if (first_error == 0)  {
 				first_error++;
@@ -145,10 +154,21 @@ check_errors(void)
 				_("THE FOLLOWING COPIES FAILED TO COMPLETE\n"));
 			}
 			do_log("    %s -- ", target[i].name);
-			if (target[i].err_type == 0)
+			switch (target[i].err_type) {
+			case 0:
 				do_log(_("write error"));
-			else
+				break;
+			case 1:
 				do_log(_("lseek error"));
+				break;
+			case 2:
+				do_log(_("flush error"));
+				break;
+			default:
+				do_log(_("unknown error type %d"),
+						target[i].err_type);
+				break;
+			}
 			do_log(_(" at offset %lld\n"), target[i].position);
 		}
 	}
