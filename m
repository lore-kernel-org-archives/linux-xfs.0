Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE61C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 22:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FE522DFA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 22:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbhAEWNb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 17:13:31 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50776 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730127AbhAEWNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 17:13:31 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 7764D7661A9;
        Wed,  6 Jan 2021 09:12:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kwuZL-003Qtw-Bd; Wed, 06 Jan 2021 09:12:47 +1100
Date:   Wed, 6 Jan 2021 09:12:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210105221247.GD331610@dread.disaster.area>
References: <20210104194437.GJ38809@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104194437.GJ38809@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=JaIyNT8g9P0kwNZ07y0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 11:44:37AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When overlayfs is running on top of xfs and the user unlinks a file in
> the overlay, overlayfs will create a whiteout inode and ask xfs to
> "rename" the whiteout file atop the one being unlinked.  If the file
> being unlinked loses its one nlink, we then have to put the inode on the
> unlinked list.
> 
> This requires us to grab the AGI buffer of the whiteout inode to take it
> off the unlinked list (which is where whiteouts are created) and to grab
> the AGI buffer of the file being deleted.  If the whiteout was created
> in a higher numbered AG than the file being deleted, we'll lock the AGIs
> in the wrong order and deadlock.
> 
> Therefore, grab all the AGI locks we think we'll need ahead of time, and
> in the correct order.
> 
> Reported-by: wenli xie <wlxie7296@gmail.com>
> Tested-by: wenli xie <wlxie7296@gmail.com>
> Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)

Hmmm.

> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b7352bc4c815..dd419a1bc6ba 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
>  	return 0;
>  }
>  
> +/*
> + * For the general case of renaming files, lock all the AGI buffers we need to
> + * handle bumping the nlink of the whiteout inode off the unlinked list and to
> + * handle dropping the nlink of the target inode.  We have to do this in
> + * increasing AG order to avoid deadlocks.
> + */
> +static int
> +xfs_rename_lock_agis(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*wip,
> +	struct xfs_inode	*target_ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*bp;
> +	xfs_agnumber_t		agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
> +	int			error;
> +
> +	if (wip)
> +		agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
> +
> +	if (target_ip && VFS_I(target_ip)->i_nlink == 1)
> +		agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
> +
> +	if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
> +	    agi_locks[0] > agi_locks[1])
> +		swap(agi_locks[0], agi_locks[1]);
> +
> +	if (agi_locks[0] != NULLAGNUMBER) {
> +		error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (agi_locks[1] != NULLAGNUMBER) {
> +		error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * xfs_rename
>   */
> @@ -3130,6 +3172,10 @@ xfs_rename(
>  		}
>  	}
>  
> +	error = xfs_rename_lock_agis(tp, wip, target_ip);
> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Directory entry creation below may acquire the AGF. Remove
>  	 * the whiteout from the unlinked list first to preserve correct
> 

So the comment below this new hunk is all about AGI vs AGF ordering
and how we do the unlink first to grab the AGI before the AGF. But
noew we are adding explicit AGI locking for the case where unlink
list locking is required, thereby largely invalidating the need
for special casing the unlink list removal right up front.

Next question: The target_ip == NULL case below this (the
xfs_dir_repace() case) does this:

	/*
	 * Check whether the replace operation will need to allocate
	 * blocks.  This happens when the shortform directory lacks
	 * space and we have to convert it to a block format directory.
	 * When more blocks are necessary, we must lock the AGI first
	 * to preserve locking order (AGI -> AGF).
	 */
	if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
		error = xfs_read_agi(mp, tp,
				XFS_INO_TO_AGNO(mp, target_ip->i_ino),
				&agibp);
		if (error)
			goto out_trans_cancel;
	}

IOWs, if we are actually locking AGIs up front, this can go away,
yes?

Seems to me that we should actually do a proper job of formalising
the locking in the rename code, not hack another special case into
it and keep all the other special case hacks that could go away if
the whole AGI/AGF locking order thing were done up front....

And with it formalised, we can then think about how to get rid of
those lock order dependecies altogether....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
