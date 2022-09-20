Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D64FECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiITMtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiITMtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1203E33A
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAgulI017969;
        Tue, 20 Sep 2022 12:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=iEAINiM6CbqWSapLbtAp+UgyyjxwhHi/YS6Ln2y6rD4OkY2YgMRgVotARkA611uJPAS+
 kMUpA0indPDlbB1RbBYVTaWLQD+MxEL4zrlxR351prnET0GeFBcUP4ZJdLdkJJFPm72P
 bYs0XUAR9nSPa30DabaTJiQnhMTE5kH+GXRTyobhNH8twtaAzSPYzFtfkP3tD4G4/0uM
 Os6jw/pFea04CtIr7G3WGdXzkHT6h4OQu7hAhk5+krrJJ7O5LkmNhdWykKN4P5DrzeDv
 2v6QmRzz+26iqb0x2jdYcG6qnZCQ5mpddh0a4pT83GDMgD8iRv751BHap9X9sU3DAHUb tQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688en2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAroAM035710;
        Tue, 20 Sep 2022 12:49:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d29quq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRNme8qMR1/4KQwfBCcSubBaGK26R4ZFrI8J61vSRE0fa000wqevUdwXP45ORkvDoRHKPRnCkK6k5vzF/yRivVChZIOFJXU7zYcFuNQw77Q0QeYTXqMFeAaAnspb2NnHEj+oC/imo2QI1KA/PVg7FI7BTG1oPbP0GGkn4NGKJ1duMFFkQixbaGyhniw/F7yviCz1oMrh/iwTebk1C6if0vZxPiANVKcG/4AkOqcqoIlJ0k1f4100rMJapx25JyFzsXD94vyuHHxsD7tUrT6+j/FL7vij4SdhA7kh9gIDMQRz31MA3Wjvblevb0u7RLA01cJAjT8HPp8OAXDkcKGEBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=DmtLfp+AvkPcxm/vic0HMEGMuImq2Y1qpvBabUfQ6nIt0Rd5O0NqiDQp605enkUx1e9Hqp0ziTvIPXS0uqU+qeLqsJ2BO57XfNZVIuzbF40m9beQEmU1VmTx294YvvuuTROkDCOb8a9IecMRgbvSEB2sWvrWWOr1WggBRFAyGJjlmShbezXie4AX4+H7aoQP9C78ys1j03CVKGCVXHXkTkxewe3S5sVVqyDf8kW42gZsfgEnHJ6gfWKr6uInhNd+/BDh74dipOJBkGTCapzfQ7hwOpRrnJcO1jJGhQ52erJ9EjEl1YCzNLGx7a4Q4IWXyWMTdUolZDbn9yJ4I8rhtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=sviEuGF+vCmcqD29ob8nphgKfRdkd09U8NINVEZLye1b5tXjlPogbAv93rqf07I98JIoAvO2QwmyGGKLgbkWVFPrQ0rcdrQAehOOFm5Q9HX9ng9FYmnYx8JNzMXnZC3DlIdTqIbxfrw2gSDtJi9T+9wHVAe35T5bOCSYh9K8aTU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 12:49:22 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 06/17] xfs: range check ri_cnt when recovering log items
Date:   Tue, 20 Sep 2022 18:18:25 +0530
Message-Id: <20220920124836.1914918-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0009.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d7811e-64c3-4997-9d64-08da9b068a3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3mR+fnOL3gnTwWa4ZM0cleMbrZc+By2R5qO0PQhqEeA9gciwvDmNLqNmtC52GDNlOmQlr6wJBA2tWbn1NVV2sr764BBuAvbOVRH8LD3mOthV85mc6Bu354KmIdsXQLtcl3RDAXw4a11SJJ1ONn9CJBsk4l1VXL/XIexZlJOEr8jfq9OgmbWviSSjGrr8duEV/Uw00tk/A4678dUzWOGu1OllwDC5vdTN/IA1XM6jWGYGPOCkQfETQbmA2LBCyXwQ9czemBsFMmOr/x1spNxmLgLKm8u8tqV44dnH2hw3gQBnb/NHa+GD50kKalZLcjZ7u/B9Hjd+5SXXDxHRjUCuHeJK6rqmFPOWdsrDuabuWkGrTdlz3tUQsjsoZIARSpl4x0qfeD/9AiBYJz71jwhKP42N8+0JjS1XYjAvmJAe4Db3bLoyGK6WVwSCDG9BmNyKS1nhGzNL809vYgKCNAEV4yTYiRxlN1G+OkBcldwwnX72y/VwGHZAKh817QCmZsvqsM/B/um/4HRqRkBgzghFHiYOaQ5ypghK2P2on6nUvwEQhSCH+Yyh6MtaX3stjjG1w8Lm2Rk94/oxmupfMBYoi+nJL477WKXVbnjhcrhrX5G/p9LVey90zzGZNOWq/vV34bgnwvMPEAwWlH62IfSodjBdNr8Adg97UyCjGJC5ji4xxBIWvS9gaWaYlQHD2menN5AwdO9pWYYy5USFk4sMyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(5660300002)(4326008)(86362001)(8936002)(6916009)(316002)(38100700002)(8676002)(83380400001)(41300700001)(6506007)(6486002)(2616005)(478600001)(186003)(1076003)(6512007)(26005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NfpcmtZoKEa6i+aCuwTRS99HtzgxXqD7dxBdK7GIpAz1fu4uQ09+5ikegDxh?=
 =?us-ascii?Q?eE2YH36llvzEYtCzllBcjYlRvhWLl8zgWLbFtJcYszFIbE9vDSwEiFxkl4cY?=
 =?us-ascii?Q?fYGNZ7ECSCmaqtEAX/9zbNqg7pVTQQxSmH3gf24gJmeN98TLEKC7HiMCvgiq?=
 =?us-ascii?Q?khy1J1btObAI74hSGISZ3OE86nBxmdysoBFm99Zb6LxJaQIRglgvDOSA5jvU?=
 =?us-ascii?Q?DKDWDdV59EszRVd26qugdgCzNPHyWQyecpkBeng0ZUgT6C7pZ54RVQFf4XYA?=
 =?us-ascii?Q?KxHaDpGKUK4SuEewqOlhjbv5J6kwYQkA9jkPEXhP3f3ndW6wGq7uTn8gwQ26?=
 =?us-ascii?Q?y7rn6WbjplNuNKmTzvYi01KLnIzFM9m0Qv7IUsXf/59SdyxU/lQC/N5bLqLj?=
 =?us-ascii?Q?NihTnjJPW/Kcs/2/efdaJT0AZFHscH63N8/v9xFt1/AussewWBpXAZtng3Hb?=
 =?us-ascii?Q?Jna6CECmePlrWBkS1lPsJOacEfNrJQPtkT4yNINOSy4QHE5GCmHp+wHdaI0r?=
 =?us-ascii?Q?DvSoYho15KbQYDiL6rN9z5JhKR5IKK0SNHf1hsi6x+0dswz36q+GlClEcKAe?=
 =?us-ascii?Q?yrJaEwuWChzfuohmgOryYmoRO4oIhA9W+12RAsZ9jnmOA6HLFhlv3ZttBCfF?=
 =?us-ascii?Q?ldKPbcXZ7ramIFVGhkcvDm9QOpCvwbYSPG1E7+oJukHUEolqeTO45KwHhxU6?=
 =?us-ascii?Q?KcyfLEsU3Fg6eVYeBjTWx1kmQAxrryaM9Bug+Ef7VL/U3+JwyyXoL8ppqNJE?=
 =?us-ascii?Q?rjHNpFTiZZPBVpPzPSIcP35U10/yiyZZ18ZtU5ghVYuCmoxmkbsHwR4SqAqS?=
 =?us-ascii?Q?YyzwfX+JTnuNqHmAmAA++QS5eVXI75wZDGJfKvk9PChCpKQOKZ8y500U0+JB?=
 =?us-ascii?Q?HLVTKytPOrJ092OIYW8J9Gmb/40J3rizqeaK9q/4YEu4rGrgwPUfmcBk2Fq8?=
 =?us-ascii?Q?fKlI0GFLUO3xtjDvQ/W5gxxz8mUs6foePUu2GHdTOEY1MPKO41bG5MIC2dvF?=
 =?us-ascii?Q?rivVyqXs3xUaojrvcGnl1hMf82Qehvh8YT6voyY7hjwc2qBz8cB/Nggr9nrW?=
 =?us-ascii?Q?DxI+sIJoUFUVQdXMkAZFhm/9wBNPSDFMKLPgnYo0PbBSL/M3ycgyOU3Ncy61?=
 =?us-ascii?Q?Oph9OCgvIqhMJ9ZVPqM0mf80JsoO6SDfndjlJSpHlBHHCIRVyLgwoziC4l7+?=
 =?us-ascii?Q?/JFhS3yshalx9ngEa+WcGWWDhSh/uPe+JGLqkjp1tqecjbgsWU+Mic4MwKYx?=
 =?us-ascii?Q?2PtVdqWmt8fSlEI9YDRMII2hltZ3frqsLKiFFPOeShi5Rd4ykRmc73DX7se+?=
 =?us-ascii?Q?/fLzzYvRq/YWQ1je29l+Wq2ZMhe+vhHIy8jQk0UOv8qp2ei6ixZnsGo9D2I3?=
 =?us-ascii?Q?PE2/z14EZ9VtzSSaLYZfD8/y8iVF3FaYlR2ICkIm5n3NzjJe42waL0lggdPn?=
 =?us-ascii?Q?ag+5tf28orBD7KqznUDXNNvWL/nigjIgqHzcEKhiYyGGDcGGp79Y1Td8h+VL?=
 =?us-ascii?Q?tzi6X2okjDWlBvdRmWB2aOf3NUQlNtabP50W3zLZaQk0KMgUnTFnZkNEcipd?=
 =?us-ascii?Q?sjH7uSOGNE/HyIXUGUoeI3mMH9KQzDGVtdmrJ9lU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d7811e-64c3-4997-9d64-08da9b068a3a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:21.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzQ6qC1aDnsHRRLTU+v7akVTkeIYg9nM/7S+UmPBl7f2W6YJP0YkMLWFsMlHN3gGhdo8pjJwYJu/6DSdSc8JHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-GUID: qUl2RJ8UNZzjHv6ZEndQXM3peYQCmW3k
X-Proofpoint-ORIG-GUID: qUl2RJ8UNZzjHv6ZEndQXM3peYQCmW3k
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d6abecb82573fed5f7e4b595b5c0bd37707d2848 upstream.

Range check the region counter when we're reassembling regions from log
items during log recovery.  In the old days ASSERT would halt the
kernel, but this isn't true any more so we have to make an explicit
error return.

Coverity-id: 1132508
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c1a514ffff55..094ae1a91c44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4293,7 +4293,16 @@ xlog_recover_add_to_trans(
 			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
 				    0);
 	}
-	ASSERT(item->ri_total > item->ri_cnt);
+
+	if (item->ri_total <= item->ri_cnt) {
+		xfs_warn(log->l_mp,
+	"log item region count (%d) overflowed size (%d)",
+				item->ri_cnt, item->ri_total);
+		ASSERT(0);
+		kmem_free(ptr);
+		return -EFSCORRUPTED;
+	}
+
 	/* Description region is ri_buf[0] */
 	item->ri_buf[item->ri_cnt].i_addr = ptr;
 	item->ri_buf[item->ri_cnt].i_len  = len;
-- 
2.35.1

