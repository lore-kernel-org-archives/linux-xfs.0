Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B638C433E1
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5812074B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZgK/Mg3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgFEQ0V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:26:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727081AbgFEQ0R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 12:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591374376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qzdDp4WGyQ6SHKJNB4/xXlXw59avDOeUSv8Rb5xajaU=;
        b=AZgK/Mg3R1IFa5aix1kBcHExmjmQ/LtmENPRVbSHjlx0xlitt8oonwdNO2lgFGnes6xlNM
        ndpUEA/Dw8vT1mmhWqyvJOFRfsah+ra4jemrWipngfSTK4hgwm+XB0TynIOMHcPIc9TGbW
        vJI2hjl7ortQbw25vGf8SlGhJR58FkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-jOVef61NPIWHBJzFDGQFQw-1; Fri, 05 Jun 2020 12:26:14 -0400
X-MC-Unique: jOVef61NPIWHBJzFDGQFQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0CC5107ACCA;
        Fri,  5 Jun 2020 16:26:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33ADC19932;
        Fri,  5 Jun 2020 16:26:13 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:26:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/30] xfs: allow multiple reclaimers per AG
Message-ID: <20200605162611.GC23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-20-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-20-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode reclaim will still throttle direct reclaim on the per-ag
> reclaim locks. This is no longer necessary as reclaim can run
> non-blocking now. Hence we can remove these locks so that we don't
> arbitrarily block reclaimers just because there are more direct
> reclaimers than there are AGs.
> 
> This can result in multiple reclaimers working on the same range of
> an AG, but this doesn't cause any apparent issues. Optimising the
> spread of concurrent reclaimers for best efficiency can be done in a
> future patchset.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c | 31 ++++++++++++-------------------
>  fs/xfs/xfs_mount.c  |  4 ----
>  fs/xfs/xfs_mount.h  |  1 -
>  3 files changed, 12 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 74032316ce5cc..c4ba8d7bc45bc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
...
> @@ -1298,11 +1293,9 @@ xfs_reclaim_inodes_ag(
>  
>  		} while (nr_found && !done && *nr_to_scan > 0);
>  
> -		if (trylock && !done)
> -			pag->pag_ici_reclaim_cursor = first_index;
> -		else
> -			pag->pag_ici_reclaim_cursor = 0;
> -		mutex_unlock(&pag->pag_ici_reclaim_lock);
> +		if (done)
> +			first_index = 0;
> +		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);

I thought the [READ|WRITE]_ONCE() macros had to do with ordering, not
necessarily atomicity. Is this write safe if we're running a 32-bit
kernel, for example? Outside of that the broader functional change seems
reasonable.

Brian

>  		xfs_perag_put(pag);
>  	}
>  	return skipped;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d5dcf98698600..03158b42a1943 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -148,7 +148,6 @@ xfs_free_perag(
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
>  		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
> -		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
>  }
> @@ -200,7 +199,6 @@ xfs_initialize_perag(
>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
>  		spin_lock_init(&pag->pag_ici_lock);
> -		mutex_init(&pag->pag_ici_reclaim_lock);
>  		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
>  		if (xfs_buf_hash_init(pag))
>  			goto out_free_pag;
> @@ -242,7 +240,6 @@ xfs_initialize_perag(
>  out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
>  out_free_pag:
> -	mutex_destroy(&pag->pag_ici_reclaim_lock);
>  	kmem_free(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
> @@ -252,7 +249,6 @@ xfs_initialize_perag(
>  			break;
>  		xfs_buf_hash_destroy(pag);
>  		xfs_iunlink_destroy(pag);
> -		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		kmem_free(pag);
>  	}
>  	return error;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 3725d25ad97e8..a72cfcaa4ad12 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -354,7 +354,6 @@ typedef struct xfs_perag {
>  	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
>  	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
>  	int		pag_ici_reclaimable;	/* reclaimable inodes */
> -	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
>  	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
>  
>  	/* buffer cache index */
> -- 
> 2.26.2.761.g0e0b3e54be
> 

