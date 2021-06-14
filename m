Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213E2C2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 16:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDBD8613CD
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 16:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhFNQPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 12:15:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234590AbhFNQPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 12:15:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623687230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i5BX5VqxDJVtTKcdfqd67V1ShP8e5dusnDVEBudp4Kc=;
        b=hdKtHj8DSCCA8dvwdOc8Cq4V0qXMH7gNRVO5K8eyJmnoMtBMIbbuXsUcjLk6w0a6G66G5d
        S6F7kLMsQUx3hvC1D/mhCms/soGyQ/6AbKx+VgD5MKjXjK2h7QoSlcDYQpNrXWJHtjhUdE
        1nZfg6uIb0pgSugC0AYXqZfTCTfTS6s=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-2IoVDnpFOM2TehjftXw6pQ-1; Mon, 14 Jun 2021 12:13:49 -0400
X-MC-Unique: 2IoVDnpFOM2TehjftXw6pQ-1
Received: by mail-oo1-f69.google.com with SMTP id y13-20020a4acb8d0000b029024aa257b077so4533740ooq.5
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jun 2021 09:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i5BX5VqxDJVtTKcdfqd67V1ShP8e5dusnDVEBudp4Kc=;
        b=G+TBkjRSUp1pcAyq1aqy7CzKCDyjiaACfWVmpCKLfRIO0w1DAJD+7qDLGdl09XYfNC
         N3ga9jZ3xEfv++icnaQ1QkhREmc0q0W9EBi5aF12TFqYKFPNPjB6vyMg9tfXh4lwf+9R
         aUQRSQURI5YYpj37rkQfzhLW9iP5OkdsrwkedOJDd3LsKU30nDQj8gQ6A4Cflz6yLluo
         F0F7zza2piEq5Ag91/4PIdgghiuwosw5DAnWzK5auJRamCfcPJi19nKTWFJnynnHW2tw
         8d0Sy7/PfBqy7HsYU6BEkfCUi/0NP5l4FJNDUivz8lI0io4da9/Ig9kqR2njewfyuo2j
         9G+A==
X-Gm-Message-State: AOAM531s/fOSu9kfPVZlU8h/llzLQSajIoTjIT1xxsPoFoU+HM/8bUsD
        N9rWjT0FC7icSB7FdL4a1m3ikagL3vBrNHV6EAJt2l8p1qOziMpSf2hdw6ZBQf8oWP8DsfSLyua
        EEN29y5Le2YQHUiJLRao6
X-Received: by 2002:a05:6830:2707:: with SMTP id j7mr14291382otu.37.1623687227996;
        Mon, 14 Jun 2021 09:13:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjA42u9Me7jOwx85zMicIUFfYaDRGc7c/KjIEKbTBiziFkh+SrzLLYbp+Z0jB97m5Mx76SAw==
X-Received: by 2002:a05:6830:2707:: with SMTP id j7mr14291371otu.37.1623687227789;
        Mon, 14 Jun 2021 09:13:47 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 26sm1702629ooy.46.2021.06.14.09.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 09:13:47 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:13:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 03/16] xfs: detach dquots from inode if we don't need to
 inactivate it
Message-ID: <YMeAOGklQwQDZdSM@bfoster>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360481340.1530792.16718628800672012784.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360481340.1530792.16718628800672012784.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 13, 2021 at 10:20:13AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we don't need to inactivate an inode, we can detach the dquots and
> move on to reclamation.  This isn't strictly required here; it's a
> preparation patch for deferred inactivation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Seems functional, but a little more explanation on why we're doing this
might be helpful. Otherwise it's not really clear why we'd duplicate a
bunch of this logic (as opposed to refactor it), if we want to leave
around the obvious maintenance landmine, etc..?

Brian

>  fs/xfs/xfs_icache.c |    8 +++++++-
>  fs/xfs/xfs_inode.c  |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h  |    2 ++
>  3 files changed, 62 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a2d81331867b..7939eced3a47 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -338,8 +338,14 @@ xfs_inode_mark_reclaimable(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_perag	*pag;
> +	bool			need_inactive = xfs_inode_needs_inactive(ip);
>  
> -	xfs_inactive(ip);
> +	if (!need_inactive) {
> +		/* Going straight to reclaim, so drop the dquots. */
> +		xfs_qm_dqdetach(ip);
> +	} else {
> +		xfs_inactive(ip);
> +	}
>  
>  	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
>  		xfs_check_delalloc(ip, XFS_DATA_FORK);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3bee1cd20072..85b2b11b5217 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1654,6 +1654,59 @@ xfs_inactive_ifree(
>  	return 0;
>  }
>  
> +/*
> + * Returns true if we need to update the on-disk metadata before we can free
> + * the memory used by this inode.  Updates include freeing post-eof
> + * preallocations; freeing COW staging extents; and marking the inode free in
> + * the inobt if it is on the unlinked list.
> + */
> +bool
> +xfs_inode_needs_inactive(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +
> +	/*
> +	 * If the inode is already free, then there can be nothing
> +	 * to clean up here.
> +	 */
> +	if (VFS_I(ip)->i_mode == 0)
> +		return false;
> +
> +	/* If this is a read-only mount, don't do this (would generate I/O) */
> +	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		return false;
> +
> +	/* If the log isn't running, push inodes straight to reclaim. */
> +	if (XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_NORECOVERY))
> +		return false;
> +
> +	/* Metadata inodes require explicit resource cleanup. */
> +	if (xfs_is_metadata_inode(ip))
> +		return false;
> +
> +	/* Want to clean out the cow blocks if there are any. */
> +	if (cow_ifp && cow_ifp->if_bytes > 0)
> +		return true;
> +
> +	/* Unlinked files must be freed. */
> +	if (VFS_I(ip)->i_nlink == 0)
> +		return true;
> +
> +	/*
> +	 * This file isn't being freed, so check if there are post-eof blocks
> +	 * to free.  @force is true because we are evicting an inode from the
> +	 * cache.  Post-eof blocks must be freed, lest we end up with broken
> +	 * free space accounting.
> +	 *
> +	 * Note: don't bother with iolock here since lockdep complains about
> +	 * acquiring it in reclaim context. We have the only reference to the
> +	 * inode at this point anyways.
> +	 */
> +	return xfs_can_free_eofblocks(ip, true);
> +}
> +
>  /*
>   * xfs_inactive
>   *
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 4b6703dbffb8..e3137bbc7b14 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -493,6 +493,8 @@ extern struct kmem_zone	*xfs_inode_zone;
>  /* The default CoW extent size hint. */
>  #define XFS_DEFAULT_COWEXTSZ_HINT 32
>  
> +bool xfs_inode_needs_inactive(struct xfs_inode *ip);
> +
>  int xfs_iunlink_init(struct xfs_perag *pag);
>  void xfs_iunlink_destroy(struct xfs_perag *pag);
>  
> 

