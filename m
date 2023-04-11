Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AC7C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDKDf4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDKDfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:35:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32A5172C
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:35:53 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJZIs8003032;
        Tue, 11 Apr 2023 03:35:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=pZ63iWB0SJaAsMbDcwEsx2IYQmKGGgDaFoRk/FtjXXY=;
 b=c2/EkjslWFU5i7Kkkev410QG9HKC8pe5mxnbtcMWkO6EBAanNFU9FL5Q+MuVkI4KlGTw
 wmxLH2iozeXEMe6FX3mDnCJXUROeUgZOJuQAKtRgEXEy2emRqmPqZs0uKEYPqLFwALEJ
 2t0xe6b/w5TB/3xOLKa3uyokYen0aiNGXyP07MSAH8oxafuEbUGuLlZQoEtCyGbOQNQo
 +mR8m9l9mKsI9HymlHptpIL6PBxtPVpz8hwfnR0ro532W7oivs2fxxvbwiMCpXzrW5NT
 1TDHRaGDfe+fyObZPD6WTz8G795Gxzv4f0GpuXigS77PWvBJ9zhd5V/Gji2zhgBckO47 lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwcb86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B2sYM0038830;
        Tue, 11 Apr 2023 03:35:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbm9844-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXcwWbhcGx04DuF2drKcgXLmLCjE+LDC895uhBD+xvpfL1/Q1FMreuPXP3ceRrnU5V78mFFrDrTOjhW6OX8vxJaVwAqjuBnudiV27gzYDmGpGH5Kv8gvAsHs2UcexY/PbDzALtokjUINNSjLlOxYQ1mYVNZO+twY5trOo2jKSDQnd/ZuD+6kzVaBlt4rpQs3bQci2rxtrSfbm0J/hqnnIA+m/qau/vc3aL63qxrPkXPPfrWH48XQJR615XjYeR4/HycegWYgTYI7wUsKgU+wsCcC3x0b5eH1FsYDyH06BR7cXo7i/veZa5XWJA+KPzd3nHVBrdHykAKstbpvtL9f+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZ63iWB0SJaAsMbDcwEsx2IYQmKGGgDaFoRk/FtjXXY=;
 b=Mm+mBW+BpDN9wF1Q0nhAnn9NxrxBPXKgCpW+Ae7nwd5AAdM8LwRfO1USimJauFFE4zoolBoaM9W0mOSp/DmFmnRX4hQYM5OWAH/zcw7a8KI2twdBKVW1zezjm67VP6betkeyzF3rXJohsxCuQirk7QmuB/g3U5F3jYkQF8GPCE1NdiohBR0AdeFJpCj3icoFZkz0EexpC0xlf9o6JzryvUiUjsNcknrcg5lYJc08dlqHrq/PKx4KzmPPXLhNRj+vkK7QrzYrv+xN3GsaMuea1SjmhyFpXhGhS4YW0ocf4odzU7vHcmXUX+cS2tLmD8by8lxzUqH3ci29YSxOCX2F0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZ63iWB0SJaAsMbDcwEsx2IYQmKGGgDaFoRk/FtjXXY=;
 b=vvKrRH7TVhT3GoBakAlzWaH3yYF3OTpY5m3nkR0TVHPwdCIb14TZTAAGp8NIYkFVjRpF51GAj5+/pLwnLv2bPVfCdjcLRIsXhbilVI/W2eKWuSS2E0HTiZwJFFD8sIYyqQVi85+GO766LG4d7v0GSBm/BJ9v0WziqhePF3lEthg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 03:35:46 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:35:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 03/17] xfs: ensure that the inode uid/gid match values match the icdinode ones
Date:   Tue, 11 Apr 2023 09:05:00 +0530
Message-Id: <20230411033514.58024-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0008.apcprd03.prod.outlook.com
 (2603:1096:404:14::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de34664-72d8-4674-ac4e-08db3a3dd641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ohj73bk8/A5y+7f543Oq8ItQpT8z6WlW6RQf3LnEmSyzX3caiE4a7f0o2pnwutkibPtxkwccApi1yqj0Gr0+KynJuxWUOW57Kg3aJFyqsm8JNwP6k5ltKXFT8Xub1GzsfLT398rchcIrAbpS0QhP9ctQ6xJwIza4I/ngWIBagJ36J5okXDBX3BeN7luHB8auBjvad5PvfxsvKB9RDWi96ggcAMGmFHmawEOoVMEAdVac3up0M5SYZgU9swi7SiS6auZyoHAJeEvU7dZHyfril+PTKL5fO/hhO7r5WM5tPArPrKloqwK6K+q2KT3foccRrD16FfJWJZ29ueIL1isRwj/Xc54L8xiVvDc8H8uI3o11jz07dZgWR0lXH236zAZbNpQ8Jh0V85D6ck02Grp7IPnvxQrwYSwqL9bKsjSm0GAiIGpVA6W2mDU7G94GewbJcYSXTZqx78zMGMaBPavYm3koK8fmtbNy9ymEMQwxFZSmdxxTjFNlnvlxZevHlgtMHIxToIWKRe25g75u7eh66FWsTNGyJWbaNCRYO8HsdYGok5mEm1SIq5i5xrrrT/ZB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199021)(6486002)(4326008)(66556008)(66476007)(478600001)(66946007)(8676002)(6916009)(41300700001)(83380400001)(316002)(36756003)(86362001)(2616005)(6506007)(1076003)(26005)(6512007)(6666004)(8936002)(2906002)(5660300002)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EO0Gpcj1YAZMpm60RmA8VoYFMYW9bg2PzdtO9Xz+DiNbHlslG+jBsCde4uiF?=
 =?us-ascii?Q?tb5gFn9VuTBPgXgPr7+TvmMOrRMZQabTWJkDG9Yam3Op3LzEHJUHGL0kfo0x?=
 =?us-ascii?Q?r5Nf2XBSrC0ikXB228fe8T9P25fIN0jjnKgpv/l+G1+fNBret26swd0GzGfN?=
 =?us-ascii?Q?wAPeA5O++UCMK0m0LOgUA02whQ9wdUFjlt0s343kdQbTj1W/iyOFoCAOcNsD?=
 =?us-ascii?Q?lTQdZeO0ayuWE0A/hV9BZ+pJHdU0J5IsdIgm/rJaXL4rZrI5E/dRxQYZDIO2?=
 =?us-ascii?Q?gDgKa5D/07pjaiBd09bt6hHlJ/cQWAES7IPL9gEw7tQu6+1/NkJMwoLGxsEh?=
 =?us-ascii?Q?ohLEDwU8UVTdyn0+o8RUGeZGbI/mDqVH7+YNKTcm+PUixXowZwwG9J/Lf1L/?=
 =?us-ascii?Q?I8of1xsqpuu8pu/SMWLc5fei5IxtSZ8ZVOCJmQ7B20UibWj/IopuERqQQ3Kj?=
 =?us-ascii?Q?nhX/J3OmscHwnGJcATr77+Ht+JTIq6rX6PdieO02R76CbfWiomT1iRuDLFa2?=
 =?us-ascii?Q?FfAna/zbiojiXBqxEkQ9tofMPN34ma57m9YtFzQMLvRFDkGZN7EXh5yAHZtT?=
 =?us-ascii?Q?dWMDJEQSI8EkxrG6N+uKBmzVc7oenF6f9dVmT180RAWauUuNseRvYhnlKArS?=
 =?us-ascii?Q?LpBg9bkhd6roR9EC4FNsKN37dZrTkAMaXV7eti6mS3OjqY+hXDmvfELhl9xg?=
 =?us-ascii?Q?DB2eh/t8hB6x7pA4fNC76RYL71aDOwcEyJvBAidUVvb5FqCE2w+pF4JrAD3X?=
 =?us-ascii?Q?gSWwiXzEnHN1Q65xd4XuTPir0uzzzIoCosNU1C+scf35ZZqzXRoChaXLirLX?=
 =?us-ascii?Q?uhHcvhkQ7NXZYNETqqSKqOqSGhf4HO+wfKFea4TNmLRvKqWe6cGGC5iWREbW?=
 =?us-ascii?Q?rc98uf5OHeu+k4wDK4g4+gOAzLuWoKnqVSJWUJSdqY/qa50jtTr1O8z6vy8g?=
 =?us-ascii?Q?rv+w/FIG4EBxfbizWsurSJKK3dpthA74CvRB6EInQXs2ct1Umy+Lnd7+cjPq?=
 =?us-ascii?Q?eFdejuUHpe0ow8mhkEH0wvdtHU6MRPMooELO6EQe6WR8Hox0Jkiy9iNTwrT+?=
 =?us-ascii?Q?BHECt/zBpQjDfxDDDVswmhQHEPEP1X/czzTFB96oiLgrpJRT5leiXuNk72UM?=
 =?us-ascii?Q?E7uI446qj6kGK092kGY9gADq7TqppFAxWNjy5ETJ4B3xj2443ZC2gnDI7yOA?=
 =?us-ascii?Q?sZHstzJOqvjY2FJPcU+D18vBG3fqVavpQxCCXi119mKdZn+yeIExQb+EvEhy?=
 =?us-ascii?Q?2ZBPZCiqatrBW9eBp1F7WOsRPM6OYW8pQ7j4raRem3RMG0TkvP0J1AUeE+hP?=
 =?us-ascii?Q?o8CE6RoM6Y1y1nXMxtqEvbom/gOTmIupKb1syq4RdLAyAj9kovscT+G9LGgB?=
 =?us-ascii?Q?CI0ES0tjKX5fKauqfmuLXi2tmux1PdSbakM+rqBi51DtM0D+ZwVPUnYi1P4B?=
 =?us-ascii?Q?pGMlBX4ssGfh4jVM1cof58HwNErIaMhN2gZs26HwHUlD7XBcgZ/q7TrXAmtf?=
 =?us-ascii?Q?THvX+5kXKWyV6JIFF+0+7w+gLNxLtRuGNj/f4dMUJWFB4qHuXGWPP2Z+IVAr?=
 =?us-ascii?Q?7RsVnnxLNQMferI4opYlx8USB0f4/u3xqANkpvq0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eYNo7WTKV8wmdqihb5RlSdRdYwW0nnqgJaxgdT4o4CuJaNxmxARQwUnI3wmcepUnEgmhOBAinGjKUp+BFbTBzDPHSElC8DuTejPEylWmw8cs2usBBIzOoT+CEJG/aelhOL49C+yKfeNNsyACvTYMGoqD2j7BlK3a37V+ZO9wU+wDoaUD9cMS+IeVIp8Lapy1B1ghYjw0LrCuJHYV/tb+DrjF1pH1Kbbj2cqZ/S1wJrvl2kIiSOHAXBEJh2dJIgaduF3Vvq2b7xT32LbJi4ua3gdp4xNm5FXqAncC51RHiPW/kMdCGKmqS4u0e54mTG2X2E3Xq305FNJxXsPbE3aDGeZ7OfKILOs90j4Z3Uxf7CMYra9VHYSLJsqwffoV5SeepPRXFaFvzxpPqz7JhRQYCqBKIIm6FLoxOLHvE2tQn56AlrkZf5p7M//O0P+gu6kVQcFwyTaEtLnHt/BSW+BLm8/+9Y7N8VOlJi/MpJqGv7bcXc64ObPQQ4G2Hs1VleujoH6YZLVNQtJu2Ehmdzh7R+yvpFDYO+YQgIrH6LEharXbxenhqoNvMt41NQf5oUbQt5VEvMNgf+Utrutg3He8S9ICID+Iq0lfhuU/EoOH44cVUc9mtlFX7BIa5TNlSQ4R+vKG3d0hgLTYZmFPkMGDe5kSPSDr8PqUPrGPzqtl21+OyqILw7qwhm1vQyFF+/3mDwUEkyDrLESC1nOeifBa89r2r8fWh4ujLJLjkU3fssU+Bp0Ob10znFlocId2enaIMvySAB3GlDOsaEbrmpEb9k+ZWxKqCczSIE3vNnE3w3UM5GEZZ2m+TJ5wEv0+4/X0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de34664-72d8-4674-ac4e-08db3a3dd641
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:35:46.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ukNgYxC4s/B8zOsuAQRU/guY08RQ+1xaqJ6fX0muqHBH6G1+VNdiJHy3l0lmkWPCDk2Tbun0jwwjU2o0vQ8IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=938 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-ORIG-GUID: AQzXVfIC1zY8etrT1Qu-_0MdAQ3Ozj8-
X-Proofpoint-GUID: AQzXVfIC1zY8etrT1Qu-_0MdAQ3Ozj8-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 3d8f2821502d0b60bac2789d0bea951fda61de0c upstream.

Instead of only synchronizing the uid/gid values in xfs_setup_inode,
ensure that they always match to prepare for removing the icdinode
fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 2 ++
 fs/xfs/xfs_icache.c           | 4 ++++
 fs/xfs/xfs_inode.c            | 8 ++++++--
 fs/xfs/xfs_iops.c             | 3 ---
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e1faf48eb002..c7e4d51fe975 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -223,7 +223,9 @@ xfs_inode_from_disk(
 
 	to->di_format = from->di_format;
 	to->di_uid = be32_to_cpu(from->di_uid);
+	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
 	to->di_gid = be32_to_cpu(from->di_gid);
+	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8e6dc04c14d4..f1451642ce38 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -289,6 +289,8 @@ xfs_reinit_inode(
 	uint64_t	version = inode_peek_iversion(inode);
 	umode_t		mode = inode->i_mode;
 	dev_t		dev = inode->i_rdev;
+	kuid_t		uid = inode->i_uid;
+	kgid_t		gid = inode->i_gid;
 
 	error = inode_init_always(mp->m_super, inode);
 
@@ -297,6 +299,8 @@ xfs_reinit_inode(
 	inode_set_iversion_queried(inode, version);
 	inode->i_mode = mode;
 	inode->i_rdev = dev;
+	inode->i_uid = uid;
+	inode->i_gid = gid;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 891f03a3fd91..99f82bdb3db9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -806,15 +806,19 @@ xfs_ialloc(
 
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
+	inode->i_uid = current_fsuid();
+	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
+		inode->i_gid = VFS_I(pip)->i_gid;
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
+	} else {
+		inode->i_gid = current_fsgid();
+		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 05adfea93ad9..838acd7f2e47 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1288,9 +1288,6 @@ xfs_setup_inode(
 	/* make the inode look hashed for the writeback code */
 	inode_fake_hash(inode);
 
-	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
-	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
-
 	i_size_write(inode, ip->i_d.di_size);
 	xfs_diflags_to_iflags(inode, ip);
 
-- 
2.39.1

