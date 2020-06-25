Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E63C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74CD520885
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v4ePz7SF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgFYX3n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:29:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53232 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731596AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNQvsv038335
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=T6v0WoW4pb/NrEGJMvsiV0JzIbtyoXt/LQA1lEGkvfY=;
 b=v4ePz7SFNwYbFZmUVCD2ZfsPhC19IgNxQNvTFzkSKakpO0RrtED+eqbUTLsbYNYu0BOX
 9FPfmDkOGhrRU23dpkyMpT/Pl1hWXKAaKgGGQ80p+rJzSLjPRc9MOvAADJ3319VPEBhP
 pf1zWUjwGLcYzsWCOGN9N4fw0fn/4D5Be7YHXV7Z7/UbLGCwkiHCdwy8ip5I1fFq7cPe
 yB4kMaRYTY4xs/l89K1rQ7vDjYyLuETg0obteu0WysO/mS1OlN1PT5SvPX7V4wEvkKEZ
 Fpbuo7F4Z7OfpSZS4Mzbo7RVqN6PS+UUzZOkzj8TIviJQM+SDzUpOWpyAH9st/YbXsQ7 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31uut5u9t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIKO110969
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uur9r3ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNT1fT007684
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:01 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:00 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 08/26] xfsprogs: Pull up trans roll from xfs_attr3_leaf_setflag
Date:   Thu, 25 Jun 2020 16:28:30 -0700
Message-Id: <20200625232848.14465-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

New delayed allocation routines cannot be handling transactions so
pull them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c      | 5 +++++
 libxfs/xfs_attr_leaf.c | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c1d1bfa..d9f7ceb 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1132,6 +1132,11 @@ xfs_attr_node_removename(
 		error = xfs_attr3_leaf_setflag(args);
 		if (error)
 			goto out;
+
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			goto out;
+
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 9ea85d1..0197d02 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2832,10 +2832,7 @@ xfs_attr3_leaf_setflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	return 0;
 }
 
 /*
-- 
2.7.4

