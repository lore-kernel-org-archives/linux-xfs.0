Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2B5C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiERAMm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiERAMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED24992C
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:40 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKcwes031717
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=A9lItAokeprONJDF4NbviTVay4G3IVc9IYH3ljFIs5k=;
 b=mm8+PGKbWWQtGbfT+QPKYwi3XiyZo9DP6hl/AbkXHgdnIXnhjrdWQnRdHZSF581kHyC7
 GjqD9D4G30/1V3Y+2RXYR0b4b4iysjkAS4FdyLPLSxnRLDbzZlB3AR79ejBR9mH0HnnY
 bGeHjhfcRihyzPdnbLUQV8UGgWFqs6QweYky9jAQV1jx01IKWPjUEHkwSO/l8guA77yv
 c4FzUUeTIU4XYxGNt6QKNfkJGdDy7qQM6ZCqadbIURlbU/atkaEWqXpsT8xR6GrrZtOV
 XvpLbLsrcr5Zwa53x1mw6SXjMpabZwRDUCdIovyVl3eKCdavu64OnYIbCQbstIJzsioX wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aafpts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1O6021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBPdmwRQ7SIs+NonoxwHUhrh/1nO+QYfSjSVH622tqCLe9PxHZkUAxyfXOlDfcQIIBObh24wZZBN+mqOS2Hm9j/Feww4dQymXGdAsmJiH3NhVFn2xXUVoyUmUIy4RixFSl9w39RjB+KI/bPrzxV4wxqb6btnPoKTuVl4+Ntvd+j6IjxoFSfHXMiKui2svUZvMEmF4z6kmhO0KtwMt/pQSEHv/p6zftkcQv7ORhBuvxrO4f7OUjKJuWYYOWCawvZE/UDriNPbHrnNi9E6d8lG3NG9lZAJfGh7MaJzPsRNFDWiYr7XZufK6bBOxtvkL4cYbxUOP+5Wb6pFsgxdhdw8Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9lItAokeprONJDF4NbviTVay4G3IVc9IYH3ljFIs5k=;
 b=L/uHFtcUiULRLChYmZ53SEWNU/nAMoRFq6uYjXeANOxWfKKyHVOgiNNMDbFdUDYh03WVf2fV6APyaR3YmA8GGtSU6EUuq1TKXSauxM03nGK9w5XzWGT8THZ7QuPZlarz/GSU/JgAfKLyx4jl3rJ/AcEKuUjojd8j75eV9QTn3Hiaw995ZZxjEq+PkfiSIHJx8OL539cgVvu9BioSgkV+MAGABJQASjACEaZyTirq8Kb6Waw5JXvAeYLGklT7tY8k9AyzWT8rpDzNROTzvqzEQ2BtC25Ayd3zTYUnS+1WF/E3ucnAgREWB+0OJ6DtXXtOP/UV6DqMQTGUkjnhL0arEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9lItAokeprONJDF4NbviTVay4G3IVc9IYH3ljFIs5k=;
 b=NWPD9rDBMVvXq/qIpszLRc5cS5VEoMGYIcrNB9iZ8TUTY+V8sQ9IYUhG1l90YpVDctnwbXoEvzauEXbbpt19Wj0iCDrST/5L6ODZVdZAObqIzeGqWOKtTmH3X7toHs8NlD3aM7m14W5Qc0UKAWiEYH2kgoKsiMJNtT9DO9fXEcQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/18] xfsprogs: zero inode fork buffer at allocation
Date:   Tue, 17 May 2022 17:12:10 -0700
Message-Id: <20220518001227.1779324-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e52ed3a-c9c6-4536-cd02-08da38631b7f
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB152843B7F411D77D91CD244295D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxY3yydda5nPh4q5aOAmQk21fZiYvFAgaQ80HET2j5zCWk4t+vpfqrmSCWj4P3cMnZh22BSEPJGTs+DuCwVC7ENhTVj6AytFcZLKms2uAowwIdDLi7tdZ7gnK6R2Doq6g3HVFWF/7iwfJB4wuclQ1I/y4SotgQaLO8OaJW0vGw6QgkeQmPjaTg6FttMnEqiEGfwsr8rwLq+1NEvBB3nGsncatOJNGq1lzNTQ8NTzVLI553E70+5VK+Gumcybl6ATXtiaXkW9w7GyGhToom0TDe0WKyQoX+1umbgCDEfJsj15F3hnurywRXG3+Wz1NCZph6dP4f9BInjmCls+CjhCZeeW2g6p7ZctLHcrGM8DeE05l5L7QVaD1oNMhci2h2CznojfulBNWiFKASEyxUmQWD1qO/X3GjLxC2RqTpsqPg7RYXxH0pw3lbbkHJZV/7RKZbsMCY+YuqAfG2LZrfVKiIp7YfX2kqOYF1V1/fIssoRG1uoyNDkL8eQvzR7CXFbnDa6/uORAqwFIDzPWBISqBLMU3Jf9rkYSkZe+BSXD/TQBE32qTRWEIdL20XgFUUaJpNpcPiWgCPc7JMMpljxqJxiyJBsx8W7YtLuLdKVuA9VJuAcP6tXCG2bwELVIBJeoyjOEuMNrRYgV0qDuMWj6vJNJme13EmFONphlG/WIPm77HMZcikA5/VX2INuxqlBM7I1GCITsws4ik4R5oWYlUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wyVRGaYA4S1qQK7GIziZGiqSnyhPniws5Rr/acSFM+m+r8XEQRLCPypNTTS8?=
 =?us-ascii?Q?RjlNes4bVCMWRK2ailBAPR4+3JCOqL8oHjdQNaB9H0jLO8GI2eskBSFH+w07?=
 =?us-ascii?Q?ud3S/viuTnaQIzIYcO7Gf2etX9a97hK3v6+qez1c63g+5S6L525sU2V1tLWH?=
 =?us-ascii?Q?mumqmkD5WANWEa60HPegM2XzHxOg0NLihqunv4daVgP2xGF/X7DPzKDQv1Ry?=
 =?us-ascii?Q?+/9Wq8ZD+Qrt8Rn7x68SA55jN3eP2DnwhkPFGF7tkq9y76oZx/HiV6elQAzc?=
 =?us-ascii?Q?33nmD0iyzHusd7W8c3lv0iqSVQOw4Y3ZsWV7sXFSsHLI3y+JmHdxkUgx6bwG?=
 =?us-ascii?Q?rKaq2ch2StdDGI+00bgc8aMirRguAII28mQIvNLdXTwHw/nefpULwbTF/TL3?=
 =?us-ascii?Q?ZJpejl5+RRU+YF8jVNKYxeBGag4Y9Tw2P/g8cDDNJWmV1SL+E+dCsKAxNBEf?=
 =?us-ascii?Q?0MzXZb4QiZwRXjwjqkqw1C3hxYEmV5m9gyvnFoADDG1GR3xgiGkITyuFLhgy?=
 =?us-ascii?Q?hqUrpJGolW3mxrgiYvHq69vj2mEUmzGsH7m+LtgCgpDgzCVbNS5HXu9LUV2+?=
 =?us-ascii?Q?/I7TMpEKRIw+G165b8/NbcQMrfcQ7H5l9NEVqkUUl2Fp2FI8fARLKxFkMSFd?=
 =?us-ascii?Q?T/jqZ1EcrPMn5ubFgSU1BD5TcOtUpdvrm1UaxsJ9kHRQcO1St+6NUYG+hEcn?=
 =?us-ascii?Q?B6Qy+3Y139PqkVAefbxiAmOYFdgYeUM7NAqdVSvjZj4/ngCuTIdo/vgVKekX?=
 =?us-ascii?Q?pe71XWLyv1/5vxZqY23rxlLU1mEJjFIMTEHVDfA07/6NtNZ8ruM31TkZx5C0?=
 =?us-ascii?Q?CxM1LjQbkQgHWRHrYVFmPMSoosuuQ0Utem942UFfRzTt3b/a7OUVWkQeSUfC?=
 =?us-ascii?Q?feGFYT08Yac9jDAH5GKYCJfgeeCNEIvll0IkNWXSYvKFLglVWD6KOvKxn4sA?=
 =?us-ascii?Q?1mVu9VPYHsYy0l83H6wXCs4COIVAG5DUvpSo5GCoOyGFUlO0wHx4p2n52YUW?=
 =?us-ascii?Q?WE9bx3KCQMbFFD1xiSc7W5DGtC5S5V4JIA2rgQBmb+JbHH2B7EwT1ZF30lf8?=
 =?us-ascii?Q?5Ts+RepceNeq3dDmnRcpaZGPgIsStsBh4IKtseMQ0fZTZVK46noglj4idPB3?=
 =?us-ascii?Q?s52DSZseB5UCanf3ebixmRYrUaYOtbEO0eIrDuwLB0bVk1vlZ4kcf0goAoqv?=
 =?us-ascii?Q?TtNtlOAz/JY/W4/uGLC0/WTg4e8s4jXm6GS/UwfMUqxdTGIPL7WL9ntq+ejb?=
 =?us-ascii?Q?oTbmgEXEANT6a6UHDxe6/uXscrTVlJDVwamfCkjeYnuzWeOblOCUpD1yCJ3v?=
 =?us-ascii?Q?8L4GzaU5WjnL99iKkVmKFgUYt+NYitBRJXb9s7FTHEmaQMDxXomSaLLtx26k?=
 =?us-ascii?Q?pGU2WQNjY2OSnrTacFltkYF3+xOoCVHuzHrHx7AlHHq4h4b6FzSXYGTf1rYR?=
 =?us-ascii?Q?RlyNqpnyZ3jGUbvrLqakzLAAGnWnXGnCuFiDGNmSfdiWTpQJnvZHz4zi+GgJ?=
 =?us-ascii?Q?pt4uaJSedbWcjaj5OO1mlgKIT6kQaENzIgxq2Aml12iY99tnZ4CdRUWEU+Hs?=
 =?us-ascii?Q?dXAirTQObgU5dXNYwEctVBItCwcl7yh88pHBFmNlahdpjm0KgRIAIvkwpF5D?=
 =?us-ascii?Q?uOg7r4EpyQdkirNlA/lL4s64q3l1ZK0IXDRu6kNs+KF430lXe9A2tRCyGfuB?=
 =?us-ascii?Q?DiRen18bA5bwjb4dfBoO5J15DwnuN0IM3YC+jX7b/vF/unPwxlDWY6uvSFoa?=
 =?us-ascii?Q?7k1vhMIvt1hi9b4blnrNEiN1SLNyugQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e52ed3a-c9c6-4536-cd02-08da38631b7f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:34.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aRI0YctbKZEWtWKPo44qNhmf01pRD8+Mz6qqNR8oRoUOpGORbsyB4RrhNjQMP2bzNazbj96fzP8SGzgFtU/yZU1wxvR+azCbx5iumTov4Tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-ORIG-GUID: luRzPFj_aU2rTKV7bGhi0nFzB6pgx72w
X-Proofpoint-GUID: luRzPFj_aU2rTKV7bGhi0nFzB6pgx72w
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: cb512c921639613ce03f87e62c5e93ed9fe8c84d

When we first allocate or resize an inline inode fork, we round up
the allocation to 4 byte alingment to make journal alignment
constraints. We don't clear the unused bytes, so we can copy up to
three uninitialised bytes into the journal. Zero those bytes so we
only ever copy zeros into the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d6ac13eea764..a2af6d71948e 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -48,8 +48,13 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
+		/*
+		 * As we round up the allocation here, we need to ensure the
+		 * bytes we don't copy data into are zeroed because the log
+		 * vectors still copy them into the journal.
+		 */
 		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -498,10 +503,11 @@ xfs_idata_realloc(
 	/*
 	 * For inline data, the underlying buffer must be a multiple of 4 bytes
 	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here.
+	 * We enforce that here, and use __GFP_ZERO to ensure that size
+	 * extensions always zero the unused roundup area.
 	 */
 	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL);
+				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.25.1

