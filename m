Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 21:59:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9J4xlaG024882
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 21:59:49 -0700
Date: Thu, 19 Oct 2006 14:58:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <20061019045851.GZ11034@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com> <20061013014651.GC19345@melbourne.sgi.com> <452F83BD.8050501@ah.jp.nec.com> <20061017020218.GE8394166@melbourne.sgi.com> <20061018023325.GL8394166@melbourne.sgi.com> <20061018090701.GU11034@melbourne.sgi.com> <4536E186.5040301@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4536E186.5040301@ah.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 19, 2006 at 11:23:02AM +0900, Takenori Nagano wrote:
> Hi David,
> 
> I'm testing your three patches.
> I am not seeing any degradation with your patches.

That is good to hear ;)

> But I think the patch that I attach to this mail is necessary.
> Isn't it?

I don't think so - in the lookup code where we find an existing
inode, we don't destroy the inode if XFS_IRECLAIMABLE is set.
Instead we do a log force and repeat the lookup. We only destroy
the inode in xfs_iget_core() if we raced with another thread
reading the inode in off disk after the cache lookup has
failed. In this case, we free the inode we read off disk which,
by definition, cannot be dirty or pinned at this point so we
don't need to wait for anything to be unpinned.

In the case of reclaim, when we flush a dirty inode we already
do a xfs_iunpin_wait() (xfs_finish_reclaim()->xfs_iflush()->wait)
so we should never get to the point of xfs_idestroy with an inode
that is still pinned.

Hence I don't think this is patch is necessary. Did I miss something
that I shouldn't have, Takenori?

FYI, the three patches have survived my testing for almost a day now,
so if they pass your testing I think we have a viable fix. I'll
sned out a set of updated patches later this afternoon.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
