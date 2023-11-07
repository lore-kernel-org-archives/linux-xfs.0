Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0A8C4167D
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbjKGHIc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbjKGHIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAA8FC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:29 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NikT005300
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=2pyOlySe7vXPGm7Xsf4IULIzTasyZRfXCj9H37LiNiA=;
 b=ZFjm9nTyws6Len3cf3btMLR6R2iy99U85M3UEKugHvcqsAsEbDNNzs0/ceuQqf0EsPiy
 p+N6uoI5PFHd4MWCuOGVczW5BxSBN/3LUq+LwWnP3trLeqYX2YCrp0BhOKmrEbCOhr8C
 2GUUSmSulDg/4nL0x/mfBeoEckZ5NP58j48xy14PaT+aimCeAKZzxpOAIXIekhfZCmf3
 o7878nyUgFsZMeUrCSXbAfkVn6eSg2lZkIoOnx/WV+nekJQeh0UCPU/KQqQbTMCjY+x9
 +m8rAMaOHT8W2a74uLpBYY/2/WY0V4duGzsbvSkEf/yxRgH3ymWQ9QeRAOMZdPawwgYT QQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5e0dwach-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A75sH8s020794
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdd1vuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CldopGfTMzqpPN7j7boDxYyYcSdqg0NLZBOsfbeFW+qoZKfiURus03K68xy8hsr8xcKfaCeeoolblwRWcm8TAgtLxfzxCnWk4TqR48Y8vxxc4T3pnO6h/n2R+wG/2MU0/kwvVp9At6HjQuFptJHYH5nBsbqx6dDTIlTqWqBhPK5TBvJyqmWeVxcPiL9zjw9imka6AClRS/ZpUcb7SS8Kyena1xySPrI/UaUsm2XKdUscKjxuxSuOEMh0xiLhzS3Ox34m92amJ6/pZLOVZHwqofZQeTWmEiuqRoDOvw3c//kmgMtrGPb9telmoAf1S/nekn92N7WSvftneYWCuScUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pyOlySe7vXPGm7Xsf4IULIzTasyZRfXCj9H37LiNiA=;
 b=VIlkUE+dgJZR8VuRIcz0u2bHgb8RrVJZ8pOzy44tlGOowLAeWgUUtkSAf+YOVDZk7slQ07Wm/tWZWxnDWwII3v4pOnguj010NXEbn3ZPB+ULcTJSNK59iDAvXoHED3wzg+98sGvTIDtPPEbcEdX4SM/w31fixHdCPwBzOOANOz+ypcSGiionuxw7EadupLD8uA6ApMkvGZ51hg4AT1vRcNP6C/C4aIXx10hZ39jSmmfh93iwzyu6x5Fb+9/D9A7s23bt0MzVxzB5skG5hxOSZz31/zUrxNWSEdTfWLHbKjCcMzjgpi7x0TVEgLhlxOhXhOcIO4e0PuW6WfX8Ft32Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pyOlySe7vXPGm7Xsf4IULIzTasyZRfXCj9H37LiNiA=;
 b=xX/WfGbuNphnpCJpUoKGxEM20rXPhZaYLHf2baQ+J/23ZgzCFYcV5UzomV2ILZ2A3JGXBHkh8E6M/Zvgmhjk6cnpA3SRBzFzStJuHpLd++ldQlgOy1BCrBg/4q9+KmpiXB+VyCTPEoDehd/3bnqQwQXjuIM7LNRH2sHVT6flGJw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 06/21] metadump: Postpone invocation of init_metadump()
Date:   Tue,  7 Nov 2023 12:37:07 +0530
Message-Id: <20231107070722.748636-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 044ba694-3a23-4f64-113a-08dbdf6047b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzbPrEmEdGXtRlrIqUssrcyMbZuJQUoIcuEaXZQn0GptDabzv9J8g8Jzs8ARAUnNVTcye3Fb/WBMpQNRHPo4ryBJzX7P59czyzhO1l2H7nQyLJ75mpmcdPtBGjqvTUROyqAzdvYGePyWOLlZCdXGNR8yIQI9IQQxRkPUj7ftbtQm5LD9DYhTq1wRpauMMs7TiW4u5Xd6ZPw113U2RhQfqXABQmZBUM1arB+H8nHLVO0RWbh1bt0x7vXUPDmT1QoqpnCLJTA0QJK2CiDK2sB5nmd+C285Cf7h6D5w4F10iq8iVd7q6vkFq/n//47zB21hkalDNb+vuXCS28igh0t4T74cqVAIINI5HYvTE18GwT/tp5phIgEGCrUs9db8bvOhAg/ki91qW94k3d/x1WEOEm66u7PU3a1bgQPUenQuKcPutu/64JUd2d6yYKsVgf9enxjAWkWqvvVjlJ+SuvXOPG/6hjRpwkJr9npy+Ja077lkEy2EdAS9YQ7NCq4Q4vcG/Kbiy3VvtVybSq1Exbx8eXOgfHw8u0tvq0slht0mttsw/Z0HodZYBssfK4hgHZjM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(6486002)(6506007)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k8mjWL5A+yrxdWgMvIJHcDZEKjwQXK0p7kChdDPY0oTsjeuYkJwbczx6GVlP?=
 =?us-ascii?Q?egOcoZzpJ5yE38LCCZ04PWR4++k00TehP85CtUjHRP6i0xydKuXP6jB4pTZU?=
 =?us-ascii?Q?zcZbEJXNDH4QGoJSPhb+Fq57ZIcTAewlZS232mASj3S2i5malO/07kjz2RIp?=
 =?us-ascii?Q?qp16EE5GPA/0KCULqBNSnD82TDTrDuE4wLk39xI32EOywN3EnkSND6U8ngVO?=
 =?us-ascii?Q?5l5PpwfrJtWOwmgtIRjzsr8ZEzexrLiLffuLa91Y8aYgunz38IAkaGpCxQsY?=
 =?us-ascii?Q?ZkHjMzo86l72XR6qNfXedm4BmuEG6D3yxSjk9wJNlgUEJPFArEwnmIiIm0Xj?=
 =?us-ascii?Q?Z7NhYhCr/oH3IeE5Ob1OBcDXdJBIGH5RNZrSEGpKsJzcqP5nmkLPK5itVIUX?=
 =?us-ascii?Q?AczpM9PvPKhlIOY0DLkYfSJwejhHWL7Khxp3L9uPg9Eqb4RY9UHJGOVNy8BA?=
 =?us-ascii?Q?vNbc8D2SnQwAK1SoZ+1SVLTEVSuUF9Un+kOLxnDFxv/TK8wOVsOf8E8b06B3?=
 =?us-ascii?Q?rhQysfva5eFfFmjiAJRWUqh454Z7sV8ZgOT2MJogY9ZPJFraZH/nNg1nf286?=
 =?us-ascii?Q?J/i/9nqpGVamcAAY/t2+dzDCkTspzUDp45M0DlO5BIzkQAhes69Cz5t79mDb?=
 =?us-ascii?Q?9T40R+oteF/63MtFrVZwJiVacHfIND5CLqW2UGXWCihTGCcN9xicaARre5KN?=
 =?us-ascii?Q?AnqFeUmjlj65CB6RFj13C0OqQbzoBw+ZNpcPMYHPn4zhOK8pzYxLP81ic5Kr?=
 =?us-ascii?Q?Cmgd94OPCYgURXwcLPWhrlNtrqH1MOy5s2/FYXx+eu+M2sN/taWZEIMnrvoQ?=
 =?us-ascii?Q?SEDeC1Ww+DjDwSmbT76g9KVb0/9jx8ei5qH0tdhHTiHkIQNt7RlQgZWOEAYy?=
 =?us-ascii?Q?4l49y/1Rq3UbMd/vKSj1r8Jznh4R8Id76TmIQx/w2vZZlMsM5xUDxzKEWKsk?=
 =?us-ascii?Q?mRi/zZGSjqgIZDri8NqfTFFuk9fXFqqNyXvvb6w8RwSHfqY8uLYb9ZxA88ep?=
 =?us-ascii?Q?Z+C+ZTp7OABBN2w4//9MfkPDJ6iiLrq09Yv+NJhskkJ436z5g6u3NeGNtEEg?=
 =?us-ascii?Q?qY2Kku0BORM7uU/I+rODROlpRYCSp35+bny0Z1BRgAK3KtrR2BuXLVBLIo/n?=
 =?us-ascii?Q?jeFVTMfh4gDOsM9Bvk/U1rNL7/WcUIYo9QlxKBEKXPfZm15e424CBvB6P96Z?=
 =?us-ascii?Q?1bYfJxE03wtqKqrJmEh6mXcYSXZ8AD8X1IkV2mXSxQojT7ZzO7ugDBpwL87l?=
 =?us-ascii?Q?wn2cztNdyD2+KIdWjjJYeWTGjzxLioEqwCWBz/VNoKymRvb0O3ewxzsws19H?=
 =?us-ascii?Q?ycONP/2QwCeKfKhB3Vh8Lm3vEAvZoZcTQnPcOX6J5jU3yElGehiOdQ1Q8J+8?=
 =?us-ascii?Q?eOHd4WV+T9LnEaNzWKfyZwUF+xCYeN5xfzEc6QbSDDjCi5uyhAwJI3x4Xi4c?=
 =?us-ascii?Q?tvQQhpijXyftNvq8vBqXxZAMxOlorZRifn4gxHAzrdiEF7TmPwm4hGWLe9W/?=
 =?us-ascii?Q?2Hs56ua1QNyTSzSr+27zUePCdCGUdpgv52tT7pGmWG082BcvpNGD50ZcTssO?=
 =?us-ascii?Q?eC1vUisPKLlvqX1wWLUWvilJR2nklrlYjoip5QrQQqQVOeY3mAcYu5rBwwGi?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: U9aDJKgYj6EalA3jIQtutPEQLCnW1YHuN2NTUbV1Yiikjw1JBadNECOhucqvkdOeD3NCT46kUwEJgWB7cr93UU1Pm3gqd0Utk6Qs71FRoiD0CxhGnje3PuGSDbznKR8WuTyhsvE+5YNJ+Jq3D+oOEGz+7F29RMyZf6fUiR52I4Gl1YH13k+9PLOTMsMBqKAXxOkz8eF7tDTqufGSLkZp3/vxAw4qfcaQw9eLqW1xqBzDNIKrBoSkGFX5pw/3rnGCScgOalP4Z399qbCtE+bzB6GADvj+aswfk0ovhgUCJqEJqm9pnHQZS4j1MpnS33Q0pyGMehR7Oa/C94XjGUhrQNRyx4b21vhDhzFnIK8HzmgbTnwLF10Yu/NZJCfdNNJ0pjcXhYA7hP9eBtBPRNvtjD8e33R+qngARPXVfXr7mv+Tsr9X+vtBmbxeU6hPse4G5gQNJEsyUmwPYDMlIbTjOX5w5EswLYnEOY8E3YYttgncS91w3T42e0aO6vlhyz0Wfm6aSyXOTVuBAi45Q9kmsSUtcCgx8n2YE5C2pdS3iOf0kBKc0z8A2+uChDoL8SxfaaU43312Gcf6JTCxdtA6yroIN+iqjFswNuMp8qzKWttXAoTGKAJiaJKFZX0ozckpW6jkDqprGvuokDs7BYTPIX/hwOPNO8PBhr+P/4wwExhGGED0sRQxXdrg7NDkEqEQrvuqkOXiKo3n+g+p6OQ1nv1s1K8wgjh7vFNaRTQml6EXKcW2CSsknrBhOiMayBcrvJoKP20JeWA2Kz2yiPL12w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044ba694-3a23-4f64-113a-08dbdf6047b9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:01.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXmab9tQ9u0+AxufJ3bRsSGMl+zFT3FZrLZwI9c9Wb5KI1Xa3bbDF5HJZ/7LhSKDP6KOR6PHMyjowEK3hq2y0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070058
X-Proofpoint-GUID: Dag2_JZXlKly2ymNcEJsXBCyyKyaBlca
X-Proofpoint-ORIG-GUID: Dag2_JZXlKly2ymNcEJsXBCyyKyaBlca
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The metadump v2 initialization function (introduced in a later commit) writes
the header structure into the metadump file. This will require the program to
open the metadump file before the initialization function has been invoked.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 8d921500..24f0b41f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2805,10 +2805,6 @@ metadump_f(
 		pop_cur();
 	}
 
-	ret = init_metadump();
-	if (ret)
-		return 0;
-
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
@@ -2853,6 +2849,10 @@ metadump_f(
 		}
 	}
 
+	ret = init_metadump();
+	if (ret)
+		goto out;
+
 	exitcode = 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -2890,8 +2890,9 @@ metadump_f(
 	/* cleanup iocur stack */
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
-out:
+
 	release_metadump();
 
+out:
 	return 0;
 }
-- 
2.39.1

