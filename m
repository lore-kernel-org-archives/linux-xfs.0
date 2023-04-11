Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C96DC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjDKDhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDKDhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:37:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC78D172C
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:37:36 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJU7oL002835;
        Tue, 11 Apr 2023 03:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=HPLTyk0iT7YegCw+lQYdROOgJ0uV9hspKbbICphNCsA=;
 b=WO+IpWT65tlPNzT0FmUn2NbdzjJDPEDa9zwbuXGhtHt8YH96qdPupiDHD8RIA5UN6NrV
 uSMCGG9SICJ+JOL6iklfpQmCCHU86tCAUz1FRi3o39xYiNxfDRzrrKfpgNzqiraEnL+4
 3NPF7QwS/O7CHxDFNE603s3sPZyvW+F+Z4Dnebu8ShCL441kQqVQ9IaQKTn6qo8pEzY4
 LOMlsEmGFqrjx053IrjdbVCwkLvl9Zj8xiWdpFptvRsnhoY9Bz8U4TzPjzTrLWVo54j9
 e41PdZDdhrhIW0JYPG+8mthSi/uPcRnO2M+9hoiTs+uCPyzioRZ25xQnFC3+S3QS6F9i PQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwcb9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B2sYMW038830;
        Tue, 11 Apr 2023 03:37:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbm99n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKQcF8/94GptOVtLNcg6Y0D2GrpVuED5ut0fiCDQNQM1lYPUpEda8GW5FCLIeIRBmF7d2qstU12FiQArDJItI5+G7eTZoz7eb861222RscNN+8saLf8x8Ou8zHFXg54eU7vNjzyNMc6taHamgreZD2xWNVa6/QJT3acLZBrnnMEeB8MALwYrNSrz7RQQJBtt3jVaK5+o7m3+Clz2/g0lXOfUINPW1sox1iPyliPZiQOlgd9oQ8oWLgzMBmv4Asrr0QsY/uXKlTh1YeeECuFTPz6oOGgC20/Sb5oyC0J6mfFssVLA6ih4pvsvqr4DX2LQE0lHlksyF0qNZ55oFHTdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPLTyk0iT7YegCw+lQYdROOgJ0uV9hspKbbICphNCsA=;
 b=FslNaQtJXdpeC5VjkUwMGyh1Tpzb6A5kdfhkIMTOj9/EYU8b8XaFsACgB9N5HyVFFuR0ENH8JASMBJf0DyUaeTJ87r1FIu3UEjuHQv7JPHBCVNqdMvF2PtYwXO13/rUN+ucwwPDhWAvyOG8v2jawBs9vqVruS1drc744Ou1p5CNKYL6gNzUGahQsE0P5YEUT2ZkSLqK3F4ZTOhhcNaE62RyWhAxnh75DjBKj9KVnA8wd1f3cVawplp0julqkAEL1l/px5GgyRm6ZQgk/H7BOplLYt4MrtTDLhVDU5oFWwchNUra7orOrH+L1zTT6cOLPIOU61gphPZZ1+P//T/6AzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPLTyk0iT7YegCw+lQYdROOgJ0uV9hspKbbICphNCsA=;
 b=SceURC1fXk2sQ+fJOqYRBJTGSOK82ltx+uczDbTwYHAkqvwe6EIXskxd7ZUkHOyTAKytHMmGUccMaQlFx+q8qkoUazOgDw7DWCfS18GavGVmYFtNr57bbx2XAQ9ZQgH5FF2CBtYVuoTGkj167uZ2EJMpGZ3nBfDxIGm0rEiUFeM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:37:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:37:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 16/17] xfs: don't reuse busy extents on extent trim
Date:   Tue, 11 Apr 2023 09:05:13 +0530
Message-Id: <20230411033514.58024-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 5289fb7d-700d-47d6-03df-08db3a3e1402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9PJmZAysCKIeC73j6qUEfeWXVqmb2b8fKfIn251L7j1F9qh9AzuiDL70JigSy1+7Fb3MiX2pcM9bFwJLpAJiq/azL3OttjPOqYMQqe5oUKGCpuQYDFi4BYcDQ6h0SvDW959IaaXxoPGoYoMnn5kv0pMsk6Eop3vHVTNhaUyBa4wT4AMnT0wEMksnbPYGv/KZQwrd3odZ4X9Zcd3JHrAclxAh9JpUFlLLv46pCddFYgAY7CQyydzWCysR02TeRWN8MB3oyy/IAQEv/+HmYAXnxl86vVeCoaNdHeOn2+c32eUOL5J7Pg3u94dOJC88wamm0H/g1hTwWBwZu76NJODLbhZ3xIhXYpU2w2safi40nN2V1ueNtiiE+BKvpOz1MIxnQNRMjbim35+Lt4rigM6RmUB9cKeXUngsf/LP+HnzoaDIRSV0lvdMS8pu4CW+Y1vdPsmI9g77cE+qp2kaOHFqRy4qFGdV/XMJyF3BXrYfh7FRZEcAxcK549WxlSeKjbsfcD4e0IFHbDl5RjUlVvjzpMlyrq6yqMhl9JYgWm35xjDBYR1HmaLgVM45jwp8EaU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D1UXLfW91oGferuh0zduSsfEK1ryccz/nsEYEfClVc/wweBBIy3DEgHH69jb?=
 =?us-ascii?Q?0OY8uLhKNeRjgDFiShtxfC5kX7KiNfp76nF9RnX6kIQM160k36XsuFg08W9P?=
 =?us-ascii?Q?GH7Io+mtNyk0JoP/JBuZgcP94sk8v0q+Im9WLbBDx/1KJX76aoX90fHQO+ml?=
 =?us-ascii?Q?pQvUrXd8lGRvIdA2/wtClxWsEnyNyyBj8MivfEiBNpKXhRkVvhZarymKi9bP?=
 =?us-ascii?Q?BY09sUX+VX0/peF8V0uwbeiwm25u4hlTbsAhYNH7U9J2alqnYMpHVhJX86om?=
 =?us-ascii?Q?U65o1hPr54fN7H66RiRyMcBVz+4A4GxDZCWa7KcYFhobqGcwVwDQucNA7DUS?=
 =?us-ascii?Q?nVF0TQQMSwDmlhdCOFOJUZMQB39m9DOutoNxR9bbHgbj+ujS3vh+MnAQ4K5n?=
 =?us-ascii?Q?2wMg3Pxl+jS7U4gS9Ow2nG/ZyC1WpZwFv6zYc8KoMY/VNgV8r/kswRljLF8S?=
 =?us-ascii?Q?NIzJ5BMqdktruAw0OutNyei2c+mpQlDElBVQSYKq8z3OgsbW9f6fNGCOxVqt?=
 =?us-ascii?Q?JeTuUSnTFtioYaHRNV/qusAHt8kKjEOVpc+hzs6JpH/qJKlH0Osdj9ORYGgs?=
 =?us-ascii?Q?5Tu7YnKSHQO+fYLrEtW5H4bQeoHUrRJj0dqvZCOiKFtmeZkWsnvJ0Oy8Kxkw?=
 =?us-ascii?Q?pf1i08Qd7fQWez9RxIJC2Xr44+egfHxToYDhiLXB7eFxJL9fpF33cRMqq2El?=
 =?us-ascii?Q?Umavh1CCUQUVmZje3kuH2X/T0+oRwLAgNQB31xFcBiJTjVHmNEoXwK6Tkil/?=
 =?us-ascii?Q?qRN24sYK3jmsmnOMgWZ6uvR1HXpLW6ue/sCTx16yAzphbL49aH+MNXfEWZUJ?=
 =?us-ascii?Q?fRREkSbyf1RgJQh8bMJWQG6JIBwwMytlYP91YF92Qqg3k6p7NZSps8umBDk+?=
 =?us-ascii?Q?JgQHbOqRgCiRAg23vhnwnadf+DWeZ+NEPS0FkuigdVmuOSggeFfK3qYNuQHU?=
 =?us-ascii?Q?yzEjbPOHJPKYwTRGtaG5gN/L12cWbBUZYfAXu93cMpHIqQPzCz3I7tb8ilpt?=
 =?us-ascii?Q?fR+KcyrPEfW3EH0/9CggzGtgTh2eNExebHICAQ4D0HS0LeAfxIV8ocHnNCQE?=
 =?us-ascii?Q?L/i5k9WBZK1Chy3GfC8o/S9FwIK9yNveAJ2CPR1xA7Q1wp5C9pEwOlveC30g?=
 =?us-ascii?Q?AgSylDqXaVjSEFntHcCjITk2sCQO3xt3s6NESf08dTLD1Z4Q4rN5U1k0unwN?=
 =?us-ascii?Q?4LvV8uNNKfz9qamua+6uHQXsH4XAGpv2VrsONJUFFWdcdQRBwG7lqtHIZKKr?=
 =?us-ascii?Q?K+8ZievzMz+lB67/sazOyTgORA536GrfLIaz7X5Ql5AtDudVgakxfBiZGgm4?=
 =?us-ascii?Q?j89udHX/Gn00ogjn6Tsmu8s5y0kkzPw7En1spBsS94rQtF0MhR3pKrXkNxxE?=
 =?us-ascii?Q?7MaWD0MqjOVt6z3Ym2ML410un8FzeWeSeLqg6cDGGcKhgFfclrSp6s5pFMWu?=
 =?us-ascii?Q?n0gmnrF6MB0PFXuoe0x4RhuYafR9ufwN48JIGufLBlKDfLx/1D7vgYjaghaw?=
 =?us-ascii?Q?hCsZfWt8q5Kn2jT3peqHvqr+TBlNSNzstFRdZZ716tK89Y0SJl9JhqyyOePT?=
 =?us-ascii?Q?jSmmtB+6pS6VBuEImKV4hQMRVlqey6B9Ml8DqjiI9BJvilaPGMigAdpYp++t?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dT3uDosLQo3ZMP1Elg0/QTmitkDW7UItcQw0DCUpK8mptd6OXMDprixIU7mAv6z/J3RaVS9969O9vUQLsM7LEQMKvLhoi+C/ZDz/6VBvL4jhXu6YjuS/sGJByU5b7+46fcETg2lPpg6srmKE3/bW5OP8sl40AtyzR4XPDDEz+t7EN3LTQQkJDqYM+UL+Nn6I6EH/3kFT8WcA6kmmH+uSgN/7IQUpqfhvHtCcCknGlTjgaWOwPWSk3l3SLNoHy1vvhXtYPiQu8PdScaL269FNg47rh/qMM6ZNSCaupIwoR+NoZOzGicWRWlDhBt5URjTIT++YA1v9Mrwy1Vr8/f5z3RFi7UuXMe+8bIW2YZ1ao49UefV0goatz5M7gEedpa8D7LPeOtF2RS2FVntwP3b48HXFrh+cwZuZF53RmAE0eN5ts4vIelyKwsuZHYTdTwN+jXvximU6Cge9IIY/rTvER27aF+w+y2cAkwacrWSmFeBwpOcA/22vi5jDfmMjilZkkF2RhxR8Nc0fTg+X/NyWLa1JhQZ/rpKZM3azZqSiJT0y05VRB51PWqUwXdJTrnhBkuGh94YB1zuiuN3rHxH4yKrxNpu1gEMd+pJWH+bMkXxa2y4f7pbWT7Y86Gl6sIwbaLn7LpNh5UDBJJ8N4RgR3Mg1UId2iAgKDRP3p7OX4EYC/DZ/Tf4G47L6gN6xlIGtjLo40J+3YifVYHIhYMxez2pjlNaJ/WAiXv/Sk6MCoeSbL3d7SUAHXCkEnsXoI6hoJfMuEQMUPoxoaTe8nXuI9x+hjLcccxE3UvQH22Wi6c4boO+SNzH1eJURDW3JksZ0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5289fb7d-700d-47d6-03df-08db3a3e1402
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:37:30.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWwpxQx89UCBVEcYqihk+gFhdNLz9co3R+Jr/BTghFAfqVr7/tgMBNIaNyp/OF4nPCWU7KZMGTr2Rz0W+QQZNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-ORIG-GUID: weY8h9-IXO-HA2fdd2pDMInF7FbvAcIQ
X-Proofpoint-GUID: weY8h9-IXO-HA2fdd2pDMInF7FbvAcIQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 06058bc40534530e617e5623775c53bb24f032cb upstream.

Freed extents are marked busy from the point the freeing transaction
commits until the associated CIL context is checkpointed to the log.
This prevents reuse and overwrite of recently freed blocks before
the changes are committed to disk, which can lead to corruption
after a crash. The exception to this rule is that metadata
allocation is allowed to reuse busy extents because metadata changes
are also logged.

As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
has allowed modification or complete invalidation of outstanding
busy extents for metadata allocations. This implementation assumes
that use of the associated extent is imminent, which is not always
the case. For example, the trimmed extent might not satisfy the
minimum length of the allocation request, or the allocation
algorithm might be involved in a search for the optimal result based
on locality.

generic/019 reproduces a corruption caused by this scenario. First,
a metadata block (usually a bmbt or symlink block) is freed from an
inode. A subsequent bmbt split on an unrelated inode attempts a near
mode allocation request that invalidates the busy block during the
search, but does not ultimately allocate it. Due to the busy state
invalidation, the block is no longer considered busy to subsequent
allocation. A direct I/O write request immediately allocates the
block and writes to it. Finally, the filesystem crashes while in a
state where the initial metadata block free had not committed to the
on-disk log. After recovery, the original metadata block is in its
original location as expected, but has been corrupted by the
aforementioned dio.

This demonstrates that it is fundamentally unsafe to modify busy
extent state for extents that are not guaranteed to be allocated.
This applies to pretty much all of the code paths that currently
trim busy extents for one reason or another. Therefore to address
this problem, drop the reuse mechanism from the busy extent trim
path. This code already knows how to return partial non-busy ranges
of the targeted free extent and higher level code tracks the busy
state of the allocation attempt. If a block allocation fails where
one or more candidate extents is busy, we force the log and retry
the allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_extent_busy.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2183d87be4cf..ef17c1f6db32 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,7 +344,6 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
-restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -363,19 +362,6 @@ xfs_extent_busy_trim(
 			continue;
 		}
 
-		/*
-		 * If this is a metadata allocation, try to reuse the busy
-		 * extent instead of trimming the allocation.
-		 */
-		if (!xfs_alloc_is_userdata(args->datatype) &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
-			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
-							  busyp, fbno, flen,
-							  false))
-				goto restart;
-			continue;
-		}
-
 		if (bbno <= fbno) {
 			/* start overlap */
 
-- 
2.39.1

