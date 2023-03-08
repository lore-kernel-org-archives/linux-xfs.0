Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF16C678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCHWi2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCHWiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7E562FCA
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:20 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwkmN018336
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=sil5hmlriTuO/5LEWcHrjxfMeNhW54fZBHtGUizezRto3kmctw90FWeKIboTb26Ts/8X
 ry0mYzxC8IBykhVv0xlE0eM7q5ySRnRcv3TpJzmbV2btoOLZxSSL8m/9EZUqmC9pDcfe
 xBpmcFVuLCp9tdb9Z6X32CmfhkKwthUGDzWFSJCRls6AFQSKW8uG/Ao9KAPvqEG49mCa
 VwKPITwE09JQHowbnjQToeT8ffc2CsVydWqyxi+DHbzaJg4XOetIZZll/tldtxhNyPB8
 e3unn2+iNiye6a8wj5lKWK913BkdEcl2jeS2n4og0pFPgT3WPs1Xft17I6tnn0TC3B1f PQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417chcxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LM2BN021689
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dws9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=We+K41sO2Bk7N9XGkbmuSTdMzjU5trC1IILy+A/54Tzn9JEo5evZHBaFoSLBj/NL8bi3j6DAahL7u0K8bRGKwhKO4HWPwrpsjEKI5gwjcpRguqZVTu4bGWvtTdPLVF+qrUbWZiRsZhHtQKz9jgN3bLYNM3RdeBYhmcDY5sEHQpdZKKENNX1eANKFb9tdybKcixnvh0w98LdoJoDce1z9h2SnSrn7dixNpACFIxiSUL+RYGjKa4cD21yLoBLYriGrr36ma0Pe0xBok0xGCjwYoZ9CqjserGMRjcSqwZUMqPagzA6xE3n5ojFv3km7BruR7D358Nyq1CQiK1qTU98JPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=D7/bADVpgJe2CeZ5MBsMyVefhjaY7ioUlgp1NR27Ur1UOvQHZDMeekrsZ5YmYWBxU0fEei5Zh6h2Zli2Myh23nimp7+6rwXPSSurFTbd6RvzFejjVFcoAyJ3k6U9zxDNdD/g4u29q38bDvbZeEa86civaemmfPc1nCL/wEtI3qJ2/uV4SUjIxPYj1UOUtrIKEL9d9rAXTyam/VtEnvXEAlJTwcIwsnSBmqitbrDceszePLVXbWrH9BoHqM5eWPU97zy5MISbuy9omK4u5m3zbPMWC4rIC3TcQpx/DyJVBwYqh0ozxda9A7BRyIfApxRTlun5IGt5c9avxHVnAY6A1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=S5Y6+J2zEMEQtYVh0blc7gxSen6H8Dweci1xpr7AaY08QG5tdfr+Ovuov/Bi91YNIpPPs0og7iy5a4oK2KchTXaJLHl/J3MxZHEGxYaUM7svXoEJ0gOWGw7EL7cdrL4Ylw/uTKCdI6xJryuwYa7K6ylk3LLTtHzJxQYMRCvj9pA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:17 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 11/32] xfs: add parent pointer support to attribute code
Date:   Wed,  8 Mar 2023 15:37:33 -0700
Message-Id: <20230308223754.1455051-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c929e72-229a-44ab-c38f-08db2025cf65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +J/A9fj7xONcTQoXr7B6vOKRJYWg+69X6YVuWrRfMOGF1P0Q9ifowZnlMSwrDSt1N8NHvNgOnHkmneeZv/XY0DSuBUelXGVPCEUJtep0LUefsPn8wLXaKKBmbeFn1FKuIubCV6uxWC5VcCo69QONy9Drt/uR5NB7VgBxcMDcxmqyYlCrXJsIQhN1GFajyKJIq+G+/JXqt2bUrx0MVFmMBtYYs5iIUWoJzzQ7G2pXdG2k7LV6Op//3ldC8t242c0sJhhcSt55ySG14YvOemoXCx6/t5u/THEmeO4VFyR3kO035sCntCYRJC7md4CxCAGL2LKl2zYvE7osDeKFPFlxwhXKzrPV1hX1jkpKNZ860nzFx6NxXJODWE1wY1CRA+OfyZNAFO6FuUK+FXkWOTT0E4P/74jOA8Ylr/Piy/Nc1Wt2AymKAkTfUxrlu6cuxWLftdPkWJYnnp5NAEH9PWO+y7d0fS2jY6W02CgT5MxxWyoK2uQs8HdGzhtcKJcTafhuijImzu/YQY1YkGO1K2fmZK6ouvqKEx96YouDwz9ToFfEMo9aoy/WEsUa77wrjyCcpeDKodVa/zadaWI8TUbNiF5BeL24KZ07l2FNYy0LWkDeiVbAhr0eqXNr/WSRa0h7dr3ZZU+OaXnZi9+uQKeBag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X5uWLjrCKZe6diXSGJNk3mi6WBJ1wsNFVSdlWY2BNruWp1pV5y0M5OuzzlfC?=
 =?us-ascii?Q?wfwum0F1SOChwFu6aWsI0TtYgh+J3yTyaiy7+/eSwTBsacwGnxcY0rYOEbUZ?=
 =?us-ascii?Q?9keWdwd4qU1lBfWDNdIMJjDEl/sw+29fWQ8WceJyKDIYU/GFGZwz7cSN3chm?=
 =?us-ascii?Q?B7J2QAwApmfTzl9pZqiLfdFOpc7Oo+Cveprju1lTc36cni2tv4n7BXpe/uHX?=
 =?us-ascii?Q?iNadhz8Td+UagKAVFx8neA5pE0bFDJy2BlVjoNbc9Hd+QPu8V+Bb9oTf9Wza?=
 =?us-ascii?Q?611iCtli14OChouNs5Ct8FUCeWRMuGDOWg1OjXGfEoRiCq6gD3hHol9USFNK?=
 =?us-ascii?Q?k/O8Of5LX94JoIQpr8NGleWDdSmraZoj8ceT06auPpyJ+UwGoVoYbQEc7rQU?=
 =?us-ascii?Q?nAkd1SB8Zv7bGaXJxgswemf1SwebHUSDwtb9tVLdyLqrPmRtxkBVqKTDWWJ9?=
 =?us-ascii?Q?ZAhF+gn6Jhyg+VgSCi3UeqFkDRliGmqXGwSGRgDj2+9WVYvBNDlbNITrVpXi?=
 =?us-ascii?Q?r6Cn7Ko7C25spHx8uGM/DohLxoUx/g/VfKuRrBwgemZ4xVEyt70eNTy/Oquh?=
 =?us-ascii?Q?MYb6OhulfKey8uTM+1UEARuIFSVi1Y1fOQjZgy452hmyy1iqU4xaBhVTup2S?=
 =?us-ascii?Q?ycvOoSgw+JjM7NR3KOmykQ/gwjToli2Wm3O6wP2ixObrrHzy/89c8ILMewzd?=
 =?us-ascii?Q?7xnknFAn45TrtRfpznbQTRPp93h+TrSuAuMhmvKlkUqkXtFpfiX42HzaIeWf?=
 =?us-ascii?Q?Gk02r5zzxPo99F8od4rU50EtRjbZkpWK9momalsdcKwqjP5ayM81vKYXudBq?=
 =?us-ascii?Q?sYctrOEZMgRCbQOZyP5XrVlvQ611hRBJvfuAUWnVD9p3pDH8nRY3skZrRShU?=
 =?us-ascii?Q?dSdl59X3uZkvW14YQjNxlCHN7hbxw7uaB/F5V6K90zdQdhKDvrY/NcfwMNw8?=
 =?us-ascii?Q?Onv/HLk+mgDGY7hm2lmy0gL3aJunnpl71PPgVNpeskR/aTVP63hfj/zAkSom?=
 =?us-ascii?Q?d1tlgvPHlillUa9FhbCdRcqCT+Q2OHIHK1yPw7Vz2LgyYH9vZYkJtyTAM9m3?=
 =?us-ascii?Q?HXhnwLzB3AhiAxicSyq6l19ovotLyXefsOYTH/MAIqPo+TivDanBWJbTW6he?=
 =?us-ascii?Q?LZjomr42fzIvLc65DgZFEnYcmfTdgcQhUXY5K+7uIeBvMkqBcXHo/ppV7QjF?=
 =?us-ascii?Q?uYCXYpo6Nh1T21Ef19AqBOURvtbM28sLzUtiWJ1PDdYHe6HxihQS5cPAus12?=
 =?us-ascii?Q?SjucMKMaV76MuhSdYZDaApoXBuolRmlmzlOqjaomGb64/vSb/lFi2+YAHA+r?=
 =?us-ascii?Q?gIVifn82dTEav5ew2STMRtTZZC1v40Kj5Ljf7lWTZP/SvPF37JTe2VJuaiSd?=
 =?us-ascii?Q?U1a6E9MD3jIIpcjSwZq+Cb2NbvM2JIV7AsR+rhKD2MInniwe2WZkFIIg9+5V?=
 =?us-ascii?Q?HdAWfX69ilPVo1WetKXLCZ/LPp/vmmkQxXyEMWDkr9Q29X1m50AKAJiC/2Uu?=
 =?us-ascii?Q?LM/7ITGARcY/1RDAkCAKDlQvo635noWmLd1WFjdWLfuGdBnznvYIkEI9UlFs?=
 =?us-ascii?Q?e9EgsDHV1nWgMfFfvJTFt+LTQ3q86sLl21HevWzq6rnV90AIGIvsxlzNCsZV?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4wxd9mA6tl1+9I0UkTKHS9w/tz1WnzSB3/NgyJ81fogDCwKksF5hxKEW5Tlwqszaaj6obuYHTu6ttuqrSOdv+vTmKVlMq2lESDgNBZTUsdWHRZnA3zHVddhfoNAeHmdYnNHC4OSKxLi5TxikR4sB/az8QUGuBoOLNvaytZvibTSzTRLkoOhpDYiOgLWznr6K3IaSDGPxvrFPEEpat+Ig4tbHim1eKK1jcqqTEfAjIp7xEk2phPo9IatoCg7t5HOXjk86uNickuu2tB4NMi8gj1LuvSrLuS8xO5VtEfPbo2B1VU+SaA254EoFOvoM4cGj9tbwu+2wThtSiPA9FDwN5YKgyELyy3IaI/fUFL0DkddyVnVnKv22PX5cY2u9jc0ZnZVhrfD94DxTzYk2mxo8jmltjhGR32IuH09h3685Xu8S2EJKGyax2bO1tPffhLI2Dw66lBUGVviZISzxE7UCftnRF2Aqub0KH+Y8Djiqtra3x5bs3sonW5XRE/k2YDhpQG6wANMfsAOpbKvHcX+y9crfn7Rs3BqoK/l8EV7XfpRROXRUyhi1536kmIMoKNLltztiklPCa9Gn9iLWHSLm3CgtdnOiZHf7LKIXUu9peaYTvBIz3KnLM/rYfbFEBPiUvHIZMR+Uolf99hogjr312zR7s4Iuum8cEOyPuaDmKjDW+xCJqnRbS2vmorSaUkouKU5CeaENllDj/0M+aDIIn8xxMuwTRYLzP/rz7ed7cvI3iZtVg0y9YUSm1hClI2AtZ42fmLkyqUdG5kYs9ur5wA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c929e72-229a-44ab-c38f-08db2025cf65
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:17.1144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6yRbmxsX0QgVRGI9wyD3ByMPiMyfpqrXlZZafwKGAvyARNViGLjKZTRoIamcp5Bikw/iOy3SpCTLneCaSN1lgTj0iBayivCDYpd2UPrDJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: xzRmNkSIUmisIo3d0Y7eDZ9Q4ZdF-fvB
X-Proofpoint-ORIG-GUID: xzRmNkSIUmisIo3d0Y7eDZ9Q4ZdF-fvB
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

