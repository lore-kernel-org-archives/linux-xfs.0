Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbeC2NTY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 09:19:24 -0400
Date: Thu, 29 Mar 2018 09:19:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V3] xfs: do not log/recover swapext extent owner changes
 for deleted inodes
Message-ID: <20180329131917.GA3473@bfoster.bfoster>
References: <f2dcef25-01f2-d7fe-3b2d-f54a809215a5@redhat.com>
 <0b3a812e-9bab-aa93-f16b-081a91eddbef@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b3a812e-9bab-aa93-f16b-081a91eddbef@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 28, 2018 at 05:12:44PM -0500, Eric Sandeen wrote:
> Today if we run xfs_fsr and crash[1], log replay can fail because
> the recovery code tries to instantiate the donor inode from
> disk to replay the swapext, but it's been deleted and we get
> verifier failures when we try to read the inode off disk with
> i_mode == 0.
> 
> This fixes both sides: We don't log the swapext change if the
> inode has been deleted, and we don't try to recover it either.
> 
> [1] or if systemd doesn't uncleanly unmount root, as is its wont
>     to do ...

Eh? :P

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks fine. With the commit log fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: Move the fix to xfs_ifree per bfoster's suggestion
> V3: Fix my eeeediot logic thinko, and add back in replay fix
>     so that people already in this situation can recover.
>     Tidy up commit log a bit.
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
> +	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
> +
>  	/*
>  	 * Bump the generation count so no one will be confused
>  	 * by reincarnations of this inode.
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5e219d9..d0e33b9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3199,7 +3199,9 @@ xlog_recover_inode_pass2(
>  	}
>  
>  out_owner_change:
> -	if (in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER))
> +	/* Recover the swapext owner change unless inode has been deleted */
> +	if ((in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER)) &&
> +	    (dip->di_mode != 0))
>  		error = xfs_recover_inode_owner_change(mp, dip, in_f,
>  						       buffer_list);
>  	/* re-generate the checksum. */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
