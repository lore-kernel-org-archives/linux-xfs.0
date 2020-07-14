Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A55C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C3B206F0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UtGdXlOs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgGNVqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:46:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:46:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELbLbb150097;
        Tue, 14 Jul 2020 21:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YS0Jk6yNI9WZI/LePtokX3WcAemLPzfwwuz9aHELn7w=;
 b=UtGdXlOsKYy5NpsZv4fUSzHARucziilHTjykIEsdWXJWNctN/hrIqY1lh/y+gccNxxsU
 I11SrMp1ooCiKCK351VtLj06fn8/vzgsR0Vyceay/372RtDoPHnqyRboJO2rjSq5sACZ
 GH4lY7Y2fKiwhuvybfJiHRqzINoZuDMtL8oEVvN57DRLWxDceBzeDUPSPbCD4/6MnwiJ
 p4guMhOkIqvv/JWsDSSjsWKfLC4SStpmFwJk7HB2SJXYa20ejxXGJrMOwPAV/H6dwonK
 Psx7/y8qEc9gyc/DCeNw9wBJSoyCbUs/e1VOMNdtkaOS3lD3xpYdjvnFc3VseAzannpx 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cm80gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:46:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELgdev088702;
        Tue, 14 Jul 2020 21:46:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 327qbygnww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06ELk4mI023083;
        Tue, 14 Jul 2020 21:46:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:04 -0700
Subject: [PATCH 1/1] xfs_copy: flush target devices before exiting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:01 -0700
Message-ID: <159476316158.3155818.4118699262119926332.stgit@magnolia>
In-Reply-To: <159476315531.3155818.235241123940681968.stgit@magnolia>
References: <159476315531.3155818.235241123940681968.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Flush the devices we're copying to before exiting, so that we can report
any write errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

