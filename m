Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75BEC433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 23:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A84D061184
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 23:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbhDEXer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 19:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241735AbhDEXer (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Apr 2021 19:34:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C64561026;
        Mon,  5 Apr 2021 23:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617665680;
        bh=35tyIzMeXnhI9nEUH3QIXtW+xoSDsOMZERX7vJsb9/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kiz5Oej0nUkjSWnZov+mMqTvRDCAtkCNe1WR+ePORbgD78rut4AXpPA21dW1d4jn5
         Jvd6SYl37CskDVRbhqL8zleWOydbjG1Bmk3kNd7i1zDQ9Mdhwwtk4Os7O2LS3e/F7C
         zxtEwIdAlQko6qaygB5ore4dDsI95gglfqx3SUifnXlMqJ2/st6wEt5MqR5Cq9l7sv
         CKkLU3u1D1yJAhuFU5f9aARjPsYbJXpIM6PDoKr0kJggrAo/3Y7Ob1qJh8V0AJdV7R
         yXEgkR2e5kbTZ4Hm+ukr8FNeE+BSjQ3hueMpz4+cQIisD1vB3PXDg12CwSWMErczX8
         YpleOuHp/dvzg==
Date:   Mon, 5 Apr 2021 16:34:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: scrub: Disable check for non-optimized data fork
 bmbt node
Message-ID: <20210405233439.GC3957620@magnolia>
References: <20210405074742.22816-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405074742.22816-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 01:17:42PM +0530, Chandan Babu R wrote:
> xchk_btree_check_minrecs() checks if the contents of the immediate child of a
> bmbt root block can fit within the root block. This check could fail on inodes
> with an attr fork since xfs_bmap_add_attrfork_btree() used to demote the
> current root node of the data fork as the child of a newly allocated root node
> if it found that the size of "struct xfs_btree_block" along with the space
> required for records exceeded that of space available in the data fork.
> 
> xfs_bmap_add_attrfork_btree() should have used "struct xfs_bmdr_block" instead
> of "struct xfs_btree_block" for the above mentioned space requirement
> calculation. This commit disables the check for non-optimized (in terms of
> disk space usage) data fork bmbt trees since there could be filesystems
> in use that already have such a layout.
> 
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/scrub/btree.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index debf392e0515..79e0aa484b4a 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -9,6 +9,7 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> @@ -469,14 +470,17 @@ xchk_btree_check_minrecs(
>  	 */
>  	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
>  	    level == cur->bc_nlevels - 2) {
> +		struct xfs_inode 	*ip = bs->sc->ip;
>  		struct xfs_btree_block	*root_block;
>  		struct xfs_buf		*root_bp;
>  		int			root_maxrecs;
> +		int			whichfork = cur->bc_ino.whichfork;
>  
>  		root_block = xfs_btree_get_block(cur, root_level, &root_bp);
>  		root_maxrecs = cur->bc_ops->get_dmaxrecs(cur, root_level);
>  		if (be16_to_cpu(root_block->bb_numrecs) != 1 ||
> -		    numrecs <= root_maxrecs)
> +		    (!(whichfork == XFS_DATA_FORK && XFS_IFORK_Q(ip)) &&

This isn't an issue now, but it will become one when inodes gain the
ability to host roots of btrees that are not just the block mapping
btrees.  (Specifically, realtime reflink and refcounting, which are
buried deep in djwong-dev...)  It might be a good idea to check the
btree cursor type so that we don't leave a logic bomb.

I think I'd like a code level comment capturing what happened and why we
occasionally skip checks.  Something like this?

/* Decide if we want to check minrecs of a btree block in the inode root. */
static inline bool
xchk_btree_check_iroot_minrecs(
	struct xchk_btree	*bs)
{
	/*
	 * xfs_bmap_add_attrfork_btree had an implementation bug wherein it
	 * would miscalculate the space required for the data fork bmbt root
	 * when adding an attr fork, and promote the iroot contents to an
	 * external block unnecessarily.  This went unnoticed for many years
	 * until scrub found filesystems in this state.  Inode rooted btrees
	 * are not supposed to have immediate child blocks that are small
	 * enough that the contents could fit in the inode root, but we can't
	 * fail existing filesystems, so instead we disable the check for data
	 * fork bmap btrees when there's an attr fork.
	 */
	if (bs->cur->bc_btnum == XFS_BTNUM_BMAP &&
	    bs->cur->bc_ino.whichfork == XFS_DATA_FORK &&
	    XFS_IFORK_Q(ip))
		return false;

	return false;
}

		if (xchk_btree_check_iroot_minrecs(bs) &&
		    (be16_to_cpu(root_block->bb_numrecs) != 1 ||
		     numrecs <= root_maxrecs))
			xchk_btree_set_corrupt(...);

Code-wise, this patch looks very similar to what I was drafting in my head. :)

--D


> +		     numrecs <= root_maxrecs))
>  			xchk_btree_set_corrupt(bs->sc, cur, level);
>  		return;
>  	}
> -- 
> 2.29.2
> 
