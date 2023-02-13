Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D965BC636CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBMEGe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBMEGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA8EC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iHcJ018552;
        Mon, 13 Feb 2023 04:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PL75Ge9RYCZ5dOJ+09kknGX9yy1pfcoswPlNoIuQO54=;
 b=b0Nrui35IZnduBF9jZlvrMRFVlK6K8vWZO0/x3PIjpPZjeGubXqRBMLrJE9eYIVoKcBs
 brnzRR68HtJjjqiLV0HfQx6gBn/alFT6QqR2aZsM718oqcGtom2WTAIYtVHomwr1e57Q
 ptN0ko8qmCkH4RqHPMeI7hLE9us++a5N0kF3PYIyKF1V70PPliTC+gqF0Hecv4Tn1L4b
 RUFeKcy7ZSTzij7qOWbP5EdunFFLdi4r1iq9KdoSgfYyQ0LAziJ+JnAWOTqGx0DE4l8w
 Fj6g25INelouDVsQfxju74+5t79ihD/qgdhITqxcsBjEjBUXXYot8ncdTivJwmeF369h UQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9sv5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D2EoV0013540;
        Mon, 13 Feb 2023 04:06:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3kgnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqX/jHLkzf8UJkMjChI1M6SMXPkkc/pQ3yc56dD6R1i5k61EvU0iwN+y6BIW0UnTdkttEEHyyeqtHHq3l6b7BFO5wtdAdLfsxibqplYXApydM9N9TFYrrXivW3JnrO3n68ixcSsbVGpTZEpz/YiPFJXw7HdYA3bT3Q0DatLa5DZz5s0YmDmGOOE8shaNqbx2LclOqJeJbyT99aKB5AZOAWZ2K2NS5goruOhhyNJ7LPuuDbzwlvCuJnp/KnCILFYT7PjjLlOJmilc6qZJw1UZ54IcxiRUh65m3wi5irjkSdzPJYbL/Gbldg/loU3IxD83lLPe3OAfCd8t/XJsS+w/yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PL75Ge9RYCZ5dOJ+09kknGX9yy1pfcoswPlNoIuQO54=;
 b=nyJ3KRL6gVdbz9Pi1efy57fx+tyJjImo/JQH/r9mcs/X8kAcnKMsGcgBW5iOgXgRfsaq8Dzq8tKOYjectk0pOsLIRNMxUNzmbfhP2b4S58tdsOu36pyxCsd6WUIZjRtURC12Nk1wCQPVho/y6eZdIdcANw0d5Xo36cokJ127hMASV+6pDUJBEieMxrdsW8l9tzkvV/kFKESQByGgMdcNeHAmXRm2w96zZ59cXUiO1plqrj1dSpW5CCH4HqD80Q3PS08a2IuvNk8CpLUgxK59iV7DU4Xcz2z5eKDrddx3bJ2cgtKH/ukL0F0348RjxbpAMkgjDROmrZxvEsDvi+Hm8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PL75Ge9RYCZ5dOJ+09kknGX9yy1pfcoswPlNoIuQO54=;
 b=es5i+LRoUT0evaxkLoqU1p5BqkUBXdKKAVgGOOlVIexwEu0/MH4eoR+O32ii1XofkFhTD06kdO3UMAnXcln9rxF+Iy//Ft+hbrZhy96fbCvwCB9H3AFdXSWA7ypbObAowFbIarfFzp7Spds9qOPh0sSa5PoufF6nQ0x1V3iV08A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 12/25] xfs: xfs_defer_capture should absorb remaining block reservations
Date:   Mon, 13 Feb 2023 09:34:32 +0530
Message-Id: <20230213040445.192946-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0030.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b5d7c09-ffe1-46ee-687d-08db0d77ad1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59MvBtVvI4+42YpUIZaQRYzhtgBQcS7zlXubVGmvxKoZ8tLf6WbSTbo5EuqRqaFvKMqyYvrdHEenSIO9MiNXpIIrRLp9NFTuu2Qx6wQPAaxRezLwUQJ8xGe6WIOQQ1oz4JpBokDDYrWxjMaxD5DYA7JVu/CbWTXNoWD9L4Fm1yCL4kT9l+OIpL6Tpldf85lmZovcWb/NN8HAOUQZnYVHmIExj2htj5WIY6Ezgq9uDFHSC8c2S+2uwRXRHf2URSSIITVmMvamr7nQhDkdpi4OT60sz4WUJSOzhq07lHA6/BMcXyoVnxpnJSDhVfo4II06R0NS6onZuI6yceUQTjWd4nxfO43947x8iwJEE1pdsJt8gLmkHuHWKn+2yCPGCTy1PIUXZT0RTJJPY/PpMR7pU8ZkbrHNgVYVrmWX3UFI39QOuiAFEGRVq9aEpITxajCKxQUD8BIw6nUawcT3z+GjsEWWt//JSIkjxyNvUSjGsLe5V1ty0FwRUbyIy52IkDWxK0O+A5DgGzYGEjkRs/rr4gw9Ko3YTBsd2EaeoqgS5oq4t0gmJyOhi91DNXKAi77TdF1oyzCFdAdYBUBjqRZWRLOAUlQfDwfdBdezZVLkPc+QNX3h2mHA0J67mxuIxsZ8UkDOw3IiQjUWfSXIys3/Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zl+2f5iynXl7ZwhlHjOjAZmO+NaELBcf8KJPT/Mre8C6QQ3UP/Y2wwPlZezx?=
 =?us-ascii?Q?Xdbpe89sCwGvdMxM49IJ875jUiYX1Hscd12Y1VHGkh1OZa1bAEMxZIcT3KHY?=
 =?us-ascii?Q?FXs4qUX8+tgcTTUZdLaXMV/TcB234m0dw8GJ6Dl9aqZeWQu9X18vi3VbaazA?=
 =?us-ascii?Q?suG3PTfsjJh6544uyypI1P6oOnyU9NC+e0kWgDtQTp/1DVIXw1XHnl6fJTdu?=
 =?us-ascii?Q?VeifM8mfqydXNXABI3NfzB5kBx0NXyqTyluhBYx3cCu56bO1UI84zLoWxIkv?=
 =?us-ascii?Q?2eJCLigSf6xLBY5i/TYKDlegAUwBx0fFi04HXPXkSGyQ3VfDWaTCE7RGDWvM?=
 =?us-ascii?Q?3lvax/WsTfnYlQ2l5k5A9rghBsQ8fX4AaA/IoV1lmUUzMs/1zR3U4isE38pQ?=
 =?us-ascii?Q?KHUfDfv2L1xSrpfHXkCz1loVO/m/uJaqYYcpFA74rVEO1HK0dNA4RE4nu8TB?=
 =?us-ascii?Q?KM8j2DPMrPRIj/w8j/Psd1WKb+Ly1IDchWJPygTgup21RATrEyIUM7/LOwhM?=
 =?us-ascii?Q?QeD24YSICH5tto0PFTzfNSlO0D/SVyaNJ+xu5NJTvPfxbnyWQ90uT6GRGoGE?=
 =?us-ascii?Q?NCqEHUgSVnQngugjZC35JQiT3NFDKs8NzN72LF1NjqIs72zsBJZUjNMS/P6Y?=
 =?us-ascii?Q?A1P0K8JRQvxeEPSt2Onw6epDf+voD+8UGjvwN5qNm7JF1dTB4m76qhQdsaL+?=
 =?us-ascii?Q?0CpfkTj16pGWPS2osx7WEb+xb64hGeUdoVyupK8LJQssnOzZQK+sKEiPCvJY?=
 =?us-ascii?Q?PbQbKhJF3CuKPGaUQ8EGYjvm/LI4cZwEN/0RrXriRrkQZgHCSfXxz7G4arvd?=
 =?us-ascii?Q?I3oJXVRJLD0tWxTbx5bbHugAXB8nS/y5fzyRC3z5SmWX4aWJ4pjyARpIPxP4?=
 =?us-ascii?Q?VhhQykfYEr+QbsTcgjDKEYSyPF6fE1D3RrboIwRIrTS+QHRvVjK4y8uspVS8?=
 =?us-ascii?Q?GhQAH2KezHSPsoUtq0ne+tMXz+fUB+KTNEFysmE74vXK6pHuldqvuq1YvUZ8?=
 =?us-ascii?Q?haUVN9FWGpNPqncDOQfUq8jzHC4G8q3y4txS8UXPirp77kf9DExY5YbQWd8b?=
 =?us-ascii?Q?QN1MSgsJMI3AumYERqjDbzgapSQBvWw+nZUs+mOyOA4gsBgCFTZi8ru+Vbsh?=
 =?us-ascii?Q?DHY7qA/MP3HbXXogDy/h7LUBQByS1ksaozTb+RRZu7IlJfShJMuMHJixnHLd?=
 =?us-ascii?Q?gDUOBa8rdVdAgtipR/7hWh7YqJ5mAJdpDpzhE5w0GRCPIwGiLDC+SJlYzZK+?=
 =?us-ascii?Q?YVHq6n9rkMma901PRd/cZDofWYhGzKGM2DV3oFbzo94Y/JJf0b5hzjfZg0h6?=
 =?us-ascii?Q?iOMM8CLk57SSMborDnJY4OiAkwPW9tZEoEtVTLJiYwe6vkn+ypBDTYcD7wbs?=
 =?us-ascii?Q?JeDmjBgiD9bwWJhED9YOhEzIFZvkSu4uaU9vGj6q9DNwIK30LV25r8tNKzaR?=
 =?us-ascii?Q?JnTxd48UpUM6WVhcfVqErhM7TVeOG5yyHPe7gQ9PeUH0D/IxnlWwk8q1CO+6?=
 =?us-ascii?Q?7rlBYHBCcP2NRd0NbtEutVmlkY8oUN/g62lkHraz2Y90Th+j7NoIXMulhuXQ?=
 =?us-ascii?Q?VgIeuWp1IqrGCjQ+dRK7ny2ltQ6E5apzZcNrfSoEux9JOOVR7WGKZSBx8jnw?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zxAZZn6D6vK6VUKRe7NG6uu6rGEUncLzu4Zm6/G6lG05Mxt/W3rPECzABxwazMGELz4XE28tntLRul3joszL5yLww3AEpAZBg0JuMRkBkcOg5q+MHeJ6iyU5k4e9QH4qR3MbzdLPxp8bJCVUd5J9RyALT31TFxWyarx8A89ewthyDQvao8OU0NAx3P9iCSbmS7E35IW7RynvodFYeVpYAh+gGXyAn44OrEnwV1siemi7QUH8zfIQdErGV5k69NjCpNbXki4eV5IbIwWTQMtEvblhq1DcCIm1sNJ7sHoGjUk3N3eK9RXphw1U9I8blksQEYBiiDm8+1yJa17UQaBWCWwqlwHIbLhnayENF0MwppIStaWNHpnPq4DUi7i5FR6zxnty1fMQSWrXH4fkSeXt4h/iTFGjJkaKOjH4q/K0jQkWfFhb0c0G+SJmQJcvsbEAvx+c4s3yv2wv/NYg9fPAykPfIu0GqiFphHzGlkHF/YXpf2aSH0JOcsx8Nnnz+Szh/aLndbtOCcg9SBKznQVFG+B5c/gwMC03Gimf5C+cT5al76lRdKG1UA7H1VMFJiccHdf0seqbgkV6IQgH9LZcuy+deSvfU4QMhl4kUjU6qrRP6wA+i1UBpwUjnwF336TpaigFK7zHe86XlLod9qRWQHXDZfo5QfUwUy0AFws7DndCsOnw31LntSoIAjceKQu31wmZB5YHpNaeZST8+uoFXptsf3WDJDqFLVPvVUaJ2BAgaQ7t33ZuzJkw/HPZwEmvH3+SVC2oZL6oFP8lHzIF41ozo+3VI38MAJf1ClDFfyZ6nHN9UMkwUGqbDrz27lUH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b5d7c09-ffe1-46ee-687d-08db0d77ad1d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:26.2680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8S7+7gCevHIEBGpVikvtfwpapYf9CUoMg+b5TNMmOX2g1mcJXBcJ4mKuIT7/OvvD1Iv5hng9CnJx7xosFgyOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-GUID: giJ9qGV9wLfRDoq0qom5bLVhLmTm5Lw4
X-Proofpoint-ORIG-GUID: giJ9qGV9wLfRDoq0qom5bLVhLmTm5Lw4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4f9a60c48078c0efa3459678fa8d6e050e8ada5d upstream.

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the remaining block reservations so
that when we continue the dfops chain, we can reserve the same number of
blocks to use.  We capture the reservations for both data and realtime
volumes.

This adds the requirement that every log intent item recovery function
must be careful to reserve enough blocks to handle both itself and all
defer ops that it can queue.  On the other hand, this enables us to do
away with the handwaving block estimation nonsense that was going on in
xlog_finish_defer_ops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |  4 ++++
 fs/xfs/libxfs/xfs_defer.h |  4 ++++
 fs/xfs/xfs_log_recover.c  | 21 +++------------------
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0448197d3b71..4c36ab9dd33e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -589,6 +589,10 @@ xfs_defer_ops_capture(
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 
+	/* Capture the remaining block reservations along with the dfops. */
+	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 2c27f439298d..7b0794ad58ca 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -73,6 +73,10 @@ struct xfs_defer_capture {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
+
+	/* Block reservations for the data and rt devices. */
+	unsigned int		dfc_blkres;
+	unsigned int		dfc_rtxres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 388a2ec2d879..a591420a2c89 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4766,27 +4766,12 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
-	int64_t			freeblks;
-	uint64_t		resblks;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		/*
-		 * We're finishing the defer_ops that accumulated as a result
-		 * of recovering unfinished intent items during log recovery.
-		 * We reserve an itruncate transaction because it is the
-		 * largest permanent transaction type.  Since we're the only
-		 * user of the fs right now, take 93% (15/16) of the available
-		 * free blocks.  Use weird math to avoid a 64-bit division.
-		 */
-		freeblks = percpu_counter_sum(&mp->m_fdblocks);
-		if (freeblks <= 0)
-			return -ENOSPC;
-
-		resblks = min_t(uint64_t, UINT_MAX, freeblks);
-		resblks = (resblks * 15) >> 4;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				dfc->dfc_blkres, dfc->dfc_rtxres,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 
-- 
2.35.1

