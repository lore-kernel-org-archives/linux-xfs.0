Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4BEC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiK2VOL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237109AbiK2VNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8095A2316D
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:23 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIhsG8013826
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=eE4b6kq5zU/hARIN4w2z/OyR+Vg6hX9YqpBO0eNRVaA=;
 b=iOpRrGEXRpvtNq39Va1DtK6QffZWMWf5ve9LIfJrFFhZaPOK2/O4YktoE77Wyeku/87f
 NZ0bmE3jEwY/MKXFHE1Dcj5QsR/obh8awr0pu/AV5vY5ITAe7YyQ7ViperWfrcvocAhN
 G045nPpofMXq+fgIfbHYq1aMqxhSGruzlHHOh1/JUFCBA+j3Ss0RBJdb/uyNZJHOo/yy
 t35uIHGoep/BaWpnEHgCD7hIRpo2O+j/VZU+L83eW0/Fwo2q5oWd49N/XTtDfA7GSK1w
 mEfw4JSXZbFD696Nf06uEIb1SKyEbw71tHKPGHP6iLJaxSxtC1OpN4vt4rNI+lHV+Ikd PA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt88bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKFuww019254
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398e6hg6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsJTSE2Z6rPvdo2RPeL/Y8/siwwVk72PxaAR7UEZbn1EjrtiaYTCPyeIiqBtX+74MJiNaswGNdv+P3RpbELN2PoOmTFDAFX9xGkcuYGLJrV9jBvoQ+BbnollRuY2m5FGZ2o3vaNb5/Jg88KHDDogbGjqeNZDQJ4hj/ooz/4xG+1pOuY+nzrPtNuoIkdUW8zXdKh8hdGrTFtJvAAZZncLjm8Mqt2GqbZqHXcMUoA7Ft9PfwOPrvL7knbtq9l+9uuFG7Ne5OHMUG+I8PnsWodVjS6oid91jAfH0L/s1QeOyZmLTNAqv6SA9d52gZcK7Lh/lslJ13ySMOv4B8j6j9THYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eE4b6kq5zU/hARIN4w2z/OyR+Vg6hX9YqpBO0eNRVaA=;
 b=aw/Y9/Ex/kH+VkmV302cXqDhbweJwTohZ74sGAO6Jh2VSlNtI7AUoDtyAQYBL2EUlduvjoLQcoURR+17X/twgqPjYteFFFo4RW3siIKwwzvwOFxNQtB9YgK/GbR3mWygJSq3+IHpPPR6DLiNeRIz782SFNjV4F5H5Si048qmwhIAUPTuy1G98Az4tr4/h02OncyI1O9FKjWoWQQui7Z93WubrPTRrcXn0BUhHi69wgl9QEkBDEDK7hBknclHErcFRQlHYQ1qy0JtcCIGA//Ah81zCN1QWSRNpeaRRn88YX1wxvcYRL3CqYJ6PUnqRTajVBwGMdQrg5o7U78ahkTgyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE4b6kq5zU/hARIN4w2z/OyR+Vg6hX9YqpBO0eNRVaA=;
 b=zJZeBXL09rztZQVR/gD5PdhJ7TX8yAc4ORpokGuF/QEyxEoSfzMMAwE/Vd/8fxg1TJYyeGaJ5iIldGTm0W9NDijM+TDOxAWbYvc9EufS7VfV6/sAHBjShCxoCN28kqlPdzRE9RacG0FI8vh9rH8xFCUU627BXHfspi2Nvz9J5o8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:14 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 19/27] xfs: Indent xfs_rename
Date:   Tue, 29 Nov 2022 14:12:34 -0700
Message-Id: <20221129211242.2689855-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: a649c06f-8b46-410c-cb82-08dad24e872a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zHWWFpZh5CzWJ2vcmN1z6i4wZU+JrpisHXB9FNPboCSXgT/E04a4bVUah7/xAk3K3u8h195Hz7yNE7xhU0PDl80SijcEiNaL2nwyoyMu7j0JJQRbLHIPs8uOG2bK3A/0ybdIkawEMT0aghWDsmvowr+DQYkae5lKo6z3aZU9gH4MslKPJTIPrRODfMDNf3M8pTpYxPfEcQsxWxhl1XrkL3Bjd7nnmtryJEQtIJxxlJWdn37SpWFUdgHHNaDc0r5Xm79x8n3vqm1+NaNmZYbw56wXFmtElzfv42NdILh4CmL/fev6DWLReSb/3YsolDFzfq9kCMBu81noqlWI278YjmnO1iMguFMzVlcqUPsdZDNxDh7Z1z14Jnn6vA4N3AvC0QwPwffkBkAJ/ikFHrXzk3gTtpKVgeuxCJnL1SnuOjtB+KlCukPUPHgtJr8AMtsIVXkU36swFIhOCjNjQVP2j2bhohq9J0e7PBdBP3sonE2bFdTPWMQ1AI5/hjXeEJcRLaHNsfgnb9w0YLfJg1+6sJRHKo1Tc4+wcFzz+FEi/2T+IvfNVqwFLJccsqnUcouu6WoPhoprlB2Jd4YpV817h+At4s7/FYafovrTFuKUo2v6A9km/6rzr+JmOHPhQpPC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iF0cGcG8DaG2qZshfBl+HhPivlZ32BFQx+7Cxr65dPvd2U9DdUqS44VcUPG6?=
 =?us-ascii?Q?Mzn4DsZcyFStLeVztjY0iRoj2tP8oUZqNxhh7FUavLX/bT0kPbYdcZTgeHfQ?=
 =?us-ascii?Q?/O+ad/51lJQwnflDy5ckhsyQjKhnVVZ60ixg0osrmhJnYcJtzGRt0uB/PmUp?=
 =?us-ascii?Q?PoJe95K80jETolylchC6uCGzMs2LfavptP1OC+mvFBvR9Qdt17bPkQRwv+3o?=
 =?us-ascii?Q?vS4erJ8E4l+vuioGGkEFDPR2mZkWDldevqDpl9AMAnsQ/Glr0ZxaoRt90Lsd?=
 =?us-ascii?Q?pzJoBtUtpamd4kE0IxumLOoV4qOlPOtqvD4ZZfnWS68IjMCtCLG8yWIjxe2+?=
 =?us-ascii?Q?yH4k1UtWJi2g4bx+eNV3wg3wKyWaUWjI10ABPFyvj0Hq5MONpFW/AvPGnmVE?=
 =?us-ascii?Q?Yw7zw/8Ug5o1c/mvF7EgkM/uuOVvgYAD6dyM2oBy5EAoUmRWno5fkRwzSmzx?=
 =?us-ascii?Q?Nme0Q+8W6A78gWE51HQYOgMi4zXVpn06un/70IpcEbqBFnfewH7L8dQ4wqST?=
 =?us-ascii?Q?yS2wXvrxtGT+7hYrRT9TQwAZDxOhL/pvKP5wABYdAmbzKbC7Xo8iFbBXVV2Q?=
 =?us-ascii?Q?SgPzeDZZaOQasxylMUFC4EyitdpzF4qbzl1mXaA7DUDdCP9RuGV+U/NbouI0?=
 =?us-ascii?Q?AYBMMxU3R640ubjgz9B/ojFPyTx1d4GZfrpMV4D4ole3/e0Xcct3QcELsaYO?=
 =?us-ascii?Q?6XhMt5mverASNBirAntsFPqsqgSIw5XDRxVY3l0EsrN/YMyKN6JO5IktA9v3?=
 =?us-ascii?Q?1H5BXhYXUUgtQ5hAIV9sM3zWmoFPcNrNXrLTvpv094AF5YBqtSDRgUDpHUGu?=
 =?us-ascii?Q?2gayaO04wfrsKCHYe658+qhFT0EJ5i4fzD2JNbMwCgfPQ58T/6KJWlNx6NAL?=
 =?us-ascii?Q?w98rPo1MxzYUwbpWBk3WsFd5dMP2CZ2Fst693pDNWxDxsr8nlT31NQ979XbS?=
 =?us-ascii?Q?hUvpBxAdqmC3smHUSb4lNq4kqtDuhP/6Fd0Amw1iHcULlcwtTIEQt+Asbxm7?=
 =?us-ascii?Q?DL3gDZBS7bl8wlg2B7LYw1Yo18MuvVIti/mTw6V0YWKntjtXvTbH2EZSgtmr?=
 =?us-ascii?Q?HZUSrseqe+D6t1A2L2dHPC3+qJYE+pVALbgMxGSmU9QbQ0i54H7nOe0I8BqN?=
 =?us-ascii?Q?jZ8lbmt6HDz7J/j32pfbnIl0roMop4PCPTAQIAlw7ypYG08t54D3huBi5VPy?=
 =?us-ascii?Q?j9r8WGB0uhGVdYETiQlX74nxB5z1gQ2JGyfoR9c7vuog0xsUof68qmAU3pFW?=
 =?us-ascii?Q?bDFFcCwS7y8j59rFEC/rg8+2h0l+9z9hQEntv39IjpfT5T3yoTXP38QiQCyG?=
 =?us-ascii?Q?yAQRim7NlKsk/HjtPfd2IEcc6I/brUMooPt2RlfzIOg3u0Qlmoyv6EwdiQti?=
 =?us-ascii?Q?2yfbGyMZXPGw0caP4b8+DcxtljvkDafIZBKXGDMJhu2k7Y1+8k3PdWxRmKoT?=
 =?us-ascii?Q?UieQpDin13AThnY0MWRWsG+fz0/JKFTcxVtqMbmv92E/yIb4oTyLARVOFYq6?=
 =?us-ascii?Q?pJiSwtoAVESmgNIlGlk09+nmXygUhQwsZ8UWxbegFvDcFVmlJaHOdMS10XBT?=
 =?us-ascii?Q?kzr9NAoFnl1Rwjv2vnw0H3lFw1F/NqKFxat83xWSOCVHosxBkmX5718t4ugb?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: amAF5g19U5poRjoK53U/StO3eHspkr7cWfteEZlRkaMibWsHDZBry44Q6/MkmQaVU+RieXMra08G8Ytb+oR9DK1KpMljng1gq/D6P5Fz+XwDdyuqjjwdtnYDBIgMT/SddgaseWeD3HgnNzps3YDDUyhM0rpnmHpRT6YXMxZHvdV1p5vu/SBLyctfc80/ChUJFs8szk6FDSAAx9NzzDAfLNUFkBt1OAGzuNvdoyIwE+TkrwtNVliuB4w1RJrJSLIfspKO0l1IZ55+pfWvNuH7Fzmodr0DVq5zT1D+0hQ3N4SmLpVFTrvs9vEGlaSCxEtMwp0wGLH1io1rI9UpSoB+iKVnXQ4VwWHqLD2wIhVsS/XSzhdWcvcpw2eCYIGwjBo677QposxcHaUVuMHT/aDEB17z3G/dRWfQkEc80byJa9UJ81EYQ4Tro8rJK+ZDyvIkVgzmbudky74L/z2PQZ6/SN5sG1jAFFWhY0DvE1Z+d+sz196PDRGkAjN4HbWlVDnPcNLzKt3boTkoQiThMMjqRdY3dqdSaJw6LepuJPsRUA4gdNK+vjda2dQZkx/U4fvv15c1v+HLYyfHRXovXgEAD58RZnIUPj3kQElctBPLuzUk9UPcY0utd95qift0JhAVPwXoHvWTjJGP0EX7d8pUXseeLFJoBPP+Pdg4yfFObh72ih+wJ63tbEqRJ0ohNC86F5eWObKXY+fcmcbnBjKbY/IlETT5xdL5WWV6zW6Aa8Hr7ZQ/fvr3GKAYQHLydYVhjGMwdbl22AsduoIvUNOEZw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a649c06f-8b46-410c-cb82-08dad24e872a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:14.4294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mN8aExksRc6q+8YZ0DwlQGWUrX4lGPFUYPha9IL73rNbwMDJJwkd/SLoXhpQ6ztUHB2IhbK7bYsh3t2oWHUBodmvNzyunonAAq0U8aE8ALo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: THdbMdwElxBRBaaD_RKNIobdkFxJnMcw
X-Proofpoint-GUID: THdbMdwElxBRBaaD_RKNIobdkFxJnMcw
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
index d98bb3da9e4e..069ce3b3b712 100644
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

