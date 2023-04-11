Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFD6C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjDKDg2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKDg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5A51726
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:25 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AKB3DQ030714;
        Tue, 11 Apr 2023 03:36:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ikUkWDy2kfzSPKbwWZfxtHoI2L8ovJ6u52FLAJOyVgA=;
 b=HScrPSq/nZzDARJV+AJSasd2sQUQ/0W+JN15twISa5p3umofqsrA11MLoefUsV1nfuoG
 ny8vmHc8rnkErUyUz/8DBFjbzHoCAl8TgFJ9r6smnXVquPhUBvWTF96F0NiQISPl35l7
 QRIuIKKNYIPjc1/iFRVUWISvHii6HNxdCH0pur0Ch4LiscWFKlV5pQen4GtRQbSM/0Pa
 3jUkt41llvKxSh+3g0qTNJEOGSg80Lib1ZgvkS9fiFtP6FNR3bi6E/mIyQOKJGUIz17d
 D4dhSvaI6bQ24dr4rog0nnKUi2Qd3cjLjiUQOBs0dzzLGQ8xTAWWbd8ngxSSsz8TQjxH 1g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvvamc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3FbES038633;
        Tue, 11 Apr 2023 03:36:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbm98nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdhXX4eHitwaCydoTbiTWpqWsaOV2gG3KdA5wcI4h/UDwFCkpDqeLOXYbQ+PwKzUMEzCxuASjrSCPkCpAVHK0AC5q7FVy3bF84+9P63buP5lCKkXNigb4ZnaYZGkmJ0cdE7dwyHjqP/1XEoef5+VyTTBtceF++Q0C87YMStW/8RLrk4D15WWlffFbaWm+mY+wJQWvOpWGCg690s3uydrHqwjutnnQQjVSnqSFwIcAB8rDDNaQKWx6ZZLPQNpxrJCTgS7PbCPn1I2F/GkrHgryPmOEhLLRfKal6SNwl9H89LBzOOdI2iF6r/DgA9aeYVyN42XzBF3WlbagAdP9Dljhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikUkWDy2kfzSPKbwWZfxtHoI2L8ovJ6u52FLAJOyVgA=;
 b=d4QFi18r5Tirjmdzrz5SwoqD9xHB/qLQhgJfwL09IPHb0E3wWJXoHT7jgmSfILegXT5GI2USKRPzU8/e68/GWDsgRpsu8/WLcid6ZPeLz4O/baCXOKZ2RIi+RlKPp/tfP6ql3L6W6ANew4iqjuYYEKahbofXSI0zVZMp2PPMBFJ7LBPwZxOi23DFMMzRxuna+IYz3SkqY4eOyGF7S45fXIzWQmVQjdRcmS0BGw3YxCxVoE4+pkxZ8GKBV2K6dGGF2YhKuExYUSaFMKfjJEWSRrJCv0i4whDF02GoGAeBj3lA769E+wkme2S9bMP8ftBq3elXmDPPA0n0Jq4fOCNlMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikUkWDy2kfzSPKbwWZfxtHoI2L8ovJ6u52FLAJOyVgA=;
 b=fGQuaHrQ+F+aNlz+Is2V+RUtJQHsZEXfDofCZvz20Rtadxm6tZElTzrHG7/CrQB/L7N2Ps380GUaXPBuO3z7QLcmTYsIjuR11TdQPdyjo8Z8nhqviNR1LATRAr3X5trB1Kkf609WKv0gGEOOVKd4FSkMg59PhtqM0RKk1abH6qY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:19 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 07/17] xfs: only check the superblock version for dinode size calculation
Date:   Tue, 11 Apr 2023 09:05:04 +0530
Message-Id: <20230411033514.58024-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: ca517c35-6f51-46d3-957a-08db3a3de9ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oJe0wKJ+Mvdag6+uSGtjwzDnT41LIjj0h3u+v6Anxk3X9ykLZctwCUgLWQZsjYiqQIodNmE0cuRwC5MmGTBNNyJyNoUOHFPu5adEaCMcZaZ1JXRL1O1B//Z2cXvryAlQvYN2phhP1p4Bk0CKpXkkeTZjYXCSQ2xMJ9gSI7ocom+ENl5ckoSr3xbNlQpwyKGyL0ZjQPe3KdAXd/El3uZ4KSLJCmApSQpjqRY3ykheVg4ylmXPupNOpTx9S+AbYpuHBY8i6nxq4BhULKbT08JLuLgG8XOzMI6m0Nv1Wjdnk5qbgC9RT0old5lH4FCPj+bIfdlu+vZBprA0jkbDi1qTG29Xr5viDlOowVbak6HaDQZFnA9u6XMQBeRGLN55h1mwxXlAqm4BGltVtu0Px7uGbW0PXi9JrP/aMf+pwtlHYjLh4CEwaJ4qe3aihX8DO/fMRD6tKbhPYf+uWAQIalCDuOSKUNPVpKLbfCT8A4JVaFEYxVZMYPtxSW0JN/SdYLvbSNuEpew//OnzsaHI5m+coxjSHED3Dfv4WL/hmj6qj4gViikN/1sICl0dqcMeKXGs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ACDBFGfbHKtYHxmW9xkJxVc9OUrwofy8ACQ955UYrF/v8vBQbUDn4lNIgPan?=
 =?us-ascii?Q?gvr/kalClBtNcdP02+nZ8MnUNcCSY/wXEIk1twWEvmveJ2PVme+whwCTFkh/?=
 =?us-ascii?Q?97818OSdPj/4BJ6ce2ZzuA+nySiKdQnDNE/g/w4OE4EYT3Wfd0Ja42pnNZ/W?=
 =?us-ascii?Q?ivETHu9h2XXqRx12m7W1SfA/dY2jHxRmoQjfJczAUvZnEpxxxQuEcZTEf6II?=
 =?us-ascii?Q?30F2o2IrLZpDfcMAXv4AvhqD6WM/xEVoasmDZ0WXpmn8srgTN8ceNLGRytil?=
 =?us-ascii?Q?kc9V2RlGYpZ7oYiO4KEZhz4O5bcpAysxfWuofJgB2joNZ4MSS6li7PwpjQZ7?=
 =?us-ascii?Q?Oq7KbvF0v0duECZgwwMSBdokAr/O55DDXaPN63HU4eNLwBqVD3KCW/vZmm1H?=
 =?us-ascii?Q?FtTR35cW114dmT4nrBwBdZmoeFthDzNnQrNN/jqBfpYYT5Y+nCi3yJW3GaaF?=
 =?us-ascii?Q?1o0WQqIyF9brfAsPZugUDrDbMjxyi7kN9UfnFW8EBGErwGX9LJPQEQKtdP2I?=
 =?us-ascii?Q?2r7tnUADDVkuWl/SCwwFeyGPL274ZdX6MBHukgBn3J2AhvbKBlzhduGX4rOY?=
 =?us-ascii?Q?oNU1vMp+/IYDvblfHI4CZwB4c9XsffZim0WlWgthJ/MHlHfOb3o4jcJtkYUG?=
 =?us-ascii?Q?3cUxXhDeASMikyFbljkFCVG2Dx8zSAeUGbfaEQMRBsbP5yZyO6unuCY9gRpX?=
 =?us-ascii?Q?5zna3hoxIW3RMmVDq3iRWugSLiPn9yrpwvr6TpBVmxYQDfajgbu9q58LcD17?=
 =?us-ascii?Q?8a7uqUidrAv0O3L4Qaf5moI/8rOotUFD1STgqeqNiM5Bgc+UKPZp6JHupKvE?=
 =?us-ascii?Q?yZvbg85VFpLVwuanBOqmZk4OL4uQ1mdroElXqIcGi57IMOJ5rl/PnDGgmeHM?=
 =?us-ascii?Q?Lb3vauqpn9Zp690UxZc2nBuWY4CRAjcZo9NEaptx3BXmeP8l26ERhhqxTG20?=
 =?us-ascii?Q?x1eTVmcSXUPx3IUeJFqBX5ig8P58FZ1ywn+MHcvQUn1L3kFZDbahdVCSndS+?=
 =?us-ascii?Q?5DJThYxPCF0hLfQHpThbODkwetJVhlS1LydckBL5FNI3qHBzk4zuQWyRTPi4?=
 =?us-ascii?Q?DMQFe1ffKo+onppUaAiabGUwW90w1jQ5lrEpyIV7M4sfviAsPLVojC0+UkPT?=
 =?us-ascii?Q?rvmvXxxyg3xo11Wsq8Sf9BJcVQHpv3+b02Rqh5KhBeMy8EQUJz7dxByd8oM4?=
 =?us-ascii?Q?p2jOCKaxgLNJIUQLHmRTExB3XI+zjDReXTgQJI0FjrRzZpW9MdHKvJKNdNhW?=
 =?us-ascii?Q?DJFSY5bowO1BsXgV1XICX/1c/uEwgmcAo4p7nF9eMJfOaKzcUEayvBe70R18?=
 =?us-ascii?Q?sFr063Pm6TCxuu6JMPlOtKWJUVQzfyFPMCdm9K6/8RNvIYJTsYHytWu006xe?=
 =?us-ascii?Q?8Wk6b2Sb+QSQjwRZFL4cWuMqi2ydfkWoepGhkrk12nic+UxpRcReVoGwPXtf?=
 =?us-ascii?Q?HiyYg8UycoQmLQG4mM7Vbvd90Vv6gHgQnz0JB4XXFPIOdPMDOverJa1+jkmO?=
 =?us-ascii?Q?Fv+HAwMl3+meLry2HnFa+KDVsE4LerhkzcBXpVRUuo+DLku8byJ/TkBsXC78?=
 =?us-ascii?Q?1R6UvobgO3wJn9WGvUF+VIfD4zbFCxxeOpDmWGgp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LKe6xy11jegbXMef8o+f7diY9Lc5NEg1QQBxRAxs1r3gi+G1XQimaGL0mQx0LLrSZ6MP6+voghV6Z9yqTAHP+fL7aOza4BTN1rAoiqj/SZ/qCdVtreL4RXVByj6bamL4JZ19ltZ911mpQz91AYZ6kKpl4LSrJ1pOEvG4Id+m3mItrPEnQA2mGC6eI72dTAoAh3BZDJ6auHTym5ASKF00tPldMm/OOFkIz9UgAiOlWT1MT0qZzZEDnIQ78H5ZUE9jhvhm9DItDlNxEPOUheUHqhFw2D2/uutCnzmh0o8ds9k/uaSXpRAkNfDV4bQjC3l8IeuOpRIsIk8OPIC9Ls82vUb01O4Jjoz424oxlFYpqDA7HUdR9QeqSDkVomGlcYAehqyftLWLmu2UT51A2edwpBYeh3UNitZczmIOpDsWmPpw88DSheZGgNhF1o0H+dQrvCcFYNZ70tF1pnSq2rI9skEyWBcma/nEGWL5ksJC4WaUEKs4nSgSseCgIeFxYjddbDwrN6lPM0MKkEoii5LDv1L+3pFKPk3W0KCK2J9+szao7fHBWINXE4lGz/7BVGPCckY22Faq1pIVS7vX27scR7KdrlY65cUP4fp+pEipOWRPgYOZxcqqMayLU4+OPOG02TpQZ6qpnpR9Z7o8bZzcLd4fhtSE6RUMN4DXHhbCzql+RY6i84diOppPyUv4kznbYU+rQQB+ApbRdbL1BZKJIn3Sha2R6aYpXCJW7saxzC78ZRbgFSBtDl7ff60BHnvZvGrukfb7HWd5atqTqZcOqN4pJv2ROssidZ3kQS4hlwY2CcAfODZPPawrn4cWXItL
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca517c35-6f51-46d3-957a-08db3a3de9ba
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:19.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7pdCk0sotm/4qzbOqQ/qYKB+ag0Nw+2/Avs3G922KZGLsNGgV43tDqgS87gmXXAlJS8/i/T6CEUoDZcDnfO6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: CgmTrfyBmkmkuP0gXxmmQPpSdQjqrpOG
X-Proofpoint-ORIG-GUID: CgmTrfyBmkmkuP0gXxmmQPpSdQjqrpOG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit e9e2eae89ddb658ea332295153fdca78c12c1e0d upstream.

The size of the dinode structure is only dependent on the file system
version, so instead of checking the individual inode version just use
the newly added xfs_sb_version_has_large_dinode helper, and simplify
various calling conventions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  5 ++---
 fs/xfs/libxfs/xfs_bmap.c       | 10 ++++------
 fs/xfs/libxfs/xfs_format.h     | 16 ++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |  9 ++-------
 fs/xfs/libxfs/xfs_log_format.h | 10 ++++------
 fs/xfs/xfs_inode_item.c        |  4 ++--
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_symlink.c           |  2 +-
 11 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3d5e09f7e3a7..f5b16120c64d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -456,7 +456,7 @@ xfs_attr_shortform_bytesfit(
 	int			offset;
 
 	/* rounded down */
-	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
+	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
 		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -523,8 +523,7 @@ xfs_attr_shortform_bytesfit(
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
-			XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= maxforkoff)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d900e3e6c933..1e0fab62cd7d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -192,14 +192,12 @@ xfs_default_attroffset(
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			offset;
 
-	if (mp->m_sb.sb_inodesize == 256) {
-		offset = XFS_LITINO(mp, ip->i_d.di_version) -
-				XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	} else {
+	if (mp->m_sb.sb_inodesize == 256)
+		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	else
 		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
-	}
 
-	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
+	ASSERT(offset < XFS_LITINO(mp));
 	return offset;
 }
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c20c4dd6e1d3..31fa9ab2ab61 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -963,8 +963,12 @@ typedef enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define XFS_LITINO(mp, version) \
-	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
+#define XFS_DINODE_SIZE(sbp) \
+	(xfs_sb_version_has_v3inode(sbp) ? \
+		sizeof(struct xfs_dinode) : \
+		offsetof(struct xfs_dinode, di_crc))
+#define XFS_LITINO(mp) \
+	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
 
 /*
  * Inode data & attribute fork sizes, per inode.
@@ -973,13 +977,9 @@ typedef enum xfs_dinode_fmt {
 #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp, (dip)->di_version))
+	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
 #define XFS_DFORK_ASIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
-		0)
+	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_DFORK_DSIZE(dip, mp) : \
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ddf92b14223a..391e441d43a0 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -339,7 +339,7 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = xfs_dinode_size(version);
+			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c4fdb0c012aa..3505691a17e2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -417,7 +417,7 @@ xfs_dinode_verify_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
+		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 			return __this_address;
 		break;
 	default:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 93357072b19d..e758d74b2b62 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -183,7 +183,7 @@ xfs_iformat_local(
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
-	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
+	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
 			(unsigned long long) ip->i_ino, size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7b845c052fb4..a84a1557d11c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -46,14 +46,9 @@ struct xfs_ifork {
 			(ip)->i_afp : \
 			(ip)->i_cowfp))
 #define XFS_IFORK_DSIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
+	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
 #define XFS_IFORK_ASIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
-			XFS_IFORK_BOFF(ip) : \
-		0)
+	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_IFORK_DSIZE(ip) : \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c69b320..d3b255f42789 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -424,12 +424,10 @@ struct xfs_log_dinode {
 	/* structure must be padded to 64 bit alignment */
 };
 
-static inline uint xfs_log_dinode_size(int version)
-{
-	if (version == 3)
-		return sizeof(struct xfs_log_dinode);
-	return offsetof(struct xfs_log_dinode, di_next_unlinked);
-}
+#define xfs_log_dinode_size(mp)						\
+	(xfs_sb_version_has_v3inode(&(mp)->m_sb) ?			\
+		sizeof(struct xfs_log_dinode) :				\
+		offsetof(struct xfs_log_dinode, di_next_unlinked))
 
 /*
  * Buffer Log Format defintions
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9d673bb1f995..2f9954555597 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -125,7 +125,7 @@ xfs_inode_item_size(
 
 	*nvecs += 2;
 	*nbytes += sizeof(struct xfs_inode_log_format) +
-		   xfs_log_dinode_size(ip->i_d.di_version);
+		   xfs_log_dinode_size(ip->i_mount);
 
 	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
 	if (XFS_IFORK_Q(ip))
@@ -370,7 +370,7 @@ xfs_inode_item_format_core(
 
 	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
-	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
+	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
 }
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 598a8c00a082..884e0c6689bf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3089,7 +3089,7 @@ xlog_recover_inode_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	isize = xfs_log_dinode_size(ldip->di_version);
+	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 97336fb9119a..3312820700f3 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -201,7 +201,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
+	if (pathlen <= XFS_LITINO(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-- 
2.39.1

