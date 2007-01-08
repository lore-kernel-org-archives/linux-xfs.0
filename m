Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 01:21:15 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l089L8qw025051
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 01:21:09 -0800
Date: Mon, 8 Jan 2007 09:12:18 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: make growing by >2TB work
Message-ID: <20070108091218.GB17121@infradead.org>
References: <20070108044414.GC44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108044414.GC44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 03:44:14PM +1100, David Chinner wrote:
> Growing a filesystem by > 2TB currently causes an overflow
> in the transaction subsystem. Make transaction deltas and associated
> elements explicitly 64 bit types so that we don't get overflows.
> 
> Comments?

Looks good.

>  
> -	AIL_LOCKINIT(&mp->m_ail_lock, "xfs_ail");
>  	spinlock_init(&mp->m_sb_lock, "xfs_sb");
>  	mutex_init(&mp->m_ilock);
>  	initnsema(&mp->m_growlock, 1, "xfs_grow");
> -	/*
> -	 * Initialize the AIL.
> -	 */
> -	xfs_trans_ail_init(mp);

This seems unrelated (?)

> -xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int delta, int rsvd)
> +xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int64_t delta, int rsvd)

This seems to be over 80 chars linelength with your patch, just break
the line.
