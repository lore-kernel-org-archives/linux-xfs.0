Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbeC2PxF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Mar 2018 11:53:05 -0400
Date: Thu, 29 Mar 2018 08:53:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/10] xfsprogs: remove unused delete_attr_ok
Message-ID: <20180329155301.GA13552@magnolia>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
 <9521811b-dc58-d756-e525-8ca428f1b806@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9521811b-dc58-d756-e525-8ca428f1b806@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 29, 2018 at 10:43:02AM -0500, Eric Sandeen wrote:
> delete_attr_ok is never set to anything but 1;
> remove it and all associated code.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 07bcf80..9af4f05 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2093,14 +2093,9 @@ process_inode_attr_fork(
>  		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
>  
>  		if (!no_modify)  {
> -			if (delete_attr_ok)  {
> -				do_warn(_(", clearing attr fork\n"));
> -				*dirty += clear_dinode_attr(mp, dino, lino);
> -				dino->di_aformat = XFS_DINODE_FMT_LOCAL;
> -			} else  {
> -				do_warn("\n");
> -				*dirty += clear_dinode(mp, dino, lino);
> -			}
> +			do_warn(_(", clearing attr fork\n"));
> +			*dirty += clear_dinode_attr(mp, dino, lino);
> +			dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>  			ASSERT(*dirty > 0);
>  		} else  {
>  			do_warn(_(", would clear attr fork\n"));
> @@ -2111,7 +2106,7 @@ process_inode_attr_fork(
>  		blkmap_free(ablkmap);
>  		*retval = 1;
>  
> -		return delete_attr_ok ? 0 : 1;
> +		return 0;
>  	}
>  
>  	if (check_dups)  {
> diff --git a/repair/globals.h b/repair/globals.h
> index 5192542..e777ba2 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -94,7 +94,6 @@ EXTERN int	dangerously;		/* live dangerously ... fix ro mount */
>  EXTERN int	isa_file;
>  EXTERN int	zap_log;
>  EXTERN int	dumpcore;		/* abort, not exit on fatal errs */
> -EXTERN int	delete_attr_ok;		/* can clear attrs w/o clearing files */
>  EXTERN int	force_geo;		/* can set geo on low confidence info */
>  EXTERN int	assume_xfs;		/* assume we have an xfs fs */
>  EXTERN char	*log_name;		/* Name of log device */
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index c2106e4..b2a2432 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -198,7 +198,6 @@ process_args(int argc, char **argv)
>  	zap_log = 0;
>  	dumpcore = 0;
>  	full_ino_ex_data = 0;
> -	delete_attr_ok = 1;
>  	force_geo = 0;
>  	assume_xfs = 0;
>  	copied_sunit = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
