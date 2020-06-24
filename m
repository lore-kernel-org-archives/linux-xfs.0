Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C50C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648A920706
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zc3/1uu8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404107AbgFXPg7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 11:36:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50864 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404137AbgFXPg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 11:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593013017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yOu7GsOeurHGDrokWNrt4CoYlJMhMdIL5QLaWJoaWfw=;
        b=Zc3/1uu8kVLahezoLIIMIovehtg8nT9aEdE+Ag14+KjOj4nLA++wg7WIe6JhWzmZ494oFn
        b55W2+mtEI43XAQGHhEWN2OLKSrH85tQIFG0CgTPisaR3FlXAmopN6GHEVL8tC94HUqIte
        +5+ZI7cDfOEAUDZH0O+SWh2Gvxzf65A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-fw9mTqgtNYKJyTHtNRpOGg-1; Wed, 24 Jun 2020 11:36:55 -0400
X-MC-Unique: fw9mTqgtNYKJyTHtNRpOGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A5E61005512;
        Wed, 24 Jun 2020 15:36:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19AC05BAC4;
        Wed, 24 Jun 2020 15:36:53 +0000 (UTC)
Date:   Wed, 24 Jun 2020 11:36:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: xfs_iflock is no longer a completion
Message-ID: <20200624153652.GD9914@bfoster>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623095015.1934171-2-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 07:50:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the recent rework of the inode cluster flushing, we no longer
> ever wait on the the inode flush "lock". It was never a lock in the
> first place, just a completion to allow callers to wait for inode IO
> to complete. We now never wait for flush completion as all inode
> flushing is non-blocking. Hence we can get rid of all the iflock
> infrastructure and instead just set and check a state flag.
> 
> Rename the XFS_IFLOCK flag to XFS_IFLUSHING, convert all the
> xfs_iflock_nowait() test-and-set operations on that flag, and
> replace all the xfs_ifunlock() calls to clear operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

I'd call it IFLUSHED vs. IFLUSHING, but I'm not going to harp on that.
Just a few nits, otherwise looks like a nice cleanup.

>  fs/xfs/xfs_icache.c     | 19 ++++++------
>  fs/xfs/xfs_inode.c      | 67 +++++++++++++++--------------------------
>  fs/xfs/xfs_inode.h      | 33 +-------------------
>  fs/xfs/xfs_inode_item.c |  6 ++--
>  fs/xfs/xfs_inode_item.h |  4 +--
>  5 files changed, 39 insertions(+), 90 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a973f180c6cd..0d73559f2d58 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
...
> @@ -1045,23 +1044,23 @@ xfs_reclaim_inode(
>  
>  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  		goto out;
> -	if (!xfs_iflock_nowait(ip))
> +	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
>  		goto out_iunlock;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
>  		/* xfs_iflush_abort() drops the flush lock */

The flush what? ;P

>  		xfs_iflush_abort(ip);
> +		ASSERT(!xfs_iflags_test(ip, XFS_IFLUSHING));

Seems a bit superfluous right after the abort.

>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip))
> -		goto out_ifunlock;
> +		goto out_clear_flush;
>  	if (!xfs_inode_clean(ip))
> -		goto out_ifunlock;
> +		goto out_clear_flush;
>  
> -	xfs_ifunlock(ip);
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
>  reclaim:
> -	ASSERT(!xfs_isiflocked(ip));
>  
>  	/*
>  	 * Because we use RCU freeing we need to ensure the inode always appears
...
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 3840117f8a5e..0494b907c63d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -492,7 +492,7 @@ xfs_inode_item_push(
>  		return XFS_ITEM_PINNED;
>  
>  	/* If the inode is already flush locked, we're already flushing. */

Another "flush lock" instance. Perhaps:

"If the inode is already flushing, we're already flushing"

(i.e. kill the comment) ;)

Brian

> -	if (xfs_isiflocked(ip))
> +	if (xfs_iflags_test(ip, XFS_IFLUSHING))
>  		return XFS_ITEM_FLUSHING;
>  
>  	if (!xfs_buf_trylock(bp))
> @@ -702,7 +702,7 @@ xfs_iflush_finish(
>  		iip->ili_last_fields = 0;
>  		iip->ili_flush_lsn = 0;
>  		spin_unlock(&iip->ili_lock);
> -		xfs_ifunlock(iip->ili_inode);
> +		xfs_iflags_clear(iip->ili_inode, XFS_IFLUSHING);
>  		if (drop_buffer)
>  			xfs_buf_rele(bp);
>  	}
> @@ -789,7 +789,7 @@ xfs_iflush_abort(
>  		list_del_init(&iip->ili_item.li_bio_list);
>  		spin_unlock(&iip->ili_lock);
>  	}
> -	xfs_ifunlock(ip);
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
>  	if (bp)
>  		xfs_buf_rele(bp);
>  }
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 048b5e7dee90..23a7b4928727 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -25,8 +25,8 @@ struct xfs_inode_log_item {
>  	 *
>  	 * We need atomic changes between inode dirtying, inode flushing and
>  	 * inode completion, but these all hold different combinations of
> -	 * ILOCK and iflock and hence we need some other method of serialising
> -	 * updates to the flush state.
> +	 * ILOCK and IFLUSHING and hence we need some other method of
> +	 * serialising updates to the flush state.
>  	 */
>  	spinlock_t		ili_lock;	   /* flush state lock */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
> -- 
> 2.26.2.761.g0e0b3e54be
> 

