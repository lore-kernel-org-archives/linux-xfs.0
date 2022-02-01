Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16848C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 20:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiBAUB2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:01:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55690 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbiBAUB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 15:01:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C1D56167C
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 20:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8DAC340EB;
        Tue,  1 Feb 2022 20:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643745686;
        bh=4NCbuAyBPX7nBFGBinEycc0FQq0rT91sLuyJKSW7rO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PEHAN0F33ucbox9iAX0dj0XFbzxWp8k81MdtFqNXtbuSUS9xmWmcJPJtXdm2y6phx
         yCxq4ZxxZrnXvy0Y20oaYgykJM3cE/8Y9lF8CptG5SH6CKKzmpv2ZKA6+Eb0BgZt1H
         KplEJQInNHXatpp2EV5salqB2tSjPNixe1ex7/z+LEqHrGadVbOi2EaVKXXN3gm7P/
         8DxiGgHlFVIDbLFlZF7XwiSQzlGnmJW7m9S6t+wE1vpyk5tma1XETkL247r46YX67x
         zBt4u4XWZbZNwRPn2E1Q2qKbL90VDlqo8YzIKsGqqtTpUvZ2iyLCb1hXbm0rqKiO4F
         1pZxgUYSPvimg==
Date:   Tue, 1 Feb 2022 12:01:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220201200125.GN8313@magnolia>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121051857.221105-14-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
> This commit upgrades inodes to use 64-bit extent counters when they are read
> from disk. Inodes are upgraded only when the filesystem instance has
> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 2200526bcee0..767189c7c887 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -253,6 +253,12 @@ xfs_inode_from_disk(
>  	}
>  	if (xfs_is_reflink_inode(ip))
>  		xfs_ifork_init_cow(ip);
> +
> +	if ((from->di_version == 3) &&
> +	     xfs_has_nrext64(ip->i_mount) &&
> +	     !xfs_dinode_has_nrext64(from))
> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;

Hmm.  Last time around I asked about the oddness of updating the inode
feature flags outside of a transaction, and then never responded. :(
So to quote you from last time:

> The following is the thought process behind upgrading an inode to
> XFS_DIFLAG2_NREXT64 when it is read from the disk,
>
> 1. With support for dynamic upgrade, The extent count limits of an
> inode needs to be determined by checking flags present within the
> inode i.e.  we need to satisfy self-describing metadata property. This
> helps tools like xfs_repair and scrub to verify inode's extent count
> limits without having to refer to other metadata objects (e.g.
> superblock feature flags).

I think this makes an even /stronger/ argument for why this update
needs to be transactional.

> 2. Upgrade when performed inside xfs_trans_log_inode() may cause
> xfs_iext_count_may_overflow() to return -EFBIG when the inode's
> data/attr extent count is already close to 2^31/2^15 respectively.
> Hence none of the file operations will be able to add new extents to a
> file.

Aha, there's the reason why!  You're right, xfs_iext_count_may_overflow
will abort the operation due to !NREXT64 before we even get a chance to
log the inode.

I observe, however, that any time we call that function, we also have a
transaction allocated and we hold the ILOCK on the inode being tested.
*Most* of those call sites have also joined the inode to the transaction
already.  I wonder, is that a more appropriate place to be upgrading the
inodes?  Something like:

/*
 * Ensure that the inode has the ability to add the specified number of
 * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
 * the transaction.  Upon return, the inode will still be in this state
 * upon return and the transaction will be clean.
 */
int
xfs_trans_inode_ensure_nextents(
	struct xfs_trans	**tpp,
	struct xfs_inode	*ip,
	int			whichfork,
	int			nr_to_add)
{
	int			error;

	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
	if (!error)
		return 0;

	/*
	 * Try to upgrade if the extent count fields aren't large
	 * enough.
	 */
	if (!xfs_has_nrext64(ip->i_mount) ||
	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
		return error;

	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);

	error = xfs_trans_roll(tpp);
	if (error)
		return error;

	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
}

and then the current call sites become:

	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
			dblocks, rblocks, false, &tp);
	if (error)
		return error;

	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
			XFS_IEXT_ADD_NOSPLIT_CNT);
	if (error)
		goto out_cancel;

What do you think about that?

--D

> +
>  	return 0;
>  
>  out_destroy_data_fork:
> -- 
> 2.30.2
> 
