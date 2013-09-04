Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ACBA07F69
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 18:35:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98E09304066
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 16:35:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SrdhHKI4lw0tye3z for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 16:35:28 -0700 (PDT)
Message-ID: <5227C32E.1040805@sandeen.net>
Date: Wed, 04 Sep 2013 18:33:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 54/55] repair: fix segv on directory block read failure
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-55-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-55-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/4/13 5:05 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We try to read all blocks in the directory, but if we have a block
> form directory we only have one block and so we need to fail if
> there is a read error. Otherwise we try to derefence a null buffer
> pointer.
> 
> While fixing the error handling for a read failure, fix the bug that
> caused the read failure - trying to verify a block format buffer
> with the data format buffer verifier.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I independently hit this, and had a similar but crummier fix. ;)

(and missed the root cause, because the fs I ran it on was so
corrupt, there was no element of surprise)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/phase6.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 2a523ca..a4ad7a3 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2064,7 +2064,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  	int			isleaf;
>  	xfs_fileoff_t		next_da_bno;
>  	int			seeval;
> -	int			fixit;
> +	int			fixit = 0;
>  	xfs_dir2_db_t		db;
>  
>  	*need_dot = 1;
> @@ -2091,6 +2091,8 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  	for (da_bno = 0, next_da_bno = 0;
>  	     next_da_bno != NULLFILEOFF && da_bno < mp->m_dirleafblk;
>  	     da_bno = (xfs_dablk_t)next_da_bno) {
> +		const struct xfs_buf_ops *ops;
> +
>  		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
>  		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
>  			break;
> @@ -2104,13 +2106,28 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  		_("realloc failed in longform_dir2_entry_check (%zu bytes)\n"),
>  					num_bps * sizeof(struct xfs_buf*));
>  		}
> +
> +		if (isblock)
> +			ops = &xfs_dir3_block_buf_ops;
> +		else
> +			ops = &xfs_dir3_data_buf_ops;
>  		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bplist[db],
> -				XFS_DATA_FORK, &xfs_dir3_data_buf_ops)) {
> +				       XFS_DATA_FORK, ops)) {
>  			do_warn(
>  	_("can't read data block %u for directory inode %" PRIu64 "\n"),
>  				da_bno, ino);
>  			*num_illegal += 1;
> -			continue;	/* try and read all "data" blocks */
> +
> +			/*
> +			 * we try to read all "data" blocks, but if we are in
> +			 * block form and we fail, there isn't anything else to
> +			 * read, and nothing we can do but trash it.
> +			 */
> +			if (isblock) {
> +				fixit++;
> +				goto out_fix;
> +			}
> +			continue;
>  		}
>  		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
>  				irec, ino_offset, &bplist[db], hashtab,
> @@ -2141,6 +2158,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  								freetab);
>  		}
>  	}
> +out_fix:
>  	if (!no_modify && (fixit || dotdot_update)) {
>  		dir_hash_dup_names(hashtab);
>  		for (i = 0; i < freetab->naents; i++)
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
