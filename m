Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E76C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiBXNFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiBXNFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7B9230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:40 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYJZI000928;
        Thu, 24 Feb 2022 13:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=4otLzcEuV3IkWz5tluNywVHQe8R545W0nuKIRN88xz4=;
 b=WVwfLHb09a8H9jcYKf7IuHfgHdc/scJwSe9wLijE5UL9q6+ZPykZ6+e9whZdS0m8LLSD
 lQi1r72NaY/LjIY56R2UKAI7ltt+E5Rmm7PCLzZY5S3QilpBzpfpcZ+qdxWBFoUDzwpX
 lv8k2tgTlVX0h/v/BnhYYCnmexF8np6sO0cdSDPlMz1DKNw6atEU1XdGAkFOhUIqCIw8
 Qw9gb1ygxU2Cuvjoib//ycMXbzLOXOWTtcQmVxnLaSXceG4TYCkYxgbeD1SRdaXVCeUy
 vTfczYiOOYluC9CfzBVaS34QmPfmDLCcV+FR+mkRiCec84nA/DQWgmPp3K9ELQZfKCTR cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqacg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1fEe039512;
        Thu, 24 Feb 2022 13:04:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3eannxdfe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lx+pHhSRjWGHS/ORmNJVSsCy9h3DShg8Bf0EGkR6+i+6gQe7a6bFRLQxFnB1rT/DXT7vd75vNwYcwPT96g569rLzItXy6K9ZXyTi2UxWdPFsqJHabGXQxzc3tEgK+FKbV8KFK3KQGhuZ46qluirSqTJa0zapJnbtndvSeAKBPl1+nThQdgVZ/UCyj0wxYzdzyVuNxDT1MUTMwbeFCQsdCxEoVc/Mkjd7w4HixL8pKxpVKV3l8wdrfcsITy6y0tg+hWhm9B+/sWnmk7vd9X3QL9fE6HQcSWG27ppcgyDvs4LE3FhQiUE1ZjEx5XftvxTzWugnjRlggnn0B1e0+zmoQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4otLzcEuV3IkWz5tluNywVHQe8R545W0nuKIRN88xz4=;
 b=Qz4tcActykUfKYq3zchI7mRFPs+qozk34biTDixEwOij3TIJi2finuRCx3uejzYs2U/we7kt1S/YKx2r+vhpdRBjmkJc82DPMP2OfvKjgVMgewebuIkpvDQPZOu77IdpS1gNZ5tdIN9GLIL3hkJY5reQLLHIjhOvIKj6B0DA2kkUH9M/z2MGwDiIgA9MFxKv1ZIkLbdPSm4CCBVmOsLQkxbdiCNsT6FRp/6v5V52jaItV4YPjqchDXHSCr9JzPZAWmUmW5lz2Xi6fP3qCoj8Lahij827iWxcHnLJYk2hNPgSpKIg7q3WWXj2Pbtj3ijEE9U9c44sXjy4XgMnIoGU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4otLzcEuV3IkWz5tluNywVHQe8R545W0nuKIRN88xz4=;
 b=PA+49pEYAAX1eqR879ubepCE2pfYr8zGshRnqUJIiuGNt4R6D+DI+fGWPKO6WsJwmzUWKk/medinvv5Cuz8msesjD9uFFOixzvghCrDbHDZENrpwLBMWS9aNQve8ni/hdEDXCbTtNsiNxORwi6DVVPKwop3nJ/yIwgEWW4JleFg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:04:34 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 15/19] xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Thu, 24 Feb 2022 18:33:36 +0530
Message-Id: <20220224130340.1349556-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d17c320e-22bd-4ec0-5359-08d9f79633db
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2172FC14BBB14ECD7DEBA7AAF63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEwuy2+SrSpAZ6V9wplW8uaXypY7RYgxNSitY/f8Wx6k+azq7IWU/jkMfBVcWBn3a4AnJZ81b0shOJDOpWnVD6whgY0OYXNWErVpHl9cNaIfjTPmxInNWSQ5+OtZXZcuoHHo7ruSKCGIsIEr9+HxcEkJF+CxMTuG9caUop5ypJXTZYY2UORRGaeti6wrqZp91qUk1dlOP1TFFu6TUx+rqqp4NKzKc24To+WtycmCbg6S11Gz/5ebZZBP4F0MpwQvU/OlgJeZTtFFWevvsMtGU2QX7c3pM6D+i1R7DPrAsA10X73Y6Ylty41A1I/jlIF9DSlM+whQ1bi9p41j8+7bpWNd3d/x1CoC/T6//zbT3odtGAuBG2eIEGvObv3NP3QvWYWEw3kJQ+fevV95bfJKF7Qr9mdxkm5VescM3J9kcdv+oV7NtQo6OPw6yU1HZpoB/+S5TqsdHYgfHBCrC7BfxEFegKLhdhsYfvnOitLlkhibB0jTDXKr31lqM2tGUmQzm+1EvvXQ6j+AKJ/2QuG2bBOIkkIzD//iz6hV+LDdQf1J0TAkiEZqg0OyBssj3tAmqVVcHbi6UEleXrPfaQ6ONcK8ceaCD/N/oGOjk+JBRLq10dBO47WSsR8wX6047zeajwNwcP2s4xHAvcsRk5psOS+w4Aq/7cBpSISwZMn2TbruXzg9+F9zW3jdHtlkB+UcWqyUC1tq7JtWeNhwaW2vog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(4744005)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wOIC35zzfvGPKVeHp5HG89sMZm+aVes2Nj7qne3OFZXAAjiWQBhQb8OJxmcW?=
 =?us-ascii?Q?iJf2VvRPTWphYi8ggbVX8VxDBKS7+8XtAb5pHh1q+e4DBKn9c1YMhhgJWUFD?=
 =?us-ascii?Q?P5F7xwT9ruARy7TusGVQOfIHAhIWn2UpefyEvUvX5MNJYPIPws7psZSl591x?=
 =?us-ascii?Q?eG0m8cg94OlFfoxLygXPqyVCdnD32lvKqYGUELXDbajloxxcptn9tXrAegWf?=
 =?us-ascii?Q?E11xSAqGhEDAF/R1Jz+GWHgT2tE50WH/xiqy+/5f8bcxGAes/DdGKzC8WpT/?=
 =?us-ascii?Q?1zg5s0QFV5xXIdCFcMFQVMX9VI+QC0bH+L/621vQ5rObEB7ZrEcOWvq6MR80?=
 =?us-ascii?Q?OVTLiTzTSM4EXKicVefHn3Tzfa81BbuuU6UWbrmb0O2MeNZ++GhuCoKVbWN9?=
 =?us-ascii?Q?ZggTw9ddRpDtjFAIuQDAY7lYKUkfkWA2nsOki4gXS7OPRf63zhPZMMZK3m1+?=
 =?us-ascii?Q?KesMMhemRRejem036q5CT1aAJaVHjqSTF0/6pSgKhCRB1IuYlg1B9kIt2kqB?=
 =?us-ascii?Q?Lo8qnYVOlpsSkVxGfADCAwzBjtJDPCG2flCcVUVocPr7XMyq7nYMQ/XGR2/7?=
 =?us-ascii?Q?MIC+jj+R4WgAdRchEKdLLfJACsbba3Hsp4ScTI+9e2CVWCsmRgoTAJqXPrU5?=
 =?us-ascii?Q?nQrlJXpG36eQOUMEr92pCOoAZoRwfl9/E/M72IkG+WCrGaUhK6blxa1gouNB?=
 =?us-ascii?Q?77a+pJ4ExhtRLiyZ4uu1YM8ujote+o+pyh6duNSLUIdUTxNH1zO0OQ5foOBI?=
 =?us-ascii?Q?g5XhpfJpsEvOUwq02qDBTtRj+QIcdB05qSjeYGvRbLuT6vZW0Wg1UWVIbaik?=
 =?us-ascii?Q?CALaJlM15GgR1Toihe5YasxgUbEH3vmwp6XIluC+6clswfFsyrXgQkGoIw2v?=
 =?us-ascii?Q?47BMncpFEORZIjhuj8EXstI0W2ttfSuavkcuqrzdxEV2yJlvzLmItAqc/js4?=
 =?us-ascii?Q?/eoabX3965QWjG6DcFmtmY6FEW/oE1cIsrHq+onGBLhvA+K9F/lKXyn11u38?=
 =?us-ascii?Q?G/BCS2QvMaYN0tyF/oC7BIjkALVB/QUFfKwIhL0r5qnHjAam3GmLcwXz8obj?=
 =?us-ascii?Q?OR7LDLEIvRDuhmcCrGfRlt42Z7KcneqB/AH1fOIHBOo12fyWeKwkbi2wUPnT?=
 =?us-ascii?Q?FInNUxzdOHUjnx6z38TMfQ8cUPylpdVVTwxhT5jcf7kjzmEpWayHDGrT23LB?=
 =?us-ascii?Q?tBs1oWOd4QV8paCI5AdT8Vl5fWC4+DxQsBhYWoWdgA0nHRLiqhu2QberibTa?=
 =?us-ascii?Q?dBrEfHCoy1AUVSeuOBIFriZlSCJiT3SU5bE7zNiGRfRo5rAt7T4iITO+PEsv?=
 =?us-ascii?Q?DhBwPSOJXmIlQCApertp5Svg0lJ1FpiZt5z6ePUjIVwWUxmj7pwPM0PyebSd?=
 =?us-ascii?Q?0IjCm/Z4Z29hC8z5wJTzv4dT5bk7bY6o3IzfvcoB+XUS1QX89RPt3DIOZzEy?=
 =?us-ascii?Q?wHQIhl/MHWV3p9S1wDQcnYFhP0ueBUcUCTA0bnHgudSd0MBQ7LSdtsQp3l5a?=
 =?us-ascii?Q?Z5oOy4zrMTe7ZzdK0ZHId7QwyW/EI5gvZdHvug5+/rFHfX/IlCjttH0BdIxS?=
 =?us-ascii?Q?gALV8SR2zM+ogRQr2im7l8Jmp+isfFpbJCj3jvcHXAZKsHI1GmbYhP3IIDc6?=
 =?us-ascii?Q?+UZk8yjXr/u4xt6kKGyZC44=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17c320e-22bd-4ec0-5359-08d9f79633db
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:33.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctnztlX4k/l2Tchxn1ejX88Sc+vvVoYHpVnIywz2FCYFmjJKApPi67gdscmGuO/i19tD3x69hinp1MtxXheQaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: 9JBDFzUAu-DMHlCnA4nj1XBycqRiTdl_
X-Proofpoint-ORIG-GUID: 9JBDFzUAu-DMHlCnA4nj1XBycqRiTdl_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 1a5b194d..76bd5181 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

