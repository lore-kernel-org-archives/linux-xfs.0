Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217D3C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 15:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E356261152
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 15:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhDBPj3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 11:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236045AbhDBPj2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Apr 2021 11:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A083B610CC;
        Fri,  2 Apr 2021 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617377967;
        bh=xkV7D/eK0oBr3iXGGtcvRYxOAm2Ko5z9cPBCibqq49o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FdMo5cFqj/cTLHhQln9yDzJBC/OGM6pltE3hSZbspJNN9e++jEWx0Z+53jzL1tUeg
         dpAjVzE2X6yQoNvipWb0/b3z6qb2bt3dDtoNgeIuo6K9a9ituDduhwmQ3W7I4REYgL
         mIWdsecD11mdfer4CnNQevWUEZPYjUp5yc9wQbbrRJSIgZyonPCk9UiwFDp4k06Ly1
         xq8+aGL4942dnTJblVR4YIl1qYJbCAhh/QSac/fSnSFCed5jS9Cb7ZsS+F0mYh6zYv
         91wkkdS/tOssyrefJg3d7KxORHJRwe8P1V6hAVwGEebuYXq4zhNo8gjKSOPUlad+zh
         hN5kjysfMaBQA==
Date:   Fri, 2 Apr 2021 08:39:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V1.1] xfs: Use struct xfs_bmdr_block instead of struct
 xfs_btree_block to calculate root node size
Message-ID: <20210402153925.GH4090233@magnolia>
References: <20210401164525.8638-1-chandanrlinux@gmail.com>
 <20210402115100.13478-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402115100.13478-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 05:21:00PM +0530, Chandan Babu R wrote:
> The incore data fork of an inode stores the bmap btree root node as 'struct
> xfs_btree_block'. However, the ondisk version of the inode stores the bmap
> btree root node as a 'struct xfs_bmdr_block'.
> 
> xfs_bmap_add_attrfork_btree() checks if the btree root node fits inside the
> data fork of the inode. However, it incorrectly uses 'struct xfs_btree_block'
> to compute the size of the bmap btree root node. Since size of 'struct
> xfs_btree_block' is larger than that of 'struct xfs_bmdr_block',
> xfs_bmap_add_attrfork_btree() could end up unnecessarily demoting the current
> root node as the child of newly allocated root node.
> 
> This commit optimizes space usage by modifying xfs_bmap_add_attrfork_btree()
> to use 'struct xfs_bmdr_block' to check if the bmap btree root node fits
> inside the data fork of the inode.

Hmm.  This introduces a (compatible) change in the ondisk format, since
we no longer promote the data fork btree root block unnecessarily, right?

We've been writing out filesystems in that state for years, so I think
scrub is going to need patching to disable the "could the root block
contents fit in the inode root?" check on the data fork if there's an
attr fork.

Meanwhile, this fix looks decent.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

By the way, have you tried running xfs/{529-538} on a realtime
filesystem formatted with -d rtinherit=1 ?  There's something odd
causing them to fail, but it's realtime so who knows what that's
about. :)

I really like how these extent counter overflow checks are finding
longstanding bugs!

--D

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
> V1 -> V1.1
>   1. Initialize "block" variable during declaration.
>   
>  fs/xfs/libxfs/xfs_bmap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 585f7e795023..006dd2150a6f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -927,13 +927,15 @@ xfs_bmap_add_attrfork_btree(
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	int			*flags)		/* inode logging flags */
>  {
> +	struct xfs_btree_block	*block = ip->i_df.if_broot;
>  	xfs_btree_cur_t		*cur;		/* btree cursor */
>  	int			error;		/* error return value */
>  	xfs_mount_t		*mp;		/* file system mount struct */
>  	int			stat;		/* newroot status */
>  
>  	mp = ip->i_mount;
> -	if (ip->i_df.if_broot_bytes <= XFS_IFORK_DSIZE(ip))
> +
> +	if (XFS_BMAP_BMDR_SPACE(block) <= XFS_IFORK_DSIZE(ip))
>  		*flags |= XFS_ILOG_DBROOT;
>  	else {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
> -- 
> 2.29.2
> 
