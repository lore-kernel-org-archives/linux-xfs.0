Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7E1C77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 03:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjDUDGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 23:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjDUDGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 23:06:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED81FE7
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 20:06:35 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KNEPEd022127;
        Fri, 21 Apr 2023 03:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=I71HN3HrJGusNl01vCoEFrJm6GyeoN9QXKc5P59fUh0=;
 b=0ridss+cOANzeatg0kvF7ZAyQpMZ9WsKju8SkL1aAutMM0ZmfLEmxap2X1Avf0r70X0t
 C3mLxye6j0evXduM0jW2GKibR1tJDxTgECkaJzOnFYtbC9WyeDZoiU6TmEWbwiqncgAK
 iaJ2CywbFHU1M8SF9DBQNA0xVX54wyK1HdT4ytzJbgyItQ3A2J+fe0MmtEBMdF/VFLPK
 gllPO0QOTPz+jTlmw1YtmZQj6KygeRjY+0qwjdWec5E96AE/WjX/aReOxh9+bC19q2zC
 4crXgxfpBTrY8dPyQL3TQ+tex0WXntQyKPfYpTnRUmwYEtZnpfmgTpva2ajwVjFzdpOJ CA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyktav8p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 03:06:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KNnKfu037960;
        Fri, 21 Apr 2023 03:06:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc928jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 03:06:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrrtiso0GbAy90I7Ig4AaIkY6pgLW1p1kVrp7gMYi1yd0YgHsApxO5SV4OzgF8t9U0cIr+1XpkU9ix5P20nz0BW6mUc+/+LMsBeuoBnNvgVEyejjsm9YIu3OcjMNryrDf7od9Okbzh7tUE+I+boq1clr/KNp639g6BhBDxAYEzEP4W62hAn7hlCHvYoUnTadYo4J1ncFkhkdq+aYHvcE14+uXPMbrskBYifLe/0BzIWS4khKiuVyDxBxv7bXV1l7it25t0RjLQYGix5JU5LyE0zQ/QB5sIBZQNg/7SG5tzHQ07QC/lAhgkAqunb9DLDng923dNg39rmdxOapHS+jGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I71HN3HrJGusNl01vCoEFrJm6GyeoN9QXKc5P59fUh0=;
 b=cC1JghckxsgAug9Y3DQXnNkHIc5xe/x6nPUfhESAJeTM0UN8wcaK1ifsmBB3VAAUolG8rBWD003itQ7kQ+3aew37VhUxXxM3erCt/SirW/nO+BxsheGJ4muXH1QMRwmGmolAqfqae8mjwm3pgrFsFNyN4gv3W129+YfW34mpfTQHxEHGbzBIYaN7+NGxUfuKGUs5SozA/kEJS2HLCiCunWxnQnbDHK8K5dd1bW2wqfG9XaBcYg4NaiZ5AVeQoAxo+/D+Rj1BJzFxIK+toMGJT4S7Tqk8fy+qXIX9UFWMJtLHSCAQ2osHJPiSQg/bzZRqhXetxhsdFDhlt30rVL4JPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I71HN3HrJGusNl01vCoEFrJm6GyeoN9QXKc5P59fUh0=;
 b=JDw3T3HrZHksfFuKNnpdKQGznD5qabKG9NY2O9XYOhW5LqmjqlrzgH4velCxNyLO/RICSt+cyXcwiqi06mIHF2sFhTdLTQ6LJ9HSRvIqbQtiKk1XnY2BAq2Pkg1AvmNOlaSATQI1eZXPbGPMum6jBsJS/RX10id5+Mv1f6p13RA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5377.namprd10.prod.outlook.com (2603:10b6:208:320::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 03:06:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%3]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 03:06:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)
Date:   Fri, 21 Apr 2023 08:36:19 +0530
Message-Id: <20230421030619.62047-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:195::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: d5153a33-8e21-4854-9a40-08db42156672
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pvRjWcO1aMduPet/V/CUtpqiO3XyozfbN+YkvFVdhdOqgdq/zR0HivTNgGniFPvMyeLSHGZ+uldGTejs292hydaK8W42FZ6JOBN/35J4ZaCycywZpQFBdOhgjfUTyI9UXhi+GQFq6r+shGN9VlL60AAEgExB28jwMnL0ddb0eKU8JvFkbN8WMRNLURohTK9efWANDeJABkece8P1HDPz29dALrS3FfeiNJFQP3AVsW3Ywh5f31K0dn13B1M+UejjnnUROaHdEnm6pqYAzgxYgy+h0dmZBNvuDS4inPv/elmTqbLsryYOfbtFJRZof5aDuDUXdi3BHTZXbNdmHuIGYDqgy4FgSt+p24NC11xNENndsJHTT83cSPPMMunc18CjsBbBkhHxx9QtdZFxDcqlcXw06RIBMapdtzTYbbDBVo8dgxokQL9td1h66ScY+a2MniV2zytdSirYHvwIb+eb1nZ9+x+xVLqV/E/r7DArsNlfM+oCqCI7Vwctv6PRN5mcLFWqlyhDSaZDnoAlnUX6D0Kt6D9GIPSbHgckww9H1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199021)(2906002)(86362001)(36756003)(6486002)(6666004)(186003)(83380400001)(2616005)(26005)(6512007)(6506007)(966005)(1076003)(66556008)(478600001)(66476007)(66946007)(6916009)(4326008)(41300700001)(316002)(38100700002)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PcQA++fPFtAWu0fyxqYX0Zu8MB740ZN6aDDCu+6DlSDqv5C6r+Rlqbf4Fzmj?=
 =?us-ascii?Q?EvnvFHMm0BIsQ4JvOIKAn1pjH8c5h4ayJGSh4ZWIfdAs8p0TOEHXyewGV7bX?=
 =?us-ascii?Q?caN7IIoDXQfBDNP4MBzN2NQKigKmq4OpwGLzDhy5quRvGlkxzwCAM1v9cjg6?=
 =?us-ascii?Q?RJ4y6GwZcagt/ejmX1SByXFSUU5c1rkU3p7U1ODs7t96U1YOVyKR/ppSvDmn?=
 =?us-ascii?Q?vUrPYrkoG+O/wBFwssISqlqlJh0e6xinh3N9MGk81TKtx65by3noUxeb/ff7?=
 =?us-ascii?Q?q6avd+4k3u81vfhGF7pn3EvGEwDrRZhoXs0+8oxgNQ09jGeKe8GZdnxaFuE+?=
 =?us-ascii?Q?eCf5JdYyrlL2vQrmCwujSNjgi8P8m0M/cxhDjb3D767y6SP6fowIQVdUxMwR?=
 =?us-ascii?Q?NyNjskGTx4bKReS60s6cdTF8zpM6HaFlofMrzos5KoglRTgxhgLNbEP/zjmp?=
 =?us-ascii?Q?DU11sEG0HH1so477zD/4A0j65NqviO+R1RBhvGvTfqTw6MrE37xXoDMw7N+M?=
 =?us-ascii?Q?oZ7nwer70zL3mDB4UJuVNcMskezlpVqT5VgnjBYlu3zkwA7ts0h7jdpwhNNZ?=
 =?us-ascii?Q?sZmWwk8wnbbu3pP1hMOqI86Gam/u1tC+Q6qQ834tcSP32GGx++hYURqKZrKo?=
 =?us-ascii?Q?wD1LmsTevml4NZH5UaMNNjGbWP65D725HYnLeN6NODU+QSlzAPfDFoMZOJz4?=
 =?us-ascii?Q?Qoi5AAvhLVVaOdTY+s45q7JvzHTxlwzmVwonAmQoOdN5RCoDeLlJVVrxRrK4?=
 =?us-ascii?Q?nZNpXvZp9dROSZCYs8HBcAfH6w/KwgX0hjOwHh1ObMwI4Dm9sW4YbD/NuYpQ?=
 =?us-ascii?Q?bEdE4WIwA18sJZzbyJDbwxhkoTWiF22Iat31B6D7H4XvNwbdgJiGNokbd321?=
 =?us-ascii?Q?15hes6peeygpsJwhAOs0W04eJE2R70HZ/apPzMyU93Uw6uFuNMbq+T3K6nSo?=
 =?us-ascii?Q?oajfJedhSkOwtK8vr35G1BKXjy1vWHGZg8ZkFFgXD75DjNlUcNx0fbA3uIA0?=
 =?us-ascii?Q?Q4Rojhr43W1TXIhLM2/r4AHZu/BX2bWNPJiQn1aT8dn03bQ5SN8JRNAxh5mQ?=
 =?us-ascii?Q?BINLDnVeLW0oy0IAdkWpx6pJ6d+iV7XFH9gg+jq0H7Rehb3kio0SSFe7b32d?=
 =?us-ascii?Q?15n8pgWp92Srh2ajBSxJIYDaNhJWGhyY4Iyl2EI0L9e46HLoTfN4deG5GsU/?=
 =?us-ascii?Q?UJ/Bah99zTlxGM+zrHuFtEM2OnVJD5Yemjntd8E6HgMkXTS6Atri49Hg7yWV?=
 =?us-ascii?Q?DodQGSnQr9snbkva++VgUzFe+Nv7ycSb+ZgDFHnIgmZKTa9dwnwC1Qx+wp3u?=
 =?us-ascii?Q?LRe+GBdLzhQhVb6khB3RSsF6/RLmAJD4XPPv0ndIfFh1lWWeTHNW8Mr9G7bm?=
 =?us-ascii?Q?fYU3uuvguk8KeZFGIyjvDTvb7HOg3tBof9C4XZ7C29ev3am0tnUSX0dIVKgZ?=
 =?us-ascii?Q?stGfhqDVPJpfxwyBE/C/sv4KWc+7uB5+lQRGAImvUZw+fHFk8XrpXMZERD5p?=
 =?us-ascii?Q?rIagGS3A3LP+2yQ1iN9+ixcHidLozwW8nOptWfKAkHwKPE8TEfF7WInJ2Nk2?=
 =?us-ascii?Q?XzWTCnxxYQJbWzzwe4hMS/IgF3PUfvhdiMvIZxnb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lNlxMM/NsyFfRefrntbIyoKGLpQY3/Z56eO1qJYaFOuLAQWR55cqKB5zyiwQgfDnilgjvAJjCUCdmp+27JIe9ab5f9zOmJgYKru5OUx5BoNDypIPeFpgvxWXT7JimJY+P/fJlgePDrpH3nGdE67AkWH81LgLcIdmbcJVrLFCwoFV1Ipy5nnZZQFvR5HSIEI30fRZ2v7qhdBCePTELZTNpCho8/bEkw7eBRrhniN+is9b84xp82epNIdzNGem9T1DwaQstypq6dXnHe8iiKqn0FjYJ4jU3kG8UsP+LTbFmA2ncTGQUE2aJtDUcUgUTbQ3DflOwC6VKoKs0uwHToNP1AP0FmVEfAQpN5aEPN4fLjIjjVqL9nktMVNwkJSUgTOzgdeiWMob2q8n9btB4Z2gh8Xv8i7meAeqfRm7eGitTtMsZFqGRzOytMK6JGsbdLjNaRYO94rDs+aWnlNromtof4mUpWKrF0tUZFXuIBMhj1sEEnnIcedTu6Q+PqC11cRdO3Nsj6A+eJAJLPnhJ2REJYAV8Onpb9uao3i9sa27VYTA7AKZE99MMMGEf/9VNYwbyK4PLGsHqB5hQlbrfgE2/Y/F5bCGyoDr4a+q3LkHRTlPDCZ8n/idTjbJC3WWUOkWkGbIkI4+U+HEeE8cVXVuFtNvqqqnohR8nNXlkLwsV5eLGd/HFnOl9Hm6+Zk9hJTBRdNARf6BD6UUjn2cR4YnLtSw1q+qVTgxERBNywunKcjaaRmv4SPbZ9nvuWOA1lt+sXq1Y7Jyu6RAR+mW6QH5DJX/ow9iz+OXzSHdWtOAO//NOs1rsHoq0g5KKS1LjmZA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5153a33-8e21-4854-9a40-08db42156672
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 03:06:28.7723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYsE9eG9/XYrSMESrhlc/rqQYbh1mYrYOyVbsiElb6khT7DtKPl2kkQjiGbQPeOS613+sSgXvdSa3DxU/KSsdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210026
X-Proofpoint-ORIG-GUID: h_qUA0DaVT6S5IEuLIPaIovAwPLdYKpU
X-Proofpoint-GUID: h_qUA0DaVT6S5IEuLIPaIovAwPLdYKpU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit ada49d64fb3538144192181db05de17e2ffc3551 upstream.

Currently, commit e9e2eae89ddb dropped a (int) decoration from
XFS_LITINO(mp), and since sizeof() expression is also involved,
the result of XFS_LITINO(mp) is simply as the size_t type
(commonly unsigned long).

Considering the expression in xfs_attr_shortform_bytesfit():
  offset = (XFS_LITINO(mp) - bytes) >> 3;
let "bytes" be (int)340, and
    "XFS_LITINO(mp)" be (unsigned long)336.

on 64-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffffffffffcUL >> 3) = -1

but on 32-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffcUL >> 3) = 0x1fffffff
instead.

so offset becomes a large positive number on 32-bit platform, and
cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"

assertion failure in xfs_idata_realloc(), which was also the root
cause of the original bugreport from Dennis, see:
   https://bugzilla.redhat.com/show_bug.cgi?id=1894177

And it can also be manually triggered with the following commands:
  $ touch a;
  $ setfattr -n user.0 -v "`seq 0 80`" a;
  $ setfattr -n user.1 -v "`seq 0 80`" a

on 32-bit platform.

Fix the case in xfs_attr_shortform_bytesfit() by bailing out
"XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
comment together with this bugfix suggested by Darrick. It seems the
other users of XFS_LITINO(mp) are not impacted.

Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Reported-and-tested-by: Dennis Gilmore <dgilmore@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---

Hi Darrick,

I had missed this commit when backporting fixes from 5.11 and 5.12. I
have executed 10 iterations of fstests via kdevops and did not notice
any new regressions.

Please ack this patch.

 fs/xfs/libxfs/xfs_attr_leaf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f5b16120c64d..2b74b6e9a354 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -435,7 +435,7 @@ xfs_attr_copy_value(
  *========================================================================*/
 
 /*
- * Query whether the requested number of additional bytes of extended
+ * Query whether the total requested number of attr fork bytes of extended
  * attribute space will be able to fit inline.
  *
  * Returns zero if not, else the di_forkoff fork offset to be used in the
@@ -455,6 +455,12 @@ xfs_attr_shortform_bytesfit(
 	int			maxforkoff;
 	int			offset;
 
+	/*
+	 * Check if the new size could fit at all first:
+	 */
+	if (bytes > XFS_LITINO(mp))
+		return 0;
+
 	/* rounded down */
 	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
-- 
2.39.1

