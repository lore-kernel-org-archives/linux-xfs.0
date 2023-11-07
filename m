Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B870CC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjKGHHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjKGHHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:07:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455EEFC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:07:38 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NoLa031653
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=Ud9rOBOyVZiNwlO+3c+yXzXarz0C350WA136+GBmmNk=;
 b=S14jmOs3UNY4owVaJg7ygwSYz2i+rWJtyRJZB/fspU4J02Sl3/AYm+uvO5ReFu1XmPM+
 5uvCzqV0vK3xnMjXCh5bJG4r2GsXEuIArf7uA1LMOaHe9uv/95SMXHSTklIdRApKyERl
 EopV60EA9VzIkfdvxcLs8B/u07XM/ITT2pAg/I9ZWdgb7jCh0ce1+Jfz0vots7IsTyv+
 JAadCNHifc2pIb4txclO0bjlnn9UhlscK6KpHBcb4Lr/iuYFq8lmrcMtxPcL0NUzB5KJ
 +kG6+xybVy5Cn5dRcNcCgyCjpCpo0WuIWN3jtMggyVXY3kWQ1qy0b2M3vIna1bLFMDq4 Og== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cx159ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A75td7n020719
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdd1v3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4JoWwAAcO/PCXjTZZ6U1Vv6DDjWZTZ6uCuzhpC2MplHWc1iMW1XbeWSbBN89vI1PjTjB+LAdvbzx+lHeKlj4rTp45U+qS48FFiaZoIqpmg/UvLEdfZ++GXbB56lrOaaw0ZYf8vqhEFKtqUKLLaouLdjPyoshqaukEzOf+YL8gXJJNnMpp8nbJ1SVA/omcxER12kQ5RPS3KN5HlQWyAw9HBBK4O4cXQ4uToJuD86eqN8d8Tct4jjpMbhHblObRPlvE+uaHci78Ly8EsIMNlpAYD8duvXCXMlY1SX4LVazKvnTeyajS6LsNn21dYm9MfFz1DQoM5LjO2CaMSnoSwwcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ud9rOBOyVZiNwlO+3c+yXzXarz0C350WA136+GBmmNk=;
 b=EHIDZp8pRkO+5zdpjjz0Cugf7Hj1tPBwGQp7AxelgQOOAA+/BLUKXZP91bpbpDty49MBHcFh2bVIDEWHJ4R0RESLjxluNEQ+ZBacABgr/XbkLAxuL+/yTcFUCNtL0DYW/r4ulLi+xDJCN7eQKLEl3z0D51xCJ0laXwxdDi2sqYwdpdVqv6ONhwrqkZTRb9PJBIMAN3BUZHa2Q4JOc/Arl9TGX0BPtLices4jZ1XlsOEZ0wC4NGhHlRficQ2SjwYcIPv8XPMxRuugOLzVSnzhOwrH05IQF+K/81EmFE63ayd9XyX6fRQuvGWC/FIqP4Crp8Maugy2V/XMg97u6Zbw3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ud9rOBOyVZiNwlO+3c+yXzXarz0C350WA136+GBmmNk=;
 b=EkpnuXiVgTkrhAXmegRUMCpbeTCdFFd4EtDGMSIb5ZOH9zzoP2X5bLo+Um+CCdAfxA82QGaI995H1pigK6zkKAUdXlfvAxGQSHkuN13fkJQwdTXa3ljVpbRWy8UvxCnfqBXN9+zXLzY/JP7Jp8miJ6OeC4d8Sd4HyVEMl+y2Tzk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:07:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:07:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 01/21] metadump: Use boolean values true/false instead of 1/0
Date:   Tue,  7 Nov 2023 12:37:02 +0530
Message-Id: <20231107070722.748636-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0096.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 80d8f252-093b-41ec-54dd-08dbdf603789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 74kfE7to5wrfkFCtoi3QOZ+hIIF++95J+QZLr2/MR+XcWOZDh0pXQ5xeMLPRVVZOXNVSVpmx0Gl8e5zsnGNTxf7SlRArGS59g8xGPe4XMiQmp904sXegMnyDm07Gf0enrDXJBSpz6NuMyPrBrhuP6fH/Tq1k06XSru8Yc5slVQWikI4UxnWemVFUq7WndGAPxv75OWV3ZYKZ0UXJG5T5QToB6WO4ZpRbEHb3o3EwSt2iYa6Ijoa9W9g6U8qRC4OjyURAbQ+AMQyHZI0QyONaTVpYt0eReGrqURnZF39WGBeEpCf8osTbXWDMz3nhfihW+nfrMU7zUVm9748yGo3FNcvRAprR56B7NdTdd4cAH9Q2+EzWbqNZe1insBlh41ULB4Of4hQnY9Ej3Y3Ku6XPR+ERmWrx7KUs7FZAq6O6++6BAXR6OA6wfeBAKXVRrSLohh402I6o4sVFdtLrbXYBS0E4DIC4NdPvjLL4RJ/f4WgeiRZyr87MfoA7FfUpDUFuZDTgoZrShgcyQTXyi1EMljzRMjprT/s/eHSWy594JMfillccCl+wj7pfQAFYmBpe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(6486002)(6506007)(6666004)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dTkeFQIzZjpmc8CpSG/L9Oa6DzM+NlgL5TEEHUqWf7LfJaWZwB2p6Cr7Buhy?=
 =?us-ascii?Q?TRUAGLSkSygj+i/zqpWAoMK8UEJL4AeLgcs4dc0KtbIARdHsTaaG/i488k4D?=
 =?us-ascii?Q?4NvVmcD7uUShfqF+WyJnhwYURNz3F3LK9BomkcSTxoVQZVmT0uu3jy5VtL7r?=
 =?us-ascii?Q?8h4djckI3ARnC5FAPrWVMQS4fP5ks0iyNg4fi3t/afybiiR5XK6UVl7yXHZF?=
 =?us-ascii?Q?5DfsHaDQIpsuHguBwftwg0N/1sSNv5OihvDP5gJgwybW1myd4W68Z3DQB9Ef?=
 =?us-ascii?Q?xVP649/HQn1uNpFjfAHRyUaOFTccpHjrKbzcsAwPLxubXEiVOuYifFX8JChb?=
 =?us-ascii?Q?iNlxmosfOK3AHYPr7QTzURCtXTcSlDnPfn1xcRULLEepadFuP2p+D3Tdj6lv?=
 =?us-ascii?Q?6O6EEjQG0MgsCVHb77Svab75GeKzyzUYmNCPeCpWV8dSzn3xR0oSeiHOqdqP?=
 =?us-ascii?Q?CjlltYyfm/za4u0/sYJOoABde43Gn023SrylLhZRJV+RzSWCxvUsDA0G0N0D?=
 =?us-ascii?Q?PhMKmM8EP1iJ5I7se+U0d4AuKAjwuWtwqlzKyHz6u1i6gf7Jo2ga5QSDfLSp?=
 =?us-ascii?Q?hIEXvjK4UgE+5W+or4g+RLEOLiMxtp8viZIxjxdFJXmHXdJqvLiqFmjcDNY7?=
 =?us-ascii?Q?7ObdhzKs0t0cpAG76BliOcXdcfR6gywC13qtcV2wmJrFFyWQceH2BivTXWUS?=
 =?us-ascii?Q?soFXDRZLGldh0WKgmqNt2scrTGHEgkQC2bL39QjKgZsX1/zVjhttTJTylxTp?=
 =?us-ascii?Q?jcZ6T7/q53zj+mQ0grDeM2Y/L8DzGyF9qPlSRzZYKG9ND4DGtCRtET/v3dlG?=
 =?us-ascii?Q?LbZC2AEPBMI+U9vLhtqHDLxeRbWgG8zzAWhUHJ0/2U8BW1IcV505Rq2h3OsL?=
 =?us-ascii?Q?CuxHnxN7XqOQR+t7kjf00ACmRh13X/MFE2D5Dhbb7G7W5ePUQ4IdoEX5+l/x?=
 =?us-ascii?Q?yfVUM/Dy6JIa0jyxnrVwfaWunwb4upZPPH+Uqnj6DeI63CVjKq1tF8wJmKJi?=
 =?us-ascii?Q?XJNWTFIFKptEF9Sn3o3gkP6iHclk8YSiu15p/7QmNCfioZg5RKN0b/JYkV6j?=
 =?us-ascii?Q?LYISl/P4VRHbvZh95Q8+YOmSwK5lKxaiqHHIUAXlU0chAg9r5vS25tg73gvS?=
 =?us-ascii?Q?dj/vLkX625/G5wyBBWIxW87q3Z+wATSRegCNcyc9Q6XPqBaaGK69sMJaheDx?=
 =?us-ascii?Q?M+Bp9CU+C65Hxti8hWlDK0b/7qDcsr0FrYYxiEdMzLBWOJ+jWvWdDQLkHqJ+?=
 =?us-ascii?Q?3/NRKsN2RpRM8TVj9d51CKwD4Maj883AotCvqa+JemXSRQk3WkGcfnhoXyV4?=
 =?us-ascii?Q?Xq1kxdnpbgZt1xzBo8D+V1gLjmcVb6bHUhrjSrvoZg4Zaz/aLM95q45dQ7b0?=
 =?us-ascii?Q?j2OCcyIwfIBfFgke3+BMgYDdiiuHEZB/Q8amYoQ3CitcFSQPwt9SgAmmVPqW?=
 =?us-ascii?Q?pHF5rz7qjuFlUBaQ32qpKtLbEGthzQppfO32wu3AVPbMrquLVhDeK/ANqHkG?=
 =?us-ascii?Q?5v2bBXas4hQVrAKPEPjJJ3gWU5owwC8LPs8M8pK2ZJ0PjLw3F/w3diEGOl9A?=
 =?us-ascii?Q?+CaQZMKrmAzpmBxMBqvb//YKuLylZLNqJoFi5m3QJukkvdaWoYWwalwsOx+4?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IcpTPhdI0GMSuMZ/g3JZ5y3R89nEDDufNdndbffAhRrlJiqwkulD1pvGxnxmpIUqRdZbgY/QxL+RcuVcdkSOLxXys3U+3ZKPOOQKKNHPA1FWBVIWRufiRpYK+/1OmtGSwphpw26C5ln2hXaFeERwcf3cfDktlRHtxwLAjC98cMCO8O4e5knX4ztaa2+fi/s+dqDPKZZmhj2rJhQrSpeH066f7IO9xHCNWh5RpV4vaP4i3EJJRwmmgsrFitzYvDz375SHtsGzv+ttODzy0oE2rGBdQ8oHCQkdZrj2qGTtcz7jwBBaeOyWuXKQQn6pr/OfdbPhxv+zSaHX9eOloEm5QoaPzI3ygvoCSswhZTb5m08yzw8DDYusV7xep4L+13tTrA1NZExelfNHyx45saZHbau8gaqdaYXSxmv7hXkWmb8xXUpYBN83FWzjsxbii3GXqTOlzsCXvuMgq9qlYdCW91LPIlCzRNxHNzwSLhOlLKJ3YDP1U3bThd/tsqmF9LB78rN/AVjtJ81jE7oAoxzCI2uGYLLC074FjrQtsurPp+f6oAb02fd84GhCBUzK1C8S0sIwwTCvEDeXX9j9+YIKYPmne4GdXFXXr+XlNUM1Djej4bNmOllPXdoNVfG9wwtID1k2fhwntmiA1IpUoLTjkmA69J0vpgcHFy13qD9gC3YHBpnz7UrIl3tQnqQBn04xtG5Ehvz+X7JdgHHWPkJPmQXrVlKENxWlIuGLyLELhWb3F7dYjcZRS0wLdaYLSTwUr0Crse2OMJboNt7aiZjmHg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80d8f252-093b-41ec-54dd-08dbdf603789
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:07:34.6606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBBFMPCACfXhLxWQR98j3wuAe6Hlg1zkVGVURPsAOnoOIcDiemJEAh2BkBA0XErqX9OzPxov0oyuMI58PUR+YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070057
X-Proofpoint-GUID: evpsNTyzJdpU2pmde5mIStz38EuSeHkb
X-Proofpoint-ORIG-GUID: evpsNTyzJdpU2pmde5mIStz38EuSeHkb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 3545124f..dab14e59 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2101,12 +2101,12 @@ process_inode(
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
@@ -2116,7 +2116,7 @@ process_inode(
 		case S_IFBLK:
 		case S_IFSOCK:
 			process_dev_inode(dip);
-			need_new_crc = 1;
+			need_new_crc = true;
 			break;
 		default:
 			break;
@@ -2130,7 +2130,7 @@ process_inode(
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
-				need_new_crc = 1;
+				need_new_crc = true;
 				if (obfuscate || zero_stale_data)
 					process_sf_attr(dip);
 				break;
@@ -2149,7 +2149,7 @@ process_inode(
 done:
 	/* Heavy handed but low cost; just do it as a catch-all. */
 	if (zero_stale_data)
-		need_new_crc = 1;
+		need_new_crc = true;
 
 	if (crc_was_ok && need_new_crc)
 		libxfs_dinode_calc_crc(mp, dip);
-- 
2.39.1

