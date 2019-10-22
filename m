Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6944CCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C96C20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I/B3FJj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfJVSvt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:51:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVSvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:51:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiMQw091050;
        Tue, 22 Oct 2019 18:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=txw/lTZxhNUJ4nOFdM0aYvY5gZvbN6/MxkRXENKKUpI=;
 b=I/B3FJj4xvqH9eXHQzP7JPmOxiUlSTLXV3ttH5M0W70CqzUfWi8hxBHYhYrIc/KVgs2+
 S+gfAilzWNNV6VNTJMU137AMOKyn66aDYCvR1c3MZzUDfWXjb548wQRorymLu2vB/HFF
 cTEICvh+pa3ri/ARmSwYh05Hnx6+P3P0O+MuLC0TyrBuCnR48JRjOcGgTI+rSR7ivCeT
 /idZEC6LHzPDLfpMdOvc37+QS82fqbEULJNB7GVXakv6QRGmQqf360jTbyNneX3lFrKD
 lTImCLkUsAggqGm2fJZgCikFCmKYvmWIzVe7xoAOh1V3dRuA98j/aS23i8DwUGHXFu/Q 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteprrp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhokd148357;
        Tue, 22 Oct 2019 18:49:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vsp400y3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:45 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIniOL031020;
        Tue, 22 Oct 2019 18:49:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:49:43 -0700
Subject: [PATCH 1/3] xfs_scrub: bump work_threads to include the controller
 thread
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Date:   Tue, 22 Oct 2019 11:49:42 -0700
Message-ID: <157177018286.1460581.16476228375864117661.stgit@magnolia>
In-Reply-To: <157177017664.1460581.13561167273786314634.stgit@magnolia>
References: <157177017664.1460581.13561167273786314634.stgit@magnolia>
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

Bump @work_threads in the scrub phase setup function because we will
soon want the main thread (i.e. the one that coordinates workers) to be
factored into per-thread data structures.  We'll need this in an
upcoming patch to render error string prefixes to preallocated
per-thread buffers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 scrub/xfs_scrub.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 963d0d70..fe76d075 100644
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

