Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BD2C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 20:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiEJU2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 16:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiEJU2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 16:28:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6383BFA1
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 13:28:10 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AHuwgY024581
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=sAJoi6ruh195y1CwGetx7vrjyU54PRx1QO2LoSAeci4=;
 b=XYV7bbCbccCKKCvXf2UtN9Jt2kOO8hZWDmWUbYFTRl0mEl1v9NJ8iKt7WMXm54ploTdf
 iqUrneBe1QwGRzuGO5QlAb2aMTpF5Pf2r7ckUCD1PsbtKWX3Xs3fg/xrTEKF2FNr4f/9
 7Q6SpfTTKlZSe/k2LLJC1CnrSOKemVPTyPUXoaDM2WT8rPSOWXI9sLP2JW+kY9wJGdi9
 ey7fpapFPiYLwKxrUjIxZ7BPeG1idYHY54e5HRd4x9BDYROiWpC63QyPZKQ9lD6jM6CO
 ABB4mEK3FQ5wjB8NCj99w+5tUMlkI2z8DnqwkByjH/vtBxvYUVxRW2SHv57AbyLP6oiH Kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfc0qw3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AKLiLV012173
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:09 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73gr3m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfI8567shvDDbirKxjKcibdu6hpN5aA41RFO5tzAIpWejz0YNDphleQRAY8uIf9MJUXfa3u0KbCgjCWKdzA4ItMONYb6v0xPmsMmo4EK/CLckUM96zTjeYD/N5rn4B/1pehyDBrzxxAFmRZArnlYFIcrIOD1JQo6HZfxTEBugiRWPebCC+xpfRQr4W/SB+7mquG8llwPZdAAst3UB9iflwj0KIAeALc8d8yT1TEiBhHkMHjt+c2rcs4217Ap/GoG5Ctw/WjmfiSZT3St4BqJJTodNRNn1G3FbeINPnuEePp3SuwAPVyEH5fHyBEZXcZFwl3JLpa+5s3OEWxpgnI67g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAJoi6ruh195y1CwGetx7vrjyU54PRx1QO2LoSAeci4=;
 b=DGiLREL/77js5511iNMYA0JzdkY3V9PQ51O3pn8ASkphGhtlgeXHUaWk8iMaEXJTrpnba8vykZ+T9M7H2jYOelsOXX4Y9YIdPLPkfV8WpwzjeBgVHRmWm1vHEnUpRbzAUoY/E4V+yy/j60MkIvnTNdk5mckvTxORAzwE76zFc+d/AXdqv8mxd+wh1jF6Vxh9ZgKnd68M/FUiSwHMxHfxnX5C/WZbgVQD/6E1Z4CuGljgL1fSg6OHl9I6AKDVTyGEU0ZfWSo24oLeDbMZLVbbsBklrloPQhQRex2sBbJMzHnNppXBJtt+k49zYPbWelma7cBdqcmTBeWeqMvMSuPphw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAJoi6ruh195y1CwGetx7vrjyU54PRx1QO2LoSAeci4=;
 b=JKtsu9mQT0OssIsvXh269r68CCFIDbCozJiBAg06iA6w6afHkQlRJHtXVdVwUTfcatUKmSvgxAg8WKr9NfjO7tyqvG4eIm1B4iFJXmLHY4V+q2CvkzHO/YaTTQKdDxP8MS+diDZ4WjiQptwiS8jAE+pmYdcd9ez7c5IC5Asff3Y=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB3859.namprd10.prod.outlook.com (2603:10b6:a03:1b6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 20:28:08 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 20:28:08 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/3] xfs: remove quota warning limit from struct xfs_quota_limits
Date:   Tue, 10 May 2022 13:27:58 -0700
Message-Id: <20220510202800.40339-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220510202800.40339-1-catherine.hoang@oracle.com>
References: <20220510202800.40339-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8969e6ed-9c60-4051-683a-08da32c3981f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3859:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3859332E6E12F6FE3C5118F089C99@BY5PR10MB3859.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvxmQDZ12n0wb6xBSz08OfEk60UmV6d4/Yn769StkAXqZ0YjcDsJ/d3UvhsJGb+Dy2TCGgag0cEUHJIJi+BeBbGPmNysvsUqln3W83QDZYmwMv7MsU2yRky/RNJfXt3CMFiNOMsrIdGt8cAqkQVnk2aJGPY1B3p9UmZMpKuZVNOUGgH0bhVAtn30Nt0oU/f3LyzqakPOVR0FJDg6u/RzTn423rYbjZ2QIXfw27JecezJAkBSpJJz9aZL9rWazoL7ELzu6ep8g1NKeIkMAzFtoBl5Oj6tJ8siKzssFnN/IK15C4kibts48qR9jfsaAjWOzN3hv23ko5UxeuUlZwKNGKf1uBeoo2Pckybqhziug+/a3bqv2lF+BpTwgMcxHL89km33y4ddzF9XZVREmjkbT1I5B2JkK1MRZqfzve+QUlsZ2d/nXrTTkcAIYXe2h4EQnB1uTI8lVE1GEvpER3vOEhOnVuiMm1B8Lo15BwM+zW8qxfsg1NLQDJXIN9HwJb3vH01113qS7ywhatq2sffTIQUbaqUJH/dnjyfOFa+TsHoeH+EvnWTm0UfBSYskoUZ9oir333jQG+NGB+HVGW5X08mLtwlffyYoyjWWunu2daaIeZm7vHJ2yOX8zD8tQJwKNnVJha3B/6NKwPC/35yvrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(15650500001)(36756003)(6486002)(2616005)(316002)(8936002)(6916009)(8676002)(66556008)(66946007)(66476007)(38100700002)(83380400001)(6512007)(508600001)(2906002)(5660300002)(52116002)(186003)(6666004)(1076003)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGdEVGVPODdYRnc5L0k1dkVpVWplSjBwTGF0TUN4YVZWV2REcGt6NHdXWXNL?=
 =?utf-8?B?REs0eStPbUx3RlRXaktPRjZVekloejMwZFhBWUpnZUUvNWE2bTg4aU5hZEdp?=
 =?utf-8?B?dnliNy9YWE5tRCtiMHEyN3VlMFJXbDhvT0pzTXZaUitEa2Q1NmM3OXU2WEhH?=
 =?utf-8?B?bytIU3p6Vk40b1l2U0lkTWdPMlpQQ3hIci9iVzcySUdZUlV0cnhSRHErTE9x?=
 =?utf-8?B?ejVLM3RJeDIwN2JBYllWQk1VNVFUajFqTmpsTExaeGdWdFdORWNodFFXR2xu?=
 =?utf-8?B?aUovb1R6dlltR1JMdHZ3L2lYSmR3QndXTGtLQytkSVJRdEo2Q24rV00rd3hx?=
 =?utf-8?B?NUg1TU5OTzcwY3Fnd2tEMzE2Ui96TnVSTEtsa1BpWnBsOW1kM0VGYkRFeWF6?=
 =?utf-8?B?OXgxWmo2VlR6RGlCckUzVWFDTEFWeWhXQVVhMlNlem9KWEVxWFZQYjZYaWxr?=
 =?utf-8?B?UndpNklvNDRyaW1BbUd5TXpnNlMrWEh4UHQrSXMzMmxlRlYxenFIQkw1eUxG?=
 =?utf-8?B?VUVOc3lNK2YzUUFpTndkemtrcTRkR0lLV0tEeENLNjZoM3JrWW16YjAzMHFs?=
 =?utf-8?B?cU9OZHJDaUY2QXg1Nit3ZnhWSUg2aEg4c1cyb1NGT2NaWVV3NDZ0YVYyZDYv?=
 =?utf-8?B?TElieUQ3SXNtVkRmeENjd2Q0M3hMaTA0b1JuY1hnbXVoR0Jpa1I0ODB0T1cz?=
 =?utf-8?B?Q3pLcGVFWE5xUHU4TXQvUmNGN0NDSDN6WTRjcGxQVW5Ya21lZFB4QlhQYjR6?=
 =?utf-8?B?OGdZdi9DSkpSWjc3T0dreGtWa1hKR2ZzaWFPL1lKSE9BcG5PekE3YzErWkNk?=
 =?utf-8?B?Z2tEd3dXS1E4dlBXM2VyM1RMRVlRakIrYlhUS1IrQnNtZTkrcFJYV0VKQjNy?=
 =?utf-8?B?dXdRbmZuRUpnUGNMWEFTSndtS0dZck5RdVVXbVdveE5mTExBSlRqbytlSGRR?=
 =?utf-8?B?WlpYSlhLYlBuTU9kM1J2c1FZQ21RSWh0NjQ3KzF2VmJFNnpyNUFwSmJJTmRC?=
 =?utf-8?B?ZkttMGdFdnhwV25leFZIZWU5TzFVckZaSnhQYjFsV2tXSVdmRGcyMFVpNktv?=
 =?utf-8?B?NjBWQWk0dTNkZzVXazRTZk1qSHVEODdGVXJrWDBWVVZNRDFLcUxoZTMrQnZz?=
 =?utf-8?B?S2NRM0NHc1h1YWJBVFRqWUpCM28vWWtad1dORnBOd3pBTjJiNk1CZEZTYkJZ?=
 =?utf-8?B?UVZlWFk4SHQ1Z2Q0NGduaytWK05EN0xNcUVpZXRWQVVyZ01QRnlyZW9JL29k?=
 =?utf-8?B?TEJFa2oxMmdaSzRKVHY4N3grS2N3T2ZHd2tuWDdzZEhiM2o0YXBBVC96K3dL?=
 =?utf-8?B?WXhqZ1VKWmJBSTQrOFRocDRMSHkwVTlPV2dkMWU1NXIvUmFJc3lCL3pna3FI?=
 =?utf-8?B?SXlCSjFyeDZYTnpHL1ZjeHQwTXJWSyt2endWNjhRRTdBcU4yTVcxRzJRNXhs?=
 =?utf-8?B?cUJIeENEdUhOQ2ZWMzZXZm5QT0NhTkRyK3dJaVc1VEwyT1F2eTlETlNpZ2ZG?=
 =?utf-8?B?WmtKUFhuSU9zWUJ0ZVZib3ZiVFY5d2JidGFibTlEMVZWWTZ5bGNmZElmY1Zt?=
 =?utf-8?B?di93UGorMVYwcVlzR3FoQWV4dVhMNzBGSXVGM2Zsdy9yMUJPS3dBYzFlZjky?=
 =?utf-8?B?SUVkVVVRMWdaSkY1blRnUnVTWVRpdUhRUlRwYjcwT2xPU2tVQkh1NVZYaUZM?=
 =?utf-8?B?NDUvTktlbmd1UlE1bnNWQ2NMN1B0OFZzUEVreWVwWXl1bEFwOERuOGNyUnYz?=
 =?utf-8?B?WWNYR21LQ1lVbi9OaVh6RitBdFExQWpPb2l6UnBkYmFHUGxORGtFdUpSWmYr?=
 =?utf-8?B?Mkt5Mm95L0RJc0JNbHA1YS8xeXVEZmNReGZKanhiVGtFS1FNMFJLYkFVbm9G?=
 =?utf-8?B?cHVZajU0MmpBOWwvQVhEYTByVFpFSXh3TmpMZjhxRnZoQis2a3pXekpSalJH?=
 =?utf-8?B?WkpYNDNaL0lSWlhHZGZoTkRCdENEM2xsUWpvbWdWbWZ5V3pEcDVkSkJSMmtE?=
 =?utf-8?B?Q2hnKys3YVcveUZHNUFVSThHUjdqUnFtK1Y3alJnRFp5L0IzVVFyUW52M1Zk?=
 =?utf-8?B?ZHF3b2FSYU02bDN5Wmt4dldveXFhOG4zNktKNm1BVEJLeVZ2Z0hJSWk4RVZm?=
 =?utf-8?B?aCtKL1VuNmJyUUtRRmZmd0RCQXpiWk1Vdm0xWm83aThqdUxiYncxKzFtTVJ6?=
 =?utf-8?B?QjR3L3VTNjlCTDhBMkVYSlVuY3gzTUluUWE5d2daRWpRUXRXbXhuN2d6cWcy?=
 =?utf-8?B?anhPdFZINWoyR3E2QVd3S3d5dFBlVUNXRlJNekRTQm9Lam5VWUlSQ0x3YnZI?=
 =?utf-8?B?TmE5OTZiLzEvNHZlYXc4Y3ZiT1k2bHpoMU9CZmdMb0VqcW91cUJOdXFYaFVr?=
 =?utf-8?Q?5jy9tOflUor2Ijkf/nrjXa97G4OCk8wx9DrZySpZbQosL?=
X-MS-Exchange-AntiSpam-MessageData-1: T8Z1qg+WnM6f7qY8AwrC+gwq4LzAHRMqKYI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8969e6ed-9c60-4051-683a-08da32c3981f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 20:28:08.1222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjUJjsjkBiGrOWWAPhP7mqqEQsNcGsag9E9+spw2NTvzWTXoSpA8FrR7SIsheNd1F3Grs9V6wC+gGIS9FbetZ1mCMj9hZ8eVaRKFpC/9cu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3859
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_06:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100084
X-Proofpoint-ORIG-GUID: cXcy1EkFgPMUo2Eofon-O1Quf5Zn6Lu1
X-Proofpoint-GUID: cXcy1EkFgPMUo2Eofon-O1Quf5Zn6Lu1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Warning limits in xfs quota is an unused feature that is currently
documented as unimplemented, and it is unclear what the intended
behavior of these limits are. Remove the ‘warn’ field from struct
xfs_quota_limits and any other related code.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c          |  9 ---------
 fs/xfs/xfs_qm.h          |  5 -----
 fs/xfs/xfs_qm_syscalls.c | 17 +++--------------
 fs/xfs/xfs_quotaops.c    |  6 +++---
 fs/xfs/xfs_trans_dquot.c |  3 +--
 5 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f165d1a3de1d..8fc813cb6011 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -582,9 +582,6 @@ xfs_qm_init_timelimits(
 	defq->blk.time = XFS_QM_BTIMELIMIT;
 	defq->ino.time = XFS_QM_ITIMELIMIT;
 	defq->rtb.time = XFS_QM_RTBTIMELIMIT;
-	defq->blk.warn = XFS_QM_BWARNLIMIT;
-	defq->ino.warn = XFS_QM_IWARNLIMIT;
-	defq->rtb.warn = XFS_QM_RTBWARNLIMIT;
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.
@@ -608,12 +605,6 @@ xfs_qm_init_timelimits(
 		defq->ino.time = dqp->q_ino.timer;
 	if (dqp->q_rtb.timer)
 		defq->rtb.time = dqp->q_rtb.timer;
-	if (dqp->q_blk.warnings)
-		defq->blk.warn = dqp->q_blk.warnings;
-	if (dqp->q_ino.warnings)
-		defq->ino.warn = dqp->q_ino.warnings;
-	if (dqp->q_rtb.warnings)
-		defq->rtb.warn = dqp->q_rtb.warnings;
 
 	xfs_qm_dqdestroy(dqp);
 }
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 5bb12717ea28..9683f0457d19 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -34,7 +34,6 @@ struct xfs_quota_limits {
 	xfs_qcnt_t		hard;	/* default hard limit */
 	xfs_qcnt_t		soft;	/* default soft limit */
 	time64_t		time;	/* limit for timers */
-	xfs_qwarncnt_t		warn;	/* limit for warnings */
 };
 
 /* Defaults for each quota type: time limits, warn limits, usage limits */
@@ -134,10 +133,6 @@ struct xfs_dquot_acct {
 #define XFS_QM_RTBTIMELIMIT	(7 * 24*60*60)          /* 1 week */
 #define XFS_QM_ITIMELIMIT	(7 * 24*60*60)          /* 1 week */
 
-#define XFS_QM_BWARNLIMIT	5
-#define XFS_QM_IWARNLIMIT	5
-#define XFS_QM_RTBWARNLIMIT	5
-
 extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
 /* quota ops */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7d5a31827681..e7f3ac60ebd9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -250,17 +250,6 @@ xfs_setqlim_limits(
 	return true;
 }
 
-static inline void
-xfs_setqlim_warns(
-	struct xfs_dquot_res	*res,
-	struct xfs_quota_limits	*qlim,
-	int			warns)
-{
-	res->warnings = warns;
-	if (qlim)
-		qlim->warn = warns;
-}
-
 static inline void
 xfs_setqlim_timer(
 	struct xfs_mount	*mp,
@@ -355,7 +344,7 @@ xfs_qm_scall_setqlim(
 	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
 		xfs_dquot_set_prealloc_limits(dqp);
 	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
+		res->warnings = newlim->d_spc_warns;
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
 
@@ -371,7 +360,7 @@ xfs_qm_scall_setqlim(
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
 	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
+		res->warnings = newlim->d_rt_spc_warns;
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
 
@@ -387,7 +376,7 @@ xfs_qm_scall_setqlim(
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
 	if (newlim->d_fieldmask & QC_INO_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
+		res->warnings = newlim->d_ino_warns;
 	if (newlim->d_fieldmask & QC_INO_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 07989bd67728..50391730241f 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -40,9 +40,9 @@ xfs_qm_fill_state(
 	tstate->spc_timelimit = (u32)defq->blk.time;
 	tstate->ino_timelimit = (u32)defq->ino.time;
 	tstate->rt_spc_timelimit = (u32)defq->rtb.time;
-	tstate->spc_warnlimit = defq->blk.warn;
-	tstate->ino_warnlimit = defq->ino.warn;
-	tstate->rt_spc_warnlimit = defq->rtb.warn;
+	tstate->spc_warnlimit = 0;
+	tstate->ino_warnlimit = 0;
+	tstate->rt_spc_warnlimit = 0;
 	if (tempqip)
 		xfs_irele(ip);
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ebe2c227eb2f..aa00cf67ad72 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -597,8 +597,7 @@ xfs_dqresv_check(
 	if (softlimit && total_count > softlimit) {
 		time64_t	now = ktime_get_real_seconds();
 
-		if ((res->timer != 0 && now > res->timer) ||
-		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
+		if (res->timer != 0 && now > res->timer) {
 			*fatal = true;
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
-- 
2.27.0

