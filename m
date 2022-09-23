Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C145BECAAD8
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 07:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiIWHWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 03:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiIWHWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 03:22:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5940012B4A2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 00:22:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28N5fs0C014822;
        Fri, 23 Sep 2022 07:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SYTIO8197arF4fGpt1oUK1oQ4ciydNCmskvG5BztkbI=;
 b=OoTjxz83yjKUfuaD4rYOhM1iay1kTPT/lXO08hHdaxRCU3zVX+QLaiSQnpn+frBAXxZP
 FDAMf98906jq4uYXi3vna6j1lx+UK207mqghD7Er19Z+b4ZsqK31qSeNtQ54DPDyRkpv
 TKzLspofRHYdJBlvTLUuT7LPQq34q1V67OdaxK5038Y9jxLGIilnEMkGdLHbjFRdeheo
 9+hUwWlxUIXer1xZuooCSd4m3Yg5uqusa/IiL9ApsPYOIy45JGnG2YgJBDhZOvTYcgBK
 hkinNevj/AmvRcxcYOP5c9CMC5YQL3zE0P+UaS8+9HouxglePtCr4KAp+gSbt1mtNMKK yA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kysjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 07:22:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28N6oBsj032520;
        Fri, 23 Sep 2022 07:22:13 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39gvc5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 07:22:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjm8sQkrZm/YLmYO+rD5sVyyU/xLUtSg1NTtoy4KuC/orMqZuYqZyrKBT9CMauOBNpgFD4KXX2TKyDzsWIK+e4OMIXE1R3GUNt0K2CepaxlexIY1kTQfspR83uORoZgxCN1sJbvIFxOnmvlyFyeucCAZdTAmcboTPOC23g1/BRYsp/n9CdefEl4Pojm9NLaPSDA+LKSsAvK2feTaH4LZvg0ZTEBOcWTXIoJnQjITw3/mxFHHrdIBOL0aqZ3sEJaV1+AduAZ7Meo7gE7EmYMcrgkuIYHG+EnC7dixHUEqDIHsSPU2AferbzHteCe/Kwza4VVAGwiy0h9eW5OvzYhg6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYTIO8197arF4fGpt1oUK1oQ4ciydNCmskvG5BztkbI=;
 b=EaHqgk7M1VNE/wZe/lWCPAAy6bGfI9q+mANC/tZPHfnuKrpvZDmDw3cSKafTaop3Qg8Rvw32qpTl1uYQhjlDvABBKshzdtuHKQ1/+AVQ5rRF3Iybcb92TzxI/IqubHOrLnVuhynAtdpJZ0wVesyxRYtlA55nsQSpReBLhds5pf4QdaUI1hgxxgLWBLGvIbVSXpQPp8x9oLhefWXOFGjegYxtKbAYQ/UePkGuAfcVoqvpyfBu5G6Fka2bNeXKY+hUgoU0i/b7/RVZKcXVlpmnkqyzzPPJRh+op5WT3761qr/naA+EPNgssz2ljJOTAOxiZZM+uflQB8fuptw/hPCqoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYTIO8197arF4fGpt1oUK1oQ4ciydNCmskvG5BztkbI=;
 b=u3XatUZZNEOhkdFTAZI1wFjH/Se8hYXT6Qroy11gStugzpjjnkpWLv5UKU/bEuJ+4yLZASfZWX3lqoH7qaJfyZLB9pgF0G3gufBW+TDBpill2Rwj5wNWQChexrfYiDIDYBlM/2nMwMF9B7flZEb+5KlJNb+nbpDKig6D6hzwnmw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6484.namprd10.prod.outlook.com (2603:10b6:510:1ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 07:22:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 07:22:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 2/2] xfs: fix use-after-free when aborting corrupt attr inactivation
Date:   Fri, 23 Sep 2022 12:51:49 +0530
Message-Id: <20220923072149.928439-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220923072149.928439-1-chandan.babu@oracle.com>
References: <20220923072149.928439-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0119.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6484:EE_
X-MS-Office365-Filtering-Correlation-Id: d312cdad-9165-4fae-fb8c-08da9d34547b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jHWAGSYJ+I+hzYbKAx1A9lr1WCpZEaCx54pXfQefOUR05/ATUC/LSTRnR7eULODH5hdMo10c0ILA/vorf2EID1vSdOqDk8VsVDXUOBsLYX0ys/bqUDuPXyy6WShgC93cX8Wj1FZ0SvB96oQFT2+LHyhsAiC99jB7uSrc99OBzO9WvXcve0i5bn7a284plAZk8JhWJl3HTbfAeOi+Lg1xqdBvretuJMCYrjMQGHnW55n6HqgWgIMugM7AItiy1UOJ1CqJIPTjIFa1HkcmcjA4Xi+Y7B/A9JSss+8ch/8rNvfyATNxhAZcrIGKDaMkEQdTnn8+UAJDil76ldrhNcW3jk6Xfy9Fcp47MI8clX1s+FHJtpmU/9j41cN8s+ceafo41TCvhnDACYJDXSmV0Szd8KlKFwzGUKUjiGKklZxyd3jbnxalpArqrF9Y+DQqhM1VYdKgZw0edsV5cXFkTR583eOPdyLluluK3loi6dF3gWaUHhKrNmnt9l+peQMVdfVpgq2S0FZpONyUQmjLLni8qycFLmUghmOICOj0XptxkE+kXUFm6TYcPiWpD47CedzZzRyHu26U3+LdUa+ox5F9m4jAU3jDXOb2ERrEB5BOCw54xH2fgwQEnHnMHrfNPI/DkyG60BDjaztWP2He4DxHGmFR2FhR1ZKFKfNUjvdZbMHJpgUsX0M0AQVMtN86nu4mjOL7OA1PXcaJSxt5SGDzKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199015)(26005)(6512007)(6506007)(66946007)(6666004)(186003)(478600001)(4326008)(2616005)(66556008)(1076003)(6486002)(66476007)(83380400001)(38100700002)(36756003)(41300700001)(86362001)(8936002)(8676002)(5660300002)(6916009)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6hzWbej8tutAkUc7O2hp6JQm4kPQBgMSEjDV0PXV17OZ94NpdpfYNjJnuYgW?=
 =?us-ascii?Q?K9Kh+jMLw+lcgrY2jBFwBgMa6WF+rXeHIJYG/vUhSZgIo6gT720sE7+MWq5D?=
 =?us-ascii?Q?lwJKA/vHEtm/2izn44ySQixwH2soVDe55sOznltNE99bHHYp0U6tsZk3e79+?=
 =?us-ascii?Q?ojMPsXNW/2ifZLrFs3c2foS6tgXIiN9gEL8+W96r6YIWGn9aoFMQL04pmC3k?=
 =?us-ascii?Q?/7JB3KldsoFaOwrNOFcfhW0VLrFEFv1IVERd/vkMnrhC6jB5yjbofR6YmrgL?=
 =?us-ascii?Q?f2XZLGQ67Y+56BMQn66i9XsDb78kquEmFVlNXT02gFWgV3Tkrv9Tp1HEYql+?=
 =?us-ascii?Q?k1ZV2b7uyfPGx9uQPBXH9k+DqoxGNcfJHpl5B3RiDrHWprAqBEJVe5+P8BTy?=
 =?us-ascii?Q?7g+Gko0yHucpa3TL4HBrgWRupghf9irJQ+772TAEFTWgjVQ5gEnBMD9MXn3x?=
 =?us-ascii?Q?TC+ZjxB5MvDUUD9teCi+AYCBk3KlO6NFcGELZf6qi4u7CLrgubHE+Uuupm1X?=
 =?us-ascii?Q?vByuZoob230z7j3sJ/4ZKtDYAlCr7vhASgizKsDphqYNQuvO7FQLDL5Q7Suv?=
 =?us-ascii?Q?Znkgh04P9oP4jgqtjhP8g3DECzZEgntDshDXxBOtHtWNVWQw34Dfa9CMQItg?=
 =?us-ascii?Q?pqprw0fnN8ZssAEHtW4dyDIaZnN9Iq6jo7x82zoRO7EublZzicwlZVJoLTZT?=
 =?us-ascii?Q?2qM3SdRq9FwRshNvfPj3jZrlGQOqdBvYQ1Brz7LoPqcpGK5aPRp56DcFSjwG?=
 =?us-ascii?Q?BOeuXBlh5gMtkn/I2+KHCt30YR9jhZfxI8K1S+datAhH4hf0jPPLxs3b8vq7?=
 =?us-ascii?Q?WfQTxlqWon8Glw2MZsu4BLDDEr2MR38XdgsnNz1g5cGENNrtn2PBsnq1/l0P?=
 =?us-ascii?Q?SLjj+nKwEjnqZmUrKMxZdIvuhQzt+2jafKp16GEFDWH20Bc6p9RWiv2pckMM?=
 =?us-ascii?Q?3jezccx6Oy40oPs1iRhJcxYKwpPG+aMvyltF5Wrf1WN42rinZbogro6GwmSk?=
 =?us-ascii?Q?tUUrliz1pZaFA7FLjsN/1PiIzaIKaU4bH/LMV6J/47KYjUK09Lkb9FBnE1KQ?=
 =?us-ascii?Q?fJHvzvEVgR/u1CghPZnb03wLkbSvfdVzeze0J1jjVhmXbWM3XAlC6T3dpTVs?=
 =?us-ascii?Q?oQ6ZPDBtb4+HETIlyAf2dpPI8iQD65iPamhCRZ4DBk04b3to+0ExQIyKR28u?=
 =?us-ascii?Q?/KVQkW0zLPmZXtqpgbWQLWVeY1a5/v0vB9yEanFCNKZgmGEjq7VWkEWokf91?=
 =?us-ascii?Q?3LTFHdRqxz+SjF47DP26tPrfpbM+JN1SwazTL2QYn9vnjQg5yQK63y3XFV6s?=
 =?us-ascii?Q?pvTIHAioICHodO39QNHTy2DDEYqPK8qGMXSvyn3XpgtTiLSoIBHaN7pjawa/?=
 =?us-ascii?Q?TkBHnKbLKNy4K5cCdesVrcwSU2m2ZCJxtMvkhtw3QixWoC1f2SlXcepjeXB/?=
 =?us-ascii?Q?BSu0UNUJXL2AtEXAK2YTxUM2EX2VglX8eEusKWhzLi+t7U2i7LUtrkkqU3ra?=
 =?us-ascii?Q?fN21s+7I/9B+i9ExeaXJnHmN7A2dtshDfNWlQejSzK45uC39ZEN1eJtcSIgE?=
 =?us-ascii?Q?cf/w16MDXMcfniwBe3xUpFX4hxTlXr3gDJAEdnVH87t9rneQdQm6Ysvm2rZ4?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d312cdad-9165-4fae-fb8c-08da9d34547b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 07:22:11.0430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jy5knsdGY7gKv8T7HfgZPowOVUp28kVsKt6h2GYj7b3yR516GPVCcFVm4Hdoq9sN7Qli2l1WOGxQPSdN4hK/yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6484
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_02,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209230046
X-Proofpoint-ORIG-GUID: BcIeTGGT9quE3PgYFnYZrbrfLntmVsBO
X-Proofpoint-GUID: BcIeTGGT9quE3PgYFnYZrbrfLntmVsBO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 496b9bcd62b0b3a160be61e3265a086f97adcbd3 upstream.

Log the corrupt buffer before we release the buffer.

Fixes: a5155b870d687 ("xfs: always log corruption errors")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_attr_inactive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 43ae392992e7..766b1386402a 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -209,8 +209,8 @@ xfs_attr3_node_inactive(
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		xfs_buf_corruption_error(bp);
+		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return -EFSCORRUPTED;
 	}
 
-- 
2.35.1

