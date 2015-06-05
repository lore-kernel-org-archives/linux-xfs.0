Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C042B7FBE
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 20:12:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37BA1AC002
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 18:12:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pZPrQGthESwJUxrs for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 18:12:12 -0700 (PDT)
Date: Fri, 5 Jun 2015 11:12:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/28] repair: process sparse inode records correctly
Message-ID: <20150605011210.GO9143@dastard>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
	<1433270521-62026-22-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433270521-62026-22-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 02, 2015 at 02:41:54PM -0400, Brian Foster wrote:
> The inode processing phases of xfs_repair (3 and 4) validate the actual
> inodes referred to by the previously scanned inode btrees. The physical
> inodes are read from disk and internally validated in various ways. The
> inode block state is also verified and corrected if necessary.
> 
> Sparse inodes are not physically allocated and the associated blocks may
> be allocated to any other area of the fs (file data, internal use,
> etc.). Attempts to validate these blocks as inode blocks produce noisy
> corruption errors.
> 
> Update the inode processing mechanism to handle sparse inode records
> correctly. Since sparse inodes do not exist, the general approach here
> is to simply skip validation of sparse inodes. Update
> process_inode_chunk() to skip reads of sparse clusters and set the buf
> pointer of associated clusters to NULL. Update the rest of the function
> to only verify non-NULL cluster buffers. Also, skip the inode block
> state checks for blocks in sparse inode clusters.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Code looks good, but in looking at this, another helper is in order:

> @@ -736,35 +757,41 @@ process_inode_chunk(
>  	/*
>  	 * mark block as an inode block in the incore bitmap
>  	 */
> -	pthread_mutex_lock(&ag_locks[agno].lock);
> -	state = get_bmap(agno, agbno);
> -	switch (state) {
> -	case XR_E_INO:	/* already marked */
> -		break;
> -	case XR_E_UNKNOWN:
> -	case XR_E_FREE:
> -	case XR_E_FREE1:
> -		set_bmap(agno, agbno, XR_E_INO);
> -		break;
> -	case XR_E_BAD_STATE:
> -		do_error(_("bad state in block map %d\n"), state);
> -		break;
> -	default:
> -		set_bmap(agno, agbno, XR_E_MULT);
> -		do_warn(_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
> -			XFS_AGB_TO_FSB(mp, agno, agbno), state);
> -		break;
> +	if (!is_inode_sparse(ino_rec, irec_offset)) {
> +		pthread_mutex_lock(&ag_locks[agno].lock);
> +		state = get_bmap(agno, agbno);
> +		switch (state) {
> +		case XR_E_INO:	/* already marked */
> +			break;
> +		case XR_E_UNKNOWN:
> +		case XR_E_FREE:
> +		case XR_E_FREE1:
> +			set_bmap(agno, agbno, XR_E_INO);
> +			break;
> +		case XR_E_BAD_STATE:
> +			do_error(_("bad state in block map %d\n"), state);
> +			break;
> +		default:
> +			set_bmap(agno, agbno, XR_E_MULT);
> +			do_warn(
> +		_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
> +				XFS_AGB_TO_FSB(mp, agno, agbno), state);
> +			break;
> +		}
> +		pthread_mutex_unlock(&ag_locks[agno].lock);
>  	}
> -	pthread_mutex_unlock(&ag_locks[agno].lock);

This state update code is repeated and has an indentical
modification later in the patch, so can you factor
it into a helper again? (delta patch!)

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
