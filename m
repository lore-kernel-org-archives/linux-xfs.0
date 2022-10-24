Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257D8C3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJXEyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJXEyf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:54:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953701CB3A
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:54:32 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2UPU3019443;
        Mon, 24 Oct 2022 04:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WNVLUzet+xSsyNeQHGN7QqfBX4jV9nRGnx+bIaO5HWg=;
 b=KfLitvMCGrHb+8J8zvLkcA5/lQuHsI8NgZoE8LcUjctilo72W1YN5cdnrHyyfaEHrmKx
 kP72lot8fxTl+762EOGsPHjXguNsle+g1ysbBkkIx+sn8uIC/B0dZd6wswDVFa3QEuvJ
 +L2Ji/vuouKbNAzwaf+qg6/bdAl+C4OFYw8QEh44psLRD+SvXZGOND1Fbp3ifl6So1VM
 PKWVTz2szGsInZRhcQHJQ7VIgvU5spDVcSXCnk77g2uCUT4htqJwxBGpIPiNEGkYtZpM
 rNharZz9MEXzBjhjgxmZ1cZBsrSiBxmCUKhHscKktn5OsIKdzgC27VtQsgbWetaGYgpU Dg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc9392y1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O4Z6Td003725;
        Mon, 24 Oct 2022 04:54:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9bp6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXrBknmIM7O6qYSmDPFrFI3B7heuMlYNTuEkjc8M1YKycGr1zZ3yRMNJBIeNJopPoMNM4fi4B0h7/IZ6G2NFCXTJAdcFtOUPBeusiw/+V0FRmPMxv01b64yTuuwuUXwkvbE/1EnmIEicHCKTvVcjnr7s2+Bn+FAPp7SBKY+xKp7d9+0KtEGk2WWBvKa3rrFgkbkgEd2AO2uzMvYSfe9/AY1yeybZ0YLQeehnHfOR22rv9WWNdwEtmJSAjLByO7E1MQZVOxcTUAiOxrKuzC/nIKlYDfsuq03tMbYgBjucE/6n/2mq6+of9GfoBzAEovpkJ9QY+ish5i+8WplDRQ0DaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNVLUzet+xSsyNeQHGN7QqfBX4jV9nRGnx+bIaO5HWg=;
 b=btRxNTc7qrrnjpGDKRn2W64GX2VUNpZNHJhdHmTSkSu3iSNL4gjwf6r4C924QemvyUKFVf83mhWEJftYAICK2NY0cB2r9fWbET3UPv4NSTo+dHiyAOmlLji1u5VZ3nPXTFxxdW1XQb0rqo9YAttgBUVuQH1rBjVvy3yFd85VvvORoj8T+OMT2sXFOMM0k4PpABtJTfx1WuRu0OCWqEthskUusRLrMtVqNnH7SB59nKD/P/j3CU3dox+cZ0bSOeElKgXwSMNuvSE0GeXUnGgkuN66mbykeaLwSYXZO5VWeLcfKNOE52IHNRFFVvg7Kf1yrlHh6+egO5d1C0HnIlnNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNVLUzet+xSsyNeQHGN7QqfBX4jV9nRGnx+bIaO5HWg=;
 b=gDnLjyYB8r55XtoNfHIY3bfczAPHGhAYqBgDadOTfSr9vf4UvIDYWgiCfxv0lx5+edtoC/wXtAEkJkDvo9/lNN2ziWtc2PELgX0DtQUn6/xzKIeD31ne3a7DZ7qn1G0Ck245m4XphFYmYjRgVKdgeVwK9uoLrEndhtlTtn7u2Ig=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 09/26] xfs: Use scnprintf() for avoiding potential buffer overflow
Date:   Mon, 24 Oct 2022 10:22:57 +0530
Message-Id: <20221024045314.110453-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0200.jpnprd01.prod.outlook.com
 (2603:1096:404:29::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c8e72b2-d18d-4e9b-0e0b-08dab57bd38e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAKk4zziI8nE6FCbOdN3chEjlPHyGYs0DxIt0p3HhKkC6hXQdndELza8AdPYS2dOqyELYYkT4jAjPkgdD+1XK5gKJPBgfcK471xusCym4UvYzH2OqQycRdtsk6fYTBJajMXGEEmYqDrJ4MJP0G1SGtRQOGVJTO+MQGPh8ZZkn+75uzjitZZwZcE+dxUimT/a6G5jrPKPkpPb3cfIY5ZYPe8OGtR6FZgLddNPKthCuBMxvXGYNYnwHn/gv5Etqbbvijq7EcV27JBxK9xMfrkydeZleAUbeco7fC9H70PdEgaCIvV2qYZ8w9w7JAl9N8OW7np1P54QFCXcwMWWSvyTyb443yDPcqMT4w+gm6zK4mCW77H5E0d0irrtpcJpFiRkfqEavrFM4N4gCI8rlehcEtsHq4gEhlQb80icBynEkHZ8PF0MPk8u/Sin628zO6n1RXOnbat0x76/T4Pq8VAqI19JXah4tZiF8UyjYnosTGF8DE/4G3quM3tl015OT8dd3gfFQDqYrs+rbHUs4IEDKW7fpqGD5FIMlc5LuriUjT289n+xwhP5suO6wR/slLFeXsI3o/fvgA9ah5oOoGYyFumTUejzBm/yJyWlzlEB6+TiRjhDCqh7tzR6huL0G/wIn+myOudIMq9Bx0IPQB4x2+WPoeOPDwJRHTIl8eCRDzV+xVERFQbwORU1gj6pZCxiXUm1QxmHf0E1jXAf3Ao0pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kq3jsSAuEpIlY+trYvulip/NKYhFbq4sz0xXBQL4tEY5ZDoJzd0bSpBFr4IO?=
 =?us-ascii?Q?ngam5NmsuNypS5ag+TxGNTnDjui+vwYMa6PV7P/7kW6pqDCCUCEOniVnujbT?=
 =?us-ascii?Q?9GwLRTsP6M9+8EU0Lzs0b/BqUsygIPYW7czsGOYN2Y9e7Ja4P9pA+mfGEvmf?=
 =?us-ascii?Q?wlE5bofXvHf5l8Ef3ginPjJq13z7EZlYdgeHmT482BIeSDMjak3taKvrieoA?=
 =?us-ascii?Q?Gyjh+fUqQnqgBBPzrRnr+c13pdJp2PRlnJ1/e5ykHYbdITM8sCFSSXkZm6sT?=
 =?us-ascii?Q?EPGeaax5AtcBTZ1Lfur/BmIJt+RGYcGjEqClyDQYc8j+R8r96SwxA6v6415x?=
 =?us-ascii?Q?65zoFbUVsmCvV9uX2UOPYwIQrgp8NgR74VLPWwHh8aH1+3+zqEBtTX2fIP4f?=
 =?us-ascii?Q?yyiwPPYXxeGzjYSoVvBSEG23x3AlBNxQ3iiRRZ3llwGw28lbglxN2EHBn4PK?=
 =?us-ascii?Q?mcFMSHHSlO7xqvyNR6vS1VPgC4UukGPLVG9NX994pL6+LqivpIGyyrMozrnh?=
 =?us-ascii?Q?NHOmXz2JND8gEmfr+WGg1Dj/pVyudJhNOVYxuSGo0YKlh3gL0M4c15K0XSC8?=
 =?us-ascii?Q?znb5Etm3/hSNBzpg44kQXyfxmZ5dyzRXRC6ppKImB9SZ2VsgcDv1IcnFtlvp?=
 =?us-ascii?Q?TfjoBE+DRJvWkAdSMToK/30RoYugYapYYNu2pW8eMzdeoGV42zFcN3PmwEYC?=
 =?us-ascii?Q?FvkGMpynGsFfIERXCc9KqcSXA1WEP5n1COf/1qoF7ZZl6P2kJVY97itkrV/m?=
 =?us-ascii?Q?OzrXvQqM0B22f2xvvR2CgwUTNpA9o/VqG998uJtDuHxVu5k9oSa+idR9gOWW?=
 =?us-ascii?Q?T5L1hWS7JvueHpZcSjRkWUIVHF/O2LIQn7E4qAk4D1z6UgSisGDm8CETx908?=
 =?us-ascii?Q?5kXrG+shcqkUHOG2sgg9DAdVd8qFB1/YCHtVEvhGrgtgAnLypQeJKob08Ilj?=
 =?us-ascii?Q?fjYYblfHBh686ioZam0gd4Sp9/fFSfJ5KTLmfxQIMB6/E4KRzyAJ4Wm4uLwE?=
 =?us-ascii?Q?JaqN0EOCc5GbYIfY9IKVGUJ5cmJTcpR1VmG3n9eTzI+encQi5cBcSJLHxr2x?=
 =?us-ascii?Q?/EFFLyadrsUOWgXe7SwaltoFFKfyau4/cCv7xaGvKIkQb+s8StypcU8LeWst?=
 =?us-ascii?Q?hMfcL+OBJilzA2qgzf5eggYqZ24yXX6s3Nq3fH8blg1VqE8QV/XEy/vN7h0l?=
 =?us-ascii?Q?pxFgC2Xd6sETU/5AjyQ4mOy0iH7y7B2bUnsJlrcNhl6cuJ4Cta/YlKA108HZ?=
 =?us-ascii?Q?IpnzAsT+uAUmYqwqTV+8Y/vKXyvjOQ2nhuHHjc6TfbPc6zm9Ly9loQq+ZTno?=
 =?us-ascii?Q?MHkJ/QS1L5/XtiOJNtUvsP6Vw6GqQ7ugkBPXlJpNearTRaEDM+qA8ySWLscm?=
 =?us-ascii?Q?dsEsqLGWjaiNHRjAwQbNgeQd0DPpOfPvMLoKOlR1V8vO9fOFTN8tnjbiM+Jl?=
 =?us-ascii?Q?YIOeakS9KUgxMPXx9/0W8GDrd7kvNHV5P2A8Y/NXOj7HZqmKaPRMHIgIszxN?=
 =?us-ascii?Q?Es9y35lXpKBIW/AG3XN/SneS/6oWPQzU5iNzK185wq3nojrVl3C5/IUbU5Um?=
 =?us-ascii?Q?+5RFPEMbuROqWbN/zb1YvBCnoUbN5TJe+4Zi+ht4QFm4YDhf4azEruA5kFR2?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8e72b2-d18d-4e9b-0e0b-08dab57bd38e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:26.3441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V50ThIHGG6m9DDyI3mW9JTNz0gF8xMLYDecKiC5RyoJlrRQ/CVmwohlma6FO66u1fGRn/F24SxHnqrvZN6ABoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: S0jwn9X-EokTAriLoZTIDFTzq14slrMk
X-Proofpoint-ORIG-GUID: S0jwn9X-EokTAriLoZTIDFTzq14slrMk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 17bb60b74124e9491d593e2601e3afe14daa2f57 upstream.

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_stats.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 113883c4f202..f70f1255220b 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -57,13 +57,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	/* Loop over all stats groups */
 
 	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
-		len += snprintf(buf + len, PATH_MAX - len, "%s",
+		len += scnprintf(buf + len, PATH_MAX - len, "%s",
 				xstats[i].desc);
 		/* inner loop does each group */
 		for (; j < xstats[i].endpoint; j++)
-			len += snprintf(buf + len, PATH_MAX - len, " %u",
+			len += scnprintf(buf + len, PATH_MAX - len, " %u",
 					counter_val(stats, j));
-		len += snprintf(buf + len, PATH_MAX - len, "\n");
+		len += scnprintf(buf + len, PATH_MAX - len, "\n");
 	}
 	/* extra precision counters */
 	for_each_possible_cpu(i) {
@@ -72,9 +72,9 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 	}
 
-	len += snprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	len += snprintf(buf + len, PATH_MAX-len, "debug %u\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
 #else
-- 
2.35.1

