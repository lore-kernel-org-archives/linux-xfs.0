Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E7BC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbjFFJ3I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbjFFJ3G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B73E69
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:04 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3565qooP009177;
        Tue, 6 Jun 2023 09:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=WHEkd7Ot2dctOxalJQqyCGzSMB8Jkbq4fwdUIOMbaSk=;
 b=3BdeDt1a5EpIXwXD0hpjiCAwZurZjeSzyBShaxeEIBt22Z/Hg/8dKHpfUjFmXknIjH3w
 ohwkcHrwYWf35f9nzOaJay3yCWWmGGSujhnhrTnxdoXahxnsfnveOUzVn4RPeHE9ZDPw
 kT7gQ41F/WmANcHq3xm+Q55Jr/pcjNS11lasyECEngxXzmd1/nRmXv5kv6x2zA62h0B4
 0YHxRYCGlKqc/z4bR41MifBdJK70n6cDLCCWkICbNXuB0sL0sDICoV+289BC5zOMQUgN
 immDoPPdnJhAiPV98YJxq0LJVZbIQ3W3Q7re1k1tcpcfOQg/3KpOgmeb59OoCZO5rQIK DQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx1nvx5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3567J4dC024063;
        Tue, 6 Jun 2023 09:29:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tq8wkgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6vNGUIa/jPF7Hq5abFqboG0XQPWQz5azZNeplsFUX2y25yAdUtKjqMqjbTontsgKaJfs8C8jOgb5exChPAafg7RdSTjYZelvMUatzg1SkhdOd/dexmHZgQx/OorxOZDHLheKysoxem6B96jEse12cVvAFWevSxnCqeyg030JhFjIWTGckIY5JOhBVo5GrTN6jSQP44jrQVJ9AnA2eOzumwE4qhzLI5mXavzHxHizXGrMrWsAg5LQWWr+SHbeTGW7yUfzdYE9n4+q5xXU6nM2OwATVC5Rv7xGkcsKzDW0w8pZ7Y7V74Ir+aGjFRPXojZBxZAtxaYM1cUunkhjxU0Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHEkd7Ot2dctOxalJQqyCGzSMB8Jkbq4fwdUIOMbaSk=;
 b=Oew0BCW1RvNYNaLXculEIAYZERm27+CVtXTKeubuHc4pNPj+vnpAMWQlXYvKFdIZM7UfwA+a92CHi+WYUEFP0J4nLlYOnjxFFjvxt9Et4M8IJ6HJ+whoJu2xSjFGyiG2D0zEiTZhhG+6mTpM6XKblrpdxH4V636ZvnGN4USySnr7oIv6j+Kt0H6ciHm6rd7I296Xk6lWK/diIOx2BjF1Kb4vIErlwNnPRSjGeTNtd52ksBkWPGbjaWBjjvpa7saiZIvtRFNpqlGv3u2r+KfrjjVCYHNOzqW9STW9JW6XpjoLphrOn3jpmtJJ74DQswx1lGl/OyZH57Amyi42yc88gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHEkd7Ot2dctOxalJQqyCGzSMB8Jkbq4fwdUIOMbaSk=;
 b=sUYL73DJj8YDgevHJse/KQ4E9BRzlJaphuTLDcsmOPqOBQHlJYLLrEtnUOmSb+htmQZv6J7sgZY4AD7+cn5/O3c+sqfKaUdy9t3asXTLPrlbj3nyyPEN0NuoNGA3uL/MbenYu3P15wPnXA6y3gfVlwSlQdRrD8fle7wz4mLneuQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:28:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:28:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 05/23] metadump: Add initialization and release functions
Date:   Tue,  6 Jun 2023 14:57:48 +0530
Message-Id: <20230606092806.1604491-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0097.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd0127f-9001-4d3f-e247-08db667074af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1B3+cPPYf4V9cTvWW+aswoDhwesjRP9hD6JrdOZ5FgxovXzXX+HhN7c2laErkWogrIA27Dh2cAMgcGdaM4CLRNQtYDVtoNpnOqPd3VRWLmvgFHjNkpYcekQoT7ECe+cV16P1GqTXg7viot4pA6A6Xmn9wrZviLs6GvWeiY2w8ln6ShgCwe+8eXdoM0+9BnDpDAdbD8gbpQdGYG5MNGar2O8toTi1YNFBMDnKIK8BfdH6C+/lx99V9eUVKWMMr4HRiSAsEC0HVDyMEjGo7LKviSkS8fII4TMPzqupjwixMJvHkaF3A7kqXKUFUsnYPzAx3fpdz2/+Kkb4KzqCBwFcu5vY826nYcMIRfgP/ZxIDE37RldqMPG0p8Yb1+GCE+62pUjECrYc8bZpn9223s/oEpYhKcFvuTgcyID9iUgg9dSCKA62bZtwbfkZSZsZgTr7kzRyUewaNlyaKL0eB4cbk1NJykk8j9irfEcKwWwMiJ9q32Tj/nBcqUbLANvrLnC/W/AUWEX5nSIrmSNrRGwlineylkXHiSQmGK1cDbFM/2aEFF2WjY0OZFeoNfuiA0Yu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DgbhiPZ5eYnX5Sa7v/W0D8TRQiujBF1vFYXIsg6f2bi2RksLVK7tfNr8752A?=
 =?us-ascii?Q?pl7Bdjyy8iCc/Ihkt9TieayErOAAZ1rUfC1n7x7vUpLATnBIxA1Q5KS40sXL?=
 =?us-ascii?Q?alC+giO0Ud2mPXM4GJeBU6whXU6rkxwLSeDV8yPQeRDSyeF8zhg0lFnFIhYh?=
 =?us-ascii?Q?x6FMxAiCdkud335XHcSxAgWILWWP843vBLTEKSqr1oAMRq+Z0SPo2PmnvXIK?=
 =?us-ascii?Q?a1LFT2wHyFVVSqz004H8axQNqmufULFWfH/ZaoAY52Ab7BqVzQXE1XVuSoIo?=
 =?us-ascii?Q?gjCPF51+P7kjUjSCZpaSL72GCd9sv1cEi+i/nVrANMObi9DkjDOJfhmwHLmp?=
 =?us-ascii?Q?BHxXN1LNlii8oE5Z943a54kuLfaD/YRZ/pq/CZVQl47DxK8oA+XVGEmNynFU?=
 =?us-ascii?Q?4lqXfkpOvzaDPTRfefQxMMOTlbtbOO28yzohh829kBu95UpMEz0wLbwJmDpi?=
 =?us-ascii?Q?wvJL1tIyRQSeW6Akwpq0hJbndl+zKyIRMSNVGvrproD3JsgG7USNgl3kF5da?=
 =?us-ascii?Q?b/KWksOZFl3sbRtrc2xNt2srwUR7AJK0Lu4SMGL5rvNR3nIyn/vueRLP3XzY?=
 =?us-ascii?Q?RTeOWRCndjHjzatqkC3oSsI/X8eqyl7HsOIMt50BfChOeffZ/ru096NjwNbB?=
 =?us-ascii?Q?6RyN3ZvWLpjaz7n89gdlJU6kXCcpWHss4yisAn/lusnxKCLrh/Uf6LJO8KRV?=
 =?us-ascii?Q?IP2FnS7nIFtDhm1kFfC+23kFPACIm1VIpwM2dgZkBOFo4xL43e2QAeG7ZP2d?=
 =?us-ascii?Q?hISXomsQ7CvWxF6dPZr79mg/RGCvhBCohl8spUQPS1xdn52By5Jk7sJ0x4SC?=
 =?us-ascii?Q?Z6RlSBVKdiekdOCFkH+evebC5F8nFL3WzPAealO13I/gIJR/m4yBe1lfUry9?=
 =?us-ascii?Q?c0iGdm1mVnqP7yM4UyynWVTHK+qrTujmXBKUS5+aMtVeQw3T9W8Oxyf230TZ?=
 =?us-ascii?Q?NSK04GR3S6re+4rI2GLeFokdU/R3mzi2Tn3KxsEsdz4zm8NAL+qf0lk/NXCU?=
 =?us-ascii?Q?fYrNR79I1qXDJEqh47v5jod2W/3IQ8MmSFFzLn50Aifk2cwXog/svZOy991A?=
 =?us-ascii?Q?E6w7FgbBWjQMBFE8P4IKQQ1c3NP5Oka+CIjnGdEUA22jis2xE3plT/CvQ38O?=
 =?us-ascii?Q?wvriKZ6dR21kvs1ls/OrJOrOkWUvledAFQdvXX08ZV6eiM1Xw5FW0qTo6sCq?=
 =?us-ascii?Q?aDIhc9qwM5k64uy0aTmMSakvYpXfxlbiNyTV+cQGNWtxRCdsE3/yVmLtkhqZ?=
 =?us-ascii?Q?IkeSsDWq50XWl7NFMpOiL9z/Hx4kfOuAEbGbegrlcfxhcbblZtd3mkGKo7Ua?=
 =?us-ascii?Q?lUCWYR5jK7lQOrJ9dDGu4rbWm7l5ix9gO5rCO+k9W7YJUJVksKxEdJkGnRue?=
 =?us-ascii?Q?wm8rwjmu7O7rgpuqumrhctPAg1UPmuXE/AbOvZA7wGvX1j5+pt1t/rdVgtdT?=
 =?us-ascii?Q?yFhw3eMLmPLoiGlVHktusISZ10PkzfznYHGPipSw7edQLPXCLYbIyZbE92vd?=
 =?us-ascii?Q?il0USLa9fmHJREUmLfeSmeolugMb48/P1Oti7ddUUNp6y3zINB4IeJ1+rXtC?=
 =?us-ascii?Q?w/Wggycb8HLyUfS8CEuCjBT9EZn+1uSdk3cx6mSf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3/oWxrmMHw9dA0m5L24nClGCC8G2P6RNERvh3JTADNAQ4kv47+uQ38kkAkdpc0S4Om7zago50HoguLw33qtkNqi1dqvjt4pdScRDVe5GzaBqryuTxeR1w69+ylqaP//2D+v7gh+FEtqkE/sTPBB62/O8cuE01YxBMoTDkgm+6ClhI4JVP6aLA0rXpjRSlwhDtKZOuwcksMGrvNE2hvGfBGMwE8b4QJ0+UJpI+54mfLaChqaMtucoJbsCVU4l1xxz3sHXiLe4ruj+Kk+DmpmbDCGoIt5q2w4d/WZwD1zyzD3mb3vIloqbHT8c1HePS5uxx250cHpdFObuMRd7ah5E8lBPkz44Of0sVCy8W3ZlnuIa8eMFx2D0sm0w3qDM4zk7vckEdt/1n9wiP+MltkE1ny7LNrKfZH+Pv2ZGkhVGFlM76j5lc5PL3RuDicuAfm2V2S+fJy+S049tLYZOcFZLa1iFILoeePl+jDTdl/M/KU4eY3JcOIcwVw9m7F8OkLvsXAAB0Cu5GeXSNf/boJy7wf1uIxjEGAbxUpmQyQAdGKvc2dxut2XvyN6xb7yKzVQ4GIX/HNrOwntfyAAFNJv1rQ4BW4VB0UHNFN2gqLXV0ETd++n9W41pPRCgqwQayMPuRPI84IcOvC19wVkuBl5Wjg+1FyTuLLpCF/5hT3dI/iRyKCb+wxDbn0o0NHa1ZugNHVNQybhVtU+mVBu/ae8lgqOjojMj4hkCtU/VEAdL9846IPOPxdQdfJUjtzBUfeEfn0nFjYcgpFftvBRy8GYEBwvu4Wkan3gxh/AxwcFp8l8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd0127f-9001-4d3f-e247-08db667074af
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:28:58.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nxWxSvqsXZI1UUsTl+vCfJyMl9tJcGe7McnCh6xTGXAi9ZqWs8/bSbBN9OF80LQ40BWzB+N30Wmks9D7kIUwXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=870 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-GUID: XUr6ntWzcExmmrt1d7rTsxb9Ur449JU3
X-Proofpoint-ORIG-GUID: XUr6ntWzcExmmrt1d7rTsxb9Ur449JU3
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
index e5479b56..ddb5c622 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2984,6 +2984,54 @@ done:
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
@@ -3076,48 +3124,16 @@ metadump_f(
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
@@ -3194,7 +3210,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 out:
-	free(metadump.metablock);
+	release_metadump();
 
 	return 0;
 }
-- 
2.39.1

