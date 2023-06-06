Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA7FC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjFFJa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjFFJa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01F0E6B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356640bY022359;
        Tue, 6 Jun 2023 09:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fMvGXZexfWN1ze0vCgPVXTtiwJ4yTHJNInnU319l360=;
 b=2SKQ36YEH2IyINuUYMQclkdlsexuyL1E4jiRW3rRNA6brMBci0ZPlqGHNXfb8iwJsCsX
 wmM8gwcIj6foY4NC6b8LMJ668H+LO1uSTLqCXLRbk3EuxnubQTJ4Cq9/1wbsJva97GR1
 8x/hMxj5mrZakGsHIJaRNvyDJ00tMSJ05LrdP3Lqu9C7sVDOYx3ChVAYqtPukNC6H6q8
 OFrN+HOjPhU42tuOZ7t8eiyanXYmdkM7tfLLvNqM/VoBXtXCC414oeVNbo6w60XpYI6C
 RawIz0tesFoMurl+r3V28uMImM0YlsbhxzShAACBv+OhOrx1NKuJ1PldwJfTxEO2jqzY cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2wmxqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35680ifG024018;
        Tue, 6 Jun 2023 09:30:20 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgvdju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7LoOA/1I4bLmlVhvXicLfu+dBNM1fOvhrRbxybuUHAT3hAXkpmbcaoVvTNlIEXRbISH5JAXbigwJEZ4M+ajAUBHkaIkUM4ImEm7pnJbRMJb586LnKGQG6XTGtLUdpfMZKiXztMQllFajBLJyCH2wAkgROgd49YiOGybczE8fPUg4xVd3ndCknOTXf9iR1uWVPTgyEEJjS05ZQxU6+OYDdkspYMWuj5gWSqekv/osZO14vVsBn2BZCK8hvPXWPRzbuuNssJ7/2pwPLfn5EHWjadfT67dlwZhO5avVZ9HQkbB4czwQuYxYxcXVzZg4GEg86ugKBG2HeRHUmH9w5Uc1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMvGXZexfWN1ze0vCgPVXTtiwJ4yTHJNInnU319l360=;
 b=KO5VHkNszhEwPmUTKW4+7SrfrG6ycce1kkl+GUHctSnJERoNr88HHeR/5xmhLrTJ9WatzCA+1+ubqIMUdpHHgLZN3ndKMOyIlecBhHcXEp6cEo6dWp2zqcYIOckYLESdnSFWDg8JJf9NTSucUyv9MEVsj03tMtB6XAa1OIhZGyR2YEyBA0nHjlg7515CuMBXnurkJTECUeTUoOMVafGw8GZ38KSsgg3NcW5XNmBr0CxywQ04CRHPJSPPl61YED1zvgk2WqNulY7TU7hakW91NBncTjrNhTBAcQcmoKCcnF7qA296pDAZz1XWuyWKFpPZUZL5A8RENynOpaiwKaKzog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMvGXZexfWN1ze0vCgPVXTtiwJ4yTHJNInnU319l360=;
 b=fOQNjz6kOsvWpLY7oknt6eKpNFEg2FgTX/ifGz8HeGTMUSdZvdljNz+8zqS//TElnSbylXPKw1rXuAOW0sPly3ghq3BU7lNko99PgfHk0KYQjzeca9JadqX5TTqGpy33V0WrzqU5cozskCoxMKoWAsxtxTFqmdvF0HrIBwqSoSI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:30:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 16/23] mdrestore: Detect metadump v1 magic before reading the header
Date:   Tue,  6 Jun 2023 14:57:59 +0530
Message-Id: <20230606092806.1604491-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0127.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: f7aabc9a-22ad-4cdc-ed74-08db6670a476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pmlY4KGxSEd/cHw2vfIcdBfJgkAjaz274PDi/We8AFjTJYY70SlWc3DYfZF5x4qR6aocG3p028jT/A682g52tuEoL4DDNUzZWnzFswBMjtR2w0gwqG2kSmkoIgqPN+DR8J4bHDs8lKLHQbe12Nm6bnDbQ0taa4oUwVZleau8J+2lJhSu0QVBB/S13SQJTXYulMA3PxvJq24fZ/vWfTmZetsCjY+6ti4zgXel3BR15KFHpLcSOW4civVeD/toH2Pfoyp1SXBpTXDQYD2qF40KkrzkX+Fxfx085eoeTapV4ccTwwEyuOWR3L5UGicNU3XWCQ2EhCmoFGYChYPxKfLR1zVLz6y8U+8EwOuaReymK2FGyeBw4VT1oED42RhMQRj5I0/btztn4TUrVe8uhV704+tCnZDiAB4xchpUMOjofOEKeHGwyqFAzBPRtkqGDQRwP9bIhP84Grlsqk+oDl+8oooF6Zj+CgDJHL1FTtjUR1YEJF0x7zVLgxYHidtaVeiZd9SVPeNmmSJXO1o1L63hyLkmywT+/m5ittUnNO4Sk9XtkmxzYLjTtd5HPQEim+wx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ezPqvWcNw/7os75Q3hU5WaVDD6yPE65PxVehMVGqt5ll1I2cvEhlucm6OAx?=
 =?us-ascii?Q?OppBfy1gqXX9WNkjdg1r9si767wmOgZtZMtRzubcGKLbFQAVdq/I1g8aY5/Z?=
 =?us-ascii?Q?eg/HglAGgbHsGdtLIZjJdsJAYq/dZbDKc+cWt+yewxT/mYxsMT1iFnzT2QOC?=
 =?us-ascii?Q?Er+CPLFNJHtp9xulNW3Ufz3qhQLqWJZWUDRTa/eibECAFaOe170TQB3+MAiJ?=
 =?us-ascii?Q?n5nwOFso2jCwRJypI50IhlaOF+md6aq+tLaDv7ANXb3n15lDT9547ky8PL5I?=
 =?us-ascii?Q?Hf8RUnwR48/oThPh2/Y4yOUY40NK2EYLLcNCoZQs8QOQ6NB01bZhr67Ul1aj?=
 =?us-ascii?Q?CTr4YEHsd/TU79CYBcJoETB5Foh2QwpEZM8zAx8j5FwCYI7iMNGpVaCuoGcg?=
 =?us-ascii?Q?txEU99UzD1duC5d+MhEAR6ZuWqrZ0e+iZ/aGRqqbyvSJmNE1Tzyp7BwbBgmO?=
 =?us-ascii?Q?gl+hl7q5f8/8WybefC8Zi3aAF+IVNC//wbqkcDVHMus/xRP+nZoloYX79hcZ?=
 =?us-ascii?Q?eqV4iQhokad50qCoyQfHcF1u8VXH2o+5H/swoKogGIVPk8c4heHm8tbJgzPm?=
 =?us-ascii?Q?vdIn2snDDB3rDibYFe18Ava9f0gA+XbrO3zC2IoHWzsRX2XWjrc0MkOKmEI3?=
 =?us-ascii?Q?FPpH2M51/3rjqMCN+fiL9ucglfHTgTr7F50RmCZ90eihJDeV/jFwyrqgZ7N1?=
 =?us-ascii?Q?4Wk7iW104XIKOnMoYblZFMF+hfgeVcHnGemAeP30/1+HgHoAraB9tjlVHOI1?=
 =?us-ascii?Q?mAEl0CgDmPb/FtmC82HSwOHRtfrd7rzW7lW3yC1gaygGE0wUU43Ktyk8ndez?=
 =?us-ascii?Q?k8Qqnr9UAGDfDqKT0Ias8AzWysRzs3PiA6BWXpw+gSgS5WviggOo5KC/UI4j?=
 =?us-ascii?Q?ON0PL0I9aXhxMhd6UImHQmIb1SP7XTC0nXifYRggwjAz172IrZt54hTHU/sN?=
 =?us-ascii?Q?JtMK8g7SIZj51k7zCShkYdK9IP8b9BzfnkToeFIg3vs8Xa9DYAFbsTlP51Sw?=
 =?us-ascii?Q?9HSq/elNhB4FKIxLgl5dgISm48vTFKCsCKfFQ9moF8xhALIFRUMM8iNh09fq?=
 =?us-ascii?Q?rCViPxqr3u6ZABWx5V4gOCu4ciXVFQ8PSbJ6SDwDggmg1eqlAXhYgQK4P4wu?=
 =?us-ascii?Q?5ulF1LLa+vdvrIy/EZy5A8I1QA8mJ5kKk91GV8/w3VzqCCCHu/vA8AKxOCgG?=
 =?us-ascii?Q?9k1tdE5cCpukL7qD/rLF3EaXHKZDfYuWdKL/UbrQ14dk9INJLOOJisb1LpJh?=
 =?us-ascii?Q?+4t+wO70+lXWCQhRiCPXYq3eCUYtXzXep8d+xOEXjZ/KE18gu1mRmDJRjaWC?=
 =?us-ascii?Q?zBcnSmaLxJrx3Z2au5beQuUOxRsWgoSUPndsrBqmpYy6gJmOZqs4UOcNGky6?=
 =?us-ascii?Q?zXc+9qAYRGqlte0T9KFF8cdlIRy+grGT/AgV1PUii8aWq/f65Fq+cGpcK+09?=
 =?us-ascii?Q?ydZ8TELaQpr6ZB1vfiXWhtHH1jstPTcg18ZSBH5Fv2m00SWGKhW72B5cgAtP?=
 =?us-ascii?Q?KUrZfnrv1NeEA18gnlBS8TQh9DAK36yYJ8ceUwTU6UofwEariUnUKSrWLd6c?=
 =?us-ascii?Q?zo0UC+WsOg6BX2l22CrJBE70yc0bBOg++6PSE/efUDH1r8C52qv7qUcYjbCV?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LqHUApkFsGzMKiY98c8nLaM68MQE7C95nmLiYXWMW7c3rMrpOgdQupxVMYqlskcbNAtJR0CQpQnczHyCsYqAt104kRBfHnNDvwl1f0+iFFTCJ4M1k/7XuLiqfhUsuWzHQL1AItOlHtJ7B/Qw0P9UJHb4/M8a6+1GJ5CKdEmnSUZTLXHRuMJVPgoYMbPgEu9XujTcojCj2s5ak7V0tS1KTd4aHrb2T31BX4a9dqzXv1JCFd7WwQA+qBeeBSGHTqZhEBRrCstQ99qNEGygpfx46YWLn0FWe42eyY1rOUbqYax5u6frjlp17MCU+6PJ3Rz3J/sxKz1I2wN/H4I4SCGmRTQ6Aqm2T6rMl28Ij61oYgOD6q5WBzZAaAb8uzkwRUTt1ASvZJPzv0VVx1sBth5VX7m1OfoN7Nb9gNe84jdbE2tBylfjqwR85rQP4lxwIR3vOhyQU8oSPWdiLo/jnalPIjPnzTRgNBWV3Xd2+hSCKYgcCFg/6JpeAQYu6MlsO3Ugml06roaH6t6tvmlK7ffWnQ22ZeLkwSMMGTykTLTez7KrOfmQRAxP/13EYVfxn4oJMoESuAi253a/ACHYvYXsbViKBv4m73StLxfSj1W1yXUp4CZo1xY6sbS8G2aMxcw/wAIET6fXjQTJNRG3HXaGieiESkGaDqbBHwfF10r+KkpOtTYGqpKFd4o7A3QEYBbJQgDNwlMYi7PF8aeoUFJkN2gtan0z8WaAxLHRsxZijb3HH+TYGG8I1GAVIoULres5L6rj7IKPNyou6TpgNOJnwd7cE+5haBDWXknTT4jSReY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7aabc9a-22ad-4cdc-ed74-08db6670a476
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:18.6570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1c4BW3VIglAvK/Ffcs9GYqVgnoJcmxA41qXVFYKgMSi/2rC3b5IzH+VqO4o8wgHn1OHXWPq6bwAzPlGPprHvJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-GUID: z11k_BMKlbgtuVJnVgFrvwHDUVEYQNIg
X-Proofpoint-ORIG-GUID: z11k_BMKlbgtuVJnVgFrvwHDUVEYQNIg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to support both v1 and v2 versions of metadump, mdrestore will have
to detect the format in which the metadump file has been stored on the disk
and then read the ondisk structures accordingly. In a step in that direction,
this commit splits the work of reading the metadump header from disk into two
parts
1. Read the first 4 bytes containing the metadump magic code.
2. Read the remaining part of the header.

A future commit will take appropriate action based on the value of the magic
code.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 564630f7..2a9527b9 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -198,6 +198,7 @@ main(
 	int		open_flags;
 	struct stat	statbuf;
 	int		is_target_file;
+	uint32_t	magic;
 	struct xfs_metablock	mb;
 
 	mdrestore.show_progress = false;
@@ -245,10 +246,20 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
-		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
+	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
+		fatal("Unable to read metadump magic from metadump file\n");
+
+	switch (be32_to_cpu(magic)) {
+	case XFS_MD_MAGIC_V1:
+		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
+		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
+			sizeof(mb) - sizeof(mb.mb_magic), 1, src_f) != 1)
+			fatal("error reading from metadump file\n");
+		break;
+	default:
 		fatal("specified file is not a metadata dump\n");
+		break;
+	}
 
 	if (mdrestore.show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
-- 
2.39.1

