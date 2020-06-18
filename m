Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A3CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49AE62075E
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wIXZR245"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgFRPXF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:23:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbgFRPXE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 11:23:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IFLs3J065365;
        Thu, 18 Jun 2020 15:22:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eNWfmZdmYXiX9iEWGc/gueYpgw2Nhm+0CuXBMAUoTzQ=;
 b=wIXZR245s7LeBjWPKEu7t7v1oJWf6q+0hI/AIZddWx2b4HDKDTKqsD1LG+xh6mQdMVuf
 52CyI5MK6bIi7tW4TF37c50hAfiVp/jpURRlc+hOYs3JH5FxDCFkRzISnP2U/ncbDIAt
 6riGGd4hMpcqr6VgCV3WjXF76pwSyM8959gM2d065pEPuvbjHMO7VLy9hX6SZro4JkR2
 U8JS28PQUNVnorHGVmaeSF5hyeDAEVUzMaPeZI8j0phWOyFqc/ENIxIcwSpr7c790FLd
 uQQvsiq6WvWpvxrOgf1fBNKKP6ceOeISihmN0VQ6/JAzAPlct+479JixCFuB7B+FKNkV fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31q6601uqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 15:22:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IFJFms136555;
        Thu, 18 Jun 2020 15:20:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31q66sgkt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 15:20:58 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05IFKqLe017468;
        Thu, 18 Jun 2020 15:20:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 08:20:52 -0700
Date:   Thu, 18 Jun 2020 08:20:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Waiman Long <longman@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200618152051.GU11245@magnolia>
References: <20200618150557.23741-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618150557.23741-1-longman@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=1 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 11:05:57AM -0400, Waiman Long wrote:
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
> calls. This is what PF_MEMALLOC_NOFS per-process flag is for. This does
> reduce the potential source of memory where reclaim can be done. This
> shouldn't really matter unless the system is really running out of
> memory.  In that particular case, the filesystem freeze operation may
> fail while it was succeeding previously.
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
> ---
>  fs/xfs/xfs_super.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 379cbff438bc..6a95c82f2f1b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -913,11 +913,33 @@ xfs_fs_freeze(
>  	struct super_block	*sb)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	unsigned long pflags;
> +	int ret;

Minor nit: please indent the variable names to line up with *sb/*mp.

Otherwise this seems reasoanble.

--D

>  
> +	/*
> +	 * A fs_reclaim pseudo lock is added to check for potential deadlock
> +	 * condition with fs reclaim. The following lockdep splat was hit
> +	 * occasionally. This is actually a false positive as the allocation
> +	 * is being done only after the frozen filesystem is no longer dirty.
> +	 * One way to avoid this splat is to add GFP_NOFS to the affected
> +	 * allocation calls. This is what PF_MEMALLOC_NOFS is for.
> +	 *
> +	 *       CPU0                    CPU1
> +	 *       ----                    ----
> +	 *  lock(sb_internal);
> +	 *                               lock(fs_reclaim);
> +	 *                               lock(sb_internal);
> +	 *  lock(fs_reclaim);
> +	 *
> +	 *  *** DEADLOCK ***
> +	 */
> +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
>  	xfs_stop_block_reaping(mp);
>  	xfs_save_resvblks(mp);
>  	xfs_quiesce_attr(mp);
> -	return xfs_sync_sb(mp, true);
> +	ret = xfs_sync_sb(mp, true);
> +	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> +	return ret;
>  }
>  
>  STATIC int
> -- 
> 2.18.1
> 
