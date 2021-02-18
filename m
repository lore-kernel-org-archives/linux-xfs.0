Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDAFC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E0461606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhBRSro (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbhBRQyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngnD069596
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WnS28Q0eLfLg7beJiPLd35hxS2KWbzebfpmi0Pra2YI=;
 b=HtdhuJ6z1T7PW76G0LS1z9s21kqyaWKlkehHqpFL4NRoywzd2tLB3ygHUpAVwFuZAsg5
 mktska7nZkGvGxllX2tA5/tefEHPPQAv9jvlKNpNnF2Ljh6imH76+YUa6Ifz+XGNVov7
 6bQQkGHX+i61pJspAk1LauvRyND3OEculFA3sukSPzOvhL78EsPPzPfoIvdnaCbs325b
 CgTw+gmoyGxmJuudNURsyW3bK9XC+s4WjpchS7EwZKL6z5IoKXELV6b6UMCbVWzr/DwO
 3xCq2gwh02eFqD1Qby7pixa6BW8ZQM8u/842cjVqlneGOt0Mkd+G/aRTMYSOFD/sA9D4 Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngUk162355
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 36prhufdh3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8jAwKRXxybwPUyWun9UdOEoevduRjRvFxaDv3y7Q6BLKNmvBQtJ/yLpSt1rnjmh0Hqm4aZ/z8lNyqufe2NlCHEUbqTgb/+iPD5+0rcPRgtBuLT7ajw2C0NMdSFcLdEHQ/9TiYm7GQjDZAg/5gjkvYCgud9gfORDZj59HwNeIIYr6IBLyVWlL+fBYM5Dz2LNOMLXunHw+unEYRPeEGRTA9FcLQ2kkd/J52sCVfvekweaRRtTLlOdykpeCb9dCmV8h0VHwTmGdQfy5B4iW95dJLJKtL955o/1ww0i1DB1JOV+ETRjD0i5C1uv3eGdu7dLpgLFQIqq1op/H3ctkb9mKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnS28Q0eLfLg7beJiPLd35hxS2KWbzebfpmi0Pra2YI=;
 b=DGQB9rIdKiKbKy1iZFWw0QUEvkcD9yx5yHNxTv0ZvwVytLxUcAx8PkGvqWxyBlw4YvKQfUcZq4rfTkg40fl+cBED4cBFQla6aht/906mjVnwu1Xui+fu6b4NJ84URQx+5RJ4PGPaNeqYNllfdHIuGwrBtsot1afQKstyUfnvP/PNiwghNslO4VOdjjbDC80atWvrRAkXvfCFuCUW2mgol+odCqnzS8aSC7U3m67TGKD+r9X8oPdi96zDM1GE0ObH+GDAjYudnkt9/8AxaCaXz/Yklahva5TVzpcwdk2+bZbPEjSAj7fFVEXxBV/IN8PgHpEJLORfFuat67zTj09Ihg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnS28Q0eLfLg7beJiPLd35hxS2KWbzebfpmi0Pra2YI=;
 b=IJp7NkkbWmJjzcU5UGPUXKxvr4ecIZfB+z+GdK1IO6FWg2tTslAFfIIGoVXjSvcYDR4JTVQGMPgs86pmdoTsjrtdUFADVe87Cu0do0qs4uypFvRM17nEF8AQh0Of737jaFTraK4BY2rMpPnpq7YRER+f2uYavlrKta3zZ9m5Vdg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4161.namprd10.prod.outlook.com (2603:10b6:a03:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:54:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:03 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 01/22] xfs: Add helper xfs_attr_node_remove_step
Date:   Thu, 18 Feb 2021 09:53:27 -0700
Message-Id: <20210218165348.4754-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95a417d8-b919-4aa3-40e4-08d8d42dcbd2
X-MS-TrafficTypeDiagnostic: BY5PR10MB4161:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4161F6459C081027B883D97595859@BY5PR10MB4161.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RuHc14fx7bCt2z5NJnHGbbwDiEK+5XFGhNHoqobbPeb8Zm2C9vL7/i6tMuj+jI3f+ZyLs0/wG1X0hctHfisINGnRx6rUFfGM04RkFXPGfcu8CyDnN/R5A0S31s92fVuLaGl84qYaEXw2GHISqNudIfNOQPuZmf3uI+DzYf/Wwq7UwWg9aJUWziSEZ2SLU1sef8wT8NAasb5RdtL5gYMcreMxeJw3UaDlvp/v4sFgPo2DzfrpegmcbeR5SlvRdoRrklyIiI6UzxtcpGg0k2IVxXt3IAxORG5aBTWvvakJHA+EhJIic+kfeCQHlsOpL8yEjsRYFwq7TEygv+8zydu8xehr9p+8OpVL+XBcaWTuqkL3J7nMCs6lm471SxdHsnvky10NAf/VjCbdXNR1bHZ33CRrAnhfdwPuCI6cDPuoH3BpOeCPM4ealvQqBmLj+kXWp/vohXZWvUQCJjAG5wWj2DNpsI7AP48R+aUgII48C93/X8iLbFgWrc35rWbVAiCtOLrfYBqXGc7e8JmWKVHJg8o+xUJChaGF5s9XlYxlxGKA4/ffaWIMeoZ9XDJW8UXXdt3GBHcU9QtoN1GyhCT/YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16526019)(66556008)(6506007)(478600001)(5660300002)(956004)(69590400012)(26005)(6486002)(83380400001)(66476007)(186003)(66946007)(2616005)(52116002)(6512007)(1076003)(6666004)(316002)(8676002)(8936002)(6916009)(36756003)(2906002)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7YDC3zfeCoFT2RJHJeDcDxKWQb18A2+3ABmRtref6cv2uPzC7PveMJP+ddad?=
 =?us-ascii?Q?SH97vZ4CB+ZS7xSprO2hVYdCelbzVPhqbuvWEmWSAqhF98PYiLR2ebSYIzOn?=
 =?us-ascii?Q?s6IPnoXleedYexw5SO9RTqwRpF9izaTxRmN3HTNUeuctX4AN/UhL/wPk3aV2?=
 =?us-ascii?Q?GU/i+dp46Su8SMCOf0P7f71lTnrzxhCWcAjX6RwNQDuVLhXQZIQ2ngyK3cor?=
 =?us-ascii?Q?0FNxvQ9phcFGArAleFAn654XGi+9LVhbKVNpQJPjPeDm3tjAYnc6tIQ+Wpke?=
 =?us-ascii?Q?6+LA3uQYBD/K8Ny82VRPZbrEcGUvX1t0tGthqHtqds7jx8RMtqj2mmhFzRVo?=
 =?us-ascii?Q?z9MRxEmCydpyj0udipAcqAAfucu9ESbn/WNyP6R7Y81xnyxBTuCn2tO40dtI?=
 =?us-ascii?Q?UAmXLXjChqJ/zae4hP9bxhfiuz4O0Wi7oP19Ytkh50/CAqTRHCgIeuZ7lXgS?=
 =?us-ascii?Q?X2H7EL/u01waOyw/deRBd3GgXwpD7jydaZz5QMU4cgdTr5DvGLXcKRwqlai3?=
 =?us-ascii?Q?k7pc33iMbzdgxjHvTPUy2HutfZ8h45pWLiHDlwWNVsYx4LbJ/2evRTBWdxzs?=
 =?us-ascii?Q?ajjeSgcJJVFGyzi3VbiD5qlRopV3Zbwahwn4kFuG7C2SMOZ+lgrjF7bFFZGK?=
 =?us-ascii?Q?j3+bnNeEnU+K/xXmGW35d+u+eYQGbs95D5qmYEmjlIfr+ycGnpQ9KVEQ914J?=
 =?us-ascii?Q?7PxCpQ7z1qftCBD/B0paQShFOCwcNnu30v7k674b0xdAqOWOki2PZrO8PJhK?=
 =?us-ascii?Q?ABCwt+rhL8Sse2kxfLRn/1f+iAWOa4nznuqbPGPnPJW+/OKEaoBpL5LorlIV?=
 =?us-ascii?Q?OEE/ity10wdA+lk9xR5rLvUyXpcoDLVLk3E9HwP34IqMaC/FIEt/QycIyKsN?=
 =?us-ascii?Q?MbMvq4+cwoqigG+AsRL34G+uJg79/iD6hWc26xNIGVYTZveVYlNiOhIXKf4Y?=
 =?us-ascii?Q?rFADVDyopziI9pSGp6lfNryvi/3lhi++Cm1oXxtMtb3cDiYuNMnmN/BNSJPj?=
 =?us-ascii?Q?V9bQNw6vCeIzuzLrVqw/lekbMT1bo8TnEM+w8kmLqLuvNstigX1lSR4frc7N?=
 =?us-ascii?Q?2RVLCmU24fZZYIuBRMIRU4f7g4SD+lAAP6F/fyZT7ktn+nZQSEJDPSX3nVXV?=
 =?us-ascii?Q?jG5CD1icmHwXKxmnyA85XiqsC0i4EHL5nvzRSAnPcVG2iRYOKhzDSpGKhO9i?=
 =?us-ascii?Q?W59v8ZVSqWl2y2x4CuldgFaPuXKmairSJKkQZkgkIK+FpIUc6hEyePlHt9Bv?=
 =?us-ascii?Q?KrSQleIRufOuuAXkghCTt87zGKrv5FYp5Gzk5Rlq67ESYSWO6WtZaU8Xe+tx?=
 =?us-ascii?Q?tdMAk8wvwZfaN8GoK8h5YvmN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a417d8-b919-4aa3-40e4-08d8d42dcbd2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:03.2947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fjskxsVO/Wjt4yhICvPCOUcPg1mV8Gnrub7hR8D50ZgabCRJF0gNMsdLnVMPWVzvblebDT9rDRf/vS5NhixZ+DIbmj+u6wxkBJl4hl0hSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4161
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

This patch adds a new helper function xfs_attr_node_remove_step.  This
will help simplify and modularize the calling function
xfs_attr_node_removename.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 472b303..28ff93d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
  * the root node (a special case of an intermediate node).
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_remove_step(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
 {
-	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
-	trace_xfs_attr_node_removename(args);
-
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_node_remove_rmt(args, state);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	/*
@@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
-			goto out;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
-			goto out;
+			return error;
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
 		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
-			goto out;
+			return error;
 	}
 
+	return error;
+}
+
+/*
+ * Remove a name from a B-tree attribute list.
+ *
+ * This routine will find the blocks of the name to remove, remove them and
+ * shrink the tree if needed.
+ */
+STATIC int
+xfs_attr_node_removename(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	int			error;
+	struct xfs_inode	*dp = args->dp;
+
+	trace_xfs_attr_node_removename(args);
+
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
+		goto out;
+
+	error = xfs_attr_node_remove_step(args, state);
+	if (error)
+		goto out;
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-- 
2.7.4

