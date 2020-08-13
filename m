Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA7FC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22EE02078B
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nw7+GNyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMX13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 19:27:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMX12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 19:27:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNGfDS101684;
        Thu, 13 Aug 2020 23:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NrvXyBzLOS3AW3h2bReoUrdAYJLGs3feCqUkOxhNE4o=;
 b=nw7+GNypMa0DPbDs0Aqf4lrBZo7z0BRW0oHCmDXRuITcEAyTrjOuTfc1/FV8HxeAcza5
 huZVTiGU3YU/bPOZ4mJuUUghxjyGeb6njn42ZEJmLdcwIKgh6IY+6jrnFtIjuXW1jbjH
 vUgEHrVmXQXbTtaLU49WmhNRCfFfCHfo+dJHTUnje7EGl1qRgUWAdmSyMFu6Eld4sRSb
 VOhaYHqZp7XQJrX8Kln6P2aMA0qEe/uDxlBmlz3FgKO4D041fs5xnjIM0xXtZSfJNUMa
 yD417V2HrqhV0FSf6SHEDZNrPdygOfML+cohbU6FTfIA146a1mx4dqTHFcKzzHT5uKzw SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32w73cakjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 23:27:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNDcOx190337;
        Thu, 13 Aug 2020 23:27:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32u3h63tjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 23:27:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07DNRNfQ016251;
        Thu, 13 Aug 2020 23:27:23 GMT
Received: from localhost (/10.159.233.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 23:27:23 +0000
Subject: [PATCH 1/4] xfs_db: fix nlink usage in check
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 13 Aug 2020 16:27:22 -0700
Message-ID: <159736124295.3063459.16896525594275470708.stgit@magnolia>
In-Reply-To: <159736123670.3063459.13610109048148937841.stgit@magnolia>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

process_inode uses a local convenience variable to abstract the
differences between the ondisk nlink fields in a v1 inode and a v2
inode.  Use this variable for checking and reporting errors.

Fixes: 6526f30e4801 ("xfs_db: stop misusing an onstack inode")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 db/check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/db/check.c b/db/check.c
index c2233a0d1ba7..ef0e82d4efa1 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2797,10 +2797,10 @@ process_inode(
 					be64_to_cpu(dip->di_nblocks), ino);
 			error++;
 		}
-		if (dip->di_nlink != 0) {
+		if (nlink != 0) {
 			if (v)
 				dbprintf(_("bad nlink %d for free inode %lld\n"),
-					be32_to_cpu(dip->di_nlink), ino);
+					nlink, ino);
 			error++;
 		}
 		if (dip->di_mode != 0) {

