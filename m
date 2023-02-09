Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CFFC64EC5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBIICh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBIICe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4729026867
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:33 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Pru5016231
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=vsMvGLx8okHtK0olwwc7WZqMVdIoOvrBE31gaFSs1aE=;
 b=bYvJuakvytjmM1UD5EkgiWlGL838Novxtm78AyHXzQA0I4JbK4yi25IsuAGqfEMj/zNR
 9NsPIoD3Co/5EJeBooeg5VgGMOqFyyZPf5sOyyKfOMv4VihoieZNtkKdMICHlhSXv1Ja
 eUDkm/xw2XBt4mUR9dRIMbDVKRfdBev3aj0w0WwrfOlj2n4x6A0NjXbIGOkbZmw/modO
 lvuLSl8D2SIUXKEwEYSKk+MB4MkJm92iKVfkvzu5W5esCO0g4nbLDv/IeNd2PZs0N9I0
 AwzuSKNE2ZKtfhIAkc5f7v0ZyjQgHDv4wMEmXHlq/RhjlbhrYmRDqRjYvAxnGJiRs9KS dg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9nj4eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196KLvp021320
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dvja-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQgrZ1JDHwHdDGbsTBQh5c5dr6FRGD0pAzOKyNDIP3Mbt2ga43rj1MCsmlqnQyGS0a0rcjy1HoynViRcY0Tk17glIcyF+tkDvNVSNfsaJ+V+e8TWDf5s5YSkOJ8UVQaEyxRyCnNCvgVQ6PME2l3SG3QI+MHuYeJjOut0s1ypvZJB1lI3Fpk93ire7DRcgZSiPNkXmee2LPDqrjWfoK4qqBpeV9Pn+zRkBtY8nHcqU5OjHuZwfbzMymYiKLQVImKSD3SZzSl6Aw/QtkDWF/IokP4lNKDURLMhuTaPGXJAk8k42PJrQsPzguoBCdl4wvyaolMqHvJ6H7syxMt/fufZpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsMvGLx8okHtK0olwwc7WZqMVdIoOvrBE31gaFSs1aE=;
 b=EcYHgdhcfova5PIN5vdGIsr1wpANlk8EN5/Qblcdice4N6xnXJ/9TELSLLfz2GfXeDXV8+z9JgJ49Dk3hq6ugyt1xTdWXbEjCTuc+Fwbe08+9lhMufEnZAUmGbXiICqI6OEkEIDhOAiIR/xvFMKfyBQiSnjau0iVBACUHVrgIWz1noEs8HeYFcSZ0qoTLyJrMqBLmYZZ+A0LF0bE/U9iidcrhwwICCRvHG3NOFCE7zk7dfDHb6UVIiznMYZ6vej3vSBAlHdIGXld81ZxWC7b7rLPLmO/WlmQs9xMcBlGqvU02mZrVq7Km2jnHs6BpAG28t+XAFuDtXICwoO5IcFW7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsMvGLx8okHtK0olwwc7WZqMVdIoOvrBE31gaFSs1aE=;
 b=UjJkCW3oACOy4rr0NNyt3FLLPX7HuIiUuPk1bNorEx400LZJyb2cxONfvUPtoHV0LSrA9qprVpy9gxjVEM89fFO3Ja0ehwPZooOuCjsPKWr3OiGIfhjOi0RbnbyhsgIZjwMghyBbgC+XyswmoIjikOLz/aWh0Q+R1iXnSVNtrVE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:31 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 23/28] xfs: Add helper function xfs_attr_list_context_init
Date:   Thu,  9 Feb 2023 01:01:41 -0700
Message-Id: <20230209080146.378973-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 173a9d2b-3012-439f-4839-08db0a73fe56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8o2+lSMK26734WCjbH/AoVJHoDXuk2m7hJIzyErPtw3cpUKBq80GcX509JfDFClP1+IiCOWHH12/kWhFGMzpJLJKZ4fC4kSXGL5EkwMwJRWJQRmpKKmmPzw+HFpiI+zg1/SkvcVCNR1VaRS1DedanKLGy6oU4GO5faGoCEaPa9umVg+I+MwkvtBcjxTucD6x1Cf1yLlZgfjhiAfedB1gqOKUVS4/1olv9viivy80OOmPVud/Rw3xHG3VN4G7prSSnDDl42Ghotk5uTbW8VPk4CRIdpsgoXTSM+/LMhM5syuMu0RNfUcTR/RvwPT8bUmldnWwGG29xC+24xIx3RzjLqWpNen90aQ1H9kQardX92SCKua6moldcKHkPmgWhjhw0l3FsCumiyZDJVGRkHXjIalQxwZmrgcQ04x1Nfy2SvDd6+S9difnuTVRwEPE4t6NCzEcuc6wer5wxmNQGUR/rt2Jy1ZE2UCRBuFsw1Ka5moId/AHmy1kuT6iD6oEHyEyRmg8buqpYXcNbTr8tCvnxsFbuCcrjDkayf2Po8TTmYG5q9s3X956ng/uYVB/VR2X+WFBMvVmDLGcfPqSoqKIESmK3pxXc8ex7MRCZYP84baAhSwYECGRttKXesBujSLXK9P/SZrocYtMy9PU4lMeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b9gKNMyvNqaYfo4ogcgaOYHfM2PTXOAHmlgyfCigKagFCm1JXe0+VuYUyW8O?=
 =?us-ascii?Q?ip6+3rw+RxkoZQ66EUv3IAgyvDxTE2gjA7CyokwgERQhXb7/qK5cIhtLATEL?=
 =?us-ascii?Q?hMcO0fVn0Dc2Nz7OVXCgQVVnYt95/c5rfhyBYJ8k7LHrWcAJBxqpFV4nIe/m?=
 =?us-ascii?Q?EnxeZYd6950t/LQNN6xIIFTQtnEMu7zOzKWK9VNqwDhIJdBMuL2QNZ/aPjlj?=
 =?us-ascii?Q?8S1RLLQuDUEyvqPQ/PXnAFWthIJiuQ2BfbBWEr5lsoPDEhRg1rhClCEglNt3?=
 =?us-ascii?Q?sQ6Wn8Sy1VON/+OGzoI66+cBxwgflYyLQxSWdnena0rtaSLyXZxIRbSeq8n/?=
 =?us-ascii?Q?xmkUxMHfmQhRW4H8gTfQo279ZT6klUq9gXZ82AySE8oajWLLnVGAkOmmIOiW?=
 =?us-ascii?Q?cSkBidoipTRKUHm9GejkVkcUMHOQNT+4iIr9CQ5J7u1VYOrgJVUViDWePWhB?=
 =?us-ascii?Q?eDG/3Ve4IfuEupgjB61bVMs8UA7eQp7Ceg/EKhHZGH6paiOX8gfneLRZKvka?=
 =?us-ascii?Q?OHBnWwVyESE4EojoSHpURShiWdyIqp62hQXsIUSDuHzkcZF1cNTWhOihEBJh?=
 =?us-ascii?Q?M3rHh+7qioY1xRYNLX8ILQQIOOEIZbXeHQpKkN74e4TLSBMZmoILOIxSh+WB?=
 =?us-ascii?Q?PxU7vEQHC+Jz9yL4ZfKbQNOyraMQFUAK1XN1+vRjkVFSOd18NSqR2qj7NLQ+?=
 =?us-ascii?Q?Ppo84kjTuxFACDoOtZgElFl1Hjzni94Fi34YggBn0rvCSBRb4j5ds/5FfWnt?=
 =?us-ascii?Q?Yyw2GMk/1BZxd7mHkykbbMl4HvUR5Y7OOugzNfGAWgtXVfSXaORJZStk2xka?=
 =?us-ascii?Q?K5nChtk3EGXxA7j1zorYS7HeQDVQWg2tAmFoplJaiPGztDoFSktAPZDv4xIr?=
 =?us-ascii?Q?ElKuGEcY5GFEtUOrcyh9Rct5/jOkqVFwiYj+WNNvEQGGD163Y+oXKrWsGjza?=
 =?us-ascii?Q?W6+5wISJM2xqkqfpv9l/1zDLcmsFcknbrZJbn3lx++DlvEURCS+DY2NrgDFd?=
 =?us-ascii?Q?I/DeL0wLAG7ofvkzim/C2XZwqZ9lucC5vIrVl27C4KYB0EdZvzvI3Aj9vvtt?=
 =?us-ascii?Q?eNXfvgL/irMdp0/NdfwNrcCosrOM5PEqvTjT6zYUCIqltBCiCADZftIsQwWm?=
 =?us-ascii?Q?9S2VdeOOqouz7TLD1hQpFjtPrvEhbkhd7RERpidk7IZ+/K5KoUppYnQiNaRE?=
 =?us-ascii?Q?szGw4j7leYB4u177mNB0M2AlueflkJM+fzJ7MvFZqtltdddKlpij7S+zqscG?=
 =?us-ascii?Q?4LVFLUMIi0S3LlrqHIpxpHnB6niljIfYLDx0fsMOG7qyUtqj/kZaQQ0I9edr?=
 =?us-ascii?Q?7dzm5saLAm80ZdcF2qMa2+Y1JBpZHw9sQyd4RHpRVGmH9Hs3RuO9GFwyC78U?=
 =?us-ascii?Q?GAKABA1Vw0Dc90KYz/ofMnLzisemvesUZqpE2KdzIjYmkdOduTaDcXZMcACk?=
 =?us-ascii?Q?FWwN2Df2g94UX4sY9nfqlG3ITU+WwnX4x+lsjrst+NU+YCmmVMXXzypEUtwn?=
 =?us-ascii?Q?C6RB/Sj1xthngrvx9VjI8PGg8FPAPWKDz1NQ3hkXis4rUrHeKGVc/kc5vnRP?=
 =?us-ascii?Q?MAYawL3MUI/fT5G5g8u2yweZs3MU3Jy/i+SPPMnZn4hmbDcruAGfDWNRPSfC?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8XLpDIfkxFgx30Zqzi/4xIFKa221MlEzPVigBbivblft9ujLwG9jKekBhSWBfhtRfgumwxr23vpUvSuWOqXO16CxOtm3ASGC9SZxBvaltssLCx8gO0XUKLG3C7ZYoEGSxiKtGdBW6Cbwc5GnHAw1yMHNElPyABMCG476ZNGqrfj5077t20F9JXJAD704Y70wX0f9Rlq0Rssxv1ThN/c2erro9fXShyGXPsN/vsb2ulN+re0yRp0kpUI81kv1s0mtUXFYsTa7cUHKyV9eCZcwP+1/hp+kKDKricPVFaBqQ2g0zQAF0whchTbVv6vPoUlYDUhDff00GNx2A8e27JHZ3c98ZAvxS3v/896ahOifBpETBNUKRedJ3NXLFjKy71vR+4fRI1sYvkwWdZETt2YOhP7EiIopnihzlDpdlqg9kIFZbhA35FC84bDCkYX0vWIpmAqlOAb7Y+CWgCwQ5WaPQv4+sD4lxBWGgAg/r0rp5IvVBdC6KTghcsAZW4hY45+ErSwb4j8U7Nps3JHua9kP2hGnkRlk+vdEiKHlsNV794wNreRQu19SIQec32O/O5nqG2kjQ/dJNRlXjjWqcq7hekfGpMN73mDToyJwWpqgOccsmZ3ZFY1jQOz/so0slNwVFJEie6VE+zujxkR1WhwU4e1vI1orzKEIQrCnQUi2OOLYg+tYjf0bljhbE/X5exVJ+F/DNegwo1jwcHmbC/3VB0pmWjjBXEcg0B04r2hTL03CNRlDcoqnCt92DSLHcLZJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173a9d2b-3012-439f-4839-08db0a73fe56
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:30.9515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VsS1+WSdm/xoA6uhbL+kh2F3CDKe1K87CWdTLmdN+nUfmKdHLrqCAzVD+pw5wbrYNvCGlrUQd2q6fUz+HHwIEntkrwFsPfFj6JGgVwpPbso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: t11qqCInJI0SPcbVhmw31kbV8Vrzyir9
X-Proofpoint-GUID: t11qqCInJI0SPcbVhmw31kbV8Vrzyir9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 595a5bcf46b9..9c09d32a6c9e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 736510bc241b..5cd5154d4d1e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

