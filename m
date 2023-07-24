Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27DAEB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjGXEhV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGXEhT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721211A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:18 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36N3n4SO023604;
        Mon, 24 Jul 2023 04:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=r6e7J2/jI0qDysiNTwNPel04H4atctawZMY6LKbo2BQ=;
 b=XxsyDIFg9DeTMbO367PNQpPOJqNPU/y+arFs4tOwUzfEXLrrrusWF6qWzMa2JCMfvvIx
 AQJsFXrR8fHX1rWO3zZAJ7cYpEopfZq2z2IwhC3hTYqvqed54s37lw3LBE5Xgn3pzDEy
 e1gSNiiCgFBT+uaTy66LPeM5ksY8DbogkZVUXc6Iq3vh92yK5iPmEcBdqsip7fHA2jul
 LE9vbqNJZTM6CRKMpRFm2bRN615O/McPhs3DOR2e7bWYZqp4w58tpTe6h8UNv5ELtlhT
 2bTtKMiUgyH0NRhmwAwvcrSKgpX2uPR4mR5QrIOdCPf9MITN0TbzaiDL/TW5lj3i9lTm 0g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d1u1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O4Plg6040850;
        Mon, 24 Jul 2023 04:37:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j3e9r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5weA0TIAjmz1o6IEj9lWwRCBQqN3+gy19fk60RbqsK795xpSTmYg7n5CXfMrYq/8rJpJdm+s2STs2ZApA+wG4KTWi0QtgPWqoeFZpHXAdZhjr9wH2sbS0yLltHc/oP9kA7Fh03A/79LA4GWU+xqMi7BPoqRkF/lyFVmtc7cCDqtLmZ+97zaULuVC/ODzxvEwWbvF6S/bC/00+3Y+efcbMS1U9s2rokT7RIp7wHux7+JAkJq+G6I6WLpsqocl0JB4ujuPXMKuw1BdEoOcosaO5yv6FaC9uFKb+8unT1HS1UNPTIiFn65FxMaQ4BFMs3HdynIHDDup4RktwrNyHmzuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6e7J2/jI0qDysiNTwNPel04H4atctawZMY6LKbo2BQ=;
 b=IkXpKfzBzdDw5qQq+E5AVaQ7Mr2m3qlOXN4MB7ib3U+WoPEimC/zzkrUqU2d416ub5E8xO7gqHtMsZt8ebgzERKeS61rr8/Ldu88GWVCs+MrAxFLr99cHNPAO+QPrPAc9s5EW59aR53a/7a8iAe3V7AArEhiQmazMeLnxrtFKX+MiKpvtliv3onVabGkZF6PC+CBtY6tG3RuDljegEhDlPosPWNC5Ayzba1+PS6Tui2QzG3wz6Dl5/9Jp4sI0RKxc5qg40UbZL5F8d0by5AWTZJPXWekh4L55FTM6i5yyldjkxOO0pPF8UdqSjlJdNKWTjDBIHYw9drQxk28qj31pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6e7J2/jI0qDysiNTwNPel04H4atctawZMY6LKbo2BQ=;
 b=oMJy+piC3wS6ABGmGqaE5CDJzb25qjYYy2fe+lz95qZnekTop8MrJMwGKoq1RZ2l2WyfSbHk3mkC4kAOjVxoc5h4V3cR2M2GljtU1h5R9wJCAuVHcXZACby+rexQLCu4BALLxeRHFszhUXa8FfGVjoUj72uLoNm0e8DR87bA2kA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 08/23] metadump: Introduce metadump v1 operations
Date:   Mon, 24 Jul 2023 10:05:12 +0530
Message-Id: <20230724043527.238600-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0016.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: d214f1ce-16f3-4233-8e93-08db8bffa60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzAWlm70sUpaktA+G9lk4V7gjvwpAdZwRCzaEfmCyH2VC6SkqImX0016BJdl0DmmE4RtwImx5/G6XViDv5fi+Y+L+Ohg/HbBiCbSzti/Y4JGB+V8iwQ1bnriMvogLOtNN+CwTKLi6RvO8r0P1Liji3JXlupOkFMzczjnWeiQgXDk7vOA7LtfQMhI+STGtLk626y5KMs+biEd7PBfVLgfhyyHAx7oh0AsCeH/IOSrIUiZ1rZc+wQ5UjL7hVKeVlIZ3IPL9qAgZT/cu2wNpkSr7jrJghRddL+ZZZ1B8SkGzT9rp95UaU6+WnRfyHjmVaiWhy4fjeKn4RCRCrWIKNmnP4PwtXsHYW5aLFyXNSSNbPZ6sbeAB2hc2pXZfGpJx7sfKcGfEHgbVThF59a13nboinSvEk+o8ZJDeGw07dGHQXCE5phHyIAlL+APTyP77UOl8hnXlqXDo9AscY66j0IIfKXfn6Lpq1c3exbCxXV9DXFvSdvlbZekiKoTwpdciyCj+Pki1TCOhPYyGsbeOXTmimPvZHfd4zAxn5UmkjsMvvbn+aXm8szWdIYrh6clqSFT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrlxZ4CiN0xZR0OphMlfK/xIczB81bBtc4pnu3IXOcfBY5HJ9/SvuNZqgokt?=
 =?us-ascii?Q?z+Bh1zDZiJj8hYKyfvXZnhX6iao0iECecDALkB/ozWQakYEx9ASLPAeF4g3S?=
 =?us-ascii?Q?+J52e/x4T0jeE2oGpKKe0Ic5Re67x/sJi2mPb1A5XUaXtBLDQTLK2dAr4t3R?=
 =?us-ascii?Q?Q4hHUihONvhUIlIUfMr4pSSkNZRNgjD03ZyrA6jEFLsZq9mR9gtVbnVhQz/O?=
 =?us-ascii?Q?0w/PehjSMlOakTnFGyiltGMCvEi7N+mmn9kVYIICOnPWNVR6wW67N7XTgweJ?=
 =?us-ascii?Q?rpo70caNzTcRBwuzV94b9k0e/ll9h3ACKMvi8mrkGSifUWShOq9RPaNIQkeH?=
 =?us-ascii?Q?uRKm3ZbRR9KpjnX7BMN22tID91m3yh6nmRybgOio3FNOphybd4Mxw30FLYlF?=
 =?us-ascii?Q?IlKj6If4wvPGx2px9FF5FRYmVZ9DdUbtwkJVzl7MpNjjOl1eWyHZ1G/ptSuA?=
 =?us-ascii?Q?9quYqX2+xkyEwT50gKr0QQy+R07HMUfEHh5pep3SmJYwqb4yYw2b7GF6I1IX?=
 =?us-ascii?Q?9FHsUh8mtQmPEEKG8vD4KkVdQhxLYVjR7LmAg79xVGHbziBM3YnFJUgx9h67?=
 =?us-ascii?Q?wLZ7dadjBJ+CwnGTpyZKHMeHhr1TUoNosl8+oNwKi+w0knewkaThflRNZq3s?=
 =?us-ascii?Q?flO+oQP7UN2J6xuP+eAujJVpGFC77aearNRbQ0gleP0A9yolGoxOjBo3GVuV?=
 =?us-ascii?Q?NUr8zRv7Yy67mp5RIv1MCD8zeAAWA15GYdGOh0OSlx9hR8Dl1Eq2nwFDHLb7?=
 =?us-ascii?Q?GNCyHqoYEhDO7AmV36u8gi1F8Cx8golj9AkBsl9/gKKvhXs1AHEQevhHlf/9?=
 =?us-ascii?Q?2v+5j0IguwGaSxwOA2J/DxwUR9cYYmPaHH6UyPc1GV2T4wLnmbD3O0STsbdW?=
 =?us-ascii?Q?VrItAShmRWESxodg+uv1ccEwAr6I52SP//LudPAiNZFSf4RMTSIClZUICGnw?=
 =?us-ascii?Q?ej38xMP164Eb30/PNch7CMslm46Mx1CgzZGQIvRhJb20gIDQre4iGuhcv+9t?=
 =?us-ascii?Q?x4F5VziGLVIDY6B5gNK6YXL5pKYMnci9x3qzSVVdFZTHzVgjzk+VdWfVpenD?=
 =?us-ascii?Q?xusbaqjaHNhRCxGPkv/8ZgXC1oXyHxdG7kBghyOBy4VgVcxAqWTpKdSk6HeK?=
 =?us-ascii?Q?svw62R5F1lpiwLGLQ+1t5V9z7XgAYVGGklMaM2z640qc6eKGxvQt9x/LfXka?=
 =?us-ascii?Q?z1TLh6M3i86Z8Aed6J5p6R7kOU+1B8gIuczYm5xJ7TQW0BtIzhc2xGeiQ4aX?=
 =?us-ascii?Q?3ANZafft3JgkceLQ6hQ/P5g0I5HcRcm+IhANFllRj13y2fQ3rZ/K5E77FdVZ?=
 =?us-ascii?Q?7t6pDTo39xvkht8YOxu5NseyAQnWsrw4l1AU2CyzFVoH5UnZOgiZN1I0m4Ef?=
 =?us-ascii?Q?fNudc6kaV4xryXIfdHM2grqCRUt3dmO7cb07Gi3mKl3f6176/LcR9U0m/rVu?=
 =?us-ascii?Q?9QhkFTTFvlYxSjZR8f0o+Wng50uRGidOiUrdFUQLECKC+qM8wgitJUFiR71K?=
 =?us-ascii?Q?JU3k0HEzRgT2/pkUIIwMXAytusi3UgtFq/6WaF9mvJ7Z2Wrn8F90KOqJVjlN?=
 =?us-ascii?Q?sZ9AcC1+gotDG6dGk9V4J3POCmF55sHdkXXde3ghf8cLYE3gpMRVkLYGK75x?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: U4T4s76GC1QwjjYGYz3Se+nk1obZYoRWiMObE1FNGyG3lxs6buL/GmecMKI/9IlQEncaOEOSqY51hfWCb0hg3e7oIbkuHd82E3EDGORX/NDdizIViACmtnfAjfxxmf6EsUgOVy2R7jFKMcKFJ+SuwqSSnB4Wf89dPZWP0fOBZPymplYDjCDDf46Gn9SBbHRrONK3qn3qTVWjCKwrx/DHj9Nmwwa50GX0+9TziE9/3MUuCNXz9se2bu1xXVAgX2DPwsz6l0ihNHd8fDc1sfc5n/pNEJY48rLmRqAfMTrtkc1798w/kmwvmb5skfm5qgH4c4ZZ9GV6aScGoOUm8VrVkYkbxCkeREDBqei2J33P08EN5JB8n8Uu2ZuvrBCjR4Y8DnP7rJQHmu2F6HJuA/nT/TXQGkazQeibdem6oAULXT7BHPoXk6RN9FP32jRmcRBy6bWyHdPPad1FVLjKaX3HpcfjjdtiZMFu2BKMKb36Iz1cUwVTJTxCshT4lK1b76sMgxAgQMqXDoyu2V79PemIAteJ8ththT0IL6loQeUvIPQ8QTNr3LwJUyXtTNNcqPPWfDZJFn7PQuU2I4q5xAVcAxOGABtyZYZKnTR67WVr9TPaumCN/8Z5YDYceXrG3I9Pnbc8zEAZGKM29jjtwyonMwuf91r34/dAsotisuVSFI4TSW+LuQTlCVLDFApPs/DZJPZBmRkTzfor/eCueadgmMaTNFLcXBKLSLyuw3d9prwSPNm7vhfE3vXtsu8CU3ctCYGOJn8JHXHi4Ox/keg1iXW3XbK5xeREQltcKzQrkFQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d214f1ce-16f3-4233-8e93-08db8bffa60e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:12.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXD62p7VWkFyCZwjCRIm1fbWIc8d3JeyajRfyxjY2YKVwRUvRgx2JuO4tks7Mj7orAtX6vQjwJzxhawTPl70Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: 7oe6AmEas_gjlgCz_eLf5w4eJs4IXdZP
X-Proofpoint-GUID: 7oe6AmEas_gjlgCz_eLf5w4eJs4IXdZP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with writing metadump to disk into
a new function. It also renames metadump initialization, write and release
functions to reflect the fact that they work with v1 metadump files.

The metadump initialization, write and release functions are now invoked via
metadump_ops->init(), metadump_ops->write() and metadump_ops->release()
respectively.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 124 +++++++++++++++++++++++++-------------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index a138453f..c26a49ad 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -152,59 +152,6 @@ print_progress(const char *fmt, ...)
 	metadump.progress_since_warning = true;
 }
 
-/*
- * A complete dump file will have a "zero" entry in the last index block,
- * even if the dump is exactly aligned, the last index will be full of
- * zeros. If the last index entry is non-zero, the dump is incomplete.
- * Correspondingly, the last chunk will have a count < num_indices.
- *
- * Return 0 for success, -1 for failure.
- */
-
-static int
-write_index(void)
-{
-	struct xfs_metablock *metablock = metadump.metablock;
-	/*
-	 * write index block and following data blocks (streaming)
-	 */
-	metablock->mb_count = cpu_to_be16(metadump.cur_index);
-	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
-			metadump.outf) != 1) {
-		print_warning("error writing to target file");
-		return -1;
-	}
-
-	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
-	metadump.cur_index = 0;
-	return 0;
-}
-
-/*
- * Return 0 for success, -errno for failure.
- */
-static int
-write_buf_segment(
-	char		*data,
-	int64_t		off,
-	int		len)
-{
-	int		i;
-	int		ret;
-
-	for (i = 0; i < len; i++, off++, data += BBSIZE) {
-		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
-		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
-				data, BBSIZE);
-		if (++metadump.cur_index == metadump.num_indices) {
-			ret = write_index();
-			if (ret)
-				return -EIO;
-		}
-	}
-	return 0;
-}
-
 /*
  * we want to preserve the state of the metadata in the dump - whether it is
  * intact or corrupt, so even if the buffer has a verifier attached to it we
@@ -241,15 +188,17 @@ write_buf(
 
 	/* handle discontiguous buffers */
 	if (!buf->bbmap) {
-		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
+		ret = metadump.mdops->write(buf->typ->typnm, buf->data, buf->bb,
+				buf->blen);
 		if (ret)
 			return ret;
 	} else {
 		int	len = 0;
 		for (i = 0; i < buf->bbmap->nmaps; i++) {
-			ret = write_buf_segment(buf->data + BBTOB(len),
-						buf->bbmap->b[i].bm_bn,
-						buf->bbmap->b[i].bm_len);
+			ret = metadump.mdops->write(buf->typ->typnm,
+					buf->data + BBTOB(len),
+					buf->bbmap->b[i].bm_bn,
+					buf->bbmap->b[i].bm_len);
 			if (ret)
 				return ret;
 			len += buf->bbmap->b[i].bm_len;
@@ -3011,7 +2960,7 @@ done:
 }
 
 static int
-init_metadump(void)
+init_metadump_v1(void)
 {
 	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metadump.metablock == NULL) {
@@ -3052,12 +3001,61 @@ init_metadump(void)
 	return 0;
 }
 
+static int
+finish_dump_metadump_v1(void)
+{
+	/*
+	 * write index block and following data blocks (streaming)
+	 */
+	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
+	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
+			metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
+	metadump.cur_index = 0;
+	return 0;
+}
+
+static int
+write_metadump_v1(
+	enum typnm	type,
+	const char	*data,
+	xfs_daddr_t	off,
+	int		len)
+{
+	int		i;
+	int		ret;
+
+	for (i = 0; i < len; i++, off++, data += BBSIZE) {
+		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
+		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
+				data, BBSIZE);
+		if (++metadump.cur_index == metadump.num_indices) {
+			ret = finish_dump_metadump_v1();
+			if (ret)
+				return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 static void
-release_metadump(void)
+release_metadump_v1(void)
 {
 	free(metadump.metablock);
 }
 
+static struct metadump_ops metadump1_ops = {
+	.init		= init_metadump_v1,
+	.write		= write_metadump_v1,
+	.finish_dump	= finish_dump_metadump_v1,
+	.release	= release_metadump_v1,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -3194,7 +3192,9 @@ metadump_f(
 		}
 	}
 
-	ret = init_metadump();
+	metadump.mdops = &metadump1_ops;
+
+	ret = metadump.mdops->init();
 	if (ret)
 		goto out;
 
@@ -3217,7 +3217,7 @@ metadump_f(
 
 	/* write the remaining index */
 	if (!exitcode)
-		exitcode = write_index() < 0;
+		exitcode = metadump.mdops->finish_dump() < 0;
 
 	if (metadump.progress_since_warning)
 		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
@@ -3236,7 +3236,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	release_metadump();
+	metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

