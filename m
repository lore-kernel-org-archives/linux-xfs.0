Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60184C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC6E20872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cuWtTJVV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfIYVhb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:37:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfIYVhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:37:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRWd054822;
        Wed, 25 Sep 2019 21:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OAoVZ/YthJabAkpE38CN7uUJihXIfMrpD4wY8nOlraM=;
 b=cuWtTJVVY8MH5tIu5R+dhGUgjZf1egaWC7tWegnsghczLTBEShKT+vkKcDdo0UvWfnjV
 0hpRZcvWdfmCTiR4+pH6syvL7CC35jaWmS1lu7zKguVj4M7lwrG1xujfAmGd9UpHH1mX
 dosKtnOfDUDXiuQ1Pk4XfJBFgGUgqHWEo0bq+/2Nt5z2imAXKe+OglEz0sO5AP4wTdBx
 0H+Y46x2fp7zsM73KT14QnkIpOmo470GAx7MEHfvSgv4NqyHARWXwCx27zs14yFMt4iT
 0kPeAoawjy8TWLWdiLlxo115/hYBwy9eKiM+bPeM7KoOyLzph5e+oH1zUeep4sZX9mjx gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYMeV023571;
        Wed, 25 Sep 2019 21:37:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuu0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:28 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLbRK5021720;
        Wed, 25 Sep 2019 21:37:27 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:37:27 -0700
Subject: [PATCH 1/3] xfs_scrub: bump work_threads to include the controller
 thread
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:37:23 -0700
Message-ID: <156944744378.300433.8796143133184996618.stgit@magnolia>
In-Reply-To: <156944743778.300433.15946504547062490997.stgit@magnolia>
References: <156944743778.300433.15946504547062490997.stgit@magnolia>
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

