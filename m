Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 18:56:49 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7O1ui4p005425
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 18:56:47 -0700
Date: Fri, 24 Aug 2007 02:36:35 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix filestreams on 32-bit boxes
Message-ID: <20070824013635.GA1500@infradead.org>
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

Please also kill that blody cast.  Function pointer casts are wonderful
for hiding bugs like the one you just fixed from compilers, but that's it.
