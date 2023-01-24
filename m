Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05E9C54E94
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjAXBg6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjAXBgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB181258F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:51 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04KGc013028
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ZpypPa8m7ksKuIgB7hynZSe5tkRIFntXd820eDNagkA=;
 b=LHulM3x45Mjp+4GzdmNm5hj5krI5UeIafu8IgPfYCTyHKPcP8PkFaJM8X4AtTwBnWk4V
 DZPLR0BahFpTae986s/sitc06F2sp8rGA+7Jqpty9k97h1W/0SJcpDhD2ps4FOZFxBFh
 qo5Ag7UYB+Bx7UAxRsO0iEo8ZrD5T2YnHPMgx+KdfO0JYw/Ia8Z93xhcRRMXg2s6dAN5
 3iOvscKpRoaMYB6Za0ZFgH0AlbB7yxlpeM9wzrympFSgWu4NrcRFQIzEKBLno+TOSVaf
 tIsC8nOQbrrLB4nGV+S7YXvxgnwVsRpRYRBIHknFmf1uT3EaKYQr0eLDPgZE+ZMQ1fSa Sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fccbxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNYBNM001108
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNyGKNUlOELPc0zpWIL3XNxusypfoI+XEmv+D7syTgdaH4F81NRwP5MNP2m0/ZHDDrCsTO15l+/EWRtTSnCEA/N3/mAIA5R0rW4YLCL8UbjpVkprC9k+2OZo8yqtsu9sDZPKGEDBJu5l7mYewqkjHNWPUkVrQ6C0JuQUV40gvrvDMh58P2TB7WzvR+nxLxqUHwCHxsPAXdiAsu6kq3M8iIkz+ErceT3u8mgG2MLzRxp7aLUL0rO3KsXFVVGCqmeMIlr1KfygDEEM9L9yMw2hjJDunD5O8QFElMfcWNHwe8xbJDYVbBGc/2a92M8B47Ft4wg6fW58leR+BPB38UELCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpypPa8m7ksKuIgB7hynZSe5tkRIFntXd820eDNagkA=;
 b=hXA2yKLJYZ3sBDgMIDiLauZGjGP2w0irLxHFbylYRQY9LYKQpgeR3M9TH3ZZWHNpHrUZGzEgAHN6Ct4kH4z0hTY2ZR2qDH/zmsPqhhjhcCFBn2IiBIvhjRCMFMQN7Ur37BYN8CWiGIKgp8zl7O6IFBT2IPELeSg86lqrJTVa4PsFMf1J0pe5vWfNDJbXaDSIXqbU+Qw09+dlfqrHyfBwMsADXCRynthWTi6PvN0bddmGLDYIot0y0M5rvBS381srlofbOES31ugVXprHXjosG+o6OsDFDe8ZpmlO46UXHKRVZICJE1lT92GoR/FvEUUI5QBPyoGNoK5gG0y7odgBXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpypPa8m7ksKuIgB7hynZSe5tkRIFntXd820eDNagkA=;
 b=mW2DbMUwN0ZdLccJm6XmaXunTg0WjhH3DPSJFOpJdq93KbBU0QurL8nFIuHUC5i8i+ol5rVJpwHL3owGO92269EOsATiMR2Cig4FmxzXQK0CD/QZp5SQ8DEjGCmpupVR8uRPgBDL6uaUuUq+KJ3mDC+ke45o7r9TMKDxJdtXZRQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:47 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 15/27] xfs: parent pointer attribute creation
Date:   Mon, 23 Jan 2023 18:36:08 -0700
Message-Id: <20230124013620.1089319-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0069.namprd11.prod.outlook.com
 (2603:10b6:a03:80::46) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d286061-0388-4109-2024-08dafdab74ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5E/pxSCSAP7Dc73/WcUiDHqCNbgMmOERMKgDcb0QlTJoKVT5U8aBo+eGnpcGM/wZY8nZft+p0IsBUwUpoNG3POP4Wg8HsoxDkX8o3NX2KHuwThCR3wc4cn8mpE7fpL7Dx7FTzC3BK6ImJSzJlof1jTMLpaxHnl/FRCGfPWMbMuMNq/VelkmOejhIKYtiq/ErqZtFQ6MMJFrQm+EFVdnd/E44Z+0zrh+5ajvc7L/NUmbxXuhGpFNxVBAAGU0Ql4zkxB1Ak7KIP4omeZa6wa7MgV9q0mjNm3OpCWo/uGbuZIwZh40AOYZ1E81ws/0X2Js16TwAkXhKfAOtWZ/+V93dbsLLx7tiZxx+DZhUKwoH4viCQnmBQgWR60jombZyZb5TYn27aEtXiYn05DqFZp7pQp62LgM+fx7qjKlN8wX94A0I0X5S8oIdLH6yrrX/jUxuaCfRvN4tB5KlB6zaTRvpKFAm7WhHnaJkh9k1+88c0LkJ/eNgcLSDOdfLH0uh+6n+gyzuA1fnsaa4ugiLvzjZSuErxFO9hhdoQXUQxyaIrudboTsa6WPQ086bh7arJMQjfrdFhSg+xO8fNypeFieWI3E2DhJ0NOHKOdP/OpZvrMYfpLIe4I/KWOMRQRRaHo80wqbvRJLbTsb5jYZ+nuy11A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(30864003)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5H7+cRoiavhe0htY7jeebw+msHt1DhlNX0MbIU/drjeUDGevRceMr3d+F+9a?=
 =?us-ascii?Q?KAay7SfuEMuYYW4KgWHcn94vZIN/niDkH5ab86piGdR7VRdccXlkA3OnqeRP?=
 =?us-ascii?Q?e/hSdAV1RGcmV47L0gQCiBGZ7rFVFhDEIqbOVca56eEYNYpFkEtsCsogumky?=
 =?us-ascii?Q?7aHFE5LVmE0nI0Am81LVDq9DeXnGyhByPZx8oI88T4EBX40wm0Ysk2UPMF20?=
 =?us-ascii?Q?/rsOibDBNTS1IxT7AtEduAba3nobOKyA9WYi4fI6SZJu8dDgjkpWOwdOHFyZ?=
 =?us-ascii?Q?xqDa+I5X/mu3dyW/HtptJ1sxKnDgyxYGApVmRXiprs4MG/WVd2YuRULbCOrg?=
 =?us-ascii?Q?BjjMvKuGeVH7D1BIm0asuqkBOAJej0m0dYjilWlsZSTHV2ba25eg43sWj6a1?=
 =?us-ascii?Q?mjUFu5ACiW1bX/rvVX3fc6kPhspB/QNAgJRUCkfoSOsQpi65+KEEucWtL16v?=
 =?us-ascii?Q?TxmthMVADyiD++cDMVbZy1hTGFe2UHv1RO1ps4tmQIFBuOsJXAtqdKvr95g/?=
 =?us-ascii?Q?H4jT8zMg8N7lQYm6Pu56UMnLZgQNq19jrr1umXv6Ri+u8+a+/UTVmJq1d5dE?=
 =?us-ascii?Q?bT/MR1+TKQSVFDwLkiKUA82Z2f/j+oNjKbELqVgFWpzKpt62NYqEyS+VwBse?=
 =?us-ascii?Q?HzZU8pVHDuMN00jslfl2lgI07r5vlJhNEIx+YOw8R/r1UncUpFExJmSHiB3F?=
 =?us-ascii?Q?/gfThUT6TRxyAVDRey2+elrKS0WKuRfmUCSZZW/q2ezpo7JLBXKS58su1lKw?=
 =?us-ascii?Q?vBpuGA+PrTwd2IWs6U6JOjgE2qLdqVfQXPuBG8bAcdVG151tE8gQXQtt12a+?=
 =?us-ascii?Q?NYKWM3OpZ7MED3WC3Dhp5NyZdK3OGUaBq4Py/jqBuGUhT/9leJnRais7/iYl?=
 =?us-ascii?Q?SSfZb+AXCre0oEnfHR5p8H9R/mM6u0ELidhlX3Cf3FXtZvcaIB3qvmxFWvL8?=
 =?us-ascii?Q?Uk01108lWAHZgKgRSxxKBEUUNQ01ctt4MLmyh98VDkO/BtyXF67eIcm5ELE7?=
 =?us-ascii?Q?PEv1dx/4kHZlzbI7PFMa2t/z8usZZXPL26YUw6WbiLmFG/gWchEAxfiUbKUL?=
 =?us-ascii?Q?+f3i/Jxc67HKFJL8pNW+3Upa4/KFSysKmPCz/LnprzJrgBlo8nJxkVeA3rNz?=
 =?us-ascii?Q?JcJVW4xpuK3gOBHUAxJAZC+0JG3fy+RkGgNUF+E7b1B3zw2o968mnliPQgxD?=
 =?us-ascii?Q?mNk582ODDyiFhvNRgsXwXwvhxVIDEBZ3uZXjJOs/1K6UomHg3dopE8BhdWhR?=
 =?us-ascii?Q?hZjtOcSQp5YmV9Ocdd8fyypGCl5yexCDErw5HoHgV3EzfQtasUYyQHevWsqD?=
 =?us-ascii?Q?cz7YGVO7UFhAcURAamu1hx55UF9eptE2utn2MwR48y4z/TZz2cd4tgjAPlo/?=
 =?us-ascii?Q?s5v6yhFB3rY11pOzPu9TCUbmigqhueh2lgs5Xo8dogHb2jESUYx9vwchdxts?=
 =?us-ascii?Q?h6eH5LaWIX6t5s4h8/PdEfBBLWhbOX4aECRavN+fe5UWWSHvL78cPms+4U6X?=
 =?us-ascii?Q?PSmoBepOuMC5HhW5sssLDTpYIw9mvKolJvjNrKOI73Lig/gPAWn4STdrfkHQ?=
 =?us-ascii?Q?lP/wBLbxXJ5JaoQr4BavHbbuPEU39bEEGTN4tlKHYXTURuIyqVFpRyzYYT4m?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lqTr/PT9zZ0QOqs+r4bZxZWB+712XSXcIQP0yr5QBodRNJxOWV6VjkyPY9TFrwQ0qK4bA5lMSW87wCOQiF0OR7ye7wkolHV2K6ZrYsFg12KeZyZdcNGyIr885OVDAFyMroW6gTkcSRUuHDx/YA2f/wapMUuwQaDU+xtlzxekYbUNmsCV9RBIcAdPq9RRPYnFEzjBx0WqSszRBLgkvpGY3zUPTrNgYeHJxMGXmjtC1bZmcjTbGF4dQt6T95VA8urJQ7yqEclHg3JoP+40srFWJ8vBnYTwHcQTbmqJ1TNWKmkW6meMJs35mW6pNrJrYQaIFwxI1sfHjOIt+qYdv65lnI9g6vTD+LQfgHZV5246lWEnH4BTtSmOEcSmpu9DHnIrqf4hiaqCdpAJI6jr2vgDjA/QxuLGRA8xOvJpKbPCr66zMtgAOp2Tx1Jpas39+B5au9rq1WVQLDbV+gWXxMfAMva8fCkn0qwHNFntEM9HznUHAXd/MrdKt6lYuZwRqfAGFShdxo3HWHjBCLCRuuEOscM+rfvTAZ6xNACyt+8K3qoxkDOlye445EnsDpK3pycB+6cfl5q8BxlaKxgc/JE+BTkMaztwVczqI7WrhL/ZP0Znq3e4OAEF4j8G9xI+7dx8IRYpq7sIBAYkGhC60x59CR/t1wYAxZXmUR56lSjeMYhICwul9i6QxOK9WLDZ/obfbQ3K2+zHl7x8I0EUzLXEk9BK9gHx/v8VAfwkByyOmNd8q/NZ5Scjnl8YasChLiDyYaW5zm2p5jwRWDnRAYaFZQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d286061-0388-4109-2024-08dafdab74ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:47.0931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRLIwqDzL34sgzX/5JTKoQO4g73xqn8soF/1J5RanhBTSOzkPzaCzEBXkgm1z9ZPeqTXQ+9PEt2a4gpyJkDH7YmO+NaItHciv7VVkpjz38w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: AznpZ0EVemGtJgmx0_BS6aE_1BDjMcZI
X-Proofpoint-ORIG-GUID: AznpZ0EVemGtJgmx0_BS6aE_1BDjMcZI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_attr.c   |   4 +-
 fs/xfs/libxfs/xfs_attr.h   |   4 +-
 fs/xfs/libxfs/xfs_parent.c | 149 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  34 +++++++++
 fs/xfs/xfs_inode.c         |  64 ++++++++++++++--
 fs/xfs/xfs_xattr.c         |   2 +-
 fs/xfs/xfs_xattr.h         |   1 +
 8 files changed, 247 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..e2b2cf50ffcf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 711022742e34..f68d41f0f998 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -886,7 +886,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -904,7 +904,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b79dae788cfb..0cf23f5117ad 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..cf5ea8ce8bd3
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+#include "xfs_trans_space.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
+void
+xfs_init_parent_name_irec(
+	struct xfs_parent_name_irec	*irec,
+	struct xfs_parent_name_rec	*rec)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
+int
+xfs_parent_init(
+	struct xfs_mount		*mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	if (!parent)
+		return -ENOMEM;
+
+	/* init parent da_args */
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	struct xfs_name		*parent_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		parent->args.value = (void *)parent_name->name;
+		parent->args.valuelen = parent_name->len;
+	}
+
+	return xfs_attr_defer_add(args);
+}
+
+void
+xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kfree(parent);
+}
+
+unsigned int
+xfs_pptr_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	/*
+	 * Pptrs are always the first attr in an attr tree, and never larger
+	 * than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..9b8d0764aad6
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+			 struct xfs_inode *dp, struct xfs_name *parent_name,
+			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
+unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
+				     unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a896ee4c9680..9e195d0e6abc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -946,10 +948,32 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+static unsigned int
+xfs_create_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
+static unsigned int
+xfs_mkdir_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	return xfs_create_space_res(mp, namelen);
+}
+
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -961,7 +985,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -969,6 +993,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_create(dp, name);
 
@@ -988,13 +1014,19 @@ xfs_create(
 		return error;
 
 	if (is_dir) {
-		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
+		resblks = xfs_mkdir_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_mkdir;
 	} else {
-		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+		resblks = xfs_create_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto out_release_dquots;
+	}
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1010,7 +1042,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto drop_incompat;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1020,6 +1052,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs = init_xattrs || xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
@@ -1034,11 +1067,11 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1054,6 +1087,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
+					     ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1079,6 +1123,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1094,6 +1139,9 @@ xfs_create(
 		xfs_irele(ip);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 10aa1fd39d2b..3644c5bcb3c0 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..3fd6520a4d69 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,7 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

