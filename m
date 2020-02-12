Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A0DC2BA83
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 257EA20658
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rp+UsAC6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgBLPLX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 10:11:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25315 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727698AbgBLPLX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 10:11:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581520282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nvDjJ/Bmg0Ryix1uyH6V1CdmalGgVhE87UhnrmNdPPA=;
        b=Rp+UsAC6S68jDkoN7f2mxeZeYDPkk6qLcGq4644vff+P0eOQ+GvK3HhLYHxeW7QP0TAQJT
        Zszg0uPds2CnLUSeaBD0ygB6R3JschXbiwEamMsQLS+smQOvi3ojTw6TC/pCCZz5OyUCmY
        sx7gF3lqjIzBecM9I7TJt+0AUtvo+DA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-iFXwm0zLNEyRyI3gwAV_UQ-1; Wed, 12 Feb 2020 10:11:19 -0500
X-MC-Unique: iFXwm0zLNEyRyI3gwAV_UQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32FF8107ACC5;
        Wed, 12 Feb 2020 15:11:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F3C65C1B2;
        Wed, 12 Feb 2020 15:11:17 +0000 (UTC)
Date:   Wed, 12 Feb 2020 10:11:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com
Subject: Re: [PATCH V3 1/2] xfs: Pass xattr name and value length explicitly
 to xfs_attr_leaf_newentsize
Message-ID: <20200212151115.GA17921@bfoster>
References: <20200129045939.10380-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129045939.10380-1-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 10:29:38AM +0530, Chandan Rajendra wrote:
> This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
> value length instead of a pointer to struct xfs_da_args. The next commit will
> need to invoke xfs_attr_leaf_newentsize() from functions that do not have
> a struct xfs_da_args to pass in.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      |  3 ++-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 41 ++++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
>  3 files changed, 32 insertions(+), 15 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 08d4b10ae2d53..7cd57e5844d80 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
...
> @@ -2687,20 +2700,22 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
>   */
>  int
>  xfs_attr_leaf_newentsize(
> -	struct xfs_da_args	*args,
> +	struct xfs_mount	*mp,

Any reason not to just pass the geo here rather than the mount?
Otherwise looks fine to me.

Brian

> +	int			namelen,
> +	int			valuelen,
>  	int			*local)
>  {
>  	int			size;
>  
> -	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
> -	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
> +	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
> +	if (size < xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize)) {
>  		if (local)
>  			*local = 1;
>  		return size;
>  	}
>  	if (local)
>  		*local = 0;
> -	return xfs_attr_leaf_entsize_remote(args->namelen);
> +	return xfs_attr_leaf_entsize_remote(namelen);
>  }
>  
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index f4a188e28b7b6..0ce1f9301157e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -106,7 +106,8 @@ void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
>  xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
>  int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
>  				   struct xfs_buf *leaf2_bp);
> -int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
> +int	xfs_attr_leaf_newentsize(struct xfs_mount *mp, int namelen,
> +			int valuelen, int *local);
>  int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  			xfs_dablk_t bno, struct xfs_buf **bpp);
>  void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
> -- 
> 2.19.1
> 

