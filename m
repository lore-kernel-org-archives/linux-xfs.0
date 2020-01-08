Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBDCC33C9E
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 409662067D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qEepHwow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgAHETZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:19:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50622 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgAHETZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:19:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JM92035782;
        Wed, 8 Jan 2020 04:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WXiusm9gQlV8eIutGR+7fO2uGMKNP2+1/vMWm+3GwLY=;
 b=qEepHwowTqSZcGqZTQKquKwft3YAI0LOi8SpueJdfH8O4O0f2QDP6GeijG1Gm6sw4H+u
 GyIVnhxdB0fUUbF6s+0c49aJNDOiCc0sG43BOFkgFilspWNYmtQJazppkqvnVkDNmUHO
 D32+eVLBqtm1RJG4I4bs1OUtcJwubRolZ+lAWIWr5xmmBn8YSuI2HKOuaPDvQGt+xyvn
 s+qYSVJrGg36q/jzQGnYi4V2MeMxF2KJJMGRLao6h0QwGbTD40Z/8aLAObO5NPScxhyT
 duVhjwKnEBywofBDTzkj5CTJYsOOvQiHLrIfNo/tepDDnXL9X1G1OklTk08CeuW16txx kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbqschq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 04:19:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JIWK075794;
        Wed, 8 Jan 2020 04:19:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xcjvep2fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 04:19:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0084I39q018441;
        Wed, 8 Jan 2020 04:18:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:18:03 -0800
Subject: [PATCH 1/1] xfs: remove bogus assertion when online repair isn't
 enabled
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
Date:   Tue, 07 Jan 2020 20:17:59 -0800
Message-ID: <157845707964.83042.11399554567794736343.stgit@magnolia>
In-Reply-To: <157845707353.83042.7437302554308223031.stgit@magnolia>
References: <157845707353.83042.7437302554308223031.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't need to assert on !REPAIR in the stub version of
xrep_calc_ag_resblks that is called when online repair hasn't been
compiled into the kernel because none of the repair code will ever run.

Reported-by: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.h |    1 -
 1 file changed, 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 60c61d7052a8..c3422403b169 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -75,7 +75,6 @@ static inline xfs_extlen_t
 xrep_calc_ag_resblks(
 	struct xfs_scrub	*sc)
 {
-	ASSERT(!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR));
 	return 0;
 }
 

