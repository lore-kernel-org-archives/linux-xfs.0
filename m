Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32833C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiK2VNn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiK2VNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDF72DAAE
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:01 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIiEpj013743
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=sHqgj9aeBnTDynS3BpSzaNf8TVr8XUBbBEnZ/Ijoqsg=;
 b=S9poDCoiT91FZpijshK3E2YR896lyFTN4oMxLZs/0JoXgoYDikkuecpbnZau+KjezURJ
 xqDhQAvlaLNYFwCV/2xySW1yjgSy6V7vT72JoSG4q/sD9TDBvfbjt1rqjkNmLHZlz7ro
 cF0fO/l1+rP4olaUfPUaUNRG6+NNr5Tixusx5Rps2r7S5nd/9uwzXbf0Z6wZl9fjlUNV
 YR5L/BtzCvpKCPDlNO5+wNwwb/XXtCEIkxX+z+RAcsP1mMS2elCpdn4GWOFL2psW7tsN
 eTu6VVCozhwkgbhMmJ3qyUYHHr2DgdHn6MfV0bxD+mWgFiRA/tubAwuPDPaVxDkq2f+9 cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt88a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKTJAx027964
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987w8nt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ol1gCUbWnH1LNPs26e91ycI11KbhGopQPwIRWxxotaKH2vuuS1FMyf2lzXL4L/TqOZmIWoJApZYCVor0c8pD6LzjzZ8DZJ8URX2LRlv1XLwy1ZpVnMDjszdfyiZhleEDwiNHv4oK/gu1Kz8wk1Tuen3Q+XnyeEblgemn8f+jD5mUL9yyB2IUv/20OEa9q8rhpv2sYwJIi7+1zk32mF026QHd/Wowih31S77fussRoqTfUJBHioDLsTVAdcMPfhKwqly7dn5CUd9ba3tjm8qSovHdgX5gyrbYZIP0oTwiHxWWbFGEfATqMj1IccgXDOyPuW6/Ju01YOT/e3pme7KZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHqgj9aeBnTDynS3BpSzaNf8TVr8XUBbBEnZ/Ijoqsg=;
 b=XtwOygLb9bP97G5m1JCexPt30h7K9Ll5A4n7dkmuyNKm7WVfBp8rUSc8S+q9CLpdWSvEXT0Ic4Tz2ptlFA96bxP+BYRiNbqyOqdEWuMSb9QvVYiYbxKdZysDwC3UKlI41Qs8ZRlabOqcMzS/MpzhEKg7QPF1Eke4gsmYkZXnZfPOla0C8bGReXORZ+Jd+5btZW2VRIU9RoAB3cc5ZpPfVsZ1O4ZIiY926WKlogbqZn9Gc3dwkH39eWxThtHxshTUT+uKXBFM57iTzwahhHo9nh2AnEVXTE875RvVfI/k/2568qgYP+IC/SktjpvKTcqtD7rVWxIwqZgT8v+XwFZvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHqgj9aeBnTDynS3BpSzaNf8TVr8XUBbBEnZ/Ijoqsg=;
 b=kmDuhJFeVuPTklrLvz8ROacxVxOcw9c9I3yX/XsYywk+WO6mw19VE3kYLGBAQLXHhIYexVGkXM0F+5iQOKWBnZ/1We9fEcKsTJ8OSTgbVt4VgfRUzZw7t+cpofDnUkwe0qlOCHch+MXARKIPj8NxTtVcW1t/zRxZK15edCq0vwo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:12:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:54 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 06/27] xfs: Hold inode locks in xfs_rename
Date:   Tue, 29 Nov 2022 14:12:21 -0700
Message-Id: <20221129211242.2689855-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:510:174::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 490091c5-b5d8-4b81-e8f5-08dad24e7b1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BwjwxSCn9kWR7oWuIt1jEbE18geeQPu+cjVO4XPSAJV4Nv+03fOseKEEHCPuEzDyrRFEaj8JIvNIA2kzxFODV2yfIhuNfuuSHhRcof2xcuzKlaJWVoy0s8E2tBZyiezbD6uZY4UN9N6tYuO1ww6rHVD43OQlKdpTIHGBND2V2rdMzFhEw2x2z2FmTvWku5gDx1YBeDBpTXhV0JV0yWcHF0kpJjX/Ubgn/qxiHPm+dKpIUDn1/AeAw50JgpNWxE7h/AmQaD2gY/hGIEnmGaoosmDXkm2mqiSMLZCMZwZZOsKUk08HUlIF90QPjAexrXbzANPeY1gZokUi7La9CWvP4kZDGSCr0bbUoh1DCCMbpnV0H3JPMrxx/gqB+O926DwTVQNWfFImbG8TU3jp5CID8TVQI/fdL2VguvNDcCiqbvjIyt0EhItW1MN/7iJKtcJXGd/DpP2d+S1zxo9fV6fQLSNDoXe0g7KFcQ1tzHYHqpeffqlWCjv3GgYfEll4l9Mr/C55cJyRXzLEsVHweweG7La8cHDGMd5uYKyM5kY/i0SXlFeE2FUAAF0CPhMHiVBxf8EqyWEMaG0CEH6YyYK6QBmm35YzilmwejxatKUBhCTy0wZfTrkGzrjdeClvCTSI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mlv54LWLw5jLk0Q9wgc2JM43XqqQXXWByJ++SZhAndJqto26Qhs3IVaUE4di?=
 =?us-ascii?Q?Wc1jLn1x+T+ryggKCLOyNeLi49SSLJ8n1oaNiBSBf7pSaLMvOfcd+S3SIdkg?=
 =?us-ascii?Q?QhFrzdwlN2xK9U9Hlx75N7+ct5TeDjYffFbXhhaBukCqABH6QghCza0n16gG?=
 =?us-ascii?Q?Gb0cR8ArwM3Hr6DO/R1xU7AQjqfQJgkc1xPNON3n9bMmoibJYrhX0y4XtXIs?=
 =?us-ascii?Q?v7qrksw9MDmqno0KCHz4NEhTbWvPMvTVDUFLGRO2FSL3B72KXmKXspgcsC19?=
 =?us-ascii?Q?4tUer4bj8TpNuzxX5f5aeUNvv2cciZ/fv5GyTaGXM9IDyda0R+uEb9cM/+gt?=
 =?us-ascii?Q?hS6Q2fHhJTT2QU0yDBp+R56RFRyx/K52nCJ4nfSDCEOkRgfMXycn7OAGw0HB?=
 =?us-ascii?Q?jeUH+65HcB3f0uv90U4iTqUR+pGmxvyp1VFwc8INdKihDlZ+wZ2jw4Bb63QT?=
 =?us-ascii?Q?bf6LSjkzWMn/sj6tDx5dnCgnCF9xVzXdlYqbBT5QUw897L6fBTNiHEjY/b8K?=
 =?us-ascii?Q?5l8+xOG0wCLmRHj/SxwFqNCv2OoJFI3+CZ15E3NqveoBbYyf2DiSfu2igIMd?=
 =?us-ascii?Q?65SwiF8+n0WNZR1KomhODfa1y28M1E+YaJ8+E3glp9sWwfdTbB3GI+26CJwl?=
 =?us-ascii?Q?Q2YzLxhPH7b3YFBjCZbXTVxAtX/kRmnBuEtA4o0FIGlSmVAiNW/mYfxo70Ha?=
 =?us-ascii?Q?C3wZ35dRZkiDdmBojH1DF73ugcAZ7eDgx8pTUVrjSdN6gxVNKcqbY1pm5Pwo?=
 =?us-ascii?Q?ZrY/07HOWzsniLTglaqqKKCy+AQrDOcHv+UiJqCLuRFO4Mw81iLaU5WEBmlS?=
 =?us-ascii?Q?f87yD306a83Qc8qc2TewivEMPacEokSuzUyf0VRzGklcag/CXJUVnjgoFbQ3?=
 =?us-ascii?Q?H7GNyn9Z0BwgaI1aKX045C3eGMvmJqaab8T4heKJ2rshEPPoQ67K8W3+j/CN?=
 =?us-ascii?Q?JdOOlnDYFFG+AI9XhmVvoYKz8NguwdyDNjA/HN+RUPMAtYIeAiXHGIgwE3L6?=
 =?us-ascii?Q?SQEWYkW90j5bAY9cJi2euQLLgS7l3QKltNYrTEQ6kMk8Y2oT8j4F9/73vJoa?=
 =?us-ascii?Q?s+ajDiR8NlBA3SsGBxoRC8JroPNNIt/w/BayxkHK/a5eAoL8NL9MJMldKa+K?=
 =?us-ascii?Q?3leLVo3QAokfu9SW8CNVTv/2FE6Uy2qrhys+Ao78vIsjiFbxFOVz3badBccX?=
 =?us-ascii?Q?KQzTfFPBqJlkUoVC38sYQcPrEURAdKMTMl5Pw8pcv/d9gOvlABcaCuamylYB?=
 =?us-ascii?Q?CGNbRMd6EDCJ38p0cQTreN5AGPOAiyvQ+kyo3rz7+kK1BmLN5rvOt1b2+HMA?=
 =?us-ascii?Q?Ay1eOW9sPvLueMcvty9KefQgWU7Z3Jml/5sLDEFUwIxh+bCfb6nQ1wtzXCOs?=
 =?us-ascii?Q?6sV6ki3KkxFsGVf76Cfd+we3LhVEc2cAqgde536yTQurnZ9sH9ExluE0clSb?=
 =?us-ascii?Q?OMKztbfFuj5ab2qQP+4SDUrzN+FOAhEgrbEfZBd8FNwoEZjNysc3A64Uiqcg?=
 =?us-ascii?Q?e+YOyaB8J3C+f4WtqfcXGv4FPCzwux49nvck2kIaFLZWImX1LT5zKGvwLdp2?=
 =?us-ascii?Q?pBviT+cuuRvSb8Vnmbdstb+u6+KbxTkfmVQegfMTllNiPFY+CXSuRbfpVoIn?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pP8RMx0ySNFMZPrvhcvW3BbRE6Fco5HFyZewd+UB5TEKP5UkQy+62ESyegYc4u4SmSRQzNhHm4BcfOMlQe68z8liCfTBDPYlofdtOpjqAhOvZG8sRdQnvFAKMLeGSvcZ3//oVT9dseJaedgQJDqePQRogCQzknpJ0wJYsGmZK2RsaMkFoH2MxziMwab5xSPmNZhkGjzGMhJApJGG9OmQaVjlPttCBBsjMCyWJT+BMsgahNxg+hWMPGkQDg+dq8yvipsXczlg3xS9dXnT8VDcVkBEGTxOD7AusL9W0B1hm59P2FoceiY8tJKlKasK8XW4WrtStDeMr2zVppqr1XxLJozMToKIWItjqdjNjJQKPFUebyxyu7/EpIAQs2lRB8V7gAPbAIAyq5vI+aeJZ+SAkqszxayqmKZFpNAgvnbkGdeYB4FRysrJlT050Guw1JR+wJzA1iiEbgoQoicqpBTGn8K5o5uEDzpDr1cK34eKHLzdBpGrNv9hNK4Nnn3Tg04NHOW4+lAeKw6G0THtj9oWdl8XkW/APF/L31TZbye16HfoMQShfdlI6zo3Jpuv6UQ6KI1aQntL7go1VHGQnSrU7QO8JzRlNIdgeqWl2YzY/uGnylPt3vgnj1r3U5vp0sJAQFd0t3NcH3nockMgmxOFb1MatAjGytusVAWZIL0lQ2NQxBBHFS51Ek3bXtdysrfMl8k2elk0vMchy+rzchUJ6/LQzakFi1E6Z7Dt3IB1UTRrRSfttcPuMWzNbzjBIMVycLNbQZfpDX2jpP90T/qyQA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490091c5-b5d8-4b81-e8f5-08dad24e7b1e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:54.3126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9EXzVsKeLIUWSTYcbxAlzIAzw+68G2+kKKT8HQl7TNMZ4IdqCFVrJ4PLjC2DE6Y8nLuGrHZG2Z9OcaX3b5M71xLbdA8VCpneXbeHy6MEyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: ruuAgrpw96IPwpNur8Q7oapObrvgZGdB
X-Proofpoint-GUID: ruuAgrpw96IPwpNur8Q7oapObrvgZGdB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 74c4ce44f5b8..63e5da5bf09b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2539,6 +2539,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_after_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -2837,18 +2852,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2862,10 +2875,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -3090,12 +3105,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_after_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

