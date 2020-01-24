Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE967C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D101214AF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V5WoApLe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgAXARR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55410 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAXARR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08sgN002844;
        Fri, 24 Jan 2020 00:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=EnTJXAWZADZJcCzFBE965w/xej9r1JJIYP0vW8Bo2wY=;
 b=V5WoApLeemPe40s02Kq6twzcqxkoioacZ1k4/8B9E8Aty1KppDSaKluHXecoZv7JmHtf
 CZxNkMszI/pOmanNK9FEvKSABBhtiXdAWfA9FULz0OSXK/hsQxVECSCSUCiEyq9o9E0R
 U74Rh6zJ30X4wHoh1k/pBKoVVkYuMWtRtAWskwRNSiR9XS792AiPKK2Cm7T1AOrc9h16
 04Dqip97+iRVuKIKhHvJhMb8UpI09z45UNmYLbrkgHnz5N1snEl97K0lDLC4jBviZeda
 KfEwWbq+TSuHWuX2c5+UuGYl92RU6+FLnUWBM0e39F73cs9RWzMjwaO8/wBF7XiO0wk6 mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnrnn1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0DW3k037291;
        Fri, 24 Jan 2020 00:17:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xqmuxkhrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:14 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O0HD8g031219;
        Fri, 24 Jan 2020 00:17:13 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:13 -0800
Subject: [PATCH 6/8] xfs_io: fix copy_file_range length argument overflow
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:17:11 -0800
Message-ID: <157982503121.2765410.8361260238180400802.stgit@magnolia>
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=956
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't let the length argument overflow size_t.  This is mostly a problem
on 32-bit platforms.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/copy_file_range.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)


diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 800b98da..fb5702e1 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -71,6 +71,7 @@ copy_range_f(int argc, char **argv)
 {
 	long long src_off = 0;
 	long long dst_off = 0;
+	long long llen;
 	size_t len = 0;
 	bool len_specified = false;
 	int opt;
@@ -99,11 +100,21 @@ copy_range_f(int argc, char **argv)
 			}
 			break;
 		case 'l':
-			len = cvtnum(fsblocksize, fssectsize, optarg);
-			if (len == -1LL) {
+			llen = cvtnum(fsblocksize, fssectsize, optarg);
+			if (llen == -1LL) {
 				printf(_("invalid length -- %s\n"), optarg);
 				return 0;
 			}
+			/*
+			 * If size_t can't hold what's in llen, report a
+			 * length overflow.
+			 */
+			if ((size_t)llen != llen) {
+				errno = EOVERFLOW;
+				perror("copy_range");
+				return 0;
+			}
+			len = llen;
 			len_specified = true;
 			break;
 		case 'f':

