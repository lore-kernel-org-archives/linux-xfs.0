Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596A3EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjGUJqu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjGUJqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30838F0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMXD6006769;
        Fri, 21 Jul 2023 09:46:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=r6e7J2/jI0qDysiNTwNPel04H4atctawZMY6LKbo2BQ=;
 b=kQHSCU8CdOjGY7LMihGoFs8qGLVgUD+P4mpzKDluHCNVL1Azk+9FIi8xBLSJKVDF0kVo
 bomX9dnJImRh8y41Slj6DBYQ/u/2Chh2VqVbPS7Kq7YjllJuvPedOh5BdbnlOt5Sc6gg
 IVCaSfF56AwdY3Ose6OidRmKi/V5DGizd7pB/JffouC1B2iS+PydmY3xGy0/NkrOukG0
 3dIkH6fi2NvIFCw7F1INIa5eSkL/ioOopt9Czuwtik2v7R1mAmxbw9iQaeMlWnN0bcQP
 f8Kbsc7qkpenmoVpAEn5ZHGE9usaOkRa6C7ryOHTPelxO4q8IoSSAoynBVlSEp7Fau5b 0A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run78bdsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L7kuiD038226;
        Fri, 21 Jul 2023 09:46:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9sqng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZigT4AemdKScyL5HcTPZyeoP0mH63H/MIHSq2AmuuJS7eYCliifiBpCfXRjc+mrHqalXLsvw4qpzN2pLITsLEuetA5lgXCQqlN2M1jPE9SlHf6kbtm1/RPWD66cEZfNRZ7wrF4ZCgUkeNNPH/Q8Jhlt50922GxDZu8KARNtPuqPG2mo60Vp3V6pHcnn8gMDP76Tl9A94s7EP1BWLrGF85pRh7LFWBbPtFcOu7h5IouxtnCiRX9ugkhmmEMNTh2XUsuYvGJKb+oaMCkWmxonuOr5VNBdPV+yD0xoWDLv3ws4NzBujuaqHKlMrBcfqBeU0NZJOz9RQ6cEYY6Yl7UJoRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6e7J2/jI0qDysiNTwNPel04H4atctawZMY6LKbo2BQ=;
 b=d1/uUh8bolGoDw9aGb5dRsjGd3kUdXHf0Q3taYeu9HFWzmsH5WONdNembpPyag7xobg5Z9lGatvtH/bLuiDyKLnTy7RL4ezrT4o5aly3eXe9ov9MiYtUy/2HVYEVWo5VJn/06ocjeZ1Z86hBvb2/BC6sLOTjIdvfudam5wyVKFvYnHwZ0LOV7g377+58tnT4Pe/qA0O73rZrnRcGuRMfwJLc94aBzJY3MT1iBt7pNXYuMD/+uQIAnqhgB7iKQeAOI8kGVjNeQXvVj9NvnRmPj27fw0gAlFbWgBTUXoP+GbXIUbxbvMew18mTO0X/UJhs79xqccx8Yi/wfspIempUCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6e7J2/jI0qDysiNTwNPel04H4atctawZMY6LKbo2BQ=;
 b=s6AD6kGWx/zCHunpURGMCwRQB2tomK4mzQs7wVcg+jEAXfwO30l7vjgvemUHUFdnQEPkHFtWQBQ3xXgxHbyHTpo+oUVDVNeDymEKDCwV9h2LwS9OXWh0VqCv3oonVw6dCECWZU/oOH7fmEaLG/s4sJmcu9t/BlSclNmSTuGgR94=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 09:46:41 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 08/23] metadump: Introduce metadump v1 operations
Date:   Fri, 21 Jul 2023 15:15:18 +0530
Message-Id: <20230721094533.1351868-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 72c6eb25-9e51-4448-fa5a-08db89cf62ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYmAa0tOAqRJAqaBu7FB9BL4z5/7Bncc0j2ZEtkQWRPKJRzzq4bhqWJlnRQwh5/RfnDFnHVMqWlInit3A0yI1bHGKWLLolU6+0vA7MgbUemW+0XO5TJg4PTGbdyisj7smTdBn/dScWTI+2wCi6ZOeVH08v7n3585p8hcU4lwOJi1JCSQ60TlXa7ntUbf8DWA41V2eytVO/sa/BN5HBAeQrBUY4e5ciCVT/MaaJIVKjcila9bxPP/IGDwaLjzeXhoHRwENC1SyCnkzdDrxpUCAcBovc1hx1xMhIWswTA2tRa0DprILiWKD4vRHbWRsmOYPzGL5guwyiGUEtiEfpMlWssJRPX3b19jYJx2TKMV8rM1+v3zK5m+Kr/boiD/cAdqxuB29VFc+3UYXRnLExXNPorfVOS8S/9ROlfkq1g5DV5+aV29BcMif07rTXrqy0eX6eI8rk2xMM5qAQO91dfNwbHAyIR570N52QiqC2Ob/taAmBUq/ZA+k0c4d95UoGWW5EujQ1So9TeTtj3sjlpn2R9vtNOMtEcnaBOKAKFpKXQNR5Y+14cdjFCn61GKGMS0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(1076003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(26005)(186003)(41300700001)(6506007)(478600001)(6666004)(6486002)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dYN2/LbwzbUy2UrnoOluOHHjcmltc9lzxie4Uq+3P1pN0Asp+mNEn8EO0sgL?=
 =?us-ascii?Q?3onfO0C2zqX9QU8hWybEH4A4lLJxHqH1EZqMkBXIuuWgPP+WzApT7Zc5CNad?=
 =?us-ascii?Q?KdsILSgqikbs2VTZ5BE8nEkARVuY+m8MWJxQKrC1riNDPH+0fuUmNaxc29gQ?=
 =?us-ascii?Q?pB+pTnNlTiqOab2yQMYd/9pXnmnEi8UvQ35H6YSypMxoGKTCdegCjgrvbt4c?=
 =?us-ascii?Q?Ydrwty5GxJx8PoAops4gcktpJqnf8smGKHA097loBOhy+wRm9navHCkkONkI?=
 =?us-ascii?Q?HrA+v/NhWsWF9HmRuGfhGkgqdDvhAeqVWC9QRwRuUiWNvGPBGZ4TW1/pmAoL?=
 =?us-ascii?Q?eMwYx2XwBT9hgO9YDVM7SSs5ZHY2PJCKTqVaBqiaCW6tzx2P9M3HNk1PqCfk?=
 =?us-ascii?Q?C/DRlY462NgyyccCw8qWJaYbkbV839nOJs1GvLKVff8V7bAMVdvO2bChcD1d?=
 =?us-ascii?Q?WcClCh21rpyXEMhL4AmJGjF0zSDOiqTC6ozDSBF6mHgJpDUkIzW3MTnN2O4f?=
 =?us-ascii?Q?9riqOxv6tzyzdr9ya/LBCIHxMzdmvikwlPPc1hfCqHsRbqXhvfyNc2x35EFv?=
 =?us-ascii?Q?qsF1ZouHE8JKWYEY6pTb2EHfbGWFl/vnuhUlJXzKFk2rUeWwVUhYaWy/XHtM?=
 =?us-ascii?Q?3EWM1YGZFfY7hNRnhBMWZJxn2LNDmAiww/hq4iD5HOlGOKuRaDMZGNR8a84D?=
 =?us-ascii?Q?GOQWFjYZC3xY9GjZJhVwfDxkZcR8xfJmp5PKJOJqhoFp6saFe7XF0esyGluH?=
 =?us-ascii?Q?MuGdPtm+iOD5x7qFYGcNPABOcFfl08I5d+79S7kJ2fEU4ItWyF1S45u8iwld?=
 =?us-ascii?Q?LVm5e+bEEIzzQXB2QrB2ymbGLidzdj+RqtDcNYRi/zywVzG5TxM9z6f/N032?=
 =?us-ascii?Q?+4fxCMvuDLM1aVoFwAtSHy/r7T5OfPSApM3WxGdatC7hS+JnojK7ne1RqABh?=
 =?us-ascii?Q?QMZ/M0CUt6pHXG6YXa1c3cmsto+vFp9JcZCRgxJvkMUKFvcSgB54G1bD7VGM?=
 =?us-ascii?Q?z+Gr60+HmkoFy7icU1+VPaac28kXe+6KDhjuqu0ZGn2RQ+/pWrj20GqoDsXE?=
 =?us-ascii?Q?pvG28yTQwi6obF94bKoo7xJTJY1fqtYt1ENr4e5dFvn7up6iopVuL5Pxo7ab?=
 =?us-ascii?Q?D4A+NqjeKpUxJjWpAzm4F3l6jKEYOXtUdxagbsgNtt76KLyVLsZhYbdluV7C?=
 =?us-ascii?Q?f+BnnaHGiBozSXALjJtSmHRCwRbKRSEtk4SGV1H1GL6LXHv75UrChJKqDwpP?=
 =?us-ascii?Q?/UQzuPBiUfHjyIzKKPA/3/bvELRV/mSnzkdVFYONl2tE+DVLiY8lJcUu6Rv2?=
 =?us-ascii?Q?8b9/jbew0hJKvXXZv6LZqPu7Fn2hRU2euA3xdSYYsFwI3CuV44HDP8LHpETc?=
 =?us-ascii?Q?hqsXsALXh2ujiKgoZ/eaccUswXij6dHAJHTk+xj9CziEfqeEs0Jg0J0/yvnN?=
 =?us-ascii?Q?uVAC3dbkkvyddHkkuYcYZluyJdX88xvOYPTnaA3EE1iBqY1KtFFkY0AvCdKY?=
 =?us-ascii?Q?4EXRMnyCaSIRbbIfmMc206X1hyfm6KjG4UaErGYWlICr4mz9cV3fQn+KEPUi?=
 =?us-ascii?Q?QMhqZ1qMFLwGp7iiwklC/rzgvMXP9HTqBABDMiedWYmqJpYWFGEnvasheHLN?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: v391fp90Qq7iLPzwL/SCZLhj4DC7ikD/F4alVUSntmZ5J4dmEWKkndBb8I/e8D4aB2qlkXMB65PoPFNrqC30wxlTOQPJYLB2+gRwkvp13P2PzPjOpvr7IcqiuRundcYJWrdAuYPz68mexwDKv2yCF/5X7qXnJOHbVAs9YZl6ZE6jRu0ANiXxU6en7Qpxh7aBtNi+JmRrUa11ogs8Cd70q0EXg4DKzIaO+nR2GSZnJ/CGbOzsfb6w9xFjk2qmlWV5EvzQAHj9tdtXxqHuxIm3gUV1tyhD96OcijbO86qt3LpZAoutMp2sD59CJlo3XQ2pSN3AA8q1JwqQefoNSHHBks5IvG6YbSP0AFK5VG9iqNn8RFO1ULQhS8+NcnD31/XtsITWIEfd8wdcfH1Eq57a6LQt2HpFx/jb03FBZyTsCzyG5koNi4z3n6SZSWdRe1zY73WPG76LcBtlrLzKi7u7SZ7dsf9DebRWs7uX2Ga11vbf7kIXbky/Qgn858jXvV3ZCe3RwaqtN1Ct5bsNFi56Ks9GbVd5yZ12qzCJY8MtY3pVNb9AzBA8n10DHUv9ZFUANSoUJFCg3JHyZqp0BqGjeLLuh1YAMnLyq64Rl2555gicWTKPLYITtZVPj+zGf3LJGZolIEAmUdzzKMNl6wBr8hXggt9j5lOaJJM6UqfLIkyx6xXygQz+Z+sE0PXYuPNc9VF445kQDVzw2tmoS7V6sk+WZ3cJTJ7wDHny4izQpuvs8/8UnW5VpM65uePxQqMmIr6XwwEcP1znTTUgBEJKRaaWbz/GYuV8RdwBoF0rBQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c6eb25-9e51-4448-fa5a-08db89cf62ae
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:41.2541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbrRgAsttQW3GMTIN9Hh2f+HqlRqg+jQUdgLIw19j27XBadWCfdI5PWF+uPafBTqfixhzFGWXcvv89g5gw//GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-ORIG-GUID: xWe26J9vMo37UNB_7FgstVgf7AyE0X1q
X-Proofpoint-GUID: xWe26J9vMo37UNB_7FgstVgf7AyE0X1q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with writing metadump to disk into
a new function. It also renames metadump initialization, write and release
functions to reflect the fact that they work with v1 metadump files.

The metadump initialization, write and release functions are now invoked via
metadump_ops->init(), metadump_ops->write() and metadump_ops->release()
respectively.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 124 +++++++++++++++++++++++++-------------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index a138453f..c26a49ad 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -152,59 +152,6 @@ print_progress(const char *fmt, ...)
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
@@ -241,15 +188,17 @@ write_buf(
 
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
@@ -3011,7 +2960,7 @@ done:
 }
 
 static int
-init_metadump(void)
+init_metadump_v1(void)
 {
 	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metadump.metablock == NULL) {
@@ -3052,12 +3001,61 @@ init_metadump(void)
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
@@ -3194,7 +3192,9 @@ metadump_f(
 		}
 	}
 
-	ret = init_metadump();
+	metadump.mdops = &metadump1_ops;
+
+	ret = metadump.mdops->init();
 	if (ret)
 		goto out;
 
@@ -3217,7 +3217,7 @@ metadump_f(
 
 	/* write the remaining index */
 	if (!exitcode)
-		exitcode = write_index() < 0;
+		exitcode = metadump.mdops->finish_dump() < 0;
 
 	if (metadump.progress_since_warning)
 		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
@@ -3236,7 +3236,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	release_metadump();
+	metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

