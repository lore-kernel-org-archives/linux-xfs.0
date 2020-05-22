Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E9EC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F25420759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sz3yTDgt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgEVMXu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:23:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728409AbgEVMXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590150229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zT5Vc/BxL2/wP8oGJRgei885/XL+DaXoFZ1dotfBOmg=;
        b=Sz3yTDgtexRzG2AVLhPP2iM8GDihSB4EwhTvQjA9S/HqKn/f7c7Da9f+e9lwUFEC+UJmfO
        ltCWnYy2NP51v0XIWC5iBgFOqYN9as11Myr/0f97XJXkKNgVJOu2DTyKyaZ9Jc+32Ir2q+
        bnRFvbiHLXRmDmjXKW+J2RWwF8Ie1v8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-Y17wysXNO5yiQ4o3lIx_oQ-1; Fri, 22 May 2020 08:23:47 -0400
X-MC-Unique: Y17wysXNO5yiQ4o3lIx_oQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF4F1835B40;
        Fri, 22 May 2020 12:23:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3905B5C1D0;
        Fri, 22 May 2020 12:23:46 +0000 (UTC)
Date:   Fri, 22 May 2020 08:23:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: move xfs_inode_ag_iterator to be closer to
 the perag walking code
Message-ID: <20200522122344.GK50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011607216.77079.15513788306075418133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011607216.77079.15513788306075418133.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the xfs_inode_ag_iterator function to be nearer xfs_inode_ag_walk
> so that we don't have to scroll back and forth to figure out how the
> incore inode walking function works.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |   88 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 48 insertions(+), 40 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 791544a1d54c..0e25d50372e2 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -791,6 +791,10 @@ xfs_inode_ag_walk_grab(
>  	return false;
>  }
>  
> +/*
> + * For a given per-AG structure @pag, grab, @execute, and rele all incore
> + * inodes with the given radix tree @tag.
> + */
>  STATIC int
>  xfs_inode_ag_walk(
>  	struct xfs_mount	*mp,
> @@ -896,6 +900,50 @@ xfs_inode_ag_walk(
>  	return last_error;
>  }
>  
> +/* Fetch the next (possibly tagged) per-AG structure. */
> +static inline struct xfs_perag *
> +xfs_inode_walk_get_perag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	int			tag)
> +{
> +	if (tag == XFS_ICI_NO_TAG)
> +		return xfs_perag_get(mp, agno);
> +	return xfs_perag_get_tag(mp, agno, tag);
> +}
> +
> +/*
> + * Call the @execute function on all incore inodes matching the radix tree
> + * @tag.
> + */
> +int
> +xfs_inode_ag_iterator(
> +	struct xfs_mount	*mp,
> +	int			iter_flags,
> +	int			(*execute)(struct xfs_inode *ip, void *args),
> +	void			*args,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag;
> +	int			error = 0;
> +	int			last_error = 0;
> +	xfs_agnumber_t		ag;
> +
> +	ag = 0;
> +	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
> +		ag = pag->pag_agno + 1;
> +		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
> +				iter_flags);
> +		xfs_perag_put(pag);
> +		if (error) {
> +			last_error = error;
> +			if (error == -EFSCORRUPTED)
> +				break;
> +		}
> +	}
> +	return last_error;
> +}
> +
>  /*
>   * Background scanning to trim post-EOF preallocated space. This is queued
>   * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
> @@ -959,46 +1007,6 @@ xfs_cowblocks_worker(
>  	xfs_queue_cowblocks(mp);
>  }
>  
> -/* Fetch the next (possibly tagged) per-AG structure. */
> -static inline struct xfs_perag *
> -xfs_inode_walk_get_perag(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno,
> -	int			tag)
> -{
> -	if (tag == XFS_ICI_NO_TAG)
> -		return xfs_perag_get(mp, agno);
> -	return xfs_perag_get_tag(mp, agno, tag);
> -}
> -
> -int
> -xfs_inode_ag_iterator(
> -	struct xfs_mount	*mp,
> -	int			iter_flags,
> -	int			(*execute)(struct xfs_inode *ip, void *args),
> -	void			*args,
> -	int			tag)
> -{
> -	struct xfs_perag	*pag;
> -	int			error = 0;
> -	int			last_error = 0;
> -	xfs_agnumber_t		ag;
> -
> -	ag = 0;
> -	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
> -		ag = pag->pag_agno + 1;
> -		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
> -				iter_flags);
> -		xfs_perag_put(pag);
> -		if (error) {
> -			last_error = error;
> -			if (error == -EFSCORRUPTED)
> -				break;
> -		}
> -	}
> -	return last_error;
> -}
> -
>  /*
>   * Grab the inode for reclaim exclusively.
>   * Return 0 if we grabbed it, non-zero otherwise.
> 

