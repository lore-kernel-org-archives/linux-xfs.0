Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24B3C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiKJVF5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiKJVFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2380D45EFA
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:52 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b6R006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Z/F2Il6tcfJDbkc6R8/DERYfJnzNnQi8E+9/MvOSb6o=;
 b=3JeqdvF4dTJuKrD1PF8D0j16Gh264BjfuoWVtrzu5dmDkyii4WnrfE52fGgwUbcWedt7
 lfhlm+im7G5M8Z9p/COlDkhRQKQUFhQvdQHHEkxSL4h4kIMYNFELMP7Y9HO4ztBpytnL
 FuZWC0cdvSC0zmfuqtG32rLirLkgOXats8hl4OT8F6XZhGufh1cG0j7zUeX94beziBp5
 qnfTz1qsGXwabIqpHICw4YdA+LZj1XsVtzpsIeWzxS2jxo+ym2uIi4Qm5PBPoz4/KVoH
 KhDPL2GsYKMQAD1hFTvEWqN/cbBBtQ6WmcyKg4tV/5YhzSW2Yrulheg1uPn7m4Qq7eu+ KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r12b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKTUmI019793
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqkmngh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL22WmQIrq27cZtUiogpRXlrmP9rsHtGIlkTE4IJAVgYaopEOGM2jhYjANtJSraxYhrR/TLPP32ZKV9wR5/7uQhFpX64GDwZXPub3Kc6EAVA1tuUEFFbSslmcaJPStXo1sFG/Q4zZHpdeCO27F7iiC/OmZWVM8LfJ51JMQpiPd8NG3LyKSaw0oD5CZBoYw8SVtNb9n3VDT8AmkSxNmcnGVtoAdKfi9+37VN+eS2OtLh63Wj9x898KbY4+orXfYG0WCvZHHgwLRmmpV6+/MggtqDKdaCd4jM6ZDGBtWMJvARa+n6D9mp3fB7tG9Stxs3i+qv0QTmgNAVK2Wh9SGUm9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/F2Il6tcfJDbkc6R8/DERYfJnzNnQi8E+9/MvOSb6o=;
 b=fGbkt5tBQBGUW7eAA81qA+n4my2zprk4CbGI3V5H6s8MZzdWLUXTlM1+U8DvcsmQBB4liIOSNzYk2h4a4esHPym78+dXR4c3v1Z/bYA8vC2ewOq9nozMvH4ie+VqOykNusGc6MWUjcxgHAD67v9XE6bAU3X5UjyEHCGQsX21+xnBMi8kL2Dh61pkkgximq50BDpLN19yws8axyv58So5/JaUzyyO62vWVUCw8iPd7aSnUGrpmO6R1vVmXDLMJmbgnQwqy4DSkvs0V9kK01KLQ4Ah6PBY6iEWmLA/qJb3zyY0RAU3WxeaTQKJZvyMJBAzhs53Gir7J3o1DzdWw9CyZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/F2Il6tcfJDbkc6R8/DERYfJnzNnQi8E+9/MvOSb6o=;
 b=CMuTjxpvaZGUkbp4fxwVkJYfqTzdKPtWcuJDfyWpjEqvTZOt8PTwTcimL0K1ZqE+KDI7OMgaIafZVr7lxzjo/pIB+4WtdwZU/OgSp9s5B/C9vycqYFDPi3kkG4nI+JthKt0KSpT6JTIkfdvURBYBJ2WMo+z2NWuhQdxAhOoyQ9Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:32 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 02/25] xfsprogs: Add new name to attri/d
Date:   Thu, 10 Nov 2022 14:05:04 -0700
Message-Id: <20221110210527.56628-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c9b2c31-4c07-4ce6-0d5b-08dac35f4de2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIPLzNCHzQg8ZJdhXDSMbMS82gWKuLYt9Flia56+PyIJNtwVFR4fZgpNl620Y9vVqDLjcQji6g0YGvALXy3xrQ9anaJ94iYCalPdWbe0ApsC49SSQ3V0GDSw4vzfrpU5w+HopMvsZjlSqneNQIOhyNhcq/Re89K4zgp8Urmv3dz26pzr4LqRwP6V54DTOsOgNGxiTAx/Zdgoi35S6C4LD1GyqtTsS+r61erMhe+l06Yo0bGvVFTrCcj9ykRzEVTQdx3n4r1vWJWMZNeJqpDK9b0BPq0Wl8kbiAf1ih4C3DvYKp0ULAV9CrjCc2oLGZ1rCvkSAy4jv/WqP0+r1K5x5zEofsHCP9qefwMRhwJoMk/BgTt2PqpS5BGVa/YA1kKB7DYsZZpvfZ8vUozj5m1Ztt7TTFy1t/atGpeYNsTN2ZOu7O7YP0wzkpDkdUDG8Ns04zwFAXpxiTUur1NC8GaYjWzkRw1EVBmZg1sr3f4FZa7s3O0OAUUjZfc583xMdfAOXX8jBHcZs3+OH9X0A2QvcntfDieqOsQ9I786R6Ftef+YsND75d/2eO/Dp+bPaU7eASx4cvvjLA8lEIyDvJAxICSwrbffiiaKecgZImon1R3wKClhYm40mo1cdjG+Z9ZsZjHnMIfGIItrntAuKjnouWbdKwqeSvkDjMNz8B6biX57Nq+f66vYSN+KL9bRgEILmrn0X9jZvzNV6WlRFQWIXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QjJvr8sZuWqqQT0YuqJe5pPrzozIJAReJ9AQMfVEF/5oLuVmcVuqkDLEKKY3?=
 =?us-ascii?Q?gl5nhqrZtWVLawrbvxPGobMl1u2gUjiZMBoursm+f0wMAihqnGgJOtFJKo51?=
 =?us-ascii?Q?69RttFR/Buisj0Q3PZUvcvj6M7ix6wgt6mGg8JyKTAH3KFpchj3obJgGQ6cI?=
 =?us-ascii?Q?nT8B0ZLt+XgusXOGonQpr5pFKTJE5YXD5Im5xPRGiH4qWMoCP2V9Wc8GrqQB?=
 =?us-ascii?Q?fW1VxlIpbowv5AiSHcxqr4Fki95xfn0GPDuoGBj221JKXcdMBQTElT9AjKTn?=
 =?us-ascii?Q?C3dJaZ/iRUUvJDzcTWH9yrARurLEaYVRtirdaZCEyVRw+qHUtTLfCz5BUumG?=
 =?us-ascii?Q?fJy1Sif++XFQP2jIpyG9TiVFZYe6pVnJhKcFk5BiDvkcwhuK9+G0ngcJOlvp?=
 =?us-ascii?Q?PYgKSnyK1UK1hAcsgdnEa7sebV4GppICqhzOD6kaBBXL5K4lBNdBX4qw+oyQ?=
 =?us-ascii?Q?mby0RAO7YK5uE85zVJ++AboMnH8ptCMtgj2dKqnrNzTCJvZQKlcDcH637iuE?=
 =?us-ascii?Q?R6FNG9gWN/e5p/OZ4vWjzf7Ai383m6KNZEe0gzM7Tte/bW3nOUThLtqbHPEq?=
 =?us-ascii?Q?85aRmqjY+cX2EQhddyLD4pr1sQHTummQ8xTAd6zHzbYRnTvAK7nkox/mVrnq?=
 =?us-ascii?Q?4aCkTUcRfwUGTxdwtsMQumBA2krG7qXmgxO3yBtmgmSHmHLTbY5jLuYoz9rm?=
 =?us-ascii?Q?CSaPiD4+QbvNEMagrCWsLcREQq8MGCUIJ5LKMASIpDgZHB8Ek4j0/gE54F2u?=
 =?us-ascii?Q?yeEusPqMTJFlhVzp2pkGAZ/SYkgyqja8B0elxai2x/Go4wxz/0twGQBbuvSr?=
 =?us-ascii?Q?lqESl3+h0oOeYW9vLmSHYtK4xBTV3c7D3qTFKa4/cgC5chExvmuxIYZODKC/?=
 =?us-ascii?Q?vYkcEcECV1MCd3TXBjhis1NCymuH8ir05R5vkfn4QTgBKIC4IQ4OY/HoTz3p?=
 =?us-ascii?Q?PJcsi7JlWHLKng6PwoFc8MLNOh32VVu2mxYeiHi7DgpyFgCZ5GMSu4+NOSXP?=
 =?us-ascii?Q?FUbBZiBBPK3SEE6BBIuzezk/PBe6OghsJstFacL+aZRNCVP31fepYjSnCr0R?=
 =?us-ascii?Q?hh2uWxM1UmjeSSz54+Xyf9IQgjC7CuO8pOSxYCa/6mGY+Y2Shws0LSW6Hajf?=
 =?us-ascii?Q?Y68rZVt/3wFkXbMbaHacDQuWAwK0cVtUa6Imp+sEMI90vbJ5Z4Wn+RpSPvC0?=
 =?us-ascii?Q?O9oq2cSa7lN7cY2oHwGWr+6IMl20L4GUpiDXf0rI+6fJVvjOeCXwObx986rL?=
 =?us-ascii?Q?82DBcfQmku395sjQKcsRY3A3NxxnbkpvrXDqjPYBZb02w6X6r9SVi6QIwj0w?=
 =?us-ascii?Q?PG/uRfii+8S7zfzbmRBTN0TRyDuK1z/q0qzu3tYLBpsjEOP71MGcNaJOkisd?=
 =?us-ascii?Q?ZkCNoJVppAVVEOEVyfiJ8dNCeYAc/7KJ2tFAUQ15kV4cV/AtBXdzftS7hJZV?=
 =?us-ascii?Q?/BYQigZ9177jCgE1ZAH8N9I08LPgbsLFv/JuCzQAAGmrgNCLMrf5/yUdtFPn?=
 =?us-ascii?Q?Pma6P5G68DqpXjvOMMwaCI4ZYoPU3ldkzF/Y4V+OU8HDkXnAZwTd+rI2wIat?=
 =?us-ascii?Q?ODAQBG/6yYcbXTo2vq/y+VmTRuIZb2KQTqNbQ14ipM0MxZKRMvTkDyIsPqeJ?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9b2c31-4c07-4ce6-0d5b-08dac35f4de2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:32.3565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzTwp/tCX6HnHOcBIUgdKafnl1A1sIzVJA0PTQAwb2SlO/YlOpos126y774b05zQiZe/PBgaVlbMQr7mKKB5xBE8vG3obvsrSxt0mS2pZX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: 8I4MYdD3UM_Ori1AoJZDGevdLATbf8Uc
X-Proofpoint-GUID: 8I4MYdD3UM_Ori1AoJZDGevdLATbf8Uc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

This patch also applies the necassary updates to print the new
attri/d name fields.

Source kernel commit: 7b3bde6f488372494236cb96da308b192bbe72c9

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c       | 12 +++++++++++-
 libxfs/xfs_attr.h       |  4 ++--
 libxfs/xfs_da_btree.h   |  2 ++
 libxfs/xfs_log_format.h |  6 ++++--
 logprint/log_redo.c     | 27 ++++++++++++++++++++++-----
 5 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2103a06b9ee3..2f6192861923 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -421,6 +421,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -920,9 +926,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index b351b9dc6561..62f40e6353c2 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -909,6 +910,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -926,7 +928,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 1974382d2da3..65d365d8f02f 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -705,9 +705,9 @@ xlog_print_trans_attri(
 	memmove((char*)src_f, *ptr, src_len);
 	*ptr += src_len;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
-				(unsigned long long)src_f->alfi_id);
+	printf(_("ATTRI:  #regs: %d	name_len: %d, nname_len: %d value_len: %d  id: 0x%llx\n"),
+		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_nname_len,
+		src_f->alfi_value_len, (unsigned long long)src_f->alfi_id);
 
 	if (src_f->alfi_name_len > 0) {
 		printf(_("\n"));
@@ -719,6 +719,16 @@ xlog_print_trans_attri(
 			goto error;
 	}
 
+	if (src_f->alfi_nname_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		if (error)
+			goto error;
+	}
+
 	if (src_f->alfi_value_len > 0) {
 		printf(_("\n"));
 		(*i)++;
@@ -788,8 +798,8 @@ xlog_recover_print_attri(
 	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
 		goto out;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
+	printf(_("ATTRI:  #regs: %d	name_len: %d, nname_len:%d, value_len: %d  id: 0x%llx\n"),
+		f->alfi_size, f->alfi_name_len, f->alfi_nname_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
 
 	if (f->alfi_name_len > 0) {
 		region++;
@@ -798,6 +808,13 @@ xlog_recover_print_attri(
 			       f->alfi_name_len);
 	}
 
+	if (f->alfi_nname_len > 0) {
+		region++;
+		printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr,
+			       f->alfi_nname_len);
+	}
+
 	if (f->alfi_value_len > 0) {
 		int len = f->alfi_value_len;
 
-- 
2.25.1

