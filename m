Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35134 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbeHBWOx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Aug 2018 18:14:53 -0400
Subject: Re: [PATCH] xfs: avoid overflows in i_delayed_blks due to numerous
 cow reservations
References: <20180802180256.GR30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cf9203f1-c41e-b302-f5e1-641e50903cfa@sandeen.net>
Date: Thu, 2 Aug 2018 15:22:09 -0500
MIME-Version: 1.0
In-Reply-To: <20180802180256.GR30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 8/2/18 1:02 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prior to the arrival of copy on write, i_delayed_blks tracked the number
> of blocks that had been reserved for delayed allocations.  Though the
> counter was 32-bits in size, this was enough because writeback would
> generally start flushing files well before we hit 2^32 blocks of dirty
> data.
> 
> However, now that we're using it to track CoW reservations as well, it's
> possible to create so many of those reservations that we overflow the
> counter.  This is kind of an extreme case (it requires ~16T of COW
> reservations) but we ought to avoid this trivial overflow.  A userspace
> visible effect is that stat i_blocks returns incorrect values.
> 
> Change the field to xfs_filblks_t, which should suffice to fix the
> problem.  There already was a 4-byte hole in struct xfs_inode, so we get
> this for free.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I think delblks in xfs_qm_vop_chown_reserve() needs to be bumped up
too then, no?

(and, uh, does it then need to be chased through
xfs_trans_reserve_quota_bydquot, xfs_trans_dqresv etc?)

-Eric

> ---
>  fs/xfs/xfs_inode.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 59b06133ceb8..3fd0e07a363e 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -48,7 +48,7 @@ typedef struct xfs_inode {
>  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
> -	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
> +	xfs_filblks_t		i_delayed_blks;	/* count of delay alloc blks */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> --
