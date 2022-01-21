Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F26C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244552AbiAUFWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:08 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28278 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348406AbiAUFVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:18 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L03raF001018;
        Fri, 21 Jan 2022 05:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=wA3FOI8YMBYPUV2bve2Sn5rJTBOK3VQtTa7O2yrQSnU=;
 b=j7NTqyON6gQxJmewmZfkstUQlWbnJixzBRG0QSJg732Mz9huC4ZydoKXa+ZmIjFUmF1r
 2Fpe9mqW9ELidYhJVig2Tn/ew3GaYy1MKFY08ocHc0t3pr4gI5ZjzNbn2NuWnFCx1kM/
 5Pu1xRwBa/+ndOmH26wX+SXOaR0hJ8zBvh5pGhKC4TWfSVxRd+W5GcRniF8wSPhwCZlJ
 gXsvJ0JF/eYZfxmiKxxsk9gcE1+DESDSO0XwkgCEO+HCDIn6MXR+80rftFArsqkFyElq
 DadwiabJ5LXGZpSley2ZrJlL3YzfOaTxKMGdbDk2IwxjiwdCUysoQztKwaXuamPnBDLZ WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhy9rcq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5L2Yo033849;
        Fri, 21 Jan 2022 05:21:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 3dqj05h42g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUS0BcUdVfhiECB395PVT1/0nET46RBbZBmN0AQIoykWQsseHbubQ/G42TuU4/CNNH9D/Vg6BFQjHzxeqYLlWhnxcBGGc/V8946P6haEGaiq6ORsSDc+tRA+G3ysQce67GvfLlyiO8TTB25gimVnxEgec5t2E5h1AJCz7pjmQ1lLqWd++zgXM7Wcmal9sshyrJ1bR1OAZ2bs4ZEshYZp+5VCgyitvlqK4J2dL+15vnFFm6qROjTanb12anTECoalNVZ/RDvOFsqR9HucrQVqvChsMDgi01FqrSS4xNT+dNnHknrpFFX2ojZjA0J4dl35zMYUcdZPVeMOVXbx9t5Uww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wA3FOI8YMBYPUV2bve2Sn5rJTBOK3VQtTa7O2yrQSnU=;
 b=jxykCwult9638l1YKstkbaqFeTToaSuFhf4w7XL4yb5XBN9kUMjMRF3kmIQpEz6FlKZlFkkLtU1GcUbXQei/9Xcid5V3p+e42cXYYTleWNaTTraJyhMYXfUqP7x67/Tzb8J6hIJtjBrQ/9bvvhgY9ussFmefIs+jlFlBj3V1GDAsJBUQtp+Hmp+Jmpd7bd5Z1k60/1KlWcqDriOlfoe8mYZZZL5LpTFaoeYDgsYxH5YFWFl/LIX2o4I3Md0iuqehk4NxDRQS1iDLeyZQpD+T8oyjDZNRB+5oqdE1LcWkuZFCpF7H5fcajr/QDmGgVHTFUv8knDkA+9hA08qeRdeAXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wA3FOI8YMBYPUV2bve2Sn5rJTBOK3VQtTa7O2yrQSnU=;
 b=toO9HjC5cmzIl90+KaJDDQ33t4ZUi+CvG36EtB5DGzmsAQy+lFLxk8MnCnMSstwcn0l8i6i32KRzaaoVyoPZ+a4iBs/o80s2hhdK9Zxde4zq077DaB58Z6KQeUQeot/0iKxggciP+BnBHNiTxF7q+/JVOVXvUYXhIRyi8YchBs4=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:12 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 15/20] xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
Date:   Fri, 21 Jan 2022 10:50:14 +0530
Message-Id: <20220121052019.224605-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb4247c0-0ae2-4a45-d83b-08d9dc9dd709
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB53222C9D1352814F3F36C33FF65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:250;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLKSe/8WrBFvlIHz25ig71RN0FEHEsnpE9yKIDNe3Z4v9KFZuo9MeCHHGtBH4T9cO7OTsbDTcn9AtVpi14F8qyEk8AH7fSyYbVnfrfKmRed7bqkpmH6dSWAPW1+zupsFxAsduLZHM6FUKTGnasKYvHTwBVpvVlwdlhW8WAZWjVctbSkv03y2xv1dhV9OB9NM2zh7ySMyf9Dd/UzxJxMhQdFkzz76XK6LFyCgcFLY4HsPKW8IkLyd5PYQgszA+n3Rg8io7m0gASydPov02vRiDl+0WaAe4TwE3D3GY6xqobJCUbBGquAUJbpFrGhBFlv0Vqyc+CwdbWgpFVlhAqaneuPJpKczl6N8fRrqfujz/VLLsnyMV9MdxUdZc+AqcYqopxgcdQobmnxSV4dUNyw3RlFglTcknyVceNL7xyvHcJh1muvBMMoosB2OBaixLqJnaQWWoveezG459G96ZZTx+DEsV2e89YMfQVeUFIdCRDKkc60f3awEjHrkTmDpvEN+52xP7yHkoIOJlXwNKmKkDIFdsA4SfCm/ZRePBjgZuYgC/ExfxLijEsw7J/zTCzcK8yFqE1XWkkHyQKuO89aK7IvFRm1imAxAhxVKfq+EXuAtFHh2dOu61rF/qDWzWMBr7N2OIHNF39Af4V7+WFNA356jVzKU5BAyTpGItO9CbSoSq9/JH0mXg52Uis4fJ0jM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BUDGa4k7rn4lNjUBiNvU43C58fcgBeqBDc6u621yLc7CiifcGo0Kv6Hr97Cl?=
 =?us-ascii?Q?GYQbwnM/YtTO1q92y+WwBQVO8kdj3el1YczeWfLJ0Y+4JZqp6YOrCVWw0tZb?=
 =?us-ascii?Q?z1cfgB96RX3kQTyEoGNs2pig8DKSJhwgcjvSjI3j0R1b9xfIPFjPyReCHB6O?=
 =?us-ascii?Q?C5EH56N6NTjrA2DDroVsAKoTlHW5tcIZG1dnwqGrKCEYYs1QspOzkxTAGCFQ?=
 =?us-ascii?Q?ZWR2VgxHQ/BA/j3NtR5AkCMEYJ9tF3oayavs5/oY/AEG55f4cAXVlRCHDeVF?=
 =?us-ascii?Q?xEy72D4lT1UaMJAsyZthF2VAW3h7MdqL5P5XiOkQWQdPFt9PnCvRaYyfvOFc?=
 =?us-ascii?Q?05sXgbRHf2J0v/G6I+fq8RxTLETdeJlWipQ43BTEUCJL1gJPM2MokCC0S3qt?=
 =?us-ascii?Q?fcjwVx7oFwB/kqGBXonqQXogdKHir7tC9eRM/A2BSEbDt8m6STdesOApnYb4?=
 =?us-ascii?Q?bmFUnde6SM5RiJcUZAC3erYEJrRVddYilx8iX4mwZPaAH5H69i46aD/8YMtX?=
 =?us-ascii?Q?+p/KmN7Guh2ipaZFkMMT2dJ9MYmj5SZ4m+PJzUw44JFBQgUouQdO3Gv2NQkR?=
 =?us-ascii?Q?WhPIzrNs4YADTAYG+fnpIU6H6xrnt69qMUZf/kt/LMwG1QWiosKboS2hA1Iv?=
 =?us-ascii?Q?tBO53BFYN87IOaZA/IxuiozFt9WkOZwYzE+4HoJkp9u1Pbj1OcyGn0Ly9Tda?=
 =?us-ascii?Q?dflOQsDlvJej87O0w79Jdi3zjhs0t8YMiHnX6MoivGZBt+WEJc+2+my5MZBF?=
 =?us-ascii?Q?81hiUdtK4I/x+MzJ43DNZCxPG4zerw70GBokIuJhuRAbehkLJhjL7zpZAUF4?=
 =?us-ascii?Q?j8DUUXnyyUpVrm3GpWk9pGCkFGr4zVwlPdX0HmtI0ewFwcr6UR2LlPACjuck?=
 =?us-ascii?Q?kbXKEgYkKjcLJ+nEaQJquOaMCaPPzn8HLf9kXDEg7PX/+x6+QkPi0ojiW03d?=
 =?us-ascii?Q?7clJrlJoQ4AfzDcQq8h/ibSFzlORpPCJiK3Tu9Wdntj2pvksIIXhdK2S+uiX?=
 =?us-ascii?Q?V5rA9/LRQ1/3nIF+GdHc6gVb+FN6Gqp9mSPa1o+q5shhP6ieufXC7l3q6CZL?=
 =?us-ascii?Q?/KDH6wIYKehJZ8SUl2bHAihnQeyPB1vt2m5dFEYjgqVRmky4skz/PB59Xv9U?=
 =?us-ascii?Q?joapQzGskxTScKvWzr1X+xA9KMuIhP0KjlOWJtoBVJTybon73PoY5D8Mrlv7?=
 =?us-ascii?Q?bGw+XkDjqrfhVJhfhHQPFIGSCSpvHYExy9FwLpCoaiWJ4P+XmuwN9KojuTiT?=
 =?us-ascii?Q?6b+cdGftSzgEVCCIwIiriukSz8i35/qlnHeMfJ2CFP9OC3l0Z4CwP+cCg61Q?=
 =?us-ascii?Q?Pfl+Q9zdvDbjIe9T3K2Ngbqrquj+ndhQSjnejBuB9Wzm1PZ0ImtExuSPtKy9?=
 =?us-ascii?Q?CAPEGIGPY+CqKcznSDDxUzTt7oq1hov3v40D1JMCILDiW09Tn/AuZwtZ6VPE?=
 =?us-ascii?Q?HUnkZ5diKuxxcNWeTCQmxCDMs5rL753PlRKxZ250/ijRN+SYSsJf221b670G?=
 =?us-ascii?Q?PPlesSRg+pFnC5rYbosetXDORh+MiETxIVH7cvDXmhTr6sOp3T4wf6X02Ksj?=
 =?us-ascii?Q?vdLjo8NGymVqIpBF8PX6lzL9HG6WdcrcaMXkrbaONZuSs6pF2bjEWFDtlyQH?=
 =?us-ascii?Q?tDtkW9m5h9sXyt6XL86KTtk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4247c0-0ae2-4a45-d83b-08d9dc9dd709
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:12.8014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urMcyoB7YUescKq5ZhHmQXS2DdjjAun5QtOV4FvhUaNtXtKtjZqUZGoKHu+jNSrr8OEborUKIfUAs7MNQw4B+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-GUID: 0Khf0tFN_X1NUJmO5qractCkYMub4FpP
X-Proofpoint-ORIG-GUID: 0Khf0tFN_X1NUJmO5qractCkYMub4FpP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to enable reporting 64-bit extent counters
to its users. In order to do so, bulkstat ioctl is now invoked with the newly
introduced XFS_BULK_IREQ_NREXT64 flag if the underlying filesystem's geometry
supports 64-bit extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fsr/xfs_fsr.c      |  4 ++--
 io/bulkstat.c      |  1 +
 libfrog/bulkstat.c | 29 +++++++++++++++++++++++++++--
 libxfs/xfs_fs.h    | 12 ++++++++----
 4 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6cf8bfb7..ba02506d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -590,7 +590,7 @@ cmp(const void *s1, const void *s2)
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
 
-	return (bs2->bs_extents - bs1->bs_extents);
+	return (bs2->bs_extents64 - bs1->bs_extents64);
 }
 
 /*
@@ -655,7 +655,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents < 2))
+			     (p->bs_extents64 < 2))
 				continue;
 
 			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 201470b2..0c9a2b02 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -57,6 +57,7 @@ dump_bulkstat(
 	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
 	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
 	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
+	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
 };
 
 static void
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..0a90947f 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -56,6 +56,9 @@ xfrog_bulkstat_single5(
 	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
 		return -EINVAL;
 
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		flags |= XFS_BULK_IREQ_NREXT64;
+
 	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
 	if (ret)
 		return ret;
@@ -73,6 +76,12 @@ xfrog_bulkstat_single5(
 	}
 
 	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		bulkstat->bs_extents64 = bulkstat->bs_extents;
+		bulkstat->bs_extents = 0;
+	}
+
 free:
 	free(req);
 	return ret;
@@ -129,6 +138,7 @@ xfrog_bulkstat_single(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -259,10 +269,23 @@ xfrog_bulkstat5(
 	struct xfs_bulkstat_req	*req)
 {
 	int			ret;
+	int			i;
+
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		req->hdr.flags |= XFS_BULK_IREQ_NREXT64;
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
 		return -errno;
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		for (i = 0; i < req->hdr.ocount; i++) {
+			req->bulkstat[i].bs_extents64 =
+				req->bulkstat[i].bs_extents;
+			req->bulkstat[i].bs_extents = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -316,6 +339,7 @@ xfrog_bulkstat(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -342,6 +366,7 @@ xfrog_bulkstat_v5_to_v1(
 	const struct xfs_bulkstat	*bs5)
 {
 	if (bs5->bs_aextents > UINT16_MAX ||
+	    bs5->bs_extents64 > INT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
 	    time_too_big(bs5->bs_atime) ||
@@ -366,7 +391,7 @@ xfrog_bulkstat_v5_to_v1(
 	bs1->bs_blocks = bs5->bs_blocks;
 	bs1->bs_xflags = bs5->bs_xflags;
 	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_extents = bs5->bs_extents64;
 	bs1->bs_gen = bs5->bs_gen;
 	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bs5->bs_forkoff;
@@ -407,7 +432,6 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_blocks = bs1->bs_blocks;
 	bs5->bs_xflags = bs1->bs_xflags;
 	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents = bs1->bs_extents;
 	bs5->bs_gen = bs1->bs_gen;
 	bs5->bs_projectid = bstat_get_projid(bs1);
 	bs5->bs_forkoff = bs1->bs_forkoff;
@@ -415,6 +439,7 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_checked = bs1->bs_checked;
 	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
 	bs5->bs_aextents = bs1->bs_aextents;
+	bs5->bs_extents64 = bs1->bs_extents;
 }
 
 /* Allocate a bulkstat request.  Returns zero or a negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 42bc3950..f65bf2da 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -393,7 +393,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -402,8 +402,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+#define XFS_BULK_IREQ_NREXT64	(1 << 3)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
-- 
2.30.2

