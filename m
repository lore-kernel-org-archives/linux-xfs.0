Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561DDC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbjKGHIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbjKGHId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68DCFC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72O5V9014505
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=zg+LiX2+A7AAxu2bDeLHcJSn0EW+5AHLZUHu4L356dI=;
 b=jg7a0BiNV+ofAC/KN9gqtdnH5dIiNG4CyN/llAD5OwPT9celVkpfQNEpu/jBwrV19pys
 LXi/QuSrwbFS3stpaWg17Syiw3xhlCu6r+Ty1InD77qI7vdp5aAwz05pC+uw+FI5aJus
 ghouVoP7S/GBL2iU3ZNY9SAsg1fhngb/IzkoYDqmj+y2d0wYWPQHFKdaCRZ34/X7IdLN
 hbQTh1ggwHkN4PCnY2P2GSynPZledEBn+2rB5ltKoZfvDTEclwvxafDdpnJDt0pnNPo5
 SMQCXLMT7GSwtUSIPrXw3EN9W8lyaGPp8zc0/E4xe+/GtIJbj21sa537xWPNDVjIOjVw Uw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub576y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76Fmiv023555
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63cag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T96AbIsswi5zRnK9V0NffH+Fsi9oU6rxD6KgvK+GMDcJWdujHOlMjJvzg6/8rPMPVmmmDV7xQ2+UeVTV5GHF6qadSqrvrINMl9Au1FnpB5ErRrjSJf2QYcccvNhZa2826OAAb7QOwR0RnK1RoisG7HZ9LaUzhnNz0+Hvu3PRSoUwtHlNzYefYb0za7TPHx6M6X4nP0oX1s7SO8fiMMvnPzst7Mtn0uhBYJlJbTwY2397vpaFlUqSAIIIt64Tcl0dZbKiW6222vjw4EGTBjNbO1imMLy8R+DzR0am8m8/T8ySbakzX65s5DBFxWqRE3o2XXfeerB7ipjE0VfV3UqYiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zg+LiX2+A7AAxu2bDeLHcJSn0EW+5AHLZUHu4L356dI=;
 b=h5hNUz5tlWoJqqWSIJoNxvMq8vJ/GtialWg241XM5z+dl0xRtBcrDwO0NmyvgAEvFaMrVDjO0/KmIuOBNQ3200oR4ZVgfr+w/dgTLUvNpnHai85IIZcNjGD6SjT/BseEpp6LCQGhXzF/7T3Pk5yF9KkaWCKaONALmS07AfVPCAlAUSwWxNIVtoYU3nPDHv9uz4SGg+SNb5xy98ks0UPpwGj/X2slr318yFNWsi5iRP9zFDqwpKWMvfIz5HbwaXNhbfXF3g+zeNYmGQRO/fi5K6IS0Z7ZFy5Xs4WntNHo9+ybevxWrtkYiqtNH4Di7WGD7iU4o/gXbEKlZxa+A9G7sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg+LiX2+A7AAxu2bDeLHcJSn0EW+5AHLZUHu4L356dI=;
 b=qcK53SZQbwWchUGDisKtMEm9YCL0xZngZRHxIJpVdCEoE9aRWaqNlhDws0XNXKT/Kyo3ewqqVYDm1qLCJRPas1ZwVfaO89AZQmZKl3+J9SlrmWn7C0tgZYAYL1nWyu/8W5Fi4K8ai/Fmr/h8tZXNYjfWEmdJVX4dWwzkoEMVw4Q=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BL3PR10MB6138.namprd10.prod.outlook.com (2603:10b6:208:3b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 07:08:13 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 08/21] metadump: Introduce metadump v1 operations
Date:   Tue,  7 Nov 2023 12:37:09 +0530
Message-Id: <20231107070722.748636-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed07900-71ad-47a6-3d1f-08dbdf604e39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1BJnKx87WkDj9laTB2LPTnive3PrZf9LTYmD6aHuGTA+yn1e1DmeDBze5T73ifYLgESLWSO5x/vdhIpJ/hyJLhyb5lZ3saAn6wLBZU7qOl/Q54rTQyiinlqiYN1P16vDRv4CIFW+yun7IsQylsOghKb/B5haEECh5CP3t/jUtp2xjzJAyWPeFHb4rFmUOIYo42Mx++FF1B7BtjIdAUEPbqyfSBkdXVCSne82c4yFwGzlIT1LO0bpStymyVMXsNZcXoSgoKiXt/FjZy4zYrsFQEvRKKnIDEHSb2pJ2Nx1cSchqxGx9w/6gueiDU7J2JNGMUtM4+ECjLZzvy8q41zVPGB+qhYPI0h7Lbgz1I5T2sInrXi75wvlZFcnHty7zZTRm0K36Yw5FJGFbr3BpApcom2bnXtzjTSCGFAYT+84LWjiPUkR8kFtLk0hxoE8a5reF3y6f/Jzp2v0+q3IRIWEktU/jV7HeqjSAwLPDOdurvi57rP74amiUsGIkNW8wed/kBBFNGcJyDIWZLCE+nmPtvvZm20wAq00gErZtjD96vk7TlMivDC+eleoH7TpjHqs3KyrLQztwTWaHmmq3x0t9OcU6ZTGcYXnJVflUqYTfnLkOk74gJDCgsHqLG8BE59
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(376002)(346002)(39860400002)(230273577357003)(230173577357003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(2616005)(6506007)(6486002)(478600001)(6512007)(6666004)(26005)(1076003)(41300700001)(2906002)(5660300002)(66476007)(66946007)(8676002)(8936002)(316002)(6916009)(83380400001)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TuMyhXtginFY9uV2E5jEZ2cU+U3KKdVpY6iPLF3Yxw71pJ8ZfZdeLZ4kLTPQ?=
 =?us-ascii?Q?8+If+LWjtZg2DU0n3zv5S6xP3pdNc2tZyaKd9nSqgKzdBbPdS4ODtDO5dWTm?=
 =?us-ascii?Q?b+c92Ode5gxMDH4D/BmMOw+CiJzLtmkUVsZe72TiAGKZ6EmwOxnTDVoEOb4o?=
 =?us-ascii?Q?0s1zb85EBphbSrkypg+k5T5dDXfiI03vBU+ud6dLhWdWGqVh8vQL/scsXYto?=
 =?us-ascii?Q?BhwmdYGXamUkTwMeCoiRhKcWchIGZLI2u2d0sq0j2AOTq/1tBDn1yg6a2ZZm?=
 =?us-ascii?Q?q+khuOhyRyNR7sBo/RYwQxiQXicQWBR+ClmFVB7Zvk/CzneK4vt1bqDDc7NT?=
 =?us-ascii?Q?1sSKqH87ED0BFMkWi05aNHJ2AgPe5x2CvdulaCroQLZb2BMnF88KghFijdVL?=
 =?us-ascii?Q?75L57wPSNK3FrxjeuD3V6yim8jXAE6s90QSB+HnaPhBjGGzZXyJAZIJ2TMqA?=
 =?us-ascii?Q?/OEP79DnS8qHbG0pXhDhaf5bC8Ppo8cmYne0DVeOgFhYXemPeizvMlUQncRy?=
 =?us-ascii?Q?Etnnt9L1UwoS5Gxq1jjGGFaqHNvuTARxbacj0GqpThB9ewyPzyka8UuLdhQR?=
 =?us-ascii?Q?aUC3jWAgwWeeq/g7oHLX+48op3fu/KtW0p/Yv4YBTZxz2/SdFZ2s7MRmwWLJ?=
 =?us-ascii?Q?QLQ3y02bT+b6Iu+OVe4xgWoGPZOkqvwlfAzd+2N7ixY6cOEisiApClS+sW96?=
 =?us-ascii?Q?0pBVTbCiC0ThZvYhHzsPuLTMPEjfFRmFoj1kNCd08oHrsq4W8Ojfz90R2PBC?=
 =?us-ascii?Q?y3VO776DUtQszLGUPFdGJtyukvUdlr+qBidQazOh9mrXkUig1mOKytLjGQI3?=
 =?us-ascii?Q?NRM2LYaIm6S9CvSKEQjxiWn18HoLFRXkJKKWlNi8kajbId0AP0lYB/fRx3Q5?=
 =?us-ascii?Q?86b2nlGtXS/bkCjK2aeG2f6sew7VBb+eND+YQo06/j3ZTUkq75vXtjT4yll4?=
 =?us-ascii?Q?VDcv9YzAXP7zAFAe0oKStgTVxmzFzxgacIaZhpfLSYH8HdRDtfJhpM7lFgR1?=
 =?us-ascii?Q?QrF7aqmPZ/iJRDaSMhMl4j8hlB5JPiQVIU+yoOyCPrTz51Uc6WilFrLH5oz/?=
 =?us-ascii?Q?78i7MigJGI4Rkl/x9JBqU5/8yaoxmXsybmXBSp6LylNghLTliH60CIJxbLMd?=
 =?us-ascii?Q?NWCABTAGj/uTMXEeMil42IHB+ISJlBBSu1fMh09MR55P0wxwrxliGqIc3dI6?=
 =?us-ascii?Q?L7yBzuZrPjj5hd0vVYPOVK08rXfr/6meoFTJpaQQOYGBoAM3cqsqqyrQFgD9?=
 =?us-ascii?Q?YPeUByT7u2VIm6raF1yTGXmIvhvmQbTHAeJDeoIUW2X9W8fgHxFVfDZMKDXj?=
 =?us-ascii?Q?ADS2AU/RUvRTHFty7LHT1izX2vljNoVIJTQBC+f2G6pQIkr5PIDgL0m9070/?=
 =?us-ascii?Q?njKQWVftI6ZFbnidE/A7PdV+rc//fSUa1IhQRBGOomPuY3o06ZYh9TqRLkOk?=
 =?us-ascii?Q?nGEldDSr3GtjyZl23UvhW9J0RhAQ0VMgZWCLejD/zIutENx2msy0b2sYlM7I?=
 =?us-ascii?Q?PABR9SOx6LVEFNVh+y7e/9xR+bNVWB0LZQiJq4uQDRFgHttz9j07/q8W4URJ?=
 =?us-ascii?Q?0G6EhParVfGoeoVy0TE1r2Pohi6u7BRGZYYA39yuG97MGmIzho8bggt/MUSs?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GS+GnKPgAP+dyKnwHJkvQyn9KBJmhkSV/Ex+T/4KUqUHjw1lBNCuRVLyAwCI7FoR5GwOO15st4VvPEDVBgkijpswa0k/lmxwWdLvp//pHVCOsVSVMGKfAChkEcXfIzi19I1c5Ow6GBTOXb5RHm04w7BraBgwWOUkUy5QmAlkNj1dLPuAJhCF0KXrDeckJFRIW5N2m3fMdjzxlqlxslAcygKYIOXPZ9G6k2sgwPFlSTknF8npwySCtadHCYe4nHr9RJTUt6ueNcE75Q4DDivS/JGTkyW3Jdw0dHUk7hnuY6Rj/AuYrnwkz7GB1uZbnjNla95fz/3iQGyfNlf17z+xGmKPs7JvnElrN7a22OsUjiEHrGIGNnhAFYIek/dQdzJVPWFEICYee72mKUPP/Gk4uPgd9dLoWrK9RD+wL+pduosZ4UaF/ytft0EJwSnXYMYndZlan99t56+AX9ERrtpPtPTy7mzDc0+Jbv//BRuaxWFWNTmvg8TLY3a2TbjoD40HXHzqn9zyxKoJbESgH8z7NEhJ35YswIDp1OpeMKwl7YHT0O4Z9i9NKj75iFFoOhUxve7se8TVYVm1AHJ/WvULigOYywOkwATMmfBr7u5Se0/6oBt7iqjWu6siusYRzgJgwjkheKbfuI79/5yPrRYUA56kjBZpo18Mcom+WQnxPD5Ht6TDE47rhf8BX4UbLox6a6+X/iB0W5xhLtzsl/UO+K00aWcyIzzuf+RCr0kJMe4YkKUe8bQIHWpFFzKxn5TOycxGUL/xEi+h1AcyfBj3VQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed07900-71ad-47a6-3d1f-08dbdf604e39
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:12.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwOQfNXzHIVaGrdhAAeU0A0OJsFWj/WBfw6Wn2N1WtSfFKvZ1icjKfzFbI9NMXatOOj1mlRNK8qc8PzEzXK3sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-GUID: M1lxnQyIK5FBfoy528T-B8XUVOnppfNv
X-Proofpoint-ORIG-GUID: M1lxnQyIK5FBfoy528T-B8XUVOnppfNv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with writing metadump to disk into
a new function. It also renames metadump initialization, write and release
functions to reflect the fact that they work with v1 metadump files.

The metadump initialization, write and release functions are now invoked via
metadump_ops->init(), metadump_ops->write() and metadump_ops->release()
respectively.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 124 +++++++++++++++++++++++++-------------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index a2ec6ab5..c11503c7 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -153,59 +153,6 @@ print_progress(const char *fmt, ...)
 	metadump.progress_since_warning = true;
 }
 
-/*
- * A complete dump file will have a "zero" entry in the last index block,
- * even if the dump is exactly aligned, the last index will be full of
- * zeros. If the last index entry is non-zero, the dump is incomplete.
- * Correspondingly, the last chunk will have a count < num_indices.
- *
- * Return 0 for success, -1 for failure.
- */
-
-static int
-write_index(void)
-{
-	struct xfs_metablock *metablock = metadump.metablock;
-	/*
-	 * write index block and following data blocks (streaming)
-	 */
-	metablock->mb_count = cpu_to_be16(metadump.cur_index);
-	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
-			metadump.outf) != 1) {
-		print_warning("error writing to target file");
-		return -1;
-	}
-
-	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
-	metadump.cur_index = 0;
-	return 0;
-}
-
-/*
- * Return 0 for success, -errno for failure.
- */
-static int
-write_buf_segment(
-	char		*data,
-	int64_t		off,
-	int		len)
-{
-	int		i;
-	int		ret;
-
-	for (i = 0; i < len; i++, off++, data += BBSIZE) {
-		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
-		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
-				data, BBSIZE);
-		if (++metadump.cur_index == metadump.num_indices) {
-			ret = write_index();
-			if (ret)
-				return -EIO;
-		}
-	}
-	return 0;
-}
-
 /*
  * we want to preserve the state of the metadata in the dump - whether it is
  * intact or corrupt, so even if the buffer has a verifier attached to it we
@@ -242,15 +189,17 @@ write_buf(
 
 	/* handle discontiguous buffers */
 	if (!buf->bbmap) {
-		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
+		ret = metadump.mdops->write(buf->typ->typnm, buf->data, buf->bb,
+				buf->blen);
 		if (ret)
 			return ret;
 	} else {
 		int	len = 0;
 		for (i = 0; i < buf->bbmap->nmaps; i++) {
-			ret = write_buf_segment(buf->data + BBTOB(len),
-						buf->bbmap->b[i].bm_bn,
-						buf->bbmap->b[i].bm_len);
+			ret = metadump.mdops->write(buf->typ->typnm,
+					buf->data + BBTOB(len),
+					buf->bbmap->b[i].bm_bn,
+					buf->bbmap->b[i].bm_len);
 			if (ret)
 				return ret;
 			len += buf->bbmap->b[i].bm_len;
@@ -2691,7 +2640,7 @@ done:
 }
 
 static int
-init_metadump(void)
+init_metadump_v1(void)
 {
 	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metadump.metablock == NULL) {
@@ -2732,12 +2681,61 @@ init_metadump(void)
 	return 0;
 }
 
+static int
+finish_dump_metadump_v1(void)
+{
+	/*
+	 * write index block and following data blocks (streaming)
+	 */
+	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
+	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
+			metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
+	metadump.cur_index = 0;
+	return 0;
+}
+
+static int
+write_metadump_v1(
+	enum typnm	type,
+	const char	*data,
+	xfs_daddr_t	off,
+	int		len)
+{
+	int		i;
+	int		ret;
+
+	for (i = 0; i < len; i++, off++, data += BBSIZE) {
+		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
+		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
+				data, BBSIZE);
+		if (++metadump.cur_index == metadump.num_indices) {
+			ret = finish_dump_metadump_v1();
+			if (ret)
+				return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 static void
-release_metadump(void)
+release_metadump_v1(void)
 {
 	free(metadump.metablock);
 }
 
+static struct metadump_ops metadump1_ops = {
+	.init		= init_metadump_v1,
+	.write		= write_metadump_v1,
+	.finish_dump	= finish_dump_metadump_v1,
+	.release	= release_metadump_v1,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -2874,7 +2872,9 @@ metadump_f(
 		}
 	}
 
-	ret = init_metadump();
+	metadump.mdops = &metadump1_ops;
+
+	ret = metadump.mdops->init();
 	if (ret)
 		goto out;
 
@@ -2897,7 +2897,7 @@ metadump_f(
 
 	/* write the remaining index */
 	if (!exitcode)
-		exitcode = write_index() < 0;
+		exitcode = metadump.mdops->finish_dump() < 0;
 
 	if (metadump.progress_since_warning)
 		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
@@ -2916,7 +2916,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	release_metadump();
+	metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

