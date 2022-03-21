Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02069C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344310AbiCUFUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344374AbiCUFT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:19:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0F33E3C
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KH3BEQ001841;
        Mon, 21 Mar 2022 05:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=c/lx11/gHIVK6FDz75L65J9fOCcnJAbqsmARSxwEjE8=;
 b=yDdg8qrsR8pNFkhZgoL4vGzODZ1jqlG6fNUscrktS1uEwPoV0u3S6WIAKisOSgANV0EG
 Q6ocLv0j9tYWAMwhNwEbzTFsUOSIYA++Tg3JtoiT/afIhWCrBfNYiwm7y9uacIlkWXpd
 MttfEOvO0rk1xLcu1CKJIahAlVoD1v6Yug+1uxyP8bhFeExW1O+KUrXOr385VcSbfyg7
 4F5yuHGK2Z2OaZNkdik6FaFHHRCvUA4XaO5ErYCH+UR4dsCxK0VkC/1/8nPEYyXXRNsT
 kRSnMgp+bGEI4D0l4fxwEXIXsMAJYfPGrix5UMU0kXGaSE61KfKwcos8nANodKkZrSPp zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j508-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5FwNu057894;
        Mon, 21 Mar 2022 05:18:26 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3020.oracle.com with ESMTP id 3exawgev17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU0i+YuRx3tVk/aeUbLR4bs/Xqx7vdNXJIgNPMCkaSW9p78xyplUURTEUwRjt5Tt0obfo0C5AiapeUZeIdaIhlFv7TNnQwsHotX2bOyr7semn4w1gxZun7p4JGpMHSxrPle4vvvas19uOZ72NS8190dq9RoaKQOxYa5tY2vXkCIK9vh1leBNYrsCxRfB4onKZBCyPgFGJX0qKJUlykfH48Z3DRgg0GWV5lbW47HQE8ws4jCrrDa2squpFKS9k5SeBiPU36pXN3x9j7pGRcQw2UwvH0lVTm+06MYmVkFt1jGtedAw/qqkgYC8CY4eI15RWTFmWTPKgvwvV1v0KZXwrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/lx11/gHIVK6FDz75L65J9fOCcnJAbqsmARSxwEjE8=;
 b=LMFbWAHLwVQ7QFlkwE+2JVSon2O6F9WOCKuTHruCEUk5vgNmnxS+mlayegF7BOFrkNtdg1CpA7CHbqrWJR1UGJjDI7hHqEtxDo95A+MZrtw9Ms/SrtSvvuf73MfZkn1a62QezSabosyNZYd91YdRnCQZYJA871hgT6/I4D2THJ7VLEyfYvWhG5s/1lkOwRSbnYp1M6Sl0aUaB+euKAYIv1Pox/Mm2nqpSouUkaRmEQNKEF7G2N7Rz8+Mjw4ihFaSLTqLXqSPryMXkw/UWKxStKSGsRVfYSkioWg4KrlGdS7/5jev8L/BjvrVmo/VHBj/+czrUqFbvlzOY1BYV3Cngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/lx11/gHIVK6FDz75L65J9fOCcnJAbqsmARSxwEjE8=;
 b=fwQpFjIqtJLGKNnH4B3cZglHdWtOxwVsMTpL2/qH7MWQo58b5vZW9zQbgVa8V41iHB29wWlEuKklZo5+faGRyxk7TEmE4Wpuc9LdmetEtVK6+hoeq6FJWE8kiXuPZYTwD8xvfXSH4WKfV1gq0agbuDRN0Pqc+va43wSjpu0wP7c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:24 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 06/19] xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Mon, 21 Mar 2022 10:47:37 +0530
Message-Id: <20220321051750.400056-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b319201e-388c-4c25-0edf-08da0afa3901
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB553736468136A8CFA59F4F19F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFkjnlEitZnPbBVII+1gbrrSCpC4TL1gTPnUxqaIxtM/aiXqSzmZcuN1phrilEnXRNpM7VPQGXq6oeP6uwNLfLTQmPOKA5hkM+rMWelMA43tkMxEuJfSUCbMAWgQJ5aAAoKYWlZ/9tgAAONu3dZmaO2UOVO43BBhp3uxLlsGwhQvII+SYDG2KYTCw7DFz2NV/zB7rC7EECbAujAvdE2jKBJU+gRdNVAeOelB1BY759GxKrU7nQzKZ1JqH1t6wUO81sB4XOr4iZHxLAVCXW0NSZC+EmtFRJZMlhmqx+CIFmeN6fkCyiJCCW+4oIzf6S42cB5gn4ieF4IM15eZ0lO7MjHue0butwctwDyMgdwv3Aavf8XhawHTagnczL1M96Zt0NI33AWB8kVlIUz/2/8jf0QltIUA6fUerwoDovCsEQaMJKUBQhAWOCwPXflqlk93+/9eGUBasgvuU9W4iX2sJQfho58sDyo0rADQx6MiwXqrtWiwfrL6p9pWQXt0vg1GmpfTFLSWi0jgc7QB/Sb0OMwjGtfSXENNMf7fFLM2HHznq3sg5BacK7Z/qqUaw9OPHruIrQcCDU9Ve7F6aXAJXRvwV+cckH8yyJ3ab02gfTYdQT5bqH6eIX6BsTAMnE6tiFYe64JRYfon/ZpMFVSTiIkNXHYYNCU0tf28kOLbe4eJN/+RJgGD7B99W7vIZ+2plIHjenC13xmNslRtmmoxFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(54906003)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?43P/M6lzr1lr6aHRJrNJcq8M+0AvWbVVQW7/fDfgxZ90J4qTvpJ2Al094GED?=
 =?us-ascii?Q?+jJDo2uqwavFdlmaUpMnWCLNDjuTrg1jajyhF1+dolMeb8FA1tlcIBzXiDIG?=
 =?us-ascii?Q?s3Zd85u2YQg4tS2rliJieinNlKjTgCWcsznifQVGlNJ1LdXA5KDDZNkfFF9o?=
 =?us-ascii?Q?0oYMpVzBiUhk4zb91k1F3+cVfBffmhl2Hma/Ga7CBBDvk4SVMsvChEHkQjMO?=
 =?us-ascii?Q?OeDROh5DLQjY3vOd+fnlzHLNYb8K3K78LE61CKQZpxvsDNO9d0iI0XGE6Omi?=
 =?us-ascii?Q?TRCpYV6YFsTQ6ued0nccbA6QElBBxjEefEKCjKHTxxTFqp5A2RSyXczZaNlj?=
 =?us-ascii?Q?+CjyA5SjhyIew47ubEhSxT3ZSQSE8U0AuqeyKxFr/QHXrNESXSrFxOMlUQUb?=
 =?us-ascii?Q?SHPyymxk5+yMweeETthnq5RUNt9dSNdpFdR36BINURF6NODvysSR/ycQWSM2?=
 =?us-ascii?Q?YIgXgX6eN0yU5NzH6eSNWsNHwebJa+E9uStMFVeDsfWyv6lVZwXae01AqGqC?=
 =?us-ascii?Q?mWd67VQkqbdJs9l4b0uwiQQtpYYK+Ol2Bw/72ugcnVKg1to1y5ZlUwW8u6JJ?=
 =?us-ascii?Q?Z8L6MGpSjcTfvFVZuphoHhmFeygNLLL6eEpbJRrtE2IX1EuWv0odr0xKxuYy?=
 =?us-ascii?Q?lTCiHFwCnrV/yVjNXvHFpN7NV/P03Vl/0YkaGY68YNceKjV2+vJ8SFaLXLLh?=
 =?us-ascii?Q?qB2ehGsIX899jTnW/khjo2y+o9bfa1B4ZrX60695BTxyvawUmYOLG/DRcWQa?=
 =?us-ascii?Q?SQg4AwbMlk190tCi67rrihxC59xRdvxR9+3/O0bE2SU9xnVp0Hl9oaowLZtb?=
 =?us-ascii?Q?n2FRwaJ7aGfMKkjiH/CDNZeahGHJn1SUJR/EIVsWNJMUMv5AkOw+hL+dPfDA?=
 =?us-ascii?Q?EWfNAYpL5R/L9/T85C0aPFhz1GV3BUotjOHLF7Be3HjhfhF0mxA2gh9DoE1x?=
 =?us-ascii?Q?FrpHhIZ1dBigGOBY7kUprCMVbo7Mvy0yd8INntABfBUxg2B9YX0oZ6AzEBto?=
 =?us-ascii?Q?KnepohVtHBRneTIKoY+rpeKJQfQ/8UAopAuT3o7Do+z5yo0VstNdHYsvpeZE?=
 =?us-ascii?Q?Osv4xEW4ZY9KL70Z/xBKvaqwdwEBmg8YtxVV8sF65Kb0jczIRmXgG1Eqb5XU?=
 =?us-ascii?Q?RwbbLB25zMA3YNyAyqQ3MEChko3VqgE6vDoFZinJz89oNW90a3go0iUP7Bt7?=
 =?us-ascii?Q?OkGKJQs5EFh8tPQc6/IOfLw49k8XPi8OSOc8Vib1v27YEHtDrOLuFolN0xzo?=
 =?us-ascii?Q?TY7/7fuZhMs4il1a8IIqTuikIg/xYh5mgoTbT0JGx2Wvo56WjUP7pJOWsO0U?=
 =?us-ascii?Q?COd5ILIvomeGifmVPF8llfUeVNryRSP66Dat7LDr84/39eLAshwIaCdqmF44?=
 =?us-ascii?Q?SJbDNEtf7+atl0nCBQNeldD4elMxFruBwZ822K/GbBSeitH1kPDaA6EjwOjD?=
 =?us-ascii?Q?h8E464OSzSDMkeG3TFhjXspoiVbLwxr63Cfi9Co/iO5mMkWzjz1nPQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b319201e-388c-4c25-0edf-08da0afa3901
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:24.3162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YZAE8eLAm+xNrUJ6qwDLVPwWRQouB6Pb0nDwQ0NIzfYGLyg/3XYki6QNC0yCkhw3A7Fc1doESZBAec8eVogQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: MeTIIaICh_XUdFoybCMpFiT9pAnrmRWT
X-Proofpoint-ORIG-GUID: MeTIIaICh_XUdFoybCMpFiT9pAnrmRWT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b322db523d65..fd66e70248f7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

