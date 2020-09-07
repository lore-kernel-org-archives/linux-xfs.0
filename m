Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD2CC43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D5720738
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z2MuI7bY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgIGSEK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 14:04:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728548AbgIGSEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 14:04:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HxZ6c012133
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ampOzmgKBo1WcneINNVwprhHpdkxGL5mcnOjJAz2fYY=;
 b=Z2MuI7bYeKhaR+v9NFd5kaZ8qv86zDM8YTXldOUKBOVwW31lsGfJ7fRZ5AYwt0i1jdI2
 oZgqg2s70nr5IJ936ysZZ9PZ4Td5JNme4j0AQyOwFZJX67XV739LQWOZiAL79+FlMV7D
 a8ebMrQ5PRGtrp+V3/8kDKVfUO6qv6hmcNb7hq20oSHPnQ1wEhyYjvtLkq/q4uzT9rl6
 7yRB+sXNcc9Hbfk91aJGcDCuBQRzbszYYgflWbF0PQ4AU8nQCHRMD5hlWne03iRwCjWi
 9Gkw/8XUDI/bRHM8Kk301g5e8FY7ckKRZ34IYAgNe9W48TDiCBs7Abb8z9zwlf8ia4il sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23qqp9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:04:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087I0vY1049424
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmk16414-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:02:07 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087I27EA006536
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 11:01:15 -0700
Subject: [PATCH 2/3] xfs: make sure the rt allocator doesn't run off the end
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 11:01:14 -0700
Message-ID: <159950167474.582172.16930353017934744381.stgit@magnolia>
In-Reply-To: <159950166214.582172.6124562615225976168.stgit@magnolia>
References: <159950166214.582172.6124562615225976168.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=3 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's an overflow bug in the realtime allocator.  If the rt volume is
large enough to handle a single allocation request that is larger than
the maximum bmap extent length and the rt bitmap ends exactly on a
bitmap block boundary, it's possible that the near allocator will try to
check the freeness of a range that extends past the end of the bitmap.
This fails with a corruption error and shuts down the fs.

Therefore, constrain maxlen so that the range scan cannot run off the
end of the rt bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rtalloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895..86994d7f7cba 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -247,6 +247,9 @@ xfs_rtallocate_extent_block(
 		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
 	     i <= end;
 	     i++) {
+		/* Make sure we don't scan off the end of the rt volume. */
+		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+
 		/*
 		 * See if there's a free extent of maxlen starting at i.
 		 * If it's not so then next will contain the first non-free.
@@ -442,6 +445,14 @@ xfs_rtallocate_extent_near(
 	 */
 	if (bno >= mp->m_sb.sb_rextents)
 		bno = mp->m_sb.sb_rextents - 1;
+
+	/* Make sure we don't run off the end of the rt volume. */
+	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	if (maxlen < minlen) {
+		*rtblock = NULLRTBLOCK;
+		return 0;
+	}
+
 	/*
 	 * Try the exact allocation first.
 	 */

