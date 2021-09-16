Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B3EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F093D60EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbhIPKKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52624 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236504AbhIPKKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:43 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xq7s004611;
        Thu, 16 Sep 2021 10:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Vg1wM4LVDF2e/d4l5BWibKLCXSvNdbzvGucpZO4eyzY=;
 b=0muGDxAx9VKns9AZx/M2b0tsHFAC4rmnIHQSRpKANc9wOBtus8nMuNcPOXqTK4XF16rP
 HA7pyskR02kLZlWluq9V8u1npixX6qbL4KV+2ODMa+qmqTyflNuDCt2B157bbDm5lyna
 abvu0bJR1IsqaBJ/RA1VPOMm5Yr/xXAcbBj9Z0h5aOWgdZ7T6amD2QQsRd882E5Jrc4m
 UzoVKPKsGtI8Np2VY2Zqc5Rp8jPewCjUsvNl6fas5wj6b59H/9EDEW7PPVGf9V/TvQNG
 j0zhJnRAj7DKbO7MZnY/hjj63gLqd+iF2Up9DgaTHAU+KSEEaPa5gJ2aXSLJOntJEJ4f 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Vg1wM4LVDF2e/d4l5BWibKLCXSvNdbzvGucpZO4eyzY=;
 b=fLZM9Dc9T7CvZ7eAZ8zHC9ippk9xKdd/qDjY1Y2Mj5iOUFJKdPKw1yVliiTXIfW6eCBV
 fL8O/p1ILVwEWM52JwB/VzvzSF9Lc2XpAtVKBdD8dmIqKHJBsXJXjhbNsqBW9tloYtv7
 rYPnQ0BX+Mvr3Bvywj0/Pq/fO1d+YP+sT5dsg/q3zgqzq//fVQJFMs9GOyoXecB/OReq
 de4dmkFEufzDlJjC0Ij5++UVdUt1KaPfBc2NPCFaMK5f4LJWlF3QpkDaRmLhoQf2IE6X
 0Bk2EsHP1qlvgJhAudj8Ki0cZo6RMYd+n0npeJBUH1VhoPI8w09QVIQ06PPSP9ojfMqc AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jy7jr9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5G1d030707;
        Thu, 16 Sep 2021 10:09:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3b0hjxydjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMeTEAxaHnGRXJ8jNnVCYOuFWg48Y4eHaG+IgjNaARlwgIucLN5vR/LE7Us+CYZSP7RjIGOpYQC5ZmOo8zYPJMlavijC/wW31vly8T8miOSVOINcxJniCQcd/CPtx+XYaefMDPFB4hfPy9eoJjWPEtEq+70AQLpx40oAqg0BbTzT+7jeQ3Ol6VNMJpXkeOkUK3gdx0+v5OS4OF7odQkdbBGUSf1/NWer+jk5TdlUGNmG9u59q7UtTsJR00pLat8SvtfQlsUdpUzA0T1gfRtH9TvgefhVjGqHMjnsG0mkXR3YDe50sq29Vv5LzzX2ZKcPPFNTns2cd1nrut9vN4Znow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Vg1wM4LVDF2e/d4l5BWibKLCXSvNdbzvGucpZO4eyzY=;
 b=TmU1Kmaesrd1uQSJsPmGPK27RpkNkj0cD7fdx1Ye4BmJYK+faim4t1W17QbizM7iJ6373Q7h1UfKrHhZq4vLxVhatn6Uh6MKurxsUO9lGEieS9aDge8ISJPxTF2X5wPwKHmpb3O+cn6jUrvMLAG4fGbOCYcsZk0tJ8v8LfUnleZZtCU5GO2stdQWvy7XbrNAo+cXS/GWwxnFvmKdTV8PfmVmkP8FNNVtea4+UNjJrst9m6WDY8+61iY1xebhd5n8kQiX2tPYW53Mg2cxBvjvPjuzqmDBKSM4UITS4MeNKoQzjTi8Te/AleYsgJWSKOdYZ1UPrjekDXfKg8DDugJ7Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vg1wM4LVDF2e/d4l5BWibKLCXSvNdbzvGucpZO4eyzY=;
 b=qVr4VyXsAGGD+/z2f1GfWcsSvo2eMmTMtTEfEk6u2KrR9ksJbYNCTnJWfBz2DEZbQHJdz2bunouWoC7zgsxtLkB4twibmvpuorDpBwqpgkPIiiR0rnvYcWsy96DxloV462PYAo7BVdahzQQ/mw4W4Xb+SadeBYIga7+lwIUnwgE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:19 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 13/16] xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to XFS_SB_FEAT_INCOMPAT_ALL
Date:   Thu, 16 Sep 2021 15:38:19 +0530
Message-Id: <20210916100822.176306-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dc18bed-c10f-4cef-d42b-08d978fa0c30
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB47489C4012195950149E1C45F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O12eWdhzMAsJUatfDO6o1bnwqJx0KRQbuFWeNhj8BKnUd25L1sA58XwOi8hI4vYk3+mzFgoEcmhODb2bPuWLePpoij7cztDtwppLZQX5XNZux/7W0izdnHXwtkbwbJls1u78/nB8QkUibZ0+R0C6VIC5Eblj6+wH1msKv0HFqMQwHziUr2Tv1yaEIsdCYZxJsXJsE8PGqJFXON+h+7jwJ870flbDVl/AyGioP+kIa874kByV4J4BpFAHo59LXx7uSjdQogJZCrpWwsl3XKEJGMQ7eE4GqE6/erUeli2OrPO3tGPBtad8OJWeLuipXmMxsRGsJzqnzTtbC53q6zJkw5mmNGQLBLFNhFJVhtXrEORC4ViGZrSsOK+pr0euEede+qks+qHhP5qVsFte+cNVK1Y3pmlh2nfepRIxY7MRtYirf2kSzV5j+huttXLZczyUfEAVGMY0jL5OQHESbr6GwQB6KgJL6SVs8R77MOPh47dCRiL8RTHCQJk3AGn0GDigLBgXn5dL2gjaAfPNk0FszjH43UEz3BSWMlyN0hGjSAx3RGHQAjM0cy1DYklP9+oBqax+/NLrHU0mSPCZI7yV+YDUt3YHwlRd0KMREcCjO6UbOwBWPf/+ba1mwfA3MwpbkrhFv4HJk3sIJzTRbVjP3XMhE5kqWNPmEhbVG2fSCFT6UdPcap12Ho9N4B1OV1BJ7CUQBb9XIgYrj9iSFZMSRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(4744005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n8sMP5oDWEnxbfNZHfsH0SKHD21VEzfoolJ/nVMeyR9+eR2Mpq7ZgKHPChk3?=
 =?us-ascii?Q?XtyALN7LYi9ueGzJnOvFEth6a5ws0wRUWSyuXucZgtxpNS4FPaU7NrLftzRJ?=
 =?us-ascii?Q?rsn5NalRVyFHgwV20zDshrxW2D9CwNr57nespnmxpJtZu5ZzELpl4cPUqvK1?=
 =?us-ascii?Q?e0EwVX7tgWPR7lWblMT5HEKAwCBRWdtRYK1le3QRu6fEXPFJBQrMbXvxN8Rt?=
 =?us-ascii?Q?iML8ge/5FMizH9fN00zeWvGIFaZvTFMfUfo4e+ZcClPEViL4zHztGCOSsULX?=
 =?us-ascii?Q?OoqCsBnLn3FvINm56gdjZNP/okWckpOzHNuOxuqxpf0rzNIDjvuV54mO2M6w?=
 =?us-ascii?Q?ZhTIunJOPUHrnLbR/h+f6b3rYiz88JNbMLNCRjzHqpUBwc3liUPS6b+hXrfT?=
 =?us-ascii?Q?Z5kHmHqYIW2wfGPsTXvM4XLtoOpAnpcGrTujA0tEgZf1ZTcvCFnHqg6aMcq1?=
 =?us-ascii?Q?t3UyuLmw+UF8ZSbcW1LeFaT9I7qlHbhR2QJIPKHF8kB0x8979c6DRSjLa9JQ?=
 =?us-ascii?Q?uoajDuGB3um5h5y2Ha2xo957uImVzgjMK8KvCUWFNHHrMOyGJcnVkGNeBG5k?=
 =?us-ascii?Q?8Ay7mV0cATVokQxY6/vUoCTRWpob0D+m/9foYGoUKlnd9aifq4kxXhRSyE6p?=
 =?us-ascii?Q?O5huZoW3H2K6Q30bBxkDCWfytw1RZO1XP3or8L23RyGZCJtWPUsua0NmYvIe?=
 =?us-ascii?Q?cnYSGkjIlL6Hm3cqDBVTpDkJvrdGfkcLfNoeg9LFnG51be00L/QX8W/zfL4e?=
 =?us-ascii?Q?KQDrjZM8SG03tjt/G2BTvUnsmAeZrIXCkTfVLM3CAuamabofHW1FxFz1vA26?=
 =?us-ascii?Q?TyRy3svzcQ0ZQRsDSoSZ6Ifvh4p1H+IefpOUsBjUoxI2WTavQl+52Evf5+lh?=
 =?us-ascii?Q?A8eGbrhw6U4FnCVJKRUkaH2Dr1OghOQj6kC/zjJl5+wy6HLMv2FE2DAUa+CG?=
 =?us-ascii?Q?N9t8n/3+iauLgBIh+ai6/6XY/6vw3t3m0TfwjNblXwQXupmQMm5cQWonqV4s?=
 =?us-ascii?Q?K/e1YxJzHlHfm++8u7otAAu9Q2N2Hm/TVfGWY1VHWl5ztkjlXKeGvMl6Lfnf?=
 =?us-ascii?Q?ICW/QhYKV19m3Qgi15PTqNVegoAizCemOcDW9exF48ntEkCq2EYM9/TFk9Cq?=
 =?us-ascii?Q?DwEQZbUbos02Ub4EDEs51eupy3EnuVOK5BXcBCrVgCXwNoDbfoTQClctXzVq?=
 =?us-ascii?Q?KHZsa57kSEbrPe/nGYJ43CaDQir9J26WdsryAKFIZfUeohj4mEptz9e9YuJk?=
 =?us-ascii?Q?oU0ceLv6qfEKnSBiaDfmsJcYGIEuY1IhxL6ngKkhVqkrQ6fufnNnP9SF43gB?=
 =?us-ascii?Q?L6t6pf+kM1GIM6d13ZpbCPe4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc18bed-c10f-4cef-d42b-08d978fa0c30
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:19.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvSh/tOrndAkx6Y9iizpsuHu7A+uZBzBLqSpduYOqcqxk76hY1A/8BH1xIxa1EZcq+kmXRdIyCIKGx+RKZqydA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: aWDWzmF6WrGXjJaNpQ3zgA4AzHHm8Z8y
X-Proofpoint-ORIG-GUID: aWDWzmF6WrGXjJaNpQ3zgA4AzHHm8Z8y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9971300a..a97abc4a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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

