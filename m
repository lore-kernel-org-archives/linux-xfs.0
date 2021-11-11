Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1196C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD6461251
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhKKAO3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:14:29 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38470 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234172AbhKKAO2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:14:28 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AANdm9i023573
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=qt7dEqIdaL9yhB3uTJMsFju8zdof033LXls2vUL6PTU=;
 b=xWJZQgX9sRPlLwPdQyvC4P47ZmMiPjMeRD7Ri3sIIwvvczJQ3McZ8LGqMmr5eE8bjsqO
 H1moLDD3iNnSW/g/x2urguSvYldwMBMNwWhPFSAZ8fpKaCVfWbO+f/LbyagASPYmADC4
 PyLUVZie86ldlkgGgBlpZKQyPb9x9D4g+INIHVsVLVKCamDpMJj4IRzaLzObCm/xulcZ
 qNgD+AUW7O+qr9Jyz54fWCUBX0NqtbWZd3G5do3X8NkEBolgBRFvOWHaeetZ901eQ35q
 JJ1wyZNeK81lgnFUkdx4QHBQqKXQzVEUX+XZoZVC+LmaAlKX41o52h8z0yONVQIAtIKQ Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c7yq7gg4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB066iW064032
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3c5frgd70v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8rtxsEWG9tEwcQgZX2Uqx81peBayyorzVrlMSklLYgG4wdSxeEso5W/SZkJzok/oKUV+wWaq8pn8rqp5T7KPMdXpp50e0/+zI1n3aaK1wX0qQqKy1553a3JUL3FVeGaZSFKx8jD319lbl6GW9NEXiiKeiJa5BOVg+SEbZGD+PEKKhSvzJpQrKIb6hi3/vTCKCx003ioq+Ond+Uu7CFLrl8UBQwJFJSoLVQlpqk2wHGAj39XfWRZaa86iEuutJzRUq1pZHvkT/jnTY26OX9j/L7XB/Ftw1lGc9deLc0oKGsjSA/0PhOzYmLHsdRjRgKEiqqqrZkcEmf26nncwTBxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qt7dEqIdaL9yhB3uTJMsFju8zdof033LXls2vUL6PTU=;
 b=SwB5yXlLzqK+hxC/4sw8YYAStQA6Yud1Z2LlytxGY8pHJNUPWfi9Syn1uS40mssNri9Pl4b9ywJi710T4FNLjk/eFKWhVMPvC2haM1dv9T79G/HAs/WT7WbhysKPTYU/BjRbuXrF4LTtjQ9VutmdtIsVs7BkImPHamiPmHYDnvh6FYMPgHXnLhVzTQPUccjzhVu9koMIDZbyE4tr9C6gcm7gABWXE7ezIzpjUhqL/u+/QV7Ut6mfxjlGRDkdLLNdgNbiu2y3HJj//DPpfkhdY3lNLWuD+QxAesrz79NqZGjW+jJ+AGTpt3SLEwaZ3nFkPokc5TNuiQMacS54NwLnbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qt7dEqIdaL9yhB3uTJMsFju8zdof033LXls2vUL6PTU=;
 b=AGa+652Gr2HO37HmGrRCfXewsLcQpUDiSBTGiApUJkHQ+osOF0S1A5Y+QIRysKPUMJAhNLrSZ6pHnhHSlVotqCEcQtfkJcUfCB2NguC7mc/E73mZPwg0tdgTGCzraJRwFXca1JVHH468Ykcf/ZkSyWfACnIqgkUasxUNPlWt80I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2252.namprd10.prod.outlook.com (2603:10b6:4:31::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Thu, 11 Nov 2021 00:11:20 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:11:20 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 2/2] xfsprogs: add leaf to node error tag
Date:   Thu, 11 Nov 2021 00:11:12 +0000
Message-Id: <20211111001112.76438-3-catherine.hoang@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8f0a36cd-c17f-4454-f69c-08d9a4a7c9bd
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2252:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2252FBCDA0BF757BBB7815C889949@DM5PR1001MB2252.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ccljP92PseFlRH5xFa+K3wvLrZfuhgoF3dh9dMiyD6iLUXOTzvXAByOd+m4WgsRIeL4RYh+7gblY18Vcvp7XSOlolg8D2mykSjo+pwwcdxuFrFKgiTRt1TKvm9JazxfMYYbFvNTGXqs8MHHX3OKwS/mF5zaK36H3ym0bwNS3yFN5eV1F0TgKp3FOTsNiiVa4qIgIkQ6vBcmCLoBh2WZcGR3NCMcxd98Yj7gPI93Sr4sCf0vDi6HAxtwsIuRc0oA0FoZgzZuF+qobFmOlNxeTfC8RU8NuvkY+ierKeJdHuX5H+a2PSqzKtWKpwZEHdlAL0+YNrrvbHUwD8Y9zpQjEAr1mS1TRYRfc7uLu5NsEJ8yl3548cSFAFSgAqGfwNvijGjIG1UwHLK4Qn2cOYtAISkPtIed6lN4IspsIhJGfMYMS8oVJCsGxA3hRf/NDSlVSeVeRnINPMjyZpBG0seP/wX2sJFaulD9at5fBnyXt0w2yK2Xku+FIZmInFO8fzkIOtRCy2A9bjGs/T4vPR+QXKF3hLGs6iqGJ3Ql7uKqLzdIeQRlfAIz7UTzuFqJMWDlwYHKhmbW20fLaDWwBT0z/GPoJLQI9KZ+PceWk0EryxyLf2RQWLZkF49L6INEHWm0m8O6mXBI3HbwkatXMHRgR2P9L3BfLVSrtLwe0sYdO719NauAEwZKL8t9xlGjGq+GWK7kMvuplsOdkAlDUMWDQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6486002)(6916009)(38100700002)(38350700002)(508600001)(186003)(2616005)(6666004)(956004)(83380400001)(26005)(36756003)(2906002)(52116002)(66946007)(8936002)(86362001)(44832011)(1076003)(6512007)(5660300002)(8676002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?STj+On7DzcEkPclV/xUywTAXGmNf1s3xVPGzNOUQilvY5gup240c4OuVsKpX?=
 =?us-ascii?Q?IH4CdBsM4zFzspHjRTd+Z9IQH5pqltvrxqN5m6LK1E8Qqfo7t1MV9arlwgOL?=
 =?us-ascii?Q?r9N+Sehv8HZoCKZQs/ex3JShq8iFVYgk9DziwONJDTnNISsAtB7Vtv7P50/t?=
 =?us-ascii?Q?laCUjmsvA45kJWR+pRcQ0PjlOy2ja1XWOXzKPVF9so3+9/15ZHHGQcWV7MJ6?=
 =?us-ascii?Q?diODFfuUt2SGS5d8FoTR5MPF8/oohsidhG7v2yB3ZCGQzvLooWIa8siXfDbL?=
 =?us-ascii?Q?5kC/SjyTS7HUZsK66n6x31Mynk6FdYhixlb+gxiAzOZl5PX4z2a8AmWGZpRO?=
 =?us-ascii?Q?MD2Ki1kvQElP0TphB6m8jwzoM1ifmPBE6Vwl7Zbm505QS2lUbJL1TpBjKoEV?=
 =?us-ascii?Q?VFpruEV/OA8MtsAyEv5gd7JH+b0W/hGov1l7OWSrIsZg2rfdldkQDtCJZgeG?=
 =?us-ascii?Q?268D5HVqKOocLa8lNLsvrXpmf2iex7l5B4xO6rCtvdiaTC/lR1PlX4SGNY5Q?=
 =?us-ascii?Q?BLy9oiP33Yn/6rYFM5V84+d5Pyr5vHuB7u8DgQWAzhnoSuW7ElsWrIcBAqXt?=
 =?us-ascii?Q?vbnoXaaF8hZCe/kH5I4Q4f8Va0br1nDWWnup4Up2q7HJ9OFz3uN0C3g4Fu9v?=
 =?us-ascii?Q?CgFRuuSHv814FDjUUL5Ld09cSYDKbb8qfFQqZn3UZplplv6sg8W+MKhNKUwF?=
 =?us-ascii?Q?Q23bdx//e8DjY3tT2awwPfYDNUHcLFjLm/hn5NHros8kOucrUPfKzxmpSqHJ?=
 =?us-ascii?Q?gmMPLTBxglHo8783Pt9x3venFu3frG3KwmI+ieqTi/65fyQAiiW1b16R6wTC?=
 =?us-ascii?Q?oaE9rR+RE6aEsefSEEie7XTZo9KTSsq/TdX84XVUhu2SUTf/A/oCedy/e6DD?=
 =?us-ascii?Q?OPyg+RPGnqEeykX76Dcken3FqyUbhmdAlTv6O9y9VSIbU6otUu62S1brAbId?=
 =?us-ascii?Q?+IEx9vc2KlZcOtv6mVBb0UdVW48og2BBwP/+/XDcAMD8njUeIAQjkEdCAeQW?=
 =?us-ascii?Q?cE+gLLPfVaTDN3UYejaWduwd+ib1gFCx2fEpVJVs5ItQE+1eoWLllfgy5xxV?=
 =?us-ascii?Q?Y5xFbgCq9KUJgQn5izeAf28akJO2I9edGAHCtoUSZv3ycI/rnfh4GStq1iqH?=
 =?us-ascii?Q?eOZxLTlSod27/NBBDvxQoofAuTX6GW9wo9py/lDy058kxRGOx7pQcuJ6ZwqU?=
 =?us-ascii?Q?QW4lEnW7vJhm66USSICmNGPQ9NiX8wogOcceUuAOwvlibhXChH1rBXVnepuh?=
 =?us-ascii?Q?WFavgobE3I0aUcTXV255vjBPgfE2Zx7r/NMYoDP5MxdS7BSoQLnRYTgLZ1zU?=
 =?us-ascii?Q?udEZnnzqSfykcjn5NhZ3CJMQSW4sbbA+fi5cwiW+7a0pDzMecaHAhWDVSLwN?=
 =?us-ascii?Q?ZYZQPiEQOrDTTbmsqyKDzaHKDPID7CbMgCsZwlGygWcfIubKCYl2k8xTAZqq?=
 =?us-ascii?Q?qAMKqUe+Uh8IErJBZAbVSjE1kD6if6vIYSQ+1xCdWlK0zmIr+kZAJ/JkVF0R?=
 =?us-ascii?Q?3aho1pjwGV8vHxPWheouGVNi/9PLHCqoWq837frXwTr3HCHO26BYdbBInp+J?=
 =?us-ascii?Q?pFsL3D6B5lMLq+wGu/rpAUHyD9pfklTnwtqCerRLPaNMj2BQQEVZhYc0ELig?=
 =?us-ascii?Q?iV9jgNgiNQwCEjxigL2vB+QUrd7HJCETimOOx5nOXwHN+iy6K+YOfcqzm9ae?=
 =?us-ascii?Q?Ry5D2A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0a36cd-c17f-4454-f69c-08d9a4a7c9bd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:11:20.1888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwbP7OeWwaspT9/1u43GmoizkAc9rkkthikZSBi1Zg4haCkK3WO0bm76kZWRUr9itlNHbeNB2558f0TZkB9EY+L7E3w1WwOrd759njK/Tl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2252
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100116
X-Proofpoint-GUID: dD8izmztn20w_mHYQ7X7SpQE1mXm2XtX
X-Proofpoint-ORIG-GUID: dD8izmztn20w_mHYQ7X7SpQE1mXm2XtX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 io/inject.c            | 1 +
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_errortag.h  | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index b64d4c74..d13a5494 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -60,6 +60,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_LEAF_SPLIT,		"leaf_split" },
+		{ XFS_ERRTAG_LEAF_TO_NODE,		"leaf_to_node" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6c0997c5..31ac4d80 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1181,6 +1181,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 31aeeb94..cc1650b5 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_LEAF_SPLIT				40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_LEAF_TO_NODE				41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_LEAF_SPLIT				1
+#define XFS_RANDOM_LEAF_TO_NODE				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

