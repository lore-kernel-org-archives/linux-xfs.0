Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28601 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbeCZMNq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 08:13:46 -0400
Date: Mon, 26 Mar 2018 08:13:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: do not log swapext extent owner changes for
 deleted inodes
Message-ID: <20180326121339.GB34912@bfoster.bfoster>
References: <f2dcef25-01f2-d7fe-3b2d-f54a809215a5@redhat.com>
 <b7a4250a-b348-0381-683b-74059c397a7d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7a4250a-b348-0381-683b-74059c397a7d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 23, 2018 at 07:13:43PM -0500, Eric Sandeen wrote:
> Today if we run fsr and crash, log replay can fail because
> the recovery code tries to instantiate the donor inode from
> disk to replay the swapext, but it's been deleted and we get
> verifier failures when we try to read it off disk with
> i_mode == 0.
> 
> Strip the extent owner changes out of the logged fields when
> we're freeing the inode to avoid this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Move the fix to xfs_ifree per bfoster's suggestion
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 604ee38..d17e2d5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2470,6 +2470,10 @@
>  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
> +
> +	/* Don't attempt to replay owner changes for a deleted inode */
> +	ip->i_itemp->ili_fields &= !(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);

				   ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER)

Brian

> +
>  	/*
>  	 * Bump the generation count so no one will be confused
>  	 * by reincarnations of this inode.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
