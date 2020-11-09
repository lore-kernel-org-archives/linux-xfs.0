Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAA3C388F7
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 460AA206A1
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i/jLfaMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKISTU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:19:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60650 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbgKISTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:19:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9I9ELc112592;
        Mon, 9 Nov 2020 18:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X1Ahs55ti3UanURVrvTgidojNUKj1BUv6sfCVakNvSU=;
 b=i/jLfaMqtoAPhNz6xEIuBCx+mwe1VI71eZJV3xn3hf/ZLetNeng6rVSbz55jzcrk9HxE
 JFXZrfWLrgjzMQ+q4uhKpmu4Q7Cd+d/seMuw8zK1e95WbLX36h0IuPPbQ1Rr7NjBcEJW
 NQqOISL+CIlBBiodfessfOhFfV5Zr6gNekHL6loIL8qBnBYTQIuLQ7pbUtAptH8VT5Be
 JLu8j65LaI0/Ox4oL4NY/fK6DgPtISsi3ckjsz0cBX8fcB+Oce9uIckeFbsp00ld/+2E
 w50+5rTvEt/8nzHdNk4P6MxE8/7BP3RAh6my6uHAsVA9yxeiZ5vCXBZJuPyOAdpZ4/4R oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72edn5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:19:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IB93Y195340;
        Mon, 9 Nov 2020 18:17:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55m9nfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A9IHG6Z019639;
        Mon, 9 Nov 2020 18:17:17 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:16 -0800
Subject: [PATCH 1/3] xfs: fix flags argument to rmap lookup when converting
 shared file rmaps
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:15 -0800
Message-ID: <160494583579.772693.11055963967780181272.stgit@magnolia>
In-Reply-To: <160494582942.772693.12774142799511044233.stgit@magnolia>
References: <160494582942.772693.12774142799511044233.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Pass the same oldext argument (which contains the existing rmapping's
unwritten state) to xfs_rmap_lookup_le_range at the start of
xfs_rmap_convert_shared.  At this point in the code, flags is zero,
which means that we perform lookups using the wrong key.

Fixes: 3f165b334e51 ("xfs: convert unwritten status of reverse mappings for shared files")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 340c83f76c80..2668ebe02865 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1514,7 +1514,7 @@ xfs_rmap_convert_shared(
 	 * record for our insertion point. This will also give us the record for
 	 * start block contiguity tests.
 	 */
-	error = xfs_rmap_lookup_le_range(cur, bno, owner, offset, flags,
+	error = xfs_rmap_lookup_le_range(cur, bno, owner, offset, oldext,
 			&PREV, &i);
 	if (error)
 		goto done;

