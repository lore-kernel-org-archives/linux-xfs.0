Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4983FC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 06:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiKJGhC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 01:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKJGhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 01:37:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CA02CCAE
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 22:37:00 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6Ph5x020122;
        Thu, 10 Nov 2022 06:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=a4E4AbtBk2akbicOF91tG7tHm1Ay6C36uMYtqeLGS78=;
 b=O/xHu4DeJ6jHrdyWEXnUVtfMLLbDKiGaULjB6Wi2Nr0jWVMRx3SyKg6i/5An2FxlCijW
 WnD9hYBTn0vGZetblmgwyV8KKx5MAEZ3aYBlthTrGhZ3QQQtfs5EgAtaciVYnIFDhvDu
 8Hayob02CrFnNPJAg6RmtzGUOrMStnx8S8edVVXGL+0dmaq/TZDiZ1DU02JynDJTtJIQ
 vPcWsGqJrLJsvJS4HSCazX2/NXkDRiirgk8GtObK1MNneFzlAYOAcFByn+EKvua5tY9u
 2BmEqVygoIOGTi3t2+bHvbKtNex4/Tpwt5O4Kd+jsd4nxvGo4F+AeMDNdyusm/l4J1D6 pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krv1100w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA5RZaZ036306;
        Thu, 10 Nov 2022 06:36:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcyrck7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBF3jqqB0NBBms8UJ9runm+Y+8/TO25jZ6F6XaeYyql/H1zYosrdFiiVDOmPwHWjjM8bP+UxAQGGR7Kt3Q1GfjFXp4trcN6c1b+2jJ6OB7JXVDwSGvlES+TbER1S+XMqoXnAwumxoVOFBh+oJAvlKxRL6ORf5x4JN+SWOePQwRtmZroYkmZKCdAoKNGozogg32FeY8P8uW2XfVcvdk1VQhe5yeAnaCSNzIwP1PcO33XloujWHxTD0qi43igGEUCJXUTzncI2UXzlZ+R16JhDr/q+YjYQD/w2ZKum/UVQbVP6W0xvTZh02a9u8PWQ+zGpLNl4mmsanWXGwa8tMPPmyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4E4AbtBk2akbicOF91tG7tHm1Ay6C36uMYtqeLGS78=;
 b=LElm+QS8rTqj+CsNjas/Ao86fsGzo0Hfilm5qAMcIJrs80wuX+txtKflGnpdxlbmVzZzRiwUgSVGn6TYFIIDhj74c3S41V3HVQOxy1ou3tpE1L66VZ6sNMgwxXTl70VIul7AwAfaSxaVXJRucwr24x7yItbENLoQX6gatDKkKmy0+FFrQDGmEI5bOmVU57RLqyV4jp0HBQL8Vz0RM3+KaaiFTAHhwtlbLHftQKV2P0NXqA6FcQM0bxcXgItVv8stAHgTWLpPrXN9mw6SkM9sPAzH0G/bf1x5ojb4+qqMjJ0eghQAsMB/lmorqogGaKjUoSMcuG3iY0zH8sJfyJ7SXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4E4AbtBk2akbicOF91tG7tHm1Ay6C36uMYtqeLGS78=;
 b=u51FrgRoCDqasp+93kMeYnYxQRI9gKtzcdvnoZzFXO67wM3xS1eGb3GIulKfvTrdt68ljJ3T6r3iAT9vKoaPQY1ruJXUuDNo6+jPl1G2VYsIvfOSIzlpivaMZnWE/dx3BUW9fzUdWUbm8Vj1HitUnkXg5CNnaJIBzsqSQta+cBo=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 06:36:53 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 06:36:53 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 5/6] xfs: preserve inode versioning across remounts
Date:   Thu, 10 Nov 2022 12:06:07 +0530
Message-Id: <20221110063608.629732-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110063608.629732-1-chandan.babu@oracle.com>
References: <20221110063608.629732-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:3:18::29) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|SA2PR10MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb84b8a-dccf-4a6d-d5ad-08dac2e5f485
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B8S/QqD6WXW6Y4TlnRxV+GHx/kCKJIWK9uv+nSmmCqj0oWPOgCip2YHTLT69B9efK1nPGSiUupLhaLmDPyw+lS21H1x8SU2JeYKCAw81byOyZSTm6MlF0BPGCxEeeSY/HXDRwJuE0m7az4pB0tDERXUxERB8F2AKsZM/9zQ1kB9K3jvdluabOIvZY2vcBg4M11llMtu4DnBcgaW3AC/dePO2iiLWVpCtyqDSHhN6+2GiMtr7Vtk3TW4ggeY2eOs7xcMd6SKjI4SGgcmJcujpeWS/SXGGyGTkLTtBo13WZl7eXeP86MEBGpgf2QvYi9iU/89h2cLXDUnmMuWaRbT3HErYCzn8G7oZwAIosGsD/7ts9eQxCbpy6X17tBjSWoX4p7v6fAB1OFpS3vZFvgbc2nIJ4pJwafF859CYGInhaPTtcpD8PFr8ad9+gXm/6gDoRD2tZRYFlC4pIzlqkYIdxYaomk4WAaw1lwzDP+XuISPJJkWvErLLmvZLZArxYzwzYbqYRBBaUdosVhaaqbgzc2OHb05MzzgTODF0YXghDpZSwMWjFe0nxtvif04/FHhU79wrewUy44axSloa6LshNMWzCNAyzRupOwMtIqzLzJ4j0wdw1tz5dFXxs65MZuH67a1tHZk0bMQ/qzB+UlL0l7YlHzowfwfmRWZDogN7QbhjOYkbAVa0ppwK1e3m8M/je4xoF4TiDQr6AHvSpDtfHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199015)(38100700002)(86362001)(66556008)(8676002)(4326008)(66476007)(66946007)(41300700001)(2616005)(5660300002)(316002)(6486002)(478600001)(6666004)(6916009)(8936002)(1076003)(186003)(83380400001)(2906002)(6506007)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VQRLkyfqNq5cdNaswk2WtzNs21Hv6nkWFpJy5YJLyvlTo1qJW3OGqHTJwhfO?=
 =?us-ascii?Q?r8/avQdeQMJjqQMnwpMRrDFAohNUMxsHzcQwOZjgeMei9jBrYWKfOhdzDVg3?=
 =?us-ascii?Q?fCB0bM+bkb1gsPx2V3dB2usW61juM6z6lzEZJ3wmsmUCZnle0eZXu+zKYcsl?=
 =?us-ascii?Q?PaIAnXOaVlbaWQm2DEeoh2zGPwXkCBbhWdXmnQVWmAT6iiNuvc1Fj08Z12Tn?=
 =?us-ascii?Q?iJKZwPIXMO+93nSvZqnF602JKaEaWDAmR9Ah49l97goWbdQnIY0pD5CmC3tV?=
 =?us-ascii?Q?e0+NuZbNnqfcFi6Cx/Kd3oNYvYxEIktkRIVvLaHXyDEJDr8hHvu6njpwIvLE?=
 =?us-ascii?Q?1S7NcwnrY6mP/nTI/fRP8+5UOgOyKiBZXjTkuoR8JwteGC8GdCY+L5TLFWm1?=
 =?us-ascii?Q?BwZmZ209uECkrG/4Cb1g/bgeLtj8k0OxfLIK2O7AL96tP0B7K6R0smy9YyCT?=
 =?us-ascii?Q?78uqyQRu/RNKOnOb03WMXDzZqUdg5umcY3qylCeQgfZw6SuCWEbHCkiKV4Rs?=
 =?us-ascii?Q?bYM7NL44nBkQqmwZt/+0F6qP7Kkuzn17E9YQmplDd9tUZUOlA74jFoh01860?=
 =?us-ascii?Q?Tu7XbK7NmjP7a3PCAipWv1PWqZxjcmHu0Igww7U08Bv9uC4Q3pG0u2bf8yX/?=
 =?us-ascii?Q?7sGZfo2OsjdUA4hzMravXBvknz8/n1WSEUS6X6MZYasLrqyIdKWJHqg1cypI?=
 =?us-ascii?Q?uFAsawYUaq7ZiZ2Et3d76oVSFaDrGGAwuaTuLVaz7BY5uZKRbDZTYlvddM3V?=
 =?us-ascii?Q?YrBaaft1S4ZWyafawOFEkpUgcn5Re88DaYTkxIi6AsJDFn5m6mUlj9HEW+6Y?=
 =?us-ascii?Q?XUCoHw9JWpK4zRafCK0ykCGVMrDjMF98SuhZxruKb5K/ZfLJUKth77+CNDPZ?=
 =?us-ascii?Q?svam//ey4aIaFBO/+x3fUBdVFyQIg72gHWompHUgbFKr9LwwOO3mHKXKQyUU?=
 =?us-ascii?Q?XOccVSdnW/NNAen+4DgyiGtI1KQqTdcl2BLKgOoqnQdaQlgXB1PIy1Hqsrgm?=
 =?us-ascii?Q?ImY/ha9kr8Se4GD4aXPpboed6a6ikPrmzSyW1YMgiAA4TxnGwxQxL+7GGB2/?=
 =?us-ascii?Q?MDCi0TvUXCD8OD6EIhOqllA6TrMTwhMXWocPzRwiMOkOlVkEa23hn+xfiJbw?=
 =?us-ascii?Q?kHT12xL0ttRt8Q2utB7o7lQFEsZVjUS3Y+UJprD8hOECJgHM6twWQ+r2ZKzr?=
 =?us-ascii?Q?IGB+4XoOl0FRMGDvIEl2QDKfnclencCGfWzIwhqPRaWzTTPL9rVXQOM01TC3?=
 =?us-ascii?Q?wFO47ogfXlODrMUbesv7YYPjC+O2f/DCA8Q4KDt+RIVOqQ1ObrkcovXPvwUX?=
 =?us-ascii?Q?F5p8BQWwzgSrd3UGRNUzif7bpxPlibvAHT0UdzixYBs/yRkHM+nVrs0rY2xp?=
 =?us-ascii?Q?txQKTTlk8NOMm3ZYViu8/orc7+xoOrAI5fj0vXV5dctDhy113OHheyVQpQZy?=
 =?us-ascii?Q?ki24C3kZ/n3nqnyGYRLpwe5f1gTLISqyD/PnKtG09ChsnPYeX3gJrbtpxJ4u?=
 =?us-ascii?Q?cJuqPDJ+7RXzDv5uX2xDbfezz/pHMsLXXLZ/TZxuPp616pcyaWVgVKOI7jqm?=
 =?us-ascii?Q?RJltGm5JXxLVLc6Ax9TVCCyWQJT7zvg476xVwjsd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb84b8a-dccf-4a6d-d5ad-08dac2e5f485
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:36:53.2995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exsBW6dD2AsJ5aaI8dXyN8g52k1UvqtCL/2eLbaU2DLV2ZowYgu6U4QH/oh5cUAFf4QF6BxGGVRkrzl67XkrfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100048
X-Proofpoint-ORIG-GUID: Rye7pF_EJuqKBs_4GdF6ZH1a8spZnyWf
X-Proofpoint-GUID: Rye7pF_EJuqKBs_4GdF6ZH1a8spZnyWf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit 4750a171c3290f9bbebca16c6372db723a4cfa3b upstream.

[ For 5.4.y, SB_I_VERSION should be set in xfs_fs_remount() ]

The MS_I_VERSION mount flag is exposed via the VFS, as documented
in the mount manpages etc; see the iversion and noiversion mount
options in mount(8).

As a result, mount -o remount looks for this option in /proc/mounts
and will only send the I_VERSION flag back in during remount it it
is present.  Since it's not there, a remount will /remove/ the
I_VERSION flag at the vfs level, and iversion functionality is lost.

xfs v5 superblocks intend to always have i_version enabled; it is
set as a default at mount time, but is lost during remount for the
reasons above.

The generic fix would be to expose this documented option in
/proc/mounts, but since that was rejected, fix it up again in the
xfs remount path instead, so that at least xfs won't suffer from
this misbehavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2429acbfb132..f1407900aeef 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1228,6 +1228,10 @@ xfs_fs_remount(
 	char			*p;
 	int			error;
 
+	/* version 5 superblocks always support version counters. */
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+		*flags |= SB_I_VERSION;
+
 	/* First, check for complete junk; i.e. invalid options */
 	error = xfs_test_remount_options(sb, options);
 	if (error)
-- 
2.35.1

