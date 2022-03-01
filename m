Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2875AC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbiCAKl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiCAKl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE2B90CF3
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:48 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221867vt010129;
        Tue, 1 Mar 2022 10:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NwHX1Sl7FY+R9f/1THWWL9TnSRk8YnFlOAfNSRXMvj8=;
 b=avisR4VvOpntGABel0xTvHnVMWK0XyMy2me+RZc4NfqFRogCuq2Apfc1PU2/nfekD+c8
 g/JM7Q+S04LvIa7KB59aeUkroWXqsqnutO4EdbTfdwBSlpqZ4G7ONEFopzAJYzli7wnF
 e/BrBasdrWdiR0Sl2MAvpc3GsZZHhbXtPopBjpbH+rAEwVWqw6s1RaFrCChBmfW+vLHF
 1C4aQj4vp3GSZSa6kBIaCB/6FUEFawKiTJUPnxjnJKMVkiV7kPUSao7rc9ctHj/Tdj0H
 Ob0IFN39/NlBqGEXHKXGl4fwYyq1twCUvnN5hYmawqeSLYIx08Ksoze+DboxfikRUt0S pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k42b4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZKVf134150;
        Tue, 1 Mar 2022 10:40:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3020.oracle.com with ESMTP id 3efdnm9sqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRkgX5Q3uNrzGREUcwZhaVbFdRc6rooduofbPyke3Mmhprom7DH3hvmuPPbDwlOklXuYtD8vvi1S4U7Ww79snThQM5jYB+xzz4u2QwMStapUYQVGJZ5yiPn5Dmv4Xe8gRtG55fUfj0slfTuSXkGqSLiNyQ/PZNYc7+hoh2PnMCfyrlgdIVTxGRn198W9QYXzm2NYHiQqF9btegEL7BpoJ/CHepi5UJL34W/d5HzZFvMkAGXoMlcvB2oR7h0RVZ7fRp26YqRuQN6blep7oPs1cdZFORsZIHLTshlKLd6C9y+dgxTtFJmXK+TCYAuct+cTF2rVamisrxGuIp23bLDqQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwHX1Sl7FY+R9f/1THWWL9TnSRk8YnFlOAfNSRXMvj8=;
 b=YNwaHiM1CreSMqPUn49IwNvBVUdJWZIdHIRnrRQYdmW0EkoAnT79+ULQ8Eup9y2uQijlWBllufQJE+EToTl6ryG29TzTCyktMxPVxhDPc+JGHnw+t2715D35s2tD2tFwqO6U1OGPeXgbF5ylFhPypCZxUQTI1iY9ENDGmHUL+NsbJihP962tsFIOMONT9LqQMMg+WLkKtI59kno0rFtph6u8S8dk7ZgcCZCaaYa2V5gM26cXTfae0aWOSde73fSLa/lHXYb5cQeG+oLaCTfe53JZkoyC9f9uVaZH868VYVL7IKE5fR+qCm9E1v3twQCKfD3rWkcM2kh49RD5VzFSNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwHX1Sl7FY+R9f/1THWWL9TnSRk8YnFlOAfNSRXMvj8=;
 b=ZP5oO7DqHQrgwWjPKA2hTOyzJJXZ5Ot1J/nFD/72sQffmG6QkDYtoXsKJ/TjEXTvSBeJwpiXpR67oa7XCVHhjMKpUJ5hTAeLO7yOdlqPGR8gwGPNFYRfXAU9qugGlaWlSOmWwIqZUcsBlWbt3MWVRLfiLz7bRM673cQCMs1VRz8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:42 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 16/17] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Tue,  1 Mar 2022 16:09:37 +0530
Message-Id: <20220301103938.1106808-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d2fd396-71ce-476f-d407-08d9fb6feed9
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160140136692589307C9477F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q7ZkzANa0+T5CmwdXwbjPVRCfAj4aJALSQ50DsEm15peLB65NAqgm8skfjXexYH0U9VpCK7ZOQCvSV5DEGyf8aTA/xdcgXpSodKklQI8MQNP+T/Nb1in1wpXBeNRZkoNPDoE4PjQDwkD3w1ZhxwT/6YuH3LdyMfTVODi0zzkipIi1YJKbcXSrjLBiW1zvPCNrILXTIfLuJTyiwn4+9usZN2Xh3r3YjnIUAxCihJvRFQZ2RiYtk/mdcLcGyC7elLFjup9rxZ/JW76riKdY3gp61hvdeLrGzY9XdgKEwfDsCCs00JDvwZWKujVzwG5qOcTIpVh1+pX5kPUh40H06IaMcyFx8yORixIuPhEjNr8nsFk/ra6Hz3r9n2NiJg9Crsd+sZc3atg/twuCDLD4TttiWhXRpMXKRzfjXsm195NLQSL8Y90IviOyOw5LTmfEaYU4Y5vFxKBcYdbq62IlJrMYAeYiqN1DBParkTh2lWLnd9QLlAX/KBjj8owaeua4BEDPYJn/W1x5qCluRqBGKxnWXc+es8ZcWyztygTP21iTwDa3tA3PskOtCr62g4lSZ6+gf/CIlF+1rjSG/fyPAIEW31PeEEP9QLhtiaEghGmt7SQg970zZGOnp3EG1FyKpsbH5/JaKQqXXq+y5k0OBwEnturTA9Adbs14H8mqZO9YuboHvybn7VA/t3doMvDGWfeV7jiKbHN2Vr+dVLy7HmFBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(4744005)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VlNUhtdWxsRd+wJB5Rc04Hq1hmYH5OLya6NkLkeEF4ZLfyAWDZfEdCVQKkJr?=
 =?us-ascii?Q?RpyVpoCxK6D08M65Ejs3hB1xM3s5DIdtmL+q29d0BoTRnXUT/pjIq3/ZWQEr?=
 =?us-ascii?Q?1KOhpOEONbOKv5Ud264ma+fxijNEzXHjrBb/npiUS2pPX2lg6/CjzgxtOw8v?=
 =?us-ascii?Q?79Mwsw9nple5aBH9oOP3+CVY6BsB5Hy2u2btvIa0iu60kHdY0KRsGoGAOqzx?=
 =?us-ascii?Q?gOpYfa7iaoGaiwGBgS+IZu0tKPVijWYrOAk9oW7e57KHDNpslpCGh3h43iKW?=
 =?us-ascii?Q?lLMhnIbQM6jOUtSIcaf+V4xYWw6c5fWAh23/A+gNiBDWy6i7ELVQb3YQx/Sh?=
 =?us-ascii?Q?XrsCle9BBINEzgSVp9l7EMnqbupgZRLSivwamoCNafb1rgyICdokxKTpKzlG?=
 =?us-ascii?Q?fbbv6KFOQohBt+6nvHnxRcNyEvwjrCRaeVdnLQ/sPbTBzv+kd3xlMkC0e9VC?=
 =?us-ascii?Q?U8CNFhErhBkLkHCyBSEQvIPJM5XNNqLuTsfjjvOV0+Dr8wBVfJYceAarQnoo?=
 =?us-ascii?Q?lPyPOnxCOG3IGhctMSdm7OsTAYIOzWHlWGoDEwYdoGhifWroMDFYFd7tao2u?=
 =?us-ascii?Q?eNowUitrnyOrtLhn9lnNqZl4RaceSoRuyu8zcwW7+M5/RJg/kpfqgdgDdtzZ?=
 =?us-ascii?Q?KJ5nXh5Ft1JCXD+zs0aRUR2qVqGlQi1S1S5Rq4G7R1w4ANEsUErak+NTyQMP?=
 =?us-ascii?Q?Tu2pG+2wb4RD7PYU3iEXZQIaHx4d7J3EU0OtlGNm6IwK5Ck8JLSwaKRrHnBo?=
 =?us-ascii?Q?uzMaTMULUW4k/PUyTkbCVTc8yBXtYPze5mPuj33Et53Dp9uXjrKxoXar1dfN?=
 =?us-ascii?Q?sGfiuYuEzq7NUkijxvmCyeeF9YfXa764xR5CiZ7q2p5PbSpWrC+IK9aLilAW?=
 =?us-ascii?Q?HuZsobMlu91Tewj4VikTEI9QN/6bZByDcYY15uIA/6QK8OjTzaVFRdhZwfP7?=
 =?us-ascii?Q?7WmDKj9lMkQ5sZ5GryltthKMtEXi0Y0LcecVQKwI9GzniLbf57a7qVmqLgmK?=
 =?us-ascii?Q?2g+6UgnWLa38zMRZCT7IOyl7YpRZZAdEoYoZGFYzmv0pnoWJp+SQiejAPmJn?=
 =?us-ascii?Q?UZj+z3k4fAfHXB+k2UYKtjI5gl+ZSv7zDeq7xDHj8J4ZjB/ZZ850gYxgpcdP?=
 =?us-ascii?Q?UUFnJI1TlQSu02+RXZO80kI0zs+NE1xEVUxxzjul/ETIEl7md7ER4S2mNyjQ?=
 =?us-ascii?Q?syH+AcWHBphXdqv+bDuERueyuKFQjTzL62w1TmBR28JJ3M/zxwvk6oVUq02R?=
 =?us-ascii?Q?62/+2RaDcjGdPOd0W/v6aPtDAcUqa3S9Iim0OL/kqppCnEqtmJqWg8ZpOZx+?=
 =?us-ascii?Q?dMMKzQ1QhrOOXerzfryqqECEKB4Jwy59Rw7LQ6PNCaMFDAM+HnyZgff7uujC?=
 =?us-ascii?Q?Et+RqWTzoC7tywxnmFJZdWJMS6RF39v2GzSfOZINQe36xuhb2QnoK18iCQlF?=
 =?us-ascii?Q?hYYzX+4O27I9TrxC5FWQ/9kn4pkraXD7KPOwAIKJ/QwH7BnDuALzsEl5SHc5?=
 =?us-ascii?Q?9nhkIdLe8xOTI8vRbgsB3PLbJW9S2T7Lpx9lGmZjzxWLllS5oTtDDyZC8n2a?=
 =?us-ascii?Q?5SFnYHBw9R51z8nmiAC1TFRHzAYwb78FtV5I/YY0a4bsnfQsbcLT9F8FKaDk?=
 =?us-ascii?Q?1U0KbmgjrKlM7jWwxdCXIZw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2fd396-71ce-476f-d407-08d9fb6feed9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:41.9811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJMg9pf5rKSdnkvecI/SOx9Zm4AdI1F699Ur1/X6bYcXMcEeJejbaykzpCu/o5DhBucWCNvd/njMb/9uVNotxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: EBT1HPx40Hye-jOyaxhpxUpp_p_a5jlN
X-Proofpoint-GUID: EBT1HPx40Hye-jOyaxhpxUpp_p_a5jlN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1a5b194da191..76bd5181f7d3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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

