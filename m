Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbfBATAz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 14:00:55 -0500
Date: Fri, 1 Feb 2019 14:00:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: strengthen AGI unlinked inode bucket pointer
 checks
Message-ID: <20190201190052.GC31203@bfoster>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897669539.26065.18123748779523685840.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897669539.26065.18123748779523685840.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 03:18:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Strengthen our checking of the AGI unlinked pointers when we start to
> use them for updating the metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c |   28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3c33136b21ef..4ddda3f3255f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1942,6 +1942,7 @@ xfs_iunlink(
>  	struct xfs_buf		*ibp;
>  	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
> +	xfs_agino_t		next_agino;
>  	xfs_agino_t		agino;
>  	short			bucket_index;
>  	int			offset;
> @@ -1966,13 +1967,19 @@ xfs_iunlink(
>  	agi = XFS_BUF_TO_AGI(agibp);
>  
>  	/*
> -	 * Get the index into the agi hash table for the
> -	 * list this inode will go on.
> +	 * Get the index into the agi hash table for the list this inode will
> +	 * go on.  Make sure the pointer isn't garbage and that this inode
> +	 * isn't already on the list.
>  	 */
> -	ASSERT(agi->agi_unlinked[bucket_index]);
> -	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
> +	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	if (next_agino == agino ||
> +	    (next_agino != NULLAGINO &&
> +	     !xfs_verify_agino(mp, agno, next_agino))) {
> +		error = -EFSCORRUPTED;
> +		goto out_unlock;
> +	}
>  
> -	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
> +	if (next_agino != NULLAGINO) {
>  		/*
>  		 * There is already another inode in the bucket we need
>  		 * to add ourselves to.  Add us at the front of the list.
> @@ -2054,18 +2061,18 @@ xfs_iunlink_remove(
>  	agi = XFS_BUF_TO_AGI(agibp);
>  
>  	/*
> -	 * Get the index into the agi hash table for the
> -	 * list this inode will go on.
> +	 * Get the index into the agi hash table for the list this inode will
> +	 * go on.  Make sure the head pointer isn't garbage.
>  	 */
> -	if (!xfs_verify_agino(mp, agno,
> -			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
> +	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	if (!xfs_verify_agino(mp, agno, next_agino)) {
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  				agi, sizeof(*agi));
>  		error = -EFSCORRUPTED;
>  		goto out_unlock;
>  	}
>  
> -	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
> +	if (next_agino == agino) {
>  		/*
>  		 * We're at the head of the list.  Get the inode's on-disk
>  		 * buffer to see if there is anyone after us on the list.
> @@ -2107,7 +2114,6 @@ xfs_iunlink_remove(
>  		/*
>  		 * We need to search the list for the inode being freed.
>  		 */
> -		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
>  		last_ibp = NULL;
>  		while (next_agino != agino) {
>  			struct xfs_imap	imap;
> 
