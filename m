Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA0417F58
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:40:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B80B58F8064
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:40:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YFZ4Q0gfrL3jksC9 for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:40:58 -0700 (PDT)
Date: Tue, 15 Apr 2014 15:40:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] repair: report AG btree verifier errors
Message-ID: <20140415194048.GD3470@laptop.bfoster>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-7-git-send-email-david@fromorbit.com>
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

On Tue, Apr 15, 2014 at 06:24:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we scan the filesystem freespace and inode maps in phase 2, we
> don't report CRC errors that are found. We don't really care from a
> repair perspective, because the trees are completely rebuilt from
> the ground up in phase 5, but froma checking perspective we need to
> inform the user that we found inconsistencies.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/scan.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 6c43474..75b4b70 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -82,6 +82,12 @@ scan_sbtree(
>  		do_error(_("can't read btree block %d/%d\n"), agno, root);
>  		return;
>  	}
> +	if (bp->b_error == EFSBADCRC || bp->b_error == EFSCORRUPTED) {
> +		do_warn(_("btree block %d/%d is suspect, error %d\n"),
> +			agno, root, bp->b_error);
> +		suspect = 1;
> +	}
> +
>  	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect,
>  							isroot, magic, priv);
>  	libxfs_putbuf(bp);
> @@ -123,6 +129,7 @@ scan_lbtree(
>  	xfs_buf_t	*bp;
>  	int		err;
>  	int		dirty = 0;
> +	bool		badcrc = false;
>  
>  	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
>  		      XFS_FSB_TO_BB(mp, 1), 0, ops);
> @@ -132,14 +139,25 @@ scan_lbtree(
>  			XFS_FSB_TO_AGBNO(mp, root));
>  		return(1);
>  	}
> +
> +	/*
> +	 * only check for bad CRC here - caller will determine if there
> +	 * is a corruption or not and whether it got corrected and so needs
> +	 * writing back. CRC errors always imply we need to write the block.
> +	 */
> +	if (bp->b_error == EFSBADCRC) {
> +		do_warn(_("btree block %d/%d is suspect, error %d\n"),
> +			XFS_FSB_TO_AGNO(mp, root),
> +			XFS_FSB_TO_AGBNO(mp, root), bp->b_error);
> +		badcrc = true;
> +	}
> +
>  	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
>  			type, whichfork, root, ino, tot, nex, blkmapp,
>  			bm_cursor, isroot, check_dups, &dirty,
>  			magic);
>  
> -	ASSERT(dirty == 0 || (dirty && !no_modify));
> -

Here we remove the dirty assert, but don't change the semantics of dirty
(we use badcrc).

Brian

> -	if (dirty && !no_modify)
> +	if ((dirty || badcrc) && !no_modify)
>  		libxfs_writebuf(bp, 0);
>  	else
>  		libxfs_putbuf(bp);
> @@ -1066,6 +1084,9 @@ scan_freelist(
>  		do_abort(_("can't read agfl block for ag %d\n"), agno);
>  		return;
>  	}
> +	if (agflbuf->b_error == EFSBADCRC)
> +		do_warn(_("agfl has bad CRC for ag %d\n"), agno);
> +
>  	freelist = XFS_BUF_TO_AGFL_BNO(mp, agflbuf);
>  	i = be32_to_cpu(agf->agf_flfirst);
>  
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
