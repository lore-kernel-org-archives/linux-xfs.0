Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB75C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 198B46124C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243228AbhDLQEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:04:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241466AbhDLQEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 12:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618243430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IPh4+6I/Ra9ZmED+rmWa6G3GHP/eH+FgOi9WmxJcvM4=;
        b=OHvS6UhK2vczUVosnyzHiLpnL2ixwaiOXZMEumZ63VodLSpxnBVSPtsH+79VaukPdkc9i3
        w46BojXbbzjC4FKBDtVWWry8cqplPhd9WhEQ86AbrIoxp5EVJf0ZFtCpr2aHGPHUy2V41P
        NIl6vnnQqw6Znp204wUR4gXU7V31I4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-Ih9pFhijM6ycrT9pdTCcUA-1; Mon, 12 Apr 2021 12:03:47 -0400
X-MC-Unique: Ih9pFhijM6ycrT9pdTCcUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 399C410054F6;
        Mon, 12 Apr 2021 16:03:45 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C80C0610A8;
        Mon, 12 Apr 2021 16:03:44 +0000 (UTC)
Date:   Mon, 12 Apr 2021 12:03:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: remove XFS_IFBROOT
Message-ID: <YHRvXh+s1ksfbEjm@bfoster>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133819.2618857-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 03:38:17PM +0200, Christoph Hellwig wrote:
> Just check for a btree format fork instead of the using the equivalent
> in-memory XFS_IFBROOT flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c          | 16 +++++++---------
>  fs/xfs/libxfs/xfs_btree_staging.c |  1 -
>  fs/xfs/libxfs/xfs_inode_fork.c    |  4 +---
>  fs/xfs/libxfs/xfs_inode_fork.h    |  1 -
>  4 files changed, 8 insertions(+), 14 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index f464a7c7cf2246..aa8dc9521c3942 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -387,7 +387,6 @@ xfs_btree_bload_prep_block(
>  		new_size = bbl->iroot_size(cur, nr_this_block, priv);
>  		ifp->if_broot = kmem_zalloc(new_size, 0);
>  		ifp->if_broot_bytes = (int)new_size;
> -		ifp->if_flags |= XFS_IFBROOT;
>  
>  		/* Initialize it and send it out. */
>  		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,

IIRC, these bits are used in xfsprogs for efficient btree repair. Taking
a closer look, I see AG metadata btree repair implementations, but
nothing that seems to use the ifake variant. Am I missing something or
is this code currently unused?

In any event, the comments for xfs_btree_stage_ifakeroot() suggest that
->if_format should be initialized properly when a fake inode fork is
transferred to a cursor and the rest of the patch looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 73eea7939b55e4..02ad722004d3f4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -60,7 +60,7 @@ xfs_init_local_fork(
>  	}
>  
>  	ifp->if_bytes = size;
> -	ifp->if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
> +	ifp->if_flags &= ~XFS_IFEXTENTS;
>  	ifp->if_flags |= XFS_IFINLINE;
>  }
>  
> @@ -214,7 +214,6 @@ xfs_iformat_btree(
>  	xfs_bmdr_to_bmbt(ip, dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
>  			 ifp->if_broot, size);
>  	ifp->if_flags &= ~XFS_IFEXTENTS;
> -	ifp->if_flags |= XFS_IFBROOT;
>  
>  	ifp->if_bytes = 0;
>  	ifp->if_u1.if_root = NULL;
> @@ -433,7 +432,6 @@ xfs_iroot_realloc(
>  			XFS_BMBT_BLOCK_LEN(ip->i_mount));
>  	} else {
>  		new_broot = NULL;
> -		ifp->if_flags &= ~XFS_IFBROOT;
>  	}
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 06682ff49a5bfc..8ffaa7cc1f7c3f 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -32,7 +32,6 @@ struct xfs_ifork {
>   */
>  #define	XFS_IFINLINE	0x01	/* Inline data is read in */
>  #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
> -#define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
>  
>  /*
>   * Worst-case increase in the fork extent count when we're adding a single
> -- 
> 2.30.1
> 

