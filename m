Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:8774 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728448AbfA1V0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 16:26:47 -0500
Date: Tue, 29 Jan 2019 08:26:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Message-ID: <20190128212642.GQ4205@dastard>
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128125044.GC27972@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

On Mon, Jan 28, 2019 at 01:50:44PM +0100, Jan Kara wrote:
> Hi,
> 
> On Fri 25-01-19 16:27:52, Amir Goldstein wrote:
> > I would like to discuss the concept of lazy file reflink.
> > The use case is backup of a very large read-mostly file.
> > Backup application would like to read consistent content from the
> > file, "atomic read" sort of speak.
> > 
> > With filesystem that supports reflink, that can be done by:
> > - Create O_TMPFILE
> > - Reflink origin to temp file
> > - Backup from temp file
> >
> > However, since the origin file is very likely not to be modified,
> > the reflink step, that may incur lots of metadata updates, is a waste.
> > Instead, if filesystem could be notified that atomic content was
> > requested (O_ATOMIC|O_RDONLY or O_CLONE|O_RDONLY),
> > filesystem could defer reflink to an O_TMPFILE until origin file is
> > open for write or actually modified.

That makes me want to run screaming for the hills.

> > What I just described above is actually already implemented with
> > Overlayfs snapshots [1], but for many applications overlayfs snapshots
> > it is not a practical solution.
> > 
> > I have based my assumption that reflink of a large file may incur
> > lots of metadata updates on my limited knowledge of xfs reflink
> > implementation, but perhaps it is not the case for other filesystems?

Comparitively speaking: compared to copying a large file, reflink is
cheap on any filesystem that implements it. Sure, reflinking on XFS
is CPU limited, IIRC, to ~10-20,000 extents per second per reflink
op per AG, but it's still faster than copying 10-20,000 extents
per second per copy op on all but the very fastest, unloaded nvme
SSDs...

> > (btrfs?) and perhaps the current metadata overhead on reflink of a large
> > file is an implementation detail that could be optimized in the future?
> > 
> > The point of the matter is that there is no API to make an explicit
> > request for a "volatile reflink" that does not need to survive power
> > failure and that limits the ability of filesytems to optimize this case.
> 
> Well, to me this seems like a relatively rare usecase (and performance
> gain) for the complexity. Also the speed of reflink is fs dependent - e.g.
> for btrfs it is rather cheap AFAIK.

I suspect for "very large read-mostly file" it's still an expensive
operation on btrfs.

Really, though, for this use case it's make more sense to have "per
file freeze" semantics. i.e. if you want a consistent backup image
on snapshot capable storage, the process is usually "freeze
filesystem, snapshot fs, unfreeze fs, do backup from snapshot,
remove snapshot". We can already transparently block incoming
writes/modifications on files via the freeze mechanism, so why not
just extend that to per-file granularity so writes to the "very
large read-mostly file" block while it's being backed up....

Indeed, this would probably only require a simple extension to
FIFREEZE/FITHAW - the parameter is currently ignored, but as defined
by XFS it was a "freeze level". Set this to 0xffffffff and then it
freezes just the fd passed in, not the whole filesystem.
Alternatively, FI_FREEZE_FILE/FI_THAW_FILE is simple to define...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
