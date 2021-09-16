Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDD4C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A646F60EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhIPKKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48814 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G9077R028338;
        Thu, 16 Sep 2021 10:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iIJ+I0kn2cDRUCd6EBUh9bkzbfm0/tFC/EFWF3P19JA=;
 b=wXir4+w8/V3x+/j+iPOqysMktjRiNohpj8mkBSrXNQGRFDy13Qd2q3G8ID/m7XnxDKML
 ZflkuUhog8/paRZdK37EV+8PfRgSTEd1jgwjwOBE7+jzndQ4Z4mw3zz9P7XbjLezsjV9
 Y3zp8y+VvYTOz1qg3flV7kFO/STffRbd8NHfc3br+pj+WM4wrmL0LEy0pYXaYJ6diCgU
 vWUBlfl9OYMWq1EWKGVP9DQNHHoBkHt3VQ3lMaf29H+H4vGulAxslg+J+l2EgL3SBOn9
 /HzYFQlmoIG+dl+EZ6T5H7FZCcg7vV3yNnM4PUpPN/fjTOkzxDGACHIYRDC+CP3HkKq8 fA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=iIJ+I0kn2cDRUCd6EBUh9bkzbfm0/tFC/EFWF3P19JA=;
 b=TKICYGF3WRTvrFP5JLV7+gUrVjGffz6oys1j4AY26n5M2NBTC777Ot0dolNpO/W22+xz
 /h92s4kwdpoUX7gDRhTbxAvNZXH4WgedeZsczFqi8tODS6rAFvc4LpCMZpWH7vax3xHE
 Ek0VPCfTSxuyB33VbiHuZoF1aO8yBWzW1nyMx/bxxHlI103N/xhRqI530+ZQL1G2FOIk
 +aO3MmfG2q27LP/EjtlsISuGlbW+lAqVZIQasjUHHn/kxayVdBhVE819n82cYEnW8/B5
 9UPsohkmtjTAOeC4hcTm/HyDsf7T7Y3heaUu4Al9EMkEy0ToBV+OAo1aP1hDEjK7/skD 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3t92hd6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6d4a160629;
        Thu, 16 Sep 2021 10:08:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv5pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kX8XkUS02xv7VnyZL1LKt67Fn9wv6siSWTkLmzO94W5D1VpcinHjs/pVRoNKBQToK7uq8KkIw8EmI9R2CKsUPRelGu9lNh0o0yRQFDdEFr4J9T61G74DzKCM2vwo2MWO1uAaO6Ukqj9u1xHv4tEUSTLiYfuEe/meH7HzA2jBUu3yqSa0C6+4okbC/G/Ox68uwwepVg5DAYAbi4jfiHiT5VCcx9Xh2tg40bcL7z2uI8R0IamDzVonPiEAxaGRxBLl1HZfkWCt78Iis8GW9h/7La8f1IwMf3x6tyqy1e4b31wZ7QVzo4v8qmcqB0GWx/egrS1DbFfuxbz0P2N1UfGGvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iIJ+I0kn2cDRUCd6EBUh9bkzbfm0/tFC/EFWF3P19JA=;
 b=ASsb6pSIA2nsTFUmRX0ZtYWzOFTmPZJ5cWlHLuoUHItW1zmYvTLzNkaUkSCX5qZfmpbkecCkAUz53frlrcmdGzPF4BCQ2rGdex3IDdovF9gz+JT5AmP3hhZXu+LTvRS5M8h/4CVAmuyy1zPF9sFrHMMv+e5xjpnt2NPSD+mhGG8Ef1A2jjXIRHkt3R9eUdcnKlxofLM93jbGdtm9anL5ZbzIad70vdOI9wf4tEEUTQu9TS2LzDO7yxg1F+E8lclJEgywJ8bZQM1cXIYPYI+3dWBgduyPsp2nwWYfEvlMjgbpSNACfUMBbDndDFxHogu7OlOCzDBZxpB8Ru5xkzb0QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIJ+I0kn2cDRUCd6EBUh9bkzbfm0/tFC/EFWF3P19JA=;
 b=GaZiYZ0N8MuYWNPAH3zIqQZ24EExaNHvjTmQNm3IOwueyrAP0lsd2qINbEzM5YupC1S70qYjj2f/b8S5wEbax1Al4jm8UAF3xv2ujHleeQD62Tde5czWJPFnDMLJ/0u0Y6yYB9LyysCvdyNzURodeVzZfG+ttkYGBMGR9jAoB48=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:08:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:08:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 02/16] xfsprogs: Move extent count limits to xfs_format.h
Date:   Thu, 16 Sep 2021 15:38:08 +0530
Message-Id: <20210916100822.176306-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:08:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62d39488-84d6-4aba-e183-08d978f9fd67
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878A1C8651C3C563847BDDBF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPXrCrb83x6vdc8bJaAyL3ORYpMSFPajtQ90hv+hie5OTQWlu5aJH5TmBIkUE3vWUszsY11yX8NmJy1tA8ApwJDSzkyOkDDsZ3MJLUg8+8FthLw6k/BTL36SWECAh5ATLQAH+jAVEKx0QWZPbk6OTfapeuvc0sJEVc0TGENmCLp4iZ1UW9R9D3vbO4OVrrrz/aJCILo0S5tqx35E0SKWpGo71UKuHuiZ5dYc6UOucdDWcoqQ2iqHKuGh+wxuUQu7DcLjkgrhXdvQnnqz8+3LVeXp7V8+EhcI+2JrQTPFmM1Sjb9IYtQPB7W14kb8dznk7LsbK2FBCCjwFJE19JIUX1TID2/KFYR+m25IZRqo5YQt/tidbcobFrqSIEeqYdOfHTaWotqb2PKZ/J4SZqNMyxIejxKSiyjyJsRyg2gF6DXsLHkblExbVEYvXLP5nQjvrsRO1ykR1J4ReniJ4GC+3VaheW9lEtPsf9xQ6SSKuf/0xH0MRUMd1fcjI+dk55vFUKtgv5XF4SKWBIylj3vo2pdMr8Enu+vRiZyY9P1T0siLAiCrz6MsePptyiUhcqbdh9HttN17GXFuL84at6e3yCjurWt808Dg8FORwZS93aDqm0sQsS9Y5oAL0LEzpQZE0itkkcru85UD2PuSg6CB7tNOSNH7V0bR9CEKE2OaWWoEHoF8Q0OyA3cMJneJQ2bCJjOHW+O7Ub2Lr4P0CqgW/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JXytDXGBm6o/KVfPokl4Qu9ZOwEwzkemia0wV6ltEhU3KB2BNy9vjODkjdkP?=
 =?us-ascii?Q?absuG8XuzRnzukUN+kHDB/QRasUpP7nVTGp+BJ7eLg+nnmvJK72dunBspnYS?=
 =?us-ascii?Q?6w+A39fpOcnaK3tT4K4Jp9/aQ1J9+LD16rP8tyP19ofHUtl0TsUmmn5jGKnh?=
 =?us-ascii?Q?vv4/5kcgTHB6fvWYT6hvBDqiL9W3sXdxpLiqmCjl2xzKHQCRP8akJeFI/FSi?=
 =?us-ascii?Q?aO8FZzjpg+viH1de/YJlTGjn6JCdfrjTDzAEJlic9Z5xhEaFZudJI+5/WZ5f?=
 =?us-ascii?Q?6bRiiJwK6lKIDpdoEvupR0V8oab5b2St6yRvtf8ppqrgLayz4qAmImkwOOFK?=
 =?us-ascii?Q?N7LwSzBO8zFpJyz6EI0Y2b3oLF+tnSCo0fz5mM7heCAZXEm1xE21KChBgSZd?=
 =?us-ascii?Q?KugR0DXt+8XA+gQnemVUhd/ifW2oOxPRBPsrAoqWjgqvInB0vrz1hwyh5Syj?=
 =?us-ascii?Q?g0BTmLumk6sra2G8yFjBMl+wBfcgODNZ32Mum0+njFzpItOI8dDq0Hn1Ua9f?=
 =?us-ascii?Q?7/SaHeB0pHDh9pXeK+TXUDiu3WIOIA4HsaJm87Yy+/hGtmke+56RMYyfcJU0?=
 =?us-ascii?Q?y0K0jFfjebAPlkMhVuDgumXaP3IpfH8PMqbcpSwYfcDXcq6gX6okLyKkbFKY?=
 =?us-ascii?Q?+2zUCGT2aEnfcoA2QVScI3MDOYKVz8yo8NHAyNC9T5oLBW3z3mBChi/9poIg?=
 =?us-ascii?Q?XpkzVhUSl3Y03rcnq7ufjdiw3svKFJmKpzulfr6nRUw++ik+IWopASCuVuvs?=
 =?us-ascii?Q?dHzAYuVilMMGe54tw6VhUU9PqAH1tCbBFoprwLhHsQyrYXgbumZDUFgyQUqd?=
 =?us-ascii?Q?wviCYxdKCzzG+MZcSNHbYuKH8LBQb8/NVUtaRmYyoPUWlTI4JilbtVjQkcfl?=
 =?us-ascii?Q?lPKhTA9+dKK8ZMnFtJctO+iHPwsJqh+dfMB+szHa7R0MCmRXDpIsOdVY9NZ+?=
 =?us-ascii?Q?5lkp4N83a9UNgdtRpMn1yqUNOaDdi0/mdUld/zMA0j8anLzHwVqr12ZNO+8D?=
 =?us-ascii?Q?DfA2rPFXsDPsxxRCcQjRsDLiodxZdvxJ9B+lsOpSpCDsXO6eVONDESEKK1RR?=
 =?us-ascii?Q?sd+oxSHTZhN0KFeQD50brPu79tmvHIgrQGXr8kSx9yPKfrkgZYlNLp+H0WR+?=
 =?us-ascii?Q?zIk8kr3+n6CZy73vRkHyx4udkRwAngmPpxZZEH3lfDVKer23upQNagAnBrfB?=
 =?us-ascii?Q?uC6gOF+uIsaQAy9EsVb+ZVRPoZet3UR6bJoTM6sBMP5Xh1KJ+ONBdacbYj7C?=
 =?us-ascii?Q?Prl57de932XTZwWjBJtUqUmYcsCB/FtMZWQ+NYM42MxLIKsbK9AvdLCC4iP6?=
 =?us-ascii?Q?6ct8snDRconPi1BQEw3T78iv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d39488-84d6-4aba-e183-08d978f9fd67
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:08:54.6704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChKqzmxj9U9cf1U/ONF7QOwmshqomgNieIxgC5wV5iafylZB2VCshcODdbKTOGndhHHFHZAQLyx1lrOpoDv7rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: uz4MwEGpMKnHgKQ6dYs2ZlcbKqfon0AJ
X-Proofpoint-GUID: uz4MwEGpMKnHgKQ6dYs2ZlcbKqfon0AJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 7 +++++++
 libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 0bc54104..bef1727b 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -872,6 +872,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index d0afc3d1..dbe5bb56 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

