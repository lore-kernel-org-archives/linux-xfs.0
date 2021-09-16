Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A365FC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8888B61248
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhIPKJO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:09:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17292 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236376AbhIPKJC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:09:02 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xq6u004611;
        Thu, 16 Sep 2021 10:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gJO8JnetRleLU03vrHvnFP4BQsyA3kLdPcd92hakySo=;
 b=Rd0sxrD62AADO0qKLVUPn3E2zzyWoHr3OJmocmz3tEmVBjgDxOUFqj450PGv1A6wlwU8
 wBHpGOsJFFgSFJ+iJBWD0oWeGRLfAKtg/pFLFKehWsxCcHBfS249CuBO4KWiFCyNlCIJ
 sa6zHIACgfBpIw21I/LtH6GrgHOVC8lOpRZ92M5s41yPQb6fD8LmbAJ879i8Iyocx6Vf
 0C9u5vx19nDHfSNSSZfvvgP0wWVCGVah1AOaABXhPEYIhBUycqPIgxI5RGSAncXcHh9W
 kqVp34EOrDiYaHT2QpCKSqp1j8W89jO900pv0Fse2v4CGO8YKGthPU6gSYnAspmi0A53 Ww== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=gJO8JnetRleLU03vrHvnFP4BQsyA3kLdPcd92hakySo=;
 b=Apngy27/XmdTEoX1vG/30aPb8Ythv/nFBy3M4BamiDyoHavZHSVjElNX/DjE0kz7mtgP
 IXUIGVZnl0efUyUOrhAnyCJ2H69ca6BDLMVNlR3wOw1ppcVqTI/iBenAkOBLF1rT9wsV
 z/Na+7pjStJFIa73cgOqSvydV3VHpitqSlTSCqngd3ZoEmxfRsSDSKr3O3iRIFJ9ElmJ
 GC2dlTc/e4V4HXRKmrKBCrXY4O9dq1H15Brl2aBs5b41szinqk7q7//bl4oOP+g9yHCo
 1gRkpOnDWZGRHNiZIh1H4/IWV/VU8F7kFh04m8HkaIffuLmIiYWMygS14tbI7oukYHI6 iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jy7jr40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5is7171556;
        Thu, 16 Sep 2021 10:07:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3020.oracle.com with ESMTP id 3b167uxnuy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjR/x73QLP5MvXHcDXkVIXywDdLTSecb12OXxkCsm/G3ICDxoMe7l80318aoWs3cELjwESTEW3soxI52YlFCwTSZxuLDDgMkJ/HmWNoCwKOTIytW8M8TvG+pC1/e6zE5pfWBfKsXGGDooCcOeh2r3SWjMNiXVuTP570OyfjdIctCLVp4y+5+IO+C1Zm8vl17CluDNxWu1W2IB5lyetTHmr53bhj1Kw02Et+KHJrfr4eEKWs79YoF+Z2M9dn/i76YScmbVqNmgZjCPBTtHATnJSkvP9U1OQJVfmNATqgXzqffbGeFrbgCdYM1CoiPidk5Rnj5pUUqhyZynOj1YFLzrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gJO8JnetRleLU03vrHvnFP4BQsyA3kLdPcd92hakySo=;
 b=SCt/VOI3UlnP9irej3c1QLKAVo66laJCGYBVTOgMCldTvwCtHeU0eMxoBIaIaAKR0MPeFLt1ezSiBcGtoNNFpM3RBOsE44zgSZTG6xpoKm4//Mj7eQJN00yL27lMM0/7mNnbXfbAB4q/oRShEAilwViZgZ5o5FU3jiKrPpofs2rBoDIh94qrm7M36Y1R/aobGLnEN+4OCaHgkcXriJmqU0vS9FkdVn5MFsxITs3+KsdLXc3ouizDuhTsMXozrodPY25BrHYrwY9utXhMsYrnzMIi8i/gs3inAc9XM/dFqAS7kAew0K9OqYDeG9/2PgbzFk+Eu27Y90cY6Tb4uzdfgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJO8JnetRleLU03vrHvnFP4BQsyA3kLdPcd92hakySo=;
 b=zbpWz+T+s/b5xjxO5oY8so3E9Tt5qQIlG00gi2AtHozPuGme13CKnYPWBYqed77lTM5hOODlG+svcj20ScAsanILoZ3AagRoTY9MXksSVCRXG8M4ISuywxtxCnSCUEg5Ega9JmeMf/h2embxNyNwYjeP1itmkIdlhnq2gK6QsAw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:38 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 11/12] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to XFS_SB_FEAT_INCOMPAT_ALL
Date:   Thu, 16 Sep 2021 15:36:46 +0530
Message-Id: <20210916100647.176018-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbc2bf57-69ff-4473-c9c8-08d978f9cffc
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878EB9506EF1482591E5E2CF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:130;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvqUHFhlMqJCWrYmlOrJlCrLy7Xay7sxD9yvREMN3pN+6E3yOl/l2cyXmq2eFN5f5cjW5DsL/HJ1+eJKScCi+1QXQ+P6dcubDmWE1h2Tl97Iu68iskwHrkCqd/VLmFcT1/TONGYyf7OhoRTLmedvSShp+wbsx/PBTa3wLNS2yUxrnV8XIRKLLO7+G3C/dHbiWbuv/7RhLTRrIyvr4BEq2xV1nb67OKpM1hbFXcN8uP4yv1MiYqC6tw7rZj1QfCvPQfeP5IDcQ9iolzgZsZnCaFmd1JJzwsQ1uVyOY7qrSw3WukTzeiUZSH5D7SxGsgFyWhAJMrZ3gkzNiJjvPYXcBP0AhpzMd8RMxg0zlmxp4NKzfZYrNwfxGXVK8+hNvFih3/pPypht/P5AAvI/DAF3xvNJgEEDNaYh6YUYxYzy2upSFBxqrm51Q/LufuDH8aIrvbsrk/ZR/787aRSrzeLknoh0jkO/y8IgpNsqOLDIFamTiS+7U/k+jK9cwrDmUZLKmyfWU2Ha/z6RGh9sL7EuwEnM2f6oxwqbc5AHuBKU9syl7liIXgHvyqIBUElzOKwfSSbUgOZ7PUUqEyXxe8KoIGUKhqJNIvmsPTzJx5LTIGcKlwrv3GlHlyWNK5jrUvSt5H+chJl1emkvGu9yhoToXezCsgabpioBcrpTKF0MbXg6tBuYI33NfHu9MlaQ1hB8vqIu7R8Njg0NduDSi3DwPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7kKnIc0SJQXB0yrjNnX3I0ENKF5b+zWmS58Mg3cV3IxHnJqBqctDhYzngYZ7?=
 =?us-ascii?Q?Lnmu3sl59oCoO3sfjbtlq3YsFfUSJznhGNjbaXKaolL+sSXpGabxssLuHcsI?=
 =?us-ascii?Q?IYfaKrkKbsJMqjVjoSN+ByBHMNJET3gtcJyKvCbQ+xDTIZOc+MXymQqjvjqP?=
 =?us-ascii?Q?5xci97+fnTNTerFqZY2Zwfx6Z5tZ1cWy7xPfQqi0jWg6VOUCBufpvFrwavvk?=
 =?us-ascii?Q?htb16mFOoDu/EOjYfFekYEg2CyI7jYJfppUL28mxvBtg4FkiL8pymwwNSHJo?=
 =?us-ascii?Q?1YVECwt7jcsXal2MLMpD9Qg1lvVDqWFxmVcwIxRHYptndNK0mtu/OBQa+QNv?=
 =?us-ascii?Q?AdIYcsVh5Khi0PtU0oWUh1WRVzz9PsCXqBwNrjgTIxPl3vkXs9cYMaSIAf4A?=
 =?us-ascii?Q?aRmH3rUK3cgpF9NFeCedIMiK30wtWbcWk+f8AHIr1aM4XCdImgXvw8M7EZMa?=
 =?us-ascii?Q?6l/TzyZA0RrX30bz8TlvrnUWr/VooMD7imB+e6kz1UFnSCsGPyEk16Cme9Qa?=
 =?us-ascii?Q?J/OVHRwF5tvaK5x2HeHsjesbOhVZX9/jDncfIbqObi7y3hon8NAnmbJlUfPW?=
 =?us-ascii?Q?Vyaqox1CkEjzku0hcZEu1n8idA07o/MEsp0o2t8aSCe0RN9pEcWHSbvTojDF?=
 =?us-ascii?Q?Yu4NYwBC20e8dZSpjrjpIv1/xGi/bK8zwFRhkSiwCQy5GsetzWOFu1hur8vj?=
 =?us-ascii?Q?tuGmUAHIrZ7DgozE8iTJbC1jH6kE+iLKpNtHaT/VAtXjqyWqqCMQgeup5Nn6?=
 =?us-ascii?Q?uWAi0M07D0lSP4IHEPs1W/yehQvteK2oNueM+CXAd9F2i3N+lTB65+8av/qy?=
 =?us-ascii?Q?EDfL1hNwMmCviV04k4rLUaX8VDEaBnzEoyzUuDU3Zg1HZqztDd9ahjT1J+LX?=
 =?us-ascii?Q?A7A6++em2qPglPLYLwUxf5kYkxp3hwtwEFbELyuJAx7JasF8HAJHewOWeqUx?=
 =?us-ascii?Q?J0UvtbLRqorYePD477nJzNY8L4BhAFAiN/qnGsV6O+r4n7+Gv961Xn+20zzA?=
 =?us-ascii?Q?74r7DTs0KIdIJuq5M8rniilvRdZBtso/HlJFGbWzEAu/ZPhZZZNi1cvMjqrN?=
 =?us-ascii?Q?MpYhYSc02fgsajOSaAxp58lXFj12yMl3B9QfAsRgb+Jg1XZ1jJuYQewRZ6X0?=
 =?us-ascii?Q?bQNewrjRPPdY56LijOGpwxmj8mBplH7LmWD9eE3a7CoyaIC+OEOhyjXCiwsf?=
 =?us-ascii?Q?vF+9bLps4W+vUiJVKOUZBojN6dKFIbcMm57TDTKihEKlh390BZUtYjw1vJb1?=
 =?us-ascii?Q?G0NeZRN2dksC2AdMJb6cKwBkt9MuBdrlNEIWiyS07l+sCKPzjKiXYHxraD+G?=
 =?us-ascii?Q?KU+Tk/kEILBPr6SE8T+0HD3B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc2bf57-69ff-4473-c9c8-08d978f9cffc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:38.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sg66kAm86Cs+ds8I6M9vPFL2YjsTaaKdc1uRd/WJw3+adiWsxgjbyfOm/n9fwoQDatPa7ygazN1aP+9BTXxmow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: bVQcGpIV2SYzxR-3WeM-GJ2jxSVXqcqJ
X-Proofpoint-ORIG-GUID: bVQcGpIV2SYzxR-3WeM-GJ2jxSVXqcqJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported
incompat feature flags.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7373ac8b890d..7d08bb0fe510 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -395,7 +395,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_METADIR)
+		 XFS_SB_FEAT_INCOMPAT_METADIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

