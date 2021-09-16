Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B02FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23EDB61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhIPKJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:09:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2188 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236277AbhIPKIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:53 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xsfJ004749;
        Thu, 16 Sep 2021 10:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tKyPAC3aPH5CFLg6BuyUte4vEolJfSyvuzy2gJbYGUA=;
 b=khd9PHF3WEOXNxmx03pSYxRNQooV9kMgHKGX+H8DIUmHnKEOrcZRwr2OWMzuLMyPvUdw
 Bvd23Grf6M7JunpHln1xV5IBW2E2/9TShDa9suGi9PSkbtLMAOSVVLLge3R5TC5HNCyq
 M5bl2nE03RQCmlBAkZ2rVJ6OPogd+tS3VOjpcOxUbMavlNvis9e/0vnjOm2VZz1y75s5
 XxgP6UBcTBq9IoDGew2MDn3a/pIL0hBb2rsI21dPoDxPNqFSDk+5wYSd+zMW0JL4Qq/o
 5lRuLhEM/E+bfdfMcg911YIIzh5wDfGKIMG3w87R9nXaIGm4zYHttO+1+k4fsrGU0rjO Iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=tKyPAC3aPH5CFLg6BuyUte4vEolJfSyvuzy2gJbYGUA=;
 b=nUv4rSpdvsNmzWWM5dNdIxwR0FbuXcNv8EZ+Z+4VJN2iZShgO+9cHJrykSKZqbvaBHdi
 H35T1K3KYp9crvVCboCojFTPQf+1Y5+m1aE35DcrZ3BHQsVMbDqiO+kaFWX0wwVPZKeT
 0T/EfNmz8RNnRQB66ATfZJv9dzPi7hOqyr8VC+UaWYzuFWnaVD4KaVzSRfrZ2M7KMQ7C
 Xiwmx3oHnkMUE8v7PWiHlNDeYLASrI/YJRDeE83bFz7u6sXPumbQjO6zHW8XY86MTpf8
 USaB0hXrcmj0BYM54uPJtIdj5P2PXmdK7/2M4m+uqEyf6ZcRcBvP3cOKVxNYhGUh7hka 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jy7jr3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5hjt171537;
        Thu, 16 Sep 2021 10:07:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3b167uxnqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVWZhcIibHAq6Gr5EX25ffT6N293RoG69IIZ34uuIRQLTwu3xmMPoylO4G+zoLq2I0j9CJlzFi8SJ5oLF7m5QLV/ys30uqwHDR4kYGy/0sjT0fdDtfhPYEcB125GFMw/GcSy8G9UOy26LJJqLngtNBX4L/BYmwu+8T+S8uEkeftZzxSDge0clHlaf/LC+TXxPIJy9weyXMQL84fpBvBdpV3V0BlX4D+ikh8jmhgbQjTt8LMdYX7YVk/lrMEjVdUWxGoTd5kM9UNutXKQlE/TxN7HZa5djLfHCDLsKUqh7w8gIeUw44K1Eg1gUF2iRHFUDacq2HtJb2NJyLm2OASbLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tKyPAC3aPH5CFLg6BuyUte4vEolJfSyvuzy2gJbYGUA=;
 b=QFQ6ZnmI2FxsVzUCZid1vwx6CiQ5iLpxxE/uaN+nLoMejKPa8q8QrszhL3PMJB7HMRu0J3tQDXtxA68DLk05M//kbsQelJdl35qZMvu6lsM3uVO+5Fm/yfRT6UfidzOb5VG6VhEMIZ98fhQji7Fva1ct/t3t3PEzNzA/7AF1jqJ8mfS4PeTAHSgZm+3FrKLI15kMIIgz7J58por6PA5aU7b/J4hvwRdtvqrzCrMv052n1cwfn4Mi8qGmV/5yWPr6UgT95g19u2jo8UJa6SdXMIBDOWFilDA5sBLCHnwA2fl3DnGNUvzFumyucDk1g6FjkMxK4HbtDj1FYvSQQjU6cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKyPAC3aPH5CFLg6BuyUte4vEolJfSyvuzy2gJbYGUA=;
 b=mWx57o5aN1XabtAldccbmXgxWgg/jrJJdHurkZpyIyr0dajxrRgL8cmR1lzk7vqeAlNA8/VejQ2BOQeHASUrjhxGb7nyIqS0946jojLKfDV8mk3c9/kxoOmjER0X0dKwRsG1C7uIveey4rIa8sDqZTkVqyu//YkKXO8BS1s6cR4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:28 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:27 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 06/12] xfs: xfs_dfork_nextents: Return extent count via an out argument
Date:   Thu, 16 Sep 2021 15:36:41 +0530
Message-Id: <20210916100647.176018-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 309f2c42-1283-4a0e-567d-08d978f9c94c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB28786773C1EE753B7C0CA81EF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N5lubg5ldv+I+IFGcGqBzm1BqGFRkkWIyPHK5ZLYZ/YNh78AHGcKeAXXI0d/QDgWUHF0xmKrHZVlM52XLkRkKWz/qQeblw4aprYQBZbJFZOqzsQDnhEg/QLDx9lXLI745KX3GnKbYsmC7JIvLpYvCz44GTxgXoer1mSLENYxfljgHpbLMDKbHH1OwYlGT0oFnR7W2rm05m53OFJ50vmAr1SSxnobzFWU5gPacrLFBQdrUYQmaiWXOh1E8lMZL5yfMYxIyeWzAluomeyDNb6PHNniHyD9XRVEyZcnFOOBEClHW9vfWgbkMfBLBMNiymch5TfrfcGHSE+lyPo+igDnNoIVDffx6pWYxzHbQTI1W7aJOugrvufOoR+5r8+FesiB771QNTEvU5KNmpetW/+e3aMALua1ZYSgY4XCGbzTIpIZL4p9H4gK/wd/ig4ARMzjP7Wmq8nTJ7ujnc1E2W1TySyMQT27dtiFiPtBghPMZ9gxMZAfH2Ybh1bH1HGuJK5VEwZzq4SmaBUZEDJhxfHu719TKb6QlHtyOS+TIJSVgudi7P4QGOgEj/vZ8U0bbxf6ksjghrxqIuWgPEf5KANdsmolqViAOIInjCiDqgTrdQk5Yf7xE/BLt234N9qP714sv2SdEAoSyB+Y6oKfBzWf4srJzdeRZs7SSf7dv3xjbwXVfeUn7qdoUVwVJk38A4bhwAI788K8rxS1g1/+1GqMow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(30864003)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fM5LIm9xqz7PWBJhPL2yMuzBoHHr5n5AVE4NblgYb1rI4nZ4IbcaQtK6z93t?=
 =?us-ascii?Q?y8E7qpg0tToI5q56pqkIXgtwciBWg1rF+7eFJZxIMk4XAuEWBktf58/9AErk?=
 =?us-ascii?Q?UlBgD6vDOCeAFzKTTzhtPrzewtWpdjccOksDLh7rLGGrR5MA1/TBCJY8HlTH?=
 =?us-ascii?Q?cfEPmVun+DeuZ2rA623b4Lmgk0s3InNzYC/jdt56hiQt0a7L6BpSolSDGrkx?=
 =?us-ascii?Q?rZDB0IWkF3tobFUdRIK8y9Z08WJ8rZygyFQSTGB4hWeH2IE0pTScq0N0T5mI?=
 =?us-ascii?Q?OcpCTZuuwXuN/WbWfmxGWPJAz0XCTk3VNG3H9POf2drRxg0kHMTYfJwFCeOd?=
 =?us-ascii?Q?u6aNs5K8xr4BfSx31uZ6su59Oj/04raiUm2Bc9Xm4rQ06owKb+s/QTJgypwO?=
 =?us-ascii?Q?pq/K7CO48AYw5kXhk7BTILJeFgUgS1KBZE+x73ZCxtQfiCk8kZsRbvvOf35e?=
 =?us-ascii?Q?+Lw6wkFUnxVFmzlamsQ/ythzudKqDF8S+crIdd3FhMxvebgRqfrJrs2IM+Po?=
 =?us-ascii?Q?KOz7fp2A/nRjAjknOIllFWp76ygUh4j7CQy3cheBfKTo5Z12yoeytMMWZrjw?=
 =?us-ascii?Q?oC51HoVl4XeEVmpBJ9JIRFDvjdBNz5qQGXEnpNppN5Nz6sHMAlk7UQNWkfCY?=
 =?us-ascii?Q?2Gnqc4BMtK7QpoKOX+H+FeMtkH+MwuenUHAOloZKQORzEvoFruOyZD30HKEh?=
 =?us-ascii?Q?jFa2jIyztxWfQWOcL7Vnq+pVCKJBkT133GJdncv+gFCILleTKLiA+znhhM9u?=
 =?us-ascii?Q?fqsLggz8VjQyJ9yeSeRK2ZcB80YEMnYsqx99TNW+gzzlm03qz1Y2L7zh7Ou1?=
 =?us-ascii?Q?F+K6OYAMlvK3oOi8AOx2cHxUCHbM/+eM70k7toeN82DSFWDDiKRxZDvk6OGN?=
 =?us-ascii?Q?YqZSu65IehCuVajORL/XOHo7aZTGtyCxE+3f3oxnFW4QAESfRYnj+zsAQdS/?=
 =?us-ascii?Q?Q+/zDEsWO9f76dGP74VYPbmpvQjimT/uyYnh7Civ6uxt6vSzRZdwJgJolfnW?=
 =?us-ascii?Q?vMioE+H9X8oU/KeIgjNJCvS/BEmJKSV4e1cVd+/qTH5U4J7mBSC0IPqcZnEz?=
 =?us-ascii?Q?Crw3HC9viiPQyFhGjli+ddlLC0JgI5VNCFMpK5M3iJzXPLknJsit88jF+R5f?=
 =?us-ascii?Q?nPjRJCEO61/ZeRqfuNLerGaarPF0waAZQBIm1Wx+r0PCjr/wMnIx0F36XWgB?=
 =?us-ascii?Q?hHavtf4xnrn2xiExl10uX1V/58r9tex/1JZens/+wpjBnq73K/llfmJn8N4M?=
 =?us-ascii?Q?eOaByC03nxlF3x0YNhGtoRLj5w8d0UXtTdX/AZxPs9DGcQNdY+bROYHSas+g?=
 =?us-ascii?Q?YvljxemkKSB+d1Nx7JT0r4pq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 309f2c42-1283-4a0e-567d-08d978f9c94c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:27.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qY9wUWm8v2Cp2+krtip+MATvU3tXPj0Fl9juS5WX7jlt1OBqtxULU0YC6scJ1U1dzgEY2HyM2wUy3wUW2O/huA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: P64nqFjniNmBzvUyERKxBWEE11GxEM_2
X-Proofpoint-ORIG-GUID: P64nqFjniNmBzvUyERKxBWEE11GxEM_2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit changes xfs_dfork_nextents() to return an error code. The extent
count itself is now returned through an out argument. This facility will be
used by a future commit to indicate an inconsistent ondisk extent count.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     | 14 ++---
 fs/xfs/libxfs/xfs_inode_buf.c  | 16 ++++--
 fs/xfs/libxfs/xfs_inode_fork.c | 21 ++++++--
 fs/xfs/scrub/inode.c           | 94 +++++++++++++++++++++-------------
 fs/xfs/scrub/inode_repair.c    | 34 ++++++++----
 5 files changed, 118 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b4638052801f..dba868f2c3e3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -931,28 +931,30 @@ enum xfs_dinode_fmt {
 		(dip)->di_format : \
 		(dip)->di_aformat)
 
-static inline xfs_extnum_t
+static inline int
 xfs_dfork_nextents(
 	struct xfs_dinode	*dip,
-	int			whichfork)
+	int			whichfork,
+	xfs_extnum_t		*nextents)
 {
-	xfs_extnum_t		nextents = 0;
+	int			error = 0;
 
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		nextents = be32_to_cpu(dip->di_nextents);
+		*nextents = be32_to_cpu(dip->di_nextents);
 		break;
 
 	case XFS_ATTR_FORK:
-		nextents = be16_to_cpu(dip->di_anextents);
+		*nextents = be16_to_cpu(dip->di_anextents);
 		break;
 
 	default:
 		ASSERT(0);
+		error = -EFSCORRUPTED;
 		break;
 	}
 
-	return nextents;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 176c98798aa4..dc511630cc7a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -345,7 +345,8 @@ xfs_dinode_verify_fork(
 	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
-	di_nextents = xfs_dfork_nextents(dip, whichfork);
+	if (xfs_dfork_nextents(dip, whichfork, &di_nextents))
+		return __this_address;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -477,6 +478,7 @@ xfs_dinode_verify(
 	uint64_t		flags2;
 	uint64_t		di_size;
 	xfs_extnum_t            nextents;
+	xfs_extnum_t            naextents;
 	xfs_rfsblock_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
@@ -508,8 +510,13 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
-	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
-	nextents += xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	if (xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents))
+		return __this_address;
+
+	if (xfs_dfork_nextents(dip, XFS_ATTR_FORK, &naextents))
+		return __this_address;
+
+	nextents += naextents;
 	nblocks = be64_to_cpu(dip->di_nblocks);
 
 	/* Fork checks carried over from xfs_iformat_fork */
@@ -570,7 +577,8 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK))
+
+		if (naextents)
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7d1efccfea59..435c343612e2 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -107,13 +107,20 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
-	int			size = nex * sizeof(xfs_bmbt_rec_t);
+	xfs_extnum_t		nex;
+	int			size;
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
 	struct xfs_bmbt_irec	new;
+	int			error;
 	int			i;
 
+	error = xfs_dfork_nextents(dip, whichfork, &nex);
+	if (error)
+		return error;
+
+	size = nex * sizeof(struct xfs_bmbt_rec);
+
 	/*
 	 * If the number of extents is unreasonable, then something is wrong and
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
@@ -234,7 +241,9 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+	error = xfs_dfork_nextents(dip, XFS_DATA_FORK, &ip->i_df.if_nextents);
+	if (error)
+		return error;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -302,9 +311,11 @@ xfs_iformat_attr_fork(
 	struct xfs_dinode	*dip)
 {
 	xfs_extnum_t		naextents;
-	int			error = 0;
+	int			error;
 
-	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	error = xfs_dfork_nextents(dip, XFS_ATTR_FORK, &naextents);
+	if (error)
+		return error;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 4177b85c941d..be43bd6be1ed 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -221,6 +221,38 @@ xchk_dinode_nsec(
 		xchk_ino_set_corrupt(sc, ino);
 }
 
+STATIC void
+xchk_dinode_fork_recs(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	xfs_ino_t		ino,
+	xfs_extnum_t		nextents,
+	int			whichfork)
+{
+	struct xfs_mount	*mp = sc->mp;
+	size_t			fork_recs;
+	unsigned char		format;
+
+	fork_recs = XFS_DFORK_SIZE(dip, mp, whichfork) /
+		sizeof(struct xfs_bmbt_rec);
+	format = XFS_DFORK_FORMAT(dip, whichfork);
+
+	switch (format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		if (nextents > fork_recs)
+			xchk_ino_set_corrupt(sc, ino);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (nextents <= fork_recs)
+			xchk_ino_set_corrupt(sc, ino);
+		break;
+	default:
+		if (nextents != 0)
+			xchk_ino_set_corrupt(sc, ino);
+		break;
+	}
+}
+
 /* Scrub all the ondisk inode fields. */
 STATIC void
 xchk_dinode(
@@ -229,7 +261,6 @@ xchk_dinode(
 	xfs_ino_t		ino)
 {
 	struct xfs_mount	*mp = sc->mp;
-	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
@@ -237,6 +268,7 @@ xchk_dinode(
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
+	int			error;
 
 	flags = be16_to_cpu(dip->di_flags);
 	if (dip->di_version >= 3)
@@ -392,33 +424,30 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
-	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
-	switch (dip->di_format) {
-	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	default:
-		if (nextents != 0)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
+	error = xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents);
+	if (error) {
+		xchk_ino_set_corrupt(sc, ino);
+		return;
 	}
-
-	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	xchk_dinode_fork_recs(sc, dip, ino, nextents, XFS_DATA_FORK);
 
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (naextents != 0 && dip->di_forkoff == 0)
-		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
 
+	error = xfs_dfork_nextents(dip, XFS_ATTR_FORK, &naextents);
+	if (error) {
+		xchk_ino_set_corrupt(sc, ino);
+		return;
+	}
+
+	if (naextents != 0 && dip->di_forkoff == 0) {
+		xchk_ino_set_corrupt(sc, ino);
+		return;
+	}
+
 	/* di_aformat */
 	if (dip->di_aformat != XFS_DINODE_FMT_LOCAL &&
 	    dip->di_aformat != XFS_DINODE_FMT_EXTENTS &&
@@ -426,20 +455,8 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
-	switch (dip->di_aformat) {
-	case XFS_DINODE_FMT_EXTENTS:
-		if (naextents > fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	case XFS_DINODE_FMT_BTREE:
-		if (naextents <= fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	default:
-		if (naextents != 0)
-			xchk_ino_set_corrupt(sc, ino);
-	}
+	if (!error)
+		xchk_dinode_fork_recs(sc, dip, ino, naextents, XFS_ATTR_FORK);
 
 	if (dip->di_version >= 3) {
 		xchk_dinode_nsec(sc, ino, dip, dip->di_crtime);
@@ -502,6 +519,7 @@ xchk_inode_xref_bmap(
 	struct xfs_scrub	*sc,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		dip_nextents;
 	xfs_extnum_t		nextents;
 	xfs_filblks_t		count;
 	xfs_filblks_t		acount;
@@ -515,14 +533,18 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < xfs_dfork_nextents(dip, XFS_DATA_FORK))
+
+	error = xfs_dfork_nextents(dip, XFS_DATA_FORK, &dip_nextents);
+	if (error || nextents < dip_nextents)
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != xfs_dfork_nextents(dip, XFS_ATTR_FORK))
+
+	error = xfs_dfork_nextents(dip, XFS_ATTR_FORK, &dip_nextents);
+	if (error || nextents < dip_nextents)
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index ec8360b3b13b..4133a91c9a57 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -606,7 +606,9 @@ xrep_dinode_bad_extents_fork(
 	xfs_extnum_t		nex;
 	int			fork_size;
 
-	nex = xfs_dfork_nextents(dip, whichfork);
+	if (xfs_dfork_nextents(dip, whichfork, &nex))
+		return true;
+
 	fork_size = nex * sizeof(struct xfs_bmbt_rec);
 	if (fork_size < 0 || fork_size > dfork_size)
 		return true;
@@ -637,11 +639,14 @@ xrep_dinode_bad_btree_fork(
 	int			whichfork)
 {
 	struct xfs_bmdr_block	*dfp;
+	xfs_extnum_t		nextents;
 	int			nrecs;
 	int			level;
 
-	if (xfs_dfork_nextents(dip, whichfork) <=
-			dfork_size / sizeof(struct xfs_bmbt_rec))
+	if (xfs_dfork_nextents(dip, whichfork, &nextents))
+		return true;
+
+	if (nextents <= dfork_size / sizeof(struct xfs_bmbt_rec))
 		return true;
 
 	if (dfork_size < sizeof(struct xfs_bmdr_block))
@@ -778,11 +783,15 @@ xrep_dinode_check_afork(
 	struct xfs_dinode		*dip)
 {
 	struct xfs_attr_shortform	*sfp;
+	xfs_extnum_t			nextents;
 	int				size;
 
+	if (xfs_dfork_nextents(dip, XFS_ATTR_FORK, &nextents))
+		return true;
+
 	if (XFS_DFORK_BOFF(dip) == 0)
 		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
-		       dip->di_anextents != 0;
+		       nextents != 0;
 
 	size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 	switch (XFS_DFORK_FORMAT(dip, XFS_ATTR_FORK)) {
@@ -839,11 +848,15 @@ xrep_dinode_ensure_forkoff(
 	size_t				bmdr_minsz = xfs_bmdr_space_calc(1);
 	unsigned int			lit_sz = XFS_LITINO(sc->mp);
 	unsigned int			afork_min, dfork_min;
+	int				error;
 
 	trace_xrep_dinode_ensure_forkoff(sc, dip);
 
-	dnextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
-	anextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	error = xfs_dfork_nextents(dip, XFS_DATA_FORK, &dnextents);
+	ASSERT(error == 0);
+
+	error = xfs_dfork_nextents(dip, XFS_ATTR_FORK, &anextents);
+	ASSERT(error == 0);
 
 	/*
 	 * Before calling this function, xrep_dinode_core ensured that both
@@ -1031,6 +1044,7 @@ xrep_dinode_zap_forks(
 	uint16_t			mode;
 	bool				zap_datafork = false;
 	bool				zap_attrfork = false;
+	int				error;
 
 	trace_xrep_dinode_zap_forks(sc, dip);
 
@@ -1039,12 +1053,12 @@ xrep_dinode_zap_forks(
 	/* Inode counters don't make sense? */
 	nblocks = be64_to_cpu(dip->di_nblocks);
 
-	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
-	if (nextents > nblocks)
+	error = xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents);
+	if (error || nextents > nblocks)
 		zap_datafork = true;
 
-	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
-	if (naextents > nblocks)
+	error = xfs_dfork_nextents(dip, XFS_ATTR_FORK, &naextents);
+	if (error || naextents > nblocks)
 		zap_attrfork = true;
 
 	if (nextents + naextents > nblocks)
-- 
2.30.2

