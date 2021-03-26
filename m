Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA33FC43445
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F0361A45
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCZAcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38538 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhCZAbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OY0f066348
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=irvY0bU1bgaIEiAseB+3HlGmw3ewhh7PlQqD+fI+bwQ=;
 b=qxZ52N3gLnjvcOwA3z+/UdQNe5KukScIbrfZQ8dizl5PY/20K7qOvISIFIlk2p1/W2pW
 TpLetrSRg+KaxbtaagKDvUPbaTaQdVBqBI8IDkFnmjokW0QpZds0eMwV1BpbCn+1O3z8
 hPleG5LvyduE5eUo1r6oPVEeFTCYe0coEMXmAt04/SdONKXvtT8Aw5gAssg21bvgtAYY
 XWlYQbkJd0lMOjEH983FTh2MrtHZSHKJOZt/Ud5l2sPTFm4RyZ4HHiQb1wmjM5sf/Dei
 sfh57iAQJv2kEwfTa9DM/BBT4YIIZftljSg7siQNoPI01+4xHIqEw25QJwxgUJMt243F IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Omux009664
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37h14mft65-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9/QxMxasYeSNeq/p9m6dM6NxYPEimvoWxynV3EOV49d9NC9J2H8lpWRftIYAXSgSfZXvxEjXgNI9ITIAuBd4do1DASPYBc/JKewooe9Ctsu0ZSNqR7mo6IKxlzXeiyN8vxVC4+8duNMdKvvyakByMfNQlzxewEKbpkvMCEeHo9X9vcvrf8VLnnOdEajZ1+qEr7NqIt6NYf4+YL354vpYTkR95y61QcCxGhxbWAK8FCcTKUj6WJMnkfPXRxt62r78BHQ+MYu4N57rvAhMwRETX3aIyh0BHYbnNuOmt2MKrllZVuo8Yuo1QxdW2Hkdtpb7Lh3rWqyWitflmNQeIemZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irvY0bU1bgaIEiAseB+3HlGmw3ewhh7PlQqD+fI+bwQ=;
 b=cUi7EUApTf/UFw5cn4gcNmfrnSZNmfzNkliZn/XGS+CdIE9aE09jMQnSQZ28WfTcTZ6uaRc2eNi3QWHMi2FhTB1MrTjQuefJUt4Oe8GCF/kPyg9cyOHHXsPHvzCC2F67177TALj+Z+pVAOJhtJd3yjiWI7pjjoOA5+B5+b4PYIzCqXI0voDSjWHfjmaZMK2dxj8CjKFgZc/FRQ3yVmkccmp/L3Dqpc3KgQkNn/l+suBM0uHYlzTyokKsB1GyX7K81u8B7uz/pdV1boPTpcCr57KRKZbO1SZKSJlOwQN19UQSOHGh+WQ+Nq2slOht+DVennjH5eh8kZzpp51UDaEiXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irvY0bU1bgaIEiAseB+3HlGmw3ewhh7PlQqD+fI+bwQ=;
 b=JPv06gNLVii/0XEXYca+QJwOWCQ0Esx2vR7T2ZevX0ZfENbZTNJvGdNoNNARXq4vxGf+RLrVi55OLQZzrpAtiia00/AxlEnag082iDLuddKZ86gz+ZmCe3uls/zpmVoCmgDFA0StcHg2cycEXfmcpaQiWFRSqJe49LGf6PG1tSE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:31:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:51 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 26/28] xfsprogs: Hoist node transaction handling
Date:   Thu, 25 Mar 2021 17:31:29 -0700
Message-Id: <20210326003131.32642-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 552f649c-4414-47a2-90fa-08d8efee8cc9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270960D23E73141F47F24D3695619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9TvKYoMOFtqW0LgOW0PZTtRV5/iWDAB5GxNMm7dKeCV+9hW6ZwyPOFgPd4FIDYYM9zqtMPS2xyKU0/UhjRN006RLlT2inTwmqcXvlkOSBQJ8KAg4l3SdyfgFZ1EDrobJJiJgLkeRBUhPFApU9g6X9i2Kgc4y896m3SK2tLQQ0zIOkLbrAWPy77yi4X3p0FaPhNqd5HGnToOQjGvPW7IFsh/qau/iU2p33AqpC/6NZwIgkS5Eb2HYx1MERLZF5lIDpvSWsFUBRujnDux6o83dkeSAwX0H68FI2drXHgjQ2aKf3wAdToYasmSAqMUhL5Y49wO0e881HMfK+bHTDo5J+HyGDM/b/Jrf5G1wfcZHLr2+dBsy0OhPYaLZBOZn0Nd9ejhxlCBCmRNSfzN4J8FzmooV774HHRKjs2JibMV8RRyhOVQXc4EWECJeh6Q+J79U99kTZpPhtt50UFZfGRXDEa5H0l8S9o4bx5wP3+ApchbAfhgMCph+Get2wa+BN6ipTPyoHy6RnUUUQ+VRq13At3eo7ln+2+RYltAA/91phNkB9sxQn/nvTxy7rv4nEHGZigPwWSWLdKXSpDXYQGX8qQhkVojaW0+Gjvx5gjKZa/6t2CYB0xLEMq/yeBvtx2QtzkzyTt2DeA5Bz1vjvxUeaCRTRA5BI/Aedxfmwx6Drf5Wv+xMsmYXAnlMYBwFbuJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2KbLblA/wWun+GXQdj+inbDffWo/1WreE8Q2RxglMHHEik/HFgoM9IGPC/HN?=
 =?us-ascii?Q?9+leJ4B14Vv8CV5xSy25ZuVZ0ZYSLTuQaDXev7pHGOzBQBB1kG4kVt/exFgM?=
 =?us-ascii?Q?8Z4VNCx8oUINbhdruTvupAhE9LARjnXI/1JDyPl6WRnGpLeBg2RSZQLiHqLi?=
 =?us-ascii?Q?4+lY+tUwVpv2LbIttzzGHvIOspUdd0RXshXZaFDDGI/cGWSa2e8iCqExWLIT?=
 =?us-ascii?Q?V4OpX32D2EQ67r3tbJqxiZ2kshzHPojkgGJgzUmUqftTx2TomtaF+EvtG5XZ?=
 =?us-ascii?Q?BbxL4LYHwILGppVLYs8fTJcxHWbjpITzTeylX73pxypwaWsUAPNCqrf8t+Z3?=
 =?us-ascii?Q?PfziGc28BXarcFpYV9rwkR2KnKtITyBBzMJJtN2wua8X3FDwu+Z/af2fwrfa?=
 =?us-ascii?Q?Xj/cwl3AjAc2ZDAV1sX1KPj/VT5QmOkrJ/Kn6as1ACGuhMsIuCo+d1E4U0B6?=
 =?us-ascii?Q?bWYbHqqXA2FuA2hLPQy/38kcBgm//wWJom44CcA9UaKtlpsNAyTXgQrkYbFh?=
 =?us-ascii?Q?DhyeXx0MNajBZQJ1kZOGbIzDM+4vO2KWkHRJ2OoFxh8qju30GujeiWJkUl/h?=
 =?us-ascii?Q?h8Yl7E6lZXHXIFWzvezuwGlVMcWReTz2zHFmael8d8J5THP/yuwoscwCRYFb?=
 =?us-ascii?Q?+2FtlwvbfrqV9mvFx8Ogs4rtxkuCMY94ZuOfN9lvj/7jEqIMXaD68SJB3Vy+?=
 =?us-ascii?Q?hzf6h7jRc4IorpVfkyuPydBLz0hWvx8SFcAYoFbtwlEI0ILY94+swFEPrs3w?=
 =?us-ascii?Q?ce7FGfJ3rxZJEXUAGqOohVii0yuAzhXs5vzKnxC0pLZAhmmL1MS780QnCK5J?=
 =?us-ascii?Q?ONJ9tdvP2u3qT2U26myNnsgXt1n9t/kVJcSAtG8ppu2jEnoes4St5ppDyJd6?=
 =?us-ascii?Q?xrKbrWrnM+6hZ59tKUUsT6LY+sLTAN3X6NxKjmnfXSFZnxl/oqyBvyDoTbjR?=
 =?us-ascii?Q?ac2Fk0ed7Nn2BPjhbhijrgGNLYYVV+cBj3Kmd+aV2vyOwbNgHXdlau5cSI3A?=
 =?us-ascii?Q?ICx1JKcM9Lvgg2Lv0PY/sty07J81rTxHUGkFUPeF9FR4BNfHT+xQ1u16Bzd4?=
 =?us-ascii?Q?1gvGIPJEl8hI72loZHNw5ONJHUWDat1BPTA1W6/xEnCc15BshIazoAh1zV0a?=
 =?us-ascii?Q?sBfhthoN0fRff5b2wwcOHFdH7iAv2kNMnrrfG8afBGqnOlKI4M3G6r4pbKxU?=
 =?us-ascii?Q?VjzfZ+lIG89yF4wZDj9TSrJ+fa4FRiZq7mLGiV9D4xvRYaIiRRmaDiyw9L9a?=
 =?us-ascii?Q?jp/zgHFrWq8CtK+zMUCGdSpoqHe2pPiC0UbxpoAgZ1Yf+aJwEvgy1wGG7CNs?=
 =?us-ascii?Q?1wzNS1LAQMJuqHl+MyEboxEB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552f649c-4414-47a2-90fa-08d8efee8cc9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:51.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPPovIVI8oNTukkvb7TlazfMuZQhZocsPVqIaqG/V0U/GIA+yjz/+r+hcZu1+KoAWfYc0YRjXwr+jRhu3P5rWIJlnQvXdMjSFjz3Dg6KEfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-GUID: Sk1B7EExXEd9F0Ta5USTC8i-gjcUyZs0
X-Proofpoint-ORIG-GUID: Sk1B7EExXEd9F0Ta5USTC8i-gjcUyZs0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: cb9e8e1fb89d84c77c8035b2391359f9cbf209e6

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 56 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a3e2b33..9801a2a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -289,10 +289,37 @@ xfs_attr_set_args(
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC)
+		if (error == -ENOSPC) {
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the transaction once
+			 * more.  The goal here is to call node_addname with the inode
+			 * and transaction in the same state (inode locked and joined,
+			 * transaction clean) no matter how we got to this step.
+			 */
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Commit the current trans (including the inode) and
+			 * start a new one.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+
 			goto node;
-		else if (error)
+		}
+		else if (error) {
 			return error;
+		}
 
 		/*
 		 * Commit the transaction that added the attr name so that
@@ -382,32 +409,9 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
+	}
 node:
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
-
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	do {
 		error = xfs_attr_node_addname_find_attr(args, &state);
-- 
2.7.4

