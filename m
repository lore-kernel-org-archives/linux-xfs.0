Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEI93gL224314 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 12:09:03 -0600
Date: Mon, 14 Nov 2011 12:09:18 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2] xfs_repair: Properly set lost+found inode as used
Message-ID: <20111114180918.GC29840@sgi.com>
References: <1320857647-25511-1-git-send-email-cmaiolino@redhat.com>
	<1320857647-25511-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320857647-25511-3-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

Hey Carlos,

On Wed, Nov 09, 2011 at 02:54:07PM -0200, Carlos Maiolino wrote:
> This patch makes mk_orphanage() to properly set the inode link count of
> the recently allocated inode in the AVL tree, avoiding the lost+found
> directory to be bypass the link count check in phase7 and possibly leaving
> lost+found directory with a wrong link count.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  repair/phase6.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index adad61d..d38e44f 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -823,6 +823,8 @@ mk_orphanage(xfs_mount_t *mp)
>  	xfs_inode_t	*ip;
>  	xfs_inode_t	*pip;
>  	xfs_fsblock_t	first;
> +	ino_tree_node_t	*irec;
> +	int		ino_offset = 0;
>  	int		i;
>  	int		committed;
>  	int		error;
> @@ -875,6 +877,19 @@ mk_orphanage(xfs_mount_t *mp)
>  			ORPHANAGE, error);
>  	}
>  	ip->i_d.di_nlink++;		/* account for . */
> +	ino = ip->i_ino;
> +
> +	irec = find_inode_rec(mp,
> +			XFS_INO_TO_AGNO(mp, ino),
> +			XFS_INO_TO_AGINO(mp, ino));
> +	ino_offset = get_inode_offset(mp, ino, irec);
> +
> +	/*
> +	 * Mark the inode allocated to lost+found as used in the AVL tree
> + 	 * so it is not skipped in phase 7
> + 	 */
> +	set_inode_used(irec, ino_offset);
> +	add_inode_ref(irec, ino_offset);

Both add_inode_ref()...

>  	/*
>  	 * now that we know the transaction will stay around,
> @@ -902,6 +917,7 @@ mk_orphanage(xfs_mount_t *mp)
>  				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino)), 0);
>  
>  
> +
>  	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>  	libxfs_dir_init(tp, ip, pip);
>  	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> @@ -912,9 +928,9 @@ mk_orphanage(xfs_mount_t *mp)
>  			ORPHANAGE, error);
>  	}
>  
> -	ino = ip->i_ino;
>  
>  	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
> +	add_inode_reached(irec,ino_offset);

and add_inode_reached() call counted_nlink_inc.

I have to admit to being an xfs_repair newbie, so you can tell me to
take a hike if you want.  Did you intend to bump up nlink twice?

THat's not what I would have expected.

THanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
