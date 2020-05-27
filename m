Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D8FC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 10:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35EBB2075F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 10:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I9F1TAQb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgE0Kkm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 06:40:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729828AbgE0Kkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 06:40:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590576040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GKqFh1LokXIjY3DgVizuOd9WZgjWSwk0elPxFeoMzOc=;
        b=I9F1TAQbzARBbOyytECJ3nS50EyeebgGSsG6I41JcED+61ewcqe7t8aP904UJtn1xhUfAF
        C0/H2vuJvVMwM3JYrwbg7xX6AgwocrjbnIfrSk+yxGuBUDOy7ev8kEhU8kDaMBcWhODJaa
        GbPL/XTUcze18c/jXFt0NZOHk6/RgiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-ZSu2m0JXMoyotZV-45G8ZQ-1; Wed, 27 May 2020 06:40:37 -0400
X-MC-Unique: ZSu2m0JXMoyotZV-45G8ZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C8C81855A10;
        Wed, 27 May 2020 10:40:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ED3E5D9EF;
        Wed, 27 May 2020 10:40:35 +0000 (UTC)
Date:   Wed, 27 May 2020 06:40:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] xfs: more lockdep whackamole with kmem_alloc*
Message-ID: <20200527104034.GA9256@bfoster>
References: <20200526163457.GK8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526163457.GK8230@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 09:34:57AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Dave Airlie reported the following lockdep complaint:
> 
> >  ======================================================
> >  WARNING: possible circular locking dependency detected
> >  5.7.0-0.rc5.20200515git1ae7efb38854.1.fc33.x86_64 #1 Not tainted
> >  ------------------------------------------------------
> >  kswapd0/159 is trying to acquire lock:
> >  ffff9b38d01a4470 (&xfs_nondir_ilock_class){++++}-{3:3},
> >  at: xfs_ilock+0xde/0x2c0 [xfs]
> >
> >  but task is already holding lock:
> >  ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
> >  __fs_reclaim_acquire+0x5/0x30
> >
> >  which lock already depends on the new lock.
> >
> >
> >  the existing dependency chain (in reverse order) is:
> >
> >  -> #1 (fs_reclaim){+.+.}-{0:0}:
> >         fs_reclaim_acquire+0x34/0x40
> >         __kmalloc+0x4f/0x270
> >         kmem_alloc+0x93/0x1d0 [xfs]
> >         kmem_alloc_large+0x4c/0x130 [xfs]
> >         xfs_attr_copy_value+0x74/0xa0 [xfs]
> >         xfs_attr_get+0x9d/0xc0 [xfs]
> >         xfs_get_acl+0xb6/0x200 [xfs]
> >         get_acl+0x81/0x160
> >         posix_acl_xattr_get+0x3f/0xd0
> >         vfs_getxattr+0x148/0x170
> >         getxattr+0xa7/0x240
> >         path_getxattr+0x52/0x80
> >         do_syscall_64+0x5c/0xa0
> >         entry_SYSCALL_64_after_hwframe+0x49/0xb3
> >
> >  -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
> >         __lock_acquire+0x1257/0x20d0
> >         lock_acquire+0xb0/0x310
> >         down_write_nested+0x49/0x120
> >         xfs_ilock+0xde/0x2c0 [xfs]
> >         xfs_reclaim_inode+0x3f/0x400 [xfs]
> >         xfs_reclaim_inodes_ag+0x20b/0x410 [xfs]
> >         xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
> >         super_cache_scan+0x190/0x1e0
> >         do_shrink_slab+0x184/0x420
> >         shrink_slab+0x182/0x290
> >         shrink_node+0x174/0x680
> >         balance_pgdat+0x2d0/0x5f0
> >         kswapd+0x21f/0x510
> >         kthread+0x131/0x150
> >         ret_from_fork+0x3a/0x50
> >
> >  other info that might help us debug this:
> >
> >   Possible unsafe locking scenario:
> >
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(fs_reclaim);
> >                                 lock(&xfs_nondir_ilock_class);
> >                                 lock(fs_reclaim);
> >    lock(&xfs_nondir_ilock_class);
> >
> >   *** DEADLOCK ***
> >
> >  4 locks held by kswapd0/159:
> >   #0: ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
> >  __fs_reclaim_acquire+0x5/0x30
> >   #1: ffffffffbbb7cef8 (shrinker_rwsem){++++}-{3:3}, at:
> >  shrink_slab+0x115/0x290
> >   #2: ffff9b39f07a50e8
> >  (&type->s_umount_key#56){++++}-{3:3}, at: super_cache_scan+0x38/0x1e0
> >   #3: ffff9b39f077f258
> >  (&pag->pag_ici_reclaim_lock){+.+.}-{3:3}, at:
> >  xfs_reclaim_inodes_ag+0x82/0x410 [xfs]
> 
> This is a known false positive because inodes cannot simultaneously be
> getting reclaimed and the target of a getxattr operation, but lockdep
> doesn't know that.  We can (selectively) shut up lockdep until either
> it gets smarter or we change inode reclaim not to require the ILOCK by
> applying a stupid GFP_NOLOCKDEP bandaid.
> 
> Reported-by: Dave Airlie <airlied@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Tested-by: Dave Airlie <airlied@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/kmem.h                 |    6 +++++-
>  fs/xfs/libxfs/xfs_attr_leaf.c |    2 +-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index fc87ea9f6843..34cbcfde9228 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -19,6 +19,7 @@ typedef unsigned __bitwise xfs_km_flags_t;
>  #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
>  #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
>  #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
> +#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0x0020u)
>  
>  /*
>   * We use a special process flag to avoid recursive callbacks into
> @@ -30,7 +31,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  {
>  	gfp_t	lflags;
>  
> -	BUG_ON(flags & ~(KM_NOFS|KM_MAYFAIL|KM_ZERO));
> +	BUG_ON(flags & ~(KM_NOFS | KM_MAYFAIL | KM_ZERO | KM_NOLOCKDEP));
>  
>  	lflags = GFP_KERNEL | __GFP_NOWARN;
>  	if (flags & KM_NOFS)
> @@ -49,6 +50,9 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  	if (flags & KM_ZERO)
>  		lflags |= __GFP_ZERO;
>  
> +	if (flags & KM_NOLOCKDEP)
> +		lflags |= __GFP_NOLOCKDEP;
> +
>  	return lflags;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index f3d18a1f5b20..2f7e89e4be3e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -488,7 +488,7 @@ xfs_attr_copy_value(
>  	}
>  
>  	if (!args->value) {
> -		args->value = kmem_alloc_large(valuelen, 0);
> +		args->value = kmem_alloc_large(valuelen, KM_NOLOCKDEP);
>  		if (!args->value)
>  			return -ENOMEM;
>  	}
> 

