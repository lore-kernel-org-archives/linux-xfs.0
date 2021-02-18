Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9296C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B27764EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhBRSpe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35608 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGU1dr040639
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vuw0zBE/nJWm1btzXP1ms1VkVUUIPHiyYBmQbALBvEM=;
 b=ouB9SiwpMuhphRfrmzjhux2xK7fXx9SYlJxzLaBwW56I4iVHwclTjn/Ru08XjiPgCB1o
 G/Kos8tlnNRvkYlKlu45qtUtRsx/ljX2LOmDPQvPhJ8GVi+685oFvcTDF7+knxTlvRA/
 uok8F0ZbHRIpMiqwYmooMei6GnKP3DiRFBLpu/izq/hoQ2ZBSvEPBX3dEocr5hH623Vu
 Br6Fl4IIuU/7ycQtsq6Z1PUgSnALDCibeCh1acNN3tf4XtN7IRJ0znizNUPkLkeQ26Po
 a6EzsxMH8E4i5/QnGsrHQgjny/CSg8YU9Xp7lOWAwkWhUCcMQF7SHvtGS0/XTCcp1+fI 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCaB032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnU9K9b7ORlz3IKL2md1KdH2KnZWURnyY4R86bxqztem9UCaLt1RTW41y3918Aoh59EMp63NupmeQneWX6JtECYelmCgi/eRVKLPAvEIdpbQdrLuGmufLURCVgVofn7AyUb9fOJPRX8oKuptecAWKuhKaBpnefChgG7cGIzCqq8Uofbmq1q7m10fXIBG7Oow5MgSYKQyrdfiNXlVclUVaPBYdoBNJEFXMLxW9IeaZ/wlJB5EWTbicq18aTSTETzzjRso7jttjQxEzBeGBtRRsKJw5SCIfMY040i2+gmkkSv88vX5hzYDYD3ksgD2jYBdDGwAYRxOSBEzINqTnTx1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuw0zBE/nJWm1btzXP1ms1VkVUUIPHiyYBmQbALBvEM=;
 b=HQzUKkom7A3OQm6tHpktmzFrc1/m5DonNw4h2tpjp2vylY/ZfXKM/Rf9SDjTdP1Q9/pR1BLBkwSR5aY+RMGrdFr3avtCKvYguI/nDOjBbtlUDXNnvDW4YLKnSW+4xM3MKSNpqpWsohE2pTSnq8+RQROZiHW3PFCNytlUYMPFbZ3Wjcvo82fAA/yakDjl6ASawboWX7izT/XX4fvKTDV/oeNsqFyZDJ6+hqBuLfMUuomyLeB81S2s6lD5ZqyCLNQB+kH8GHfj5vGseRGFyqKlJQua1y+7oclRWTYHBysz6H9dlEEjXVGVlVdrIyUGLcP3stYFSRzDTrhnlqPlWEz1/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuw0zBE/nJWm1btzXP1ms1VkVUUIPHiyYBmQbALBvEM=;
 b=KHGLVNJHcF9BEGavNQrl0myX9h1zi5XSA9nhsxtka1b2jV3wjmEzi3wVGxyfr7jf03QLUt6zHsD+EI945ehcQHOzYBMmnEX2x3wq1UBbg1R67i8vqc+Gem5Pk3IajVfn/nlkW1M3BRXXgfFmJH6rYWe4QG5zuvHdbH26qoA5MvU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 13/37] xfsprogs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Thu, 18 Feb 2021 09:44:48 -0700
Message-Id: <20210218164512.4659-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cff7df8b-6334-4d42-51c1-08d8d42c9e0b
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB429058452E013E576AEBD00E95859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rgbI1nknmhGRbUCDUcbBNRUJc1WZuL3nhStMLThSvlTc9lIQR8b//F4XsLru23AcR1b6C0LtHkvEV0JiuI/SUPX/MYUPz97cLWYwprqlHiIVtXM3KyDE1XXCRihaq1saTbKV4S5D86+Gc3dd2PiTSAeI+6xYplIMeNyj2UdLLommbiDGgYGl6/3CK/dhFqiy9/YTLw818NnnbGKp7YyOGb3R/QgU2iSCGiqEB48yI1Dxb15+G8J+pMdEfTS1CEijlPorCeyR2f/slyCW0UcZzuv/ah6taSeoWL36Lf9FbiumYv25yaJAOBpk16HVAithThfDIYDNIl+n2/srKAzr0Kcen173YUnTmXs06znP3oPLycLAdkGkdKRipw0x+6C+H6SfWAKmi+qxZtKusEksPyH0gey6p7XZ4lW5XZ04GJhY+yAZUkEl4mG1WH2o698333dXhTiR5SV4PvoCM/DVDN5N4y/twHMSrT5QtYKi3TqLR3vju8jMofh/xFUC84xALLVVO8YmlNgGiMKf3AOAFQDYwCzxsIwZ0rXjKBsGDrbmTL0cEuIXCVmfNqrRNW8F7JZUf+MNKBl791MkORspYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ATtV+lxCfvB8+0cjEFYDcPXdq8rL4TXJhejIOzwFu/JAsqSjDhehJgDgBm7y?=
 =?us-ascii?Q?p5j6UtcqO2/G5DNsm6ALSOl9go34DthzMKvTF7aV3fiaM+F7wTbh8llZ60WE?=
 =?us-ascii?Q?a6xEMJeoSGlt7n9ATVPmIuLBw/wY5mm0jdlf/Aze4v+UXNgIG+QMLeJYg/LS?=
 =?us-ascii?Q?G8AsfzGl/mJqkpZdFYczPe6r6E9D2jMq0th0adfyXZiexXkeXF0ZjfAVSCk3?=
 =?us-ascii?Q?rH73FAVd+f1nmcse4b5grZrrbt6JCPOQE/KSzdwuhpZFVSZZhHiEEhj607No?=
 =?us-ascii?Q?B3xJaLAvRGTcGzRl8xg6JpznKCm6+OjIWFqRw7KjdkuzZRty+cAjxGls4M3c?=
 =?us-ascii?Q?elfYIwrcxx+yZTIIbmNYMatFC0QsCgnjDa0fwfutEhMtaLeAWFAsDDQEuJFY?=
 =?us-ascii?Q?EHhpFwQSXGf3zOOydgicaQm/yt/q+I0E1d8NPBPFY8ilzgyqjFVV9+UiDk44?=
 =?us-ascii?Q?jOGGr6Z66qBA1VzbH356eM3+COSe7JSYioPQsoWdU1mHwYG1anJNGyoUqVO9?=
 =?us-ascii?Q?/l6MWNz4suMAkz3pkTt8Skz4G1G3Heh74jTYeUP2Tc8Jrs4duBWLICqBzu9F?=
 =?us-ascii?Q?aRORfKjIVTjJ1ZVKdISzkXGkyCsRlYn4eVkLxXfrNl701+Rkz/atevwJD1st?=
 =?us-ascii?Q?ZFX52fZUbJkAiilo2qS7i/wANA6FFTwr5mZ1Y+RyglbaVkVO0GyOVBY0kzke?=
 =?us-ascii?Q?ywN+b8KPXbcWBnBOzka4Mtixqg3K8ESiFIJcwpsU2wi66vXQdRvN9n9pmhZH?=
 =?us-ascii?Q?rvpKEvrevvjmPzrB0f6Jalm2zgNo2XQOIEkdJ4lT5xHWE/MvsB41X/pMXgTG?=
 =?us-ascii?Q?Haw1dOAv/VpsnkKQdGSMgHq4Y5pT8aEcznwPY4jObGct3b2khPQz6OOwlpA/?=
 =?us-ascii?Q?eX4MUeDGSysINe618KaKCAmTLQGwLU7aaADVE0LvxM9+cbEa6LlJ02uYzM4G?=
 =?us-ascii?Q?iU6DQhcbPIYL3i2LzhutimxQKwCJugtmDOFVljLVpp2TdyWzLKVOSXqQvFN1?=
 =?us-ascii?Q?6gpv/jV45wkcPkq2vsk2sEMEN3/ckwxc+3Id8QYocrYA2tLsD5KxFfFdMr/y?=
 =?us-ascii?Q?1WW39XCcNFIzTv9FSkeD7RnftlHDlU7wWqq1vIAZeDcOhJs434mBD1A+8upO?=
 =?us-ascii?Q?BvimYptWm7pIjnm7v/Lj68I4qIUVWhojWiAjVVtlFikoCF5DUiGDtVghZ47U?=
 =?us-ascii?Q?CWbHz+W4G+SAj3fbch5qcqJxeqBD3UvyfSLuB6NYQTKRBbjGujRUD8uXu+Vo?=
 =?us-ascii?Q?w7AVxpa8XdQRr2aDjHubEVvFjbNnj80T0ecJxO0Ee2f0DpInyXY2bx0ljmhU?=
 =?us-ascii?Q?vx/txQ5byRhHOMvm/IGP1BMW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff7df8b-6334-4d42-51c1-08d8d42c9e0b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:36.9928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42x1EUHSiFNj7wnzWPN8s2kC47/uhFELVO2b50K15/aIf8xBtqnIPDlxKP66qxNyW7wo4KT49fUAJNXdsAbVUL8Z1sa56kpfJbg9W7tjXOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: aff4db57d510082f11194ca915d8101463c92d46

The check for verifying if the allocated extent is from an AG whose
index is greater than or equal to that of tp->t_firstblock is already
done a couple of statements earlier in the same function. Hence this

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e9c9f45..836e5a5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3692,7 +3692,6 @@ xfs_bmap_btalloc(
 		ap->blkno = args.fsbno;
 		if (ap->tp->t_firstblock == NULLFSBLOCK)
 			ap->tp->t_firstblock = args.fsbno;
-		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
 		/*
 		 * If the extent size hint is active, we tried to round the
-- 
2.7.4

