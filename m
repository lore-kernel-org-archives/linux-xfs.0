Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jun 2008 06:43:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5DDhN21010733
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 06:43:23 -0700
Date: Fri, 13 Jun 2008 09:44:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Prevent extent btree block allocation failures
Message-ID: <20080613134418.GA31720@infradead.org>
References: <485223E4.6030404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485223E4.6030404@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 13, 2008 at 05:38:12PM +1000, Lachlan McIlroy wrote:
> This change fixes xfs_bmap_extents_to_btree(), xfs_bmap_local_to_extents(),
> xfs_bmbt_split() and xfs_bmbt_newroot() so that they can search other AGs
> for the space needed.  Since we have reserved the space these allocations
> are now guaranteed to succeed.

This looks good and makes lot of sense to me.  Please also add a comment
to enum xfs_alloctype in xfs_alloc.h about the danger of the allocation
types that never go out of the AG when used inside transactions.

> In order to search all AGs I had to revert
> a change made to xfs_alloc_vextent() that prevented a search from looking
> at AGs lower than the starting AG.  This original change was made to prevent
> out of order AG locking when allocating multiple extents on data writeout
> but since we only allocate one extent at a time now this particular problem
> can't happen.

This one also makes sense, but I have a very bad gut feeling about it.
There's nothing preventing the same deadlock scenario from coming back
when people modify the highlevel data allocator again.  We really need
some sort of assert to trigger early in that case to not got a nasty
hard to trigger deadlock.

> +			if (++(args->agno) == mp->m_sb.sb_agcount)

and while we're at it this should be

			if (++args->agno == mp->m_sb.sb_agcount)
