Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 00:47:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K7lMF4007061
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:47:23 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7F6B6C4D47
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:47:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id mkWW99FGFvTR4MS5 for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:47:55 -0700 (PDT)
Date: Thu, 20 Mar 2008 03:47:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] Prevent shutdown on inode allocation failure
Message-ID: <20080320074724.GG19969@infradead.org>
References: <20080320052100.GA95344431@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320052100.GA95344431@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 20, 2008 at 04:21:00PM +1100, David Chinner wrote:
> At ENOSPC, we can get a filesystem shutdown due to a cancelling a
> dirty transaction in xfs_mkdir or xfs_create. This is due to the
> initial allocation attempt not taking into inode alignment and hence
> we can prepare the AGF freelist for allocation when it's not actually
> possible to do an allocation. This results in inode allocation returning
> ENOSPC with a dirty transaction, and hence we shut down the filesystem.
> 
> Because the first allocation is an exact allocation attempt, we must tell
> the allocator that the alignment does not affect the allocation attempt.
> i.e. we will accept any extent alignment as long as the extent starts
> at the block we want. Unfortunately, this means that if the longest
> free extent is less than the length + alignment necessary for fallback
> allocation attempts but is long enough to attempt a non-aligned allocation,
> we will modify the free list.
> 
> If we then have the exact allocation fail, all other allocation attempts
> will also fail due to the alignment constraint being taken into account.
> Hence the initial attempt needs to set the "alignment slop" field so
> that alignment, while not required, must be taken into account when
> determining if there is enough space left in the AG to do the allocation.
> 
> That means if the exact allocation fails, we will not dirty the freelist
> if there is not enough space available fo a subsequent allocation to
> succeed. Hence we get an ENOSPC error back to userspace without shutting
> down the filesystem.

Looks good.
