Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D74C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiKJVTq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKJVTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:19:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC431ECC
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:19:44 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALHxw5004036
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=7NQ+nQvI6fMBSndorOhJwEiohmi4lRJ9962G6AKpj+o=;
 b=tlf/nyzN1DlVfuKd4nzMtKg6y2XdvSFtE3eyvS1G1gSnq+ZYpdUgO5sf/eu7eByPsS3P
 hFQBjf2caPjnDuNLS2AtqUKJtUtoI2piaBHFASfTc8IsyTa8aRmNTAQltFb9rS6uYBqG
 oJ8Ae53vMPSsNDm4/FdrgHKWo8fye7WkgCeLlwue7EoaWCcSObsf35RTQwSlHITMwuet
 IpJ6/7c9c1crLGKO4dMp4RPy7S/SGQaFwdnnu00vkLujvVlRSoyCNWiyuzsieuIUVMlg
 6A7eFKeTB+rBu3aQcgPHl6tqhj8cvCsh8QrnVNRI6JH/nPKUwGYOBnJU+yJfwPvG3uzm 1w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks935r0ea-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:19:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKjfPk009709
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5hauy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqQjgBM6qQIGVre/uJmTMsPs2kMOGVAqzvQ9P1s563Lw2hO06+rR+hYscc3P3luYMa1bTjyENN2R3+3Pm7c3M4FzeVNJzlbJqhbsuvoRNtoyYgaqBO9iyTxUHO5T3BJyaORk1jhuutWZK4E4O50qphcpQ4Xmx63Ylt830i9El43LaNGxor612JxnqJXXSWluF/2X92GIZYf9Zt4gc5tHqw106Ei8J+6tXHzKN2B1wPMhja8km2BEjmO3WVLQrrU2A6itt1s6Pxu++b7RiymPKcedsLzjPpJEGiabSOgdsR6uQGBBxxd4YYdAM6oRqMQrjDtgMwRn15nIdlhiBAnqUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NQ+nQvI6fMBSndorOhJwEiohmi4lRJ9962G6AKpj+o=;
 b=DfJ0Uwha8Di4Lyce2UDj6w+AAQjPB/IZpk4C94HSAoO8c058uwmDNTLKGIM5lgmNeTKWDgmVHdI2MYyuCvHCTE7Kxq+QPm0ZQR8sa3dJkXNAtvq6vcOnjzVtiaMrBXhwD5rXJ7QMueq8fPrG2LrJdTANpLcpoRDoQ6rTscMhOGVvDGo6V15x1rUuMoQPLy7ncA0khCkYMsWuroORlnFePLL+EfaNEJIFAK6n8B6cfcslrQNMFOEqf7SZx4I3r+N8jv8abiiFhEgirPCGmdDWZqFdsGVgfKEpLoVblYU8QyCV8RiOexOI0Ut+Uor8LGbwUUBj23bARw+pkieGLhgQIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NQ+nQvI6fMBSndorOhJwEiohmi4lRJ9962G6AKpj+o=;
 b=XxqYUj2qmskRXhwtjfS6VExzL+rHLb1KOKOZCRvDuR3fjCg/q7O2ZuNYOpc3HnCuOyLOZxokP19ajV4bCmo246539dSpNuNcibVvmMT5F4zWXijjG0zqeIgYDNyasQVbuYxd7/lC+GhDtuA8COdP3zeAdx3hIDSrFmBMu5r096U=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:39 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 07/25] xfsprogs: add parent pointer support to attribute code
Date:   Thu, 10 Nov 2022 14:05:09 -0700
Message-Id: <20221110210527.56628-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:a03:255::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a0efb7b-78d6-49c7-8a90-08dac35f521a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSnkaRTSPsJjVol9eJbh0knWuh/z2Azns+P7j9/VpcMGSnaoAF+HNHm21C000XD43/0tfDVoLROWvcHPhYFAnqTRitTDeFwuoer8ztswQnfLqGz3As2kubyxu6nccEoslpz6TpEjcEz2aqO9X4swWHhVue4CR78U2pd1ROUVshkPqqxv9tqW2I0pr4GBoeQuI6hmcBRsdSw1Jpu6Nso1lT8t4klIrvIqGCjjacSGHz0ngnHngNP9BaxVD+YkPdegx3E+dNVb96dA7Ld0iScsw1k7iz8MxC1Q3dJUcIeppUnza5F6J4ovJK2IbfAiNiFYccRa/TU3HNMZ6eF7XzE+Ul9NRBaGiOiYK4ESNWvOTORK7o9K0Bi1d6TWwup48FCw31rVwiU3FM+a5n2uSutTDuB+/7mKEB8i+EhUC3X+52P4wFBOQbAuqEwDdOvgCbIX+C50MYiXPxHD1DieQ/LslMYfjoTQ+pYk5i94yyLDjQwKDKnPX3Pz6a7ap/8u9qqwwi+VsQ2h1t/g1Vkr5nXUoKRd1YEgb6KNiHhWSrcYNqC8HW0VYfAPHzCHeKTW+zOJ6z6blmtFJUDSBpvc0SSvutbMMrI5JfhRwfU5n8gRosqau8Spgvxc5fJPleBWgSoTixIAHrrrFcfmrURCQGOk+95fvvu5dw1PEZ/USR2vOuQ8g4y31cVQJtfcfFz0sTFSrC3cElt1aKfWovY0nT6Skw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oe1RTrT9oEq3nGEvlgGTwGxJA1Cs0O4JbTWbI9VrmO2Q0TXT5pAwxjZXkI78?=
 =?us-ascii?Q?TQDOIvKKXP5/rWvlssbWn3dJmrA4sSQ0iNima35HSNJJEyv2oETcktdpJrmP?=
 =?us-ascii?Q?M5SFDA5fEP5OT1emK/VMc9DgLRVjTMmGc5BTC+6L1FX3/iC4v+UUL3+LMljQ?=
 =?us-ascii?Q?y9Q8VSKv4R5vJ3jDeSBgk67zqnp53hVbzVw9hGEOQnHd0pI1fDatP/+AJxh0?=
 =?us-ascii?Q?Nx9lhFFWYF7s5vjkhc0pLhttUrwwLhvrrT+9+ACJojy67iFjse9xtkj++/s+?=
 =?us-ascii?Q?+54CqiIpJRV0iwbeRwllqrsX7OpItLzhkGN8cnFgI21XqlIxpySKS9bqjLjG?=
 =?us-ascii?Q?sz9gbtG5PdErMO5/4m4P3MUJB8XQiM7lYBpvxDY3FVH2IuRZ6NCbenXGk4PX?=
 =?us-ascii?Q?PN+WCOBl8QtJg1BCxE5RQLZaxPrPJC93KenAdQMOR1WsJPVI2WkVRsLTC4Ga?=
 =?us-ascii?Q?qYzM91cwwgMFT+ULXHsTHlY5yxqklyZKcJRJnqjWsjpAeufhZRTg2vs20Ziw?=
 =?us-ascii?Q?ldcpQIldoAKlFS7HEtCZeZhJ268Ipa3FwEL2RceB2EazgG0RPIdsbyy8Ocyv?=
 =?us-ascii?Q?X2ms3lda6Lv8gWcnapn4aizt2OOgC7to/Bjmif8mY0rtW6YAbLkG1/BKb2TH?=
 =?us-ascii?Q?i4ThBAC6AA8gdMzflZFzhL1eA75AeJNXAFo+/YdA/IanR5/YUEoWjyL8fuAd?=
 =?us-ascii?Q?4KZfFled8zfenhWCmoRuFd6TK1guKwckxkb4WWLXwmKxFGRYjPOLIQY/QeT8?=
 =?us-ascii?Q?1oEv0lK3fKRwNm2I+2MdEeMpgtSI98gtdgDFU6fgtu/eFVjvDSN9qdUodP5j?=
 =?us-ascii?Q?XZTZMMwvyFT/Ag4gH+VAP6oLpqCj7wExhJ4GeVjhuq4Er3IN8EUe1BkwUj0e?=
 =?us-ascii?Q?hpfoG+E58w5W6Zr/hJSpiwI4qH4FjyAv7fbR7BpePc00ALgJkdaTYbkob/kk?=
 =?us-ascii?Q?5qMOlr3kZJt/uPZLJ2CIR9RKlDznZ58AcOJza8JfHViq2ZXGVdWtQB8kj4VQ?=
 =?us-ascii?Q?YJfhJhmJiGTsF3JtJacAWFinutP74wFonhGqVksYoRv/9ZPyZl6/K99SdGWB?=
 =?us-ascii?Q?2xgBxq7CEXp39A3Tc5Rwb2WvoMKI7l7e1VAVbY1Jea3lE+rzH8Iee0qCDhwX?=
 =?us-ascii?Q?mosXkY7y6aHNyxWhGTxQo4up7Afp3hn7ALPMh07rNlhY/VoQABEvQUsfsuD+?=
 =?us-ascii?Q?OFs3F8zCCLNGg0E09iQsaaeCfsVsZkR56syqXLR9m6Semkhnh1c0gSnH1qry?=
 =?us-ascii?Q?4WNHQHmmw337ldmoBQn8+H7CCwXHNd+NkP2YdFLNBlnqGAC+JdqhbGA40r2+?=
 =?us-ascii?Q?GQRkAuWxAJk6oVKUkvRu1y57aaugIUzy+5BvQYTcoIB/C6+woOZG5CqYfQqz?=
 =?us-ascii?Q?cfBseWrzG+8PXulVbrRQQIKOhqmnBO0nUxwm98D7VlQ3wBiA5VHlMxI9HTlV?=
 =?us-ascii?Q?wSbFpyUmDt0hyLfKgNqOtZxLzczQlQh8CkpNkhVIAFNeL903mR+LK8Duiqc8?=
 =?us-ascii?Q?mIJ5ngLjKNmzRQyKCQebYydzhWli5qgnipwAkhkalueaT2RqWoabgiWk27jd?=
 =?us-ascii?Q?FCXo6vB18H5IZaz+tu5tbq1HQSCSxXneCzqaqgpDPXctTatgozzRbv4+ux26?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0efb7b-78d6-49c7-8a90-08dac35f521a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:39.4220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8Rrf52YgD9KJV8sJcVq/MNx4BGzFuCDGSuSZHyDFWdowwG6uf8ILUNE/s8+mvsUEBZAcKgTFc0G9NsIEaF4xp02Nl1t7RUeYZ1ACrGM5ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: WaUtaEwohGK57t8IHYPeReZord_gnrZo
X-Proofpoint-ORIG-GUID: WaUtaEwohGK57t8IHYPeReZord_gnrZo
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
 libxfs/xfs_attr.c       | 4 +++-
 libxfs/xfs_da_format.h  | 5 ++++-
 libxfs/xfs_log_format.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2f6192861923..04f8e349bcbc 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -974,11 +974,13 @@ xfs_attr_set(
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
 
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 25e2841084e1..0201d64b1f82 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
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
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 62f40e6353c2..57814057934d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -919,6 +919,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
-- 
2.25.1

