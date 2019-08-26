Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38300C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0988C21881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i83H6FLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfHZVbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35432 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbfHZVbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDlZs000848;
        Mon, 26 Aug 2019 21:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+2dtofMhRW7N7Chgqq/nlz/Ss/ekFfdAj6pXzPaeqyU=;
 b=i83H6FLhRF+QB9Cs9pp3bw+O0fHQTi5YpltFyEYG+rZeDK0CkL1X5DCRSqUi0FVCxeDt
 Txf+nTs1bOqNIOlfqGCICU3JAq5Sb8/cuw2YIBSO0I53Idi+Z8GY29NIs72lNJ0mBxsW
 aAuidUE7L9+zZ2cd4M/Afv/juQgXWAWGaZdAeJ2W2y7plCbYqCwRmtet6f+nxpIrikhR
 oo/Kki0JzZ8Wsu7+oUbOZ6ylc3iCHgkMPjTPAShmFasPEFsBGwzbIbx+yUtdQOnrz3+7
 cjEGleVXb4IXmP/gWm6bf7bqOxFpWHDcXsDx1qUq5MEWkH1g5xiBkkUA9+6si8qvn/yA sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx05mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIR0v025060;
        Mon, 26 Aug 2019 21:31:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2umj1tk9kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:42 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLVfqu029956;
        Mon, 26 Aug 2019 21:31:41 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:41 -0700
Subject: [PATCH 05/11] xfs_scrub: don't report media errors on unwritten
 extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:40 -0700
Message-ID: <156685510004.2843133.6588901612950010876.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=963
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

Don't report media errors for unwritten extents since no data has been
lost.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index d6688418..f5b57185 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -372,6 +372,10 @@ xfs_check_rmap_error_report(
 	uint64_t		err_physical = *(uint64_t *)arg;
 	uint64_t		err_off;
 
+	/* Don't care about unwritten extents. */
+	if (map->fmr_flags & FMR_OF_PREALLOC)
+		return true;
+
 	if (err_physical > map->fmr_physical)
 		err_off = err_physical - map->fmr_physical;
 	else

