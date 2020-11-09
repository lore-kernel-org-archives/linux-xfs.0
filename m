Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207A0C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7231206C0
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IkwMhuoe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgKISRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:17:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55454 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKISR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:17:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IARr0121342;
        Mon, 9 Nov 2020 18:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7IoFzHtcUfcBdyDoE8lc5KTNkXIYwJzhnTsqJ4R57cM=;
 b=IkwMhuoe5u8vBM7CM5uOs7cyn+Z3mdHAdBc80xUm5ZmRsWYm/0r6oRaWqQDbTiaTe2Wx
 BFyw/53FEEU/OmhyTwL3NQwrSQbQ7H/9QErQ9mUvNsJqscZpdin0kjISIUk/kvYUij25
 TFcqo/a/W65OlV8Kr59BMoNL/AFS+C7zPECIHvXmzL+VMSumK+uxOTMgGObsWUfNghbF
 pJSZFfUJM1wTC9KvOT628UQTLrsWzA16cVAgAi8aLe9Ff09+ZU8Izb9MJjYblLNkNa3O
 yNa524r6KptYi7uFXwJvym709VNK2b4xjEmOsDVS9cWeQ/2+jNqgaJBgeIZw+Bq87Ys5 kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3aqn8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:17:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IB16s136667;
        Mon, 9 Nov 2020 18:17:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34p5bqv1cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A9IHNIp010213;
        Mon, 9 Nov 2020 18:17:23 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:22 -0800
Subject: [PATCH 2/3] xfs: set the unwritten bit in rmap lookup flags in
 xchk_bmap_get_rmapextents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:22 -0800
Message-ID: <160494584199.772693.777818995688769739.stgit@magnolia>
In-Reply-To: <160494582942.772693.12774142799511044233.stgit@magnolia>
References: <160494582942.772693.12774142799511044233.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When the bmbt scrubber is looking up rmap extents, we need to set the
extent flags from the bmbt record fully.  This will matter once we fix
the rmap btree comparison functions to check those flags correctly.

Fixes: d852657ccfc0 ("xfs: cross-reference reverse-mapping btree")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 955302e7cdde..412e2ec55e38 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -113,6 +113,8 @@ xchk_bmap_get_rmap(
 
 	if (info->whichfork == XFS_ATTR_FORK)
 		rflags |= XFS_RMAP_ATTR_FORK;
+	if (irec->br_state == XFS_EXT_UNWRITTEN)
+		rflags |= XFS_RMAP_UNWRITTEN;
 
 	/*
 	 * CoW staging extents are owned (on disk) by the refcountbt, so

