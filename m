Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2ACD67F5F
	for <linux-xfs@oss.sgi.com>; Mon,  9 Sep 2013 15:36:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C223EAC009
	for <linux-xfs@oss.sgi.com>; Mon,  9 Sep 2013 13:36:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VsuJnu62LVD9ZBCP for <linux-xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 13:36:20 -0700 (PDT)
Message-ID: <522E3142.7090501@sandeen.net>
Date: Mon, 09 Sep 2013 15:36:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: don't break from growfs ag update loop on error
References: <520D1AAC.8090701@redhat.com>
In-Reply-To: <520D1AAC.8090701@redhat.com>
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
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 8/15/13 1:15 PM, Eric Sandeen wrote:
> When xfs_growfs_data_private() is updating backup superblocks,
> it bails out on the first error encountered, whether reading or
> writing:

Any thoughts on this one?  W/ the verifiers, we have a higher
chance of encountering an error, and leaving the rest of the
supers un-updated.  Repair will then possibly revert the fs to
it's pre-growfs state, and data loss will ensue...

Thanks,
-Eric

> * If we get an error writing out the alternate superblocks,
> * just issue a warning and continue.  The real work is
> * already done and committed.
> 
> This can cause a problem later during repair, because repair
> looks at all superblocks, and picks the most prevalent one
> as correct.  If we bail out early in the backup superblock
> loop, we can end up with more "bad" matching superblocks than
> good, and a post-growfs repair may revert the filesystem to
> the old geometry.
> 
> With the combination of superblock verifiers and old bugs,
> we're more likely to encounter read errors due to verification.
> 
> And perhaps even worse, we don't even properly write any of the
> newly-added superblocks in the new AGs.
> 
> Even with this change, growfs will still say:
> 
>   xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
>   data blocks changed from 319815680 to 335216640
> 
> which might be confusing to the user, but it at least communicates
> that something has gone wrong, and dmesg will probably highlight
> the need for an xfs_repair.
> 
> And this is still best-effort; if verifiers fail on more than
> half the backup supers, they may still "win" - but that's probably
> best left to repair to more gracefully handle by doing its own
> strict verification as part of the backup super "voting."
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 614eb0c..70714bb 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -153,7 +153,7 @@ xfs_growfs_data_private(
>  	xfs_buf_t		*bp;
>  	int			bucket;
>  	int			dpct;
> -	int			error;
> +	int			error, saved_error = 0;
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
>  	xfs_rfsblock_t		nb, nb_mod;
> @@ -495,29 +495,33 @@ xfs_growfs_data_private(
>  				error = ENOMEM;
>  		}
>  
> +		/*
> +		 * If we get an error reading or writing alternate superblocks,
> +		 * continue.  xfs_repair chooses the "best" superblock based
> +		 * on most matches; if we break early, we'll leave more
> +		 * superblocks un-updated than updated, and xfs_repair may
> +		 * pick them over the properly-updated primary.
> +		 */
>  		if (error) {
>  			xfs_warn(mp,
>  		"error %d reading secondary superblock for ag %d",
>  				error, agno);
> -			break;
> +			saved_error = error;
> +			continue;
>  		}
>  		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
>  
> -		/*
> -		 * If we get an error writing out the alternate superblocks,
> -		 * just issue a warning and continue.  The real work is
> -		 * already done and committed.
> -		 */
>  		error = xfs_bwrite(bp);
>  		xfs_buf_relse(bp);
>  		if (error) {
>  			xfs_warn(mp,
>  		"write error %d updating secondary superblock for ag %d",
>  				error, agno);
> -			break; /* no point in continuing */
> +			saved_error = error;
> +			continue;
>  		}
>  	}
> -	return error;
> +	return saved_error ? saved_error : error;
>  
>   error0:
>  	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
