Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8D4C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26EE420820
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cpinnr6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbfIFDjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:39:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52624 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732014AbfIFDjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:39:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dGJh113013;
        Fri, 6 Sep 2019 03:39:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QYa0J/56ik0cVNr/8sYuAIpx/THjsj3tnlpDeE/UnGA=;
 b=cpinnr6LT0ckuvg3BCtVjl7G7ZYw0gup2OLepESpO1EOxSfzbBS6vj3wY3nkzuASXXej
 1LaFi6kurqXVMTLQ/EA6OK5GlPu+ZHMulK3g62r70kqvS8TapH2AJ2NH8hX8oDOHYze8
 2z+Lu4pxh/eHiy0y2G0JOM6junhkGaZHcvgvsoltmz/qwLk8oxOq7vhaIid3Lvl79RXO
 UHJOy3VK6NAcqXMDDO1RGzksOH1IYgewk5rk/2vYF/VU52rFqckQvV/ZT2/bLYEWoBWv
 WtcN73sTYRA3JArA5YYIV8znIZdSmJThzWJL1fjxMIvTHmZ1HwwGe+sjb5/nIVOpUKlt KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uufr08008-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cT1N096174;
        Fri, 6 Sep 2019 03:39:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uu1b99t4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:15 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863dEpc006145;
        Fri, 6 Sep 2019 03:39:14 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:39:14 -0700
Subject: [PATCH 03/11] xfs_scrub: better reporting of metadata media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:39:14 -0700
Message-ID: <156774115430.2645432.7940198097391039890.stgit@magnolia>
In-Reply-To: <156774113533.2645432.14942831726168941966.stgit@magnolia>
References: <156774113533.2645432.14942831726168941966.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
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
index a16ad114..310ab36c 100644
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

