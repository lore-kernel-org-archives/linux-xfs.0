Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35044C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiK2VOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiK2VNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D6170DE9
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:20 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIiEps013743
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=dAmXwFfkoZIYkLCLqSRKSp0COwJhx/PumKYZW4voEy4=;
 b=0Fc1ciQBtyToW8w9K3g5vYb6A/S/euLRnHM+Z6ofTh3nEH8p9u/BxsbFeaF43tyvPUt4
 OI00PdNpxxUPVVvFndYo2rpr+6apFheAwP0tapdY45i3laIbP8oRuNDZ1yqKJiONso8f
 BvX2QXXoR6OsXdBCk1kUuhFVOxJMjx5S9s3ThhG06iMdoJoBP/82r/o39iYuuLKQmCZW
 NtGNoGgGil8s6WGqZPpmiWJmk6wT8bCftVCnyyWZKiapAQeC0jvthd8t2yr2WcR4yIkV
 /EzzrxKuL+OpiMFE6zZI4i49cFA3QJN8CfO3SvQuStuRr+wASFzeWgsbxWAdipYCcr/p 3w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt88bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATJo44C019311
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398e6h89-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ufu8sel25TI3QtDyU2VGFHuaGHI2JZ4F+22nLnaf7wupMq6sfEG/VUWqsBCJyiPcuNatZrliC+7mrjivgYIpUgWWJSN2HXVmUbeHut3SduigvyO9jkZ8dcy3whVxxPxXrmRqE4pr5IK581RhkJyHXhC17b25hXoOBtXYd4JSdkT4k5alcKQTYcuzwmCpJS7PX2Ibp8yq3dZek5syeFpuhNOop2SeOgLVZtzuqadC/dAcojHxZ6lIy6EYuUH0hcLFsu7hTx1yL3v6zcBrr4ponM9vBpkXUk+vH/ltxjLdaFx2zu3+cLQgsZomWJmDH7aNyoSNHm7bZC7y19roibjT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAmXwFfkoZIYkLCLqSRKSp0COwJhx/PumKYZW4voEy4=;
 b=fNV+090hHUUBquBLPD9xL9JFVjmWZq/bnkPRv+3z9CEO1k/i85c9OXkEZM5hsmEmudG5vAbfIStpCdI6yV5bhGtjWmdvvih+8sLwqEp+lcSnlAB6NS5eTo9VVlplryzn8QHragQnOaMHKluW5WYOuGapGtlL0o86FgUNegF4AI226DaYqbIMNqpH8w7/8MdYeY0uydDGRKxInKI/epnHshiCt/BZbZU4vdsagf6db4gJzdbALrroEaNdQgH+0X9uuS/U85WTeejVHx+gjwJ2SAmesFwxowLBbNJjWG7GVvmDEN9qbAnHncWDPtpWjMBBqsDdfU7i2sOYHciNsa2wAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAmXwFfkoZIYkLCLqSRKSp0COwJhx/PumKYZW4voEy4=;
 b=NJVC2tlJWigUgYIqOszy2PWn7NT/zWr1/FpNEz1H5I/QOIqXuseCLDzXTc3NvYyHt6g8zqrEwwfdtsDOqIZbVqGRzcWmPFtd4s6Y4S2XYsrwQoWg3grV4gwr4+cx0LY9VHJbbazHA/mfPL+Te+ZwCU5p9wIUJT1fu4/JPC4c0tc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6496.namprd10.prod.outlook.com (2603:10b6:806:2b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:12:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:57 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 08/27] xfs: get directory offset when adding directory name
Date:   Tue, 29 Nov 2022 14:12:23 -0700
Message-Id: <20221129211242.2689855-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:510:174::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 42190e05-00f1-401d-5b96-08dad24e7d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wTG3N4hE1Ur25PNCkJ2B+uRzNYEmnPV7R8PZVEo/+2gy3TkID6kyBLDGomSmGNd6421I94v7PDjnENBtmkZkAjt0nqN8XOgrQyAN32TjiGqAYClnr8KtHbLXAkKg/r93xrT1dbOXaQX6CQe4iqzziOxlOuoCskAtqGpW/uW6qTHpmpyqV5MQr88/MPvmkkNpe3EiRocfNYL1ipFKEGuP7Ln8lQjAQee/s0lVF07ZLpEdPqvVybiNVKHUG/ihLdUt2JPnBnOcPOv1sK4kg/kZVv/hJDOjxBn1aJvTBwlIyLPAhFHtfVvliuoTO1BBi0TXIOrmqLTzUilQXrv/CdIABObT86y4oc88uVB4uRw5/uip4GnDCdQlCICjy5BCumipcIVS+rhJqcVwNCq4njpKCCQIO9VSiwTMQ748naT5oHGQTC69nKo4i5uZ9K9i260mL7oAUl479xbh8/EIvQhub2vxODxRAbALRzcHA0vaQnlYHkLPZApawflAXGQz7494mCiapFZQKpyK8mTCawP4OzmMm6okf6bySaoBK8iWfJkm0l4t4kS1Ls6UQkLnkdLeu3GmficC3SgzJr7GfVSK69yqdHyjIZP6VIig0YKj7mtw7D6sGK4OPdHzIxaHf2Gm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199015)(2906002)(6666004)(36756003)(86362001)(6506007)(1076003)(26005)(6512007)(9686003)(2616005)(186003)(38100700002)(83380400001)(66946007)(66476007)(66556008)(8936002)(6486002)(41300700001)(5660300002)(316002)(478600001)(6916009)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBC01tUexxNY3aCFQY066VVuyfGNQIkmIwTudnG13jpqXk6LbHs67L2HH0uz?=
 =?us-ascii?Q?IW4qTEWHUaQDwKpsp4iDrcfUuv/Y2oE2c4EHWKUeyVX2A2XSGeZFTkO/7gMf?=
 =?us-ascii?Q?01UC+ncOsFpWcpQnv0mzx1txZGWF7bH5ATHPTW+yAmyGXK02R65HJkKLnbdk?=
 =?us-ascii?Q?BZElIW6nMP0b8gVJ+VR8yVGFil8Al0Z/Fa6dm+ZkXLdctJlxQkQr/cgPgrfI?=
 =?us-ascii?Q?ZwipSeRDGAsaLUQxrPShhmjhOBvdq2y9jYYsCUEU7iOoIHyJdVMbiewfYlYV?=
 =?us-ascii?Q?v6mDOUjvEPwL+zb1UTfbwMDk24L/p5giulYkF/aut9BgvmAqRsh5nCH4vv0V?=
 =?us-ascii?Q?deElJavhhsnzH2zvjHZQqHeFUXCkdJeiULQ4F+1k4a29bjMtGek/e7g9y+VO?=
 =?us-ascii?Q?kn4s8OCUINC2WFtuj2u9pb4gQqgastMvhiqc30yqXi1jKf19yPMwH/Ksy6GU?=
 =?us-ascii?Q?ZwAHs7Aj04goTndnnf2h7/AVwu/Jbgzgao3Tbi06+FK0pWzzVnvGpwVmy6Ba?=
 =?us-ascii?Q?hXnk1Jnf2zzz6iG9S3O1yftMOkC69HyAKR6wrqGC5DGHMaCyZ6hmzxJ3l9ms?=
 =?us-ascii?Q?hDmOqWCUeq4EE3mTuzXHPbzZ8U8+wcWLDTk/vOTx+ZE/aXJ5rAuOLRvyfIxU?=
 =?us-ascii?Q?OnlmlQG8/H8uzIbSBFEyZ0UTLaUlO1lYmcOApsbw7O27kNc+ny3lA3dkjimN?=
 =?us-ascii?Q?UDbIYE28HfFeP2sBZf+OunP7GyQN6YhNPNI3P4HrTxSPa/vC9OzLzUEcDXEA?=
 =?us-ascii?Q?bfQ5sj/YyUfRDLhhqDakX5BHCSmO3jh6xFexK6rK79ydHllqdTH1BnBN+5YR?=
 =?us-ascii?Q?Jvj6XPbH4VbR/UMXCKx9kEEFZ0cS44q3z1wxc+kgM1OC3hWe2qy6n3X8zXgJ?=
 =?us-ascii?Q?Qo4uWqNj2I7XJXysVIba81LOtdhGhaNvN0aiEXuw30rT4+/84Ffc2199lstA?=
 =?us-ascii?Q?6wWVjAjmmcc4EQ4arSD3oi/K+r6GERllxE7L7kGX8uqxaM+6rZNl9E7L1uYC?=
 =?us-ascii?Q?UHpO8qd1AJ5Z9f/HClZOqOQU2raWJXWHL7FVH1ZqDVXhNtko1pxa0G6nRN88?=
 =?us-ascii?Q?TOdvtU83XLYrk/dPzalD2g3h6IxnF79yACj7JplpkPNlbdce6wdpAOvhdt04?=
 =?us-ascii?Q?BkUDTfZIJIUijpupDl1HSbhggJCwH0wJUglDaBBHqRp8WkGHiwFlQ4h9Ordm?=
 =?us-ascii?Q?SU+4qWAYgspyitVbjGV16BRN9ynK3kBl01GMNjIECQCypFziWZvW29ZP1Fgr?=
 =?us-ascii?Q?f64kddEO1EOTSWQL/r2uiS7NjQhpM6YpCESqwS+6ZmZDcvEf9tCG8+F4VuCw?=
 =?us-ascii?Q?AZh/MVzvEi6CQsjgRpr/sMoXtBH6eX1Zr6DyhV6LWQZJ47te8wv7+p0EXrV3?=
 =?us-ascii?Q?DAJ1xerZqzYlNyEknCsa5H0vYGosDdKRrKOcm1GuN5H1AmnC8T/Y/nyLwD9q?=
 =?us-ascii?Q?u949kzlxqmrccwvhgtZPycP2EorL4iM13SWe4FhOZ1tzQWRKuR7apNWJOlg1?=
 =?us-ascii?Q?TxKU/0lSv6ZzExfm6DAciEjMrx/8HI7TKR1AEwhhdbaw7cCP8mxXIqQ5t2Vb?=
 =?us-ascii?Q?aEpuFaAyybFtwabX8Quq0q/FkiwkXUyWMkztCPbMM7QReiGXy3WTstAyf1lW?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1dtDLfuAwohoQctjYiEddNGw56momLL6WMhb2K8yUSv7BllmAqL059X5+0irTD21EDuUSGXhlziUwn+Pq+g7tLfSNWZ7PDUXcXC4soTBGbquZN5Lqb3v83ynuza+eY1UXyx7+BOvVcLJM/NGl8F/BNJwW/U7J9fdLMWNoOb+OzXyWMXBF9XeQjUJZyWi0SKl9GMApDc9Cg0kYVrGEqtMeAg+eel2bQbi4aIGzEhWyYmNpA/COWEgTLf7s+VS7kPx58Y0SEExF+UqwJjhAzZrWeWy97eJSQMKqyG33/OAwA2ofHqg0FKRD2H6niqSJvF4kW2rDUOHJUegx1JjAjWOBQh6Adktkl2feSs04a/23R7kofVI1Zo/SsOMwqroY25QBHXoJiExCHP4l8ctlghfwkHJlWf1nm6WZaH40caGxDoMpRI4Z/doOGLlCnbnWGArnxIJOBq3qNSlQJco7F8M/tSTeVRX2CEdQoZ07EBadULPFMMRasPpGMdE0cAVHKmECztBq9zAIn+UuYbca24sbWcT1SqlVaLIOO8xCYthUQXkcQa6N26I5EQgGjZhLUio/TK5gyXIShfkigk60t9ZndTfMse/bruhVP8j7wN4ZfUd5qSm7UdcZ83xL2aXWJWLngJLZxv8akw1ZWR7NNFmI5B1/zYvnYr3RQz5IVyCL5oIzqOCotAkV/HQZqQYt4qw4sF2RMFoplFZF3zLA8lQxEuLnS9h7Jz65ARMa3ITzD1/lHIZfYkEc4iX8XyKvMWC4wMLhdR4HoszkF4hHiLQlQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42190e05-00f1-401d-5b96-08dad24e7d13
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:57.5298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RtKpujI5cuZWC43oanfwc87qor1yeUXgMXQ4Ir7dwdKtOuKs+JDZyombS7zg2WqnDodpM2O+dZ9kyTVmSro7d2fAuA6D+GTjHVTn7QZLfF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: w3Zklmir4k1QOoFJ4A-Y9yrWbvHKuign
X-Proofpoint-GUID: w3Zklmir4k1QOoFJ4A-Y9yrWbvHKuign
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..69a6561c22cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..d96954478696 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d..9ab520b66547 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d38..44bc4ba3da8a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2afbe0e15500..ce7880e560d6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1262,7 +1262,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2998,7 +2998,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

