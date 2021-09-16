Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622BFC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BAD561209
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbhIPKKb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3736 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236417AbhIPKKb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G900Qm008814;
        Thu, 16 Sep 2021 10:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fCM50HzQgXZKckpSRlKE6r0vwfbDzhnNviFucWPpSr8=;
 b=zm45X51jtHjSUUbT1li0XmghJ3BJlja9LEOJTTAAVDNBWEAw6hoMrTFECJZKvxjoMee0
 2dFyak9neiP385MVz/JgTm3eSsztY7C1H3v6gd6MYkiS6orUOwA/ElVcm0aAlsI8ksrF
 Q06YwsZ5TVsJve4R8BxCO+ieCLBFONlTn+8U/ALdgJcH/IP5jggSjp7FwVycKoTltAYU
 wXRFKif9C+Lsv7KIcGKTA13N+hmLKRJBR5+V5KG4/USK1mD3aeJDSkuSDKRTpb1dihp4
 rZf76A8vIGgAeL5v0TE3bjA/Su41dqAEzbKlOEcBCd4OJ5wG1nvZW9DRynvS0BRs6vJx aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fCM50HzQgXZKckpSRlKE6r0vwfbDzhnNviFucWPpSr8=;
 b=OWdaxZ3nOPUyr9UQaNIeIjNlG4Xd5JORZIYzaU/ExLAZdBaFKZidXIVUTU3itTpjaN0g
 wwOfBE+LJ3iOETAj46CX7VmnlqvBv9lpz5YKwmohIIlSIS0E3GJZTKagDengP4tgUOwY
 7P6/LOiyTcARetTaAKsoDyex9knGikRRWRVhr9JCzWGUSvAjZjOsVWBj3UoVCuvt0qFZ
 s1Q7mOzLcTmOQE6gNA+oyGYcDGYGTbTpiFOaLwjLavKzZoa8lqJp+LzMylnLW67PzHqA
 c/o3cxorr5voxzfm96jZy3D7jOg1rk66uaJpr3F4CtY9tTW4ma3DgdI7IoqwgmrlNvVl QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3vj1156v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6Tkv112221;
        Thu, 16 Sep 2021 10:09:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3020.oracle.com with ESMTP id 3b0m992uje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cs0WIhrE2KHelnUIxwSsb5v9G3gmB8dIC1FnhuGyO5RvFm0/YyDE9I6sOAXaXh5SZ7T/L6c1T6SYukqlUWytjfOZd6JX8658bq+IMwiy4r/aeEIs2E1X9c7ka5j/+ksQGEIB1d1WUQSvg/hhz0NWNGVmhSJZYjAYOkMlJGdk0BShwv6Fz6zY6EZpFygLdtnGFNu58k6QwIFHgiTe9pxpbPp89N7CRDhHDH1BbGHNx8mK9mj+6zBQpDwpFNEdGwXu05mBH5jsifjQoRHbm7h+fLSkvjPtmtHyi4OHkJQDy5sL0Lq0ArfscMlely+uhHn8LpsMtXrpCKmgjbftUhOMFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fCM50HzQgXZKckpSRlKE6r0vwfbDzhnNviFucWPpSr8=;
 b=edOuUnDIR6FhWhd05JgBDdQrVPuMQaq78cB8Mxbjp6X8CRLZdTIHop+V82sjsu6hrPY/93QqxLNL7lagRTJ8NZVCe0/vuT62mnk1IWWggIPD4Y5h4ecdN5OnnJpHzLHCJzaQ1Gac0c3V8hvXlpF+9m7IwKTTbstJaCJLLIWgwPmbIDGjAoE8LiDWSoxAGSQbO+gWniAM72/XB/jl176tIxm3D4nR2tXX+4llHhoWg7IDWc0jHOV57qQNc1vOZ4oNRwyb3MxbpgxsMOmFUVVZmAhYqSQ58QI7rG2LhAQqPAQCbheIng8tunIpDgyM5nb1aA/C8bAyQKe8I12pDyd2rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCM50HzQgXZKckpSRlKE6r0vwfbDzhnNviFucWPpSr8=;
 b=yLLgkAzC35vXkqim/9FOhSobDAN12PBDNavm9YdFd0Im8X0/xpo/r2YWxHqzDhNeV2aB8LsWa1rgkprqMAqSNDxqF+J+HZepqWlPkOQzH/bFUk9T7M0nyJFoZdu35UxVAGWc7hkGanUfBEu1VYzYsF9o4rqaazNV5CRG92AYYZA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:08 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 08/16] xfsprogs: Rename inode's extent counter fields based on their width
Date:   Thu, 16 Sep 2021 15:38:14 +0530
Message-Id: <20210916100822.176306-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f62465fa-9031-4ec6-4915-08d978fa0551
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB47488D919FAE7DB34404D49BF6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsQdhHYy0GpKYB/nkRDJ4FZPTBSOaYX4CnTD6IVwXbh9cjzibzT6lFd1ywEmwmdOxRS+/lMRSyJic+kLtM88tvsJQopyi3/ZHjdu7UNibJhVvnMQaA7cS57MjFSPISJkUBv7fWKp2kwL3Uc7/iHOljboslUIXWoNmqg4qfOZ/f8RNq/j8BxxHt8NTx7L0Uu07GFA27tHPpfoKrY9byyjRPDVCSfsAaLRF4FdW2w0/umAu1NSJVfFwTGT5YDa2YPBrH6u413qEumhoz1yob65FfYHLoUAN4U9BC6nKaANA5dUtIKGk6f3XD2NvgETnvhqq3/rEtFpHMi6BDGfvoS6Op03YEjtksis42Hg5x/jFgy62Gh/7F0fRN2s3ocb8Vx9JRqxyE/0P984wrQJjKagZ9YhQOEBim7uJnQUzAg4P1jtCRmX0WwTtBTo03RV76xoCg1hEUzE+Jry22/wGu7Pgrf5bUaYzS4jlI4GqLfUdT3lRipEcukhGTeNAYSVsiDbPZcpm4S87e1WEchgycd9LnAOBHXrG6w2TK1kng6BRE246Jzk+FzqjXe9CVVxJs0qZPdwEPdP2xgAoc1ZL9j3zVxHJCExMXlL9kRnAv5wKyBhdhHChvQyz3i8ZFaPOQSp+wEwpowptmuczeP6GJEPVMpGkggQBcmT+UvgRTSZOHWPvDEtm64myy4Wb2K2gTaeezI4zoH6ANfgjymdOlNVgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(6666004)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lDxdxx7ckTOFyPYFoa9lVnSjA4r3+k+VHTG6DnJJQ9hcyQjqvIOTH8MVF1Rf?=
 =?us-ascii?Q?AHyWNnlO7wJRycNus2/Bgr5SCOV+wdsKdEI3QKdt3dmI89cHs/EfIk/uh/aC?=
 =?us-ascii?Q?J9ywEFzsItx5oaZ2bXz6l81LMEG8PytwR7FAjcONYcpmomkZW3SlRB1h1m5h?=
 =?us-ascii?Q?uYS0/fHuH/1WymxN+xDrPy/W4H40qkRfYjun1MJanx/79NCBlMMWd7EY27YG?=
 =?us-ascii?Q?sG1IlfOlaD+Ju1DDMGXKDD0pDgkpupJO8A3cZpRvF7/8kaFSppiX1MtuSGbY?=
 =?us-ascii?Q?SzUPw4sZhtewPg8/fIW6TqPcnPIMbYM9QM482AfJZip01tDheZ7E5yvj6kzs?=
 =?us-ascii?Q?PktzpQBVWr8aNWhISaiNTnfsCMCvOG/NrXxdbQ4ml2Cd7Wxfv/B/TaHJpRcg?=
 =?us-ascii?Q?8ce1K7aK5OE1lViiQYheuXAZmGoJLU/1+d8z0OkP1VNair17IsGrYZzTbTq5?=
 =?us-ascii?Q?JAfMowJS/B5Bl4L6BR37FLiqnG2ynZvYrdlO6l1Fqj2Z0FFYGQ+/wdnzcCqg?=
 =?us-ascii?Q?FY9EqHdseKcKIXFtD0SwApARYlX5e+l/to9ijZgb8FWLzWt1LY+aHPmOx4JA?=
 =?us-ascii?Q?46Cz82EGFqvzIX9mBUmn4fVPJmdTD00Cu3ydhzH9By4oDfKts/j11Bh6O4iZ?=
 =?us-ascii?Q?eJo2M5zPPU+tN5PoCgoRCVCSeW/6mjx7VWPApFH633szUFsi7n8YlgIeg3Yi?=
 =?us-ascii?Q?fL75x3HXfC4ofSbMR5VL7VAw6hO0PrJbOAjYSNkBUs8cNlDhX+KYcgMk74Gf?=
 =?us-ascii?Q?4NZG62MFeEfm6JRLiow+oCudmSVuH6UqiuwLtJn6kREcc2eLQqFULr4iMgyI?=
 =?us-ascii?Q?dfOLHWn1QUST8SLAeHTu1vu5phf8L371nfay8draFsP9/zPOqDeLf5kdGeXp?=
 =?us-ascii?Q?SP5rfEUBxfJXOE9A+yopysks63L49xDrxht9dNO1baAB/bocnvDBWX6ib9Mb?=
 =?us-ascii?Q?ntmPg9jb40MLUVHTcfaU9pIy6HuR/Z3FN3fgBhtfZyis4FxRLBE20s6dPuke?=
 =?us-ascii?Q?P7BeW12A8wr+D3L42dgGOhVrffAOSSb1Tap/z2p/+b921JJoZ5aKT0t6qol3?=
 =?us-ascii?Q?4q7U85WstX+aqJEuq2chsYgnt0yw487LwIXEFNOtRVuwEN4Z4NCXu5lSs/As?=
 =?us-ascii?Q?NkfZeydZFp+roaPZoU3GO1C+Eht+vidNUpjIbdeX0+2dV3WMyrat12sk5JLe?=
 =?us-ascii?Q?9BgxAFiLgUL3+75ejc+HARATgQcyDsMs1b/Y1pCpuSQkauopxOwHpJKrxTbw?=
 =?us-ascii?Q?v5Up4G9d/H9fGu0uZpzHsjDTd8tCWUkc2K8opJ3V94pNBQIbIiFKFA57Vc7o?=
 =?us-ascii?Q?DTvsDao2OLAAqx0g3NarT1Xq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f62465fa-9031-4ec6-4915-08d978fa0551
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:07.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3NtjNC3opI0iT/niBDqxgaTHbt3m+Bil6us6lWJftnAmwfuG7NDlCR1SC9X9s4+HF48wdompxNtrclJ6zYDWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: l0VK_BbUjDNH4JF1raVjIa9tHF1t6Bxg
X-Proofpoint-GUID: l0VK_BbUjDNH4JF1raVjIa9tHF1t6Bxg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit renames extent counter fields in "struct xfs_dinode" and "struct
xfs_log_dinode" based on the width of the fields. As of this commit, the
32-bit field will be used to count data fork extents and the 16-bit field will
be used to count attr fork extents.

This change is done to enable a future commit to introduce a new 64-bit extent
counter field.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/inode.c               | 4 ++--
 libxfs/xfs_format.h      | 8 ++++----
 libxfs/xfs_inode_buf.c   | 4 ++--
 libxfs/xfs_log_format.h  | 4 ++--
 logprint/log_misc.c      | 4 ++--
 logprint/log_print_all.c | 2 +-
 repair/bmap_repair.c     | 4 ++--
 repair/dinode.c          | 6 +++---
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/db/inode.c b/db/inode.c
index c45ec1f7..33dfffd0 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -100,8 +100,8 @@ const field_t	inode_core_flds[] = {
 	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
 	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
 	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
-	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
+	{ "nextents32", FLDT_EXTNUM, OI(COFF(nextents32)), C1, 0, TYP_NONE },
+	{ "nextents16", FLDT_AEXTNUM, OI(COFF(nextents16)), C1, 0, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 49e627ad..36c382e7 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -802,8 +802,8 @@ typedef struct xfs_dinode {
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be32		di_nextents32;	/* 32-bit extent counter */
+	__be16		di_nextents16;	/* 16-bit extent counter */
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
@@ -940,11 +940,11 @@ xfs_dfork_nextents(
 
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		*nextents = be32_to_cpu(dip->di_nextents);
+		*nextents = be32_to_cpu(dip->di_nextents32);
 		break;
 
 	case XFS_ATTR_FORK:
-		*nextents = be16_to_cpu(dip->di_anextents);
+		*nextents = be16_to_cpu(dip->di_nextents16);
 		break;
 
 	default:
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5ed923ae..5909bc26 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -310,8 +310,8 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index bd711d24..9f352ff4 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -402,8 +402,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents32;	/* number of extents in data fork */
+	uint16_t	di_nextents16;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c06fd233..4e8760c4 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -452,9 +452,9 @@ xlog_print_trans_inode_core(
 		xlog_extract_dinode_ts(ip->di_ctime));
     printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, ip->di_nextents);
+	   ip->di_extsize, ip->di_nextents32);
     printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
+	   ip->di_nextents16, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 37669372..403c5637 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -257,7 +257,7 @@ xlog_recover_print_inode_core(
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
 	     "nextents:%d  anextents:%d\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
-	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
+	       di->di_extsize, di->di_nextents32, (int)di->di_nextents16);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
 	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index adb798f7..847538b1 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -579,7 +579,7 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_nextents = 0;
+		(*dinop)->di_nextents32 = 0;
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
@@ -590,7 +590,7 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_anextents = 0;
+		(*dinop)->di_nextents16 = 0;
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
diff --git a/repair/dinode.c b/repair/dinode.c
index 46f82f64..4e95766e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -78,7 +78,7 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (anextents != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_anextents = cpu_to_be16(0);
+		dino->di_nextents16 = cpu_to_be16(0);
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -1872,7 +1872,7 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents = cpu_to_be32(nextents);
+			dino->di_nextents32 = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
@@ -1896,7 +1896,7 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_anextents = cpu_to_be16(anextents);
+			dino->di_nextents16 = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

