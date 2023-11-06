Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3F0C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjKFNMK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjKFNMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:12:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8BDD47
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:12:01 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D26t1011551;
        Mon, 6 Nov 2023 13:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=zg+LiX2+A7AAxu2bDeLHcJSn0EW+5AHLZUHu4L356dI=;
 b=M0FqB2CYj5iaQrVTCNNm0jZHvCHjeLvo8wMyu/I0F9KrmXgZ27IxDpurLa4vB/IenxmY
 0vdV1/KRgVwNDsnSJzL07Mp6EbD5hEXwV4TmkmhMyWA6744UqG1uiSOlK3S4it59KFtT
 huwpVSldEcE/0/MYwXCyS9pfWaY4L2rIF+joec1L3FzU2XjLqI/A/khaEXw+PzV4yBT0
 WJCbVUgZRoyuza7HRuNa6FrLMGTLo/dU3q2DOIAKP/LGG/IX1/z3kWojs1yHAC+PjoUq
 xH9v7B6RhmLoTMpk1EvzThTQfRYYkWMDLVR2h/q9gcCuKVfTAXXwcmB6SR6DtHt2xlK9 Lg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cj2u00m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D0KN7024790;
        Mon, 6 Nov 2023 13:11:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdba53r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QktTtIAu/SU3UtrLKRWrEjU/egKbeg9/RLZjkAlW10Sf3aPHqnd7gL5Z9cpADnJHfMlNJx8IfEU68t7AEIqWsn+0xGO6cUfAv0yqIPe8jMyPUTKGeTmQsW8u2YHogxKQpqEWYHoMIzU435KOicqhy91Hk5PgusmIUvGlCc/5C7o2QEgHvm75gT2pUyY25Fqy5svMht9mBnM1+4pH73HPMbjWgt/CTOtwvWNjqJ4+egTTpwaWnRfhLr8I7Fi4FRnE6M8aHW//qwr4zxEZN5//xzO/d+AnsAis/PZSWVr/1NB0tuilsB0kYx//pALl6q3Du5kl7T9F/R6gSga6jjZ4eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zg+LiX2+A7AAxu2bDeLHcJSn0EW+5AHLZUHu4L356dI=;
 b=Ck5bN8GViBFRaPBprEm4vAESo02IqKE84/u3p9FFvleoLPGszklOcvYgo5wwe1gj9dTUJ/dhR5OqvdNIF57f6Na2DrTefY3SNrEGMbMKDWGvGV807Iw4RnTHTm4NLlBikIJiBtmWinuy2KZfKH6D+dBcehWoNpsm5u2xdIsK78M5KLS+JWJuyuNLn0NphoS9ektsC+PAHcvCQCg3OSqqRG5GrJqeHudjZMYlGhATeUwa+toHfy07o+7lViCONey1X6dsMzli7wO7aplYvlPLmJKqnY3697KDlX8OotwOQ+31fZ8rxDQPG8M9H4NKk26nYMHuoM1WTUPlZnh50jHESw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg+LiX2+A7AAxu2bDeLHcJSn0EW+5AHLZUHu4L356dI=;
 b=pKlS7XjG8BMiuolyUmlwzeOPLvtCZoqT6Buehl3AKrBg7YmmtRW4hYYdKSGiZD3XVOov+325pLBenirnwIyEKZ9FQTH2/d3OZDRS4x1Gv5Bm1PK64TEfJl7nQW91lsqO3vCKgastZ9wczcqv4D/VqdkoHA74RwQprAEZ8XITxQE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:55 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:55 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 08/21] metadump: Introduce metadump v1 operations
Date:   Mon,  6 Nov 2023 18:40:41 +0530
Message-Id: <20231106131054.143419-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: c46852ec-536d-416a-eac6-08dbdec9f2fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oKGEUsH9HYN6w7sBAoaBkQteX1c3felEkoN0bwYye69MMc/hTJGmEdgSwGEU22AlcjQaVypvNfonGoPpPa5uzuUvTc6hlrdotavC6bjUUKa6z7OqtWNqkwFU6til7NF3pF3FPwCJ212PRpGoDzNODYXgTg0jwha/a/mrbNZcwObNsHSc/bYzJVIpa3YG3zJw2WrX/4FQoQKs9kevUyCiqOaZuClQhER7rk3LEHahO+aOnVH6lzf85l8AWIZwWKdAoPUudYulxN1VUbHgZ7cMVoeZ2zc7SbhLefF6Sk5fubzp5q5hKnMslTQKD8MuC2ffN7pxlq1vM3UZvc7qhiA6aomSayv63H/3Cge/M+DPwzO2gU8RYksphbY8ggXpYOkD5nEGyHEBeTs72h5ox9fnREXCvaEyCCP3rLjayvjWBDU4WDFAkM6m7kvlP13LTPVOjCm59JX6gtffCwu2HPlv2AONZCJrh5qkbMUnSFThxpYA382VqgDA72qsb5Fr2ZdzVROXZIMV2xbeQHtWzcJPbV4/8uB+akSSDIR4ep9fZSBXiCxFIBnq/IaURAg6MdaLZ0x0CcS27BbuQe42/7m0jlZ4nlEjQrq1SCIOxeD0KlgyS46f9iYc7uFCInrYLYRr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8aI0eMAfVODzZhvJ74dipy+AMvQPPoBMRmqzyAh/OodIje2ZNH0mS3pI3t8?=
 =?us-ascii?Q?EmDLDbN6TZYnNhSFE1j8ssGUT0RNb+SKqSkPpKfWcNdS9JRg56vDaWRAq+Sh?=
 =?us-ascii?Q?+WQOyixL6LWkxcjCth3EqOhVmYKraFPXOQ3uqLr4WwfFOE3XF1JjF739fWiV?=
 =?us-ascii?Q?0fCIReF5HGTB75n4ucRkTudwvSL3yeCcNSC2AHBzSVeRQQDYM14oJSAXtnHU?=
 =?us-ascii?Q?c7Y9Ob19cA9OcuSXCPoXNFii6nUDJXTlS/3vB7baZh+QND+BNlGTHxZGasas?=
 =?us-ascii?Q?KABxycLzRQ+g8jm0mJHBQRmmRpSNkZ4mlq0SoBYpA90YKSufZt34Ry0Fb7Mg?=
 =?us-ascii?Q?j8c7nJaP8QomCCMQJcEkQi6XQQUfveKS/ObR1+5BJKzoxm+Eta7HxP05CHtb?=
 =?us-ascii?Q?IvGacTHT2nKjA8e4I0EwewwHxw7RirFKGQit0C8ssopsrCnrHBdKEWepYZSM?=
 =?us-ascii?Q?o5Q2PHQGETVl5BsvOgTWd3Y8LPPwGpVATiNELtC4vcw3LVIoooA3NYQ+/Fxq?=
 =?us-ascii?Q?UfRnywlnQE34olMZ9LG7QpNoeDGDKVhxJueohjz6QaGgqWF9Y+mfQmyuqWjG?=
 =?us-ascii?Q?10jD4Dan6TpG8jtGBZ2Rvt6Jl68Ys0iVAushpOJx/kOna+leMAjTsy454KWJ?=
 =?us-ascii?Q?bgvfJgkLcsA/SsyENjB4RpKdRts63nVKBapqyVyqvZ/9InZsW8tGJrdgDfF4?=
 =?us-ascii?Q?HmbyFrrl7/PshpppNT6cc3QtTjo5xVumDzG2MaN0mhz36fa9Y4BdnOBN6MlK?=
 =?us-ascii?Q?kXItXTTEO6pwUb6LDb04rO1OBRC5XY/Ds7aZSfVyj8uRKiZcFLs7OKfUQkCe?=
 =?us-ascii?Q?7vy51o4LxlG6aEKCfculu4r6hG8tnhtTYf9LnHHcfgMMl37UlsRCQP9D/B3D?=
 =?us-ascii?Q?gr9ajYOY2vCD9GqBATfdDf/Zb9Y3YmF36O4qPbiqnsiiH+Y0YwmJaC/9xTfS?=
 =?us-ascii?Q?Gso3cUhcHkxbsLpg66MBJCPdu5OX/Exag8MQdrNQKbuPm5Zc8ohqEyzL1nQw?=
 =?us-ascii?Q?CqhTOV3UI02f2LcCSrifw2vctykp88Zrni/+EyWE1UbfG4lH1a9J8fq1JyNq?=
 =?us-ascii?Q?2bofjNbeeTaw80Re97YGK/+s/sqx2CJRT9SiP6Y18ywQhsF5wOCU+lBMi1vY?=
 =?us-ascii?Q?3F3HywXbxvWu82riwiXsJzzC3DPKzkI3fV6EabEzZO5yvK6ytab2Zd5xX+IE?=
 =?us-ascii?Q?9sdRG+ZEpyNBZLU4g2yhKAufaQODn4jvi94N8PztmiVuGoWa6HMFm4HW8heO?=
 =?us-ascii?Q?T4arx5JQ7pWe27TzzSM1wCk8InwIVN4YRPTeTMqA2cNp9K8Ys6j8trPV9eeC?=
 =?us-ascii?Q?1f1OjJ0A4XX54hjIYPBs5hBYRIQYJfT5tdrK6habqVqHGapUqpntR6W3QtJ0?=
 =?us-ascii?Q?/mqMOjPV8KIfxHrtbCV+OHXtyAWdboRNUN6o68Chep6M4tRgsrpG8aWHJFFB?=
 =?us-ascii?Q?+VCLpwIxZStRsgg7edfglRkYji2eUr/RdvYVlhYKoTwCXKa6ra1ckWwNIkyJ?=
 =?us-ascii?Q?Ur0zzru0a9zIteQgthNSuej454uYFJwxIR6H+NxEQtZmv5aOohAnL/nbWoJQ?=
 =?us-ascii?Q?JHDZv6CnXx988XBhg4qrtkmyNvAHRbeGIjUmbVvr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XM3x5Iel1zjyRpjwRDS0gFnENr+71Kfns1umsGGmhHFmTsrpXNUJEYLL44djHaD5gU9bk9uNO8QXEgPuEaHni6lGbCKMSM4LXU/bcY5Qo5hdOYkU0XhwKdM0I/6bQ1QFGpEbgRHrJ3F0jslb5GfW4zXN+WuRjMq4GQ5oFyeU1gJPov62EwGmNbtkCSFvZ56U2p+w9/xQPQl/iH/zRVAxf0OMBrkCxj6xt69GXSexdjmWw+2dcW/LtvBDhXMm1PKEpgmd5zOOWb/HqIz56atOtxcrDpFw0FfWgwfd+VpUVfmYlT9tygS12LJHQVMlIrfVVvXRUtgC36RKrrvM9UOEwF7HFKBbVCOO6c9RWvWx9wDBwXv6zX1kL54vKHkmL6+xQ2zOukey3iW4WNdO33mvsRksPLKdo0PO6IGMDdGuJfk8fKVK9RjZ5HfVuO0dnkadOMK20hZquvuIBYzL5igNWO/iIxrdg7PAMWnp5Thxs2Km0wVR+SgcV7E71dIGaMUd6tf3Ny9FN/y3mdH2BJE7JCKV+1fQbJv9BytdbglheG088HG3NAerzwvfuitJLAf/V/GKImmRhLfJOXmkR2IQkkX6EoyT3ZjiPfAsitRN1napAwoe4WUoWgC+q+P2VghlVSwy58T1EHK6Pd4VrnlgnMkbrLDgDMNOW3drdSBjXNrsKkBG6oqvSKonx3wxRTjIMn7sWCm8FOBHIpOdW0fcj1YN0PZ13bO6vPzoS673QCp/vjuzQcEbwXrs5o+078zVxAxW27FQqjS5rB4mZq/5iRjBug4/M4T+eG2McOHGCj4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c46852ec-536d-416a-eac6-08dbdec9f2fb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:55.2573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L168qdbHmC6LDhMA1cO1lgFxevYBdRTSEf/cvF1FDJ459aG76JeOKOHNsnPKX5xVxHB0nU32Jx5Oqq3bLi7WaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: iPlBcepEeCYRPBbFn-TWb-pIWO1lUULW
X-Proofpoint-GUID: iPlBcepEeCYRPBbFn-TWb-pIWO1lUULW
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

