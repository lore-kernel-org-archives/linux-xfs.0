Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46452C0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjGXEg7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjGXEg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:36:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B841A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:36:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMfvPQ015477;
        Mon, 24 Jul 2023 04:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=AOrjB1JhGn+GoPVPYI/JEwYnShJMyRp6zWRqRfOxdzE=;
 b=iubVYD5iWNhkpItudj2jjcG5czB5t8zBvFuOYBqQOrRLOWvJuFaxjM+wIEk09nQE0pHb
 COhojuzsf7C9dbIyncg53Z0Cv6UZ62v9m/sJ6dJW5NZeTNJPWoWSFOCaUB2DOxFES1HB
 d7AYvfwf8+P67T/Hco7MPSccnh8Ezor87xGzOY+0Ku7ipIOYUEycwjuSLM66WJdJ2Qsk
 1U0pzNRLy2AX6aQL3WRlv+YrPdSc7F7PYqWme3igK7jc5rHg+l2mtRX3VzI3N9A45mh0
 NCaii2njO929QGu85sI82z6rMA743wkXZSOLT7o1Y20APmb4LwaX+bJhJ3jfKo1D1App cw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070astf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O440S7029092;
        Mon, 24 Jul 2023 04:36:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96j2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caBrHB3isj9r9ofpuB1zkd12dMx6Eyqk6knwM+K50uIlEDczhhh9+NktTKkXfKynAkqp2B3UFC0iNGt2vk+D6bygD5YDuS5oYIuJjlI0NJmjVGO4ye0gbZFZU8zCPm1WGLnRjH0adyUryCeWKmpcmcFvPO1e68l6qau4nJK7B7LI9NZGXFsJQe9DhWP8DKRJVEUikJxhj6bxxSOrWYWr04q5g99b/V9DHMbg59j6YUuZKkAJze388HykTaaCFANXLaQZBWcQ75z+EtzD5X/qB8RXYFWp1jlhtiJyPZblM9C/1dUyp2vFn2QdGopidCwyA4/o7f/fM1d3eZ+nRohzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOrjB1JhGn+GoPVPYI/JEwYnShJMyRp6zWRqRfOxdzE=;
 b=GKMwuqaemCotipp6JV6YMJe+C75l+0TW2GzkpoZQG0rCRIqgb8/2i5U5RK3PukpgAWOwznApO2sDYPuxGix/PD6O6OLtHRNZWzpTHTjDlSV9mDVSWzKZ0qesqxJHzqoMCt4h+1+rk60YUrI5O6GaF5NsiVUpZIb/xE/2kwQgeS/S0FVo+rlO6u+LhXFURyZEA+uGnu9Z46bABVtrVl7E3NT1pxpdhYSDICYIP+Mvp7pgzfTYhh7GqadAP6EMqTQkZlJQE5OC9ZsiRFfKiuj0P2OKyuNg7JdBmb5YsPT4Ncrt6cVYWSIle99VCy4kEd8v65nXe7mwUqwB2mDRVooHBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOrjB1JhGn+GoPVPYI/JEwYnShJMyRp6zWRqRfOxdzE=;
 b=TrjBYiPDwzfGC1nBJpzducl2vycOjmk3qFBBhSSC9CbatP1e0Hh/QB8P09vCiuUfU5xIf1JdZ/ZRZOqV3k0qR8hSo6Hzzzr7sAuxW2rOLMXI2Xwnvcwl1nwpODhfDpS4ThJVjwCObifoltpK1glFj+iBNAaG7POnEcdsTItP2Sg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:36:52 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:36:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 05/23] metadump: Add initialization and release functions
Date:   Mon, 24 Jul 2023 10:05:09 +0530
Message-Id: <20230724043527.238600-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 66c9fc97-c2af-488c-42f6-08db8bff99de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1t1uVoTRifD5gBEXOvh+F7w5S2HnNW9yMpBJXzpKH4QWtru5LVBnfBB9w+MEMITTNPL6Z6ypsEYdkRMvIT2ifPoR77pp6ZxlfKBr+Akly7akh14DpR5O3X6NirDMAAvZ7hkd36IyumYirtl0KZEIB99rgNMqoOGPIjaiEz4sQBQoFkoh1FkNqOIt58Yc0ul24Vufg0rTrGoWtyCeLMEkDDpKwg2zNDoRlig01wO+M8K9pGnF2tvMf2LS3fsz+WhaGfcVb9p4euvBhk6U/WyEPvU0kCbCv2/QFVvtEzrY07NEfa9x61n5Sy+aD0sOnGp3Jn/g1Nj3sKf3RfOmcwXcUCwJLr/s9IJJAW7PCkPa7dh5+5j9GQTSLRncj+GACup3c8nQZOfAa8EpmVC8M0mz5Rtixxd44BJhhwL0L6gLJQuwKrVjAJqXktwD4FMtQ/iSdhWiKsRDNwWgQwgujd4wVbHQifHfagEs/42Ced3LOcqYIGGmeFyDVH0yttxflJsYEMZYR5vDP8pwU+b1FIineV/BG00LWhUaQlmdFrmJIOSZYXotTCYufAHKhkrXXXWP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2huJHlkI6oTvMpMOyetq6RTV5cNRzfcB6ar+R05N0quWBSQxMFZQ0wXjtBk+?=
 =?us-ascii?Q?kKc7bg8xUhVDAODE7TT7jCO2Lgf5pOCCPWjtl32n8kxNh1sJxPA71lf66hbE?=
 =?us-ascii?Q?fgcE5XextxxMs+d97YFxVw1GTPohxtWOtBJMdfYNn4dFc5nRKd64rUG2m48t?=
 =?us-ascii?Q?Ln633BxshGI3/uFUEBVRfSW9RrL5lDePKwAy9UFGPCIB5WRuzbhxHO2IuYrJ?=
 =?us-ascii?Q?6g/c0QX0JbRCkyOdU2zIR/JCFtrqCC+qGDK2AX2AWsuWjc6+UIo4eA+2oANt?=
 =?us-ascii?Q?3TtnOfgynZGcGPsVXAd/Gjomy6EC4ASSa6a8fAdynCY6iCqMqxlBbcEUs3Hq?=
 =?us-ascii?Q?ouq5sANEQ0+q9KyqWGt8laaKL8lFN+htIWBRMIAkM/vf57+g8ScXEIve7Tte?=
 =?us-ascii?Q?KHTo6cr5skOphk2QQovmIgQM//SaMrrUtLcACHpzPwnP1YucU7V4OLw59Vyw?=
 =?us-ascii?Q?aC7OAJkRKFp9VgG4fd1rhCcklmlVcPdH4DH8We7wfa8hX/guadC1otAvjwUm?=
 =?us-ascii?Q?oMDw35wOX0QjurjG1azNXXrj2reqQBlrxKVYrDBlR/nEXaHBdllaMtWh5Eaq?=
 =?us-ascii?Q?TYIGPwQUoHY9vTKxivXyzjyXGCGUqvBBXxuFGtmlgAe8YCYV5j9xnnjul881?=
 =?us-ascii?Q?pH/DXnUF6nD+mL2yRlx7+pNmhTkPQgcvjY4+xqjP/ps1Rn7xMVTwv0L/y7a3?=
 =?us-ascii?Q?UqEOiTz1rcS7s5XZv1rV5/maIvZbSgo6Ogw/eJV+8XajY1qG9DDRSvZSYT/7?=
 =?us-ascii?Q?ec1LLBZ+EFU+7EER7JNFPDnAadRxAoE7mOGvPsjSJQa8zu8mkDXXA/ZnurSn?=
 =?us-ascii?Q?UF3TUAF6OtR6rPZV5mH2aXcHFX1RrIorobEuVzIAbZ1uec8WrxD373Gg/tHd?=
 =?us-ascii?Q?9jxh89AnkjIwgKcwv74tREmkIXyWhqYxhe5kZVjIBU7AyBOisOJrtzRrjXZa?=
 =?us-ascii?Q?OP+JAsL9GkyN3HlR7Q6e/hjbryeRPfBlV/RBTqWOiEushuK4WjtogU/yFrSF?=
 =?us-ascii?Q?1unVw+pCxNaLku9okkz9F8i1zDannqORrjR5HColN6mJCuvdfOI5jHYjPYSO?=
 =?us-ascii?Q?A8Uu9TJKMCfmpwnWOBkVN8UNX4JMweS7XDNnYppGQSBMeiIA5lw3Brm4zd31?=
 =?us-ascii?Q?PrPm7tNNtXRSfCa7Qbe6+oPRY4WmEoWM3Z+guHPRyqPbP8yHe8I0KsEo8FPn?=
 =?us-ascii?Q?Jb+ClI05zmyv27e115ZWxuZrP/c/sqpt+c43vbB/7pWHgDgIyu22N38cL/Y1?=
 =?us-ascii?Q?9TC+sjHFSrcPvxPck3FGa7ULRq2n/Mz9R/EYfd6jvQgtIRKnj70Ig9qB4Vig?=
 =?us-ascii?Q?YrLS7MJA08XvRYeNYmBumJWrObZ+98EwSWUSAHg1NfoCFhz6/WolSemroqIy?=
 =?us-ascii?Q?L4LRBRI32z4LiVOuHYuQeacjvcaLMY3obO95m4i+qv4TKVUOZGgnm8wuWNRb?=
 =?us-ascii?Q?b+wlFZtMpJou7KTKXwM+RSvum/2eUFoJrcjwmlG3nY07bedZkJ54b5SQ61PX?=
 =?us-ascii?Q?ot6CswQPxVp3mxFiI2I7iF8lr8H/To+dHsYDeLJdtuXzKT4RHpaPtTWTEayR?=
 =?us-ascii?Q?Y3j2v/6zcCbFDST2QxjgsQ8Jw4EG4a0XBbPstcpJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9Z3iH55+qX98kbgBQM/TQZuz1hBdBEfbaupt6GGVDTDtwPGSetmn0nmXFGUHMtq+N6oWVuxh9CqUtVd2x9pCE4xTDm8Ly06M7D0/dniSR92D2RZCwXNygGJ++C61ElIpA5UCa6RRefYWR43b77C1qGxzgxeqPIyOSmgidGLIUNTVcrmhnYzPKca0qZPLIDPf9diUi9EZUeCOMho+iB0kbYJuQYUD/7VW57vceecVTqPBf02DNFdM1026TMmh6po91iQkwxv1mAHS0zUsQQpBosCAu7PN3aqf6azlGH8yebX+WuMC2ldsRDhqsO4Uvtgrx199dQSjojY2PVQKJQ3GEUbh5a3C2TW8ywEScho/0UJOKBX9TDchbT3DK+lMd+fn93vpQhbrC1XEnUsmkVEaNp1ZDG30nh8AlH+lCMTr4foc25g/99rQsy0ttXvSjhgFR8mzGZx4GmAf5kMdY4YF7njYqPtcym6/y+fAcdCS/taqfhyR56IJhtQ00PTtkMXxMDioz6ftKejgIt8QTlFsMcJaCGXpFycUBdKPheIzbHvl6bFqD6mGx3mAqoRGjilc/EhcI/qH9j9SyYXdlZlAM5c8Ds3xKpXiiUguzgdSMCL4oMh4LALLHE2ssiK1Rmmisrln6pqIH+gzJzYyoCdaXHq6vudgnCXiaylYefi9A3jzOkTzRGdjA9G+GPLxLp0BYW4gt5a+O16atHdSIJdWLNFJXpobg6c8CQrcclPx9dsDY3b3otOBKlyLryJe/Frd3SK2RELb2G9i6nJiRvsKeF1zP92ilavk2D6+T4eh4TY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c9fc97-c2af-488c-42f6-08db8bff99de
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:36:51.9474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrXoDfaFf/PmVVEGk79P2HZ3Y5iUemNIJSt/t2iStcD7v2SEtwkZBH3IrljEvu8T19VQF5UC2w/IEfPoGJjQ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=851 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240041
X-Proofpoint-GUID: EqsoTc8t4064ZEzJKiUEW3Pu0vhIlpUs
X-Proofpoint-ORIG-GUID: EqsoTc8t4064ZEzJKiUEW3Pu0vhIlpUs
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

