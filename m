Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 657F87F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 13:21:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48A428F8040
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 11:21:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w71qKQV6nIlemfhP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 11:21:13 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s67ILBg5019931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 7 Jul 2014 14:21:12 -0400
Date: Mon, 7 Jul 2014 14:21:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: allow inode allocations in post-growfs disk space
Message-ID: <20140707182108.GD4123@laptop.bfoster>
References: <53B4E1EE.40702@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53B4E1EE.40702@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 02, 2014 at 11:54:06PM -0500, Eric Sandeen wrote:
> Today, if we perform an xfs_growfs which adds allocation groups,
> mp->m_maxagi is not properly updated when the growfs is complete.
> 
> Therefore inodes will continue to be allocated only in the
> AGs which existed prior to the growfs, and the new space
> won't be utilized.
> 
> This is because of this path in xfs_growfs_data_private():
> 
> xfs_growfs_data_private
> 	xfs_initialize_perag(mp, nagcount, &nagimax);
> 	 	if (mp->m_flags & XFS_MOUNT_32BITINODES)
> 			index = xfs_set_inode32(mp);
>  		else
> 			index = xfs_set_inode64(mp);
> 
> 	 	if (maxagi)
>  			*maxagi = index;
> 
> where xfs_set_inode* iterates over the (old) agcount in
> mp->m_sb.sb_agblocks, which has not yet been updated
> in the growfs path.  So "index" will be returned based on
> the old agcount, not the new one, and new AGs are not available
> for inode allocation.
> 
> Fix this by explicitly passing the proper AG count (which 
> xfs_initialize_perag() already has) down another level,
> so that xfs_set_inode* can make the proper decision about
> acceptable AGs for inode allocation in the potentially
> newly-added AGs.
> 
> This has been broken since 3.7, when these two
> xfs_set_inode* functions were added in commit 2d2194f.
> Prior to that, we looped over "agcount" not sb_agblocks
> in these calculations.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> tested for regression with the -g growfs group, but this
> shows that we need another testcase for growfs.
> 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 993cb19..b291ada 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -250,9 +250,9 @@ xfs_initialize_perag(
>  		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
>  
>  	if (mp->m_flags & XFS_MOUNT_32BITINODES)
> -		index = xfs_set_inode32(mp);
> +		index = xfs_set_inode32(mp, agcount);
>  	else
> -		index = xfs_set_inode64(mp);
> +		index = xfs_set_inode64(mp, agcount);
>  
>  	if (maxagi)
>  		*maxagi = index;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 87e8b01..ccc564d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -597,8 +597,13 @@ xfs_max_file_offset(
>  	return (((__uint64_t)pagefactor) << bitshift) - 1;
>  }
>  
> +/*
> + * xfs_set_inode32() and xfs_set_inode64() are passed an agcount
> + * because in the growfs case, mp->m_sb.sb_agcount is not updated
> + * yet to the potentially higher ag count.
> + */
>  xfs_agnumber_t
> -xfs_set_inode32(struct xfs_mount *mp)
> +xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
>  {
>  	xfs_agnumber_t	index = 0;
>  	xfs_agnumber_t	maxagi = 0;
> @@ -620,10 +625,10 @@ xfs_set_inode32(struct xfs_mount *mp)
>  		do_div(icount, sbp->sb_agblocks);
>  		max_metadata = icount;
>  	} else {
> -		max_metadata = sbp->sb_agcount;
> +		max_metadata = agcount;

The fix looks pretty good to me, but what about the 'if' branch of this
logic here? We calculate max_metadata based on sb_dblocks, which also
isn't updated until the growfs tp commit. That appears to be a similar
bug in that we wouldn't set pagf_metadata on the new AGs where
appropriate, which I think means data allocation could steal the new
inode space sooner than anticipated.

I wonder if this is better moved after the superblock is updated?

Brian

>  	}
>  
> -	for (index = 0; index < sbp->sb_agcount; index++) {
> +	for (index = 0; index < agcount; index++) {
>  		ino = XFS_AGINO_TO_INO(mp, index, agino);
>  
>  		if (ino > XFS_MAXINUMBER_32) {
> @@ -648,11 +653,11 @@ xfs_set_inode32(struct xfs_mount *mp)
>  }
>  
>  xfs_agnumber_t
> -xfs_set_inode64(struct xfs_mount *mp)
> +xfs_set_inode64(struct xfs_mount *mp, xfs_agnumber_t agcount)
>  {
>  	xfs_agnumber_t index = 0;
>  
> -	for (index = 0; index < mp->m_sb.sb_agcount; index++) {
> +	for (index = 0; index < agcount; index++) {
>  		struct xfs_perag	*pag;
>  
>  		pag = xfs_perag_get(mp, index);
> @@ -1193,6 +1198,7 @@ xfs_fs_remount(
>  	char			*options)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	xfs_sb_t		*sbp = &mp->m_sb;
>  	substring_t		args[MAX_OPT_ARGS];
>  	char			*p;
>  	int			error;
> @@ -1212,10 +1218,10 @@ xfs_fs_remount(
>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
>  			break;
>  		case Opt_inode64:
> -			mp->m_maxagi = xfs_set_inode64(mp);
> +			mp->m_maxagi = xfs_set_inode64(mp, sbp->sb_agcount);
>  			break;
>  		case Opt_inode32:
> -			mp->m_maxagi = xfs_set_inode32(mp);
> +			mp->m_maxagi = xfs_set_inode32(mp, sbp->sb_agcount);
>  			break;
>  		default:
>  			/*
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index bbe3d15..b4cfe21 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -76,8 +76,8 @@ extern __uint64_t xfs_max_file_offset(unsigned int);
>  
>  extern void xfs_flush_inodes(struct xfs_mount *mp);
>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
> -extern xfs_agnumber_t xfs_set_inode32(struct xfs_mount *);
> -extern xfs_agnumber_t xfs_set_inode64(struct xfs_mount *);
> +extern xfs_agnumber_t xfs_set_inode32(struct xfs_mount *, xfs_agnumber_t agcount);
> +extern xfs_agnumber_t xfs_set_inode64(struct xfs_mount *, xfs_agnumber_t agcount);
>  
>  extern const struct export_operations xfs_export_operations;
>  extern const struct xattr_handler *xfs_xattr_handlers[];
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
