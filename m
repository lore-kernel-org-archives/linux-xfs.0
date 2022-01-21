Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC8BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348379AbiAUFWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29220 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348636AbiAUFVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:19 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04X3H009028;
        Fri, 21 Jan 2022 05:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=egC8BHPpJt0gOyyfk6xj7fYFczohuIYeJRQVwBD5eNY=;
 b=QaVXmgNqZI2u9CTmgTJRTsmyfv2c+hy5M76qqcv3Ri1K9TsKCVB8Jt9wESjXgWkGYwau
 87IZvEwT63ybxsk2Ov4FNLD3Tu7bS2ErsX5ShoPDOAWN1un0cyFPxFjnd3zEB4mnwgGR
 TqLwvvcsKLAM4wlQA9wZ0uITBJzgtDNveESfzhX/X8k7gfXXYocuUKyA3USZPmBsi9cv
 wRrdVo7ZuAYklgcauDS0QLW8gyeniHdJwO3O3WbJtGxlLlBbXesZDGn3t3K4D4L6UcE1
 2TGbqgPR/O7trUn12ikHioAAkBGLYZSMUl58YDZ5M+6/REEAe7rrajzXfy+Dbi0Ucrrt LA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykrcqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5L2Jd033915;
        Fri, 21 Jan 2022 05:21:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3030.oracle.com with ESMTP id 3dqj05h439-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvWfU+BVMzBLWNu8ysvj8Pjd8Sr75A9wV3kys1X9kAVwr+RXyMI7IW4GAXu9glrK2RO1v8csZy9R+K4qjsT1WiEf92rXC25j9ZOdlWs3CO25VGi7wPV15nkOGlC01hfLTbczEStT9DJurNFXLafqFQ8xfqkYqLENWZviQVkPWrOcbcfvEY3EeB/0ovs8N+y9703cL4UWf+Bpz7HROspnESpGuqtZWxL3HTqqWmou7vQKgcglPCs1dCln+AbpBckihuD2fsazUcK7Dd/uJqT4p9Q1d/jslwsKLqVFr6AK19wIlUnAtxCOeHKCnIvvEmwDH6Lybn7zXFUTMn/KoTwHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egC8BHPpJt0gOyyfk6xj7fYFczohuIYeJRQVwBD5eNY=;
 b=nJ3USHZu7T3UXFL8l2Gu0iBg6MACxIJBbhSD83CpPfapEMYvX1urpAUABr38vDMjzgR0Howpa2CazHyPiZX2jUcUpJB8OcysIodMvDij2HB8H3bLu2Uol/nsa8mqcmBf9Gh8Mv6jbnJmgq6tnZpnjYu/ubxpFaSiYi7Uz3g/D04cF/1woiaC7KFZPxDy8PMskhslsd4mqyk2WkyblCrRgi44vxxITGsUjT4ROoehZgCWuqtZjVaNE3rSoCyT7cEkJUUuI5AOp5AbYYw4ggsAcXUpsOZWkk+FWjNYcT9MyMHGTLzfC32D4jvwyST4ht7WCZ3bfg13FfvSgWrfXEFIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egC8BHPpJt0gOyyfk6xj7fYFczohuIYeJRQVwBD5eNY=;
 b=EmhJAnIw/8yFc2+fx0EXOQpS+BL6OvKnX7aA8P4SY0I1KJfERz0FK2TbJdHWt4hVc9Ln5fm+4wZUEPPAjbNJuTRmxUCcVsKYjC+BKfoWZvi52u2sJoy7v3Zcl8Mw9Zf4HWU9rGFafj09uuqfhQuKxoy1MBo+WI7KrrbCAC1XVTI=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:14 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 16/20] xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Fri, 21 Jan 2022 10:50:15 +0530
Message-Id: <20220121052019.224605-17-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d55748c7-073b-4af4-c5bc-08d9dc9dd83f
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5322AC2A27FD6DAE25292CC1F65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mxVJf3OZJA5xunmUNcsSRh4fm7JiH4lOfTuZmLUDnKN3ZqKYH1DH2G13rgVMdpbcdJWvOxEB2lVTImw6oQdmSTXxWTnT+6RFY2rpdLU9Q4O51waJ+3pz7KNrUGatCL54pHn/ROMnDSOOy4hp2c0FsKvWUVF39ziMeR50z2yCppLoBZLk6z2R08L2HutlIbCEnv11G/g9XalUQ+XOXej+ygOZZrzvxoeP0LNK1qHw90XhrSDb8e7n8//hLRuvo+VO+6cLIgIQj8HbYsnmwdpkHoqrszxW32QZIQYRA+5ibYtzGDt3cXvpWVLQUob/gkt0CiDEwTikKlcvt3bGvV+0Vu7R25PZUXkFyGIl51klrYNc0s/T0NRcKqb0Cx/RilnZcaleGOAd3hmuGepgjFpian/psNi2xfICagp+ZeKFjLh0Ccf9tEvVSbhv877nVrCoGXUzE168OVuesXhCzSr9M8QjKfkyGDwfRIJr+ps5jg+MbX9mbiP2Un+J7VMxl2W0YS/ccntj3KbgQxF+Jvp7MNbWnZFJM9nOiIB6S/uxOQ3J9a33bUzC3R2m56mbEaqXGUyq7bB9cjWkhvnxUKdXDo5Idwc/rltKSb5wmGWfNI31GzQoKSo1DBagRRksjL1kvbEvWD7m9dGGNGvXK5njmVrV9UaOM1hySHQS8gxf3Nh9pmGvuEI5mMNFbthxeL+Ny3PXzlagxBykXMu+FSUX0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(4744005)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Wogn4WDr2g53Kk9vQSR2mSwxvIcyPs2KGI0De69zh3i9Q/EvjqdruCUFQvH?=
 =?us-ascii?Q?z6hifpC3CL+Bxi14AB/agX2tRQCn0OD7dt37Iu8NDrAP1W0UxW2V0loOP73+?=
 =?us-ascii?Q?V8ZFONbEElo2YOWAeFNxVzIdRkKSiWf107BynlZSbV+IQWm7KZDwpZEkrl02?=
 =?us-ascii?Q?M18bSjXBbH53TU9Ss14JqXY6tYwvj38vdjIRxK1Ih7/2aD9w+Q23j0t/yLx4?=
 =?us-ascii?Q?UCN5QzHKGdXkYvn3VSfmIwg/Am+9FpWF/HeGRgS1CVZmnoE0Tc73k1r9mCBR?=
 =?us-ascii?Q?L2QwQwfEdYBBMV2atZLeO8d13rEbiqXWQhDY1B0E58vHwqavhWpXu0c6076t?=
 =?us-ascii?Q?uY0bbRX5tM8jGr+NGMpOL0yEK0/jrFDpBfbNVaXEtudwX/vY+jnoRYi1PiC7?=
 =?us-ascii?Q?kYHIS4SsGeKWCqtAD5874DYf6tlAsgP1UxZbTvNoWEftNCj+FtdIiwGxKZMm?=
 =?us-ascii?Q?5UEll/dOZ0536h+h0aSeqowCW0VioF+f6h+rRJJm8Z4c9qgcPg6c/1mbDZW3?=
 =?us-ascii?Q?bDUpjdmeLQ9zZ74dykgJVlSRUtyoJJCe+62nhToByOIBE3MfB+XCEbuVe33r?=
 =?us-ascii?Q?xUMiG+P7nY0pIsMLKAp0f0oQ+5GlcgPDmWVozjRtIe25R+G+dRKLk1ZCmsS1?=
 =?us-ascii?Q?v8VW4jMUjMhH7wYZ42r+ysTMvo7U+rkLuWoj9VhT4Fgl3TOpRJ6UYrd0LoJU?=
 =?us-ascii?Q?SINexBu4/7QfxQjbqOMqwIYKq8NY7RF7NOoc5Y79cr1Ds83qI6xp6Idiz57N?=
 =?us-ascii?Q?/ToLHVViCnTuOkIv3OV1xBkZRZDdzJIbcEoJajMerJVqoLigyhqZR1le2org?=
 =?us-ascii?Q?QZHKO9uGov2lg2Vl4wCymWLF4LEcF3fQd0OGtR2Ab81fxoL7TlAVOhipfGLc?=
 =?us-ascii?Q?llFfe93ps8b30EpKpqreVwkIdljh1NR0uinbaWZKnVNM+ytQXTxODDo4FhR0?=
 =?us-ascii?Q?l6OsL9bT885FkAJ/WWYKCzhytCXpKZngwZytEVRM3VcXvksRUBn7c3/BXfeZ?=
 =?us-ascii?Q?6JvJOWXzlDAftmX+SR+ZKo6pt3WD3F3HNLfOYZsAehmVgdqWumeaV5VKS1Wk?=
 =?us-ascii?Q?4etCpzflYv2n04BIgtPW+E4rtk5PDqWzbhWvldUrWJ+kCLbNOKWR8a67G3Rj?=
 =?us-ascii?Q?68TO52J1wpptCkS0JRTGQu4nufIg2wQAz6CTOK5BxuEhOH+EasdxdoZL5/A6?=
 =?us-ascii?Q?YJ9Dhax4QYtxqmRR4K4QO084A0cNtbod2ttAMBFeveRVa4UyHO8tLeIIo8S8?=
 =?us-ascii?Q?vssjXhAFkxqPAqxw50AoqOCoKXwWtYl9xz6dHpMDDs3mYGmJXTBRvQdWRMHo?=
 =?us-ascii?Q?hc4ABydqDiSynPBtN8yhSv4LYqqoaie+1PsiT8xMXxXHnxo6dDdMnzc+VzOL?=
 =?us-ascii?Q?cPJ2RJbyknF6JIGjBb0+Q1j09BZ/KI0e91FFxlZhWMQpRK9j0m56r8CMXI6D?=
 =?us-ascii?Q?2FrHcwwrT0fpK/f6V9R6MT0vOeRUNEr6JuEl6yelPQMB03fO2b1Lu/34ZhXY?=
 =?us-ascii?Q?OAjbEndvfVL2bSJg6SMcHHTzV45Z1bdm80jWieu6Z3CV4JSxlD4J+LFQ2eLr?=
 =?us-ascii?Q?1yhZBIW7d3K7AlacBwRP059hsWfdXSRomodbaVsed54c8fASCaipPqL1ca2b?=
 =?us-ascii?Q?aV4yjfdiFl65CWMAEYnQM5w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55748c7-073b-4af4-c5bc-08d9dc9dd83f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:14.8482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNiZf6YYV0gUp+zxFdZnv4OJmGudXVCGpqOXNbM+25YfJELhYQOqsVSX0owJ/Sm9WCds3iTSwqL5Pu9/SRwvXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: YN1QiarI3yittgaM08JTaEtbCWst7Xb1
X-Proofpoint-GUID: YN1QiarI3yittgaM08JTaEtbCWst7Xb1
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
index df1d6ec3..b7521c1d 100644
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

