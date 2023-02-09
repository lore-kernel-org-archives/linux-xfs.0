Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5859C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBIICP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjBIICN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2692D15C
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:11 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197QBcb012239
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=r6Ef9bt/l1BveTg44pWT0WtCgtVs8+t4AXWbggIstC26iodZTnCQ6bzvVIYkya9a40iH
 OSqCQwAYhS3cAGcmc+0FsMm519taP2g9r4bHn1wAgOumQEbj9lXadw6Kl06oZVAQBlS0
 YqOa5K7Av4bmSymAxGuyxfuVVg0JkQYA7ifuzPK2vRfEOLiHMzX12pJr4Ks/LfxoA0Ig
 f47mAal2ccViJKnHZl+gmshxvCTVtKtOZa8MDX44ObyEuSyvI8mkK1yCXh8ZKA6zbxTb
 C+SDQwg/jW74FjzFx0dRqs3daQJ83CUE4DQEc0RJr5ECUh3HzaxVJ2JmhUP88rwdg3s4 mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdt4a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196c67s036270
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtfg40q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7djBiiRsQlEmz5ZKct+POFZv6YojVQtvff9W6asnXsFONIRymmHAJmj0wP+qJyCHIJGjOg/oNcOjttTSzhYcYM+oRmxv74C8gm9L8RmhPB4owYcMcDd+T6h8c/9rOs3WYqbieJFJ7H3ZoITTCoAcUP1VvJJqctU7FQgLnq4afqK87oVQA+J3yhLflZ8T5dzRLHjjObjB7YRbZnme0E+LvRuUE8HAJLNaiFd9rnz0G1v2Io6pJZqjTaU4zNxqFSwh2yLoCCvwfp5so+/7V6tLmTa7vrkgnssx6gs5i6ZDrwtaorvf4ThYoyC5D3vYbJl3d39Ii1mvwZDv2fITA+XMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=GVB76aXqM2n5SVFeP36X+NqG2ju2+rO/fCC6FvOmaMAzvk2ELah97KSdeMtojiaLRQp1VDGJLAkxc3UP9LMiEU+MaXS0zQ06RCpebqpe2hkUZ/emP0VB/SS2Oyuqjn8Zuyyptv5D24O7zLGNoW9cXlcYKBLbot/FRDF3/Q6oAFKA9TqSjPbNGh5yHMSTcF+CaVmjiMwP+L88UuMOnSYoiYEv8l0xXCmqHNSlWxPsQWiKrrZWpy4xB7iqaBXXQaFG/GTlQAiJme4FENhnOhqFTRtwoXKuhLT3jDZV0e4j7OkFzBdHzl/RBl87W6SLc6ah9i8ok5W2u+P0ErhDSzCjOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=q8rZSZ5JPVFNyH+ZrC0XoEjrjghdmobwHkKVQRB/9ij7L6E+PPaKiQcYy6B0wKI0fRUNNADGT1850go1B6JsGMYhEGtkkCZ2xlgWEgq4Fo2s5I3H/pMruGiEaIFRM0sSaSDAJ2H7A7/KHXgeEhU9EhsKrnkLlCPgxebdBS+IoQY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:08 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 11/28] xfs: add parent pointer support to attribute code
Date:   Thu,  9 Feb 2023 01:01:29 -0700
Message-Id: <20230209080146.378973-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 372f48e6-aa17-4cec-dd27-08db0a73f0fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FS5yd9qO8/Q/3oRe16TlqMWz3Q4f+rnjOJPa+ig9jmpELjMM9sAoQ+p3I7pBZXOCFpmh5cHPubsitGWJvbhn++Qo4hEOvXXReZtmmXdJ9h2ISFCm0tTKMWUdWI1JnB5G8lIdaT80yKNLiTZ8UsFUsFbOVfuhJ3I0yMM+18slv5KE5LKu54WqohrGCcY15bZnoLOF1eAm3WiYkaWSHF5yR+rEFsTChC2wZJkT7KvIGJP9Sg7vNAJ+u23bM53x/gO/2kt7AyzeLrzHQjIVFAUBnH7VaDFJSQ5sasKt3twGy2pGXmnilO58QOgwnqxkTsl5YYekzp/f73pwN+nSPLtaGzoOrzDo1zrJKuRXgsULlZmDO2G3ZuGfIstQOLQzKgUNEKqnSX+yYQZ5FQSvlnyETmBqVTVD4v4Tn4tHoWkyOWlZV/yz8/YD2qVpC10/O0czKruGQEa7t91gnc/DA83d7IHRZT82N3CkmQRrZRKhlJS2BPVCDC+JAtjJHbnCcYjw2smcoBq4S25gbdy2xSd/sCVktxZGCdF8M5WURIdlpprEqC0jsEOnHu1nTyHmwGStvRi5VQtt48dbDgJvj1JS7egJS2a5bvhYyaTi5I0jOIZGfYLKo54JbQn8rVoJkGl6zxNMb9n3NFD2Y5OR0ro+ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bRbcoN3UxYN4b4KeshwB9/qvvosNiJRWXUSx6WVNOySFEZRD87lP6oLE+bSI?=
 =?us-ascii?Q?YvNSrqp9zPt3cPwDer102W7SfL+HssWXscYKKye+F+OcpCSR7jLJ9/FUUYyF?=
 =?us-ascii?Q?9bM6qTMIDl0l4K722zo6eSAlrNXlHGKrVJk1dOInA1eCv7du51Xi360tA+Y8?=
 =?us-ascii?Q?eFrp91Wk6AkNIVSHGOlvPj5JAXoIPw+Cr8zBO8Lwo3/NOmd4bKiKeDAHD2Zn?=
 =?us-ascii?Q?QF13KmqG4DgpDUIZt+f3CquOvpD0wxlNfXC6tkuIXWRbAPGKigqbGquVak4O?=
 =?us-ascii?Q?pRMn8Lz3wBO//b4i0tAGL7tQT+I6aBXodfoRU012ElJ/LEvN+nWh5k3oMPWN?=
 =?us-ascii?Q?ba2VeCk1x9flCaKltQeJmxBb7hkOsvFTUvuVfg3E5pUVHlX6jUTrnLFzw2xP?=
 =?us-ascii?Q?LeY4Ji/tPhzMA7EbLuM5ZH9ikcrJMaaTes7RkbGwGBbQd1AwyrIu2zWvLgQD?=
 =?us-ascii?Q?K0s7SX6mLo3UJrfuAW12l24rHmRusiOsoC6/IZGUbU4yPg/10GjvxR+AREId?=
 =?us-ascii?Q?IsGsLBjNH6c9AhlftyI+Gt2F8+H5XxxDtydL9+9ydUNyFzik6KvK8FhCz8J0?=
 =?us-ascii?Q?23+O3L55KjtiE5vPJhHWVljEYphepnClmKpfDWCRL6MTb0mdTMttSvUftlzg?=
 =?us-ascii?Q?0L3yCYpg6d6dS+KkpBzWaZw1s0fq8fWuIW2QNAO9DjbCNL/sCz2yri8hakZa?=
 =?us-ascii?Q?hcuBxlXtV6a+PxJLmLYYiyWmyi15zXx0H1RpYshncOpgxTvbSsvEfO7kdj+o?=
 =?us-ascii?Q?F2ewqj6vR8S1WVwDxPpvYcH2xscf0ndV3PywX4R0XxLSHNpw3OVaNor+XDmO?=
 =?us-ascii?Q?LkeAb0PuMwPb21MbDENMzamjIrLowi4b2snIaTnb4qQnLbAmjVWt6ygn9pGe?=
 =?us-ascii?Q?P4GVjpLCIgj945y98FZna40yf7Va/VUfQiuiro+kKoIJ1YEVrgkjvZGpyc/c?=
 =?us-ascii?Q?lYvkZ1Jv/eyFIX8kcGAh6VwXWjlJft2j4VQ/wtv0N4o6CfqADe/5Sy/zcoO/?=
 =?us-ascii?Q?Un+bgb35T/NFHQ9lJARlcMWe0bXR2HGijuAMVha8pCBU5PkbAFNAgE4skPZL?=
 =?us-ascii?Q?zVjfqK50rMBMC0Yt9I5+w5ZY/GLGknS/8b3FvIap3+WxlklnyGfV2LSPLjq7?=
 =?us-ascii?Q?NWozZ9buWH+SR+CDLzP6jaoOE5RoEwRtJFSULIg1YSHgjQthITOjsUCxvTTl?=
 =?us-ascii?Q?Ct6shRzPYvH/PizVoPsw8V6OCwpIoZ4SSM5Rq9RmbCbcYWNHDVJF7NkZORXt?=
 =?us-ascii?Q?R9mFu6xK1moX10Fh7joenDqy+7Ph97FT45LOfuIuqt8NCBp8rT/vH9dVz2vf?=
 =?us-ascii?Q?hWJwhLqDTEsbvoO8Ipv6BptPPU2iPhmruVi03U/iD9Ksafb+tmCLEajAQBzx?=
 =?us-ascii?Q?wSjdpcZrcHBO5c7kDk2JCQn/zHQtVmSTMta8WVpJpJ9eR37puWAHpae1KRs/?=
 =?us-ascii?Q?kM14qz2A7nAjTQwrsIFNYWhHCXdP+JMbWGU7xrTP1Mmiuf74F4WLZ+CPEklG?=
 =?us-ascii?Q?kw1Vob1UNot8kqycoxYmskTSb4ul7bU5JmJaJ1Tf6XUTiLWD9MiXHXs7RG/p?=
 =?us-ascii?Q?yJroDf7JQVSZNIl9aQXH2nlSkK4NeqAHFnS+KYbX4epSoo0TKhHliu8nlbZn?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Z0LG5dhyWINPKZACeAr2906GD3jtvQoLhEADlYN193vG71WAaFI8Qq3krU/EiTkt1jFGWXez8WRgIe9p/TZI67r5q2/FWvkSWgs/AOdSaoG4iePuJSCxUoBl64qU8ceZ1HnVLO2NR7rLPn4eVJ4C/PGd9XXBeovH1EQjYG+17YnW5WC6xfdQiZ4Eif0Rj37aUdTASgarKKh+tY+3VCrSM1IggspLjWDjrw/74MQi/sP+jPf8ee67TzuEJI1Q7yEcIRW6F215plnRVJsiSPpClGh8KX3WYwIUfvZZgvoJ0tuGTHq4cdZ4n137pt0+DygILVUny0F3+Wpm/OyF24kZsF7BaJE+Y/Jgw0+nbe5s0QO3gMLGQufRU+fSVi5d/fCH/dyuxFYFw6kzmuNh1VlQi1AzhsKfK6sGeHZEeH1IvRbwZtXnUtK61nA7N14Lp9tIm5VA3jxViemaJHEMxIoxT4893sq/MGMLm22lh4SPr2n0TLmuhDdJ07FV9EzBHGoKUZ5JwHCvT5Jc0pPN1b/X3fLXxfvwkIyv32etcCHKo7VxnCNBbkd7wmcyxQp7T3ZpCtXXGuPWHcRhb+UKfAX6IcIpeTexbznE71R8jNqRrD4xRJJhchjwAPg5hY4VuJ7rsxA8TBnb8E40VIAYYMFZDAas8MxGdQKOV5xmJVTFe5nkQXCCHKPS0h7BsbzJLjlLHUAGqoXSuCXVQUO09OSzqEOpqiLud6EkxP2tHT8cDuxyX06zXsg0jWng3bxMleCs
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372f48e6-aa17-4cec-dd27-08db0a73f0fa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:08.5577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7A4kUx8fbZXqKnA8ZkbTnTCyc6/+yOsYUusNF9RoiFZLPqaKtVERVafwFRU/Mc3xjDBIjl13Ngr6a1+VZkmcg1sKOP+3hDtq1MhdpArEQ00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: zS9U4Y-x9EJOPOuoXpmn_olo91HZx_Vv
X-Proofpoint-GUID: zS9U4Y-x9EJOPOuoXpmn_olo91HZx_Vv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 fs/xfs/scrub/attr.c            | 2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b1dbed7655e8..101823772bf9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -976,11 +976,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..3dc03968bba6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index ae9c99762a24..727b5a858028 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -967,6 +967,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 31529b9bf389..9d2e33743ecd 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -441,7 +441,7 @@ xchk_xattr_rec(
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
+			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
 	if ((ent->flags & badflags) != 0)
 		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
-- 
2.25.1

