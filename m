Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48810 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727011AbfGLMAF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 08:00:05 -0400
Date: Fri, 12 Jul 2019 14:00:04 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
Message-ID: <20190712120004.GB24009@quack2.suse.cz>
References: <20190711140012.1671-1-jack@suse.cz>
 <20190711140012.1671-4-jack@suse.cz>
 <CAOQ4uxh-xpwgF-wQf1ozaZ3yg8nWuBvSyLr_ZFQpkA=coW1dxA@mail.gmail.com>
 <20190711154917.GW1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711154917.GW1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-xfs <linux-xfs@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, stable <stable@vger.kernel.org>

On Thu 11-07-19 08:49:17, Darrick J. Wong wrote:
> On Thu, Jul 11, 2019 at 06:28:54PM +0300, Amir Goldstein wrote:
> > > +{
> > > +       struct xfs_inode *ip = XFS_I(file_inode(file));
> > > +       int ret;
> > > +
> > > +       /* Readahead needs protection from hole punching and similar ops */
> > > +       if (advice == POSIX_FADV_WILLNEED)
> > > +               xfs_ilock(ip, XFS_IOLOCK_SHARED);
> 
> It's good to fix this race, but at the same time I wonder what's the
> impact to processes writing to one part of a file waiting on IOLOCK_EXCL
> while readahead holds IOLOCK_SHARED?
> 
> (bluh bluh range locks ftw bluh bluh)

Yeah, with range locks this would have less impact. Also note that we hold
the lock only during page setup and IO submission. IO itself will already
happen without IOLOCK, only under page lock. But that's enough to stop the
race.

> Do we need a lock for DONTNEED?  I think the answer is that you have to
> lock the page to drop it and that will protect us from <myriad punch and
> truncate spaghetti> ... ?

Yeah, DONTNEED is just page writeback + invalidate. So page lock is enough
to protect from anything bad. Essentially we need IOLOCK only to protect
the places that creates new pages in page cache.

> > > +       ret = generic_fadvise(file, start, end, advice);
> > > +       if (advice == POSIX_FADV_WILLNEED)
> > > +               xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> 
> Maybe it'd be better to do:
> 
> 	int	lockflags = 0;
> 
> 	if (advice == POSIX_FADV_WILLNEED) {
> 		lockflags = XFS_IOLOCK_SHARED;
> 		xfs_ilock(ip, lockflags);
> 	}
> 
> 	ret = generic_fadvise(file, start, end, advice);
> 
> 	if (lockflags)
> 		xfs_iunlock(ip, lockflags);
> 
> Just in case we some day want more or different types of inode locks?

OK, will do. Just I'll get to testing this only after I return from
vacation.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
