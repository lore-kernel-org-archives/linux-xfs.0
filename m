Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52626 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdAWXrV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 18:47:21 -0500
Subject: Re: [PATCH 3/5] xfs_repair: strengthen geometry checks
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494393485.5256.16822617236354659766.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0ed43e2f-2e9a-e53b-0770-1b50fee4b697@sandeen.net>
Date: Mon, 23 Jan 2017 17:47:20 -0600
MIME-Version: 1.0
In-Reply-To: <148494393485.5256.16822617236354659766.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/20/17 2:25 PM, Darrick J. Wong wrote:
> In xfs_repair, the inodelog, sectlog, and dirblklog values are read
> directly into the xfs_mount structure without any sanity checking by the
> verifier.  This results in xfs_repair segfaulting when those fields have
> ridiculously high values because the pointer arithmetic runs us off the
> end of the metadata buffers.  Therefore, reject the superblock if these
> values are garbage and try to find one of the other ones.
> 
> Also clean up the dblocks checking to use the relevant macros and remove
> a bogus ASSERT that crashes repair when sunit is set but swidth isn't.

( ... no ASSERT is removed in this patch ...)

> The superblock field fuzzer (xfs/1301) triggers all these segfaults.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: make the inode geometry more consistent with the kernel sb verifier,
> and prevent an ASSERT if the fs is !dalign but sunit != 0.
> ---
>  repair/sb.c         |   24 +++++++++++++++---------
>  repair/xfs_repair.c |    4 ++++
>  2 files changed, 19 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index 004702c..06b034d 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -395,20 +395,22 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
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

Ok, again this just uses macros in place of open coding, cool.

>  		return(XR_BAD_FS_SIZE_DATA);
>  
>  	if (sb->sb_agblklog != (__uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
>  		return(XR_BAD_FS_SIZE_DATA);
>  
> -	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE ||
> -		sb->sb_inodesize > XFS_DINODE_MAX_SIZE ||
> -		sb->sb_inopblock != howmany(sb->sb_blocksize,sb->sb_inodesize))
> -		return(XR_BAD_INO_SIZE_DATA);
> +	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE                     ||
> +	    sb->sb_inodesize > XFS_DINODE_MAX_SIZE                     ||
> +	    sb->sb_inodelog < XFS_DINODE_MIN_LOG                       ||
> +	    sb->sb_inodelog > XFS_DINODE_MAX_LOG                       ||
> +	    sb->sb_inodesize != (1 << sb->sb_inodelog)                 ||
> +	    sb->sb_logsunit > XLOG_MAX_RECORD_BSIZE                    ||
> +	    sb->sb_inopblock != howmany(sb->sb_blocksize, sb->sb_inodesize) ||
> +	    (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog))
> +		return XR_BAD_INO_SIZE_DATA;

This adds more checks: inodelog, logsunit, and blocklog tests, also cool.
  
>  	if (xfs_sb_version_hassector(sb))  {
>  
> @@ -494,6 +496,10 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
>  			return(XR_BAD_SB_WIDTH);
>  	}
>  
> +	/* Directory block log */
> +	if (sb->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG)
> +		return XR_BAD_FS_SIZE_DATA;
> +

Sorry for not catching this before, but -

Hm, FS_SIZE_DATA ("inconsistent filesystem geometry information") doesn't
seem quite right for this case, it's used for AG problems elsewhere.

I ... guess a new XR_BAD_DIR_SIZE_DATA or something might be a good idea.
It's only informative, but may as well be correctly informative.

>  	return(XR_OK);
>  }
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 5c79fd9..622d569 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -614,6 +614,10 @@ is_multidisk_filesystem(
>  	if (sbp->sb_agcount >= XFS_MULTIDISK_AGCOUNT)
>  		return true;

And now for something completely different :)

> +	/* sunit/swidth are only useful if fs supports dalign. */
> +	if (!xfs_sb_version_hasdalign(sbp))
> +		return false;

I'm still bothered that this is a bit of a special snowflake here.
Why isn't this part of superblock sanity checking?  Thinking
it through...

Outcomes for various correct/incorrect sets of values:

has_dalign	sb_unit	set	sb_width set
0		0		0		OK
0		0		1		invalid [1]
0		1		0		ASSERT (earlier)
0		1		1		invalid [1]
1		0		0		OK (huh?)
1		0		1		invalid [2]
1		1		0		invalid [2]
1		1		1		OK


[1] invalid in secondary_sb_whack (!?), fixes by zeroing both
[2] invalid in verify_sb, fixes by using secondaries

Ok, so this ASSERT is going off because verify_sb didn't
catch it or care, even though a later secondary_sb_whack()
does catch it and fixes it, but we have this ASSERT in between
the two.

At the end of the day, what is_multidisk_filesystem() returns
doesn't impact correctness at all, just performance of xfs_repair.

The ASSERT was essentially coding superblock consistency checks
into this performance-tweaking function.  :/

So I guess the question is: If the superblock stripe geometry
is inconsistent by the time we get to is_multidisk_filesystem(),
what should we do?

1) catch it earlier in verify_sb, and copy from backup?
2) keep that as it is, but only return true here if all 3 are set?
3) return true for some subset of fields set, even if inconsistent,
   as this does? :)

-Eric
