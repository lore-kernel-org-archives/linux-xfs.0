Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF81EB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjGUJq5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjGUJqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEECDF0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMXZA002054;
        Fri, 21 Jul 2023 09:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=WxQ3rU/98LcQN8BGtfGwuT/w/tKOVbV7UOfxEVvh8xs=;
 b=p1iY4AHEImJLJlhLnEnDtPNuUixY13jh9LzBS+BqoPxPDNOyYaiwZgwWrpASb8G0z7mt
 4RqmUIgiFoKGyK0WG34ogOoomyKab0ddboH6KSWT9t1iIg+wgMB3Mr+C7huC3TlPcoB+
 l350NFTsqMIbfEqbYZ2ZPLRj9zsj9u686yCY4dSbkbyKILUbv1oOqg2Bxwr4tuk5IKM0
 PBXcZw09BfDlXDer1OF55Qdx1MZ39zW7i9W0fNlPtSWVQ4y0jVX7lml59uzPXERGJGBx
 O1cVM+IY1jMFOV3orvpao1+YUzWkPKgbyKLT1uY9Tg3sG+D7bwtM8+wS8N/eOB0hmKRE HQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run773kmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L90J8T019258;
        Fri, 21 Jul 2023 09:46:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa91qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxDBKZYwllejsJrATZmjt4KiPBHpCsCwxbv0JOb4GM9ebzmqSY98r+UwLV2pc3t11NrWXjTGT/zvTAHSaJV20UAce2HAOpXtceZBT07JMfPzgoP9spUrmwEfint6ov+KwmdH2pNksyWWNjZDHDpRmotdbxrjJFaS7UfFMobAz23t9rAMTO6VQ5SR/gwOVASQvxSTlspcqkE3f+o1Ho26iAtDT+5RfFWr2zkUYLpQILsqo6EX8i4bERRKyyeEQmZ7f2JM6giCZ6qK3e99uCcm3W0znJAY4UUC2fL9eChycS2nGodwzsHM2Q+OpXCXhAxJ9xvs8FwiVxf1JLC8IoE5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxQ3rU/98LcQN8BGtfGwuT/w/tKOVbV7UOfxEVvh8xs=;
 b=QP10tdnbjoRCXLGIIkjPYBdZAaWOTZ5Y7ojEHdQ6l3kb15hULx4Uu8A05u4CzKi3BQ4dp4jMwjN2t7L9lli1Z/eyXXORlpdp1nAfITYHTa1KUG6xof2QthjQzfAwmNsJtSLO1v3OC6W8+5aCAKJr4f2LvymhRodq3TgLTQlDKFQt+lhmUw6gpfLVCjhLe+dSUEezOi0BWJTjLU/1DFxc+2/RkUJrOIyH7YsEStcwZ0hcPQp5g1vnmNMUI+ed41zoYx6v2JpqzPm60adKWeHiF6wX6Uh169akj/yWHCSVzLmaxE77Er6sC7lbW+TCvo1jTO8e5KqLDa7YWImFVn7USw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxQ3rU/98LcQN8BGtfGwuT/w/tKOVbV7UOfxEVvh8xs=;
 b=xi3VKW5VDN3gJ3xvqJdO/2UiZba7Z85UOGNvnO2XEconIqtLbrpKvQnIHBA2IrmRZVokw90ppcdCave3RHjI3+Knzvl+5j1Ne/bkxmYIODPYyXPkPErIU51NwY6NB4P+x3vKDZ6fHd0hSrPDsiyVxJkOv/sPiLzE5fGmAQt8oxg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 09:46:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 09/23] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
Date:   Fri, 21 Jul 2023 15:15:19 +0530
Message-Id: <20230721094533.1351868-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0167.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: cc4739c2-dd7e-4909-6bf4-08db89cf67b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4/Zaoq65vH+Uc7N9iqvqFaksj531gNwc0iZM8MJgloLTNr+2VZNLxOxgUN7yI/9eXylnLOX8vf13iFZvPwfmGmnWXqpZV+I7Ux9WwZY1XdEh6xp8gm/SPSM2WTzz9dPR9pHni7R81CTxvcabdWqVOsF8OqYUpLSkKiz7aNb74LzrVuWX2/yWustv0pSQjWbGB09MbW1/JEuhOoF4vga0fcwSnH7uJrgdXxPsA8O6FMkk1qKAwgeBjAk0UAXo55p3MgG6XHVwTljAOzOrCavDAyeXXcQNB72jnpcOP+lOfjNcEC2EaHLjvINUAgMTnBOqWqoIK5lOgfwye+pZIYCo5x+U5cPmZEOlOOG82ZC1al470iKbP1hxsjd6eeanRzPtVKFMh+6ETGSQbRNyOUhcwDyCbq3HKuBSXvZ/OKHeksiwYMlbBWkn48K703u4SzEsj31W4U78zu3s/M5zE5DhK37JWP4LvOHt+L3mjicOPOmGvv2XFLFKPSYNdEtO4JbIy3wnbZfqTsSH00hyfsU4lnQ6uf2ztFnZficLlA8WJ75mMHfD5Yn6DK1aaDl0Eag
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(1076003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(26005)(186003)(41300700001)(6506007)(478600001)(6666004)(6486002)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3OQpBK+t7kaysAixE4jBUUp84ENoFRGIdNrqqZg/hU8cdh62C2dDTHYwj1CC?=
 =?us-ascii?Q?3Hf+/V3ZuD3g+YB7f2Je+aukIE9iu+TBgH30Slyig06oLcNY0wiZ4EWAAjuO?=
 =?us-ascii?Q?KqPKqIVYD7i3Gv+DzsMYOnutl48HBoP+YxawXzZhLEcsJVgAF1S/ntEucX+V?=
 =?us-ascii?Q?LjeFwEaQueyTJAZJA9dC1xFiP50HDPDXYW1G2J78TXLc3/KKQnAeHykH4MdM?=
 =?us-ascii?Q?pq7i5Ws7+EHr/XNgBOBoPMdk6jAi5LydZXuEsAyhhWLyf9iDXxQ1nMWVBfif?=
 =?us-ascii?Q?rRuW/iKPNLzdlJ7UR4pp1QUlhZPdOFx2xYxUG5tSPAcbGIRKcTA6SgXiMBE8?=
 =?us-ascii?Q?s5+T0+cly6xFFGiOkwJ7it2R1iisAyKbnUzdM444/TfY9imcpEbnbQH0G5Tv?=
 =?us-ascii?Q?S/SLTnidyc/q27sHiCjp9tivstbXzEUzhWRCU9X+7IsSvwrwv5i7OYYLoCnC?=
 =?us-ascii?Q?vVMWUvY06mR2iMxgDsLjGEaGRfL7Q0zZerF1HXGBjIq8oQX4Yh5kbxDg1sn8?=
 =?us-ascii?Q?LMIj7zEZNARpeEZa2JPGTMU4R2w63MarLt0pyCj/4vfQXQxRdpCsiIYoH5oA?=
 =?us-ascii?Q?n2A1bjGNl5SslHJTS7qwPfrIudMEz6bsYMAqEuzRm1UujN14LGWr5+hT9JKr?=
 =?us-ascii?Q?0JZKo6MDQx3ZiNKvL65xkPt7oVcKlSb1ghFwgV9zLwyIL7J6ta4ZBJyvSwsA?=
 =?us-ascii?Q?KiMl4s08MOIZtMhRyx9WTaOFpGVJ8d3oRWJMmEMr++gNsonty02ME3tvd0tE?=
 =?us-ascii?Q?HQyCeObOY976KppkkCOx7DS5aeSJjxKpuGq4HE9xpQIra6PoK5nma2ArwnBE?=
 =?us-ascii?Q?8ZAKbQG3gyasP/pM3PQ4t9/1jCoeLUbdQDkYSNCb24aiBpGml4qwg2/ks8Vl?=
 =?us-ascii?Q?JaYK3Mz8Xg3Z6qxtATMsw5MWk3LkDFmgJpTEkHG11YDqZekxsS2NNxaRdzl5?=
 =?us-ascii?Q?eW7ytj9jPYsn836kVbH8U5JQ4I4f2Lakz3IPNRpEX7CmNkYiPOSg8ilJ9w1C?=
 =?us-ascii?Q?QIzdL4/P54PLtnCp7QlpUELZO1qDGdRzLK0CX7sOUQNwh0hcLdb+U/c8j+Pq?=
 =?us-ascii?Q?2k5gxb4pktgWkFbk+gnLBdcm7FnrnJeQy1ol9CrLM4hsYKy5MfZvb6DzILD6?=
 =?us-ascii?Q?5DEiCDCPMf23jpPx0biR1D2k/FjycHYlUs67RivmEN+MJuU4lPPG3Fgo0bIh?=
 =?us-ascii?Q?E9XgQga6DXUS+DXDgVqHOWBJufO7S15zM0woWaObqtyW80nzXw7gWcYx15e3?=
 =?us-ascii?Q?Lbfj67AO1gUmEAv8t3i4WQvBuCAVreSvf/tgxe8lJZSl78qtW1JHuuGU7kCC?=
 =?us-ascii?Q?pIHx4YeizX9KeNqyDuuPXX4lfz2RHvwLC3+av9LPDf9fCRW55QVoWnUweceE?=
 =?us-ascii?Q?mep53cnlrnWbora85JBfnSy8fdN1cexTCpAiOLoWJikHpzJc44lbwXLl47Ne?=
 =?us-ascii?Q?xK/kkzX8EblWSxStjHM14c/ksXddOZh1728SxUSy6g4GhaN31hhs7ok2uf5M?=
 =?us-ascii?Q?IyqZjAbLVCVyyJs4k7h2PA0S6evTcLKcaurojx9HzZJnqzj/iTFlNkPkhp/p?=
 =?us-ascii?Q?ptbYFIcboHfEu6tqaVc0uL6RHgoAjonrxIKnXY2fEykNiDd5ZNEMYaBKIj4R?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Cd/tYOjgFrJ4eXrQHBDExrvb1S6FEBr2HgpuecMhvtrKXKCOFlNrE+nifjFTYAmyrGQTL7d5owGqsN3S51fxXzGL8OhJTLfUDgl7obkO3AFuHoLSH4MdpkjmHL4dirWbUFBqd05BLRnz7/RIoSVUsMHbJQpX7ML2EaQFgpPVP98KHo2I8eGjHfChaT6eSzXkfCGN08/You2QAdGYgTmQ25tDL14Nq5NXlkz1+saCacmxb0p+6AgzRnaQkqwFoMJEqn6XnXaDZVqxnpJ5cfc9YpgHOuo3cU9t85O9WuCQkvv1OoZJtKiMgQTQJkXp8IxxgDWXTFjApWgTfPR+LYSKDBvMYPIioa/FWj43B7w+rgQbXfQDTm8I7dKM3IoOTcn74woBs8daBj3xiC7CuQwxopyQL23wyGv+woLBLWB6P8JVFr4aeLjvmpdb38KToTRtaN99r4syWLMCsuSiOSrJTkwSV7KqimCYl14NNIX0z78VWILFW/Mpw4iqOChV1xbqiSwP2F3ob1e8vtoOe8SmzFYKGCiEaP5TUv+5y8RODSlQvDukn5TIKQZAJoYBr4w+T0ea3iFj3cI4RGxuxc/T6tlh/gcMFJOwAsSheSAjNrXCU3raifuRga6Bzie421vNlxmyJdf3BjyW8XkknDmoSz3pJ0DXa0i2pyhsZWIKYP1jPSUujchBGXmtcej3rS08VCnJpxUeyD3d3CjKTQ5YuvH4i38zThBxaAAUXsvqEbWCAakVlLCY6s5PMcSlGNhAxRknMID7AnX4+zYWjwW/NeS8DwNgb7n8C9QGNPMyFYM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4739c2-dd7e-4909-6bf4-08db89cf67b1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:49.6809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GcQuiXdnvBlyRj2C/ZKlZ4OAGAf/7Xxl7xmNZb+2p1d+1BV4Texa8oLZRNNpPcaeIXX/v/jFx9kdKGTpgdAS9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210087
X-Proofpoint-GUID: gQOe457GaCMEmuueqmv2nElvk--OMAke
X-Proofpoint-ORIG-GUID: gQOe457GaCMEmuueqmv2nElvk--OMAke
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c             | 2 +-
 include/xfs_metadump.h    | 2 +-
 mdrestore/xfs_mdrestore.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index c26a49ad..7f4f0f07 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2968,7 +2968,7 @@ init_metadump_v1(void)
 		return -1;
 	}
 	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
 
 	/* Set flags about state of metadump */
 	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index fbd99023..a4dca25c 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -7,7 +7,7 @@
 #ifndef _XFS_METADUMP_H_
 #define _XFS_METADUMP_H_
 
-#define	XFS_MD_MAGIC		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
 
 typedef struct xfs_metablock {
 	__be32		mb_magic;
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 333282ed..481dd00c 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -240,7 +240,7 @@ main(
 
 	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
 		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
+	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 
 	if (show_info) {
-- 
2.39.1

