Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB155C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C34D560EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhIPKKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12332 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236263AbhIPKKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:36 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xtuu010932;
        Thu, 16 Sep 2021 10:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8zYwKvm5Ac4TiG22NvEg+L0m6O7ZW9L5qG+QwUXQ7YY=;
 b=jU0FVdhAPQ52zYjEvw7PAUrid5hpAnFIsPhzjL9mE9IH8m6GGxKsCLPznEDwa4V4oB+q
 MTfTuqlQQ4UOF0ntHBzXsVRFn3ocU7MuLg5nWJN8Qw1Xz5VH0YnYdEuILJaKQLHZ3JPf
 P+RSsrFfVpMfwaHve0kzjb3FlRvBle/HO7LjKrnaWw8WhPr/IBWNOh4Od4hwEBjcSbwj
 aGMASw7kApRuf7thDWNKVVkSfRazMj8PlcCUPJAY3v4qFkJWrGJsEU9r8sIKnrFmyh/0
 1nQDVSJ0ElXG5ckCMk7r/4XjT0SXCZcka74OKI4VuqYdi8+p562G83LfD5D/sCp/xHG7 Lg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=8zYwKvm5Ac4TiG22NvEg+L0m6O7ZW9L5qG+QwUXQ7YY=;
 b=kS6WJD5q+ItlxawBNCdekEPF+bz7Mo7L++rvXHKKpRqB3saDTa8XwK7asZhyAmEdZzDF
 TIf6yYUSiBFlB0uv/mZ89wojeRQZ1WpOErQ9m3xz8G10rL99xyEqGYseqAXOlMoCv/00
 QxGS6+iL1TajhGDkaBYanroCJBoKvTHpTKI/GejAlOARL08xsOSWzPF9LwfMY+KrMqgR
 IIqRNkU0p+eD+2FML3D5uAZwYduthhPuUPfpzkqQXkNAl3+uyeiZwdiSHYUPtcoNvQQq
 8RL1w5WVl7RBs3FukivqaxZPmpwJ68p2iiRguraEbP8h1Es7pW5zzB/pBq8gVpU4yFVV bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjvee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6Ubr112438;
        Thu, 16 Sep 2021 10:09:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3b0m992ums-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnA3EwNdMtYvbzxPsSGMugMQlmDFKEBDO1KeXTYVEZ/PE+XMZjYsobNOsEXdi944ZrQuRqX1WQGvm07FBYpXt/Si6BuleVrWtjNycZKkmDpJG8SLfE1kpg58tl9UdGg4LcOhjq4ztiSTdBkOwly/6ntO6Tu+ljqQddhhlzIjVyiFvd8Q692XPOI3AGTJqQXB6VwyahSDZ0BayT0as6loDQ2efiDvmKQ2XiwfKexm0d+WjTN1IsY8Paa/0gVZOy25vVc6wAHWZZM+zPY+spj2vKKkze+oSA2S0Jd0QQ3xO1pPOSa6jrGsgWYgd2gh/rhTYiLi5MawrYis1y18kW6TLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8zYwKvm5Ac4TiG22NvEg+L0m6O7ZW9L5qG+QwUXQ7YY=;
 b=klgeYLqyJ2nRTUv4B1FQzShY5hvKN4npz+YFzg5rc0z1VAz3p0QqiyoZNLEAoTOItebW0wJGg9XOMeo8Z1wqH8xWKriNY/id9b/K/Bo1E25f2omAUKQnnLES6k/vt34646pFoJopE25xH/Li+0kIYQMZ1Eq7DWeRMi3o3snqxyh62sNCRrVKSJUhIyl0Fe1EzLXpMqDR19nWPsak31CKsf/0MNSUgJLM1BowL6J6JezN6kGhcQP06nXgKwPugQoKFLFQvAjoKnjYDJBM3yF58gM3rCFN7n6E56SZZgztqRfB7st115CF6xbgZl/NGRF8bAFJVD99qsqJMOeGrNWznw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zYwKvm5Ac4TiG22NvEg+L0m6O7ZW9L5qG+QwUXQ7YY=;
 b=m4vgxeUQD2Jlq9ALAQvZDCDvmlj0lXNaRnUtHSbl5wO84CUCMJb7kAupmrtdboXs/Lk4DXYCXze1K3k3uPSN9CbxeQGRfXSKHtkmjDjc4Ot/aH9pG9/0IQi2evjE11vDwxzwhvxm2OD2lDUl7H60NDLAVimcgdCYCUq94dTBcgY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:13 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 10/16] xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
Date:   Thu, 16 Sep 2021 15:38:16 +0530
Message-Id: <20210916100822.176306-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8aad7c89-7452-49b0-1f04-08d978fa07bd
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748B277B4325D78DA36D8F2F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLrsma0rbBB8K06+MGRGnlOaGpS96wfv9YtyKqz+os75fSWQdi6iWk3donJUPcsJQ5P1/VcmSBXCUQS8wS/48Ztm6aVv30ehQOBBLMvrs/b1u30d2GeQ3lffbYaWuvw/2voRRGk/EFHAOU1q8WlLzKl6oNbLIh0Vte3Wqfzpkq888hAsA89AOF+rp4l0c8edF53p212HG/h6GKLn8XznrbqoxAtDsit92CQ4DrskkYrjKGxBmiuFuMUQrXxzKjITCUhT2wByxacok7Dc8Nb9EN4cCnh6cw8rKpSke0gor4tr6lhBUbM9jagvql7IOJUzy4DTr6YUxOj9r9f3ebSMk0YBQDGCFFdSnOfYgghH6hrtCEhCziwhVGNjghS23QDAX+7fm8CrQl0MJW0FHqwd0ePS4oNIX/BEMmz2nG51jHPhMEmql/m0FOqr85qvAs0BoEsdasb93LaL8tCfVCgUonc4LpPnNMkmStc1hFY09rdsECz8xxgUFmqPZH9+JB/LCA4QEWSwAe9EF1Ut3Qcrhvv4g4hOgNotog5i7jn86IYskIs6YSUfRbruPuy9s3O/C/TnQcBLDxSAyua7q86/1TVJ3yieV1VfFHA/62UK7drAFWl9IPJrkLDnQmmrg5lr0mR5+XoNQMuU42X64U2KvFuhgD7XHa208LaAW4WIHhVROGmEkacaivdUPHBfHc3d0kqEsG3LKGEhKmJZhFTq5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TdcEVpBYUlius+JdYBuc36ngN4QbpGtkG1YkfGjBW8GGMbivqa0em8+uN1Pr?=
 =?us-ascii?Q?RpumhD4IUrqgwSo8KzijMC45juEZgIlyFM0klOgUW+a5ayzlM8+33ddN+b7g?=
 =?us-ascii?Q?Qsa7hgxvrN5eoQJGxTwjvNCm3Ji6gFDXNo4mLRKLxKUDxOFInQprVa6eFNO0?=
 =?us-ascii?Q?nnKZjr2LLZ+dxVQt7pih3YM3q7YpQoO/EG2wLAG1CDtmpzlytgt+ISq3xrS0?=
 =?us-ascii?Q?+4YOp2MKIAcnNQ+8nFOYVG65HnlAbmCLWlpq3Cr0uYQiePqOXmGIrYC2gPVR?=
 =?us-ascii?Q?/j58pQwL7AHJ6B+VjP6OijFWi0Zo029TD7y0nvS/NfekFwSB1ofjai/OiWRJ?=
 =?us-ascii?Q?SfjtoJGkoADOCR64DIL+R9s617Z0KicJHt+y4gp7Cr+uDNz+/ejc8aCaUMFv?=
 =?us-ascii?Q?VuUzreMsuZEp2d70Y3sIgZs4UCL4YPGsz8us0MFOSvDhX63+1hZJAeROejrx?=
 =?us-ascii?Q?sEstib/raZZVSznJUxmv82ksk2QtkCVIJMPGm03l0rhuIF/7HH8oUOOExZMz?=
 =?us-ascii?Q?yohCsqx+2lHrmO8mwLZlIBaCGoRtArghcQE8hPBLMOapdtkV9MWhWzk5KAHZ?=
 =?us-ascii?Q?02yia+RclL0nBvgn1Ivd6/Qcqi6KeqmP8X3R34ly66TY9+Z66fYhsTpXqg/Y?=
 =?us-ascii?Q?/I6vmgdj3dL4Gcy5IYITNyVdtjBlVx5gN8XZeKGiB0bcNx67jHr8e0bDXQsU?=
 =?us-ascii?Q?YFpFRUKZU8CGyUBEQSgYK3weF2slTHx3uX+Z7X1iXe8XgfV6bwN/D8p5LJA7?=
 =?us-ascii?Q?TxF95KdVHMq1tnUnBHHlFtLogy2OvYOFSoi7R9bLeXrVbdLU2F7dQo2/ljfl?=
 =?us-ascii?Q?2yAOgVDYdYhRsuKszDzJjb9RFZkgwhvvIOa8IU3MYA7TrPL0nC2IpKXdVLWT?=
 =?us-ascii?Q?VyXPY6syqa02jAZAo3BOXP0JxBqJfObAuDgUf7PAakTIMtA94Ct/h4hLKRVg?=
 =?us-ascii?Q?3lpisI3/ADficxPehC+V6SSUKWlHbSSnAg4HvTKdsmD2z+02kGz9VLHNv9N9?=
 =?us-ascii?Q?PW5y0HofI+3quoNXjXHBgUpXpGLSQ/jaDJDou5yd2ZUGk6wokgEiwhpmBR2Y?=
 =?us-ascii?Q?/cnvhKHZ18dG3JG43IXux74c0mMZwgmV+/m1I8rSR6M8cgagHiXilbzRbqn+?=
 =?us-ascii?Q?G4q+oDUkqeamr1L3wHcpPywIshJjtkyFlqfZ2fy68fIEMce+MmQflQ189yNi?=
 =?us-ascii?Q?jB2q1Pc0h+Cd/vIvo9hanKxz3kPZn6aHANA1gY9XHRclUj1byjkh9MZMkLZk?=
 =?us-ascii?Q?6GTqSHKBruQtTH3+vYHAZkNariFUn4aRAimfFGUcL7jL0AhFhIPcvILhYijv?=
 =?us-ascii?Q?GYCa9vQKc/u8JV9KRPbLy4FF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aad7c89-7452-49b0-1f04-08d978fa07bd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:13.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ufmraw5vFgliIVIF6kYNz19jNZcsBzsePgf1HBEoIxz/4kaBVU7JTStst+wL85O7+dA4pf36hvz4X8KoIFxhHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: qA7VM8UWHm3Hkb1b4FAYslsoKBaIsBhp
X-Proofpoint-ORIG-GUID: qA7VM8UWHm3Hkb1b4FAYslsoKBaIsBhp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to enable reporting 64-bit extent counters
to its users. In order to do so bulkstat ioctl is now invoked with the newly
introduced XFS_BULK_IREQ_BULKSTAT_NREXT64 flag. If the ioctl call fails with
-EINVAL error, the commit falls back to invoking the bulkstat ioctl without
passing XFS_BULK_IREQ_BULKSTAT_NREXT64 flag.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fsr/xfs_fsr.c      |  4 ++--
 io/bulkstat.c      |  3 ++-
 libfrog/bulkstat.c | 55 ++++++++++++++++++++++++++++++++++++++++++----
 libxfs/xfs_fs.h    | 19 +++++++++++-----
 4 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index bb5d4a2c..1fb2e5e7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -606,7 +606,7 @@ cmp(const void *s1, const void *s2)
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
 
-	return (bs2->bs_extents - bs1->bs_extents);
+	return (bs2->bs_extents64 - bs1->bs_extents64);
 }
 
 /*
@@ -670,7 +670,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents < 2))
+			     (p->bs_extents64 < 2))
 				continue;
 
 			ret = open_handle(&file_fd, fshandlep, p,
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 4ae27586..8a9cf902 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -49,7 +49,7 @@ dump_bulkstat(
 	printf("\tbs_extsize_blks = %"PRIu32"\n", bstat->bs_extsize_blks);
 
 	printf("\tbs_nlink = %"PRIu32"\n", bstat->bs_nlink);
-	printf("\tbs_extents = %"PRIu32"\n", bstat->bs_extents);
+	printf("\tbs_extents32 = %"PRIu32"\n", bstat->bs_extents32);
 	printf("\tbs_aextents = %"PRIu32"\n", bstat->bs_aextents);
 	printf("\tbs_version = %"PRIu16"\n", bstat->bs_version);
 	printf("\tbs_forkoff = %"PRIu16"\n", bstat->bs_forkoff);
@@ -57,6 +57,7 @@ dump_bulkstat(
 	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
 	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
 	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
+	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
 };
 
 static void
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..9de614d3 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -48,12 +48,13 @@ xfrog_bulkstat_single5(
 	struct xfs_fd			*xfd,
 	uint64_t			ino,
 	unsigned int			flags,
+	uint64_t			bulkstat_flags,
 	struct xfs_bulkstat		*bulkstat)
 {
 	struct xfs_bulkstat_req		*req;
 	int				ret;
 
-	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_BULKSTAT))
 		return -EINVAL;
 
 	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
@@ -61,6 +62,7 @@ xfrog_bulkstat_single5(
 		return ret;
 
 	req->hdr.flags = flags;
+	req->hdr.bulkstat_flags = bulkstat_flags;
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret) {
 		ret = -errno;
@@ -73,6 +75,13 @@ xfrog_bulkstat_single5(
 	}
 
 	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+
+	if (!(flags & XFS_BULK_IREQ_BULKSTAT) ||
+	    !(bulkstat_flags & XFS_BULK_IREQ_BULKSTAT_NREXT64)) {
+		bulkstat->bs_extents64 = bulkstat->bs_extents32;
+		bulkstat->bs_extents32 = 0;
+	}
+
 free:
 	free(req);
 	return ret;
@@ -121,7 +130,18 @@ xfrog_bulkstat_single(
 	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
 		goto try_v1;
 
-	error = xfrog_bulkstat_single5(xfd, ino, flags, bulkstat);
+	error = xfrog_bulkstat_single5(xfd, ino, flags | XFS_BULK_IREQ_BULKSTAT,
+			XFS_BULK_IREQ_BULKSTAT_NREXT64, bulkstat);
+	if (error == -EINVAL) {
+		/*
+		 * Older versions of XFS kernel driver return -EINVAL because
+		 * they don't recognize XFS_BULK_IREQ_BULKSTAT as a valid
+		 * flag. Try once again without passing XFS_BULK_IREQ_BULKSTAT
+		 * flag.
+		 */
+		error = xfrog_bulkstat_single5(xfd, ino, flags, 0, bulkstat);
+	}
+
 	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
 		return error;
 
@@ -259,10 +279,21 @@ xfrog_bulkstat5(
 	struct xfs_bulkstat_req	*req)
 {
 	int			ret;
+	int			i;
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
 		return -errno;
+
+	if (!(req->hdr.flags & XFS_BULK_IREQ_BULKSTAT) ||
+	    !(req->hdr.bulkstat_flags & XFS_BULK_IREQ_BULKSTAT_NREXT64)) {
+		for (i = 0; i < req->hdr.ocount; i++) {
+			req->bulkstat[i].bs_extents64 =
+				req->bulkstat[i].bs_extents32;
+			req->bulkstat[i].bs_extents32 = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -308,7 +339,22 @@ xfrog_bulkstat(
 	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
 		goto try_v1;
 
+	req->hdr.flags |= XFS_BULK_IREQ_BULKSTAT;
+	req->hdr.bulkstat_flags |= XFS_BULK_IREQ_BULKSTAT_NREXT64;
+
 	error = xfrog_bulkstat5(xfd, req);
+	if (error == -EINVAL) {
+		/*
+		 * Older versions of XFS kernel driver return -EINVAL because
+		 * they don't recognize XFS_BULK_IREQ_BULKSTAT as a valid
+		 * flag. Try once again without passing XFS_BULK_IREQ_BULKSTAT
+		 * flag.
+		 */
+		req->hdr.flags &= ~XFS_BULK_IREQ_BULKSTAT;
+		req->hdr.bulkstat_flags &= ~XFS_BULK_IREQ_BULKSTAT_NREXT64;
+		error = xfrog_bulkstat5(xfd, req);
+	}
+
 	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
 		return error;
 
@@ -342,6 +388,7 @@ xfrog_bulkstat_v5_to_v1(
 	const struct xfs_bulkstat	*bs5)
 {
 	if (bs5->bs_aextents > UINT16_MAX ||
+	    bs5->bs_extents64 > INT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
 	    time_too_big(bs5->bs_atime) ||
@@ -366,7 +413,7 @@ xfrog_bulkstat_v5_to_v1(
 	bs1->bs_blocks = bs5->bs_blocks;
 	bs1->bs_xflags = bs5->bs_xflags;
 	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_extents = bs5->bs_extents64;
 	bs1->bs_gen = bs5->bs_gen;
 	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bs5->bs_forkoff;
@@ -407,7 +454,6 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_blocks = bs1->bs_blocks;
 	bs5->bs_xflags = bs1->bs_xflags;
 	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents = bs1->bs_extents;
 	bs5->bs_gen = bs1->bs_gen;
 	bs5->bs_projectid = bstat_get_projid(bs1);
 	bs5->bs_forkoff = bs1->bs_forkoff;
@@ -415,6 +461,7 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_checked = bs1->bs_checked;
 	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
 	bs5->bs_aextents = bs1->bs_aextents;
+	bs5->bs_extents64 = bs1->bs_extents;
 }
 
 /* Allocate a bulkstat request.  Returns zero or a negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2594fb64..b7690691 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -394,7 +394,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents32;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -403,8 +403,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -469,7 +470,8 @@ struct xfs_bulk_ireq {
 	uint32_t	icount;		/* I: count of entries in buffer */
 	uint32_t	ocount;		/* O: count of entries filled out */
 	uint32_t	agno;		/* I: see comment for IREQ_AGNO	*/
-	uint64_t	reserved[5];	/* must be zero			*/
+	uint64_t	bulkstat_flags; /* I: Bulkstat operation flags */
+	uint64_t	reserved[4];	/* must be zero			*/
 };
 
 /*
@@ -492,9 +494,16 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_METADIR	(1 << 2)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
+#define XFS_BULK_IREQ_BULKSTAT	(1 << 3)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
 				 XFS_BULK_IREQ_SPECIAL | \
-				 XFS_BULK_IREQ_METADIR)
+				 XFS_BULK_IREQ_METADIR | \
+				 XFS_BULK_IREQ_BULKSTAT)
+
+#define XFS_BULK_IREQ_BULKSTAT_NREXT64 (1 << 0)
+
+#define XFS_BULK_IREQ_BULKSTAT_FLAGS_ALL (XFS_BULK_IREQ_BULKSTAT_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
-- 
2.30.2

