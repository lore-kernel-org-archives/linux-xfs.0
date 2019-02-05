Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfBEOX5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Feb 2019 09:23:57 -0500
Date: Tue, 5 Feb 2019 09:23:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/10] xfs: refactor inode update in iunlink_remove
Message-ID: <20190205142354.GB51421@bfoster>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930319253.31814.2352584428677696706.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930319253.31814.2352584428677696706.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:59:52AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_iunlink_remove we have two identical calls to
> xfs_iunlink_update_inode, so move it out of the if statement to simplify
> the code some more.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c |   34 +++++++++++++---------------------
>  1 file changed, 13 insertions(+), 21 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8af5f4e989ac..fac9562ecd39 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2183,6 +2183,7 @@ xfs_iunlink_remove(
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
> +	xfs_agino_t		head_agino;
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> @@ -2198,24 +2199,24 @@ xfs_iunlink_remove(
>  	 * Get the index into the agi hash table for the list this inode will
>  	 * go on.  Make sure the head pointer isn't garbage.
>  	 */
> -	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> -	if (!xfs_verify_agino(mp, agno, next_agino)) {
> +	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	if (!xfs_verify_agino(mp, agno, head_agino)) {
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  				agi, sizeof(*agi));
>  		error = -EFSCORRUPTED;
>  		goto out;
>  	}
>  
> -	if (next_agino == agino) {
> -		/*
> -		 * We're at the head of the list.  Get the inode's on-disk
> -		 * buffer to see if there is anyone after us on the list.
> -		 */
> -		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
> -				&next_agino);
> -		if (error)
> -			goto out;
> +	/*
> +	 * Set our inode's next_unlinked pointer to NULL and then return
> +	 * the old pointer value so that we can update whatever was previous
> +	 * to us in the list to point to whatever was next in the list.
> +	 */
> +	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
> +	if (error)
> +		goto out;
>  
> +	if (head_agino == agino) {
>  		/* Point the head of the list to the next unlinked inode. */
>  		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
>  				next_agino);
> @@ -2225,20 +2226,11 @@ xfs_iunlink_remove(
>  		struct xfs_imap	imap;
>  
>  		/* We need to search the list for the inode being freed. */
> -		error = xfs_iunlink_map_prev(tp, pag, next_agino, agino,
> +		error = xfs_iunlink_map_prev(tp, pag, head_agino, agino,
>  				&prev_ino, &imap, &last_dip, &last_ibp);
>  		if (error)
>  			goto out;
>  
> -		/*
> -		 * Now last_ibp points to the buffer previous to us on the
> -		 * unlinked list.  Pull us from the list.
> -		 */
> -		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
> -				&next_agino);
> -		if (error)
> -			goto out;
> -
>  		/* Point the previous inode on the list to the next inode. */
>  		xfs_iunlink_update_dinode(tp, agno, last_ibp, last_dip, &imap,
>  				prev_ino, next_agino);
> 
