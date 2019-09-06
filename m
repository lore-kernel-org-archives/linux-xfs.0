Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1EEC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7989206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IwoLFdPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392160AbfIFDkS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:40:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731630AbfIFDkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:40:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dIsq078111;
        Fri, 6 Sep 2019 03:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OAoVZ/YthJabAkpE38CN7uUJihXIfMrpD4wY8nOlraM=;
 b=IwoLFdPRuw1W3XOpc1d0ttqXSOZ2G+aVvXeVt05I05ao1MBSwUxpZrYZo3GXOko+ud/+
 TuXuxbXRJufrjHL5bm0wy+bXsjNBDaWknezXOYh7fGfLkCK81+0r7Y9shx9dh8plA258
 iJdStfLwhuDD2x88Ww39zKSqb38zpKuqEScbFNYUMgo+qPAZvSfYsPtLnxpmcmYfy/YF
 HdHCtxBvb3XeA0vDxCdpVzAn1QEWETJDy2XzXOJ00dc28kvM4pB4P7OrWU47l4uLlq9s
 1kg//uNKH1/CMrNOgOTrxQ/yIeDvZbgIcCYL99FbnDXCs7zz2UELhGAj3oWGgJiJmTcG Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uuf51g3h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cPAD077917;
        Fri, 6 Sep 2019 03:40:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2utvr4k15c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:15 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863eENw016808;
        Fri, 6 Sep 2019 03:40:14 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:40:14 -0700
Subject: [PATCH 1/3] xfs_scrub: bump work_threads to include the controller
 thread
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:40:14 -0700
Message-ID: <156774121398.2646601.17566281978943790161.stgit@magnolia>
In-Reply-To: <156774120780.2646601.13902985397309977000.stgit@magnolia>
References: <156774120780.2646601.13902985397309977000.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Bump @work_threads in the scrub phase setup function because we will
soon want the main thread (i.e. the one that coordinates workers) to be
factored into per-thread data structures.  We'll need this in an
upcoming patch to render error string prefixes to preallocated
per-thread buffers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index aa98caaa..3b347d86 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -458,6 +458,13 @@ run_scrub_phases(
 					&work_threads, &rshift);
 			if (!moveon)
 				break;
+
+			/*
+			 * The thread that starts the worker threads is also
+			 * allowed to contribute to the progress counters and
+			 * whatever other per-thread data we need to allocate.
+			 */
+			work_threads++;
 			moveon = progress_init_phase(ctx, progress_fp, phase,
 					max_work, rshift, work_threads);
 		} else {

