Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37BEC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FB8F2084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:11:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8f+34vG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgBYQLP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:11:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726019AbgBYQLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 11:11:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582647072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1SKfztX5NVEywpxKnyh/Mlx7KZZMB3AcU714IjAG344=;
        b=Y8f+34vG38YstT9GxdOtyI6vC/BjN4KotFxolui+/wbtPVdw3qKdGnjp8s37VPasBhVoC8
        SfUYplG4gbJP+iPAH9DeFEL/iWdfqX0ud7y3pgxRWftFZb3anAYRq4wOHOiXw5iIGNdPQa
        V7AhWbNsWUProcu+Xo4RychazAqVnLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-3k1M6J5EOaqQiZor5RBjYA-1; Tue, 25 Feb 2020 11:11:08 -0500
X-MC-Unique: 3k1M6J5EOaqQiZor5RBjYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 015768024D7;
        Tue, 25 Feb 2020 16:11:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 104795D9CD;
        Tue, 25 Feb 2020 16:11:05 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:11:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 1/7] xfs: Pass xattr name and value length
 explicitly to xfs_attr_leaf_newentsize
Message-ID: <20200225161104.GA54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-2-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:38AM +0530, Chandan Rajendra wrote:
> This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
> value length instead of a pointer to struct xfs_da_args. A future commit will
> need to invoke xfs_attr_leaf_newentsize() from functions that do not have
> a struct xfs_da_args to pass in.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c      |  3 ++-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 39 +++++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
>  3 files changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 23e0d8ce39f8c..1875210cc8e40 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -149,7 +149,8 @@ xfs_attr_calc_size(
>  	 * Determine space new attribute will use, and if it would be
>  	 * "local" or "remote" (note: local != inline).
>  	 */
> -	size = xfs_attr_leaf_newentsize(args, local);
> +	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +			args->valuelen, local);
>  	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
>  	if (*local) {
>  		if (size > (args->geo->blksize / 2)) {
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fae322105457a..65a3bf40c4f9d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1330,7 +1330,8 @@ xfs_attr3_leaf_add(
>  	leaf = bp->b_addr;
>  	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
>  	ASSERT(args->index >= 0 && args->index <= ichdr.count);
> -	entsize = xfs_attr_leaf_newentsize(args, NULL);
> +	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +			args->valuelen, NULL);
>  
>  	/*
>  	 * Search through freemap for first-fit on new name length.
> @@ -1403,6 +1404,7 @@ xfs_attr3_leaf_add_work(
>  	struct xfs_attr_leaf_name_local *name_loc;
>  	struct xfs_attr_leaf_name_remote *name_rmt;
>  	struct xfs_mount	*mp;
> +	int			entsize;
>  	int			tmp;
>  	int			i;
>  
> @@ -1432,11 +1434,14 @@ xfs_attr3_leaf_add_work(
>  	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
>  	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
>  	ASSERT(ichdr->freemap[mapindex].size >=
> -		xfs_attr_leaf_newentsize(args, NULL));
> +		xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +				args->valuelen, NULL));
>  	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
>  	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
>  
> -	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
> +	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +			args->valuelen, &tmp);
> +	ichdr->freemap[mapindex].size -= entsize;
>  
>  	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
>  				     ichdr->freemap[mapindex].size);
> @@ -1824,6 +1829,8 @@ xfs_attr3_leaf_figure_balance(
>  	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
>  	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
>  	struct xfs_attr_leaf_entry	*entry;
> +	struct xfs_da_args		*args;
> +	int				entsize;
>  	int				count;
>  	int				max;
>  	int				index;
> @@ -1833,14 +1840,16 @@ xfs_attr3_leaf_figure_balance(
>  	int				foundit = 0;
>  	int				tmp;
>  
> +	args = state->args;
>  	/*
>  	 * Examine entries until we reduce the absolute difference in
>  	 * byte usage between the two blocks to a minimum.
>  	 */
>  	max = ichdr1->count + ichdr2->count;
>  	half = (max + 1) * sizeof(*entry);
> -	half += ichdr1->usedbytes + ichdr2->usedbytes +
> -			xfs_attr_leaf_newentsize(state->args, NULL);
> +	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +			args->valuelen, NULL);
> +	half += ichdr1->usedbytes + ichdr2->usedbytes + entsize;
>  	half /= 2;
>  	lastdelta = state->args->geo->blksize;
>  	entry = xfs_attr3_leaf_entryp(leaf1);
> @@ -1851,8 +1860,9 @@ xfs_attr3_leaf_figure_balance(
>  		 * The new entry is in the first block, account for it.
>  		 */
>  		if (count == blk1->index) {
> -			tmp = totallen + sizeof(*entry) +
> -				xfs_attr_leaf_newentsize(state->args, NULL);
> +			entsize = xfs_attr_leaf_newentsize(args->geo,
> +					args->namelen, args->valuelen, NULL);
> +			tmp = totallen + sizeof(*entry) + entsize;
>  			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
>  				break;
>  			lastdelta = XFS_ATTR_ABS(half - tmp);
> @@ -1887,8 +1897,9 @@ xfs_attr3_leaf_figure_balance(
>  	 */
>  	totallen -= count * sizeof(*entry);
>  	if (foundit) {
> -		totallen -= sizeof(*entry) +
> -				xfs_attr_leaf_newentsize(state->args, NULL);
> +		entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +				args->valuelen, NULL);
> +		totallen -= sizeof(*entry) + entsize;
>  	}
>  
>  	*countarg = count;
> @@ -2664,20 +2675,22 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
>   */
>  int
>  xfs_attr_leaf_newentsize(
> -	struct xfs_da_args	*args,
> +	struct xfs_da_geometry	*geo,
> +	int			namelen,
> +	int			valuelen,
>  	int			*local)
>  {
>  	int			size;
>  
> -	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
> -	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
> +	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
> +	if (size < xfs_attr_leaf_entsize_local_max(geo->blksize)) {
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
> index 6dd2d937a42a3..7bc5dd6c4d66a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -96,7 +96,8 @@ void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
>  xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
>  int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
>  				   struct xfs_buf *leaf2_bp);
> -int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
> +int	xfs_attr_leaf_newentsize(struct xfs_da_geometry	*geo, int namelen,
> +			int valuelen, int *local);
>  int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  			xfs_dablk_t bno, struct xfs_buf **bpp);
>  void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
> -- 
> 2.19.1
> 

