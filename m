Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC52C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiKCLy6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiKCLy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:54:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF9BDF6D
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:54:54 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39NgIl014536;
        Thu, 3 Nov 2022 11:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vjH6gZaci3vlqqk/u02OdHt00p74X+Ld812eX9aff/I=;
 b=GinXrLCDJtHCixo1BUAnGmBs4qaclP7TOs/Nsbq7MHmU/fBKaxsx5phb/oJg4acLweLj
 ldP+9RUjVeDLpsZYzE4SEMelrKUa6OIWbJP47KNh6JXgU4P6tvm+4R1koUVWRV74qP75
 bgd0Uitdv3RcSMW30Wvdvw+Rhw3QOA0XilUAwDwR4AZni0dcvSfxko/9MajzxZw5qlwh
 bJGKiOYX6sA1X6GaUCiPfo0XlwvdUxFVBnIjB2fCc6O2OZg66q35339lHEu9cGCJpJ4I
 VWHN0qzIXpRNlR8JSGq8UYTKRTb9PJTWVN0EdZNfdayOEgr7WokXoJiv/PWoWcudc+hk /Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty34j3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A390MYW009661;
        Thu, 3 Nov 2022 11:54:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtmcmq9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1kcpyGv3tb92QXPyfrotFZqwmHWKeZJ7FItH/KM7kndQfugTagRLes66zeoVtuGRjEueN7g/dDO20BLZrWoCT+Kod0Ry+8bYjN9YP5vy6EZp9rXBfGjMX+PBKJAelxhdjEz2zRzO4YdcrUKVG93ocDBezwSgjyoNqn5QuLRuWO8wdOXbs17ctrOsnzL97KCUl1uD1OP1SYCEAvwhiR3MpKU22META7DLs9nlj5Ggz06AfNq5OboAT/lkGoE06V7utPMBbrgsKRbqEgR40Ky4hVl83lP+PJYy8jG1Ew1n7fSI5W9VoKWZ8ZX20l1FMhpnGwdirmHyki1yTApouFgpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjH6gZaci3vlqqk/u02OdHt00p74X+Ld812eX9aff/I=;
 b=lEOtmnB4H6Qv19FqFLz7PsosMk7UxlO05JsSY8SJNs6pAxJ8PdkGg8CAg3d2/npU2R6M5aDoNvbsisaKc/ahAHjZ2G+DXPvXtGoiiCvVbC6mzMepwlbR/X9ALA3eSEDbl39W3Yw8eAC35jciYo9jL9X09vjr7HHfWXJYdOhORKwvccSuxZYuJs2Lnzj5fGri0aspg+lXJmAMm2gmiQo6ca6wFJRXLFVvAJLvRqRs50LLaw9OyKCGwjSoigKeEPOyBsrzWGZrngqEgHe6oCGMDdSuc9DRYd7v0JUcZrdoL/OA5JrYm7uT3IaZqNgtlpWYXNTwL7ocBpeCnMF2+dGkpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjH6gZaci3vlqqk/u02OdHt00p74X+Ld812eX9aff/I=;
 b=UvYBQ/q5VFemrGNbFF7KrRo6jCoRKoVqUiT1rgEVHlTKxI81tR8nZSzakp24GpRyMXjzPqDOADaNWvY7gHmVQ5xfDZOT6cQ/Mes1OcEmkmgpg+MCa9Z5oeFZkF38frcheFHuR1WlUHJz7RC4yKsBzE3iB4jEj5atEt9Dm9wEoAY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO6PR10MB5619.namprd10.prod.outlook.com (2603:10b6:303:14a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Thu, 3 Nov
 2022 11:54:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 11:54:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 6/6] xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
Date:   Thu,  3 Nov 2022 17:24:01 +0530
Message-Id: <20221103115401.1810907-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:404:a6::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO6PR10MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: db31a173-16b0-453c-6653-08dabd923585
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: chqziyMBx23MNIGbCEz87FPIkgCmLFAkaYvZBH7NK+V6EoEOllWWmjJyw5uRZuzd1WkCyT94M7QI8sWNj/nxGjovMgsXK7lVm2YJ2yuRmv2DPGBDzcTda0Qqo4ZR2y1qgxIz+zJRiPSeZrbe/+syBC8gtu4b5UvQJe2ka6IxbDeMMNMZVklJvGZ+Q+MDCnLFRQBP+GgYAU3dFRIF9pFxZzXPorzo+XeQWymFhXETX5OMTxTnbzIzWSd77jJZG8TxzPA7eWtLyqqmgNV6RHK15Jja63xMIFwiAiadY24ZDZNj4WhTf+bZAU17uce9xmKOculnBXNE2bKp7/XftlilaSvE8U9yajs3A8jnEy+YExGyDys45uVKG5O31Gcimj9P4fFOoENxro+3yFuc9FQ4rP7un9JPt7aPZFaHC1hYHcR+kRVvgLHn1B71YbrXi9dllkGvnGFdz1bEj4RN4uNSZYdQoQBA2qraq7HbOVqYbV8QbOSBTypfdRNBo6FvbE5bo0OWOUi9B1KvEMqq5r2lRXObuZS7lY9+jnlNKT5r5FBvlKipdFDzgD8lP8T6m5as4wTX+hT0nUBtrH+F+zW4WGTsem0RpiN8IDE/cAuXUknQRzYe5DEXKpSfIsyOHz3C/zqSR9jD9HG6MibakWpqUJ0vJNOPNpTTe37vS3IIn3WmZT8ur0hsL6Wo0Yr9+VSyD8f4o0mA7b5pwumYr+RWCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(2906002)(83380400001)(86362001)(5660300002)(38100700002)(6506007)(4326008)(41300700001)(66476007)(66556008)(8676002)(186003)(26005)(2616005)(6512007)(6916009)(6666004)(1076003)(316002)(8936002)(478600001)(6486002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vwI4aqmvDcJKM27cKIgIbVEF6RSkp9LdsZp8BNlU7Ynf3mrADsu9836brpXR?=
 =?us-ascii?Q?fWwGWYt+jvRcE8aAHJ7y8ZnWG4bummUFs3IRS4LayKCU95IpgA/WEYJuaQVN?=
 =?us-ascii?Q?ruDzA7vw8tRjS2RS0UntBgujAm5Z5Hvrj1DsOOXYud2V8p7I+MJN4FayVqy3?=
 =?us-ascii?Q?9o4K0GSy+mA6TNFtkCQfmvuhgfwHtnUA0g8bbqr32JToaHv6EBMGcN2foeFi?=
 =?us-ascii?Q?wCzT9x+dD7z7dtErF+4PLeHfHJYZ5WQHTqgFVfBH9w3q0/QleQep2HwWc4zU?=
 =?us-ascii?Q?yzlOG2eatUdpoBlFEnRLk09greLZg9TeWwThxqyJXStL/OoUIhQMEQX77XM6?=
 =?us-ascii?Q?CVLqW1Rs1kWWIZpjqvV67j/4+eyOZC04Ins0bL7xoOAkzwnQUI09qCuk3ZPo?=
 =?us-ascii?Q?UJADi2GcKSKLjEjO0XnAMK4xt1VypYa4Uje4Tj9jxAjavkwV3J3QBQd4sPJz?=
 =?us-ascii?Q?zXTMfkm1Pb9AphpZ/7RHOodG4sCszyYmyTF601eOEv6jUHbOPkp2OrpZs0d7?=
 =?us-ascii?Q?7F2TASnXuguodoqidBZHnjEj/gLZJ8lHL3MoE//6BRyyNuzOmf2yS0O2adfw?=
 =?us-ascii?Q?2Y3SQAYxa4nwpfsZM1EdN92z6WMBoWIeC+h7/dd1dXvSYX/M1g9jIKk/mrt3?=
 =?us-ascii?Q?DdQ2DHpm9e2pYq3MCgE/trSed6rNTI8SG57YRJ+NPw2Ie2pF7RliFmwIXTJ7?=
 =?us-ascii?Q?3yER3XSBzch6jbZFUKGjTzN8mewXgePgWwrB0OJ4geDYT7tmiA8ahN+s9LFS?=
 =?us-ascii?Q?jMZ2Y9qPu1NSGvWeJiEDyDag8tQVRrLokSeFJzDMt8c9XjQHO/XuRViR+S2O?=
 =?us-ascii?Q?CgHCEdL47UdNjviBEtE/o7p9ajYgI8tYkPGfflDlaNbnXEMjElZWUYBqwsTE?=
 =?us-ascii?Q?u3gT3U6eCdTUYC22qBDccafAtWIjHXg1tfGcAaAaOcW5Xnjcr1LcPKrE0L/E?=
 =?us-ascii?Q?VEOd7iBGBwUHQgvtF4VLd5XPHMQTvkuS5ely5QIcs6eCU1p4eepuNPhsMW2F?=
 =?us-ascii?Q?lHYqJwIk4jCoaO0lrfCHI4pqSO8pEuT2bNZEEvQEh7vJf0TQKp+BZhyh8E38?=
 =?us-ascii?Q?z9DcH3SvLoKSiBEXpiP7kEwBgEUQHh1qtI8BMYlG7Cd2sjqxQ4Rmh4MBuSeB?=
 =?us-ascii?Q?4nnmaz2r4qeTKkvk2orT02T2Wp/+9NCTLpjq16rysTMjeT25t0Gjg9o7YesR?=
 =?us-ascii?Q?93CSxRERIiaxdacHNaX6vJ4V2jhQw1swXeB4aIk5uPq78TZOBZxvnd+SiEPM?=
 =?us-ascii?Q?c8gU6FaTUj2/zr4MSXqkfAP3XSEAiIj04u8R/Uow8wU4Ir2SK+vFy8GhpVp4?=
 =?us-ascii?Q?PIisU5m1TryxvBK5Lbkugm0/QByNdzXibs+/GcTyL9NrMZeVAnL+xvxsC6Su?=
 =?us-ascii?Q?RXAWK5hp0WnuFkWsLYj3k9dL80TbjhJfGzTxY4UKtuEKyWCujUYKQ4vSBKdC?=
 =?us-ascii?Q?3BaI07YCVjdTaCpcwdi1MpG9hq+zcQd8a9pQrxDGgFnoJidJUAECGqxSCnaw?=
 =?us-ascii?Q?+ervZMTNsCfU1JW4cIYoZ+kYQByIH3BHfN9X8MVh7L2huF50n1KYs3PfrV3q?=
 =?us-ascii?Q?GhGGPf+i7uiuqS5+BcrrYvsKnMxRgjap+MbGMpAz1ETJdzKWTJlnvkU8khv+?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db31a173-16b0-453c-6653-08dabd923585
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:54:48.7937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9slspP+eGxIhA5xtIOoTxkXqLDWZwwtHA40132r64gGl8F4bfmtx58mQECz1qF3jRJRMgoL01bcQOGaVR49gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5619
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030082
X-Proofpoint-ORIG-GUID: Dxlq88IiD3vEnD8sshyOwM_tnXelHYwZ
X-Proofpoint-GUID: Dxlq88IiD3vEnD8sshyOwM_tnXelHYwZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 8cc0072469723459dc6bd7beff81b2b3149f4cf4 upstream.

xfs_ifree_cluster() calls xfs_perag_get() at the beginning, but forgets to
call xfs_perag_put() in one failed path.
Add the missed function call to fix it.

Fixes: ce92464c180b ("xfs: make xfs_trans_get_buf return an error code")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f8b5a37134f8..e5a90a0b8f8a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2592,8 +2592,10 @@ xfs_ifree_cluster(
 					mp->m_bsize * igeo->blocks_per_cluster,
 					XBF_UNMAPPED);
 
-		if (!bp)
+		if (!bp) {
+			xfs_perag_put(pag);
 			return -ENOMEM;
+		}
 
 		/*
 		 * This buffer may not have been correctly initialised as we
-- 
2.35.1

