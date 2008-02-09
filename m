Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 22:33:42 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m196XbHk008618
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 22:33:39 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A4CA5B9EF4
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2008 22:34:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id hm5lgLJ6l3DjaYWJ for <xfs@oss.sgi.com>; Fri, 08 Feb 2008 22:34:00 -0800 (PST)
Date: Sat, 9 Feb 2008 01:33:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] recover from iclog allocation failures
Message-ID: <20080209063329.GA6840@infradead.org>
References: <47AD3E11.7020608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AD3E11.7020608@redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 08, 2008 at 11:45:53PM -0600, Eric Sandeen wrote:
>  	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> +	if (!mp->m_log)
> +		return ENOMEM;

Currently there's no allocations in there that should be able to fail.
But actually marking these KM_MAYFAIL would be a good idea.

> @@ -1219,6 +1221,13 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  		prev_iclog = iclog;
>  
>  		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
> +		if (!iclog || !bp) {
> +			if (iclog)
> +				kmem_free(iclog, sizeof(xlog_in_core_t));
> +			log->l_iclog_bufs = i;
> +			xlog_dealloc_log(log);
> +			return NULL;
> +		}

Please check for iclog beeing NULL before trying to allocate the buffer,
and switch it to KM_MAYFAIL.  Given that there are two failing cases now
it would make sense to have goto-unwinding here.

Also once you touch the memory allocation feel free to remove the
useless casts of their return values.

> Index: linux-2.6.24.noarch/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6.24.noarch.orig/fs/xfs/xfs_mount.c
> +++ linux-2.6.24.noarch/fs/xfs/xfs_mount.c
> @@ -1007,6 +1007,7 @@ xfs_mountfs(
>  			error = XFS_ERROR(EINVAL);
>  			goto error1;
>  		}
> +		uuid_mounted = 1;

How is this related to the rest of the patch?
