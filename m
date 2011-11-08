Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8ItuDl143829 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 12:55:56 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AAEBC1543B8B
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 10:55:55 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id EXK14RLI3WUUzw80 for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 10:55:55 -0800 (PST)
Message-ID: <4EB97B3A.6000202@sandeen.net>
Date: Tue, 08 Nov 2011 12:55:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs_repair: Properly set lost+found inode as used
References: <1320777990-6556-1-git-send-email-cmaiolino@redhat.com>
	<1320777990-6556-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1320777990-6556-3-git-send-email-cmaiolino@redhat.com>
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

On 11/8/11 12:46 PM, Carlos Maiolino wrote:
> This patch makes mk_orphanage() to properly set the inode link count of
> the recently allocated inode in the AVL tree, avoiding the lost+found
> directory to be bypass the link count check in phase7 and possibly leaving
> lost+found directory with a wrong link count.

Looks pretty good to me.  I think maybe add_inode_reached shouldn't
be called until the transaction to do it is complete, though?
Otherwise that might fail and we'd still have marked it as reached;
I think that could be a problem.

Thanks,
-Eric

> ---
>  repair/phase6.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index adad61d..0e0e294 100644
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
> @@ -875,6 +877,18 @@ mk_orphanage(xfs_mount_t *mp)
>  			ORPHANAGE, error);
>  	}
>  	ip->i_d.di_nlink++;		/* account for . */
> +	ino = ip->i_ino;
> +
> +	irec = find_inode_rec(mp,
> +			XFS_INO_TO_AGNO(mp, ino),
> +			XFS_INO_TO_AGINO(mp,ino));
> +	ino_offset = get_inode_offset(mp, ino, irec);
> +
> +	/* Set the inode allocated to lost+found as used in the AVL
> + 	 * tree, so it is not bypassed in phase 7
> + 	 */
> +	set_inode_used(irec,ino_offset);
> +	add_inode_ref(irec,ino_offset);
>  
>  	/*
>  	 * now that we know the transaction will stay around,
> @@ -902,6 +916,8 @@ mk_orphanage(xfs_mount_t *mp)
>  				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino)), 0);
>  
>  
> +	add_inode_reached(irec,ino_offset);
> +
>  	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>  	libxfs_dir_init(tp, ip, pip);
>  	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> @@ -912,7 +928,6 @@ mk_orphanage(xfs_mount_t *mp)
>  			ORPHANAGE, error);
>  	}
>  
> -	ino = ip->i_ino;
>  
>  	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
>  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
