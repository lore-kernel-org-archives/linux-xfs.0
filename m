Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7AEC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60CE320850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MS7c+6zm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfHZVVI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:21:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39712 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfHZVVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:21:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFVKA162597;
        Mon, 26 Aug 2019 21:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6vYn3fYgWzP/uzRe+lgdAvozI2V6zVDGlIww7i0JDDM=;
 b=MS7c+6zm0CwUqjbjJ9NO723IoLLqaxUUWUf0Rtn95bSYG040Jj1RCHj1Shh4hHH+E/m9
 nszX0A1eyB9HiFNXejxUpx3JT6TLcdqxM6hPT4HiwM03Oa5a3l28H+xW6hGL46u0Tr4y
 zqxMGdptOy5/E9Lo8gnu1+US82wa4dIou4n4EWdXuhm+z/XIroreZwEYi7Mgk5LB1oU9
 NUL8uSNE5utYdrcLfWx+b/Wt9IaU+Twagz3u/VeUyNp+wFQwDvyjOjMbBhvTtIgS0T8E
 +pb7LJXjb3X2+4njQqnJEWmHtOdTW09NMEoxoYXA4+TPE+HCF4Bxn2YGSHf5KUEC0KeV 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2umq5t80w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItun184979;
        Mon, 26 Aug 2019 21:21:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2umj2xvqys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:05 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLL4oV001668;
        Mon, 26 Aug 2019 21:21:04 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:21:04 -0700
Subject: [PATCH 1/2] xfs_io: add online scrub/repair for superblock counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:21:03 -0700
Message-ID: <156685446357.2839983.15064768299625184515.stgit@magnolia>
In-Reply-To: <156685445746.2839983.1426723444334605572.stgit@magnolia>
References: <156685445746.2839983.1426723444334605572.stgit@magnolia>
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

Wire up the xfs_io scrub/repair commands to the new superblock summary
counter ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/scrub.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/io/scrub.c b/io/scrub.c
index 052497be..b6848e5f 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -53,6 +53,7 @@ static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_UQUOTA]		= {"usrquota",		ST_FS},
 	[XFS_SCRUB_TYPE_GQUOTA]		= {"grpquota",		ST_FS},
 	[XFS_SCRUB_TYPE_PQUOTA]		= {"prjquota",		ST_FS},
+	[XFS_SCRUB_TYPE_FSCOUNTERS]	= {"fscounters",	ST_FS},
 };
 
 static void

