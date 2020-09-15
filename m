Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38983C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011BE20771
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZmwdtIsE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgIOBvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:51:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55588 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIOBve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:51:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1ndx7034426;
        Tue, 15 Sep 2020 01:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S8YkTAcfjBJq/dn3L1Mn8jMLRoRJifXcmO6HiKwGINM=;
 b=ZmwdtIsEmm9+JqZ4UbXFCnw+UWM4MwUGA5VRTw2ymTznveBU8CtzUj6CWgeZ5E6+na6t
 kT1A3vruy+DA7zYZ7HSXEpF4sRRRunj7OA99PMpg4r1HfDNjIo/LAXnYJPUdJCP6U+Wq
 mC3fkKrjhItBVSGP4+ZEnvLzT4ocKxYntnCiVql6ExSqGu7nH7EPFoGB7XgO5gxuTQr2
 IZFS8jQz3Bs+FG2aL3+QuaLI5byxRVbWHRj98spCKzjM5d/OCLY5DcnOekHjjy3OIM06
 P/QpqoLz/2fEi2q/OzHe/NCJt7goMjpfK/URS0WzqnYa4yoXGA3QuI5zBkjeHmANSOO6 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m1xcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:51:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1ntTr103873;
        Tue, 15 Sep 2020 01:51:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33h7wn6rhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:51:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1pVw1024552;
        Tue, 15 Sep 2020 01:51:31 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:51:31 +0000
Subject: [PATCH 4/4] xfs_repair: don't flag RTINHERIT files when no rt volume
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:51:30 -0700
Message-ID: <160013469008.2932378.8829835167711862408.stgit@magnolia>
In-Reply-To: <160013466518.2932378.9536364695832878473.stgit@magnolia>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't flag directories with the RTINHERIT flag set when the filesystem
doesn't have a realtime volume configured.  The kernel has let us set
RTINHERIT without a rt volume for ages, so it's not an invalid state.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 48b75f7883c5..8aee9f9e8343 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2393,17 +2393,14 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			flags &= XFS_DIFLAG_ANY;
 		}
 
-		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
-			/* need an rt-dev! */
-			if (!rt_name) {
-				if (!uncertain) {
-					do_warn(
+		/* need an rt-dev for the realtime flag! */
+		if ((flags & XFS_DIFLAG_REALTIME) && !rt_name) {
+			if (!uncertain) {
+				do_warn(
 	_("inode %" PRIu64 " has RT flag set but there is no RT device\n"),
-						lino);
-				}
-				flags &= ~(XFS_DIFLAG_REALTIME |
-						XFS_DIFLAG_RTINHERIT);
+					lino);
 			}
+			flags &= ~XFS_DIFLAG_REALTIME;
 		}
 		if (flags & XFS_DIFLAG_NEWRTBM) {
 			/* must be a rt bitmap inode */

