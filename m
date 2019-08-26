Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A41BC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3372186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NLx4poKQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfHZVcc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:32:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52118 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfHZVcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:32:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLExsx161945;
        Mon, 26 Aug 2019 21:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kkn8SRSCxYN3pgXXxKhGjglOshC//m6U+hzpYDM2b8o=;
 b=NLx4poKQOkMQ0gKHV+cZJWTrdRRL+QRN84yYkbHXtzkgL4TfmC1Fsy/QOgoqYI5a61j+
 ZLNA3AxjutxRlJzdsFa4bnRp8ts6WYabeZTChqWkd81BetwZqnI6BijgZT9fCAemP035
 ZQ9bUEKBv0io6A8tU2RrphVaj11MV7rQ03OI26xh0kRfiQ3sd0LZRYEwPNJ5emBF4Cdu
 w9uW4Yp3vS1Kd/Gx7uEIrd69e6H12sZaL7pqfWslBcmfbZGdaSduA1lUqcGr41uGHx3w
 r1ZhUUokZRmQz/Tfr/EP2XR/HmEhMS9hm4+Mg8ChyueU4462gsd8yfmLsj/x39YpjYrt 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2umq5t82hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIQ4x024943;
        Mon, 26 Aug 2019 21:32:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2umj1tkawk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLWSc0030866;
        Mon, 26 Aug 2019 21:32:28 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:32:28 -0700
Subject: [PATCH 1/3] xfs_scrub: bump work_threads to include the controller
 thread
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:32:27 -0700
Message-ID: <156685514736.2843450.9667654589238018795.stgit@magnolia>
In-Reply-To: <156685514116.2843450.13345990837227741560.stgit@magnolia>
References: <156685514116.2843450.13345990837227741560.stgit@magnolia>
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
index 645b2c50..378f53b4 100644
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

