Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635F0C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 18:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DA52063A
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 18:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IlbauGd7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgFHSsC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 14:48:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFHSsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 14:48:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058Ikolc095528;
        Mon, 8 Jun 2020 18:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=jgmwQWB1PuvNtMIKhmntFC9apccZlDUI/nYSidH3K3E=;
 b=IlbauGd7Nx0L3EiZNtr9UL9bpigvVMkYMCcNjUfjp9bR6PYr964/Tg4zD9LjHoE/ZkdK
 02l03qrBOVGzGuyPBcn3hyBsGuuCnTJnVyjioMMD5gz6tFYX2gdIg3q0UztVupfidQkR
 L+T0nUgkOQYU8EPKrlGFQAvklKQrjv0OdeBSUZyUARab1H5PPsgzyFY+CvCDqpr89X5F
 1emZmG5DdS5OGQOyF71oE5iQvg2H4nYp6KKFSTR2/TLQcG9tGXgiRsSkijCED2KRRxZJ
 cYqeUNc5CD4Ne2bXKjqs/SBn+OgYKPWpgZ33VGiYR26He3YtIi+PunkvBAyHtub3bsqX cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31g33m0evb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 18:47:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058IllTC028628;
        Mon, 8 Jun 2020 18:47:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31gmqmkasp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 18:47:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058Ilw9d012345;
        Mon, 8 Jun 2020 18:47:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 11:47:58 -0700
Date:   Mon, 8 Jun 2020 11:47:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs_copy: flush target devices before exiting
Message-ID: <20200608184757.GL1334206@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Flush the devices we're copying to before exiting, so that we can report
any write errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2d087f71..7657ad3e 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -12,6 +12,7 @@
 #include <stdarg.h>
 #include "xfs_copy.h"
 #include "libxlog.h"
+#include "libfrog/platform.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
@@ -150,6 +151,10 @@ check_errors(void)
 			else
 				do_log(_("lseek error"));
 			do_log(_(" at offset %lld\n"), target[i].position);
+		} else if (platform_flush_device(target[i].fd, 0)) {
+			do_log(_("    %s -- flush error %d"),
+					target[i].name, errno);
+			first_error++;
 		}
 	}
 	if (first_error == 0)  {
