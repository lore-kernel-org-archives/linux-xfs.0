Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7391C54EB4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjAXBhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjAXBhF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:37:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D045F1A4BA
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:37:03 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04Uuw027011
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6r5E+jUVmqy2GQaGZCtwPHOxi4Rm8gm673bMX9XGoY0=;
 b=NCqKsrP/WEhkL5mfLW3MqkIIOv9Y3FCBM/9VACS2XcWpW8PUYb7H1Bm/3ejvSarWdVy9
 xIuIrJjSxnKzFLM1f57stI0dD+xgjziBoiWB70J1NyMpgYOgfyqhsJY3Gp7gHdyvuAbS
 Zt+E7DZ4jlQWJ8TajyFKOOvjiQ4sVRPWqui24WaDF+O57dz0Io6UMDsvK2Ze8gDsUAAT
 gNOqT7G1enTuEqqsRgX9QnpCQ0a0/bYIm3GtkhBFVS6kTQ8zOxVt5wZt0b+DJbF9dTXY
 cxFFFDZRLBDYuwrdLQd/MtyXZaDFKKNPAXtrC2OvS4021FXRbeEbBizTOFWkq4QtcqjM Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0vcgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O0PAm5040137
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:02 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4a8bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2uIkvQENN44tm3Myijyu98XFVbG5ikX7kwqiHdrRGg/X+l+Do3bap60oI3xClaeR0EPZdOUAcQYxhaS25yr4xXCCbxgKQrN+Oqyu5RIthOBN1eJ1bat4d97o58fA0kHQGCqv2lLLqCjGQ9ZT8I5AObpyA16/hrNF9eNKIdy8/6XfuSnHkA2AnePpxcioXw9Dj8LRl1KftgFmxZrcl8jHV5adjTdbjXaPTq8vSkxOwDobknE3LLRyVDkBcDVqklAlrMJcDLPJuQnn6JVyz1PwionsGYwFfL98eSL0N1A0hhAnfr4P54S1GWmS4ZMQUIk/KD+napWKXSOjhD5ecbKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6r5E+jUVmqy2GQaGZCtwPHOxi4Rm8gm673bMX9XGoY0=;
 b=SdKP0xcMpRw6yT/QIBjgm1OQMGtya9P1u4itMsL7whKhtzp8/sl73sW6IzzYmetUrpVaOZcWOZpkfqtcePs7K1zZhEfRP6SLXR70muDqOmAoc2lp7xA9VrZNXRoasqWrUv77UlFavN9kSoiJy1ct006sh8pOyHiyGnYbhNrZCImtNw3OPKKGbE2tIgy4cpS6w7Bj/LVlzh/0M/up74rIMHxxWSuSIboIhXBVhgnGYGlanItVx1GVQlqkZKvwbBSxjvHtDG/ORyGfW+D/Ds2lhPgCJmR7SUTxd24uGAquQaCcF4e/q5Ez8qChgrnH3ccgcvRdyzOdlKaIUWBkHV1NtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r5E+jUVmqy2GQaGZCtwPHOxi4Rm8gm673bMX9XGoY0=;
 b=ie/q0LvRvSWKxICU3S0EUaF3SEJ+8Kn8MPN/bx5caZRwerm9xxLCWx41awjhn9bQTw1LKPSXoz4vwC1VVQLzvSEoc069CpKWFMnBdH43rjgUJliGCd4+5gEAIntiCqXy0L+KqVXMXxPOrmalxxVr8gStuXB0Ynp0S6tdrhAskRk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:37:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:37:01 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 24/27] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Mon, 23 Jan 2023 18:36:17 -0700
Message-Id: <20230124013620.1089319-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0072.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 3817e4c4-5ee2-42fa-0c04-08dafdab7d5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: an4LAt2CfjTlSPFGbOaJ1erunfF9K0pWGpJliRgWSzjM+ocszWKpib3WBmlRcjgm5gS20DvpWvGbo+TIbNVp9MWbOqAQ/21cl7JZdDDPHYJyMqUqQTUvxUIAYL6hwFj9gCXvW6xqsg0hpXZTMx6Y48kMqys/ofPFUqP+ZHgdFaqD+Z3/idm+9aOkJpN5G0jmInICrVMKwmJLjMyJHJTyeSO8JX/mDBszYlm+h13/uWytKU00Q1KCwdzJKlfhy/1PrVtvjhTP9tCDF4RkOQygF07ef4xC6zaxuS6hk3NMbGDJBN4HA0tFysGxJDAjVQWDtA116argADDVT8WfriiBR/v+paq6wWfw8N/RkDrywjj6uBa8nni+o9aqRTF9lnVY5kLd/in70K5+sDc+T2yC9dqnOYpKSbgloQpc1uglH2J4j/J/rL/NkM5+1Qpi7jHKCwB/dkxBFXHwYojRcYjYMPE7ScrbHxxDAGaUiCFdYz7T+dBxjj0yX2RJErTq3W51QLCShW2RHRhc6ZDAhyA59J+CD7zbYjlb9SBxJt3HrEDRNDqjZXtepEkqjF5K/DhR7KJDE/R7uQAXyrVaxNN5MT/CFfEKJ+Nqc7243vadWKoqtx5+KCrKs4jBC9ejfEeCj5O/gDYXFYwLtZUBp8B1Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(4744005)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DBH34WCslPmspHyF9IOGCqsZ+Di0BjkwtwVHlqhJ8Eo6AqnAv3/hBjC047ME?=
 =?us-ascii?Q?UuYpiZc6+2MbiDyexto00jobufPlZO2zVgB3WuAsOTCqHjU1zy/YDv1JKB9c?=
 =?us-ascii?Q?j5BTkKpZG+Zh1DEzjPz5i1kImagMyMNEwrY6NqtPJj+y0NBQPq6m6yZQljBV?=
 =?us-ascii?Q?wc1gfV5CfHxkwSrUZkISiAlGjf51ZAQ0dp5pFDk09AbShKi4O8H0hHJuaX2H?=
 =?us-ascii?Q?HG3s3U+Id+5WVnjAQRxo8p2nIRGox2DlrFPZ9maFTrFLzpvpp9zV1CoyZKrA?=
 =?us-ascii?Q?ysVp0H8qTBEfRvIU6Jea+ss4+cYN/XVPRX9y9d13oQEiW9Bok4mY8QFhQiFc?=
 =?us-ascii?Q?t1Gl7a41iCA6Nn7L13DX+ab5kA5Z54drDxqZwFZL9BhhytCmvp6Z+Y71b8Hq?=
 =?us-ascii?Q?JWc7WGo1ZHhFplX9h3Aoigvd+edZovdWZGNJ2OjwHV6Ckd56II59SZDZPE/O?=
 =?us-ascii?Q?IzTzfihQytKpCU+nB4PpdF2R6RANyxs7hPtXUihZ18lWLX3hGRUlIxCLI2h4?=
 =?us-ascii?Q?amtOTtNo458ahO/y7nT9KqlCnayMCkceqgT+RlHXIcl6tF7ox2VRjan00Agd?=
 =?us-ascii?Q?/PZz7sEZ7DdVj51APk0pOcCRoxzpVmTyyh4REdxSEXt5qtcbv65icOHj9ssj?=
 =?us-ascii?Q?mdMuh6AJQEMjULWKb+1fKCiYEsh09Q8scmo3oB5gynR3psQZtA0B4GYio5ag?=
 =?us-ascii?Q?wbsWJ/fJhCM1YKBxmQvl9r65fIzu8g/rMhtQd1V4K1yzIbIbf1YvUn+GvcBN?=
 =?us-ascii?Q?mJf10E+XXB40uO4pa7AtP7RF64uLf20jDYvrV1iIZeNERUSDoBxmrTikJpuP?=
 =?us-ascii?Q?rF5NqDCsrqzX62SXOc2e+rfkTnYGm4Bs0W/MJL5Zos3s14pYvZWhYYWh2s2h?=
 =?us-ascii?Q?Rn+2Orq9zXZmoXWriJgiYcRxk8vANkd7A8gk4pltBBxDQK41uioMKU4X1ULJ?=
 =?us-ascii?Q?9b8fteT8rhyhOZnvuc85bxOArZhmww/Ixvs2J1j24KIwxaDytqxlxJvpfXNl?=
 =?us-ascii?Q?TGOhFdXZywOx8/xJb5oemtSJkMoJYMU/hV70+MFx0984I4F2TGv8yQxm/dSE?=
 =?us-ascii?Q?nj+yq1dDm609P9r2Yf6XheSn+m8TIY3Lqnzph01y9h6tF/sFvXvuiTrBoM9B?=
 =?us-ascii?Q?e3fgZK2VpnPrOd8S8aHw0I0z3cZWRmOBRsyt0OeEy75ED6QRBTXdJgnNvMB4?=
 =?us-ascii?Q?ZfEEQf3MyiasuXvlh8MeZgSeDw1486LgWXLFWk0fzKHZd9jFOT8mYLGbL1uF?=
 =?us-ascii?Q?uZXpjwONdy9M7+auXJDdgxW0aX4vyIf23rxavHFmOyx6ZiXitzZeNx+xBIrp?=
 =?us-ascii?Q?Oa6FA8V8N+TN1NXPPvGkhQoNO+KASl+g3Wz0aWzvedJNOXDCxx5uHHZY6lZv?=
 =?us-ascii?Q?s1q3hPl/po0uZrfZwzkaBq8Bqa9HtVrG3uaa17JIlv1UbpJWQ9kTPCzb4Tyc?=
 =?us-ascii?Q?1MymBJXaJvv+YI23bl6vzCFvPBUa65fFP91Q7D4BVBI3SGYwClubZBLVzFQy?=
 =?us-ascii?Q?dzgvBqI1eajfOznJ1gRLHq0/5FEQvwXU3Lt3CXtyjX9Zjak7bP0LjxjPiE13?=
 =?us-ascii?Q?70N/vBcJJMtANrF5Nc6ICER+2/bZIfsAxFaAD49Z1AhLhGTgPHGgfVFLpH6S?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: drudJWvJ+NzWfpJ8LW/Zz1dwCWN3DxALjPC+oggmD3i1vS6zFGoLItuAM2koMmBnqHiN15qwS9J2w8QQM3K+GOezdkArlziHrdN0Kv7I06DrKbGJSY5gfJuxfG+ySd4S7UEU89Ew1lsUusij6tktoCEU4tCGnV7hDQWxDVoA2+cFyb5et4WFjkmZq3DGEvxnR5N2fmBjfvmrdhbyguBRfEiaI8EUF9oAc+JccMB4Xh3IKXWE52Znc4iqq9siW63VV4d8i6btHxozdwrGgixoMMHHMqKNCBsL+EbYe5fcKoHFgukadAjkwwKSrVqhUyHw1B6UMCpnLL6HVNbxnCKzX+oNFT0duAHrVwgo+VTFzGsffHEtrNh4tRUk00B7lN2JJ+LG2hgVR4OWm/VN5yYIROIhGwuRa1fODKyzFuZIwUUCvbvyp9MO5GHzCiZBBFCkOkxgzz0OorJVBidWMnNySthMiQz9M5+sdYZBfM6tGVIQ6iW3rQ3CFO+UD2ilJd25i3II+jeMlKsTOZUBoMRwIOEdr8OCDit01LPQ3OQ4ajn/wgZ7R5ZYU1Y0ZzyYOrmoMSwxV4q4Hc7WLJPq9+VgxgJ/J5JJCygwH6ICqaInOiO6C+yVj2DcmymA3euVbmrxNU4EfGyJ/FQe3+jLmSkaSKgCTAykdx2bgynGcBnWtlg22JctJanZcBofXSVClz49QNaZECy/Qy+fyXajLc3EM3r/COV/sPC6ZZQBhWNcpRBGyqpJW29dIYJuPeNQGyn2tz4v/weULj+XVRxqMVfcqA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3817e4c4-5ee2-42fa-0c04-08dafdab7d5e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:37:01.2302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHjxE/pXmsDjd/GfkTd72rOu1R5MHjqWaYfsYpb5hjSfokK6qufusjJLZ6ilDGRDF4/HNEuWog82azCkTQxQYoKK9ejc3aEbPmedlAdxH24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: hwJ-Ygqhc9_B3-T2ZATZTjkMElRUMJcc
X-Proofpoint-ORIG-GUID: hwJ-Ygqhc9_B3-T2ZATZTjkMElRUMJcc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 3644c5bcb3c0..3d54701716ab 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -234,6 +234,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
-- 
2.25.1

