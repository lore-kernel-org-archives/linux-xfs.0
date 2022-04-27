Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA5CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiD0As0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356471AbiD0AsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:48:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F142C3584A
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B44AEB82375
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49675C385A0;
        Wed, 27 Apr 2022 00:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020304;
        bh=lsnUrXNR4PgcgxSs9/nlj9hRd8vSQIpnoOAPcgpgZEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7G+tMM8YIx3osojbtfkbKxmYFE/VBgP1i5azeSWVDOqcivJ/hrcaFMWHtL9CDiuQ
         oy41y/Jr8HOcYD18BS8JOb6QljoRwbltJg2F8cFv37o8Mla0f6UuUJbxujeaMhOzzw
         hZ08TKU+XLqMwc4l8wFvUPQH5wCG5c91+TaZnJA+rC8ZkLPwJBZhreeSkk4TezyQA0
         8HhAIDH8pIfZ2dnH58FpcS6k3de6mO13mhIU1TQGt4ZWF4GeAJdkoJekJC+6xe5jSW
         hDUc3Rx1PS1Fy49VxMmcyAUxSdALzuKj9TcHmY9M6Hho+LvIIxK7T+34t1fnrVrG7E
         Z0B/YnFvrOK7Q==
Date:   Tue, 26 Apr 2022 17:45:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] metadump: handle corruption errors without aborting
Message-ID: <20220427004503.GZ17025@magnolia>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426234453.682296-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 09:44:50AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Sean Caron reported that a metadump terminated after givin gthis
> warning:
> 
> xfs_metadump: inode 2216156864 has unexpected extents
> 
> Metadump is supposed to ignore corruptions and continue dumping the
> filesystem as best it can. Whilst it warns about many situations
> where it can't fully dump structures, it should stop processing that
> structure and continue with the next one until the entire filesystem
> has been processed.
> 
> Unfortunately, some warning conditions also return an "abort" error
> status, causing metadump to abort if that condition is hit. Most of
> these abort conditions should really be "continue on next object"
> conditions so that the we attempt to dump the rest of the
> filesystem.
> 
> Fix the returns for warnings that incorrectly cause aborts
> such that the only abort conditions are read errors when
> "stop-on-read-error" semantics are specified. Also make the return
> values consistently mean abort/continue rather than returning -errno
> to mean "stop because read error" and then trying to infer what
> the error means in callers without the context it occurred in.

I was almost about to say "This variable should be named success", but
then noticed that there already /are/ variables named success.  Yuck.

rval==0 means abort?  and rval!=0 means continue?  If so,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Reported-and-tested-by: Sean Caron <scaron@umich.edu>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/metadump.c | 94 +++++++++++++++++++++++++--------------------------
>  1 file changed, 47 insertions(+), 47 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 48cda88a3ea5..a21baa2070d9 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1645,7 +1645,7 @@ process_symlink_block(
>  {
>  	struct bbmap	map;
>  	char		*link;
> -	int		ret = 0;
> +	int		rval = 1;
>  
>  	push_cur();
>  	map.nmaps = 1;
> @@ -1658,8 +1658,7 @@ process_symlink_block(
>  
>  		print_warning("cannot read %s block %u/%u (%llu)",
>  				typtab[btype].name, agno, agbno, s);
> -		if (stop_on_read_error)
> -			ret = -1;
> +		rval = !stop_on_read_error;
>  		goto out_pop;
>  	}
>  	link = iocur_top->data;
> @@ -1682,10 +1681,11 @@ process_symlink_block(
>  	}
>  
>  	iocur_top->need_crc = 1;
> -	ret = write_buf(iocur_top);
> +	if (write_buf(iocur_top))
> +		rval = 0;
>  out_pop:
>  	pop_cur();
> -	return ret;
> +	return rval;
>  }
>  
>  #define MAX_REMOTE_VALS		4095
> @@ -1843,8 +1843,8 @@ process_single_fsb_objects(
>  	typnm_t		btype,
>  	xfs_fileoff_t	last)
>  {
> +	int		rval = 1;
>  	char		*dp;
> -	int		ret = 0;
>  	int		i;
>  
>  	for (i = 0; i < c; i++) {
> @@ -1858,8 +1858,7 @@ process_single_fsb_objects(
>  
>  			print_warning("cannot read %s block %u/%u (%llu)",
>  					typtab[btype].name, agno, agbno, s);
> -			if (stop_on_read_error)
> -				ret = -EIO;
> +			rval = !stop_on_read_error;
>  			goto out_pop;
>  
>  		}
> @@ -1925,16 +1924,17 @@ process_single_fsb_objects(
>  		}
>  
>  write:
> -		ret = write_buf(iocur_top);
> +		if (write_buf(iocur_top))
> +			rval = 0;
>  out_pop:
>  		pop_cur();
> -		if (ret)
> +		if (!rval)
>  			break;
>  		o++;
>  		s++;
>  	}
>  
> -	return ret;
> +	return rval;
>  }
>  
>  /*
> @@ -1952,7 +1952,7 @@ process_multi_fsb_dir(
>  	xfs_fileoff_t	last)
>  {
>  	char		*dp;
> -	int		ret = 0;
> +	int		rval = 1;
>  
>  	while (c > 0) {
>  		unsigned int	bm_len;
> @@ -1978,8 +1978,7 @@ process_multi_fsb_dir(
>  
>  				print_warning("cannot read %s block %u/%u (%llu)",
>  						typtab[btype].name, agno, agbno, s);
> -				if (stop_on_read_error)
> -					ret = -1;
> +				rval = !stop_on_read_error;
>  				goto out_pop;
>  
>  			}
> @@ -1998,18 +1997,19 @@ process_multi_fsb_dir(
>  			}
>  			iocur_top->need_crc = 1;
>  write:
> -			ret = write_buf(iocur_top);
> +			if (write_buf(iocur_top))
> +				rval = 0;
>  out_pop:
>  			pop_cur();
>  			mfsb_map.nmaps = 0;
> -			if (ret)
> +			if (!rval)
>  				break;
>  		}
>  		c -= bm_len;
>  		s += bm_len;
>  	}
>  
> -	return ret;
> +	return rval;
>  }
>  
>  static bool
> @@ -2039,15 +2039,15 @@ process_multi_fsb_objects(
>  		return process_symlink_block(o, s, c, btype, last);
>  	default:
>  		print_warning("bad type for multi-fsb object %d", btype);
> -		return -EINVAL;
> +		return 1;
>  	}
>  }
>  
>  /* inode copy routines */
>  static int
>  process_bmbt_reclist(
> -	xfs_bmbt_rec_t 		*rp,
> -	int 			numrecs,
> +	xfs_bmbt_rec_t		*rp,
> +	int			numrecs,
>  	typnm_t			btype)
>  {
>  	int			i;
> @@ -2059,7 +2059,7 @@ process_bmbt_reclist(
>  	xfs_agnumber_t		agno;
>  	xfs_agblock_t		agbno;
>  	bool			is_multi_fsb = is_multi_fsb_object(mp, btype);
> -	int			error;
> +	int			rval = 1;
>  
>  	if (btype == TYP_DATA)
>  		return 1;
> @@ -2123,16 +2123,16 @@ process_bmbt_reclist(
>  
>  		/* multi-extent blocks require special handling */
>  		if (is_multi_fsb)
> -			error = process_multi_fsb_objects(o, s, c, btype,
> +			rval = process_multi_fsb_objects(o, s, c, btype,
>  					last);
>  		else
> -			error = process_single_fsb_objects(o, s, c, btype,
> +			rval = process_single_fsb_objects(o, s, c, btype,
>  					last);
> -		if (error)
> -			return 0;
> +		if (!rval)
> +			break;
>  	}
>  
> -	return 1;
> +	return rval;
>  }
>  
>  static int
> @@ -2331,7 +2331,7 @@ process_inode_data(
>  	return 1;
>  }
>  
> -static int
> +static void
>  process_dev_inode(
>  	xfs_dinode_t		*dip)
>  {
> @@ -2339,15 +2339,13 @@ process_dev_inode(
>  		if (show_warnings)
>  			print_warning("inode %llu has unexpected extents",
>  				      (unsigned long long)cur_ino);
> -		return 0;
> -	} else {
> -		if (zero_stale_data) {
> -			unsigned int	size = sizeof(xfs_dev_t);
> +		return;
> +	}
> +	if (zero_stale_data) {
> +		unsigned int	size = sizeof(xfs_dev_t);
>  
> -			memset(XFS_DFORK_DPTR(dip) + size, 0,
> -					XFS_DFORK_DSIZE(dip, mp) - size);
> -		}
> -		return 1;
> +		memset(XFS_DFORK_DPTR(dip) + size, 0,
> +				XFS_DFORK_DSIZE(dip, mp) - size);
>  	}
>  }
>  
> @@ -2365,11 +2363,10 @@ process_inode(
>  	xfs_dinode_t 		*dip,
>  	bool			free_inode)
>  {
> -	int			success;
> +	int			rval = 1;
>  	bool			crc_was_ok = false; /* no recalc by default */
>  	bool			need_new_crc = false;
>  
> -	success = 1;
>  	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
>  
>  	/* we only care about crc recalculation if we will modify the inode. */
> @@ -2390,32 +2387,34 @@ process_inode(
>  	/* copy appropriate data fork metadata */
>  	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
>  		case S_IFDIR:
> -			success = process_inode_data(dip, TYP_DIR2);
> +			rval = process_inode_data(dip, TYP_DIR2);
>  			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
>  				need_new_crc = 1;
>  			break;
>  		case S_IFLNK:
> -			success = process_inode_data(dip, TYP_SYMLINK);
> +			rval = process_inode_data(dip, TYP_SYMLINK);
>  			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
>  				need_new_crc = 1;
>  			break;
>  		case S_IFREG:
> -			success = process_inode_data(dip, TYP_DATA);
> +			rval = process_inode_data(dip, TYP_DATA);
>  			break;
>  		case S_IFIFO:
>  		case S_IFCHR:
>  		case S_IFBLK:
>  		case S_IFSOCK:
> -			success = process_dev_inode(dip);
> +			process_dev_inode(dip);
>  			need_new_crc = 1;
>  			break;
>  		default:
>  			break;
>  	}
>  	nametable_clear();
> +	if (!rval)
> +		goto done;
>  
>  	/* copy extended attributes if they exist and forkoff is valid */
> -	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
> +	if (XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
>  		attr_data.remote_val_count = 0;
>  		switch (dip->di_aformat) {
>  			case XFS_DINODE_FMT_LOCAL:
> @@ -2425,11 +2424,11 @@ process_inode(
>  				break;
>  
>  			case XFS_DINODE_FMT_EXTENTS:
> -				success = process_exinode(dip, TYP_ATTR);
> +				rval = process_exinode(dip, TYP_ATTR);
>  				break;
>  
>  			case XFS_DINODE_FMT_BTREE:
> -				success = process_btinode(dip, TYP_ATTR);
> +				rval = process_btinode(dip, TYP_ATTR);
>  				break;
>  		}
>  		nametable_clear();
> @@ -2442,7 +2441,8 @@ done:
>  
>  	if (crc_was_ok && need_new_crc)
>  		libxfs_dinode_calc_crc(mp, dip);
> -	return success;
> +
> +	return rval;
>  }
>  
>  static uint32_t	inodes_copied;
> @@ -2541,7 +2541,7 @@ copy_inode_chunk(
>  
>  			/* process_inode handles free inodes, too */
>  			if (!process_inode(agno, agino + ioff + i, dip,
> -			    XFS_INOBT_IS_FREE_DISK(rp, ioff + i)))
> +					XFS_INOBT_IS_FREE_DISK(rp, ioff + i)))
>  				goto pop_out;
>  
>  			inodes_copied++;
> @@ -2800,7 +2800,7 @@ copy_ino(
>  	xfs_agblock_t		agbno;
>  	xfs_agino_t		agino;
>  	int			offset;
> -	int			rval = 0;
> +	int			rval = 1;
>  
>  	if (ino == 0 || ino == NULLFSINO)
>  		return 1;
> -- 
> 2.35.1
> 
