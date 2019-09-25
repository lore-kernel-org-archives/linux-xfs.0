Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2E2C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D051720872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YX5ohGbu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfIYViz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:38:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47250 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbfIYViz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:38:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQcD009886;
        Wed, 25 Sep 2019 21:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4h3OQuBn8pRUP0g/Wi+oBN7oH8p3EQKoSQamm3fBr9w=;
 b=YX5ohGbu1bmUqBmZXTW8YSiCdWw7C4yP1uhmvzVgJnJM2LkoEEfSaz2HM/laDNZHKkTq
 2DQM0aP5JetLOrG1XNeZla83nXVe9mzKUfyKH8Rv9FgZ/dahrRtbsdZQaK9V0EUi/yAw
 Jbkz4hM4CE5GEfRQDOcoQZa958RKRp9Xznt0vzOhKWHJSV0vOD/3tcviTJG2M0QWklxd
 /ecqz+HnXaZeSoIaplh5RZmJ+XHPJXgfz/WhyDcwHVgUSMHZszHHskEmUmqIE6I0X97Z
 KUa7dqYEwkPEaIB0sszQXf3EhwWmcfBGFFnc8hvKBverKPZLz3kj8mF+DTxI3MKUVyQ2 gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v5btq7j3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:38:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYPgE078623;
        Wed, 25 Sep 2019 21:36:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v82tkrk65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLapir015693;
        Wed, 25 Sep 2019 21:36:51 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:36:51 -0700
Subject: [PATCH 07/11] xfs_scrub: request fewer bmaps when we can
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:36:50 -0700
Message-ID: <156944741018.300131.13838435268141846825.stgit@magnolia>
In-Reply-To: <156944736739.300131.5717633994765951730.stgit@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_iterate_filemaps, we query the number of bmaps for a given file
that we're going to iterate, so feed that information to bmap so that
the kernel won't waste time allocating in-kernel memory unnecessarily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/filemap.c b/scrub/filemap.c
index bdc6d8f9..aaaa0521 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -71,7 +71,6 @@ xfs_iterate_filemaps(
 		map->bmv_length = ULLONG_MAX;
 	else
 		map->bmv_length = BTOBB(key->bm_length);
-	map->bmv_count = BMAP_NR;
 	map->bmv_iflags = BMV_IF_NO_DMAPI_READ | BMV_IF_PREALLOC |
 			  BMV_IF_NO_HOLES;
 	switch (whichfork) {
@@ -96,6 +95,7 @@ xfs_iterate_filemaps(
 		moveon = false;
 		goto out;
 	}
+	map->bmv_count = min(fsx.fsx_nextents + 2, BMAP_NR);
 
 	while ((error = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
 		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {

