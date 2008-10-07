Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 19:17:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m972HFZi016392
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 19:17:16 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7A9C13A521A
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2008 19:18:53 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id R1mhhA8SxO9bTGsR for <xfs@oss.sgi.com>; Mon, 06 Oct 2008 19:18:53 -0700 (PDT)
Date: Tue, 7 Oct 2008 12:51:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Adding attr, inode reference query
Message-ID: <20081007015123.GG12509@disturbed>
References: <op.uimntunh3jf8g2@pc-bnaujok.melbourne.sgi.com> <20081007005409.GD12509@disturbed> <48EAB9F6.4090102@sgi.com> <48EABB9E.9090302@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EABB9E.9090302@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Oct 07, 2008 at 12:30:06PM +1100, Timothy Shimmin wrote:
> Timothy Shimmin wrote:
> > Dave Chinner wrote:
> >> On Tue, Oct 07, 2008 at 11:04:32AM +1100, Barry Naujok wrote:
> >>> I seem to have traced this down to xfs_bmap_add_attrfork not calling
> >>> xfs_trans_ihold after calling xfs_trans_ijoin like other similar functions.
> >>> BUT, it does call IHOLD(ip).
> >> The difference between the two is kinda subtle. IHOLD() increments
> >> the reference count to ensure the transaction commit doesn't drop
> >> the last reference to the inode when it unlocks it and hence
> >> cause us to enter reclaim in the commit code.
> >>
> >> OTOH, xfs_trans_ihold() holds the inode across the transaction
> >> commit so that it is still locked when xfs_trans_commit() completes.
> >> This is needed for rolling transactions to be able to continue
> >> across duplication and commit without needing to relock inodes.
> >>
> > Oh okay.
> > Want a reference held in both cases, but don't always want it locked
> > after commit.
> > One way, we take an extra reference and then drop it at commit,
> > the other we just don't drop the reference at commit.
> 
> This sounds like a very implicit way of doing things IMHO
> (i.e. not clear from the hold that it is about a reference
> being dropped at commit time).
> It almost seems like a different kind of trans-ihold flag
> would have made things clearer (one for unlock, one for rele).

Go look in fs/xfs/xfs_vnodeops.c - every IHOLD is called during a
transaction there is a different reason given, but they all boil
down to one thing - ensuring the transaction commit doesn't
drop the final reference on the inode. e.g. in xfs_link():

2141         /*
2142          * Increment vnode ref counts since xfs_trans_commit &
2143          * xfs_trans_cancel will both unlock the inodes and
2144          * decrement the associated ref counts.
2145          */
2146         IHOLD(sip);
2147         IHOLD(tdp);
2148         xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
2149         xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
