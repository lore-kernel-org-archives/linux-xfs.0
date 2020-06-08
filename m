Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F04C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 18:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0542E20775
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 18:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bs8HrQBs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgFHSoG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 14:44:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFHSoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 14:44:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058IaZXv193488;
        Mon, 8 Jun 2020 18:44:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=01V1hwsWL0TUokOvXBEZxcS7a/nR7mvKnmk1s2rm1N0=;
 b=Bs8HrQBsO7zqdaM8WORVddxg5a2nBdf5QCCcx0aaM03hZHeEIJ+XOI+nDJgYcMQr4HBI
 F41XcEM0+8aulFFiJh7kOKzLmcwjrwU9I2FRWkiKyE0mvzUgJxS+5qwAEduJB50hlK8N
 pIEKaMkTNrG/fLUHL+d092Q8vWt6tVEjic2LmL5iXJpfOxf6DPKBme2Cwn1a5XCUOHdL
 PAGvcBR3kxoAHwyB42yLtpIQDnyYduqvdGhFU+wmXDzs4hRKE1dtaEPJ+2skeJIGa0tR
 NQwq85ezYschbzivz+hmh0iY5u+2VS0qVjC4aCHAnWGaT2UH/5CtJhSpooNFUzizPRKP Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31g3smrbcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 18:44:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058IcXKd006467;
        Mon, 8 Jun 2020 18:44:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31gn23ks2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 18:44:02 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058Ii1SK031619;
        Mon, 8 Jun 2020 18:44:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 11:44:01 -0700
Date:   Mon, 8 Jun 2020 11:44:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_copy: flush target devices before exiting
Message-ID: <20200608184400.GJ1334206@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=1
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Flush the devices we're copying to before exiting, so that we can report
any write errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2d087f71..45ee2e06 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -12,6 +12,7 @@
 #include <stdarg.h>
 #include "xfs_copy.h"
 #include "libxlog.h"
+#include "libfrog/platform.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
@@ -150,6 +151,9 @@ check_errors(void)
 			else
 				do_log(_("lseek error"));
 			do_log(_(" at offset %lld\n"), target[i].position);
+		} else if (platform_flush_device(target[i].fd, 0)) {
+			do_log(_("    %s -- flush error %d"),
+					target[i].name, errno);
 		}
 	}
 	if (first_error == 0)  {
