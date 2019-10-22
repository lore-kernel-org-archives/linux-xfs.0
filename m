Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF7CCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68CA920B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+ZjbFV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbfJVSqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:46:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43104 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:46:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiNc3109563;
        Tue, 22 Oct 2019 18:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Wlj61yoquvYsts/eCzm/9npe1I/N26HqXOwsws4XJ5E=;
 b=V+ZjbFV1dMWqcU9xKjISD1ycbpCf7l9Qn1+Xp2qbv6rYi46MuUVxf+yZI76tiHZM9/l+
 rCq5GbBKTTV9ukXhQFVrWnLgaUXCz1hM9AvCM/PTP0/xG93bX5dE9PFqNU6GQKUeyYI6
 jBLP/UJnu1aiHk1oiFcNdIGcJk5WweJEPvzdCXbKPRMsLdr61hoHMxnbcK+tGMJuR0fU
 rs4ZLjUOuTKqFNBg0xfMW/eSMB4CWqxEbJKm7t6N/04bFTtnjSvOQXo05l+RsTVLj8Xc
 c2qvRwXCr91Xs1L/AGSoQMONDVJYBSUhq426Ovh+6fn7q5FYbT76czUt19S6m2OMkXXE Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtgugg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhlNG148086;
        Tue, 22 Oct 2019 18:46:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vsp400sn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIkdlW024467;
        Tue, 22 Oct 2019 18:46:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:46:38 -0700
Subject: [PATCH 1/5] xfs_spaceman: always report sick metadata,
 checked or not
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:46:37 -0700
Message-ID: <157176999737.1458930.11352482066082675215.stgit@magnolia>
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
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

If the kernel thinks a piece of metadata is bad, we must always report
it.  This will happen with an upcoming series to mark things sick
whenever we return EFSCORRUPTED at runtime.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/health.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/spaceman/health.c b/spaceman/health.c
index 8fd985a2..0d3aa243 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -171,10 +171,10 @@ report_sick(
 	for (f = maps; f->mask != 0; f++) {
 		if (f->has_fn && !f->has_fn(&file->xfd.fsgeom))
 			continue;
-		if (!(checked & f->mask))
+		bad = sick & f->mask;
+		if (!bad && !(checked & f->mask))
 			continue;
 		reported++;
-		bad = sick & f->mask;
 		if (!bad && quiet)
 			continue;
 		printf("%s %s: %s\n", descr, _(f->descr),

