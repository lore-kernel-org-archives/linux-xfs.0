Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2392C49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB9342086A
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfITNvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfITNvA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Sep 2019 09:51:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5E0123099F9F;
        Fri, 20 Sep 2019 13:51:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0557D1001281;
        Fri, 20 Sep 2019 13:50:59 +0000 (UTC)
Date:   Fri, 20 Sep 2019 09:50:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 10/19] xfs: Add xfs_attr3_leaf helper functions
Message-ID: <20190920135058.GH40150@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-11-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 20 Sep 2019 13:51:00 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:28PM -0700, Allison Collins wrote:
> And new helper functions xfs_attr3_leaf_flag_is_set and
> xfs_attr3_leaf_flagsflipped.  These routines check to see
> if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
> already been run.  We will need this later for delayed
> attributes since routines may be recalled several times
> when -EAGAIN is returned.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 84 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.h |  2 ++
>  2 files changed, 86 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index bcd86c3..79650c9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2757,6 +2757,36 @@ xfs_attr3_leaf_clearflag(
>  }
>  
>  /*
> + * Check if the INCOMPLETE flag on an entry in a leaf block is set.
> + */
> +int
> +xfs_attr3_leaf_flag_is_set(
> +	struct xfs_da_args		*args,
> +	bool				*isset)
> +{
> +	struct xfs_attr_leafblock	*leaf;
> +	struct xfs_attr_leaf_entry	*entry;
> +	struct xfs_buf			*bp;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +
> +	trace_xfs_attr_leaf_setflag(args);
> +

Tracepoint seems misplaced.. This is just a flag checking helper, right?

> +	/*
> +	 * Set up the operation.
> +	 */

Not sure what the comment means. The code seems self-explanatory here
anyways, so you could probably just drop it.

> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp);

Didn't you create a #define for this -1 earlier in the series?

> +	if (error)
> +		return error;
> +
> +	leaf = bp->b_addr;
> +	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
> +
> +	*isset = ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
> +	return 0;

What about bp? Should we release it before returning? If not, the
comment above the function should elaborate.

> +}
> +
> +/*
>   * Set the INCOMPLETE flag on an entry in a leaf block.
>   */
>  int
> @@ -2918,3 +2948,57 @@ xfs_attr3_leaf_flipflags(
>  
>  	return error;
>  }
> +
> +/*
> + * On a leaf entry, check to see if the INCOMPLETE flag is cleared
> + * in args->blkno/index and set in args->blkno2/index2.
> + * Note that they could be in different blocks, or in the same block.
> + *

A sentence or two on what this check is for would be helpful. Relocation
of an xattr or something..?

> + * isflipped is set to true if flags are flipped or false otherwise
> + */
> +int
> +xfs_attr3_leaf_flagsflipped(
> +	struct xfs_da_args		*args,
> +	bool				*isflipped)
> +{
> +	struct xfs_attr_leafblock	*leaf1;
> +	struct xfs_attr_leafblock	*leaf2;
> +	struct xfs_attr_leaf_entry	*entry1;
> +	struct xfs_attr_leaf_entry	*entry2;
> +	struct xfs_buf			*bp1;
> +	struct xfs_buf			*bp2;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +
> +	trace_xfs_attr_leaf_flipflags(args);
> +
> +	/*
> +	 * Read the block containing the "old" attr
> +	 */
> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp1);
> +	if (error)
> +		return error;
> +

Similar comments about the tracepoint, -1 usage and buffers.

Brian

> +	/*
> +	 * Read the block containing the "new" attr, if it is different
> +	 */
> +	if (args->blkno2 != args->blkno) {
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
> +					   -1, &bp2);
> +		if (error)
> +			return error;
> +	} else {
> +		bp2 = bp1;
> +	}
> +
> +	leaf1 = bp1->b_addr;
> +	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
> +
> +	leaf2 = bp2->b_addr;
> +	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
> +
> +	*isflipped = (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
> +		      (entry2->flags & XFS_ATTR_INCOMPLETE));
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 58e9327..d82229b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -57,7 +57,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
>  				   struct xfs_da_args *args, int forkoff);
>  int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
>  int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args, bool *isset);
>  int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args, bool *isflipped);
>  
>  /*
>   * Routines used for growing the Btree.
> -- 
> 2.7.4
> 
