Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC6AECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiITMtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiITMtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C946524E
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KA7pE6024487;
        Tue, 20 Sep 2022 12:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=UqqP9VxOW08GkfmMsxNaY/OCDWimXyWXnCoM2PGS+Yvxh5K1xWAv4xemihKcOvy+LQYD
 Ocey56teMJMCFbEL9emzeF2lnCA9KxUZKXfzuVyBvqOnQ5gZrQ5I5iCo14bY85b+TMzm
 tHu5OavAeHEW13FgyySCL/U35kXtFU+wIXzEZr+HuIgUQp7iHbFzeOdmVpDRtoE217at
 cMtZyGij9UMiTLA8GHoFXTgWE+agw3UbljXjXgqV3l2GM/N5tApdKOWeN5SKgRwbDUqY
 bEQAh3R4zLZ4j+I8uab+9mBOf8HtTrQZotFJdD0EwEpPMJrSPBoGVpAEQhb5YtAfQtHT 8Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stexdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:48:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAroHZ035690;
        Tue, 20 Sep 2022 12:48:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d29qed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:48:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Te09TlNnQRuATfQZVwBjEOp/G7hk5SkP+4YufrYIUkm76R86pBDi8XYiaMNeOoj75ttaJHzEu52LLUUOnIPlQhqfh2T/teTRcvKKTHVZzypejEyrpHHs5SHqqV1z5IID5apK6mfQwNw3L5mriLutncBfwCzFCisH5xbY53IJaEdGSWQ5OEuw4fAGSDKEAXZygh4k6rQsLtz3DHHhgDv9ifiQuiaaLSYlZTL9z1Y687WsDnIOi+KuxmmcffJqymhJ+bOf6ukrDfWLS6dNSxyPKMPe1JHFWz5px7YMmZeGovij5mjgjGHOGlcua3QB95LD2Gk1jKKjuXS27y17wQRIjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=oXsrWJnmVJjqEYrdGKesqXdVBSRghRHlNrSBYoGyf7LrzAjW4Lc+k+N9uolckCcll3UCFxQe2WDm1Iv6RF4q5jA2GPEkI9RRJrA2eX/sVl9BG632ij4eoOsuatAhdmtWPnXR6Qtwqjv/hM3Us7e/M5ZSSIM9gwIuZQ3K2ZS81p2PuGMwxS5xHgBwy3fDqAvbCrgDfvA3rNprrugiLWsf8qSVeyQoCowmsv7WpcXCPyTWKIZ+9vOKpbDr5bpGtgCFxEBcWd1HZFphcPA8M9RYXnCyG+7eDWGLUY6FhgAHubQtu8l9VN6B+higvs5f+PQLsIs+fD81VF3MZOmMxlj1TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=m7kjAme0+gO/jrL/WrY2FI9HN5nrS2xKY2dvfdzF7tGAxl8jtLLBvY+G1mzk6e5rq/NETx1tvSmhsW9CClhOo3h9rbHtFKB26vCfCYCb2Y0fcf+vqY2tsWNu6h4CCfHoLgscpY8rC4BleumOY6WJ6fJnLsOIZ5j9e3yCAOXPaiE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 12:48:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:48:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 01/17] MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
Date:   Tue, 20 Sep 2022 18:18:20 +0530
Message-Id: <20220920124836.1914918-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0039.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: d766985d-a418-4728-bcc2-08da9b0676e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWS3kFX5wXP2T3pH9HxT3Uc5BeeklUiXeaBYhKgodcLpHrHzLIfqS5oz2e2bfDjE1PRuP+MYMKWXvVS4usENxp8BjvHfuXsbfk/6sEHQj3PB7nc3Jf+0E5vhu7TfS48y2ow56vmZkXNQ2kyEzAzPPMBQEo9p5jwTgAqZzvm6eH6cMjXZmXWwZIKrW+avxhO0dC5zBrHx6iOC1REK9sylFIZfdOHdbJuG+9ZEhAufUqnKQVHthKOMRQIJVQhb/+dcK6ooT5j4kKo2YmoIMSepH+xwWastUbfgqWzZ2RU5Pn2Q4/y10AJkl9unNzXyiOdrigjLQiUjibTwvDMIdTt4ePmcXvpGHOSHTcQ2q54KYEYR56KhuOdg9vo71lhb/j1Cpf256Ec4VgHP/LZi5GWI1BJ/uvjKqQCiP73QCtCj0jyyYg48z2SDC1cto2lztRDaSLdH5vjYgqCabGaBqb/rC8XD0AUevokaYOj1wHkZvWuxrj12eY8TtluXHWmaIV1AXLo4kH03ftj/0U0S0hGQInsuXawPUkhaMzOMfmkSbnKxbCPajaaHlx+afoVWJ9OLv5Al1SCNQIvwNsP0RF2sSi7wNwcH0BhzhEQlV3tMZ5wqG2jI690GUIUT9lufeayGZ9aA7uyYKSZ4zmavfIRejGWYLejkyJLKraxc3sxNuR+1NbGaZCY6xRPN3ClfzsIAoTKYIRo6hc4HzZMALtk59V93GSIyDIUQlxYqN2+ICG0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(5660300002)(4326008)(86362001)(8936002)(6916009)(316002)(38100700002)(8676002)(83380400001)(41300700001)(6666004)(6506007)(6486002)(966005)(2616005)(478600001)(186003)(1076003)(6512007)(26005)(36756003)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XOyASxbg81KNNelj5L5xgNlmuZvIaYbo1w33iRqrjwrxHo8O5Tz40fUxuaR8?=
 =?us-ascii?Q?LuqWrTQzzzplHrLSl1NxUCDshESz/eHpIaTsern4Bt1nw3VJYmj0NqB06BHt?=
 =?us-ascii?Q?qS0P8yWhah5RYRpijyfD9JAgofQ0odRtpulp7c1dMTVkwJ8hj3FM7gikGqz3?=
 =?us-ascii?Q?nrMcjC9EINDvv5b1b8pbNN0lOGr66UR/gFEo5wbGbAktrnA1oy9j1FPQ7V73?=
 =?us-ascii?Q?IU7sEQ0SA1uKgq/Dw3C6Tje7+/3mgOiDXmlGCOuljDPLWVTL0EBqXPzrtmOH?=
 =?us-ascii?Q?VjQ/N0qbnTNjfhYE22rZgS9ADe+Y0G2ncCRmdMmdzv1M201OShLOvjQvmpEo?=
 =?us-ascii?Q?50TQERgX8bBVoQnmOAaGbq7LxA4RO3xAlWqWBrUxxj/Ws71ZHP1+jVs6mUro?=
 =?us-ascii?Q?YKI5H1n8riMmEvHWYe2mrGax/tgHueZ08ZGs67qDRsaNJkFYN2TNAd4Qfxfz?=
 =?us-ascii?Q?NhSgbhP60tKGTxV0r4cmpdPrDLgtAW/RUZ2Qz3GnMFxBbzC5qPUbByo/e8pF?=
 =?us-ascii?Q?luaiMEfVFOlfgsnV+kYw9YhQPG14Y8DPJmWly4vCmb/GLwTVav3URllHdU1i?=
 =?us-ascii?Q?br5cdnaI5MB+aBX1BrLLNArXdIQT0Yp8CMWWm1+XTTO8Dc4Fmoor16sO5hZc?=
 =?us-ascii?Q?U0UlU3ilGRZ2Ewit5JPB9u9+CB46fojMf2Om6KN+CRRMOUminXriaqDC6PhH?=
 =?us-ascii?Q?H4MDRgNwzfoQPjMnLH3ShL5TyZeNal2VE6FArwZn+Vqrxm+ewL6TVVle5R76?=
 =?us-ascii?Q?JWDkoJuX2qWGQjGtetBjwMUS+PId+C9orr4Ets/vTzWTRoeiNXtRly3nS7AQ?=
 =?us-ascii?Q?4iO0y74xTU3jdPazQj2aAGdz5JEC5rRMmUU3e6wPcD60dCa/UZ07LXEMTIoy?=
 =?us-ascii?Q?e0rFxNAJ2d1RXHdm80LSM4eaf62OzuD1WVwK4SpvV33/7bQjGKOJEMlHjjJ6?=
 =?us-ascii?Q?ifHG6wlS0PuXUAkSAodPQdewV/hg14lohTsA9ZSQzmKe1Z23f2u2K9NjiqbY?=
 =?us-ascii?Q?P5AE1p+vDCuKZa9Kq2+guMVPc59EZLPtV3pa65nCNh0SeD/6daPpsL2ElWSh?=
 =?us-ascii?Q?KtCWVDROvWfhmGhfuQjX/YUSOmDfepNZLrEYtEcnje+AQH9uw3uESG/2a5X6?=
 =?us-ascii?Q?3ffzGkM9kaiSTHoZkzDTEEPLg31NUVJviiIYJv4x04OdblWZB/f4FImjqw7K?=
 =?us-ascii?Q?Ii22NHuOh19TxmABVjWTYZMXwgMrvRAPVoAhorl4XN5itt23ikmLQpcBDgiT?=
 =?us-ascii?Q?44V5QtTrzjECpvK5D66E3n6iYrInY377dhA3V3s/1KllA8FO2Z8+u24I5+0l?=
 =?us-ascii?Q?VSWyzzgS+FmgxRRrjcDAy646wpdn/nlZP/IpEvk3gDvlSDbZVbwGFHjdIBYR?=
 =?us-ascii?Q?yTjx0fVKONwMXmRJWYE374YIVSvRS07mIEk/N+RumaeAECCeYkfS7FPuw2w+?=
 =?us-ascii?Q?P3f+J5Kg9rb2weQWLOGfSH0u6hRlgY78xP+GT/94TxOw1Y/DtnjY9eVwIQz2?=
 =?us-ascii?Q?zlRnnra5Wz9alZ9wEwrMZofDXm97MtJEknBgP9W9FZoRdCE7R4VeDBhRqTDd?=
 =?us-ascii?Q?ENfL4TzKC0eRYaQCTUrL0v56n+60ZTuysO0ZtU55?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d766985d-a418-4728-bcc2-08da9b0676e8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:48:49.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uD4uoHHji4diWW3wXPMCHlvF3U9K45Zfl/0GZiD/HFhkRTGyiFhphAPWBTVTAR/xHYvafHLPB80dEUorWBI5zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-GUID: UlvU0HAgFMWYbXft0MSyQ6PjvQbdnrXI
X-Proofpoint-ORIG-GUID: UlvU0HAgFMWYbXft0MSyQ6PjvQbdnrXI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an attempt to direct the bots and humans that are testing
LTS 5.4.y towards the maintainer of xfs in the 5.4.y tree.

Update Darrick's email address from upstream and add Chandan as xfs
maintaier for the 5.4.y tree.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f45d6548a4aa..973fcc9143d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17864,7 +17864,8 @@ S:	Supported
 F:	sound/xen/*
 
 XFS FILESYSTEM
-M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	Chandan Babu R <chandan.babu@oracle.com>
+M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
-- 
2.35.1

