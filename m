Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6148C4708A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiK2VOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbiK2VNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89E07119F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:31 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIkjpa005619
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=ZdYAeLAsvzMoX58fn5gO3cXCSlbXZQ7yKNuUJZ1/Je39/+jSN4upSIDVBsi9Fw/NS2Gs
 3oh8JRPZL/2R1sDHi0Q0iy7IOH1pjuVnF8ddriAGc2yXhKb6GviXCkbTM0Z9TAYoKvMG
 IVTufQJXys1mHS2HtN8E0wfIzw69Pj1huvwnL1DAEfE26IucDeDeMNIgSPKIHHsp54Bc
 UuGJNkB5iJZ9DSwDZIN+PVhREaARSiPT9FTY/cPh/lnSbkaJPl3ozCSrTAcDYJQ5UnXu
 bEs2FhzyqhH2oZa17iuEuglocvOcMNlpls6sTuQj23Qh60Uzyzx73VCz6ccUnZG6hzeN 3w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2r9gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKRDdQ031233
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:29 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987nb4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgpOttrDrqMHgppAR9WBPB/mmf+fh1r3CsaG3HLfkPFqA8MA27FMbWqPO/N292zTFk1isHN1aXddBQXuUi8nGwvUHLHdb9BngWZMKVBTd1BNbofV76STyVYIp3SwwM3RnkZVLSNlmTPFbhVV1IzjFLROZASOQGJ5sdQi6OoiO7pVSC0tHisluBkhjcFcBswohhzMA+yFcimaaPhn/ecp+/rIhEvFj9+prl0lsOOmOSqyAUysflvwfG1SZhQ/M3Uf8TgzSfsf8qQ7gP3jSKnLYdZCgFcP80NzrrZGXEwVz8+8sbloIeWl3UXSxBnwQzqffEw8/EMzPiaHBLIlqaM7SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=DtBBFe7qkg2gP2ANH1ltXIj96IlKbq0/xrn1s/VZvdjWuFjvXcjD4vkT6MQT48qzR0fdbERWFqBdZnWdOixiHrEGKNkGe007f1v+T3W2YVKs2e2GJnCJfTBbMTsChi2h0Mr9R/EUmkd2bvXNfdsQ6gu6h7sSv9gux4ty7PHOM+gn6efbaViup2imxEGpXMCCJjLGJXfejwGCpb53cZt/QocTy3d0c3tcoamncl3PvraTD6At3DvpwQX1gi/Vk9mCY72n1Q92KVJs6q+DmggNyCV4NO/nARF35roQf35T7OGXGh6C3c5ZlaIGGPWBr2JvEUeESShw5hg+IuR0CDmKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=mSg3oLX+aNZvJm2V0qelcmDdIJxMAzfjPnpb9CRmt55gPYot6oeZ0qMbYiYdhe9ZYcfBsVvjW4hWg05OAJAFNkA5PvL9iSVhBIUCYLQWaITQV/BJ/y05N8PFnZp1V7/ASgBdq5tfQg3WWSfun1lGsn9097mokgvTE+3/Lt1cGYE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:13:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:27 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 27/27] xfs: drop compatibility minimum log size computations for reflink
Date:   Tue, 29 Nov 2022 14:12:42 -0700
Message-Id: <20221129211242.2689855-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0018.namprd21.prod.outlook.com
 (2603:10b6:a03:114::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b080268-656d-4606-6e2a-08dad24e8ed5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/e82e4eKYcfQf4/UvzL69bPcQIwLemiuyz3kl7fddjnV0FrK7ObhURh2JXUaVyOIjlN5qs4PW7qjsuTLTrEE79VOI5ooZMWWWnDtDwDSGvWjitIockRSQYI3YkyLT0GaE84wZnk94LnKGh1mEnzkSPk3ksvbaVC7W8FFShl13cVHxub15Y3j6kaTeJQ2jkRsGq6qvikU16JXznsdhJUyZL+JMhkLXFXb8LWlc8IweTxxAEiQV3NN+ztKWF2FbDlLYxiIvAcxOQifLdY5gAUW7QHdvC4M4xxJGwrEE2/+aLcfakqX0VyHIqyle3dBVIk6CYQCejbbpqRPBD+wbzrj9bybJ2cwITLWRIn6SvwRJt7EshukkUr6CSquQhTt4iCrqi7M9mdqDLTWpuX6282jk/MllGQck0I89HkYoTJgKmR4Tp38adoHYkY7Zta4i2mlQJ9rUIiaKn4tf73/caxH5mwgXa99w85FbAuSI91fuIyNGwVrU+hAioH7oLxCYm7RbzGsbeIgnfRkp+VyWt0A7aEfyqTvs7aqiP8iySWT8GT/KYdUxTinnKj1BBQm5vFle7gefExNVnc/aT1JX1uvN1ymmxG9RsuhYR/FJFI2RURbZvGKOoIe0Qpp2kVmdUO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q86PZUPWpsrKsM36S0c3z2fBoEOWUG7/lYBGWg47G9Vd1Awf1Bos7n3lemcg?=
 =?us-ascii?Q?/2jlPLbQr8J9VSVUgKaeTV3x27nORir1MfWhWFr+7kKEjciIr8Bz9nAe6gje?=
 =?us-ascii?Q?FuqNAZOq+PrpRYzaGI7pn5nGEUROUzfhGr25c+DQV6SdRcxeb8LMcN1ZYdSJ?=
 =?us-ascii?Q?oQ1lsXNiMRzB6BnXturpoWW4iWECk4tzhfVtFB9eTJ7WN3vx52KiquDfjmYE?=
 =?us-ascii?Q?UGd7e1VXvsOISbbMOFc8lEHFJbGqvGp3mc+5fq5Iah33tn3g8zzkVF2tzmMY?=
 =?us-ascii?Q?OLI3ZEw0ou3YgSI5CwxDi5pGv3/JTV6lTwxWoIXw/qI2uWhPgLMEK5VliRku?=
 =?us-ascii?Q?Fv4X4/eeeADlf7CAJrozK8RrZblS8Aw+ymJFnEwXDEQC1vYCNTDLDr46qF3E?=
 =?us-ascii?Q?Usw9XN3ixxP+PFtikD5nsl4Gc3QQyMFbyYk1fWo/rPLa7XFRd3/PDer3V90y?=
 =?us-ascii?Q?tscsFNvO9Kp0wJEzMwVz1vUNSv9n3qg4KVKtK3yoAoedZffr5N2YXP0XATuy?=
 =?us-ascii?Q?p0ZSpTusfgEU/wKJDwZRtfU0vqVfHJX5ZEUskEPNWdOWpfDYeoG8I2UX6Ekx?=
 =?us-ascii?Q?kSqrfRjWD3Ttzsi+oHXsbtEf8lVdOwS+NnGYOApYq2NUptEVqbBqSlkdfzWo?=
 =?us-ascii?Q?RzbL6YaKIYUTKEuPfMCx9IJqtn1x8KxFoD/DFPR0PKYvlrgDA3yrOQNaLyiG?=
 =?us-ascii?Q?yMdYlHVXWICmJqLikOruPl4wqnS62ZdK20l4tkuaJl7Fm5vl3d/uoXtK0W0Z?=
 =?us-ascii?Q?0oQKXEjl9qjo5F1ArfG75bUpfWyEJy3hi2euEhtepTxgMaqFXZCU706XJvJ1?=
 =?us-ascii?Q?0DTc9H7csyXdJbfUE9pt8APe9tgHgbT5gCnj15RJxIXDC9SlXuFb0D23Bqgd?=
 =?us-ascii?Q?8B9DnKe0pp2Imxlhsc3itJnwwJdqLBVwGC0B/mSoS2Gsa5tuBlALiZL/etB1?=
 =?us-ascii?Q?5oheO55UKf8q2JlaSIcEOaIkUpbSN/r+zCnpTkjHS34vmsRJs+AJLhwG1NzF?=
 =?us-ascii?Q?EB+1I/FGl/Awuwwd3BmbJymy4uRWFAtoS136oR8aOygKjXZUZfRvQEEcIzxA?=
 =?us-ascii?Q?fYUTxp0qZ7lT9yiWOlfLaf7ge9lR80+XHYNcd/opfCmCbYrLMhAmkxsHb/YS?=
 =?us-ascii?Q?as2x4oh/EkFDTPyIPgwDylJ/mHlUt5tsfaq83P7vMmVOpo+KWAZh8aXGZ5jH?=
 =?us-ascii?Q?WK6svIk98kRM2vvVOtLFG0nE2fzT57PeblvdGPtZf5++zE+fA0zxxW+qSlKz?=
 =?us-ascii?Q?lJXtEF1GWwlY3KcGE35f8fXk9mc0pKi9e989l9EVi5NCWJ2inD6tHkBVUhWe?=
 =?us-ascii?Q?S29fdr7vyO0NUPKAV8So274nnYUu48/qutL1QjNEjicQ9kCYAQWHU9a83zkb?=
 =?us-ascii?Q?o3NaKmzmwHFKArJ5FdLndKFvxtg5pOOWj8vOR+LKXXNbejnm+zqDh8BUUUC7?=
 =?us-ascii?Q?UM3qcch1ubYPIWw4kRIqcKRrIU0FCujAAKRVLlwtXre3N269tQyyillmIt9h?=
 =?us-ascii?Q?btDTlgXomi5cpknmHmyda6INtinaSp/3QmaqQWd5ZEZYtHPNB2RFDc8J9Dpd?=
 =?us-ascii?Q?bU5eG6nMCfz2g9Mt6rg1lvFz0lZqo+1GQfuFgi+eJc+nHaida7NUY9W3EfSz?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MS1Tj5NaT9vlGHw2xW8ynBsxfwILLeXUKWhqBxIpkTYrVJg6BdUdS4VVZm45ZEJ1kb5sigQVMPZNj6eZAuASyaLMzDKxW48LGEIgkU1+sU+INUZlQ1LdBJ7Wl2Wul177vcgIOnIeaNYltQ6OkyRStAKRj4VNqBlOZ7Mh011fDRi25vUdrYBOIIxE45M4O5rfLwbXxT7GpGK/5ZafwPmWrpAMELysnoCCNx1AzbJW+PDTA35YYNDGNfIW0TYqPjzh1VbDXtXffeKaUoT5wmVtTZ8lNab8dLzKvLujpR3RDmh8ydq7lWwv+Nv4dFvo2ET4cx40eIAyWTg07Bdfm5vY47cxd9rd6D5VxkDIQTnARjqFB0hn/vPSRIaYdCbHe+qZW0cyEBa9Siz39tCRWKdGUWqhUFON2JGPtwgFKvnqVNKYMH8dJr46qSxR7Y/7pp7jwyTpP+E7ZQGAktKCbnFZXZrAC+K7TSOsGW42hWY9dGPCP4dKwsdaWOzGNOtxH3XJy71axqZ1xlN/p7/D8vnEYFqHRZ6Dwe5KLVkFb8fcSPJ6XVrXJ5eSytVUh1WOcrqDLXQVeOZm0EDW9ed6g/HpOlKUQNF9BbWMBr2yjcHk4HB5JtsaY4w14fCusMGdMr+77mirK7OszRdJ+sIZ3DXlO670ZR05xfFVVHMFxRiQQMrUIAqGFh47B2nufpoDUf7tIE8QbwNYx4EQnzKI0rWBobaoZhGfnRcew37SF028bpdoiqootGE2yDQ6+LP1lQ07XwHcRCa5LwgSRjltMBORhA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b080268-656d-4606-6e2a-08dad24e8ed5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:27.2917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGPXLEDySaDfPEEjsHBbnh7zWHAVeK7BX3UA7enFIKKoQAyIkrxgl7kfnoe3hTs4NP8SLzrmmCOAYNpvlgZ3lW42bMRmd3sH9lyDyYrShaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290125
X-Proofpoint-GUID: g3jTeeEDa7sxU-xg1L60KNkIomDVUDGF
X-Proofpoint-ORIG-GUID: g3jTeeEDa7sxU-xg1L60KNkIomDVUDGF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

