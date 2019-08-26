Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6241C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 762FA21881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gpcy8PyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbfHZVaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:30:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbfHZVaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:30:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLE0wK001361;
        Mon, 26 Aug 2019 21:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pGHXMFv0ROQpLHMeRT4YUg4u9k2B2zcBm2QEqZ6Fz6M=;
 b=Gpcy8PyQibWObGPTfhBPapaqTxfzxpT55LeQjJc84uRDFZ0FHRqe7lQuNuBhUc+oDYZh
 bhN+DkRG7nACPNPF8LLOWIy4x9gdStmTvE73J618eJSTRIuI7YjDjJDQYRGHTmBwG4hc
 6lXIQZJAmUH44DlKJZYdnm+k08voQ3Gnu4I0hoKVeR3xCAbDdy2GZNDmnigtGrGB0JYy
 bTVXP0qY83ejUjczaTHdEBE4KU9WrS69eAPWY98et3M1eg7ETuPDm+tavjG2RevNbrdm
 RdS1LTBPT8dbHij3c4rAUaKtc5U7Kd2QawBmF9prRQLdbG+MxQ8ojxiy9ICJhTzzonvU 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2umpxx05em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIdAp169685;
        Mon, 26 Aug 2019 21:30:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7x0hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLUHs2006767;
        Mon, 26 Aug 2019 21:30:17 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 21:30:16 +0000
Subject: [PATCH 04/11] xfs_scrub: fix queue-and-stash of non-contiguous
 verify requests
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:30:15 -0700
Message-ID: <156685501582.2841898.903114008316471296.stgit@magnolia>
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

read_verify_schedule_io is supposed to have the ability to decide that a
retained aggregate extent verification request is not sufficiently
contiguous with the request that is being scheduled, and therefore it
needs to queue the retained request and use the new request to start
building a new aggregate request.

Unfortunately, it stupidly returns after queueing the IO, so we lose the
incoming request.  Fix the code so we only do that if there's a run time
error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index a964d2cf..3bc56bdc 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -265,8 +265,13 @@ read_verify_schedule_io(
 		rv->io_length = max(req_end, rv_end) - rv->io_start;
 	} else  {
 		/* Otherwise, issue the stashed IO (if there is one) */
-		if (rv->io_length > 0)
-			return read_verify_queue(rvp, rv);
+		if (rv->io_length > 0) {
+			int	res;
+
+			res = read_verify_queue(rvp, rv);
+			if (res)
+				return res;
+		}
 
 		/* Stash the new IO. */
 		rv->io_start = start;

