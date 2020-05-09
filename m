Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5F6C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE3582063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hSVAeicv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgEIQcj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:32:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgEIQcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgq1072390;
        Sat, 9 May 2020 16:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y3JLv4WzXAz0sZTCbqLX8b5a8FGWgnaMYxqrtjCtXmQ=;
 b=hSVAeicveZnCGmY9oFWJ4v76u1Us6CrmYsyHxe7ukEH4S6p1BYIhf4A4wedocT3sSCBC
 Mx8vKBmCzr8JVNP3TyvkXMAuuFwu3UGK96DUYgcIrfLzMjrqVNawxaUbc31bOJwcuHqZ
 9addo0zqGgeC0bi4jS24SciPmnKCrZ34OJexvVvSbBP0T07ANuVS4Z1hYxmjlomvCovF
 KbCsUaAmEF0Xk45crnxmaHYszVmhIVCDYrXZw/K/b5Ow97ZP7KxHMjEAdEOC0gAv2UvE
 VIF29RFNT+T0A169vZ5o+uyMuvrj7rItxyQIp2NinGQmBzcqvRiHMkjxL7GhKFRMIYAV Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30wkxqs6j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GWVob117487;
        Sat, 9 May 2020 16:32:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30wwwpnk3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GVKEV025464;
        Sat, 9 May 2020 16:31:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:20 -0700
Subject: [PATCH 13/16] xfs_repair: mark entire free space btree record as
 free1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:31:20 -0700
Message-ID: <158904188022.982941.11510270346760102443.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=2 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=2 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In scan_allocbt, we iterate each free space btree record (of both bnobt
and cntbt) in the hopes of pushing all the free space from UNKNOWN to
FREE1 to FREE.  Unfortunately, the first time we see a free space record
we only set the first block of that record to FREE1, which means that
the second time we see the record, the first block will get set to FREE,
but the rest of the free space will only make it to FREE1.  This is
incorrect state, so we need to fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/scan.c b/repair/scan.c
index 76079247..505cfc53 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -719,7 +719,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				state = get_bmap_ext(agno, b, end, &blen);
 				switch (state) {
 				case XR_E_UNKNOWN:
-					set_bmap(agno, b, XR_E_FREE1);
+					set_bmap_ext(agno, b, blen, XR_E_FREE1);
 					break;
 				case XR_E_FREE1:
 					/*

