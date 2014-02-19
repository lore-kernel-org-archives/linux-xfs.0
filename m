Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E1DB801B
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 08:01:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 75FFE8F804B
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 06:01:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PzcP5JHEAqHci0hQ for
	<xfs@oss.sgi.com>; Wed, 19 Feb 2014 06:01:45 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1JE1h7u005825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 09:01:43 -0500
Message-ID: <5304B941.5090800@redhat.com>
Date: Wed, 19 Feb 2014 09:01:37 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 9/9] xfs: modify verifiers to differentiate CRC from other
	errors
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1392767549-25574-10-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 02/18/2014 06:52 PM, Eric Sandeen wrote:
> Modify all read & write verifiers to differentiate
> between CRC errors and other inconsistencies.
> 
> This sets the appropriate error number on bp->b_error,
> and then calls xfs_verifier_error() if something went
> wrong.  That function will issue the appropriate message
> to the user.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_alloc.c          |   37 +++++++++++++++++--------------------
>  fs/xfs/xfs_alloc_btree.c    |   15 ++++++++-------
>  fs/xfs/xfs_attr_leaf.c      |   14 ++++++++------
>  fs/xfs/xfs_attr_remote.c    |   15 ++++++---------
>  fs/xfs/xfs_bmap_btree.c     |   16 ++++++++--------
>  fs/xfs/xfs_da_btree.c       |   14 ++++++++------
>  fs/xfs/xfs_dir2_block.c     |   14 ++++++++------
>  fs/xfs/xfs_dir2_data.c      |   17 +++++++++--------
>  fs/xfs/xfs_dir2_leaf.c      |   14 ++++++++------
>  fs/xfs/xfs_dir2_node.c      |   14 ++++++++------
>  fs/xfs/xfs_dquot_buf.c      |   11 +++++++----
>  fs/xfs/xfs_ialloc.c         |   12 ++++++++----
>  fs/xfs/xfs_ialloc_btree.c   |   15 ++++++++-------
>  fs/xfs/xfs_inode_buf.c      |    3 +--
>  fs/xfs/xfs_sb.c             |   10 ++++------
>  fs/xfs/xfs_symlink_remote.c |   12 +++++++-----
>  16 files changed, 123 insertions(+), 110 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 9c7cf3d..9a93601 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -474,7 +474,6 @@ xfs_agfl_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> -	int		agfl_ok = 1;
>  
>  	/*
>  	 * There is no verification of non-crc AGFLs because mkfs does not
> @@ -485,14 +484,13 @@ xfs_agfl_read_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	agfl_ok = xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF);
> -
> -	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
> -
> -	if (!agfl_ok) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (!xfs_buf_verify_cksum(bp, offsetof(struct xfs_agfl, agfl_crc)))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_agfl_verify(bp))

Obviously you added the CRC_OFF directives earlier in the set. It looks
like this patch squashed a couple of them (XFS_AGF_CRC_OFF as well).

>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
...
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 4657586..8aa720d 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -1573,13 +1573,17 @@ xfs_agi_read_verify(
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		agi_ok = xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF);
>  
> +	if (!agi_ok)
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +
>  	agi_ok = agi_ok && xfs_agi_verify(bp);
>  
>  	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
> -			XFS_RANDOM_IALLOC_READ_AGI))) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +			XFS_RANDOM_IALLOC_READ_AGI)))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }

Any reason not to use the same if/else pattern here that the others are
now using (i.e., similar to xfs_agf_read_verify(), removing the need for
agi_ok)?

Brian

>  
>  static void
> @@ -1590,8 +1594,8 @@ xfs_agi_write_verify(
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	if (!xfs_agi_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
> index 0028c50..7e309b1 100644
> --- a/fs/xfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/xfs_ialloc_btree.c
> @@ -243,12 +243,14 @@ static void
>  xfs_inobt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (!(xfs_btree_sblock_verify_crc(bp) &&
> -	      xfs_inobt_verify(bp))) {
> -		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
> +	if (!xfs_btree_sblock_verify_crc(bp))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_inobt_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +
> +	if (bp->b_error) {
> +		trace_xfs_btree_corrupt(bp, _RET_IP_);
> +		xfs_verifier_error(bp);
>  	}
>  }
>  
> @@ -258,9 +260,8 @@ xfs_inobt_write_verify(
>  {
>  	if (!xfs_inobt_verify(bp)) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
> diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
> index 606b43a..24e9939 100644
> --- a/fs/xfs/xfs_inode_buf.c
> +++ b/fs/xfs/xfs_inode_buf.c
> @@ -102,8 +102,7 @@ xfs_inode_buf_verify(
>  			}
>  
>  			xfs_buf_ioerror(bp, EFSCORRUPTED);
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
> -					     mp, dip);
> +			xfs_verifier_error(bp);
>  #ifdef DEBUG
>  			xfs_alert(mp,
>  				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index 818359f..b134aa8 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -614,7 +614,7 @@ xfs_sb_read_verify(
>  			/* Only fail bad secondaries on a known V5 filesystem */
>  			if (bp->b_bn == XFS_SB_DADDR ||
>  			    xfs_sb_version_hascrc(&mp->m_sb)) {
> -				error = EFSCORRUPTED;
> +				error = EFSBADCRC;
>  				goto out_error;
>  			}
>  		}
> @@ -623,10 +623,9 @@ xfs_sb_read_verify(
>  
>  out_error:
>  	if (error) {
> -		if (error == EFSCORRUPTED)
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -					     mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, error);
> +		if (error == EFSCORRUPTED || error == EFSBADCRC)
> +			xfs_verifier_error(bp);
>  	}
>  }
>  
> @@ -661,9 +660,8 @@ xfs_sb_write_verify(
>  
>  	error = xfs_sb_verify(bp, false);
>  	if (error) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, error);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
> index defa09f..9b32052 100644
> --- a/fs/xfs/xfs_symlink_remote.c
> +++ b/fs/xfs/xfs_symlink_remote.c
> @@ -133,11 +133,13 @@ xfs_symlink_read_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF) ||
> -	    !xfs_symlink_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_symlink_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -152,8 +154,8 @@ xfs_symlink_write_verify(
>  		return;
>  
>  	if (!xfs_symlink_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
