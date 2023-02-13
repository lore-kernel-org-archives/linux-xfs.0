Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62919C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBMEHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjBMEHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:07:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68656EC58
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:07:07 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1i3h5011963;
        Mon, 13 Feb 2023 04:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=c3YiIWAbHBsilshyAQOZCgzNyIykwDSbTTXEJSiojTs=;
 b=1hbmqWaiUMV1jOrbpaH+1Y6+emrUWkjNTVlJlTF/CdYHVdDNrkExyHy8MAwqfUfr/uQp
 lit4YABS3V47KXzQh7cx6t3JfjLDb6F3mF02lmUqHiI0e2N0H+hWQjlakAkVI6Nb4aq4
 GV6SZngeIFfnWN2avP+XkQhZsCQDYDPSHGIU+aYDvFDyhFYwttMYLoF92gavUWmodlRO
 Zj43fFGRuG21Tg1AAffDp9H4WSmzAs50SmNLx8JXpDOUJL3xrgrE0S4CJ3tU+xqDZF2p
 I8BjC49a37zHqpHhwC4/ADVC+fRmHWUgfWK268fMagR4SdnBeWAan/EDsg0qy2pDRrRR uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t39v50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D2SXhg032602;
        Mon, 13 Feb 2023 04:07:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3k1rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKFbaKPbpd1h9S1pLvxvayaQCTPgKtYLu+jrtB+z/UsT84eNuV/blmAMS1ObA610n9OjRgWhn44UvwxGdGk7j/BWVO687gpFG5NYqdpahQoGxHgWuGA0fqe+iFzGE08+UV/IWgMlhMyGuf1MZGfPyN0V/oaNaRJFZUTBB4rPt3y63MDMxaTkX1hqhcR6TRJmTEJhe7vHRW8AHLgkcbjSgrcmkMAYlyTJUgY6QJdD3N23IOuQb3Ejsy/RivaHSmkifhxBj5I1UfdL2fol45hbtLXD2LyvxbEIIDkmNAUD9k7ZALHCKPWnJJAKatyLgM0hLSj0sxkDoCWxGLEl3kPcuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3YiIWAbHBsilshyAQOZCgzNyIykwDSbTTXEJSiojTs=;
 b=Lj59StV0DSKpZRFpiHnSHcC9ZLZ7Gg4TnsZlD+uRb3mK6pmAkEAAhMPCGnSf/Kn0WEHzaTIv1hrWHwHH+nAGWVM0bMyOWLvwnR1cBUi5iiOhypnY5tcSzfjn0BLXKb2rFfo3s7/pJZh+VM81kaDRBowGpsUw4uk9TGQOU9bi2NRCP5qE4BUbDUpBYgh8fhV2kIqX9KeVE/uWXmvTIeOpVpf88P3+X+uAVKnM23AesXTbQpJmDfpevtqCVW0zVyqQmrpB03VhiJwTxJwrpqwfUpphknnczA0XXXV/oU+jpWSFSTTG8U8UTUhkYTzEcc7770H5SGbWFDpurv9K3J0JVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3YiIWAbHBsilshyAQOZCgzNyIykwDSbTTXEJSiojTs=;
 b=oIjyi+f1QNT4kRhmVuSXw8F967qWlXz4tEP1hUM2fr/8kKlMenYkYY5j3QBdJYp9b4vvGPvKiVutfgJeP0gmx6pVaRoqe8kHLslKl5zOhPPWno7VVt3h1LAN4/qN5HikcXX4GTFuRTzpncAvrfloLc7WH8OrxTm43U8zdMmC1zI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 16/25] xfs: fix an incore inode UAF in xfs_bui_recover
Date:   Mon, 13 Feb 2023 09:34:36 +0530
Message-Id: <20230213040445.192946-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 23af3ad3-25ce-4a85-abd1-08db0d77bff7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+Kzk+aJ/86jl57rXydUC3XpeisPWjdpNpEJjxOq7IXlWw+ZPR90qLJt5GWG07c3ELVZTt0bmKY+g6MZzMmspsd7JauoBgr0TvbIOs9HjB1dJgzjZ2Gv7Svly3Zl2YfnL/t9fCNDwy462LoXiuleg/mtgEktPHtnS95OdyzdvhUfRhPjEEQvYIevBP/LWxBc2ErLodH6Qt6hM5tMAkqdMQqZ+aYFTmTSz7aguNsbD+yMU3V60n+/1cGzLuTHZNkq3QpWiLBt6py0ibgO8+sTZMLJL5JBlgbjlxZiHaFYM2NPAoTkiNuIaL3QMO3FgDzbhIJqSQctCzNHkLHDWoDifmSeRPi2B1ZNzMDTJFtMeB/8egXKJAHeIqseNsCI9Zk0SmYwGgXUJToPcadLYljtNb18tKo/L5ldD96l8JeA2MyMagastAqWaSRFyiwpB3e1M2cdDbCq4PpBXBPwyIOkxx9xGUb/PjFSdiFAXtov5c38Wrmy3y7mcgucKhbqW7K8MPjbDxih3GpnBu43FoydIowmueJevvGIcTNnrBWnQreSAOAmAepJKWFsOgTKuFHRMENb5tpAn4XYiYOXd0mmQWEfcwDllLAuSfFqdv9Bsv9O3PqTyBToJ2XOQ/w7+BsfsDZSlQds6wK9XnqRDeU1/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3nyM8X2ITcaJYUINzqwFDpXaLF+GjMofK9NJmPyKfvDudIqKoYBPRJVRwzXY?=
 =?us-ascii?Q?YP8jNheqqGH/DeqyLy/c6Z5+7o+nUZt66I3sQvFVMA1k+E5XN7AG+Me57S8r?=
 =?us-ascii?Q?O0ZSrbZ4Ndnp6k3M6ol5w+iYjP6vgaZ/bPViu5EOY2gJA+FaX1es7OUS/bqc?=
 =?us-ascii?Q?+2uqEtELGKalwBP+LhX7j0wl/vmChFaosEu7f2aAANHlFabrRvriqmT95ivu?=
 =?us-ascii?Q?v9gcwoddAW4oHuc2X9Z3YdAyoL6BsNDHFEnJ83Ks7IPVml9EBkcyiuyPuIbE?=
 =?us-ascii?Q?kOfdGOtfbSGykmnX8Gbpjvf+TVQX9A6aBwESxo32r180vlhHqNGZI9/ttjlF?=
 =?us-ascii?Q?ZtZ8aKLE06jnZKi3vYnYYiymPGcsNyG33DOhkWL3/zo9IHeSJrPhAz1jAtir?=
 =?us-ascii?Q?rqNd4XX3e0CwBGe8mE79Lm0MOur1aUeoXGWzzBNi+d+Prlur874SKtJjKZ/p?=
 =?us-ascii?Q?fb1vjuddJq716t4lZ7c/LqDsC1PpSAMO01hH5B2tRcLBUbuL8DDj9vvR0IX8?=
 =?us-ascii?Q?d27EqRsDCWnhz+Ha4j2n0V6IQimluMPnbyPxDKW0NgPG4pULupwQ/Qju6dNH?=
 =?us-ascii?Q?A3BmpE1y/uHS+EuFwx8Cc6HKSJaCKvKgZxQAEFlbfvMTETGNoxqwkneSx1WL?=
 =?us-ascii?Q?cJtydtlLLTEGEStBcZvaDWsHBKsigzm5uzGy2MuMCHDsxaQZM63HBlomvtFl?=
 =?us-ascii?Q?ASsziiTk2K90MKHLG0lN7KqfeWGEMRCu3t/w/AS0H9cL86Yuvx8bp65ROsU9?=
 =?us-ascii?Q?FX0Laz1laZKI2WrmNCov77UQ+Kvh50EtehU0Zn+ZiDzyqb9kbx/5dEUv+JrP?=
 =?us-ascii?Q?Dc8ntJM2XHU3oQYvdnkcOaFoKQASx97sCpv1KUcB30fNOHb8BIgM9IIGmcjQ?=
 =?us-ascii?Q?u8E+Me6nAL85iRjiwXFTBHn1+RLxCxV+I74BIFbN7dDCiivGEmUeDXRk1XgE?=
 =?us-ascii?Q?ewm6UHhhN6JHJm23VQyYqnUw05Jb/Zm12yid43WvIasYtQ8fGnSM7nMDtmwc?=
 =?us-ascii?Q?IOG1xNiI5fJA4eYNDCnMLAlwdLqr5L7cphC9z2rzGbyRZOJojq6TLVFd6kRG?=
 =?us-ascii?Q?qZXhpCJeHdoM9a1+I19tYfzjPXTIH1J8OGQlfKRjH0jnrp51tjym5hfvpp10?=
 =?us-ascii?Q?ziHpRHa+wjN3O+VreGl9NuiQmgerzTZ55XGiwsvlGCJO4S1fJDLXreqiwDR5?=
 =?us-ascii?Q?ImVq7/t98xS3crg+HdTvf4q1b22sG6n850yhglqJdBVEwxZO77CNAPT68vrD?=
 =?us-ascii?Q?ElWNv+gyNSPVok5PIw3jIi+tCK+D8j/f7FMnPkph7dp7k9VTVMV3ou4VCPhd?=
 =?us-ascii?Q?x4oxrbGSpO/z++3JuaGCasQviKxKiTk6jJd3FV+TW3Oq1kh4i4kG/SZvVV8Y?=
 =?us-ascii?Q?EHvPdMD8n5oKMzog62cAZTcihftX+qHkH7u8o4B3KZvYAE3FfeekF7b+o/Ba?=
 =?us-ascii?Q?lqpzlWKLE36Y0eTVwZ2LPDtxmZ19SfprwLmq70H0WE495NRqF84g64On1WLD?=
 =?us-ascii?Q?A7gt9cX0EqUCovMqO9GbBmpmMvxiBnasG6QRCow0TXJPRVmXUF6cCLj0xRs8?=
 =?us-ascii?Q?VnL1bWrgX6iXqbJOnxwjE70Wl1JWEyLnfUw+EZryP3jBFe4FF6r+MGv3kKmM?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nq3QbMij610I/+73VKZ7fVBXvEEpv87HDy4/yBTMW5dn1h45AhU2I2zGp5cJvHM4b/NHS6bZGmuMtGGs3gT2q5ZzlV5TMSkEPitcCGRFvFZqUHrWKVxfY+YnNSB9rAz21hxZdzDBwUYhp1wH9CsDCcBR4NgrtS8B8Ni4MgvRlf6koNbYwTz+eU0474hyO3r6Mrx4cFYy1ZH6rafuqt0BGgsSyxy0K0BgoS3zjjiiGFjA5I3nMFMWf3bS54wO3Ag7naDc4wYMzbsEQawWOQTcS3R80CdlXhG11eKQppvt6dd8hrjOcGwmAq1xYgdY3dkeAKoqFws9x4NpMDN2RihWYnal0RKUfTGk3Dj5CLyFekkAzObskwUyv6DC6AD5hXqEwxlMMiVVZPnFVmVrZV+nT1YT4NrNzxX3zyoqfKjjRVbh4qyTKz/CrBHmP8WceAJUaQpL9wGdKYk1bPZBCdtS/7PMTkBbPFU9kj6UZZxMTY/1ur+jUTKsiHkDb59rc8kmTg5eQDL6OzdCi78dNYXflHFFJNpx5SLlmTg9jz5ks/Ruvg/XqtU8Le/mhl8ljJzbF6iMexri3UMQaVOai1X9gZ4QZGGRdBxZrFE7fLjk8gxLKFuxMtGlUsVLiwuJPnJNxmINqeSmoBfcd1rk3fELwZenPPyOTWBG0KngLckBx4w26SK5nZhuGO50C2//34HV719ZYn4yDvnWQShYHhIZmDyYe9EXpZmz4oyHDKoGtf9re6gFXjZF6yI7dKWtieH7xx6ZLOCkf8ixirWDiUGe4PCRhIVBvcmzpdJyGMieMQucNFLW1no+B0YsMKiFf7N5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23af3ad3-25ce-4a85-abd1-08db0d77bff7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:57.8818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2D7GCkQzxjHUG6JIltx0xJ9Nq+cYHOsC7dcaRHh9pSR5IK/d7sjh7EO6HJVmX2FCbWWxhuZjvc86cvNGBKZ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-GUID: NnuEcL-bW2_hgrUUTKhpn2oFl2HsXQ5B
X-Proofpoint-ORIG-GUID: NnuEcL-bW2_hgrUUTKhpn2oFl2HsXQ5B
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit ff4ab5e02a0447dd1e290883eb6cd7d94848e590 upstream.

In xfs_bui_item_recover, there exists a use-after-free bug with regards
to the inode that is involved in the bmap replay operation.  If the
mapping operation does not complete, we call xfs_bmap_unmap_extent to
create a deferred op to finish the unmapping work, and we retain a
pointer to the incore inode.

Unfortunately, the very next thing we do is commit the transaction and
drop the inode.  If reclaim tears down the inode before we try to finish
the defer ops, we dereference garbage and blow up.  Therefore, create a
way to join inodes to the defer ops freezer so that we can maintain the
xfs_inode reference until we're done with the inode.

Note: This imposes the requirement that there be enough memory to keep
every incore inode in memory throughout recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  | 43 +++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_defer.h  | 11 ++++++++--
 fs/xfs/xfs_bmap_item.c     |  7 +++++--
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_log_recover.c   |  7 ++++++-
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 7 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index d92863773736..714756931317 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Deferred Operations in XFS
@@ -567,10 +568,14 @@ xfs_defer_move(
  * deferred ops state is transferred to the capture structure and the
  * transaction is then ready for the caller to commit it.  If there are no
  * intent items to capture, this function returns NULL.
+ *
+ * If capture_ip is not NULL, the capture structure will obtain an extra
+ * reference to the inode.
  */
 static struct xfs_defer_capture *
 xfs_defer_ops_capture(
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*capture_ip)
 {
 	struct xfs_defer_capture	*dfc;
 
@@ -596,6 +601,15 @@ xfs_defer_ops_capture(
 	/* Preserve the log reservation size. */
 	dfc->dfc_logres = tp->t_log_res;
 
+	/*
+	 * Grab an extra reference to this inode and attach it to the capture
+	 * structure.
+	 */
+	if (capture_ip) {
+		ihold(VFS_I(capture_ip));
+		dfc->dfc_capture_ip = capture_ip;
+	}
+
 	return dfc;
 }
 
@@ -606,24 +620,33 @@ xfs_defer_ops_release(
 	struct xfs_defer_capture	*dfc)
 {
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	if (dfc->dfc_capture_ip)
+		xfs_irele(dfc->dfc_capture_ip);
 	kmem_free(dfc);
 }
 
 /*
  * Capture any deferred ops and commit the transaction.  This is the last step
- * needed to finish a log intent item that we recovered from the log.
+ * needed to finish a log intent item that we recovered from the log.  If any
+ * of the deferred ops operate on an inode, the caller must pass in that inode
+ * so that the reference can be transferred to the capture structure.  The
+ * caller must hold ILOCK_EXCL on the inode, and must unlock it before calling
+ * xfs_defer_ops_continue.
  */
 int
 xfs_defer_ops_capture_and_commit(
 	struct xfs_trans		*tp,
+	struct xfs_inode		*capture_ip,
 	struct list_head		*capture_list)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_defer_capture	*dfc;
 	int				error;
 
+	ASSERT(!capture_ip || xfs_isilocked(capture_ip, XFS_ILOCK_EXCL));
+
 	/* If we don't capture anything, commit transaction and exit. */
-	dfc = xfs_defer_ops_capture(tp);
+	dfc = xfs_defer_ops_capture(tp, capture_ip);
 	if (!dfc)
 		return xfs_trans_commit(tp);
 
@@ -640,16 +663,26 @@ xfs_defer_ops_capture_and_commit(
 
 /*
  * Attach a chain of captured deferred ops to a new transaction and free the
- * capture structure.
+ * capture structure.  If an inode was captured, it will be passed back to the
+ * caller with ILOCK_EXCL held and joined to the transaction with lockflags==0.
+ * The caller now owns the inode reference.
  */
 void
 xfs_defer_ops_continue(
 	struct xfs_defer_capture	*dfc,
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		**captured_ipp)
 {
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
+	/* Lock and join the captured inode to the new transaction. */
+	if (dfc->dfc_capture_ip) {
+		xfs_ilock(dfc->dfc_capture_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dfc->dfc_capture_ip, 0);
+	}
+	*captured_ipp = dfc->dfc_capture_ip;
+
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d5b7494513e8..4c3248d47a35 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -80,6 +80,12 @@ struct xfs_defer_capture {
 
 	/* Log reservation saved from the transaction. */
 	unsigned int		dfc_logres;
+
+	/*
+	 * An inode reference that must be maintained to complete the deferred
+	 * work.
+	 */
+	struct xfs_inode	*dfc_capture_ip;
 };
 
 /*
@@ -87,8 +93,9 @@ struct xfs_defer_capture {
  * This doesn't normally happen except log recovery.
  */
 int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
-		struct list_head *capture_list);
-void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+		struct xfs_inode *capture_ip, struct list_head *capture_list);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
+		struct xfs_inode **captured_ipp);
 void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f7015eabfdc9..888449ac8b75 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -528,8 +528,11 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	/* Commit transaction, which frees the transaction. */
-	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	/*
+	 * Commit transaction, which frees the transaction and saves the inode
+	 * for later replay activities.
+	 */
+	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
 	if (error)
 		goto err_unlock;
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 2db85c2c6d99..0333b20afafd 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -639,7 +639,7 @@ xfs_efi_recover(
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1e6ef00b833a..6c60cdd10d33 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4766,6 +4766,7 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
@@ -4791,9 +4792,13 @@ xlog_finish_defer_ops(
 		 * from recovering a single intent item.
 		 */
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_continue(dfc, tp);
+		xfs_defer_ops_continue(dfc, tp, &ip);
 
 		error = xfs_trans_commit(tp);
+		if (ip) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			xfs_irele(ip);
+		}
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index c071f8600e8e..98f67dd64ce8 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -569,7 +569,7 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5bdf1f5e51b8..32f580fa1877 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -593,7 +593,7 @@ xfs_rui_recover(
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-- 
2.35.1

