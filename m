Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58232 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbfDIUqX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Apr 2019 16:46:23 -0400
Subject: Re: [PATCH 24/36] xfs_repair: bump the irec on-disk nlink when adding
 lost+found
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259757750.31886.15831311797503004248.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3c0b7240-f2bf-63e3-2133-e169340c9293@sandeen.net>
Date: Tue, 9 Apr 2019 15:46:22 -0500
MIME-Version: 1.0
In-Reply-To: <155259757750.31886.15831311797503004248.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We increment the nlink of the root directory inode when creating a
> "lost+found" directory during phase 6, but we don't update the irec copy
> of the root dir nlink.  This normally gets papered over by phase 7, but
> this can fail badly if:
> 
> 1) The root directory had an entry to a busted subdirectory, so
>    that root directory will have nlink == 3, but in the ino_tree,
>    counted_nlinks == 2 and disk_nlinks == 3.
> 
> 2) Phase 6 creates lost+found to root the files that were in the busted
>    directory, we'll set nlink = 4 and counted_nlinks = 3.  The correct
>    nlink is 3 ('.', '..', 'lost+found'), not 4.
> 
> 3) During phase 7, we see that counted_nlinks == disk_nlinks and so we
>    totally fail to correct the on-disk inode.
> 
> 4) A subsequent run of xfs_repair complains about the nlink being 4
>    instead of 3.
> 
> To fix this, we have to adjust the irec's disk_nlinks in step 2 so that
> phase 7 seeds that counted_nlinks < disk_nlinks and resets nlink to
> counted_nlinks.  This can be reproduced somewhat frequently by xfs/117.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/phase6.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 8a50b350..194cfdbf 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1019,6 +1019,7 @@ mk_orphanage(xfs_mount_t *mp)
>  	 */
>  	set_inode_used(irec, ino_offset);
>  	add_inode_ref(irec, ino_offset);
> +	add_inode_reached(irec, ino_offset);
>  
>  	/*
>  	 * now that we know the transaction will stay around,
> @@ -1037,14 +1038,14 @@ mk_orphanage(xfs_mount_t *mp)
>  
>  	/*
>  	 * bump up the link count in the root directory to account
> -	 * for .. in the new directory
> +	 * for .. in the new directory, and update the irec copy of the
> +	 * on-disk nlink so we don't fail the link count check later.
>  	 */
>  	inc_nlink(VFS_I(pip));
> -	add_inode_ref(find_inode_rec(mp,
> -				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
> -				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino)), 0);
> -
> -
> +	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
> +				  XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
> +	add_inode_ref(irec, 0);
> +	set_inode_disk_nlinks(irec, 0, get_inode_disk_nlinks(irec, 0) + 1);
>  
>  	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>  	libxfs_dir_init(tp, ip, pip);
> @@ -1056,7 +1057,6 @@ mk_orphanage(xfs_mount_t *mp)
>  	}
>  	libxfs_irele(ip);
>  	libxfs_irele(pip);
> -	add_inode_reached(irec,ino_offset);
>  
>  	return(ino);
>  }
> 
