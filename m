Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 12:47:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5IJkvdw002574
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 12:47:16 -0700
Date: Mon, 18 Jun 2007 11:47:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Multi-File Data Streams V2
Message-ID: <20070618014731.GV86004887@sgi.com>
References: <20070613041629.GI86004887@sgi.com> <20070616203851.GA7817@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070616203851.GA7817@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jun 16, 2007 at 09:38:51PM +0100, Christoph Hellwig wrote:
> Thanks, this version looks a lot better now.
> 
> The pip checks in xfs_inode.c are still in, but I'm pretty sure they're
> not nessecary, and even if they were nessecary they'd need a good comment
> explaining why.

Because quota inodes don't have a parent and doing filestreams stuff
on quota inodes causes all sorts on problems.

I forgot to split that patch out like you asked last time. Will
now be patch 2, because without this fix we get extra references on
the quota inodes that never get removed and hence busy inodes
after unmount problems....

> The patch still hooks into xfs_close despite your comment that you
> updated it for the removal of it.

<sigh>

That's because it is moved in the xfs_close removal patch later in
my series.  I'll move it.

> I still strongly believe the mru cache should not be inside xfs.  It's
> a completely generic library function and should go into lib/ so it's
> available to all of the kernel.  That means it'll need some codingstyle
> updates and proper kerneldoc comments, though.

And like I said last time: I don't disagree with you.

However: I'm not going to hold back the filestreams code for this.
Doing janitorial work like this is a complete and utter waste of
my time and it does nothing to improve the code right now. I'll
happily accept patches that move this code to lib/ if someone goes
and does it before I find the cycles to be able to do it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
