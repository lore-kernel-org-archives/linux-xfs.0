Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482B2C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16DF421881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n+UJX7NV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfHZVbc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51046 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfHZVbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLEuwq161933;
        Mon, 26 Aug 2019 21:31:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VceLnt+CSl8VWMjZl0O/AzUH6xTt1RDr4Ob3TN0db40=;
 b=n+UJX7NVqlx8rmaBQ4VQVbUGPg9uKj40pMf03PewoN03dI5Q60+94UV0lNcfHNon1vTG
 5IpgvJJa4+gGH53I+ZOShOJrH2MxrGGopyPXPJo7SGNG5bPBKjDinCsjAl2V0rxEyLfd
 R5sDw+FkfjyYB3DZdn1rlwTDeLTVXDqpbYZVkkKCyOYIBpiOrreuVYnRgyD1ziKmmsIR
 6l+6o74To/zAEx4gLj6FJ/8GFImlX+VPKPehAFqRxq9y3GF2Pb8T/HohXvhi3Jlzs6rX
 ay80N84YrjkuZ6ca1BFqad4z1nFzFPVdqoPM0KNP9losnOTNoTm7udESF/lNQlP3G7Sh nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2umq5t82c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIQdj024952;
        Mon, 26 Aug 2019 21:31:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2umj1tk99s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:29 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLVSdY008478;
        Mon, 26 Aug 2019 21:31:28 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:28 -0700
Subject: [PATCH 03/11] xfs_scrub: better reporting of metadata media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:24 -0700
Message-ID: <156685508488.2843133.4495703850578724801.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we report bad metadata, we inexplicably report the physical address
in units of sectors, whereas for file data we report file offsets in
units of bytes.  Fix the metadata reporting units to match the file data
units (i.e. bytes) and skip the printf for all other cases.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index e78c8463..a83fffdd 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -368,7 +368,7 @@ xfs_check_rmap_error_report(
 	void			*arg)
 {
 	const char		*type;
-	char			buf[32];
+	char			buf[DESCR_BUFSZ];
 	uint64_t		err_physical = *(uint64_t *)arg;
 	uint64_t		err_off;
 
@@ -377,14 +377,12 @@ xfs_check_rmap_error_report(
 	else
 		err_off = 0;
 
-	snprintf(buf, 32, _("disk offset %"PRIu64),
-			(uint64_t)BTOBB(map->fmr_physical + err_off));
-
+	/* Report special owners */
 	if (map->fmr_flags & FMR_OF_SPECIAL_OWNER) {
+		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
+				(uint64_t)map->fmr_physical + err_off);
 		type = xfs_decode_special_owner(map->fmr_owner);
-		str_error(ctx, buf,
-_("%s failed read verification."),
-				type);
+		str_error(ctx, buf, _("media error in %s."), type);
 	}
 
 	/*

