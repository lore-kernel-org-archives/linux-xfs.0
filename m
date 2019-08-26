Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5446BC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24C0B2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QakP/NIO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfHZVas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:30:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34366 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbfHZVas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:30:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDlEB000858;
        Mon, 26 Aug 2019 21:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=f3CpY2z6BisrlfWud3QPLJlU2AmSUAesQaVMk2ohINk=;
 b=QakP/NIOmJs+b7NkZpM4v4ZIWo/YRJPFRL7QCIwtHHSt94RID7dkzlohlnig5Z70RC9R
 4uS+8uc6CSTWXK3rrOS+zih0ZjGtekvlvc2ZQsOWqG9jiduFj+NnaHORxk6mkmiTnmWe
 jw+D60LwfjJusLYAzLNK40Ti8JfCgDWbuUYGfNh+OsnwEduXr+DJxvaaqTvOSv1TMRB2
 QqNSY9XFIOg1imI8QiUKucS0OrrQpddutbyF3SzeCyyxvU3G1HdbYtAEHddoLAaaBVEh
 acbqCLRV26EqW+Kaq62L5sx/xOQgPkZRwtk9XRi3FS1NL0iRmsjvN1EwSZrzkD0FoZeB YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2umpxx05gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIt7t185028;
        Mon, 26 Aug 2019 21:30:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2umj2xvy1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:46 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLUjKi029544;
        Mon, 26 Aug 2019 21:30:45 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:30:44 -0700
Subject: [PATCH 08/11] xfs_scrub: enforce read verify pool minimum io size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:30:43 -0700
Message-ID: <156685504387.2841898.7841707499738990491.stgit@magnolia>
In-Reply-To: <156685499099.2841898.18430382226915450537.stgit@magnolia>
References: <156685499099.2841898.18430382226915450537.stgit@magnolia>
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

Make sure we always issue media verification requests aligned to the
minimum IO size that the caller cares about.  Concretely, this means
that we only care about doing IO in filesystem block-sized chunks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 7cfe834c..7cac0a0f 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -77,6 +77,15 @@ read_verify_pool_alloc(
 	struct read_verify_pool		*rvp;
 	int				ret;
 
+	/*
+	 * The minimum IO size must be a multiple of the disk sector size
+	 * and a factor of the max io size.
+	 */
+	if (miniosz % disk->d_lbasize)
+		return EINVAL;
+	if (RVP_IO_MAX_SIZE % miniosz)
+		return EINVAL;
+
 	rvp = calloc(1, sizeof(struct read_verify_pool));
 	if (!rvp)
 		return errno;
@@ -245,6 +254,11 @@ read_verify_schedule_io(
 	int				ret;
 
 	assert(rvp->readbuf);
+
+	/* Round up and down to the start of a miniosz chunk. */
+	start &= ~(rvp->miniosz - 1);
+	length = roundup(length, rvp->miniosz);
+
 	rv = ptvar_get(rvp->rvstate, &ret);
 	if (ret)
 		return ret;

