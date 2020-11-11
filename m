Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F368C388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2346721D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jxn5dbZy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732437AbgKKAos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:44:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56044 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbgKKAos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:44:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0XrBu040631;
        Wed, 11 Nov 2020 00:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=y+SPDfh4kLI+6gCrC3nosZ+Q3ot+DI2IHj7DqRiI/+U=;
 b=jxn5dbZyyEkt6AoKd+EnoQluSim0hXgFSOp6bLOFWivpCe7Q3Lxev4lIFIONw2m4UPcR
 P8flJ6pbHiwptJX1nsoIHjVx9P6NF4IKJIOG3w42yL6VEj2XX2F/NpIZIwBxCR2MBcoY
 We+9R7Dgnkklher5HtXDinm8RJXLnn0KjKR4AohBHS774E+VwVcK2nHbUSvSKRM7p0it
 V9gjSkeESlClltedlOKZL73/MuLOD2dAkJiMLypoocETTPDM5U1JgbnANrbf1sa5fef4
 1RqUe91fzsu99gy9ym23tR+6DpbdFAiu6ok8/kvDHnh6WHlCOI2OzY7f4YargCUQIKlv dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34nh3axw4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:44:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0VCEp095247;
        Wed, 11 Nov 2020 00:44:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34p55paudw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0ijg7029360;
        Wed, 11 Nov 2020 00:44:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:44 -0800
Subject: [PATCH 1/4] fsx: fix strncpy usage error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:43 -0800
Message-ID: <160505548377.1389938.2367585875193826371.stgit@magnolia>
In-Reply-To: <160505547722.1389938.14377167906399924976.stgit@magnolia>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We shouldn't feed sizeof() to strncpy as the string length.  Just use
snprintf, which at least doesn't have the zero termination problems.

In file included from /usr/include/string.h:495,
                 from ../src/global.h:73,
                 from fsx.c:16:
In function 'strncpy',
    inlined from 'main' at fsx.c:2944:5:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:106:10: warning:
'__builtin_strncpy' specified bound 4096 equals destination size
[-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'main' at fsx.c:2914:4:
/usr/include/x86_64-linux-gnu/bits/string_fortified.h:106:10: warning:
'__builtin_strncpy' specified bound 1024 equals destination size
[-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 0abd7de1..cd0bae55 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2769,8 +2769,7 @@ main(int argc, char **argv)
 			randomoplen = 0;
 			break;
 		case 'P':
-			strncpy(dname, optarg, sizeof(dname));
-			strcat(dname, "/");
+			snprintf(dname, sizeof(dname), "%s/", optarg);
 			dirpath = strlen(dname);
 			break;
                 case 'R':
@@ -2799,7 +2798,7 @@ main(int argc, char **argv)
 			break;
 		case 255:  /* --record-ops */
 			if (optarg)
-				strncpy(opsfile, optarg, sizeof(opsfile));
+				snprintf(opsfile, sizeof(opsfile), "%s", optarg);
 			recordops = opsfile;
 			break;
 		case 256:  /* --replay-ops */

