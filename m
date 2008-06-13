Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jun 2008 08:56:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5DFuEMd025238
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 08:56:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B635A2280F9
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 08:57:10 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id DQT5mBxmzjf55JcR for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 08:57:10 -0700 (PDT)
Date: Sat, 14 Jun 2008 01:57:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Prevent extent btree block allocation failures
Message-ID: <20080613155708.GG3700@disturbed>
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
> When at ENOSPC conditions extent btree block allocations can fail and we
> have no error handling to undo partial btree operations.  Prior to extent
> btree operations we reserve enough disk blocks somewhere in the filesystem
> to satisfy the operation but in some conditions we require the blocks to
> come from specific AGs and if those AGs are full the allocation fails.
>
> This change fixes xfs_bmap_extents_to_btree(), xfs_bmap_local_to_extents(),
> xfs_bmbt_split() and xfs_bmbt_newroot() so that they can search other AGs
> for the space needed.  Since we have reserved the space these allocations
> are now guaranteed to succeed. 

Sure, but we didn't reserve space for potential btree splits in a
second AG as a result of this. That needs to be reserved in the
transaction as well, which will blow out transaction reservations
substantially as we'll need to add another 2 full AGF btree splits to
every transaction that modifies the bmap btree.

> In order to search all AGs I had to revert
> a change made to xfs_alloc_vextent() that prevented a search from looking
> at AGs lower than the starting AG.  This original change was made to prevent
> out of order AG locking when allocating multiple extents on data writeout
> but since we only allocate one extent at a time now this particular problem
> can't happen.

You missed the fact that the AGF of modified AGs is already held
locked in the transaction, hence the locking order within the
transaction is wrong. Also, if we modify the free list in an AG
the fail an allocation (e.g. can't do an exact allocation), we'll
have multiple dirty and locked AGFs in the one allocation. Hence
we still can have locking order violations if you remove that check
and therefore deadlocks.

This is not the solution to the problem. As I suggested (back when
you first floated this idea as a fix for the problem several weeks
ago) I think the bug is that we are not taking into account the
number of blocks required for a bmbt split when selecting an AG to
allocate from. All we take into account is the blocks required for
the extent to be allocated and nothing else. If we take the blocks
for a bmbt split into account then we'll never try to allocate an
extent in an AG that we can't also allocate all the blocks for the
bmbt split in at the same time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
