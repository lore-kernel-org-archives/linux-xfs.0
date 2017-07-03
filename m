Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:40163 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750861AbdGCW63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2017 18:58:29 -0400
Date: Tue, 4 Jul 2017 08:58:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170703225825.GD17762@dastard>
References: <20170629135420.21357-1-hch@lst.de>
 <20170629135420.21357-6-hch@lst.de>
 <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
 <20170630173740.GB11420@lst.de>
 <CAHc6FU4rK3cg+nYeOSSJirKoYiuApV9KauqE_iar+7Q7X6g20A@mail.gmail.com>
 <20170703162145.GZ5874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170703162145.GZ5874@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Mon, Jul 03, 2017 at 09:21:45AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 03, 2017 at 05:03:54PM +0200, Andreas Gruenbacher wrote:
> > On Fri, Jun 30, 2017 at 7:37 PM, Christoph Hellwig <hch@lst.de> wrote:
> > > On Fri, Jun 30, 2017 at 01:51:10PM +0200, Andreas Gruenbacher wrote:
> > >> Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
> > >> to be added back for consistency between reading i_size and walking
> > >> the file extents.
> > >
> > > At least for XFS we never had such a consistency as we never took
> > > the iolock (aka i_rwsem).
> > 
> > What else does this piece of code from mainline xfs_seek_hole_data()
> > do instead then?
> > 
> >         lock = xfs_ilock_data_map_shared(ip);
> 
> To avoid confusion, I'll start with ilock != iolock.
> 
> If I'm reading everything correctly, there are three levels of inode
> locks that must be taken in XFS: First, the IOLOCK (aka i_rwsem) to
> protect against concurrent IO when we need it, then the MMAPLOCK (istr
> this was created to handle dax page faults, which don't take i_rwsem?),
> and finally the ILOCK for inode core/extent map updates.  I think page
> locks are supposed to happen before ILOCK.

IOLOCK and MMAPLOCK are equivalent - there are two locks because we
can't take the IOLOCK in page fault context because page faults can
occur while we are holding the IOLOCK.

Locking order for IO path is:

IOLOCK -> page lock -> ILOCK

Locking order for page faults is:

mmap_sem -> MMAPLOCK -> page lock -> ILOCK

> xfs_ilock_data_map_shared() is a helper that takes the ILOCK in shared
> or exclusive mode depending on whether or not all the inode metadata
> have already been cached in memory.
> 
> The ILOCK must be held before reading or writing the extent map.

More simply:

	- IOLOCK/MMAPLOCK is for access control to file data
	- ILOCK is for access control to inode metadata

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
