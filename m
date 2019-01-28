Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f180.google.com ([209.85.219.180]:43217 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfA1W4a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 17:56:30 -0500
MIME-Version: 1.0
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz> <20190128212642.GQ4205@dastard>
In-Reply-To: <20190128212642.GQ4205@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Jan 2019 00:56:17 +0200
Message-ID: <CAOQ4uxgUDoSc_nVrLM1An_tH_0NMVonA8npJLBbi0ibD+mwnMw@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

> > > What I just described above is actually already implemented with
> > > Overlayfs snapshots [1], but for many applications overlayfs snapshots
> > > it is not a practical solution.
> > >
> > > I have based my assumption that reflink of a large file may incur
> > > lots of metadata updates on my limited knowledge of xfs reflink
> > > implementation, but perhaps it is not the case for other filesystems?
>
> Comparitively speaking: compared to copying a large file, reflink is
> cheap on any filesystem that implements it. Sure, reflinking on XFS
> is CPU limited, IIRC, to ~10-20,000 extents per second per reflink
> op per AG, but it's still faster than copying 10-20,000 extents
> per second per copy op on all but the very fastest, unloaded nvme
> SSDs...
>

I think the concern is the added metadata load on the rest of the
users. Backup app doesn't care about the time it consumes to clone
before backup. But this concern is not based on actual numbers.

> Really, though, for this use case it's make more sense to have "per
> file freeze" semantics. i.e. if you want a consistent backup image
> on snapshot capable storage, the process is usually "freeze
> filesystem, snapshot fs, unfreeze fs, do backup from snapshot,
> remove snapshot". We can already transparently block incoming
> writes/modifications on files via the freeze mechanism, so why not
> just extend that to per-file granularity so writes to the "very
> large read-mostly file" block while it's being backed up....
>
> Indeed, this would probably only require a simple extension to
> FIFREEZE/FITHAW - the parameter is currently ignored, but as defined
> by XFS it was a "freeze level". Set this to 0xffffffff and then it
> freezes just the fd passed in, not the whole filesystem.
> Alternatively, FI_FREEZE_FILE/FI_THAW_FILE is simple to define...
>

I think it's a good idea to add file freeze semantics to the toolbox
of useful things that could be accomplished with reflink.
Especially with your plans for subvolumes as files
How is that coming along by the way?.

Anyway, freeze semantics alone won't work for our backup application
that needs to be non intrusive. Even if writes to large file are few,
backup may take time, so blocking those few write for that long is
not acceptable. Blocking the writes for the setup time of a reflink
is exactly what I was proposing and in your analogy, the block
device is frozen only for a short period of time for setting up the
snapshot and not for the duration of the backup.

Thanks,
Amir.
