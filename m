Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189A3C433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E478D2074B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vbZlGmIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGOBuy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:50:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43986 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOBux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:50:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1mPdn076157;
        Wed, 15 Jul 2020 01:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lidaS044Cc+NWc2qYUY7R7falR3heXv5JgnC281HlDk=;
 b=vbZlGmIWqrmJ0ICggrsIZhJcowHFhGQJphGMtnNQ2luGgqh2CXIAbzD7TfWsNu6rkv5r
 HVVf6V6+IDjjeJtH6dxy0zyCdwFizzoPfgL8PgZvxRgt4AGbVedC/r0dIrOI8lqXEnjA
 rOZ0AJObk6jBCOYY75M+9O1uMTwagS4FlOfr/8c9YrTOkTpiGjZjMdN6v5lk88E7pKj+
 KowAcDqshE+pMBRyxUoXEoh6NhaBbG+Nb92o0d3LUm6qY11AdjxXPXIJdIU+pZZB8Y55
 j4+sz4YQ8P2BE/oIgI23f6NgGY0E76RQsbAlzE6IhHBb+5nasxWvamTa/THBAf85XN9r lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur8pw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:50:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lkh3081006;
        Wed, 15 Jul 2020 01:50:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0qa5m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:50:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1ol5T023274;
        Wed, 15 Jul 2020 01:50:47 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:50:47 -0700
Subject: [PATCH 02/26] xfs: fix inode quota reservation checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:50:45 -0700
Message-ID: <159477784546.3263162.14861237259530145501.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_trans_dqresv is the function that we use to make reservations
against resource quotas.  Each resource contains two counters: the
q_core counter, which tracks resources allocated on disk; and the dquot
reservation counter, which tracks how much of that resource has either
been allocated or reserved by threads that are working on metadata
updates.

For disk blocks, we compare the proposed reservation counter against the
hard and soft limits to decide if we're going to fail the operation.
However, for inodes we inexplicably compare against the q_core counter,
not the incore reservation count.

Since the q_core counter is always lower than the reservation count and
we unlock the dquot between reservation and transaction commit, this
means that multiple threads can reserve the last inode count before we
hit the hard limit, and when they commit, we'll be well over the hard
limit.

Fix this by checking against the incore inode reservation counter, since
we would appear to maintain that correctly (and that's what we report in
GETQUOTA).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_dquot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c0f73b82c055..ed0ce8b301b4 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -647,7 +647,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
+			total_count = dqp->q_res_icount + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = defq->iwarnlimit;

