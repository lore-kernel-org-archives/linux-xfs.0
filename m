Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F48AEB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjGXEge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjGXEgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:36:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F501A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:36:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMWMor014874;
        Mon, 24 Jul 2023 04:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=KtHETe8WwNkODnPOzBR0jxQqULzrv1kP8B+eDQyw965a0CfwzBnd4M+gVFiVwON0ak3B
 DY6W5bAL90eBMrcS5Xvi9GHKYcPxriymhgpVsiAbJRkot6c8OxeF9edpICjOBZxJeYXK
 NhWV0s20DYztQE6Oo/Wmruh8IJ3YtMJyhI3eUam4iaUZTblvmZmtfhb9cudgv8SPuV/H
 D00CysoRRqm9dFCTTNe8c/m4rPMfqDMiQqEnTcBn0Bq0Lfc/GSr9VU8AP5TnT5UwZ4eG
 1fAacd5E6ullJrsJPKHy2Pp/bsXwHrUEPgp+ENna8xjq63yi6wDsCm4LuuNBHdYAB5bY oA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3huuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1PPTI035600;
        Mon, 24 Jul 2023 04:36:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2x77m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUPRLJ8y62TjNjx3c0URQ5JcV7MV5+savth6Hd/M22otvRgRdapG/hJvoGPV53eERpIk39Q/yeEH8TZn3bSsbZbBFjHB7N3GiSpBTL86eRA41Cf/t5vdvJE1WyLgOhX+sIb/0N+d6VENJpXtmhFbbVh+YxPfJQ6slhAwWzRGGdJ3VPAv5DsPF7XVEm8VRgB+EV6Ul5xr7gXtsWB3Zkx3ckP19HheT3CTtiWMRTVwSx7hrJ+Agsz4Q/ntj177Bq52g005GA5Mm7g0bKkZqj6SalnYUZegZ2t9ZK3rVAQOSWloexgDeX6TuEQibNqERHcNsmkwvtFQAYAPJ7yhDVpcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=m09YwLYsOg/C5AlKML9EAjNpmo9nf3wH4kcpFw07OQsBrfRx1XTWA4GxKnf3Jpvq2jb2i1vpHfp8s1RRC/viEeCQM+5bFIzDZlkHnEjuF3AokdadxO0PhflJmsulAuOtkux1FTWnT4+ncf7Dy94q54z4ATfvxQazrQFW0yGbiktmgdWc6e1B9VzaZs+Y5q3eWVdeYE62Gy9TfDsIfTaQ9fky/sD+MJyiWI+3uwbrAyzXP6IQQFmbFjOKggkiqdSrLQwWaoYUSEOeW8k6FfMmQSZyVw7HQd+hd2EmnL+A6MIoAphTDVbbV35Sx3Aln7euAudPoJ2esSBCbcnnZhMoYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=n20fwRFQJz+b7kzkQXPLyaVL3hY9MCpbFd1ZSDNJnuy0Qvg2ujC43+GrMZaCKUOEMV5EmO/g6nCTUUvXf1QOBvLtrOdQBLVCbYNQDO4a4q5dKeYu97GQqNZZZgi1UMJUMySy6GpkXD3cAGCqD6sZ48V6msqP9FpJITJCVRrpGg0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:36:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:36:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 01/23] metadump: Use boolean values true/false instead of 1/0
Date:   Mon, 24 Jul 2023 10:05:05 +0530
Message-Id: <20230724043527.238600-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0076.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: c824d5d6-00bd-407d-70cb-08db8bff88b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Njfn6nuR7VaWnPwOYE1Oz3NC9DwUiY0iYOhAkI2n6gKvun85MrIKK6iADlsYvcecLjywfCpYh/JVmZkpMsfRCpo7lrh+yjCPtQqZYKx+xxtEEomPyhoVjp3DkbbiE1mgIPewXyvVuoJXduHaTZhjr2TOtkZV4gzeMjvi7yUL4azYChhyJFwJZQPs4TaMGxJTDs2SDfEt7Gp+wA4/tZQME/5Y00aHFrAoXFk/dCwS1jJ+3uOx6QMHsz5NA/dNJ2cKaaR2XlPbLqRNrOK7WWc5DkyAoPMMhdOnNh4+usyOxGoMi+vu8Z8/FH2NarHhp5FnKrQrjHsI8Ol0EcTWJ57Ku75I0Iq9DQm0PjCNIkA5t1GAszSpwy+623cCR54H73WbneSj0InKB2it3KW/oX8sn6dXuR8lHoUHt9Nq1jRvkQQ8fyimCA0VRIKN46YlWJMbb8nDpk5Pvh9d4kDzoD0xcjvX4/qmZIB9Sdv8BHPxHFxkJZKzrjHI2/D+RhItxTl1Kv9mClGPpuS8iEKowZmOL9Oiv8EQIN9jSgojFj31RtBld43ah8qP2SNHrennh6ba
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bb7y101h6f6sEih7FuWmfhKaBsqF9fEEF5x0vKHlRDBFa2rj0gYwoobodyAj?=
 =?us-ascii?Q?5eM5nXRL90Xd7XahuaarbUFDI0aK75fiE902bxFgxauwq2CoTeLV+aIyen3C?=
 =?us-ascii?Q?YZVreLsUoXqEqO2BQkxCz7luVJgBuUIbc9Ecj/k+prYNQFflHt0pdMkbnWMP?=
 =?us-ascii?Q?N2knZSwvTS/b+ZSK6ZlUQ9y+Y41ZXOE/N6O3ZBSa5C9yHnDchM0DsbyHFsX2?=
 =?us-ascii?Q?N2FNoIVrqr+ZPWZ6iPfYpnVkGkLfcCMiJUk+as1DxPuctedNteSghaeN78Aw?=
 =?us-ascii?Q?eP4MfAmLApfwvbiOASGUww5St2C0KVmPlJOWK4VSjhU1rQLHD/A9UNvYRriA?=
 =?us-ascii?Q?9x7QgGBBy/NgUA6QT4NUbG0gJzchxwMltO+N01UuJZdYWmjk2WuvZ3Whlrhq?=
 =?us-ascii?Q?lWeP8SkRE+l8cbrpGzhgP7XZAirbCmqJjiFj8uK9NBK7aMBv9QmGv9gAZ4Y1?=
 =?us-ascii?Q?Rcfc9PEQ2VgREFwSf0bl+l6qMu7xtGVUGbAAk3wfrnU8b8i/3S8bjzAUD/Yf?=
 =?us-ascii?Q?8JtN9poJ5gx4oeOePuG+DFjmHqpTfvO+xtZ6haNBW6ZI1CK3j76SjlewR+ib?=
 =?us-ascii?Q?PgB5R8qlyGAAzosrJ0SP/j/nW4SmaCJKU51go1VeD5iEZC5fAX3L53UIaAlY?=
 =?us-ascii?Q?M0jliPal9YNPT5OvFy63zMW8HyXLehEp7YSgt2zqIgpkE9/cuJlSdQQGF9xo?=
 =?us-ascii?Q?wnfv3oDTx13HAvd7cdfEHJ/qiWxI/1ReVSNvvN+3hx6yT9/iff7lP9Qgfrga?=
 =?us-ascii?Q?EGQeEKO//RLd5FcHWh9GFFiyQ0ZObPGK0SOg3uzoZAfs/z33vhhPo6qsQwfb?=
 =?us-ascii?Q?gU5PFM2U/fxom/iY13VxpsjGhaX0N3iVSkQyJOYdbyVMK0FNQZxbiRX9qx8I?=
 =?us-ascii?Q?nLoXDFfZG+sofcEtP9U6c/FpTGTZqjMaPuMpTMZgAIHIJuIExnvjSPywfMQ4?=
 =?us-ascii?Q?QIncMKinzGJRRhhQpUKmSJBc3WhZOphuySCpQ9EoxLwAzPdTExvKKd45Ne9E?=
 =?us-ascii?Q?i9MST9pr1D5bSonWPe5JhbysXnmx0fVUlpwoITJzl8iP6LQnwvG8sdrXxuOY?=
 =?us-ascii?Q?w/2Qq6GptAxGkaXftAWb+vYzcw2V7BU28OOA2ZE2T4xZ2axAID6imi3ZsncG?=
 =?us-ascii?Q?OIoJF79rY+9uGY0bzhxKE5ruJDmvcPO50QXyuo4A8tvMlsWfGmm4HI7FYjLR?=
 =?us-ascii?Q?XGcXRcBjEiHRdryp193hk00VPnXILIZ4DGrcdiNNcB9o+5sLYTC0JZNag+iG?=
 =?us-ascii?Q?67H+8BF2dUnyDrIaQ3f0kPjyF12BpYpuJ+559yDYG3pXW+mw68u7P0qAAPZZ?=
 =?us-ascii?Q?QOw1XVNNqdc9h9e+KJFEKaHHUq66pas5rWu5JqkjcoxPhROil2tgh3LRJ7FF?=
 =?us-ascii?Q?4sjVauu1IM2hOV34f+XdNvms6uAa1rDq3B15SXJcXqL4Qj+arW1Uh0qeHCLv?=
 =?us-ascii?Q?LO9fJtH4shzDipGJotRv6fEQisIBFUIqGjGpuxWj3fwXOkwz6li94pS/4jRX?=
 =?us-ascii?Q?tzqErkM4CbsCxq3ayMJn0JUWaNcl4k5CpdEGEaXNJ1bTBY0Ginst9R/GOL8O?=
 =?us-ascii?Q?uoZd38ESUroKFRPZak+sowEPN2gCgozkIH/3QX2u?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VpImXAHYN7s49WmhaA5cP/ml6HCdI07vRs+CoPucAhkacTICI8jpqtCGb3z+Wxf/MRiTNqLK0eMd/Ygk4A1obMvfBzDljbu+hZcJtSBxu35LMGqG3AEkAeKYQJgyK/Vre6aLhPiJLYY5RVZXos1iDNb/LCcJdJVeNclUQof0M5vTcBMaH2d6NmdJBk97grF9wCEh4TsmXMgLv7Yo/Myv3fOd/xlg9OgY4oSZJJxGTVFbrLPAkf3LuTxUtCxieIqJrcgmSQUYD14USjQyOI1WacB2VKbzUIPRMu+dNuiiMCAqvj415lfDhJl801HrZeKDf6TM4+VtjTSeAwsijEUQnf8KCjEVgqFyugUlzB6SYX4ffEjs4Z+YLWDrA5oT5OUA8k3uGBCYNT4asfTnx1+93s1Ubc4HwuP3aTsgyYMbg67dCwnqcfmErBTUQ12hkkp1NP8WnXdWO8IaaOXLWoSdqRYeEvFVgE+bex4v/mxuJ7dlCMQjuV56Z4IKZw2WjtjZFroGlqUKNyz0cJoF4GJpqhlwReEcJWgm55BLZ/tbf1uErJu3DkmYE/iMYHzCBS8roplLjvjkLA70bhVkmefO7VU49Zmd4ooGl7GEnGpXucKekbIIegxpifsOmptDe32w7EaJMw+aXFRxpYxlgETlFmP7cCp88L4OHBbfUH6VR6RpL7RY3kmham8RVDff2YjlQTCF1zIijc6Zpj8AfR5uTglZLZHKV2NXPcAtB9ZhWCj6xJB6Efdia/xrz84MPwPa7xF6nFIvlWCAOCgW1y9xkK1fo4gLpa3npZdB5Ceihgo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c824d5d6-00bd-407d-70cb-08db8bff88b7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:36:23.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAPCHZAH1FP7d4g6MuIK0bQXNV5GRV/zT89OPUAZ0ZghyllidSp4dm5d1rm7qYYkRi7QPiliD/CmyofGlVwFdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-GUID: 1VQA-h6hA_N5roZLGWy5WJEAeNYVYtzl
X-Proofpoint-ORIG-GUID: 1VQA-h6hA_N5roZLGWy5WJEAeNYVYtzl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 27d1df43..6bcfd5bb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2421,12 +2421,12 @@ process_inode(
 		case S_IFDIR:
 			rval = process_inode_data(dip, TYP_DIR2);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = 1;
+				need_new_crc = true;
 			break;
 		case S_IFLNK:
 			rval = process_inode_data(dip, TYP_SYMLINK);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = 1;
+				need_new_crc = true;
 			break;
 		case S_IFREG:
 			rval = process_inode_data(dip, TYP_DATA);
@@ -2436,7 +2436,7 @@ process_inode(
 		case S_IFBLK:
 		case S_IFSOCK:
 			process_dev_inode(dip);
-			need_new_crc = 1;
+			need_new_crc = true;
 			break;
 		default:
 			break;
@@ -2450,7 +2450,7 @@ process_inode(
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
-				need_new_crc = 1;
+				need_new_crc = true;
 				if (obfuscate || zero_stale_data)
 					process_sf_attr(dip);
 				break;
@@ -2469,7 +2469,7 @@ process_inode(
 done:
 	/* Heavy handed but low cost; just do it as a catch-all. */
 	if (zero_stale_data)
-		need_new_crc = 1;
+		need_new_crc = true;
 
 	if (crc_was_ok && need_new_crc)
 		libxfs_dinode_calc_crc(mp, dip);
-- 
2.39.1

