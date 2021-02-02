Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6220EC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3278464F68
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhBBPoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 10:44:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235560AbhBBPkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 10:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612280344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZU9opts6oUy6ea4U85sQQG4EFT79ox5JTYfZ/Y7qZe4=;
        b=IwQAMWhqgjrynbThzmsSkDozqPpo8M2Xf2hwf2k7gJnPaSEAKTCPC/UUnwBSW0GS9Jnxhx
        nfD/RodTCWYOhKpydNceUpcAxVFT4c6noxMsbyhaKSaC9MzzEHvFvjzP69KH64WOEpyofG
        MNG4YJU3HyRZygctdLoL/fBe8yQRu1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-771k8MCwN4igdeLH_lsAUw-1; Tue, 02 Feb 2021 10:39:03 -0500
X-MC-Unique: 771k8MCwN4igdeLH_lsAUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 242B11800D50;
        Tue,  2 Feb 2021 15:39:02 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 873DC5C230;
        Tue,  2 Feb 2021 15:39:01 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:38:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 07/12] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210202153859.GG3336100@bfoster>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214516600.140945.4401509001858536727.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214516600.140945.4401509001858536727.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:06:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a fs modification (data write, reflink, xattr set, fallocate, etc.)
> is unable to reserve enough quota to handle the modification, try
> clearing whatever space the filesystem might have been hanging onto in
> the hopes of speeding up the filesystem.  The flushing behavior will
> become particularly important when we add deferred inode inactivation
> because that will increase the amount of space that isn't actively tied
> to user data.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

(FWIW, I'm reviewing the patches from your reclaim-space-harder-5.12
branch as of this morning, which look like they have some deltas from
the posted versions based on Christoph's feedback.)

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |    5 +++++
>  fs/xfs/xfs_trans.c   |   10 ++++++++++
>  2 files changed, 15 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 086866f6e71f..725c7d8e4438 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1092,6 +1092,11 @@ xfs_reflink_remap_extent(
>  	 * count.  This is suboptimal, but the VFS flushed the dest range
>  	 * before we started.  That should have removed all the delalloc
>  	 * reservations, but we code defensively.
> +	 *
> +	 * xfs_trans_alloc_inode above already tried to grab an even larger
> +	 * quota reservation, and kicked off a blockgc scan if it couldn't.
> +	 * If we can't get a potentially smaller quota reservation now, we're
> +	 * done.
>  	 */
>  	if (!quota_reserved && !smap_real && dmap_written) {
>  		error = xfs_trans_reserve_quota_nblks(tp, ip,
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 466e1c86767f..f62c1c5f210f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -23,6 +23,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
> +#include "xfs_icache.h"
>  
>  kmem_zone_t	*xfs_trans_zone;
>  
> @@ -1046,8 +1047,10 @@ xfs_trans_alloc_inode(
>  {
>  	struct xfs_trans	*tp;
>  	struct xfs_mount	*mp = ip->i_mount;
> +	bool			retried = false;
>  	int			error;
>  
> +retry:
>  	error = xfs_trans_alloc(mp, resv, dblocks,
>  			rblocks / mp->m_sb.sb_rextsize,
>  			force ? XFS_TRANS_RESERVE : 0, &tp);
> @@ -1065,6 +1068,13 @@ xfs_trans_alloc_inode(
>  	}
>  
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> +	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
> +		xfs_trans_cancel(tp);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		xfs_blockgc_free_quota(ip, 0);
> +		retried = true;
> +		goto retry;
> +	}
>  	if (error)
>  		goto out_cancel;
>  
> 

