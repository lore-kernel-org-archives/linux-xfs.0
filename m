Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2310BEB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjGUJqc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGUJq3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D774F0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:25 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMeKY012879;
        Fri, 21 Jul 2023 09:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=AOrjB1JhGn+GoPVPYI/JEwYnShJMyRp6zWRqRfOxdzE=;
 b=LWWlmgsXei9iEXolrWBH9haYg6eQ/zD3N3ka0NKsg8XegcwnUqzEr+DsngETHQsFn2d6
 cv6J3BZy3OxBAYY0x+dq6HAKe6UfponPyibAPZRVMMeMkBtndmr6ycKzMKQChT0w9eGH
 jM664Oucp1oZJ2xm6HPUczuiBowynVz5C7fsnZIdGIDAFijwd7BVi8hce+ixCkWDum3L
 42v29LyHI6de3J+ip2H2oJv6i/3oQ9VR4U/qU2aaJzafW/U/9A1JCt73SeKh7Fa/xZXh
 mVt+0vTv4EsYE5ksvdTmksWC90NVZD7WdD3g9rWJH5F/w4u5xJ4t5time7a2+ccuEXp+ TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a3ne0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L85bDh007817;
        Fri, 21 Jul 2023 09:46:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9jw7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVrZxlj+518gGZ9zctron/ODh25pdmOL/SBxH++zIMxHYuOJ10CiWL+jUyMlYXUMHF7Ntu9dMx7skawcICC1LZ2cfC477z9YhlbRAiNPpFxHmiy+OwGuhgE0MwG5dov1+wtfdemP5IvRYqf477bH19WI4dZUvPuxNU2sVAgUMshejb7OJdbkoA6CnPdoCogmsmmQGizo76tYe/RNdAfzJ5XrKxtRAZsXIDWiTCEyZrD+TfKI/vsWBqIiFVFaaMhlFvj2kpxhs82IGD2+CkYGU4Ti+A3i/u1J746bakmbiTdRBv/obDXyi0TkwKe1qzzCW2T5ek0RGzgkUcd9PPvHfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOrjB1JhGn+GoPVPYI/JEwYnShJMyRp6zWRqRfOxdzE=;
 b=aJmyG1FS1Nob/zqKfMJ4kawsU60vkU4K9ySGciUeR2aRSLU8TC64IuHRvFCbaF0SpAK3bMfK0JLxJBw3Qb29GDloUiqoj4QIBzQf4DmW8o8nN+YXWy19tvsF8mumEwAF9b1wAPPJ2pAb6FClOU1epFTd3BaLHtN2D8XbWAVXSRg9J+gY2DS4GK5FGjz+2rr/cYmlAGT6jFsyPhSaS+gAPHjK2ySYTC+441gA2r0uNqxC0b5JM3+IcWivtD8uP7TtkbtEK4TQ+Z6eF8P6d5mfV65MKiQt8uqLgsWgEIq+7UniNmhCaFzUWzRkVAN21xYaW3FrYQ59f9na+KLSQU1k7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOrjB1JhGn+GoPVPYI/JEwYnShJMyRp6zWRqRfOxdzE=;
 b=z/JPH5U6uawHO9Ewcoc+15e7k9i0M4LkX/lzhvDxxu7DKqIOR9/YYFITaT1Z17J6Bi0RcA6YpcICTdXECmBJMWDUDJkcVWm64n8ROI3VniT685y33WoCm6uAD/hJ11bM7RZsvynkz5KQnIhzvk06VTn0dkKwQykLEbHQGWjf59I=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 09:46:16 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 05/23] metadump: Add initialization and release functions
Date:   Fri, 21 Jul 2023 15:15:15 +0530
Message-Id: <20230721094533.1351868-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0159.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::27) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: cd13720d-409c-431b-c081-08db89cf542a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s4bk2tO1TQZsuPL1eatgVLTennEhxGOE6HLTotAeNUosACJ70wi5R9EsAL4Xl8TG58DdPrcZB0Z8kZtBQnksAsfZZfAT2MlJHpC0++pwtAeleuZsg7EnbOCj/EXcuEHMVRYjFWfD9jmNJfcCOI4mNw0LfQM7fggZXgQHk/3zZMKFC+a7anH3kIIh8OiRbekGa6Meul6RJmouDON6o2dcLHq9sa8Utrq24ND5YYxeB/UAoxUa7bdc0NCjJKdtHnUD8xBNU9uB2GzmOvrsxFcMNC5AlyWfzAmVqUKH3+QYwLUcItd75ioGo8p7Y/WxPLwJAsR6doMWJYW3No6upU4UPK5Q2nmRPQJOON4MJPmBY09SGLPGAPquy2A7xFQX4QGxAoSYWuay9SvzVyTkny1LgZYXOvtzgERFJFLq9GUt3RM4vObr73tXZaYTsGk+baiYLs004VvdVC0z1xtBucmzic48gdLnVyv7rTgbwBixmH9UTmMur0MuVAudhjlhOd7L+2Ovv77h66iM9gFP3v7zgWDuAZm8lS69Ulm8xtrUAGXfEU9CpswnQFpoMQESREL+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(6486002)(6512007)(83380400001)(36756003)(2616005)(86362001)(38100700002)(6506007)(186003)(26005)(1076003)(2906002)(8676002)(8936002)(316002)(66946007)(66476007)(66556008)(4326008)(6916009)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MdSVML6awR5D67uUttVSttUFItf3hDRD+VMfwHpDRduXmOcg6cIAGcmuhg7j?=
 =?us-ascii?Q?mWUjoFi/hKlZdMUEyMXZgj5qnIVESI92BwoGalwc3FDDCtJo78wlyi91+SNl?=
 =?us-ascii?Q?T9GhpAaNEaWhvV1k77WK8g7a8YDZvtKXv1Gk9tLSCDCt5f/UB4hEMSA1wU18?=
 =?us-ascii?Q?E/bkcGKDJ/wm5Hztd2jviLk5VehUsRYPD6USDxfp5JFyG2b/xFqC2hYzSEFj?=
 =?us-ascii?Q?qODdARPycjCYcK5xSaWHfmCBs3H/ECUHENrs/RCMdbsFJn8cqvLSmXq8Uwji?=
 =?us-ascii?Q?Ozt/7fYg9MO968WampMC73PbsI/av/caFysJehxCGEXz/EAakAJPm9FPUrLp?=
 =?us-ascii?Q?f7Ap09oWVTaUFncyoUkGqALxIU/U0EK3//9QbjvqJUELnjDX1heXlEyU3bT8?=
 =?us-ascii?Q?p+MmbpFfwve9j+sjaWpweD2pKjdf8jMmEY1+A5ICHfyQj/zy13BMkQsjD03j?=
 =?us-ascii?Q?x4EHceEiKIh7s+CqT99BD4SfPePtoLza4GIUHUeQXj+3ql1wqQaFf6vGsw76?=
 =?us-ascii?Q?qnZnn9RomyIulPF3o2KSQYGBeBArH71ObFVxOPeL1hIhQoxVW2/sLX5bZVvK?=
 =?us-ascii?Q?6yUk9QTjCioGV8Z6ahT4lU7PTn3KC2XpM7ft5Qwizy+QHWlXPcf45SN49hXA?=
 =?us-ascii?Q?f7nNedgMaLH79QHN66v9oZQPrlh70dbYm6vz1hE74L8crxxJn66oe0m9qf2p?=
 =?us-ascii?Q?fe5f57z9qKYIK6nxTK2BDFp6UhBsMOVZpJC/z27Qzw7S+fbJqw7qEewjspCd?=
 =?us-ascii?Q?PXaqENRFHpcZFhytq+zn26yoWnqXdg0aqE3SINDmWo2CnkTnOTP5qc3ISvw5?=
 =?us-ascii?Q?icRca8L2R05goF72h0tB19K47889jRtVsed+7kejdakZC1/7DX4px6q6D1CQ?=
 =?us-ascii?Q?CNDAaPw/XhzpofBlY0JDyKYxE8CRDPWKaUx77FHSE9nssElxu28i5we7HU7z?=
 =?us-ascii?Q?wvQMkJJlUSGVMqh2rQx2wRuaWSkmrW4NKDB7TMI2o1J5hoOojbIbUGz50hyF?=
 =?us-ascii?Q?FVRRLNGMzHsE3kxAh7eFfYx8TKWjo1tMhx/xf723VRCAsEdYH89LCyvjZcuE?=
 =?us-ascii?Q?iLWWZHVHVlD3sWITZFVywL565LgSvH/0QaPX6lHECkMZgiBfjZKG2eLrL10Q?=
 =?us-ascii?Q?dt73Z21R59yzN3GbiL+INBGzIIawx7glh+GsyZBQ0QSf2HAE16OccDUHLF8K?=
 =?us-ascii?Q?019TUlUJSChLD6Gxzj+NDf7s67A07xQW2RSJP8rd98oaaaB5LzYzZRzQQvqC?=
 =?us-ascii?Q?uunBjCIpZbli32Gi0mGdq1n/m2QdBkZBvsNNrpH4IA7qXBNpxDyqBPcg2Hc0?=
 =?us-ascii?Q?4gr3X19AF8vj4TgRiXrEfytqnWSRKfyq9nz9qwR5VNXHdEYNGuqsdyiLDLuR?=
 =?us-ascii?Q?T+69WIwtAYPrZtxNc71sdB6BuAuwEiQBCMymcAt2ujJZSCQDH4OjceBVtytP?=
 =?us-ascii?Q?Ph62XHxLb2RUYroYrT37RiqvKOTfisGuM1gWXW7cgeQHBFbmp61X2rATEOeC?=
 =?us-ascii?Q?RTivkc5hF+Z70h6shpJ5VbQV8MvRvps1dCpFAjWt3K1lPyU3oaBAvpS5cJFL?=
 =?us-ascii?Q?89uHIzAltUll3UID4n3p1r0HI6Dfzsr/WDU/1IMj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QlMKlKYYdRV6kTf1ebTtvz5k3UYaBI1YZzHocr5R0RqBgISdzCOQE2PVCJzEGW3iYhduh/is0+a2epGXg9dbUXmGgLGQF6sqBG68Q5Nq1/uVOfpc+45s2/wF7Pz1rRM9HBmkBuVbMmOc22pSbQ0fbYexq1bOTReA1Esj9g8JKAnmGjp7gTP9dPBrzsWm3KOkjHBNqRpDR0KvWFzVRIZdghMWMCuc3kizvjy/Zw8Ko/CU+nwKCkR7FGq+iM9Atb7lRh0ZC2L9n0uSAJWAMfWdASwHjL86SSyRaGUZWgk/YnXBdRMVuS899dGFrDw8srZBBX0kwSXEcgkLaoaYPybcas0lP6r00Q1igWUdYdYnwfNHqJA0abaabuczOD+J/fQfFp309h0GmKQH5ZHcGsTVmeStYcMYrOCLb1BJ/sm6t077T5sK1cryTtWLsmhhsQ+AKRGFvUDajYP6N/KWwOCQ2wtaXyIg3j4P1JnYLC99o4n/W+SY8Q5L2Gi1ICCCo+7dbEjjBawmzUf3K5Q0yqCyFy2s9EeqxVmroIpSU4urtUAdq7vpXCrwJqMEWLkae+mRwmnP/kIjJvzpbyU5DnkdK8Z+n6IEKDQMSkUi6Jpk9QAV+0nHUN0NBBPtOiFdqNvwOlWVJbLpg0IoEMlytwpat78E/fBuUuWwFd6kMwYa0sD4Mi2/50AhgN+7hS+tR/+RzqM7ijBGFgIWWUh1MKhsZEzeFI2LKZW/VWr+AOQHmBcK/75WcoNYIcVg/SKnZxxuYCbjRA+EkSQfULOLbaJ5eA1CyE9Q1DUYnKKg8z/Pf0Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd13720d-409c-431b-c081-08db89cf542a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:16.8234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPUEXp/Hp6lLSnbhKpF40aRSBIC34e6P6OkW9fZST2QtfapoyAOWAJa+M+ZaDVDV2bSW37qwDQdoph8gG3HbKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=852
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-ORIG-GUID: CWA_DdBrYV-8fcVWaiXmtpWlIPUQLOYJ
X-Proofpoint-GUID: CWA_DdBrYV-8fcVWaiXmtpWlIPUQLOYJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move metadump initialization and release functionality into corresponding
functions. There are no functional changes made in this commit.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 88 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index c24947ec..8bc97a6c 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2985,6 +2985,54 @@ done:
 	return !write_buf(iocur_top);
 }
 
+static int
+init_metadump(void)
+{
+	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
+	if (metadump.metablock == NULL) {
+		print_warning("memory allocation failure");
+		return -1;
+	}
+	metadump.metablock->mb_blocklog = BBSHIFT;
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+
+	/* Set flags about state of metadump */
+	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
+	if (metadump.obfuscate)
+		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
+	if (metadump.dirty_log)
+		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
+
+	metadump.block_index = (__be64 *)((char *)metadump.metablock +
+				sizeof(xfs_metablock_t));
+	metadump.block_buffer = (char *)(metadump.metablock) + BBSIZE;
+	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
+
+	/*
+	 * A metadump block can hold at most num_indices of BBSIZE sectors;
+	 * do not try to dump a filesystem with a sector size which does not
+	 * fit within num_indices (i.e. within a single metablock).
+	 */
+	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
+		print_warning("Cannot dump filesystem with sector size %u",
+			      mp->m_sb.sb_sectsize);
+		free(metadump.metablock);
+		return -1;
+	}
+
+	metadump.cur_index = 0;
+
+	return 0;
+}
+
+static void
+release_metadump(void)
+{
+	free(metadump.metablock);
+}
+
 static int
 metadump_f(
 	int 		argc,
@@ -3077,48 +3125,16 @@ metadump_f(
 		pop_cur();
 	}
 
-	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
-	if (metadump.metablock == NULL) {
-		print_warning("memory allocation failure");
-		return -1;
-	}
-	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
-
-	/* Set flags about state of metadump */
-	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
-	if (metadump.obfuscate)
-		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
-	if (!metadump.zero_stale_data)
-		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
-	if (metadump.dirty_log)
-		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
-
-	metadump.block_index = (__be64 *)((char *)metadump.metablock +
-					sizeof(xfs_metablock_t));
-	metadump.block_buffer = (char *)metadump.metablock + BBSIZE;
-	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) /
-		sizeof(__be64);
-
-	/*
-	 * A metadump block can hold at most num_indices of BBSIZE sectors;
-	 * do not try to dump a filesystem with a sector size which does not
-	 * fit within num_indices (i.e. within a single metablock).
-	 */
-	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
-		print_warning("Cannot dump filesystem with sector size %u",
-			      mp->m_sb.sb_sectsize);
-		free(metadump.metablock);
+	ret = init_metadump();
+	if (ret)
 		return 0;
-	}
 
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
 		if (isatty(fileno(stdout))) {
 			print_warning("cannot write to a terminal");
-			free(metadump.metablock);
-			return 0;
+			goto out;
 		}
 		/*
 		 * Redirect stdout to stderr for the duration of the
@@ -3195,7 +3211,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 out:
-	free(metadump.metablock);
+	release_metadump();
 
 	return 0;
 }
-- 
2.39.1

