Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EAECA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BAA620B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lgdein8G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732753AbfJVSsC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732322AbfJVSsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiCaO109504;
        Tue, 22 Oct 2019 18:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CKjapPa9d9KhldOOvKUSrrgVfBJCFg20jOX8ZrfeivA=;
 b=lgdein8GsEXdKpOqx0NBV3noNCLDg2Y1lFmq9mMEGQxAVo05n3Pv9XagYYxCsm3UL+p6
 conbeyvZDzqZWL6pms+3C8zBV1qdMCVOKEh8OGktPl2IJ3wIRhzQxI5UfmgaCv9S0wAy
 wGLX2l9KpBIbQ2Ax0RWuXyoSITLjVnUgDE6HtZK07BRQIinemn2w32fCbkRvl2qbDoIl
 zgAauJ1tqZsaJzmEUbnLLzeRxsWAg/ysk49WkR2pO1gnFZY0MS/30laBltBznMd1hLhk
 KK/fLMUgoGvGq+evB3qFwgoO0wRBRUBf7XiN6rWkJIJ1yLA5mZ7TiPGibd8qJaHnXurj tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtgutk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhlNm148086;
        Tue, 22 Oct 2019 18:47:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vsp400uwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIlvQg002991;
        Tue, 22 Oct 2019 18:47:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:47:57 -0700
Subject: [PATCH 8/9] xfs_scrub: request fewer bmaps when we can
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:47:54 -0700
Message-ID: <157177007451.1459098.7077839567802348147.stgit@magnolia>
In-Reply-To: <157177002473.1459098.11320398367215468164.stgit@magnolia>
References: <157177002473.1459098.11320398367215468164.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
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
 scrub/filemap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/scrub/filemap.c b/scrub/filemap.c
index bdc6d8f9..f92e9620 100644
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
@@ -97,6 +96,13 @@ xfs_iterate_filemaps(
 		goto out;
 	}
 
+	if (fsx.fsx_nextents == 0) {
+		moveon = true;
+		goto out;
+	}
+
+	map->bmv_count = min(fsx.fsx_nextents + 1, BMAP_NR);
+
 	while ((error = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
 		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {
 			bmap.bm_offset = BBTOB(p->bmv_offset);

