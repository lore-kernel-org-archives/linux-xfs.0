Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58778 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbdANCNT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 21:13:19 -0500
Subject: Re: [PATCH 5/5] xfs_repair: strengthen geometry checks
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041963.32674.9938209133184119040.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0b7d6af0-d0f0-ee5c-d613-54e03e42fc9e@sandeen.net>
Date: Fri, 13 Jan 2017 20:13:17 -0600
MIME-Version: 1.0
In-Reply-To: <148419041963.32674.9938209133184119040.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/11/17 9:06 PM, Darrick J. Wong wrote:
> In xfs_repair, the inodelog, sectlog, and dirblklog values are read
> directly into the xfs_mount structure without any sanity checking by the
> verifier.  This results in xfs_repair segfaulting when those fields have
> ridiculously high values because the pointer arithmetic runs us off the
> end of the metadata buffers.  Therefore, reject the superblock if these
> values are garbage and try to find one of the other ones.
> 
> Also clean up the dblocks checking to use the relevant macros and remove
> a bogus ASSERT that crashes repair when sunit is set but swidth isn't.
> 
> The superblock field fuzzer (xfs/1301) triggers all these segfaults.

ok, thinking out loud below.  Mostly fine but question at the end.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/sb.c         |   19 ++++++++++++++-----
>  repair/xfs_repair.c |    5 ++++-
>  2 files changed, 18 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index 004702c..d784420 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -395,21 +395,26 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
>  	/* sanity check ag count, size fields against data size field */
>  
>  	if (sb->sb_dblocks == 0 ||
> -		sb->sb_dblocks >
> -			((__uint64_t)sb->sb_agcount * sb->sb_agblocks) ||
> -		sb->sb_dblocks <
> -			((__uint64_t)(sb->sb_agcount - 1) * sb->sb_agblocks
> -			+ XFS_MIN_AG_BLOCKS))
> +		sb->sb_dblocks > XFS_MAX_DBLOCKS(sb) ||
> +		sb->sb_dblocks < XFS_MIN_DBLOCKS(sb))

Ok so this is just proper macro replacement, all good.

>  		return(XR_BAD_FS_SIZE_DATA);
>  
>  	if (sb->sb_agblklog != (__uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
>  		return(XR_BAD_FS_SIZE_DATA);
>  
> +	if (sb->sb_inodelog < XFS_DINODE_MIN_LOG ||
> +		sb->sb_inodelog > XFS_DINODE_MAX_LOG ||
> +		sb->sb_inodelog != libxfs_log2_roundup(sb->sb_inodesize))
> +		return XR_BAD_INO_SIZE_DATA;
> +

missing parentheses on the return.  (I kid!)

Ok, we haven't checked out inodesize yet, so if it's wrong, the above
might return XR_BAD_INO_SIZE_DATA even if sb_inodelog is ok.
I suppose that's fine.

hm at some point I wonder if this should more closely match
xfs_mount_validate_sb (or vice versa)

That function does:

            sbp->sb_inodesize != (1 << sbp->sb_inodelog)                ||

which is the reverse I guess.

>  	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE ||
>  		sb->sb_inodesize > XFS_DINODE_MAX_SIZE ||
>  		sb->sb_inopblock != howmany(sb->sb_blocksize,sb->sb_inodesize))
>  		return(XR_BAD_INO_SIZE_DATA);

Ok, this doesn't cross-check inodesize vs. inodelog, but I guess that's
already done above.

> +	if (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog)
> +		return XR_BAD_INO_SIZE_DATA;
> +

oh yeah that too.

I do kind of wonder if we shouldn't just match that mount code more
closely, and just do

if (sbp->sb_inodesize < XFS_DINODE_MIN_SIZE                     ||
    sbp->sb_inodesize > XFS_DINODE_MAX_SIZE                     ||
    sbp->sb_inodelog < XFS_DINODE_MIN_LOG                       ||
    sbp->sb_inodelog > XFS_DINODE_MAX_LOG                       ||
    sbp->sb_inodesize != (1 << sbp->sb_inodelog)                ||
    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE                    ||
    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog))
	return XR_BAD_INO_SIZE_DATA;

>  	if (xfs_sb_version_hassector(sb))  {
>  
>  		/* check to make sure log sector is legal 2^N, 9 <= N <= 15 */
> @@ -494,6 +499,10 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
>  			return(XR_BAD_SB_WIDTH);
>  	}
>  
> +	/* Directory block log */
> +	if (sb->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG)
> +		return XR_BAD_FS_SIZE_DATA;
> +

OK anyway, if any of this fails we go and take a vote from secondaries,
should be fine.

>  	return(XR_OK);
>  }
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 5c79fd9..8d4be83 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -621,7 +621,10 @@ is_multidisk_filesystem(
>  	if (!sbp->sb_unit)
>  		return false;
>  
> -	ASSERT(sbp->sb_width);
> +	/* Stripe unit but no stripe width?  Something's funny here... */
> +	if (!sbp->sb_width)
> +		return false;
> +

verify_sb did already sanitize this...

        /*
         * verify stripe alignment fields if present
         */
        if (xfs_sb_version_hasdalign(sb)) {
                if ((!sb->sb_unit && sb->sb_width) ||
                    (sb->sb_unit && sb->sb_agblocks % sb->sb_unit))
                        return(XR_BAD_SB_UNIT);
                if ((sb->sb_unit && !sb->sb_width) ||
                    (sb->sb_width && sb->sb_unit && sb->sb_width % sb->sb_unit))
                        return(XR_BAD_SB_WIDTH);
        }

so we do this when we start up:

main
    get_sb
        verify_sb
    ...
    is_multidisk_filesystem

by then it should have been ok, what path did you hit this on?

Seems like we shouldn't be making decisions about "is multidisk"
here, we should be saying "bad superblock" somewhere earlier, no?

I mean, bailing with false is fine I /guess/ but I think the ASSERT
implies that we should have already verified that both or none
are set...

-Eric

>  	return true;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
