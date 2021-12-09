Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB33C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 14:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhLIOsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Dec 2021 09:48:24 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59472 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233886AbhLIOsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Dec 2021 09:48:24 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DuCJg006477;
        Thu, 9 Dec 2021 14:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cQgtYtby7zwAA5kD/2a5lMsEfumNDkEqvw3HCbA98bU=;
 b=Mmb84aBVGF0iYkoHr1ZWPFsCRVjkGUFLGzNCnnHjHaFLdnpGv5TYu7qZVd32SKwi1dr2
 tIiZ6c8W1iJEh011MDeiXgAwbBNO55BMElKDRB+mXjk7qxkX4x43k9L3zSk1VZypbgch
 e/dA8sA38Y8U859MLLndgx2VdHR1ppLyHy8nQivRjncnz20TQgK0KFW7qtRo7UORUhhr
 pXaqKkJ14X7kUDuMTqHa6wAVgp3aNBKu78wpBRROs0cx2UDvGYqtMUb4rYINypxsvp4a
 MiL0gsr2j679mj8d9nihm61io4Ftt+KUPVM8my+zMsjNhGw4ngg1Tt9OeuPGe1M7zbg9 qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctua7k5tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 14:44:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9EZHIv138392;
        Thu, 9 Dec 2021 14:44:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 3cqwf2856t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 14:44:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxkSh2zqbD/XadOSvksCDuI8FkNZVMi6eI0G+rEhQIO0dqjfNsv8YGQx1c5A583DQFZnIPI1nOSVwuFSDdfEnh1c9iEm5GHKzEcV7C5lVsRxfmVI2nHdEyGAU6/EG2GNsac3ePmECvftS3U+F41FXh4B2hn3KPcmbV2Myj50Oprs5j9cmjMsif90TgV6YZS/9NZYKjzkZHDRNMy8VLNFfuXqpkqfkO0IcO89Jfj+OaGMLsCmbEHW8/ygXsgz/CUDgs/0nqUQkpuz9LlpipVhvcXoay5GQncxkv/I5JraISxKGrXfja99KTvHLaskXCxYhiDqPbMyrk0MzCDVzEpxtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQgtYtby7zwAA5kD/2a5lMsEfumNDkEqvw3HCbA98bU=;
 b=MtQsBPv3gdSl+fq6ZORkemFfvrYf7GszA6659ruW1hz40kIrbe99N1+BODeRuJWZNvI7rtopIpbV/GMxzQqf9//LTu4nVJLFdhhYwqYe1vUbyRT4yCx6DA2s4aUQFUIjL6INx5+RvTKkRwp+muGwDzoZqwnMX6xqRv6aQBhzCNlQhYXq6Fb0rcsU4/+OohqpzL3u2RFHBFGpZIx3BpOx6HO0jkF5/JWVedJlgw/Ky8iAsTV9dcNk6SxLfzNXzQHqLQr9Y9ZBjf2aaJWaZ++1lvvOWxgdRH8KevS0NYhVyuUTWhGCT8ig/zMoG/e7mLol8rAPU8mRcCcrFg7e0tFkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQgtYtby7zwAA5kD/2a5lMsEfumNDkEqvw3HCbA98bU=;
 b=zsqm07hX0IbscdVd2Rp8//Uy85vkTeVdTUUROcaxPpJAx3+o+xmhByOnrpCsj0xZKjhsRFBzpTF5ilUx4IZd2RmngDfYZ3SK+r+t2+HV3tESy3WCRLTzUuFSzstOzx/PW4nUmO9I2+1LUhKT9FmkQfcFsAkPU4hnOzE2sjGQ76o=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2752.namprd10.prod.outlook.com (2603:10b6:805:3f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Thu, 9 Dec
 2021 14:44:44 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 14:44:44 +0000
References: <163900530491.374528.3847809977076817523.stgit@magnolia>
 <163900531629.374528.14641806907962114873.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/2] xfs: only run COW extent recovery when there are no
 live extents
In-reply-to: <163900531629.374528.14641806907962114873.stgit@magnolia>
Message-ID: <87zgp9x2gc.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 09 Dec 2021 20:14:35 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0118.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::34) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.40) by TYAPR01CA0118.jpnprd01.prod.outlook.com (2603:1096:404:2a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.24 via Frontend Transport; Thu, 9 Dec 2021 14:44:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f82f00c8-1fe5-49c4-0fa5-08d9bb227049
X-MS-TrafficTypeDiagnostic: SN6PR10MB2752:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB27522082B64D98FA0CD11D8CF6709@SN6PR10MB2752.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RObeH0X9QTj9s/C5rLhMNCC+XdRDn10P6y2HTbdJzUvBD81RzLbJu6acnKfc9zUDa87kv9KZjDKpg1/545N3rbsncUiq7aIzMMMrMrDn3q8I3jury4xvlVnBUi0YAofNRfvH5R6PbpkSxERPUxMw0C4BRCFXiTQUxcp3RHlcFE9UGJDwC6L2X2LUYZJmMEOmUsHaInkKqTFUUltmhYe4gRWVk2m2z859NHAQ8N6fk7sb/wOgps7PN7MpnJoFrVsg1ZJ1u0uUDY67vtpZHfAI/Bmfjoco2k4WAebdTDBbApJTcI/bDtJwIEk7dhR/lbdb2vwZHYwBaSt5R9u6/c3wYPA5w7Xk+ioqWBoovtCEYh+/B5RX6O6G5H0fBJj6baHUaphv9i9VGH90Qra7BhYuXmQHSJXoWKmuAOw6TlTQk2xLA6cwOJbys3URKZXPlF3xlDS0AFHib0c7+DrSIGw//aZlR95wKJEtBoAbMQzYWT2O87FgzsZHJgu8+sGi7O1KQdfDTA/9hKJiHyKJMJjKXWOz9TiP2Yi7LuRP+w5hcyN7DRcnj3fKzo31NNmSONe9vLi2XIB+N2hakhmac0zHzjmjRXnGKrpDCNl0MKGgT82K8fWeolQUcgV2SZvuDXNZIv+rF3mbL24O40CGbRHnregb++7RC9RNu78kzA0TFRmisQBO9oxx45Mtw1rRsFwLUStdKS306ZE2E/eOz1EHyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(107886003)(26005)(66946007)(186003)(508600001)(66476007)(6496006)(6666004)(9686003)(4326008)(66556008)(956004)(53546011)(83380400001)(38350700002)(38100700002)(86362001)(2906002)(8676002)(6486002)(33716001)(5660300002)(316002)(52116002)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P3kUEn7FDEahnccf6cX/dobEUXGCdVFXWSiyeHLjuDToK9rHycfOQo695mIe?=
 =?us-ascii?Q?K34PvAfv3PSH01PhpnFQFX/LM7HVd65cZjMdljS8wZih6+L7xCQsjhPIwg8l?=
 =?us-ascii?Q?i0WZKnWnBYD03Zk4h3uAC4xZ1VdpLsJOfbrNRwzEJanJWev45mYte3qfsh2X?=
 =?us-ascii?Q?iopHIX12+dQbHL5k7RPINLIwk6X2KizFvPHK1Q+yy0uGtaeXvrHaE08bCbgm?=
 =?us-ascii?Q?/EVx6NBziO6rKWeO+oqoYVDlEstLk/Vk6NcOXnCJGbBAks7EKuawbzyHu/nT?=
 =?us-ascii?Q?UK/nDnSh57zq+gHIYrdFLL8tZTrRbMLw4d6rGlreR3NA0xW/4FMoVXCO3qUl?=
 =?us-ascii?Q?FoEuZJY6TC7w4Am64eX+NSQuiSG4f5TScfIqHtGMon9gVuYZfEXNlDRRCTGS?=
 =?us-ascii?Q?Eg6pV650y6ctslkmXFXLYnsLIDxu6YoXgjzubKzbt30K+DZiXZHllgvtqBAZ?=
 =?us-ascii?Q?y6OWmDvzf1C+xieDkmWisvetWMrmfvsvwwFoCchJwdMRoOCi1Wbf9WupEA87?=
 =?us-ascii?Q?JH/JP9XC7TSro4ZkGZtlhXdRi94YmqzJs7pyZY7zv9oqpYk4UHz5KakBmEPG?=
 =?us-ascii?Q?u1kNO8c5Qb1A1WIQGVebTeA2e/zXxAoJbTvCNSSJbhyMbR7jgcRhdHuC76I8?=
 =?us-ascii?Q?gA3myxReiscArHECMu5S7rlx+b0Qird8pfwio+4BFJlw7VF9v9pRfbpgpPMA?=
 =?us-ascii?Q?R63HbtPYoIEyo7FSiU6R7XO6bZGHrnagrDjxMEQhCd7iFCuzMqcNGemNtxU2?=
 =?us-ascii?Q?l9opdbGhL1NMTeZ5zS26Vx4691V2z2U8Xo0ZKCaaWq0mkA6JsaLlShb3gyE7?=
 =?us-ascii?Q?ceeAStJy8hXq3CNot/dCQEvmnDI7nhLdyeWBlMHVz3jdmLouH7IzOUN+KhV6?=
 =?us-ascii?Q?yQ0DQB3GdJl13JC3v5htpp0RYNt/uYHY72ZbrfRiL0WTzdCXk1fTP6yYit9H?=
 =?us-ascii?Q?9PfOyarrxZjqAjl3Ek1mpp+n+rSeKC1piCXZ0JHibAUHfBdjiMz5a7Ao7aFS?=
 =?us-ascii?Q?Wy0TTeuce1rmh7KqUwJG2NVKkeBg2RELUdEd50HNXt7dQ3kHGWZuJNmAFw+P?=
 =?us-ascii?Q?KNOIJ62UXUiCr2XpkZ3mVsIDyFgf0EAletkuFUdfiZDCPTDe54cBiAQEdj++?=
 =?us-ascii?Q?aiALK40xmtyE/io79pCe7Kd5zw39hdskZQrMUdQvLq5IIXi0G4JmvwRMkvOH?=
 =?us-ascii?Q?jJYKyq+0bULNvh7q7o1weGgJVZu2gFg5bmCMHX+ocZ2qiueHz+3wDBpvVWya?=
 =?us-ascii?Q?IAybOLe5jiqD07p8sfqEKwPA6qFWRxPMwcYKJwp1+72B/7dvvBXyPjNJaEu4?=
 =?us-ascii?Q?XVlDRyojyl2xJWvXUHtYmH3aSLuaKD8yCm/ua2FqF4hP7bsS+7byxDCiQavN?=
 =?us-ascii?Q?dgwCDU7xHsI1tDZv812mTrInWX/TlBFOXARiremn6PvxJs7282TxD+5d/jX4?=
 =?us-ascii?Q?uOriRzns3lTeyiZPahSx/B6RA44CanXGgG44RC9tZ3UqT3FAfMZfd3J9zNKx?=
 =?us-ascii?Q?yP56QXi6kBRuIjvaFhfllM0OWb4ikVTujqhMBd0n6ntb+4/lFvHsLIgc1Bqd?=
 =?us-ascii?Q?/gGxDuNDuhmmx9II2GhNijX524Cq9DMJlNswK55/7OHSzGte9ng/X/6KXS9j?=
 =?us-ascii?Q?TvXQW412LuT9a6E5of9iMjM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f82f00c8-1fe5-49c4-0fa5-08d9bb227049
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 14:44:44.0079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: itkbdPZQCri55wDAByU2aP5lF2IXCeBlIchUM00QcskMXkFcPkfJttMeqgINKW/bCW/2Fua06SClJ4zABbYGcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2752
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10192 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090079
X-Proofpoint-ORIG-GUID: dmQck2VV1F9UQnajZz34lBFEH65p7Fwb
X-Proofpoint-GUID: dmQck2VV1F9UQnajZz34lBFEH65p7Fwb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Dec 2021 at 04:45, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> As part of multiple customer escalations due to file data corruption
> after copy on write operations, I wrote some fstests that use fsstress
> to hammer on COW to shake things loose.  Regrettably, I caught some
> filesystem shutdowns due to incorrect rmap operations with the following
> loop:
>
> mount <filesystem>				# (0)
> fsstress <run only readonly ops> &		# (1)
> while true; do
> 	fsstress <run all ops>
> 	mount -o remount,ro			# (2)
> 	fsstress <run only readonly ops>
> 	mount -o remount,rw			# (3)
> done
>
> When (2) happens, notice that (1) is still running.  xfs_remount_ro will
> call xfs_blockgc_stop to walk the inode cache to free all the COW
> extents, but the blockgc mechanism races with (1)'s reader threads to
> take IOLOCKs and loses, which means that it doesn't clean them all out.
> Call such a file (A).
>
> When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
> walks the ondisk refcount btree and frees any COW extent that it finds.
> This function does not check the inode cache, which means that incore
> COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
> one of those former COW extents are allocated and mapped into another
> file (B) and someone triggers a COW to the stale reservation in (A), A's
> dirty data will be written into (B) and once that's done, those blocks
> will be transferred to (A)'s data fork without bumping the refcount.
>
> The results are catastrophic -- file (B) and the refcount btree are now
> corrupt.  In the first patch, we fixed the race condition in (2) so that
> (A) will always flush the COW fork.  In this second patch, we move the
> _recover_cow call to the initial mount call in (0) for safety.
>
> As mentioned previously, xfs_reflink_recover_cow walks the refcount
> btree looking for COW staging extents, and frees them.  This was
> intended to be run at mount time (when we know there are no live inodes)
> to clean up any leftover staging events that may have been left behind
> during an unclean shutdown.  As a time "optimization" for readonly
> mounts, we deferred this to the ro->rw transition, not realizing that
> any failure to clean all COW forks during a rw->ro transition would
> result in catastrophic corruption.
>
> Therefore, remove this optimization and only run the recovery routine
> when we're guaranteed not to have any COW staging extents anywhere,
> which means we always run this at mount time.  While we're at it, move
> the callsite to xfs_log_mount_finish because any refcount btree
> expansion (however unlikely given that we're removing records from the
> right side of the index) must be fed by a per-AG reservation, which
> doesn't exist in its current location.
>

With Dave's review comments addressed,

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c     |   23 ++++++++++++++++++++++-
>  fs/xfs/xfs_mount.c   |   10 ----------
>  fs/xfs/xfs_reflink.c |    5 ++++-
>  fs/xfs/xfs_super.c   |    9 ---------
>  4 files changed, 26 insertions(+), 21 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 89fec9a18c34..c17344fc1275 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_inode.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_trans.h"
> @@ -20,6 +21,7 @@
>  #include "xfs_sysfs.h"
>  #include "xfs_sb.h"
>  #include "xfs_health.h"
> +#include "xfs_reflink.h"
>  
>  struct kmem_cache	*xfs_log_ticket_cache;
>  
> @@ -847,9 +849,28 @@ xfs_log_mount_finish(
>  	/* Make sure the log is dead if we're returning failure. */
>  	ASSERT(!error || xlog_is_shutdown(log));
>  
> -	return error;
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Recover any CoW staging blocks that are still referenced by the
> +	 * ondisk refcount metadata.  During mount there cannot be any live
> +	 * staging extents as we have not permitted any user modifications.
> +	 * Therefore, it is safe to free them all right now, even on a
> +	 * read-only mount.
> +	 */
> +	error = xfs_reflink_recover_cow(mp);
> +	if (error) {
> +		xfs_err(mp, "Error %d recovering leftover CoW allocations.",
> +				error);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	return 0;
>  }
>  
> +
>  /*
>   * The mount has failed. Cancel the recovery if it hasn't completed and destroy
>   * the log.
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 359109b6f0d3..bed73e8002a5 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -936,15 +936,6 @@ xfs_mountfs(
>  			xfs_warn(mp,
>  	"Unable to allocate reserve blocks. Continuing without reserve pool.");
>  
> -		/* Recover any CoW blocks that never got remapped. */
> -		error = xfs_reflink_recover_cow(mp);
> -		if (error) {
> -			xfs_err(mp,
> -	"Error %d recovering leftover CoW allocations.", error);
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -			goto out_quota;
> -		}
> -
>  		/* Reserve AG blocks for future btree expansion. */
>  		error = xfs_fs_reserve_ag_blocks(mp);
>  		if (error && error != -ENOSPC)
> @@ -955,7 +946,6 @@ xfs_mountfs(
>  
>   out_agresv:
>  	xfs_fs_unreserve_ag_blocks(mp);
> - out_quota:
>  	xfs_qm_unmount_quotas(mp);
>   out_rtunmount:
>  	xfs_rtunmount_inodes(mp);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index cb0edb1d68ef..8b6c7163f684 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -749,7 +749,10 @@ xfs_reflink_end_cow(
>  }
>  
>  /*
> - * Free leftover CoW reservations that didn't get cleaned out.
> + * Free all CoW staging blocks that are still referenced by the ondisk refcount
> + * metadata.  The ondisk metadata does not track which inode created the
> + * staging extent, so callers must ensure that there are no cached inodes with
> + * live CoW staging extents.
>   */
>  int
>  xfs_reflink_recover_cow(
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 778b57b1f020..c7ac486ca5d3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1739,15 +1739,6 @@ xfs_remount_rw(
>  	 */
>  	xfs_restore_resvblks(mp);
>  	xfs_log_work_queue(mp);
> -
> -	/* Recover any CoW blocks that never got remapped. */
> -	error = xfs_reflink_recover_cow(mp);
> -	if (error) {
> -		xfs_err(mp,
> -			"Error %d recovering leftover CoW allocations.", error);
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		return error;
> -	}
>  	xfs_blockgc_start(mp);
>  
>  	/* Create the per-AG metadata reservation pool .*/


-- 
chandan
