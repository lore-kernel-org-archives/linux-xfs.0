Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1182CC433DB
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2ACB23A63
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbhAIG3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:29:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34192 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbhAIG3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:29:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10969W8v042399;
        Sat, 9 Jan 2021 06:28:19 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35y3wqr9e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:28:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096AaSp033379;
        Sat, 9 Jan 2021 06:28:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35y2h9nhtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:28:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1096SIbE026237;
        Sat, 9 Jan 2021 06:28:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 22:28:17 -0800
Subject: [PATCH 3/3] xfs_repair: clear the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:28:16 -0800
Message-ID: <161017369673.1141483.6381128502951229066.stgit@magnolia>
In-Reply-To: <161017367756.1141483.3709627869982359451.stgit@magnolia>
References: <161017367756.1141483.3709627869982359451.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the needsrepair flag, since it's used to prevent mounting of an
inconsistent filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/repair/agheader.c b/repair/agheader.c
index 8bb99489..f6174dbf 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -452,6 +452,17 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (!no_modify)
+			sb->sb_features_incompat &=
+					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		if (!do_bzero) {
+			rval |= XR_AG_SB;
+			do_warn(_("needsrepair flag set in sb %d\n"), i);
+		} else
+			rval |= XR_AG_SB_SEC;
+	}
+
 	return(rval);
 }
 

