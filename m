Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A7FC4321E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiKGJDT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiKGJDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5EF15FC0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:15 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78uato012294
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=B2WfycBxt1J9clQm/24saA8kQkhQHjrLi/b6QVLuMGE=;
 b=MCYxvXQ2fky8u8ZsJN1I9OI1JAfnu/m7nqflxwKLZeI8jXXjy68dyr3bxQANaiRp8OXb
 rUmaXXwPaB82AxLsEkwVME5oKp6aAB5g3wwupYBw2eVBodxAZmZX8E43Dgepc7Q3bbiH
 OXb/ZLTkJw7LRL18zOJM+PNk62U+qeyN8bRnm9Gq3AM7J50tx8A02IqluBrtSxGjM2vJ
 v9NoO0PCfToM4JNZVMAzlR+bi3xABL6qzMsdMhyU5SMQ5aOxuQ6HW5mrahjiIvmtF8g+
 xWIRBcw5va2AOCWreWnS3YYrxGDoJaKlMvTNZa4V+uYHKRqmkBmMc9ekaPC+EflVEX/2 +A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfu7uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77Rer9040942
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:13 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcymafw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rtu7U6edNv8qqIBuNwwy1H2URqULHB26eNEHVEeZvMT21Yh68qTexfKdKUiQM9EsdNhLFXGrhLwVZAPh+kzMrrk3qhqkVEyIv22bhcB/WRZ+HR/37C869Kmpiwn/YKIz8uM+ueZhSo9QWnaaSTep66QWj4SWsiTD6mppZIxoi6dGDnjQLidPZbDhcYUNVtrXnVL4yw2AL/oBXWJ0dringOkjyGAdrCPpJ+5GuhsFyV+BS5kIM5XihEahcjtdXkm88glmgC57Nl0gp3/mFBUHh7CUhlmbqYXkeEAVvSrX5td2dH2kQvbCOcA5lkILmNtEURsVZow9c3snHFXx3+6Cfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2WfycBxt1J9clQm/24saA8kQkhQHjrLi/b6QVLuMGE=;
 b=mtNTx6236YxNd2fbEsH1K17jtsaaMN6e9qvCg7NCZozJwrpW64T8yEZnv5uD+/AFx1GRckRd9f/P/x79ZKf5teBORQ9pr2xcgUQsdcUWwH0pk2R/BJQTC54e7OZJpvDwhzSbSlXiKbiArhX8MQgjCx9hTJeBKaZSTuVofguZFiIYRvvaNYOzGARjigtf1PFxMujueErRcsWOJ37wz/98PGKZqAn8qI8SWG5RA8pRMSGepRnOKf+QbZ1OVGZVQEzsCgfv7oqf+TcpInaKL/9Q8JBKbm3HZ23V913jnBXXPnnKM14ZPsQztECFdtzkanICiX0QLR3O29sbVltybwXZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2WfycBxt1J9clQm/24saA8kQkhQHjrLi/b6QVLuMGE=;
 b=M71Lzwpvehh8H4yuQwHpiDWzu1OB0rcks5T3Tlhu3QVmtMwEACVPFLeQV5cVCh70mpYJWqyV13uodHvPXipZVygJhKMtLEONN7nbt4rBFuSd61adtdVbO1/G1HOmLDT+QWYIDvBRkzbkYeeu+y3kRHssNtiCzOunRdzllR4PSfg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:11 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 18/26] xfs: Indent xfs_rename
Date:   Mon,  7 Nov 2022 02:01:48 -0700
Message-Id: <20221107090156.299319-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0375.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ec52df-9260-459c-c949-08dac09ee5b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNY677+CJWueMgrBcwUO+7e+uVd+RvnOaMU1YM1BYA7ozXydQOpe5J9WFTstfecAg3SMYcd+TWDCORscmvm+LQuDWdCCByhpXJKJ5z1hk84FNrogeYAAEtmu0jg44KWYO9fyWCCWA/Ase/WVgXSImLZJlTO7xvUw536U2L7rtNdDXrYdjJAk41ee134CCo2pEvZOB4UkQACzYZV1APN0wAM2QLg47b6ph4us3Sua01djOuAkm/Gx1v0u+gLuQCePLdyExYIUmOPbzRM++ZEpI3IGX7Z3qJg0/pI6CRkvWbnvJrDVxQjMHnpFKfYLhza0bhimcTM0CAtemMQb90Ez0MBSpe+dTto0Lq5DFDUO2rwtan4x8kwkU2JnDeg5hIuzc77+wpNmh7I05kRqWOtyjJkMWw/VKXjZspfahbnq4/oyryUGRNBUqXZPrQGoqHNLseVrcdnsVhXpS6Wq3xOQtz19qtVej83ZJjfB/3u94DNnH9+/WkXhXB4nVkNumnRkPK8TJ7gx2yxIRzAsuUO6XHXUNCYykfTA/IJR97wkfb422hKi0MkCrijX/HKx90eaBE86J60dLJsh3SvD7bCdc7Q1YXimbl/cmHS9NBqCkgc5+i422IwTSyQpbGEQWoMtfvaYGrzhX20xRnKLfH5cdug3Vv886chNRTzUGxDlg/6cmTkJWtDkznuW4mp4ljaZlQqWyB1mBj7Db/LgmmHZ3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UzcUuayYBQnuKYls4yIOYwZpSj+Xw5DLjvERFsqhZ52WVShW1lGGqSwp24Ix?=
 =?us-ascii?Q?EJZJxN/9KFDB3utxsz3ULMZfYojqrL4VsYglTY6++FCTEoS2DEIeyMdzyQAY?=
 =?us-ascii?Q?JskkTvtedAyPQMoy8aBUp45zQRMn2RwXFvSvwNCIGVE2JQu5vQZBrc0D+ZS9?=
 =?us-ascii?Q?v7q1Lzylp+NOCXVX1P4UQtRQXF2tM7+ToZ8PdNUuBb2TU5WCCYu/KlpBNxMA?=
 =?us-ascii?Q?IlE7AjY0JBHaqUh8Rh99I1XTfe7OH8cuCH/jQHmiw1JPeu8/Dut54E4ZPf04?=
 =?us-ascii?Q?68CjDHi8PiSvht1LDNJJAC8sFd5kyiMm95ly6IpzHc6gYvYE9TzKB3HpoDr6?=
 =?us-ascii?Q?VrzhL8iE9FSfXIcTAWcmaJyogDNGkVcflYRxKAbZG6CNRwfhWccH0jgAJWLN?=
 =?us-ascii?Q?I2ipu3Hux0acUdlO6ouFEVp/8FP205JETWQnVgaPf2tYhELW+SlxXc8yiLE2?=
 =?us-ascii?Q?scnUvp7OnqWlnGne4Zk6eOs6UuOFif+n/FY9lTIgybpGqe4t693rYvK4CRmm?=
 =?us-ascii?Q?iAFN52gWU5oTOLk45sqyCjoG3xdcooMxZkYepcf7JLI/HufwaqELYBI3JrwH?=
 =?us-ascii?Q?9xd0zhpYCX0SrQsFb46pDZTWqZj67mSI6w6a48lyZN3sQ92oI3UJxZy15Hhy?=
 =?us-ascii?Q?UdQJhNq4KPqmJBTOUrCKWC8/DrWNyZ+4lNzMMnyl+wjio002ccf20fcbNDJu?=
 =?us-ascii?Q?vipAu9xvYyAn3U+xAbXUbe1PQMXbvvOUiIVHniiraC/8OsXtC1CA55eMonrV?=
 =?us-ascii?Q?57f+miTC7EgBPLBRdM0XNfTHMPPamVD3ygYpB4E/V2xXZbl3YLsJ9RdyIjMS?=
 =?us-ascii?Q?82lJr5G06ucmfkprsRHhbO11G/H02cfH9WdGI1pwlyu8/Loz+XDmbPdsURwz?=
 =?us-ascii?Q?nYFqvXcj7XvthsmBs/56LIGafrg40ulTvI5f2gexNiLqYLzNUhrAcp7jjhdR?=
 =?us-ascii?Q?a+UQ9RqnU/jbjOGKzNxZyUoR5XHXPJ2vMNDVPwrJWS34TooUrv0VbpM447oC?=
 =?us-ascii?Q?EwvuLn/V/gxIy4Nc+b56PAq1P/3mWVs19IXtNrA7d4ELr63U2tGzZ7uFdgvl?=
 =?us-ascii?Q?Ln6yd7g3l0dG52kEfPo0FCNuWEFP6FL2b9JwXroQY1uuG68df7ZuWZYP7Zjn?=
 =?us-ascii?Q?moJeRyLT3vUMngWmd83+zBtJj5bhCU3vt/oNqjZdnm5UeaS/PpmkGVdI7rxh?=
 =?us-ascii?Q?skjwf2cezgSUfrf3Tp8eomhSnJclJym7Pplv0XB8Ulk/uefWLPP/zqVUglm8?=
 =?us-ascii?Q?Gi4NdN3m1vBzIho978jHWNHkKmeuBzsfon6Sc3iqsMVoOFa394B9MTxKqJRN?=
 =?us-ascii?Q?e25X1v+zVUoDQtMbTnOg6YvYMrGl3HiPNgWmZzcDto6zQKEGzg/6s1n+I+An?=
 =?us-ascii?Q?kVLMdyiIIt7o1GebrkNG0iN/62omqm4VYi6pvxezdf+6m6UIf6iqzP5fXrhv?=
 =?us-ascii?Q?mxH93ifjrnMwa7UuxT5CeTZltPPDvI+D0wsTIN5cKQWgCcKFUoWpbXxHZl59?=
 =?us-ascii?Q?HTnlTqsgZZTvBKZSol285oUjP9bhh4lKia0flVZ2ywV8bkH1Z0o2I2Ea8KK9?=
 =?us-ascii?Q?tqIMiVFTKZetDHCwrbhW05J25yEacBYtv171k9Zp1fUsq2YqJ+3rYHkLrs4z?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ec52df-9260-459c-c949-08dac09ee5b0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:11.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ljmzlEGlcux67+/ZB5g8OkxD0R/OlSo+vX029LTVgGHCF85Qa8Az0H4q6pjGNLkhVls/UZaviQIEHS8rPHKkhST7KP5RJDxyPgpWMhFrQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-ORIG-GUID: 1hDC0Fy5OC7-srM2lyEyGWfZIiR-OaJP
X-Proofpoint-GUID: 1hDC0Fy5OC7-srM2lyEyGWfZIiR-OaJP
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
index f6be7779c9bc..22b1b25ad7f4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2897,26 +2897,27 @@ xfs_rename_alloc_whiteout(
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

