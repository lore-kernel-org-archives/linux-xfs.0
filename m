Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1B6C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbiAUFUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:54 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57486 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234054AbiAUFUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:47 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04MqV016482;
        Fri, 21 Jan 2022 05:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=i8phx9TmITGCpRYj5OF5k5XDqmoz92docZ+iJwFje5bimaaGzPbum1ZA1GQeOwQ1hsGg
 ios/NtyERtbY/CvIhGI44+lSh2WFVdkqFfSWlVWcWvwsCwjPP/3KHKb35B5uM0Ipk7Cz
 uKxxvrPUJuEF9xCnsxpPk3RwExVkAs0EhKvU0wnSY9hRh5frQUejmgSOVV7aJ67hXpUn
 Bz04PuyjUgaxFdIxJYYhOmSmumB9aHUuFgfSlDPH8hGxGXZO61qRaj3pE7pafL5HKe9F
 0turVSBGMJrgvsRnlK66R/iWK08/EJDITiviQM+3J3qdhdhHjz1BELkKPLWoyqZlUPKv 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KWfl007127;
        Fri, 21 Jan 2022 05:20:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh0vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeXMjEJQU3zk+ST2JrGopK4Rj9d2e70zEYcPOvzgFg4Gd38ZgyP0DcgyoBIsBUp83wAFZeRX8u3mBfvP2im0hoPrkWkHJxpcv2PPoFRj1J6vZh2PIuNmt82Y7s4AYYjlnlw+Ha88lFWEVF9taY/L2JaU52LHdc95sG5N+BoRTM19lE58X3lwTiedH70xS97EqTx4mCIvO1eB3GRwfqwsb+WlyBvpu7cvCAFNgf1gMRK/yiHLEBVeiB1idSycYSYcECH71A8TOqymBfoYiWhrcLt8IlOntXvilR/DIuwvjFFRugtSqQzXf99ZaeR3j8VOOrG6VhD59KvCufG3AJDIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=aXzfwAzevy/JOL6EqwN8PX50w4FWXPb+cACKSIszodMDz4zG/6oUvMAbihQ4H8qKpRm+uEivdEPUjlmdywwc6Cyq950gKNd74IBeOQdwx84Olw7QeJimP7MESkGFKc6ehBqKX6UWcSiW6zqnj8JIk57sWwFNlj8r+Qtt77n4o1fXJPyrm6Kb4oi6y3vsA7yb+eyhO/SAla6VOoDnO8wu9iqGjF9BVxWqZoY4Ug9D05oUyzIWtG6DezIIuL2Dq7T5oxH2n9D4WeWDIsCg/CXFZUvwWG0TahCLWz1de8v+BlEdzoxXek3fNhf+sWOC/qlbT2meT4n4xe+HIjE0PlJ/qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=MPoMK2h4n3gSYGxmQ9g3wt3sT95rrFehxT7DdxjVSLrH7gxn0T8QA/FFIg6qKbBA98aacbfQ/8MB//L4UhyIQm0+f4dmZB8hpYAiYrZNc7aEV4CFyqJnfWIuCWvulvFuOtNgqY9OJo8p8kmUuQphxWwdOLvkJwfu+cSENE3LKx8=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:42 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 02/20] xfsprogs: Move extent count limits to xfs_format.h
Date:   Fri, 21 Jan 2022 10:50:01 +0530
Message-Id: <20220121052019.224605-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cad054f-3cf6-46c4-c01b-08d9dc9dc500
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287781FEFC0778D0429C9E3F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsPnjWwiMH/5mF4XEENNCTBsV8Tx0va+28ubzbSrzsqfnucAE/6YqalhZnrqXgeZCFp1HZx5RBfFjJUtLxax0GixHtzmuC52YrdglOb+pYJXygylC8zhtMEOzLE9Y6VoF0Ezlen0yfFqhIlgHhO6cGlxApNSU4lgYE41TY+jkXVjjBzxchhJ8BLAmb+loZFSucinVHysb8rqMdE1LflLrmfdBQajlw7YCHFrQidtaYWXsJS3CwcdfvMQ4eyjXoHmDr9iFonQAAgzNLk09uYNkB2/c2ssuyVOw0M+xOXm2zeIAE3vVpQZ1qfGUXPUuqUBweu6URQOiute8TxVnY0s4ohodZdd0RVPbjdbxzLyjJNaKJChQylQvh/Igwq+OGjK8j4pE2hHJU1Zuqx9KGWOc2Xh+OUbi4YCgrds2TifDZ8PY5HDlKndi2AUeLDJEXP6otNRuybrUe4s1pA6OIbRDKQaauYjSpIVh9DsgBmPNNjZiTbILQdFMNQszRAlg6Ir+eRdDGXiBVK7ivwmLFBHsm8izy/n1oG4uv1myjb9RPWwrUGj4/bLvouk8QROjIEcb9uRo4Z5KMsvhD+0R2qIUE1pyw91hcNiIs8HbGQmZfv07WoVozOKpAK+OLziVUmUzyXZzZr9dazXaE7ol/Nsvt8gqgIWPv90VI52fzSs0f8erXaZ5AM3xLNaOEqjhTCJuYVyu0wh2J3p4AuYyL3h9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eliDSyBbbACjrWxY2VP10TGAcGX+oQVKWwQdhH9DeSaT1JHou64rSDDsGHur?=
 =?us-ascii?Q?qMXyP652V6WN6Ze9akukZryic7mLhDKuev5wr2r8ff04YHzN2Egt84uWb/DI?=
 =?us-ascii?Q?9cMriYUPtrTrDOW3mDD13qcYVmoEQL9m7XEs2Yd1fzqOxInz1FrSEhSlLEVX?=
 =?us-ascii?Q?f6QKjnHuxgDtICFDVihalTR05rNtVAg8ojEGKLXMXsiBA8GaR0NMs6EjX7Hc?=
 =?us-ascii?Q?OJFNfq7w33n42C8dtEGt8UuaHo/eNM16OUKlOLxxTRxyuWzFr7ZHLFGVS57K?=
 =?us-ascii?Q?lp+r+VSCeEPsT7rFpmZkgAVaoel4FCEd46Fv9c4xgFqiF0harMYDvqi+sDdo?=
 =?us-ascii?Q?ab+7RYWFcjBwfOuhOLeoNp+6kS75nG7BEQ3yvlRcw6No33pbU/zJQoB/kbke?=
 =?us-ascii?Q?GGndWFTXuwo2DPVYe4jhjx1uG1a1iGP/hMxXqZkSnQJHfq6+gOkxLU19sAAg?=
 =?us-ascii?Q?dYYVIz3WWQ+8rNMGsW6qSInHfi1omF8XmjtbuBwA4JIKi7G3J8AI4MwGkQi6?=
 =?us-ascii?Q?5nsx2HC7n6+HxRmNUxTX6JvNcSu1VKMSFXUZCuDRRLF25anxeEFqFcCNZdVs?=
 =?us-ascii?Q?tRmkWcyGzf1JKdgFvmmUSsm+h7DyfxG2q6CrC7xBM2n9ZhaVGTGJtPjSTY4S?=
 =?us-ascii?Q?DeFd2xeBixcolwr/8xMPXz+se/Kkq7CBwILPuVLUDwKmvFlNB7BiFQMgNpqu?=
 =?us-ascii?Q?ZipkAYHT6P5I3tTpHXMDR1IJjljC2VUWebEXuW+TnR9DU+OfRUxhS0iIQAZR?=
 =?us-ascii?Q?2+3ycHnM4A6w11H4ODkzhhfLrMmg4erxG+tsYr/5s4a2yzEWnl/cyaqI3d8P?=
 =?us-ascii?Q?oDJpx2nIr4NvXAOStO+nVw0Z1kB8obtVzXuAL+QRyMLdEJ39Hu377PeT/1Ta?=
 =?us-ascii?Q?EAX4zOpt45QazQgcBa6Izg07r9yoVvQ5v5TwfJK1vnaoC32ejYoDxnBYy1tP?=
 =?us-ascii?Q?vEVEtGlxVsf1mP8/UdAt4RXnJ3AVtHS4SlTvG6c0Pi1eQTL++0H3KVmXC0dd?=
 =?us-ascii?Q?J8gJMat061JbB1GSpjwOrLfe5ju759I4ENs9exUIRLNLAvC6tGXH2kWJvDrs?=
 =?us-ascii?Q?uEilZS8gkagZF6CJeZ3g8+lWDYgf/ZG157FEsslO3GeTu1bi8YWmXbkzuNOh?=
 =?us-ascii?Q?16hhwStQuS6nJl9eagKOm7JsSlpHp4QaK5yvBl9ZnYUTm21EBz+dMe3Cu2UX?=
 =?us-ascii?Q?TgRh33J30pUiH3aJp0wZhAbxXMVV9nsdswux+JnZ9mfvgk79MUOosIDP02ZS?=
 =?us-ascii?Q?C/soyZE6Z4LjJe9ISH5Y6V4veVvgmCkKdn+U0+It4YkJng+a75S7/LPUBvYD?=
 =?us-ascii?Q?9a84E1q05IOgMjxPP7GzAxPdlocOa4AMV0vDuR+8noC2dQg3H1qSpIwjBGKt?=
 =?us-ascii?Q?aGbB8hXZOWfGHk2mYKYHkFw7apgKFy+Pzt2Ts/AlZfHhFWSY26t34TwXKRrX?=
 =?us-ascii?Q?+qLHH7SaBj+Yn6scpOFrw1/onXGqTY7SMPR4FA44lkWh1TOD6ctNOGbZUGuY?=
 =?us-ascii?Q?lNXxEwJ9rhbQ4MlQvK9indovKZU9OP++8RB2RtQSVZdjkc3uZG4q9Yi4Ieew?=
 =?us-ascii?Q?Qw8wwY83EtJkH50O1xtSLzQZUjT21PT7dDyfoM64LYM3S87WfaEo3r9yu8nX?=
 =?us-ascii?Q?UZIsKgB8HQ+ac6Q0u6qtuuk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cad054f-3cf6-46c4-c01b-08d9dc9dc500
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:42.5584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/7JPkzSpRbNbEZMOXAMvUVuwixyKJX0m+pozwccqzieMROXijwiaqWY6x0o9IiUDtNgu23oozDv6nMd9yzyaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210038
X-Proofpoint-GUID: S-I5eKYfTFSlHA4aO6XzQVvhktMq-Rx1
X-Proofpoint-ORIG-GUID: S-I5eKYfTFSlHA4aO6XzQVvhktMq-Rx1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 7 +++++++
 libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d665c04e..d75e5b16 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index b6da06b4..794a54cb 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

