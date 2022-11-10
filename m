Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45613C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiKJVGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKJVGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97765FC5
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:30 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b79006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0eSwMuWNKeFoDRrYUb4vEDWDCKm8Mp8tDBZ5j9ICFQw=;
 b=k3qRA6RHxgePKOChDjzAOx2cvaCbvZISi7bY0NEVDS7TRXTI5SaztAVl0p0+K4SUbqGd
 fE7usQF9R14WIeM8jjxmyPQp9wE+JMI/thg5+NLl9qEekvG+nR78s8bUm9l79i6Fv4RI
 /FvQaoWVJ/QFoQd+WNDvpt9jBWK+SgD78dR2H/Yj14NuKyQ605h4WG4Mu1Y0gB+Yo88N
 d2a6ghnkhbZwL3k3puVSJ3gMBPTIo8XE+UANgTCdZDOfBo1kZNqqLynImG4fZT1PkLxc
 y/mGR161ryMs6/laLOmNn7OcLeyz7NNY/V4SiARz6pW2TDDJZaFI2WmLMNUbPho44ZCy 1Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r1a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKhenG009770
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5hbcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cda0PZ+0vzZVTMVHmdFsDZRlosu8YPW8ULIRAYdwSG4jEmDnhGrGi57mZPYxJCBnzP29qgGMEnf6vSxU+sZKWinexK4jE5erIESFQ1FkFDdFVlTRYSAwZPK2VYVOqQi62+eZyJgyUvnDmOgtS3aVlN0s/nG8kynyyI4uCz8gOXykNyyJDswxR25uzOxpRR5GBow49nTYGr7CZbG9Ks4okqWfDwPVGYa13EcPISU1eX4ky+Iu62mMWqv+ZAefg7G/0wLIh7f1QHO3lOxQ6q6C78UMvfEm6R2d5iqIpePYDK02YG80Q50jkxQSYxuoJJTdHGLMn6cq+Wr2MFM61UUq6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0eSwMuWNKeFoDRrYUb4vEDWDCKm8Mp8tDBZ5j9ICFQw=;
 b=WgSrJHNBu9XBojbaiX5mOUzZbfHb7Pq9auQ/0teNzP1QMogOoNlphkFbID+UbqYvUAwKINEuYMCbu6zA34uSkuCshp1zuw3uZSZEoL2CWOcrw4Xs7zXxLBWLH38wjHBUr+ILmp4fkmyUxGlvdh2e07ZBhiGa4scoUuuuDAbfbnlbq3L+vnmwxC32uRqxDF98i8EtchNOgZL0Aqc6P+/ChegxS72oui3z3LABn42JMZ1Zn+75cXfOh23IlIMZB+EifjVEpBbE4PNVKrnZnt38tbbE/T41q+qZc9mElnp46bjR80rrVq7RslfxhAMU50kvUE1WxlJ8EZsFOWBzlW6Y5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eSwMuWNKeFoDRrYUb4vEDWDCKm8Mp8tDBZ5j9ICFQw=;
 b=LLOl5bsUKx+bcCs1qVwX7T0tK1yZlfM7HMYa1b/ZuJypaJRatlafMSTFt/OK0Lcatx+kvnn16r9XR6htZmvH4OODuQiEOiTR4PMsjdO+HDHpCwtAnYX1bZwj0MwD45bLNRjxnSDCEzczk++NMcaiAUCx4Wxb7e4Kl8lPjRvw3LE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:06:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:04 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 17/25] xfsprogs: Add the parent pointer support to the superblock version 5.
Date:   Thu, 10 Nov 2022 14:05:19 -0700
Message-Id: <20221110210527.56628-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0067.namprd17.prod.outlook.com
 (2603:10b6:a03:167::44) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b152849-b0cf-4ac7-630c-08dac35f610f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Y4IoBLPqg7XKgb0/+QIuL7h7jSPeaIwkHCBcXlkqNBR9loTbd4++LEK6FjjiC8Nb4Q25GrBC4NrQZvxQpoqIY/GfVQTbWFYn3lvttEAhvWVuPZvgWWBjP2wfR4q6F6hM1o8tJN7TKAYyATF6F7W1Jzm3gBCOk3skHCJAOKPFM31kywXa7uMDdS/DfeWC4h4GJGGMW7BkOrs+I+k7iUdRy0kinvdoGLRhHsNmX/10T/0jmNjCfGNwLluKyRjYHPb+DqLymp35K3vF2uLyqs2WgJdEbLhGE7gkVmxws7h3ucYmwwRO2oWCD6QsuAJ2mtOsEM+JTKPweiVLX15vzJ4uUbKVSCLCuJoi2CtW9WjnYd8+3bYW4MWLKHmjGArc5pHbeUJJDzF1s0Hwq0M6MB6rGpiNRV2P91FyE5YT9jpBQ3zCfC1rnGhrs5y4SIoUCaFerw8Q+1tnoY97oWIReCGNuERR/rc99vgvzZyDvn/qluKl0rooy63VamCeJ07a4XmavvpVCVZFzWgxEzZmzEAklYVlz8vmranCJLM03vLop4NHVQpJfvBrkvpU4GOia8YhNerOLAneMceQyG7FJq4LG4Qd3U19VGdbA41dKdormy6rCtI+Vea+j0dQdIUCruQTGCNLCBmHfifWLmHTL+0RnmUKKfkKIPGxqkZB7zxnjGhseTkeFXMFILajbz/uBa/BQITQVaO+xi5WlBI9PAAaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(2906002)(6916009)(36756003)(66476007)(316002)(86362001)(6506007)(478600001)(9686003)(6512007)(26005)(8936002)(41300700001)(6486002)(5660300002)(6666004)(38100700002)(66946007)(8676002)(66556008)(83380400001)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kNvELKtVcz7pWCiW8EArzTOE2HWC/rILqkRsy7hBgN0nQnJ7sOURzZOXCxuV?=
 =?us-ascii?Q?2pjocdESL9Dr8rMRRJVvqh1kkOJ2KCP44x7VCwRprJxvbxYqj+jborLwuWHD?=
 =?us-ascii?Q?6SLD9lJMukGgU2bkibMND1o4E+oZpw31eOKYN5AASB7/nR9/zEmJw+jwI3AD?=
 =?us-ascii?Q?MrFZC6LVaxvJriw6taemRfXbZ59s+lEHsZetDEXlMJFiVuGUJhdGQrukH4Ex?=
 =?us-ascii?Q?6UzIuaUb06BOFcvza+wQ+tfVyNyLVQVQDgvF6D8mwukrQrDOQllW+sC8FRZL?=
 =?us-ascii?Q?zEwwDA7PJOcPIYBNzLUHCGQEB46D0uK3DEsUq8E6trwt8rOYf5AYa/4Xhq6A?=
 =?us-ascii?Q?pJg0aXEXTrIwCpktfPG833+aujwqMjHO+z2BWKJ8vzza3cQCOUvWMAqOoWsf?=
 =?us-ascii?Q?r+tXG1Xd2WwZnbAsb/qicLKT+8ZLq3F1nNj8cu0PYSA+0VV+UazNAiFLoIwB?=
 =?us-ascii?Q?lkYVBEkslbz0QSHrZ5o22AS3N0hnxQPzJ0Bh+9LcPtvEO+0IFlIb0ZdZoKOd?=
 =?us-ascii?Q?bHVrHjybau2WhDQjRHITXx4i8NAZHwThSRVh7ctyBDKeMFP1Hd1VKWQG8ytg?=
 =?us-ascii?Q?Q0gUqlORv3AAuc+XUR4q3lk9jLA8egIpx7LF/nyANRRiu9+mIZYiYqgvYLjo?=
 =?us-ascii?Q?jONiwuBEk7NtFJnXm+64nb9A91IwMxsJGsb81xFCTQYRH6hE6jwDxYCtlbqP?=
 =?us-ascii?Q?sNKyijaF8mOlyiyIz87Tv+lz3f8FeRrkvWAVAhzI3FaLxzbxebuoqjtmB8Zf?=
 =?us-ascii?Q?i1DszBOS+iTVGbhxRO7bb1FuKm4dc5JvNUD5bzZ5+tLiRyU334LQA9XcZ1lq?=
 =?us-ascii?Q?PaVxGoA/pOUWngC4rvbf6WLTw5Q3IblHwrdixdFIeFcrcxy6xRKiF6JwUDXs?=
 =?us-ascii?Q?9AqG1ZzT1cEELriUcJY4dmnHY0YeXBCzK9zfQe8V42kIjBPNZLm1l8EZUe2H?=
 =?us-ascii?Q?pKl3s82WdLtiSWHXWovvd19pHesWB3naFhe9Iu7jLl2kDAiBQsnZQCLWzUuM?=
 =?us-ascii?Q?I3dxeTHRkmXq56o9KIbFk2xx7nzR32IjJPGqP6Vb1P5mJV5K4MBY7hPuBxhG?=
 =?us-ascii?Q?TpeFZenLSYkD078QrMOE05fLanvTDqaqGbzIGHFazMaBSd4M4VlTrvwaWSNV?=
 =?us-ascii?Q?gbk2zlJsmfTjAvTPH0h/Qnru4BuzP/XUt4IS0yyCCNYa4E7JYgVsfxFoIGoU?=
 =?us-ascii?Q?1ngJ2H0QB2AjbL0V8s6dJcRsh+4AoCfCBDbAN93QiNXf7Fnwa1szfB9oigt5?=
 =?us-ascii?Q?XeLS9NVgaw+6df/hD5eWuQG5cp6IL8LSsOR7N18ZGS6oBzhCStelnkGpuZAZ?=
 =?us-ascii?Q?PDTTkOZ6YGOxfUnoX8jVhiomnd3HAxPv6QJ7ZfaYGvLjp6OFPWDny3IWEl3i?=
 =?us-ascii?Q?VGUTv/QbXvELYHIst1SSbNNhYhMU7hSM32wqKzQKN93pqOmc5w/nSoFQsdN7?=
 =?us-ascii?Q?gQHykrELBE5V/WpEQ6sPPF1AyGWECDFM3SkhF3G0Nx4verFU31kNllliIHKO?=
 =?us-ascii?Q?rivFMtQCqZvcPqVlTjbfXRBdvY/Jc25FAsXkzcYUupbLeSzFJVab9If2Nhzk?=
 =?us-ascii?Q?wDO7nkA+yRBL+PPdywB9EGEuAkQFRlfyYK0sniPl+kbEXBXRufuQ+EvV7kiR?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b152849-b0cf-4ac7-630c-08dac35f610f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:04.5147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /wPcuQvnGlXXptGZgEITBzUe3irJz9PPSK/1M9z7esnf1gE1S1WzRYouLHIJFAUCoY3pF3xylBfbAj4ESKVxpvbkBIIhI61/r5spklinAko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: JzUf6OijUOhFbiwAYd3AW5pJoqgAgMsh
X-Proofpoint-GUID: JzUf6OijUOhFbiwAYd3AW5pJoqgAgMsh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 724321b7f1c737ce880ea0e6fa4422ad13c4d440

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c    | 4 ++++
 libxfs/xfs_format.h | 4 +++-
 libxfs/xfs_fs.h     | 1 +
 libxfs/xfs_sb.c     | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 3e7f0797d8bd..3bb753ac9e39 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -31,6 +31,7 @@ xfs_report_geom(
 	int			bigtime_enabled;
 	int			inobtcount;
 	int			nrext64;
+	int			parent;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -49,12 +50,14 @@ xfs_report_geom(
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
+	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 "         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
+"         =%-22s parent=%d\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -65,6 +68,7 @@ xfs_report_geom(
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
 		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
+		"", parent,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b55bdfa9c8a8..0343f8586be3 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index fc33dc4a2a68..fc222fa1e0ac 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -171,6 +171,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1185,6 +1187,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
-- 
2.25.1

