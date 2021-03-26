Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB07C433E8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F62361A1E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhCZAdg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCZAdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OksD057470
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=g2cw3EdKTsurvbuhjudKonZ7HCpp/xTCHqrQTxoxU3E=;
 b=Zf5MS7wxkEfjCZoxSCYzWaz7xMT1mIprHCwURp4PM8bZgX+x5W7VY0up9zoNWN3YM3ql
 qlpbKXJP2wXb1c8OOsBdUjgj17nxE/uBacu2vLWoU6aPWPbvMAU55VUGUspdoBnDRN3l
 an04hZYIS9YM33ot8p7fwnFEFAM5MWVmr8MimvrBImHH93DLsfY639RopkKTwK2wXHr9
 m76QdvSE8V0nIK8XbhPanwiH6rkxr9rE6dGAEho2rUOCyjY7BFQwsyYa+Z3co+AQeUK/
 9bW3rG2GbIKm7dptfE8aHdwpbU/zW84kOQ410mduo2KyU1ySBFUIIb1ASl0IoRT5GglQ 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37h13e8h62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0QXnA076081
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37h14gg490-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqt+qDOMII5ej5Yfqrryy+aibJ/ZsXqhe2cSW5uxI7nErDQ3pZeoZYm77vKUAdBDODajKTj7WHaYX3duZUfKbs3eIIEt/+vkJKYiFiRvI4EtxDikoXv6okQCo8Q+W2pR/9F191DzK6c8JKV7A1ul+h7d4l2WOaasQ7cQ5xkPRYMfNBtUVer2n/C/Mr0ZgXY3K1RH/vozCmjsAi2wYlkWXbMmTEEocjfBGyKsTc4ngsBccbNs2Q6F9tW4+H7FWNrRLXwYbcA5LRK6UhFWEWD+aIkAosroL5htGT7Lw0rPD0Mfwp2lDkSkc9mKcZYsQQUIrcxBr74td249k2G+4Ht/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2cw3EdKTsurvbuhjudKonZ7HCpp/xTCHqrQTxoxU3E=;
 b=S2kIiVgl3f450Y8S2omPN4cMrnQLxD26kvhFVqB8pGDbbgWnqjCHCNgVSlfJG1XdFve2a3gHGMRGhBUbORfJCyKmLwJrHR2cZV3lcN5F5UDBgiT8AlKV0vyj1mXhop/dqpu6yNgtzCJPpvLTGj2omf3bjql7aLyZm9qGBSaxPTmobmyHV27mK4/lV8Bmtxu0YN4NjNSqXPjX9HLKjtnboolAKFld4tehVfAWicMQBIXgNRB8SaV+LNbellPEGQuHeT29xEponAitArVpO4zX8TZ/x69DQlBm47peHvAlct9NlgcOKaOAkK8a9P1IA3YhSjwX6KdUE9ZPG9vr587lAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2cw3EdKTsurvbuhjudKonZ7HCpp/xTCHqrQTxoxU3E=;
 b=Eh4M4hKaVzjZEiWuyrZEYe6ds1w7/RmoGtJv6IUptTD0mG3/5wztmayiU8Rp/eexDuYNnSbyNDT+0NBOgCGEFzieAecvmLCeTK2WfeqMwE5HpKDnNbkLdggNUc3FgehYWlIuoYwpsZ35P3izeqvp9dHYRCRBET6L5yNuZQAipcg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:33:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 02/11] xfs: Add xfs_attr_node_remove_cleanup
Date:   Thu, 25 Mar 2021 17:32:59 -0700
Message-Id: <20210326003308.32753-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003308.32753-1-allison.henderson@oracle.com>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:33:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc729ad7-fd17-42ad-524f-08d8efeec16b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270946F5A4E43F5FC4D559F595619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yDPBvM3xu1ry8/TjBYnRdN3bKBxZyK5qhLWUWuU8GmIs3MIgmZ4I5wA74zKiWcgp6+fOHUXFp7njrofABU/wjToyRwK9D4YYcQ/2efy3rXhTrS0+NCavswLyklx71TZuNB0cLh5v/msLraf5NjKA9vmv16iRMtHng9/Mn/r/gat+B6AYxIUTlB4Y95CWSDW4AmKIwcu+2dU/eYa9TNi0DWMiDkdlhbC1n/syzJ9klFAJLB1h0AQE/d6s05hMpDDgy7JsyElFJlTmt/nZFr5rrQLiiAyFdD3NQ6n28dZExjaQCvq9Tn0YKnUFR4bfw51Y6Ps9+6vKszhZYPUb17VM7cTBp2oVM/WKMpTpDFryytmAhFo/AriaiFfFTNd/P8VaBmZoflIxHntK1EpVpnRJ0sb5nw3urOlRF9WhXzEQ2rXedVcvOiKcqYDp+bPkiKYbZhjmATcruP0NS82DIA8RaFWizxCa9kBUp5FoIhEf/xWH5zhk0b2Nh/Lnpqb4fA43W27O2OXh9FQTtnBR6WI13SQnuCXwqcjWDgXaJcjw2skCM3POEi1JWrlWol86Bo0TA4iC4b5K7BANGaihI3n8q5FH6n5mytD52gVfumgYm7/iraisqt12jMPYhfkmpqLweowMeAeE79VJbd084zKEOGRsw5BGaQUwmEN/UXki5qZNpkHnCWTkpdPIb5dPk7fT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+S/e3EAwjc53bKM5BWXddvTDomu50F0kn2FrUCPI7Fu81EV2iRiqwTM6NDVg?=
 =?us-ascii?Q?p7NxhNIERcT8JtoDowRzYNNfoln2G/49P+LClDgQLE63nsbDrPZQI0wWIoud?=
 =?us-ascii?Q?/G+egDdsKOPEMdirFt/NKRcnMaVUK/TxqqwTxk9iErf3yNW3vMEYxY5xxymK?=
 =?us-ascii?Q?5saphhoCEqZBghxTnmacUEsfCkqn7ku5LUlejMqTFj+x59K4Yivk45G1K1wM?=
 =?us-ascii?Q?jflaI4rnpGhdasgZ18CUJzRpWB9lNERwCxqncITPUhe4o3ptlhKOS7q2smHT?=
 =?us-ascii?Q?weihcU4+mnO4r8cXx6RhHBEJHX29zFoDkJuY1uZOBbfOB3EGaiZ+Gmcf4Nhq?=
 =?us-ascii?Q?FMRcIuJvmsYMbRdFS4gia/2mqktie8LGfQzGG4ndi8spiZbo6naPua0+f2SA?=
 =?us-ascii?Q?PjzI/bCOkfbJbip7bTVgjm8II17UvjTQlogdcryiJzYEwGpjOkeV6PRlJAB2?=
 =?us-ascii?Q?dSNVQzYWuVJakvPpVyqKzyAARQ2xBhbnM1c2ag9XZonjbtt3dLUewSlmfyAk?=
 =?us-ascii?Q?OqFD7DN/VpUeY2z/3BauCMpnlKFd7BBkOdsb953i0HbVjKV6uEIGtueXZnpa?=
 =?us-ascii?Q?5oukNIlKlXSBuHO269quv7XsYmAMswYhi0UExpTXsRZ1XrM15VrnJGR+KAD6?=
 =?us-ascii?Q?qB4jGzMSJoonr2phZ4rmcoVqAu2aJQzl8d46qkTRmMAxPthskI5r3r7gWo1Z?=
 =?us-ascii?Q?aVALhjlhZ4mDoJwvpp5nIPwpCV+HcQBASkcKwJY7+b4q1V6jANTXszmll8mt?=
 =?us-ascii?Q?8r6PJAC/X+8WKftJe8pyIpjdTniUdWB3JLfGJpC+QFMOOHB7DR7oMgE3JkDQ?=
 =?us-ascii?Q?lLLePzx+uhP/fLZAzFAd8d0fQqWP7eQfeK5ChH1b1hxRHtksfCBSJ1sI9Btj?=
 =?us-ascii?Q?5yvlZXuCRb4CbQsv+M2raDyLpQDghlwjoonOCRpwBdXb3pOD9q+/oZU3sxCN?=
 =?us-ascii?Q?wekzA9Nb+GlelxOp4+YW45tz2Sexs+ZWNUge2FlaqlL2nEAN5WdejCGGH05p?=
 =?us-ascii?Q?I/8CWT/m8dS6Ou+7hNqbz7xV6KQt1jS0a2edQeBQ8VaIgevQN1gIJwFgjE2F?=
 =?us-ascii?Q?tCSOnokhiuBv1uktnZYq5yYGSOZhfIIUv9/fu8E0uC3HuoUHaBLPSQS3n23c?=
 =?us-ascii?Q?txlXikr2isP9EHP0/6F7yVpzvymovSBAe2pANlFBn5r15CWqWZCSaq4TJRC0?=
 =?us-ascii?Q?OwaKNMq6sTI/RNG2BqgTtoKF+U3PYs5zZsUIuI/zPfFZcGt/LTfPO/vwdEc1?=
 =?us-ascii?Q?0N97VQ6j74RrEN20M756Gat9Oc2wlMgAFPdBcK3W2YpSQ2z+TueHnLn00XIV?=
 =?us-ascii?Q?LaMd5DPpFSCJo2Eg7zxPfwfL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc729ad7-fd17-42ad-524f-08d8efeec16b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:20.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f09zwXKgu179HlNNr7bAR4iVzOqolk2SJtMiwqrSgqFBsQnktlqm8S8ZCjnIYQ93Y8CmhNksNO2WdSao1n/7AOS4nELWSDBs9dgaPSyFghs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: _oJ7c46WO12n1-nG5vZEU8QBKiwFCWBJ
X-Proofpoint-GUID: _oJ7c46WO12n1-nG5vZEU8QBKiwFCWBJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls a new helper function xfs_attr_node_remove_cleanup out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b42144e..32c7447 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1202,6 +1202,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_cleanup(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1214,7 +1233,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1242,14 +1260,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_cleanup(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

