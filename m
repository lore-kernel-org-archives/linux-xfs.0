Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A691C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDKDhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:37:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F6AEB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:37:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJuOIw014424;
        Tue, 11 Apr 2023 03:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=s3kWDgm1lUus90+3q4KA9FacayrBIJymGbP4O+RxzLI=;
 b=VAWEVCMQt89RFDlYl4LPWWE7dwvHq/bghDlOcsA3i+z2JLui85QyQYqtg9VtZf2SN7mi
 EC6AR2oqweejaBTg1AYI4n0QVEwk0UGxp/5b4LdaJHDSl31OF0fveHC1LXQJ3zJ2/Bol
 p4LfgbH1jwiDp/ij0tDHZg//SMfGmdwbUxpRtqy8yhhYSE9id1GldRDESzdBNwqCZscq
 hCsdXCgE//ik3fbDg5CowPoY5UClnjU0l+ajrDKD8xotrkPsshxSG5QgSiS3vqiR+XTZ
 TixwCY8wYMZlsJfOU0RQyiL51JY/OympR1yso/svZltf4CMQTId8Y6L0OHO4LGAd5XYt kQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2v9u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3U0bI021198;
        Tue, 11 Apr 2023 03:37:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdn1ggh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d33vxntIvDWvkv2u+qw+EcSRZnnvofBZyoyFWpmGmeeDmsa86yrISXVOywIa5JJT5ozOXChXT09pPwhs3jNthiZnD6YOscb6j6W26bYPeQiHYTHoItgLHL979C+wYubTRzPZqcsR9ql4/mQv4hXY2W5CH6jieiWLjQcoUkKwqI6mH0FTdQNgyEG1KmWO0LWbp2RrC/9YfKOorQb1TTSBSoqwgHo+m15vLGkLK/MWfa77eVR2zTWO/8QNseAZjWKKEY1qhOaL793EMSNpy3Evg9vNCxcOrqOdqjUOU0QI5zni5N1EtE9uGG+y78LFrMBereEKdpAOoWfy8R270nOO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3kWDgm1lUus90+3q4KA9FacayrBIJymGbP4O+RxzLI=;
 b=CSHEfZMDqBxmx0ccDn/yc7cDcFg3Ig4SA8GtTJCs+A+zamat2ewGspThcZJyqiT24CMn8rgb6+ESCAsHuqRbYoVLi/DldcQdWYSiiGO9+i9YrZdI1kZBBba8hys7qpQmwbVcjHWDi9ag7rIbiEmxRSFwL+lXfmsZ3isOOdZRYWGvnszBcIbivGYdoyZH3IljuPLMXsRsxfa5k9KtjIB/H2T9iNzm9PpDGZ1wuiY/BDXSEw2S/5ZUEf7BjcVBlCrGU2cVa64ADH1xlpzsI7Ps6Xmu617ZrU1Gwo7ogbbABiA8PbZq4FBJdVqal2xURoKDStG8k8GNn0R0c2ggqiqOsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3kWDgm1lUus90+3q4KA9FacayrBIJymGbP4O+RxzLI=;
 b=KbGRXvK/QWfsTLGJAxgDCh6PV2Ocj5BUqb8IAht8K6fRJCv8IEG3D1MJr1WVYVFiWvsb8SXkqkc5Ll2QJXdXyP0cOFnAZFO9wgpuvTbIl6plkszZOz1t8WJUwr1FdHRQ5SwDQnqoRhYKhEl4rG4hIskf0K2JUWfxza8NeGesvfg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:37:06 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:37:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 13/17] xfs: report corruption only as a regular error
Date:   Tue, 11 Apr 2023 09:05:10 +0530
Message-Id: <20230411033514.58024-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: e89ba8fd-ebd4-4be0-6013-08db3a3e056a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EEND2knfKRpRGZReiKpNktvBRzkuUuQrn0K6YThSi+X/olQ12IZ5lJ5U3Hc1OfbZsHyKyxuZQzqk26DQQEZrZUvwPBZHHrJ+7s7rkYAfS08BXkL/m1LbMtsk4ETS8FEw0QpdNa65X0CjVdcuG/vcEop8wHIeAWTk35Sv+XT/S4zFs1dcKX9XMX0EO8q0bI3ZtflBTGglXPdg2H1ovWcw7CVwcfHBF5/qcdt2kmOf9w2E70PwyaQVfRcw2xZCLsilANM9Z0Mgu4VauBGiS0BMCCzFOPyiev5C7la0q0BZq/6dEUrpSzuJRzDLZNdlGKddgvwWucjyR/0z1fTXM1mn3pTu71AWK94jyaKhI6lVU93KvLaFhQVJLwOqTsc5gey+x5tBzDn7L14AlPNfySP98Kwz750cCbDpWkT1FhZnclc6+olmaHId56yW9GVqujHbrE5D2ZAAOue2zYtFuk1eZbQPHN0Z1oAVZ3dvOTm3Z4D9axu4V8tXXr8ZZyG7SrWAaH0TDOojKQ7+gsys3F89OVi09drcVIKFubUZIF8Gnwm+lD5Z57OWcSqfFxbzeXRe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ABvOugF2jyrgSlpt+RtON562yvx0aBhkYUwHNixOOxz01BTLpX6pAc1Iz9JZ?=
 =?us-ascii?Q?Da3XlZZJN3DXrBlMBZ4PrlEAmitkAaCzkTxcHVA8+CqTLpkfsGgbq2W1Qzkz?=
 =?us-ascii?Q?gVFgPi+fIyUKEyBazS/HXLGBHX9fYzG5hNj90tBa+7vioc7TJQmmddNyHNQo?=
 =?us-ascii?Q?yarhVO9xmqsNdpDBRLWE8E9zszQRPcib6FuNtI1QWHJqjW26u60Yr6ae8twe?=
 =?us-ascii?Q?b5uY7oEryOn/hyDsXxIB9uH7JI5L9Rg3DRwHF/J+Q+PceeY27VknTHKm8YXW?=
 =?us-ascii?Q?u046EJQ7mLuSHcdSVJO5VDFrxeRr2Wt+AUKY4WHHKTGWjQkcSq2TXffldXG5?=
 =?us-ascii?Q?DcKFszXnY+vh086vYgLF/9DvS+fkMDuXW9E1V/JEG812gmT3JviwYGmBRg6g?=
 =?us-ascii?Q?hwS+WfZ22GQW34wtusWYkhQnft8dyJ519bTIArXGSeTig7hPJ2EVwmfY1AZe?=
 =?us-ascii?Q?1cg9NXUZ04L3wScWCh0LvanM054PCE73M8WQnLp9K/mwxtn5LjxufHQ2ribv?=
 =?us-ascii?Q?S6QZ+RO+lH69umGSWJglMkXUMbceU+UkDozu/bG0OroMF31ZU1UDsW8pGM0n?=
 =?us-ascii?Q?vscIgo3my9Fht2vnyv4ArzgOLW+HaeElwsMLvcEjQ5Cz9lW03jJrJf5rEH2A?=
 =?us-ascii?Q?fC2ebGY0YTSNhgTKk22VJXK+n7ZB4mH+uok27d6FzoS/69wNzDhjrqIhFSEu?=
 =?us-ascii?Q?BmbT2zZUeLdOEM51VXpI0lnV9ARwwxIxngiIro7HdRVNXi/yaPLlNzBLbrTO?=
 =?us-ascii?Q?HlnQcSuALRRsFGmdiJn+vY8eibrZTIFW6b67Qq2kN2NrirtpRnVVeAt1b/Lx?=
 =?us-ascii?Q?LU0NvN8dJiZRiAUtFk9ol7pAccuoAoVQ164GblJq4M/CpbZ579wrwN9nnJ8p?=
 =?us-ascii?Q?g2ydX7b+6XUT/8kNTuUdgvY34DadVe8ZoAc/BVuA3L7ar52Zr+HtkF4D5uRJ?=
 =?us-ascii?Q?35BpZZlALyRVmHtAUAOrXlVGHcxY1q3Bjv2grCZ6CtAAC3pjfqdQMhtIDyzy?=
 =?us-ascii?Q?N3hE13enrsp2GUWvedMAU2P6/sqydHFGiMWT1TpsGJlp23859AEn3DYmqi3W?=
 =?us-ascii?Q?xJ4LrtJt6f37VwMPJ9KMvV7qi8VL/zs6P6NJGHU8L/gl6ktkqX4yJBaBr9c+?=
 =?us-ascii?Q?qz4mjTSFR0JUarU34+nkhs2ocvHA9tWhKEOTY0K/JlWb4OrjQIOsKtnCi7yj?=
 =?us-ascii?Q?Yoyv+8tk0krsZuP7bud4Br/uq6NPJEUmwG5vhZSUHTqt31wZDaoH3Dj0yOVk?=
 =?us-ascii?Q?Ki4SLNT2nMwM2vBCNHAgpwnMWwSTq420q4eJg2GdTCHy9xSYPPYEq2BXzQOv?=
 =?us-ascii?Q?1TiROyhCgLcYNPddVqIia1aa+aKYEbLUAeRtxDNnQgr63N6z4x5d5yOw4SMF?=
 =?us-ascii?Q?E/xs2Ys51HApPnxe+E3yZS6hHL1BljvJ++I0zQn1JVqk9flsQvZFpp+b3/MU?=
 =?us-ascii?Q?ki6sBNUPrBhhRn2kaLDWivvIIAIi7n0KhuOCt8DLhuLv9uqgVQ3uK4t823Dy?=
 =?us-ascii?Q?fwg+dCbEjZqPMM90cdjkVYXSyrqsXi0k+Y/4dU5fB+8+VwmHp4Iqj2OwwA0Z?=
 =?us-ascii?Q?r8g6+QltnbrHgAcn8D/uw4IsdeU4uWzEPVNEgy4ePkreXYuvZg5aPydPRhj7?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: efOAY+IxyXaRVdPybUTbyQU1p/Gb//4JOPkIIVXfcd1crYR4CaPKFBd8Jlx34EZXz0vtzEqlHcoSByGjYe/T1IOky4SxXZltgC1qjvhKr6oEiYdJMRaQfIJ+Hw1eXv3nNSOo1hWQ5qgtWZWwTcU8f5YXWtdPD7vEIDMrsTDjQT3r+HEIbaJtvCZyZNWwXlxhRwA8US6Ye0j11EkygMV4GUV1x0gbwPJdMsR7Cgupouw7hMPLwVphVXi0cqx7pFSzrsgUB20f+G9LjAKrJ12pceLdzpZ/f0iuoil3KHiOYmvRL4mToICKOysaHkSe5yFB9gQTW2BI85sRY2RaGkg8XZvubXf7cP4ObOu3QllAOjSSGuijn0j2TP/057n+vWjb6TTL2RH+X+RuIifSkO/Lmjbl9AdNK+kJ8VK/UfQLIXfEbHIro+CtM/DjonuN432CltYTx/Bf1L0iSjJx7ac4CPmHoPIbr+YKIHUteGqwxfTUpN8/akRtKJyIfWe4+pbRkDycj2WF9tSUpPnnNdJ9lXNbm97gv0W/9tcF1r3PKYnnAIMwgrI2TePyCu+iCGpahTIm2gZinl5cHh1psVg/MKXcCeYf5p4S7N/oB+sP86paKU27r4YQHus/rllcPlszFvoHPR67lqI9yUOAk4hiB08I1QitHayCSgfGYKoWM6s1ynG9RsTjibNBOlGyUkd+EERCrEHu9Y27liWqm3bOGNNZ+J0MloTMQA+7wi/05zrV0F5KtihkoISdxF7UuOktAXbHagyYNUlGc03OHDyn/vsEQS4Bo9POK3yK3BD2NUHGV0YmJnx06MWnrOW44fKu
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89ba8fd-ebd4-4be0-6013-08db3a3e056a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:37:05.8985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/Y445sJEIQJY7Wl9Wf5dI9PaDyqPT9apkxV0DylVbeIfUn3RDmfh4E8/eQDvP9bN/RsVJwCz86lxd7mk1jmVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: rS8Kssl6d5DWGDFPTHx9sHMwtaHTNPbT
X-Proofpoint-ORIG-GUID: rS8Kssl6d5DWGDFPTHx9sHMwtaHTNPbT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 6519f708cc355c4834edbe1885c8542c0e7ef907 uptream.

[ Slightly modify fs/xfs/xfs_linux.h to resolve merge conflicts ]

Redefine XFS_IS_CORRUPT so that it reports corruptions only via
xfs_corruption_report.  Since these are on-disk contents (and not checks
of internal state), we don't ever want to panic the kernel.  This also
amends the corruption report to recommend unmounting and running
xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_error.c | 2 +-
 fs/xfs/xfs_linux.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index e9acd58248f9..182b70464b71 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -335,7 +335,7 @@ xfs_corruption_error(
 	int			linenum,
 	xfs_failaddr_t		failaddr)
 {
-	if (level <= xfs_error_level)
+	if (buf && level <= xfs_error_level)
 		xfs_hex_dump(buf, bufsize);
 	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f4f52ac5628c..4f6f09157f0d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -217,6 +217,12 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
+					       NULL, 0, __FILE__, __LINE__, \
+					       __this_address), \
+			  true : false)
+
 #define STATIC static noinline
 
 #ifdef CONFIG_XFS_RT
-- 
2.39.1

