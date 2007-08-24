Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 18:48:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O1mT4p003923
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 18:48:34 -0700
Date: Fri, 24 Aug 2007 11:48:20 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] fix filestreams on 32-bit boxes
Message-ID: <20070824014820.GF72985246@sgi.com>
References: <46CE2A07.7080305@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CE2A07.7080305@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 07:44:55PM -0500, Eric Sandeen wrote:
> xfs_filestream_mount() sets up an mru cache with:
> 
>         err = xfs_mru_cache_create(&mp->m_filestream, lifetime, grp_count,
>                              (xfs_mru_cache_free_func_t)xfs_fstrm_free_func);
> 
> but that cast is causing problems...
> 
> typedef void (*xfs_mru_cache_free_func_t)(unsigned long, void*);
> 
> but:
> 
> void xfs_fstrm_free_func( 
>         xfs_ino_t       ino,
>         fstrm_item_t    *item)
> 
> so on a 32-bit box, it's casting (32, 32) args into (64, 32) and I assume 
> it's getting garbage for *item, which subsequently causes an explosion.
> 
> With this change the filestreams xfsqa tests don't oops on my 32-bit box.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Index: linux-2.6.22.i386/fs/xfs/xfs_filestream.c
> ===================================================================
> --- linux-2.6.22.i386.orig/fs/xfs/xfs_filestream.c
> +++ linux-2.6.22.i386/fs/xfs/xfs_filestream.c
> @@ -350,7 +350,7 @@ _xfs_filestream_update_ag(
>  /* xfs_fstrm_free_func(): callback for freeing cached stream items. */
>  void
>  xfs_fstrm_free_func(
> -	xfs_ino_t	ino,
> +	unsigned long	ino,
>  	fstrm_item_t	*item)
>  {
>  	xfs_inode_t	*ip = item->ip;

hmmm - probably should make xfs_fstrm_free_func follow the correct prototype
and convert the item into an opaque void * as well. Then we can remove the
cast that hid this problem in xfs_filestream_mount()....

Nice catch, though, Eric.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
