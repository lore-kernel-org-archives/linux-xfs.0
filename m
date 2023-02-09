Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9525AC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBIICe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBIICc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A181326867
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PjsN011365
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=l2LPlF+Pn17Z5N4hWYkbckj8AjPsKx6nZSIa/oLWK34=;
 b=xbsZXE0Np5/TEwNTmM++PRxEp903foYBlzt5o2Ig/8qWeHD1v2kHHHQ3nvKPPifsbWcp
 8VNtOYm0+8Wdw0Bv4OH/R6f6om078qKNinPKccuMftVibVuqVC3WcdnvMIxdzHzFFd18
 fr/iSRpIcq8QYuezIky/55MVevtXLtCa5/g0Cy44+//+acwHsEsE/eUo7IVjD1TNAm3e
 bZ2pKfrx3SJubkUcVBqOgKULCUBJmkQ0H/RPZlLlj1BEHpUVixKmFQBjmXeVxisWkC6F
 OfihJy7XukLpK2FzTmdp6nHOane6eTcwkjkkPcG4Lk/LBJSZzAx8bjDt3L+WipCsIDk9 pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1a76r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196KLvk021320
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dvja-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kk/KxjbChBf6e35QBlHqWPZLuj74St2FSSd5Qpd/KNRHkxaFNYSoGUdUlO7KMD5QcJ3qHwQPlNd2qSa1Th/e1nR2/bEXfLugmUpTabsjn+5yPEPJwxubsUzoMVR4J9cNRKQ6xWWvichNlmU+3HytqnKBLwaXf6vIa79qOsRrlUHyymLvaD0VeMso6LFgJT3oiHnZujohoKk4WLN6LwDTb7jeCPqm4d/VwX9pXaOv2j8Gaxm7zr0W1cC8dYiUanlsa7DkbmcRwqyYHureB33TwzrjlVYK5yjXFwnlZK8UMvkuXWpim8Xzh7Mj9+kEEyxrLBimRyJiRKBJSAf41z0YGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2LPlF+Pn17Z5N4hWYkbckj8AjPsKx6nZSIa/oLWK34=;
 b=GJeV3AmgqKHr3Jxy/uxDMgjHEcD21334aJFVkDv/h4AgNw19hyRPa6ehW6WEZP+uHzzvILdcsr8jf+6ZwI3xM7DoURHvg1k2H3TdcDfxzG4BtMi2Yfp5TBn0AkvhJCA1NnnmBfDBTTO9hDNAzVyrBS9jJK5jP85FjqPfkO29jRzuVCvA/ROIN6bIwQI1iEisoCQbie9t6GFePBY/oS69qX6ssPv+ORXRy+kEhP2lB4+0ZCMOhrXSetO9pq8QMnq2/QjNPCkTyp1Zy9A77BlMBUOX8e5ZvMS6ZSqs+MhNAHzEXQl2QJr2bAX3yCIVq/YVgKWiMUxosujuuNO7d5duLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2LPlF+Pn17Z5N4hWYkbckj8AjPsKx6nZSIa/oLWK34=;
 b=A5mCM+LCh6Z9/EQhom5B/5yL7YCdfkiuVrHyaXe2xQmRg03foSMiITrWvX4HoMBzFWetjc2ZoUz5sasaMzxH5YGbICIRlQ1Q6CJ27bdVuUAbsk5ymL2FDqzmKs/DCHOW0inwUn4H9U61b0wHsk3CN0N91z5smSqtCetVGmWPFTs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:24 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 19/28] xfs: Indent xfs_rename
Date:   Thu,  9 Feb 2023 01:01:37 -0700
Message-Id: <20230209080146.378973-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0042.namprd07.prod.outlook.com
 (2603:10b6:510:e::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 2178b6ef-3f23-4a54-a5fe-08db0a73fa76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dFPxOp+kMFS4nZLDznZW2v9t+pqDYH6s1ulnWM1wt/cTT3bDBHqzFOtaep9Q8UTE3KfsgnObIWkbf9lzCIjE/rxgMz3w5GiO94yOVHBKLiyIPEMg5m6bkb4U05MWYgkMmlR1bo81nRNAGgnpjZevlheMxPy+rva4oZS6dUNaEEyq0k9AjJqghN40RKr5N+Zx/A8RZK6DtgyNd0UW1pHuMALCbkxtQQ53CbIdh6Ks0b3UrsS27HyirdJuVxsSPJ6v4FP4PYRSKp5kvqQpANwZB51sJuhUKC/feZLCpttHHcZiMEtM5hyDgdWUiznO+1gqCjG2vf36HfmO7Pgw2kw7c5H6IJltnpdd6oUg/udOTiLuzvblfw6X4NY8eOuri28fmofyLMmc5jDgFsq1wWf8gQLfKiEd4hLFQZGBgnWXEoLLSpsUC+5o4PlYFmULp/lE9WceUnSKIlj5EmRt9XuFbKAgleWkw822A5nwIgDNiu4ll0ME9qmSyogXQgrzbG5bmpMvC2Itf8ulLCjdH+l4cc8GwCRBqSKpgD6k/kSg2HS15GSb/tzhxtQu6c1JCxf0Y8bRrt26wc5TWlnQT5HUFCni1LFK/1X3NimLLYiyEmVyfCx0loLF4JJSGZT8/XORPmMz58IIws2PWXmrzmOg4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N/uGeStHtsCyY7KymjAUYdeYDFsBrL+5JbTVB3hnQEOyJvGm/ODw2hVb0rSc?=
 =?us-ascii?Q?mfLGJqGdk+0cIPZvJTIeYVEXwsIFl0oHR6zHatwOIzOdiunZjqlbBMCXFQFS?=
 =?us-ascii?Q?3qUsWkk+oEZxgfc8vJn/ogI6W6GbKO28cVYKH5JTwDmJBXhkVupGLhLCDEdM?=
 =?us-ascii?Q?9W+5SrYyj6qbLARgguYA+JTl6OmoQ612LKyBS73cEbmJ1DljODcp1WQ3pxA6?=
 =?us-ascii?Q?5smLtyjLwEw7pWyp2XeUWNMG0o+oyRkrriXMbykS4ldMzLXY3v7ZVt6sud/5?=
 =?us-ascii?Q?dP9ITw7xjBtY8NEMYMWEBptd2zD1Ejo9L6LmH+TEc+LXYj4kiBe6RvSVjhF+?=
 =?us-ascii?Q?odc7fVOllsQ5xLTjg6aEX64KKTRJO9HDOtNOzN80rmDYxuTvBEV11++d61vv?=
 =?us-ascii?Q?4D2NLfJ/tPNsUMIZ0LpY8VjscUV/y4J/w4fy+ZnZ4SMf8NKSBFAZBSOaOeNG?=
 =?us-ascii?Q?e/0K1hEqxRNQ1Fax2LHo1NFnibm7xuaGEFSdU/+JGs2CgEfU0oIGLWi9Xx8+?=
 =?us-ascii?Q?bv2M9gijeEBarqJ7oexAdgD9s1SmULjI0CijK39AAphRSKvif9LCrHW4RBUl?=
 =?us-ascii?Q?KRNccMDtQhjHsyf0iiuTyZlio3MgwFPrGY+vqPDEtdmfZhgV1eIe7Rje5ZU5?=
 =?us-ascii?Q?BjHNf07xrV7kdozyKmjXXU3MLXcmtC+oLeR4zdTv4gpRTmkYumCeO7S5uAKC?=
 =?us-ascii?Q?iVoK2epG5DYuTts6HC1gwutTyu4+yo7aJah0XWrta+JbDPOL8XreEq8qMEHm?=
 =?us-ascii?Q?45iNPCnZMxw4XkAPKvLQUCT15/ONyYziosmi9lUfMY79OZDrzhSclidsvzsi?=
 =?us-ascii?Q?HCyWnUPbLOlDTxfqiqYQQfdD3iN1Q+s3EC7jc3JnqDp7bZ5gBx7hJAWRJugV?=
 =?us-ascii?Q?wjrQJHRMyEbtj7RTT+uSpYqqiAR+OdpO+xnmpRBQ1gH74g8xHBRDEriTdVXk?=
 =?us-ascii?Q?Zu/9F00JKSmuNlsh7STMi51GJ2OX6l8Gb5pLDSPSSMvPK5DY8aVg9OdIrPAk?=
 =?us-ascii?Q?EFBny81wkWocLBbLMmOxrerGuASg5NZFGYcW0pC0eh1pOQEyEyv/AsAsTn0O?=
 =?us-ascii?Q?K/UqpZKH1JL/iE8Uu3+Aa0Rqpr4txklHF1Mt5WmisPb1YiXOliTz5DBsQ+pA?=
 =?us-ascii?Q?OZ5qb9WgSnNaeYGON41043vrgZnR35QIDtQPqfLpJp92MKKIpqSk8ChzzLfd?=
 =?us-ascii?Q?IUb++PSoQ87n2hRzBx/DdKKhll+Rbq21QwwC8E97LfcZnxZ7eIUYO9ufdj77?=
 =?us-ascii?Q?SJPzGs7ruUJnzSMKPxQ8OTYMbKsJWOzjw1ua8V3GOui/NQ3l+g0APPNYApoH?=
 =?us-ascii?Q?utSy7RPy3SRRKoFRNNQbDakQ+dv6zdXqK3ozRfuMzo5jX0pyNh+jiESHYMVL?=
 =?us-ascii?Q?uUnw3H8ftyRp2eHohQF5UVKU6MmObu++QJJh11Jqe3Ifd/xJdkGHou00KWTj?=
 =?us-ascii?Q?Mq4vXwcBNmmba+luCCp+xKMUeKYsRsAlnHw61wVEWlFdB6iS2LparOjNA5fh?=
 =?us-ascii?Q?Kjh/MDbjaDcxpAj90afUCqXaVx7DFQzBgjvKthSnhVvHvzXuj8PuBVgf12Ju?=
 =?us-ascii?Q?MHa7ZOAqqJkHpHXIN3b7X6uGUG5ilWJV2VYgGVHtSW+w7Hf3xLmXas4560ZH?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1jSJCnrLoZpmD0sJkYMsuYaJMvToM7lYmadJ8TUvGKMmOUe8TCweQ3IADZ8P3wmfIJB4bwpDrsUHskGpdf1MrRU1YEIdxyPlwGyZZJnvHlTSpqGvNBKNokgpTem9BNrdRkier5nxa8qzoFtcbB3aaTL4di3E152ZLjgbGXhgH5pLdSTkNqicb66R5swCvyYOhpcM9Y71qnpETuF3M4nZZHFs68xQ+5vyjVI9VUOaIsl091NLEH8UUK6KTMjOFkccO8+kUnv+cQkqs220Tqgt2Bb/psql9ctagcy1e/J2ZEaOyMbJBFHSFkMO8Q3ovLr9qxti19Bgd+1s/vCs6B/9oEEtE246PaQ8DnN4m40Gl/ojdr6yDh5sKiFFm5JhCt4r7a/7fdI+nDQU/jxOjrlczfBKhSNNtX6ff4NvKoIawZL/ppmdZF5wyWZR9hZSMCqNxecO4Di7BDwFSK2jq41mpUDQQdcph7l9ppbTda9plMMxvi1IcxR+38u0OoGX4zphU0lZwkOfV4frXszAcBo0ZBEjUNjmbUO+Xr2rD13k6mlrIi9T0G/ghEMKKeH0MO0hCwc/UBoy4IdNtfEIcd4IL63iEddvK4NRC/ya+ILOhbpEEkHPJB8l2so5vtJxRqOtObgwsblwyLKxpg/iGtGnt3MdTjWrsTNpvAkYVA1+uXFvw08Gqn5i+TmdAOtcEvxXFgA3S4zHCNM/axixany8AvLPXGTpgEobL2IJrR0if3Na7h6E+S5pZDpBwxHWRkDi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2178b6ef-3f23-4a54-a5fe-08db0a73fa76
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:24.4528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXiIe9dn3jlyJKaXMVrmTICuKV+mipw/WBGhCA2zSn4YhBkPoKB1Ce4hRzAj9O7fkPIwsxcBsvS203ywlI5z9m2rMshuOPwsHEMEtu/swvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: fNWpt7UuBAO8cWstwDrEXH_ya0x2vmOD
X-Proofpoint-ORIG-GUID: fNWpt7UuBAO8cWstwDrEXH_ya0x2vmOD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Indent variables and parameters in xfs_rename in preparation for
parent pointer modifications.  White space only, no functional
changes.  This will make reviewing new code easier on reviewers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7b34ca2de569..2d8f225cb57d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2902,26 +2902,27 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct user_namespace	*mnt_userns,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
-{
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct user_namespace		*mnt_userns,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
+{
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;	/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory =
+						S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
-- 
2.25.1

