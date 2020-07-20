Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE63C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 15:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66CD422482
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 15:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dr+FFtEE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGTPcL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 11:32:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37969 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726858AbgGTPcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 11:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595259129;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WuO0ceoCrlI5WXUN1sWSIg1Q1X5L1heUQCujYy6OI5U=;
        b=dr+FFtEEHZfOORQeyMRiWp/aHfxgHzNtEgn3UM/mCXO2a6zYQkdVWUW3RtEszHOP1OjVn9
        jdn3Mr3/5HeXjAPO8tCjMi+G/couIHL6uyg+KCWx5D5qEll+7JnQcOIIbVSzcmh3oXtrWT
        tMbu4TSjkcHbr+X75CCgL1GxKADoAmw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-vnxIcrmOOIilaeTxaZfx1A-1; Mon, 20 Jul 2020 11:32:07 -0400
X-MC-Unique: vnxIcrmOOIilaeTxaZfx1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69853106B247;
        Mon, 20 Jul 2020 15:32:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4433C710A4;
        Mon, 20 Jul 2020 15:32:06 +0000 (UTC)
Received: from zmail18.collab.prod.int.phx2.redhat.com (zmail18.collab.prod.int.phx2.redhat.com [10.5.83.21])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0DB6D94EE2;
        Mon, 20 Jul 2020 15:32:06 +0000 (UTC)
Date:   Mon, 20 Jul 2020 11:32:03 -0400 (EDT)
From:   Waiman Long <longman@redhat.com>
Reply-To: Waiman Long <longman@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>
Message-ID: <104087053.24407245.1595259123778.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200713164112.GZ7606@magnolia>
References: <20200707191629.13911-1-longman@redhat.com> <20200713164112.GZ7606@magnolia>
Subject: Re: [PATCH v6] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.113.230, 10.4.195.2]
Thread-Topic: Fix false positive lockdep warning with sb_internal & fs_reclaim
Thread-Index: WmhqTmYfplYkpIlak7AmgyVLRnpP0Q==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



----- Original Message -----
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Waiman Long" <longman@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Dave Chinner" <david@fromorbit.com>, "Qian Cai" <cai@lca.pw>, "Eric Sandeen" <sandeen@redhat.com>
Sent: Monday, July 13, 2020 12:41:12 PM
Subject: Re: [PATCH v6] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim

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

Will this patch be merged into the xfs tree soon?

Thanks,
Longman

