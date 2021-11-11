Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C054BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972F861260
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhKKAOX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:14:23 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30244 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234172AbhKKAOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:14:23 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AAN39tW014459
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=thNZK11Ny/3Yni375vpRVPnfmok7JQD6p9gh9/TsZlQ=;
 b=agMDCgwIM/med+ELQuQc2r83mIUBtZmGjU0JAF+a+vnDxc1syO8cPAUV7TS5ITpMINRm
 dgByXMzh+r+ugKTkfr5B2uknum+b8cd5IebXR374eoeW9NL0L8hj8z2mMgZrxj1+3QOg
 Rf73tjxo6SK+fRZ9Y2KlRExl6/yM7Hmlev12UuI6UtLJa8X6TOzyh+DGn5LjImQXm/98
 3s1doR4MJnVKNtsnDaq+XK0KUYLUbClqCtAi2Sf/2ErieE2hFu5cKpG3wHY2J/XXN/i+
 DsXS+xXERIfRWynwCpeie518ADr0SU/d9n8COeERaK/unmWJOQffTJ7ynYbJvlAzwXR3 QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c85nsf9bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB066iV064032
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3c5frgd70v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDHF3eNEJUwuh1l+OO6BxEHztdwc50ssVSugSe9h15irLSYtFGAGBvCsWN0G4D1Z1xb92TDShjRmybdxwWM9bmPwKhEjr0kB/to9lqLaex23CnAf3/xgXPf/rdC+aARcHKuhsHM0zjQI5Ny+uP+OANzvWFzsQGk5wciv0SnEc4IA75AOwvLzzw6CSMZ9rFe3dIrfBc3JN49U068uv1IT7naWHEIv/TUgK+VyHWmWa/P5i6z+6Unapm2qICUZxdewqxZXQF2BGED/2wXZ34rFXZCX4k3MFuCwhIl09m/05F44RDI3+CjYkL6B1kVI6yQGdl3yLp+ZiiVs6Zv0zyJbSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thNZK11Ny/3Yni375vpRVPnfmok7JQD6p9gh9/TsZlQ=;
 b=HdbPevfuwtS0BOl8EeIZyFjuZBEzdel9wI50E6jyCytOyFLYY4tcFgLhnQzvBsOqHMx56JYlrNbZjSdtDycYK781cuGClRbG/1yClK9xb/NTsJOH0dhdVIeSPG3wJh+rt6XyGrXjPTckY6YyJDkLRGuULB+hVdH4seTALuuXO7tWZcOoPr4J8gQf4+uuUunSVVKxlXA1qNve7nvH0dam7/4K4K7rdF8jaRYoQQPclp3JquSTg95DVjM2ObEWBJgDiCipgw1zfmTucoMXIDb9JxP9RWO5P/FK4EsCozJElczvRRwuPuyjsVQQ0wJTgWoKLEdTNmNOEXxRbMI7ECpnlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thNZK11Ny/3Yni375vpRVPnfmok7JQD6p9gh9/TsZlQ=;
 b=OJSB9dHm568DVQYs6YzTVsO0zjwJNZ6NajK6kWkRDxDMP1RXt/RetOzN+IulGP5cgdX0h1tg3enSTeP78/vef5+6FDhtLzv5YeYk254wFXE5akCiajH548Vj0Y3v7u4uZdwkDaFq7dW8KlBLIGN9ZS631ICUtzv1Ik7jlNANpM0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2252.namprd10.prod.outlook.com (2603:10b6:4:31::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Thu, 11 Nov 2021 00:11:19 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:11:19 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 1/2] xfsprogs: add leaf split error tag
Date:   Thu, 11 Nov 2021 00:11:11 +0000
Message-Id: <20211111001112.76438-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211111001112.76438-1-catherine.hoang@oracle.com>
References: <20211111001112.76438-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0428.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::13) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL1PR13CA0428.namprd13.prod.outlook.com (2603:10b6:208:2c3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 11 Nov 2021 00:11:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf1c450-ab58-413f-43e6-08d9a4a7c98a
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2252:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2252A1C166DB596D1431B9B989949@DM5PR1001MB2252.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+STwpeg14h/XoeiyD56eTKvFfKEURutCP07Qt96dWv3NgjduQd12dntSNNaGVLThhlDmwOnotnCOxLxJwWXOOghZo0qNM1T1pro4wRDWsxkeOWmW0Xa04LK7yQLgf95OpHUZhTCyrC0MVrwdl0p/aW8IqPug95sHJzrqTf/WkOaPup0zm9r2uF7yxQeBDslSmyduy7L1gnYFm3Ot5tDiWOA6ZTrIRgumnf1mzCsnXi+80YXVww94sYSTRrNXaLgd/0c/HClIBpupP/8h8+z7VG+V1EhuICnwFNOh4nhO0ar/H8pX43RSVkxYbct/1G2pDxmpS6qVIZdoBKwpixioLjq5wQeFx7bBvB8W4mZrUuzhIOzfI/jfR1pCMgibcZ9tYY9QKZMtLYBEJ/Uah2xK68qQmTI4tlQxpPb1NHF8m7/ELuudT6J1c3g4yRikvzdSEZGCTGrfKqGDfh218mRYh6cnlJBcSN8tPLTNdzvVvA9kv+zwSSquhluosZo8ywrZ3IdiBN7LDTTiYpzi0cB8BJZeUTwz+LbVb852a5FAbWBGb72dcPxw5yO8aMwWh6I3zFuw95YDuL8g80Z8xV3JBDuDnszZXeLDifzAcVr1EYoSbnXfqMwY5s+6Fday4mNW8deBgHx+262YSqrKSLL5o3WAXoLu/JlQQFkma+iHTh9b4tLS/rwWRCi7xhmp354/j2eTwIBquFA4f6Pl+J5FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6486002)(6916009)(38100700002)(38350700002)(508600001)(186003)(2616005)(6666004)(956004)(83380400001)(26005)(36756003)(2906002)(52116002)(66946007)(8936002)(86362001)(44832011)(1076003)(6512007)(5660300002)(8676002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?doIllH3SwMkD1RGXXXXA9uLJ5wG5r5p9j2BzL3QlcsKbkwvinc+hDsTN9pVP?=
 =?us-ascii?Q?Npz7a0OP4PVuIUTf7YkkoehQrNA01Ob8t687AQFkfhY/LH2jwTL//fzfEwH9?=
 =?us-ascii?Q?uqG+cw5bkV3qTo3MeEd1dG1UI4c730iZo3bYXjh/jHqqNDJDrWw4xDAFWMyR?=
 =?us-ascii?Q?3UmlyhVpNkaIf0bFZepFBoxF9moNxksofonEU98u7WbqqOJabBV7ChgJD7RH?=
 =?us-ascii?Q?jCwkwCkkbLhtIfvNfFlQXlr7jSsjeJ1jsDpEDL9HAxUnXZ70vVSpcbqXjQtY?=
 =?us-ascii?Q?+SaXNHZeGiug+JISDMnKRZK4cj0Y3Q8HyMTsr9pVf0Pz5guXPgJOvcD4W+H5?=
 =?us-ascii?Q?b8Sr9Tq/NzYWiN7KRKSd5Gk3dM8cE+AiHnz1ZVf1cErrQ28dJ0DD0qvOMRTp?=
 =?us-ascii?Q?DOc5hH3hyJ2excIZkpIlD2VVg/LH6TfMLd5Ot2MtVJ7T61mkSNOvAg64FwWZ?=
 =?us-ascii?Q?uBdKkbWq81Vnx6vPPuTyyfA2tObn713voc0plDFTZ8lXDzffzIh9BqGBtFYi?=
 =?us-ascii?Q?IhzxWvIhstlBDJDJzhqBM7q3gqXhdlbGLyJ+FN1tMv7/kOuiKMFBjLGSNefH?=
 =?us-ascii?Q?U+5oEl4lhEdHHfOhyJGKWOcNmV59QcFR1TYxH2XFM9EE8iHqqkrG7TQfSmMf?=
 =?us-ascii?Q?NIvWCsHQ33t//dqkEXMlFH9mpBwpFZIr3330GZImCRSlkUYDJ7UnIdsspKFY?=
 =?us-ascii?Q?EXGVPN+O1IMS9j258yVEAVO67HGiUBPGxSU2RPJ+0KByimwNG/hAImF4r+rb?=
 =?us-ascii?Q?RaIayinIIqYEK87QXm4AoVBAZed/5EQ+McHA9Q4pLiAKdUitZkDSRZOP/JHY?=
 =?us-ascii?Q?gYdvGXbjX3NsQhFZqkO2me8Gi1pTd2Z5jPFDVzdCBG573cPdHjObyiYgIKMb?=
 =?us-ascii?Q?AhFau8c6Tv+Zuqr4X5O0DoFIIwp/gu9UXbV3RWLh1PcG/woWdn7EVWTg5NSf?=
 =?us-ascii?Q?WlyJ3YfS81OwVzD2NDlJb8N2W7OAe3YU5SHz4lCLRgogpWcvFfqlggqay8AA?=
 =?us-ascii?Q?lsKG5MdTWmuQiQxdSommY7S8Y3xrPHJ6TYU1hTu7F51fG8QZ4LqEWLKyFhnd?=
 =?us-ascii?Q?9Hea8dfzoTx23qOzoThnsJxXQVeNYsy7StubLs6/1bUPIS6Gdb1f1pWOzIXj?=
 =?us-ascii?Q?mnA2vJtr+BxTzjKFsD3fj5n3qs6IbHVSdWVPODsjZiB83nava+fz1rX3k1U0?=
 =?us-ascii?Q?OTLADa5uk0hYeGL2zc+uesOhEdsTzcwNSzQPSAN/IK2/AkgIA1e+Lvy8SDFl?=
 =?us-ascii?Q?bv4OQBQiO1XiW79jutyrT8CTxrProGK/zor5s/iO1tGxUHyelEtGuty0qNzL?=
 =?us-ascii?Q?H1ZNjzTa9s+xilDd00AN2yQPG98bO9LBGAIfC4T8jAyrYAfRjcRpEI6l+QxI?=
 =?us-ascii?Q?lsGdzAKlUqe+zCYi6s21rPGd4TQfW8HVLQ12e1PDoa5eMa1ribQC+NJMLOEw?=
 =?us-ascii?Q?lklTGl0bJ4FP37PHgGuKYW7dGdtA0tx5cW1JdwMsoQsHK6Gyq64JL//WI47c?=
 =?us-ascii?Q?f7W7cXPlrys4+UjrspebbORxJlLHWAPa7rsWo/7pDyi1vEctz5D9gkcxGcmA?=
 =?us-ascii?Q?jg851pZ4q5I5oehJg0YrGBBFcbz0psu/kRWvKM69evovNO3HdXuWgxuj+p11?=
 =?us-ascii?Q?1xzUINreBzxGqsHq3qmx5WvhRk3P4jSoniFFeZG5t3v+Ee1swPXjjzcxDEMI?=
 =?us-ascii?Q?i8yQvQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf1c450-ab58-413f-43e6-08d9a4a7c98a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:11:19.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6c1yXybCr9pNRAXwQh3ceBXOxN9HEZ4o+ehWSy9OfRwzFydIyS9cV+cMp26nZSLMqLwUr7GmiIieUthYdl3TIA+sKDTmfEfq9mxISMmi3oE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2252
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100116
X-Proofpoint-GUID: 1aW50xo20_CWuRqIBz9_lETT4Z2-ATf0
X-Proofpoint-ORIG-GUID: 1aW50xo20_CWuRqIBz9_lETT4Z2-ATf0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_da_btree.c | 5 +++++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 43b51db5..b64d4c74 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -59,6 +59,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
+		{ XFS_ERRTAG_LEAF_SPLIT,		"leaf_split" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f4e1fe80..5c996ced 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -479,6 +479,11 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LEAF_SPLIT)) {
+		error = -EIO;
+		return error;
+	}
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index c15d2340..31aeeb94 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_LEAF_SPLIT				40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_LEAF_SPLIT				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

