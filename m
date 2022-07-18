Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66E8CCA479
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiGRUUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiGRUUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44852CCB0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHTbRu032480
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ZWrlHGOewd2cgqOPgTr6KdsOfeP5SkK2XskQJx3JEQY=;
 b=YtWql3tuZoJZaPDPPxoCaFnIpNjgElxYpYcXy66l8vGPcLq3MBxPU/PLIsGc8L0mrE0W
 f748iHGhFgChtQ+xuPHJ3lf//y/4ebsgQpC4z90a0AlPzbjhotVUVs5KNy6LtFHuVxpj
 IKkHGjcy/KfUE6UyBnc/ndmbCeA3+Ro/lHRl+XELbtFXrFRd1Lqb2b0AneuePLWvhHTx
 +6ZZEhJydBXlWE3Vn/8cSQNZKKEx4coiguttyb03FwMNaOOyXOK4tU3AGm7KBvxpkIed
 CVT2EImHI+SIgZ87vnoQ1e9LpKvPleBL+wNYO90WyIO0ub+uu17/a1KvQv4yMr7IgsvU Mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx0vgd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHVRS3007937
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1ekx2da-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+p71Wd0WimzQehgQSowOElBzYfR74PuWJqZ1zaLqBHr8Rd09mH7+t+A5BpRtM9uQYAp4w1K9L0bjzij5QNhcJujzZEecvrCANjyfQUeHWrNeV8+XxMHt0cEsM+Yjj+KVWF36G3NzBdhHo5cdbnOli92+GLNm74ZOD36qoFyCIs3nROnp94zq3nUixmuvLX51VsLemQKlzoOszNiDN60gOsxfB0SyFz8/UFn5NdkJY0n+kG1ljDzlmZgfhUn/Md0SlvlqKvZl4Z4tIp6IFWm5yCm9dp8tV02FgDEvBkwXt2ll0hAaBBYlJcG5X68ZTPRx8ndEKDKQ1LVD2ao3uRxFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWrlHGOewd2cgqOPgTr6KdsOfeP5SkK2XskQJx3JEQY=;
 b=C/Uo1Sk9jVsRTUo+TN9e6qSfAdApLsqpY22EOAhP2KSXM+glP6k0rQjdxzqFK6gvr5OVZ8gQI3ZBP+3PXPClIo9AMDKDQhHEIyfWd6IRakHau3yx68qrypWVbCwNRhukKaFSRNXdjBQw67uSw5W5hedqNxZcWHFohD2tG61MQO5tvCBntJ5cWQV9oXzBLIUpt5k1NrF0g4RY9Vlf0q2S/OlKwd8ixzJyUaDvisztMszkWkfZLjyBse0My+tr3seKuQHCwBw3s6CMjdqnrZTQQyp5uBMDjv5tI86eRY7sXSGdDENk+dtgqvDqRWlEwMGPAxu7EawgVCWgOl+xmLk+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWrlHGOewd2cgqOPgTr6KdsOfeP5SkK2XskQJx3JEQY=;
 b=Ljt7FDQ99Q4+KHaHErVvDyHjLFEMt9TrBj81KkjnK3nq9vPMldCbn1N7CMjMqoSGw+e4iOvyDNldFYgs1HBSqBNL8Zx6JPkrxJuTnFk8pLV8C4Um1ZgbL9fwzFk5haIfRL5JA3UzCktCDfAh7DKC5Su8IVjC1usKwwVzzZt2jsY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Mon, 18 Jul
 2022 20:20:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 18/18] xfs: Add parent pointer ioctl
Date:   Mon, 18 Jul 2022 13:20:22 -0700
Message-Id: <20220718202022.6598-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 749a0bc9-362e-44cf-cb15-08da68faf807
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuSMxEh6+fKItLmESWNz+dEvcuODdCMN4j0id2jLFi25/TB5QErC5Uk668XcZWiKLV8ngVRjLuFra6KtPrVyEfxbxTnHkaiuugbg8jy700uY1x9HaC0JjFWwn7SRhZGQIO1aAOvbz9caMSF+1XeVr30ZfiaKrOqJwLDJjRLIBJ2mZEsC2YkMSidLB03/ecaB40FTBc4TTQbQZm3Q98onQO/qj568+2g9Gqewrx50D5viCL5/cydEdGKzjPcYx43D3LQu5RLq778htEu1Qk2IH9Ytx/OaB9PnZj+g3lTfpe3ZD/l36wvwNHOKh8TmJHDNt+JtcJBPBV/jtgaWePFbL1yk6LTMQDFm5P+e6CDKWRSRMbwHdd0ns4CIJxPjuWcOUv1A2nxefvOmdl6xurGmRmDJjhHWcVKc7+HQHuSE0/mbx57xppmP5l5vRE1/BSku9sAxtYx10Lw2jDuUy1mFBD2vCSXFha76x+T6jeSMH/zSP3lybyXP2V73RD7QwYj3QMgZwKF8W8+G3y0zWgJkBR2zNg1UdqgvIKP3KoTneeHJ2UJFJMsTFHIsh59zyifJT9ePXQU8toJBKiX1Uj9+pFBmIi84oJwm5X3MMX0DiZn/Upb/sVkb2/UU3T0M71rQ6+GXHZje8f6rNoWf0SH5qQOpLMB7Avq6xpMAP3uKVtowOLjnEux3on9ed/eulF3fWh1rtkleu9xeRWR6M72E/HtGMg/+pZ1T+a5SNHZNY3Esu/37gUtvkH91a1eTtF5t1pem7VN7m62sVNScX0NPSls53FjJoQ6K483qihRhya26CW5YegjHmr8G32YeJPKg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(2616005)(1076003)(83380400001)(66946007)(8936002)(186003)(30864003)(5660300002)(2906002)(36756003)(6666004)(44832011)(316002)(6916009)(6506007)(26005)(6512007)(8676002)(86362001)(41300700001)(478600001)(52116002)(6486002)(38100700002)(66556008)(38350700002)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DR0tyYICHG/ASk6dAlO0IWNg3zEpxuh5kE1C52Nl8r1YwDA6mQ3VI0+Rqaj?=
 =?us-ascii?Q?BSUxSEDYFt73GEKqSaLQswFwjiIMAECEFtaONTVMyou2zqFzAEeTJCWsDQuM?=
 =?us-ascii?Q?jcvn3Sr7KBkPK+azwdwZXbwewhmzkNOUQ1EwgRPc6+coF67o3UbCxhQh0pOe?=
 =?us-ascii?Q?4FATquCKDVf4Xsi1CWpcHh6EuaijqNIyQAWmWbHtn+eqxEsPi3EQD8zv4/kP?=
 =?us-ascii?Q?NDpgo5RjLkub16An2CjLbd6Xp7myYalsYhmD/CfD9l5FpCJiYTBtLmWf7SJB?=
 =?us-ascii?Q?PIEiBrkjv0JOEJte5q5daKHJ4rrQFTH//F9Jy+sCe+qDW65h0q/A+9hWzPKn?=
 =?us-ascii?Q?6/ypm39O2GHeXI5l6Zkmbt37Uid67ZB0o8iW7Tx46dIr/kpoUM1ux0u5Nkwf?=
 =?us-ascii?Q?LFDrFPMHxie+ga8b+FblRVQZ92AM4nAS+GzsFqsTceWCLtmI3fIvoJONRLe0?=
 =?us-ascii?Q?RZWyHuAAOaLla6HQvSOgVx3Jt/CbkCM2yoQ/JoDFOmYEJ06i5DvJrzfgrzIB?=
 =?us-ascii?Q?e7hGV0qFHsGcRDEjl8/lt5mxDmVDnRwcg2a9HRaEPSqT77zA2WanmQj9JGkY?=
 =?us-ascii?Q?uqfsnTu+IG172m8pGZuSteGUHkwoUMCFTfE+WlU+gMXhor9FcdRG9oYmVzst?=
 =?us-ascii?Q?KbyZfTagwHpKp0PVAaqGtj5zyYfliQcyQnIlwEbJmkg03Uvm4moRGVCEo21O?=
 =?us-ascii?Q?1QORx5zApdSg5TR0hChlPVXFVn0QpYYP9PTgxZM7cHyZuZeChMzg1vYlXz3z?=
 =?us-ascii?Q?FhzMN2og1lEU74Km/tHiPxwg2d+Rh3fyxaq5hXPVbTJ+BPACQehleKf0g5cM?=
 =?us-ascii?Q?Gs4cBSYZjLQAedHjl0j7eki0YjwRA+4ObFdZqsptW3p7p0HZ7dQKjT/x+TQf?=
 =?us-ascii?Q?ZQI6zTmqTZKHwu7BzIO+7CZ5trl6glYYxNsRI/7ucB5PzjPgktQxhB63USq5?=
 =?us-ascii?Q?S6geivx0T4PCioIIIoTCWvB6OtSgkmpcLG55/wDp7t6eVcip+RqtYgrgR400?=
 =?us-ascii?Q?o17gbUtXDonzgDslYZwykZx+8Xd03qDyJWGN7aPhLNVtXghz8gsLf4yqYHvh?=
 =?us-ascii?Q?VLZmHXtZx1NVJ7DjmVhRSG/XUQCaGTIk1r/qvPW0uLohsVYrp6FpVgmPIO09?=
 =?us-ascii?Q?U529Tp5saMuQvIEDAavO2I/jX5uB/x2IOTQ2MPmcuhRqw8X7lakDGq88NrAj?=
 =?us-ascii?Q?Ymn8vlQ0AM+1YRWrPrfftaJx+x7BwF64kz3F4ph+IYXUFr8tvch3mbJyo3cm?=
 =?us-ascii?Q?QxEk2g98F4tl1W4+7VmO3KMuinMkhB0GvTyo2+7BMkVYWwOGqQBpMv0HHsJZ?=
 =?us-ascii?Q?pezgFWySH1mP7N5dVEbauAC8vaSUYj6BjLHZ47jW+C2YI2nt3ZMBouzP0yl4?=
 =?us-ascii?Q?yW+IVhZPH9UCOewivUxEBiW3OD7h1i5bbRDqtu2vNwdRW9dWebuouGqfaak7?=
 =?us-ascii?Q?gHild0Wlmxd+eknwj/4gHLdos/YqdcUkUIfLuGpQFt0o9XKrnaKEaWAkeakv?=
 =?us-ascii?Q?8kppzMgwLBFH7Tt0McfwAdwZ+gQiaAGfIApg8dLYStwA//YgPFNbdyG9erDM?=
 =?us-ascii?Q?p+egI4WK2SKBz92kKESXRlWujnWvIjrl1FvTKEtKV5vkjPI0QiYcFTfKk7cy?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749a0bc9-362e-44cf-cb15-08da68faf807
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:33.9969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTQYggo+KeiLql0WYAqsCUErnO9MAW/pMDZ4aQPhrG2qyAj/rIqmaQ5rjrb89aNMdUGFe48mbhhRtuIxXEuYR0OPdQUi4/xAMyDGPvV7tyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: UZDmlysLpf-ReRs2oKgxQtHqGISKBIrw
X-Proofpoint-ORIG-GUID: UZDmlysLpf-ReRs2oKgxQtHqGISKBIrw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  57 ++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         |  95 +++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 134 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  22 ++++++
 8 files changed, 323 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index caeea8d968ba..998658e40ab4 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0b4d7a3aa15..ba6ec82a0272 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
 #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
 #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
+#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent namespace */
 
 typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
@@ -752,6 +753,61 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u32		xpp_namelen;			/* File name length */
+	__u32		xpp_pad;
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	struct xfs_handle		pi_handle;
+	struct xfs_attrlist_cursor	pi_cursor;
+	__u32				pi_flags;
+	__u32				pi_reserved;
+	__u32				pi_ptrs_size;
+	__u32				pi_ptrs_used;
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use XFS_PPINFO_TO_PP() to access the
+	 * parent pointer array entries.
+	 */
+	struct xfs_parent_ptr		pi_parents[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +853,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPPOINTER	_IOR ('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 03f03f731d02..d9c922a78617 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -26,6 +26,16 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr	*xpp,
+		    struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 67948f4b3834..53161b79d1e2 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -23,6 +23,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 struct xfs_parent_name_rec *rec);
 int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
 		    struct xfs_name *target_name,
 		    struct xfs_parent_defer **parentp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5b600d3f7981..8a9530588ef4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -355,6 +356,8 @@ xfs_attr_filter(
 		return XFS_ATTR_ROOT;
 	if (ioc_flags & XFS_IOC_ATTR_SECURE)
 		return XFS_ATTR_SECURE;
+	if (ioc_flags & XFS_IOC_ATTR_PARENT)
+		return XFS_ATTR_PARENT;
 	return 0;
 }
 
@@ -422,7 +425,8 @@ xfs_ioc_attr_list(
 	/*
 	 * Reject flags, only allow namespaces.
 	 */
-	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
+	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE |
+		      XFS_IOC_ATTR_PARENT))
 		return -EINVAL;
 	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
 		return -EINVAL;
@@ -1679,6 +1683,92 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * followed by a region large enough to contain an array of struct
+ * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned pi_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_pptr_info		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*ip = XFS_I(file_inode(filp));
+	struct xfs_mount		*mp = ip->i_mount;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_pptr_info to put the user data */
+	ppi = kmem_alloc(sizeof(struct xfs_pptr_info), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error)
+		goto out;
+
+	/* Check size of buffer requested by user */
+	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (ppi->pi_flags != 0 && ppi->pi_flags != XFS_PPTR_IFLAG_HANDLE) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size),
+		       GFP_NOFS | __GFP_NOFAIL);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
+
+		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (ip->i_ino == mp->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/* Get the parent pointers */
+	error = xfs_attr_get_parent_pointer(ip, ppi);
+
+	if (error)
+		goto out;
+
+	/* Copy the parent pointers back to the user */
+	error = copy_to_user(arg, ppi,
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
+	if (error)
+		goto out;
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1968,7 +2058,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPPOINTER:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 758702b9495f..765eb514a917 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -135,6 +135,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..3351ce173075
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+
+/*
+ * Get the parent pointers for a given inode
+ *
+ * Returns 0 on success and non zero on error
+ */
+int
+xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
+			    struct xfs_pptr_info	*ppi)
+
+{
+
+	struct xfs_attrlist		*alist;
+	struct xfs_attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len;
+	int				error = 0;
+	unsigned int			ioc_flags = XFS_IOC_ATTR_PARENT;
+	unsigned int			flags = XFS_ATTR_PARENT;
+	int				i;
+	struct xfs_attr_list_context	context;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct xfs_attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
+	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
+	if (!namebuf)
+		return -ENOMEM;
+
+	memset(&context, 0, sizeof(struct xfs_attr_list_context));
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size,
+			ioc_flags, &context);
+
+	/* Copy the cursor provided by caller */
+	memcpy(&context.cursor, &ppi->pi_cursor,
+	       sizeof(struct xfs_attrlist_cursor));
+
+	if (error)
+		goto out_kfree;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	error = xfs_attr_list_ilocked(&context);
+	if (error)
+		goto out_kfree;
+
+	alist = (struct xfs_attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		struct xfs_da_args args = {
+			.geo = ip->i_mount->m_attr_geo,
+			.whichfork = XFS_ATTR_FORK,
+			.dp = ip,
+			.namelen = sizeof(struct xfs_parent_name_rec),
+			.attr_filter = flags,
+			.op_flags = XFS_DA_OP_OKNOENT,
+		};
+
+		xpp = xfs_ppinfo_to_pp(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct xfs_attrlist_ent *)
+			&namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -ERANGE;
+			goto out_kfree;
+		}
+		name_len = aent->a_valuelen;
+
+		args.name = (char *)xpnr;
+		args.hashval = xfs_da_hashname(args.name, args.namelen),
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+
+		error = xfs_attr_get_ilocked(&args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error)
+			goto out_kfree;
+
+		xpp->xpp_namelen = name_len;
+		xfs_init_parent_ptr(xpp, xpnr);
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+	if (!alist->al_more)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &context.cursor,
+		sizeof(struct xfs_attrlist_cursor));
+
+out_kfree:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	kmem_free(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..0e952b2ebd4a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2017 Oracle, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation Inc.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
+#endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.25.1

