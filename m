Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168AEC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbiBXNDh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiBXNDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A314A22B96E
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:05 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYSSh023288;
        Thu, 24 Feb 2022 13:03:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xdRskXVGCVOaL3lxIr5p+PcbV+ng2c7t6kqV+9nSIgk=;
 b=XskrkoTwV4GFhNHcA5+wK69JqiwqTh0xj0WoJtS99dC9YOYivT0KlzRtjGxlQvTZu1+0
 lcsOmLz0DtRF+MyFzaNcTfhAb0EsIVGBiWI+O++jKKN6JL6IUZ+XsgTYz3l57SGShXc9
 ErHs5EU1uD3ygLTd37ztRu5nJqXnTjMySihptesMh9RTxyjFUax6N8JeE92jdZ5Pjntc
 GUp8L+3xLkAvRsPi0UGpkpiiBsVOe5hDPZlyLdxKAHmcXy0aFKbCmnubV+RdeAYXd/qR
 HCLhzsAYx+g5er4OYJKlCN9LBCHpKcKPrVDIT32hs5pUVgvM5UF+PwlUnHfyZIQWH/r0 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0t5w169429;
        Thu, 24 Feb 2022 13:03:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 3eat0qs2xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNnbOYq41oHPT63F/TFqYY0vvZ2yTnzPUMsLkGhjIBmM47zTW8sxOEdKwmJm9LWd3ZZxIgxUZoVsQR/FoI1gqzV/nc9rPRp2++/VKk+8gcAxD6/HcY50rIWmr9732ddfzIrqteEhNwy0JbgiY3y4th3Cb+mRFXKueg0GNRNjW2n5kZJ5Xe7HyY9oEjiXcKEVwzu3Z0JkmAr1bofzwMzYXfzcZBYNyg72LHyqhwZPYGiq5oRBJy3BpK+8ukWJAEMH5BHPelhTGu45Fd5RTFKNejS9w5uPbs2yUGmVXG16BjBUSYKmyjfABy5e9lwVDCWEmmKTnYYOwNGOVea0B2wJXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdRskXVGCVOaL3lxIr5p+PcbV+ng2c7t6kqV+9nSIgk=;
 b=KEsm8fst3QPOWy9V82UtIQsr2HbqhWqbDdxQJaT5qh7IZT6fq4hd+BT0kEBVTczVONgWb5fW6Xi0/D0htu67JlBwPt/sSSyo8W4ZZD62YF2Weu80oHmM0vs9RW/EhcFka/BeeoHz45P6Y5Mb2PJzteWKzu2S5rRae8grn03gmxDxm8wtbtwHSEpid59pS/Iwx0z3HFWEIOi9u/S8x0NiDGCWxasbVvpYFL+4VH0tvOhMucfgqcJkbELRzmIpu2foxv2T5gDO18U0qCnYhN/+Nei+9++RPar7IXT8gbQLrtLqhULgDjKvGyY7O24vjpFswMe+5Cxp0nQNU2Y6l3zhrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdRskXVGCVOaL3lxIr5p+PcbV+ng2c7t6kqV+9nSIgk=;
 b=odTo/ytvqZ7B8gkf79/g0VXxOJZYHLJxzie4hxqhbtYgDkZncOLn6Ad4YOy59DBZDTiPUBzWgMGmb8hm9dfZc4Vt+onsWsRKZC/HrgDkvyGaFp81o58JbycEChUDjQpbHZpr9EHXetPC3odxpueStXKoldm8wCBgMfQxp5YnWbg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:02:58 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, kernel test robot <lkp@intel.com>
Subject: [PATCH V6 10/17] xfs: Use xfs_rfsblock_t to count maximum blocks that can be used by BMBT
Date:   Thu, 24 Feb 2022 18:32:04 +0530
Message-Id: <20220224130211.1346088-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e138f471-7d79-4b1f-0fde-08d9f795facc
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2172BD24844499AAF1A9014CF63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/xN1R7+YQDY4s8Waz5buSd0VnuBSy9Tmmjb4pNHPy2U8jQbjkDs4NbF1DxLBoH9DlIscDiCVM6MZCRbEV/BtVr69pdpUBoq5r0SzC46QE73o24FbT0uEWOrXfE6O13aiCTXdOKWWk5rKbr9g3l79GkyGnjRnPokz1hMo0ZbIUGNVO3MxEFA2Ktb9IVHv9ULvZgHxIjsmFSYcqsz1xwKktp5zs7V2KcRrAGRUNvEp9CLbCZPmknZH7sM9HtPemUqh3/ewX9cueoex7M4dCiLEvC1ONiIhYZq/g69rFTpEzshTepVvGUFklpcWVCbzZrgyTenEmevEmZjkILtwjcsyb7p/faVdGkyveohbprAUGCqjXMxmOpBDvOueX0ReMSy73fF1/Nuug1Xy8EFtkQchMoGzQVELpI9cVWX4FDu00xYm/QrMS2P7TPAvtI/XNdFRw7sqYT1bkgTjUbfH2eRzxuoaki0kCU5NUSTpTz1wA2YP8St/wbxqEydlKSxpovJ9RDzPrJRT1qjL/Oiem5Sd9uceoJcTo7phEQ5gtyNTdsx3rSHMVI9T3WN4TwcuKMJrb1qPOVtXfiU7wYnlErBaUbRtvYLs4f3z2G/hZ7kR9+WqR+KRTpsuCLq2n6ZRjSj86ZsbZr1dKC+1+hEpJmPKI2tkVM4Jc9Xn0La7zFNpapuaaBR1/qrpNsEB3yb0yUeg1NAsWPSVgOwD226uI31oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(54906003)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6666004)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lam6GZHgqZv/UfrBFvDuocu0isHm7LdyyD97UxmPArZ2GON9GZ4kLHALx1c2?=
 =?us-ascii?Q?Ss7tvo/Hw3xe9JXTxSOgZan38P4l6wLPYpoBJAou5ngo0ka1Nqd13W9BLB5N?=
 =?us-ascii?Q?CzWfM2qzCIfe2Uc34xEqFUd1HTz83IG+DyTZVSZlIjRiMW+Kwb7KFox9YzqN?=
 =?us-ascii?Q?BUrKE9uOWrXzP7E+SaG/ZsPNlUykqNUAzehh0SmfYpbdwBadOWDNKR4FXhys?=
 =?us-ascii?Q?ohmyfxmrnXpYGoOjjn0iyOjoYYTnGZyOnJfgL4iMltDr1DhSGOMXZnnJOZ61?=
 =?us-ascii?Q?qKh9+t0XOH26y6/z4dTbTMn2QEr/1q9K2VKYdotQUlq2OuRoe6pcOtihtExa?=
 =?us-ascii?Q?MwW/BPjbwVBZ0A/OMoYBlTksf8f25TIKoXqxT4TJ/HxDJGtzINar6gdJHSYM?=
 =?us-ascii?Q?10zQZ5EO+xap53t/L/rj5qNvsYFWAuRWYVyhB6cjSSzJjFGo0ay5WKvkM3FS?=
 =?us-ascii?Q?jXz+gj/3w4hb70Hb7OMPEaN+h3HZtYjIEEoy6irxHJCFPSnjyyL1Y1UzCweA?=
 =?us-ascii?Q?yPdoK+HS6Jlh/OPxcFudQk2dKe05YjBkCYF0LoM/3tW7dZ/980BlNEQh1n4D?=
 =?us-ascii?Q?TLRSgWSsvqlYsOazQkaCtOcAtIe/+uWg3rlT1al7ceiCTCo/elhgkLS29PvI?=
 =?us-ascii?Q?+1RKaLyUcRb13IyFiqpvhk1j3pZ0DHzWMuLJP04o7aG1WRwQKb81dimlMNH9?=
 =?us-ascii?Q?mVkDdASDrir/79U92VkJ0SVgUj7hJjiZ2i05c3xUxcWzv2/HQq86amCR0y9S?=
 =?us-ascii?Q?Qv8Rk5R0lLSgeW2cp/HyfwtQMuoRS8gFdnbYuFxAFtb++5Af6F1JTe3lDbMh?=
 =?us-ascii?Q?OuxqceRF4+8IqjiV9l7Ij/5dT3MDTo9/KEtsPuNQfEqBJ1SrGKqiIusvI3Bu?=
 =?us-ascii?Q?eGaVGhbx3a4SwostGeIyJCvqQIO1quhyB8bdSJTRxNsGsqu8GDYca9stGL2F?=
 =?us-ascii?Q?zVRcjfqq5Uhy4HqWPe3g5+5KN6o9WmPy8rCJ9Yat2xyzjTwJAPtaMZT1MqzN?=
 =?us-ascii?Q?TpRrZ7INpCBDh8p8cd2hQrxIC+CjFVRA3oa9oi7RqoAEE524i+HkVl0IqOhP?=
 =?us-ascii?Q?DrhCaVtOIn5VwStNVqOQhgkijVnYPxo0ZjwSv5RZ4KZohJSHgOrw4ypM7cEO?=
 =?us-ascii?Q?qu43StKhFS2JCkAAV5oB34fsNCqlpbmAr3Vkz7JLByxtWwNQyYj6GYTmJ6N3?=
 =?us-ascii?Q?Frt1+jKQZTr0r+HU+4BkJuPq+yg59RlpSk8NWN92pr9zyoTt0wZCnhGzEuff?=
 =?us-ascii?Q?h4CTcFwvfKTzdKwZEZn3vbJslYHV8CZ+2gxPTzO05CvsBKNjY0VaaxeHwOab?=
 =?us-ascii?Q?Cm+SYeZ02TGlUC+/D94lVNGybvuympJBTjODMf4HIURX4EK0qsn5CILa0mZs?=
 =?us-ascii?Q?V4U3cVz3V0ZhATmA4daU8w6xCLI07WM+NAt5IOFp2sZ1azUlVFC0R02bREBX?=
 =?us-ascii?Q?TSQqnMDvDZUGFOOu+f4eeOokjb1jVbcOJgtsrJB4SA0XRC6E+o1YLLrNMgJI?=
 =?us-ascii?Q?0dvlk46+lTs/wdxVwsWSx8yjXnTHgrD7YU8gVVBD9ojO9Zy7GM78/frw+iQR?=
 =?us-ascii?Q?Xck0hIIURoNQ6svcvFdOdMEcRpG6fhjZplB4faPmR9Red0Pd6tsohg7vaSQg?=
 =?us-ascii?Q?NL0PjXM9op3OHtU/qfTKG9U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e138f471-7d79-4b1f-0fde-08d9f795facc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:58.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrLRZ2TWGhZB8TJo61zaUCOM0BZKdQavzdtNYePFQurBe7tQq83jAppc93+IcFg6PM2kzKhvfUV+xdgwcgenHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=981 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: IW6xLBslwmNJZwpzT3tkkEco4JHk7k9j
X-Proofpoint-ORIG-GUID: IW6xLBslwmNJZwpzT3tkkEco4JHk7k9j
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9df98339a43a..a01d9a9225ae 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -53,8 +53,8 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

