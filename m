Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCF0C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbiAJVZ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:25:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5118 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344271AbiAJVZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:25:10 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlXYC026175
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=p1xjLYJXipUsei0fiJcwDobHYIv1oruEvUn1O/3j5dA=;
 b=r0bbLlEfZ+Qio9oxvWVPvSvp1GZokIY2WVv3xOMcJ2o01BPI3Xv9C67J4OicYcq8Gcxo
 pJaONVAlqSJn87bFA9KxZ72yguCWPVhPA7R6JBqqzKw2/zFLkc/QnpGKwZckmJxd7q1V
 4MI+jXIZdOd5ctL9hCLahnmtCyK3aBwf9JsPXhRTLy68KMhEDSebYf5cazWoFyUEXg4r
 Ewfv4A6s3ohTZdgWItDoeT3ziujbONTPhrN1UHsy2VwWNBDo+nGEGQQCSttW3FV+eW3f
 Sz/LEG8RqHqwHKm6RcusHQ97mqEkA3FByM2jKObzj6t0LyBzAZX8KUWDhUIqdWugw0m4 Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtg9q8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AL072W013591
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3deyqw1ndt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TX6CobxbL2H9AmbvvsgmaxJP8fFJsbkd9gUMClm/cOTsE/DVuFPodL4MLA7HGPAZ+GOAodMoumyeKeE8HYtj9RqCSjcEqgOkvVtr7bV2MdgO6Y1EVS150qaPZejFaPcgHY7mf4njRRUF5akWJFppoVzT51mObJQJv1r50Yvd7q+3024iBmYGsxvel308itK5R6t9wrIfQBiWA08YWAA7bfwr8uLk8u/oZjXFFNv+wjR2rNWArAMewniQ6ZyrlYSSmHTIgzINXHXGSH4UgkBqW31D1Wvq+LYKSwn2ilUdODlauBcLSGZtPlSyUu8fHHvR5xE6meexnS/h0yTsrJZUYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1xjLYJXipUsei0fiJcwDobHYIv1oruEvUn1O/3j5dA=;
 b=XdktX/O2hhRlILjfzn6kjh6DHwwj/RCFLJgOkWLELC8XkH+W+4aRCKPDlABdK5CREkuZ4UJBObf5NDDnqalbD6okJe97+9MhC5ycuXQnpLV0EhK8Dw+XUuz5RcmSHMmaBkzbep3axJ+6sQVY9eQaiE6BZbz7fi8Q2f5r5KIxXcP7jFsumNJyJxO16aAkTQxhKfPRHekuzHv60uqa18ssTGq7yZx8Z4D+5ORUSxAtw3cInTPn9nXgYmajNPoFIc76V370DlAyX6aFUiAe8gijPBa8mQDlMDAGxx2rGQqwh9GprGnhlRRuriSZqkfWdt5gKGIl0ZmjWgu5mIfAjOPsqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1xjLYJXipUsei0fiJcwDobHYIv1oruEvUn1O/3j5dA=;
 b=hBJQr74DCO9E1vX5pmDRliAB7YaIM5uvYo7u7UOFihZZteMLSlg0TBQ8bRGUxqH8q+vyOrKQxY/zoNCB9rmInHZ56z4uIyRt5cWNpKn/q/CNIN1o9w/0uhNroXk5/BHX9DND3JfrfrF6Cf45Vm4UYi1Bl1yqRfbB0XU5/8ptZEo=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2570.namprd10.prod.outlook.com (2603:10b6:5:ba::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 21:25:02 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:25:02 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 2/2] xfs: add leaf to node error tag
Date:   Mon, 10 Jan 2022 21:24:54 +0000
Message-Id: <20220110212454.359752-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110212454.359752-1-catherine.hoang@oracle.com>
References: <20220110212454.359752-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:208:32e::21) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 386d2874-1801-46d0-d90b-08d9d47fa928
X-MS-TrafficTypeDiagnostic: DM6PR10MB2570:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB25700B4671C6BD285C1D2EC389509@DM6PR10MB2570.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZNWL5kvmg7TCxj1Y+5EXmCVO3SCsTkOI20ZVaxCW40+kYpE5RmOzohqp3a8eoEdnZFANOCtharNAFn5e0eJ7pCiaPnDaOdg5+LJ3aylAAVjIOX6ou3fl01Gz5RwcUV1gJhBr0IpBg5JWq9u3nb3v7cXAkurm/OMXXjWqVPYTPl4Vbfyw5GrVxlDGDRIMv7yElXwZMdM1HvzW7QLYJcyxPsRQ+emwKgRP+FuzTMPtizc9VhWQuYDd6cZQ/J8r6BIhDLX/t9gbsPBjOjfPwgLHlgWtJHgrsoygF8cbYfvOH3q6Kvgbc9tyOp55bjTgNUumVxLrAMX0nPZ24E71UqjTZGS3JayKvBw+YIxJUlqBU0cGV7uvjbl5PWHnLO/ziXH7/lEANJaMI0Wb+H1JqSi6qdjgrcjea2BJqaq5RDCdLpqc3pXo/eYl5It283JM41ImxG9iF3NZDrW4sCqBX6k3t29Z3Haqh8PIzHSnzR/tnvT3wmz+xA4gEG8p8FQfwITLCGkv3Zj9FHeosq0hf1tYo2bfl0iJmXSG9u5mER0Mh9OTORP97BMr3hKj675Y5xYLzH5VS4ZJ33n8zBoJLKAfzA3h8zhK6UHLLA1YENmkYxRbPUtxxf3wY6I8ZGq7Y1aZYw3pIs6uaHW7pqmFweiAY++2r0rNkpVoS/CsGWp6Ha6qlv4k1Wn9bBmMxFhyc1xT+9mt2M0biix47U7ZYmNLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(6506007)(86362001)(66476007)(5660300002)(6486002)(66946007)(44832011)(6916009)(26005)(316002)(2616005)(186003)(1076003)(83380400001)(6512007)(36756003)(8676002)(8936002)(52116002)(508600001)(38100700002)(2906002)(38350700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S8C7b536uCiItuazniZZf/t37Q+lvqMDqxL8d5bpid9Co2g+eVEDVFGaTlNO?=
 =?us-ascii?Q?a94PNs5JpIhOOxqgORq3j1FlKfYiXqm2iLoaHMNGFOsLT94UVjVndyuYhR6x?=
 =?us-ascii?Q?2rHLFfJbGlKitkeHqV3oeBfUIvxh3iPSNQ0oX/pzee2sVIp+GF5ZY3aaWkCl?=
 =?us-ascii?Q?aagBVaWv1zaE8bx98unU7J2IhIRk5C4D7v3QJP51inToMF4Derw7e/D02po4?=
 =?us-ascii?Q?j2+BY0/AE/ngngTREEpjS0cGKQ3a6XRbQ76gnOWPkekPQREBJR0u3EAgejns?=
 =?us-ascii?Q?5fdUp8hGxnOzFrplvTvypknqXwl3T+aSm22zSrw0xzDKNjXJsLS9L0+/TLjH?=
 =?us-ascii?Q?btAkynunldFOaYNYF//mXpfOiJla1OgrXWSuGMt6g5lR8v6x7hqKKhZPudLO?=
 =?us-ascii?Q?S1O0gI/5EAqlDvuEq7K/GhRwVA7NZDlDD8B5bTZPpVytx1qZxeFeyGaN2LQj?=
 =?us-ascii?Q?uunR/PiJpMvU5xuygRz1m5aF36wrM3MD3KJvhDvaNZtVBZ19u8wol7bHhkC9?=
 =?us-ascii?Q?6Yb1zPlMjm/mTR7owhO/u2LuARUPbvbUTcQtbb4UOqEHe+6qYpwnZSzMHGQU?=
 =?us-ascii?Q?o8Xujhmn21kN04aUSN2nJdNryD/BlYU9xHbUdS9Yt5Z8XptlNxFOVom0CtwA?=
 =?us-ascii?Q?DHZUiAnEdQwi7z9fk7nro2Xi5iRNkz4Y4OXeJNqkTudT2Optf1YhcX8/cIbf?=
 =?us-ascii?Q?VufD+F6FpWMLb5DvalYSSnO8ER13EPgS8Pe3Ywfq65J8QjGnnx2ipVBu0WpM?=
 =?us-ascii?Q?6xqyXQHgyqM2JANHygYXqImn7vHYpWvIwpT66EvE/6oa8R5SBH40aJ5wr48M?=
 =?us-ascii?Q?81WexFEa9Ufh6Mq4CGk3rwUzhhBtyEQSkjCEJSrdCN3WkE9eaFxxJHYd2cq5?=
 =?us-ascii?Q?tpuH9W/iQA8UQ0yw09t6cimIlnbQvbwgZ/tz6CTVSQjam4m2QN6nO5TMbvq0?=
 =?us-ascii?Q?+5OBLavZt9OUpRRqY+GxhIE4JWpXjRPdmqFD+eJW17lcPpV7WWdQg5vfA5Bh?=
 =?us-ascii?Q?Ioy369eg5bFyX5KLBarqBRshZKmSYzjpIXBTafptNwl1pgafdsiSohBm1D8J?=
 =?us-ascii?Q?JEPgLfF8ugaXkcGiJZLNUxZVaYMPDME3vj28Hr289nOllryY6rdTvYL9jKdN?=
 =?us-ascii?Q?AJ7YxKCfjA2aSFyWRXPukf5WQYNok8mjFjULOIVykmPQKzYZgMNKU5B+JIfZ?=
 =?us-ascii?Q?tR+K3HnIMfFQZry6hmr6W89LDcAULSb4ChZH9DlJ8/Mz+76aXTB8URBBJJhc?=
 =?us-ascii?Q?iYTkDS+BkhmFeenxT725Eo8lnFHeXM2VewIUBzx/DQ5e9Na0GtNfmBT+fkda?=
 =?us-ascii?Q?FY3F7lX7vxzb3rwjLcZktKYETGrFaDitYbySw7DkpM2DkRlAkKG2PR34JJrR?=
 =?us-ascii?Q?SMU+KJ+fiewNLXUHJmFxc1m6EaeusSdxbPBdvs8pLJb61Lfew17w0llUy07y?=
 =?us-ascii?Q?wrYRAaVyWbByjSVqIwfsQnqpyqxvQuNT4P9cfuTg1T97pitfhiGfuJ7TXr4L?=
 =?us-ascii?Q?DJ+VIe2QYewFSpHrbZtd3OPOICSHeCJ14Go/Rbe1KCiE+GPfvr95t9AFTaP9?=
 =?us-ascii?Q?NKKBlWwtuTw0DQs2aK3Ni+pGKe7Md5/o+Bmh5bsVRG/A4CSXrQghz+CStzUa?=
 =?us-ascii?Q?ysH0qdP82BCpYsr7NVbmWqWQOphjnlGeN6rhA05bRJ9YrU3eiZvohnkIjl8w?=
 =?us-ascii?Q?oXYDUw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386d2874-1801-46d0-d90b-08d9d47fa928
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:25:01.5326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jcolPNOXS5MM7pjAIRADmWmnixx1yWQqKtQjshNy55e+v1cdvLvgA7jgS3wLxDleWym83XTGVkvH3ouk1YWeTpVaRS58o9mwpq7hfhKKzKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2570
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100141
X-Proofpoint-GUID: e32Kqs5lmVjJXkm6EkkrldYgsX28ZKIw
X-Proofpoint-ORIG-GUID: e32Kqs5lmVjJXkm6EkkrldYgsX28ZKIw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
 fs/xfs/xfs_error.c            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 74b76b09509f..0fe028d95c77 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_errortag.h"
 
 
 /*
@@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LARP_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 970f3a3f3750..6d90f06442e8 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_LARP_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_LARP_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_LARP_LEAF_SPLIT			1
+#define XFS_RANDOM_LARP_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9cb6743a5ae3..ae2003a95324 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
 	XFS_RANDOM_LARP_LEAF_SPLIT,
+	XFS_RANDOM_LARP_LEAF_TO_NODE,
 };
 
 struct xfs_errortag_attr {
@@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 XFS_ERRORTAG_ATTR_RW(larp_leaf_split,	XFS_ERRTAG_LARP_LEAF_SPLIT);
+XFS_ERRORTAG_ATTR_RW(larp_leaf_to_node,	XFS_ERRTAG_LARP_LEAF_TO_NODE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
 	XFS_ERRORTAG_ATTR_LIST(larp_leaf_split),
+	XFS_ERRORTAG_ATTR_LIST(larp_leaf_to_node),
 	NULL,
 };
 
-- 
2.25.1

