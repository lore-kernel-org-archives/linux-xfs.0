Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DED5C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BA9C207DA
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d4pPFJgN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHMX1d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 19:27:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMX1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 19:27:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNI4Q5116408;
        Thu, 13 Aug 2020 23:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+w3TjA7TqYvRGMMX6f97PFK+lXsRBvjICweEDC91I6U=;
 b=d4pPFJgNbfrfe8vZeyKBjQuaRVlidRiosLxjgPNRhkxJ8BQLLPCuOJtXcvL9AHR4obLR
 LlX4VYidrfnHxMMSFpWAiKVQCl/YYLOlMTSX4nscmQV9rMb7aPLgxh4DmItrel0LsxH9
 DETis8YoBo7hJxY/7wAEoq/umAnsaGxfJLXf/AW7WwNY7Api/Zdj5f8sWzjdiN1Kb1pf
 9s8wk/yfBtzgSK+kWokL00SRdiWvk6KVQXu4lCBQkzeixy4oWsH7DCdoJoqmW30a2Su5
 PT0TGKXeY+pWopUeGxsg9nS2H7dixVBcXJaYQ6BL7xyCqKYUlHaNr7yBTZ8astq5wQN4 +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32t2ye1vd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 23:27:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNCctr075721;
        Thu, 13 Aug 2020 23:27:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32t60457h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 23:27:31 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07DNRTcd010629;
        Thu, 13 Aug 2020 23:27:30 GMT
Received: from localhost (/10.159.233.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 23:27:29 +0000
Subject: [PATCH 2/4] xfs_db: report the inode dax flag
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 13 Aug 2020 16:27:29 -0700
Message-ID: <159736124924.3063459.16692986145242990855.stgit@magnolia>
In-Reply-To: <159736123670.3063459.13610109048148937841.stgit@magnolia>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Report the inode DAX flag when we're printing an inode, just like we do
for other v3 inode flags.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/inode.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index 3ae5d18f9887..f13150c96aa9 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -172,6 +172,9 @@ const field_t	inode_v3_flds[] = {
 	{ "cowextsz", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_COWEXTSIZE_BIT-1), C1,
 	  0, TYP_NONE },
+	{ "dax", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_DAX_BIT - 1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 

