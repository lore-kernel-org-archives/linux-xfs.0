Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 22:49:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m525naOp010606
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 22:49:36 -0700
Date: Mon, 2 Jun 2008 01:50:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Zero uninitialised xfs_da_args structure in xfs_dir2.c
Message-ID: <20080602055028.GA1629@infradead.org>
References: <op.ub3wttk53jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ub3wttk53jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jun 02, 2008 at 03:42:55PM +1000, Barry Naujok wrote:
> In particular, this patch fixes a problem in the xfs_dir2_remove and
> xfs_dir2_replace paths which internally can call a lookup function
> which will use args->cmpresult which is uninitialised.

> Index: 2.6.x-xfs/fs/xfs/xfs_dir2.c
> ===================================================================
> --- 2.6.x-xfs.orig/fs/xfs/xfs_dir2.c
> +++ 2.6.x-xfs/fs/xfs/xfs_dir2.c
> @@ -213,6 +213,7 @@ xfs_dir_createname(
>  	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
>  		return rval;
>  	XFS_STATS_INC(xs_dir_create);
> +	memset(&args, 0, sizeof(xfs_da_args_t));
>
>  	args.name = name->name;
>  	args.namelen = name->len;

Doing these memsets looks good.  Stylisticly I'd rather put them
directly in front of the intialization for the actually used args
fields.
