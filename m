Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20366 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbfA2ASc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 19:18:32 -0500
Date: Tue, 29 Jan 2019 11:18:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Message-ID: <20190129001826.GV4205@dastard>
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz>
 <20190128212642.GQ4205@dastard>
 <CAOQ4uxgUDoSc_nVrLM1An_tH_0NMVonA8npJLBbi0ibD+mwnMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgUDoSc_nVrLM1An_tH_0NMVonA8npJLBbi0ibD+mwnMw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

On Tue, Jan 29, 2019 at 12:56:17AM +0200, Amir Goldstein wrote:
> > > > What I just described above is actually already implemented with
> > > > Overlayfs snapshots [1], but for many applications overlayfs snapshots
> > > > it is not a practical solution.
> > > >
> > > > I have based my assumption that reflink of a large file may incur
> > > > lots of metadata updates on my limited knowledge of xfs reflink
> > > > implementation, but perhaps it is not the case for other filesystems?
> >
> > Comparitively speaking: compared to copying a large file, reflink is
> > cheap on any filesystem that implements it. Sure, reflinking on XFS
> > is CPU limited, IIRC, to ~10-20,000 extents per second per reflink
> > op per AG, but it's still faster than copying 10-20,000 extents
> > per second per copy op on all but the very fastest, unloaded nvme
> > SSDs...
> >
> 
> I think the concern is the added metadata load on the rest of the
> users. Backup app doesn't care about the time it consumes to clone
> before backup. But this concern is not based on actual numbers.

So what is it based on?

> > Really, though, for this use case it's make more sense to have "per
> > file freeze" semantics. i.e. if you want a consistent backup image
> > on snapshot capable storage, the process is usually "freeze
> > filesystem, snapshot fs, unfreeze fs, do backup from snapshot,
> > remove snapshot". We can already transparently block incoming
> > writes/modifications on files via the freeze mechanism, so why not
> > just extend that to per-file granularity so writes to the "very
> > large read-mostly file" block while it's being backed up....
> >
> > Indeed, this would probably only require a simple extension to
> > FIFREEZE/FITHAW - the parameter is currently ignored, but as defined
> > by XFS it was a "freeze level". Set this to 0xffffffff and then it
> > freezes just the fd passed in, not the whole filesystem.
> > Alternatively, FI_FREEZE_FILE/FI_THAW_FILE is simple to define...
> >
> 
> I think it's a good idea to add file freeze semantics to the toolbox
> of useful things that could be accomplished with reflink.

reflink is already atomic w.r.t. other writes - in what way does a
"file freeze" have any impact on a reflink operation? that is, apart
from preventing it from being done, because reflink can modify the
source inode on XFS, too....

> Especially with your plans for subvolumes as files
> How is that coming along by the way?.

If I didn't have to spend so much time fire-fighting broken stuff,
I might make more progress.

> Anyway, freeze semantics alone won't work for our backup application
> that needs to be non intrusive. Even if writes to large file are few,
> backup may take time, so blocking those few write for that long is
> not acceptable.

So, reflink is too expensive because there are only occasional
writes, but blocking that occasional write is too expensive, too,
even though it is rare?

> Blocking the writes for the setup time of a reflink
> is exactly what I was proposing and in your analogy,

No, I proposed a way to provide a -point in time snapshot- of a
file that doesn't require reflink or any other special filesystem
support.

> the block
> device is frozen only for a short period of time for setting up the
> snapshot and not for the duration of the backup.

Right, it's frozen for as long as it takes to set up a -point in
time snapshot- that the backup can be taken from. You don't need
that to reflink a file. You need it if you want to do something
other than a reflink....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
