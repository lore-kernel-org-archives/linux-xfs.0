Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEED4C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A212067D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xUm8TAgC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgGMQlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:41:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729751AbgGMQlW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 12:41:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGM1J5177362;
        Mon, 13 Jul 2020 16:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OdIBi5hUo2/VqBKmf+cLwz5gWjKz/BgHq+yufd/HaRc=;
 b=xUm8TAgCkMgEOV9iB5QC8oH+4bIqa5sbM53IYKuzPyH79yZpFXxHVVoAL/45Mcw9p2Pe
 NN1fRoa3b3+y3C3CgkuUkHi+4cvm9oHTbYFrcTtEQwzq7f4x6aCAr7UJyq0A1MAntc9j
 5tHEMdRdpkSDfXarvtNn/BxoXBSGsBICq/ppkvXlLsHpyB1XqA+n7zr3ZDYeMUDTjRvN
 z0DEpTsvtHgOrwh/zFbXt6aFUwIqkK8vQ8m8oJY1L/bpjzdp7E7NPuoVXRPqmUNGIRzf
 yqPjnKTCLyHt2EmdJUHcQIBPQmX0nYJd52xwTa3uzbachCZEjWB/VT4GxZrlv0m/qjbl tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274ur06s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 16:41:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGMZu6094523;
        Mon, 13 Jul 2020 16:41:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 327qbvvtg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 16:41:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06DGfDmK031181;
        Mon, 13 Jul 2020 16:41:13 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 09:41:13 -0700
Date:   Mon, 13 Jul 2020 09:41:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Waiman Long <longman@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v6] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200713164112.GZ7606@magnolia>
References: <20200707191629.13911-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707191629.13911-1-longman@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 03:16:29PM -0400, Waiman Long wrote:
> Depending on the workloads, the following circular locking dependency
> warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
> lock) may show up:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.0.0-rc1+ #60 Tainted: G        W
> ------------------------------------------------------
> fsfreeze/4346 is trying to acquire lock:
> 0000000026f1d784 (fs_reclaim){+.+.}, at:
> fs_reclaim_acquire.part.19+0x5/0x30
> 
> but task is already holding lock:
> 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> 
> which lock already depends on the new lock.
>   :
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(sb_internal);
>                                lock(fs_reclaim);
>                                lock(sb_internal);
>   lock(fs_reclaim);
> 
>  *** DEADLOCK ***
> 
> 4 locks held by fsfreeze/4346:
>  #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
>  #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
>  #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
>  #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> 
> stack backtrace:
> Call Trace:
>  dump_stack+0xe0/0x19a
>  print_circular_bug.isra.10.cold.34+0x2f4/0x435
>  check_prev_add.constprop.19+0xca1/0x15f0
>  validate_chain.isra.14+0x11af/0x3b50
>  __lock_acquire+0x728/0x1200
>  lock_acquire+0x269/0x5a0
>  fs_reclaim_acquire.part.19+0x29/0x30
>  fs_reclaim_acquire+0x19/0x20
>  kmem_cache_alloc+0x3e/0x3f0
>  kmem_zone_alloc+0x79/0x150
>  xfs_trans_alloc+0xfa/0x9d0
>  xfs_sync_sb+0x86/0x170
>  xfs_log_sbcount+0x10f/0x140
>  xfs_quiesce_attr+0x134/0x270
>  xfs_fs_freeze+0x4a/0x70
>  freeze_super+0x1af/0x290
>  do_vfs_ioctl+0xedc/0x16c0
>  ksys_ioctl+0x41/0x80
>  __x64_sys_ioctl+0x73/0xa9
>  do_syscall_64+0x18f/0xd23
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> This is a false positive as all the dirty pages are flushed out before
> the filesystem can be frozen.
> 
> One way to avoid this splat is to add GFP_NOFS to the affected allocation
> calls by using the memalloc_nofs_save()/memalloc_nofs_restore() pair.
> This shouldn't matter unless the system is really running out of memory.
> In that particular case, the filesystem freeze operation may fail while
> it was succeeding previously.
> 
> Without this patch, the command sequence below will show that the lock
> dependency chain sb_internal -> fs_reclaim exists.
> 
>  # fsfreeze -f /home
>  # fsfreeze --unfreeze /home
>  # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
> 
> After applying the patch, such sb_internal -> fs_reclaim lock dependency
> chain can no longer be found. Because of that, the locking dependency
> warning will not be shown.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Waiman Long <longman@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 379cbff438bc..0797a96b83d6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -913,11 +913,21 @@ xfs_fs_freeze(
>  	struct super_block	*sb)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	unsigned int		flags;
> +	int			ret;
>  
> +	/*
> +	 * The filesystem is now frozen far enough that memory reclaim
> +	 * cannot safely operate on the filesystem. Hence we need to
> +	 * set a GFP_NOFS context here to avoid recursion deadlocks.
> +	 */
> +	flags = memalloc_nofs_save();
>  	xfs_stop_block_reaping(mp);
>  	xfs_save_resvblks(mp);
>  	xfs_quiesce_attr(mp);
> -	return xfs_sync_sb(mp, true);
> +	ret = xfs_sync_sb(mp, true);
> +	memalloc_nofs_restore(flags);
> +	return ret;
>  }
>  
>  STATIC int
> -- 
> 2.18.1
> 
