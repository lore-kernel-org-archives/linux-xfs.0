Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 21:59:59 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5O4xuQ3002794
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 21:59:57 -0700
Date: Mon, 23 Jun 2008 22:00:56 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: [PATCH 2/2] Restore the lowspace extent allocator algorithm
Message-ID: <20080624050056.GO16257@build-svl-1.agami.com>
References: <486058F3.3030305@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486058F3.3030305@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 24, 2008 at 12:16:19PM +1000, Lachlan McIlroy wrote:
> When free space is running low the extent allocator may choose to
> allocate an extent from an AG without leaving sufficient space for
> a btree split when inserting the new extent (see where
> xfs_bmap_btalloc() sets minleft to 0).  In this case the allocator
> will enable the lowspace algorithm which is supposed to allow further
> allocations (such as btree splits and newroots) to allocate from
> sequential AGs.  This algorithm has been broken for a long time
> and this patch restores its behaviour.

Looks ok to me. Perhaps add a comment to the definition of
xbf_low that explains what it is used for so it doesn't
get broken again in future?

Cheers,

Dave.
-- 
Dave Chinner
dchinner@agami.com
