Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45336 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfD0VrI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Apr 2019 17:47:08 -0400
MIME-Version: 1.0
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz> <20190128212642.GQ4205@dastard>
 <20190131211351.GB26359@bombadil.infradead.org> <CAOQ4uxhf+mscvqt9VkpRDpwNJ6-gr_uQm2EMrGFGBDBZkkDbOg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhf+mscvqt9VkpRDpwNJ6-gr_uQm2EMrGFGBDBZkkDbOg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 27 Apr 2019 17:46:55 -0400
Message-ID: <CAOQ4uxgq3iR+w=qTrbA6Pqney4NjJP7fAQpWVBSbrZYS+iC4cg@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Feb 1, 2019 at 9:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jan 31, 2019 at 11:13 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, Jan 29, 2019 at 08:26:43AM +1100, Dave Chinner wrote:
> > > Really, though, for this use case it's make more sense to have "per
> > > file freeze" semantics. i.e. if you want a consistent backup image
> > > on snapshot capable storage, the process is usually "freeze
> > > filesystem, snapshot fs, unfreeze fs, do backup from snapshot,
> > > remove snapshot". We can already transparently block incoming
> > > writes/modifications on files via the freeze mechanism, so why not
> > > just extend that to per-file granularity so writes to the "very
> > > large read-mostly file" block while it's being backed up....
> > >
> > > Indeed, this would probably only require a simple extension to
> > > FIFREEZE/FITHAW - the parameter is currently ignored, but as defined
> > > by XFS it was a "freeze level". Set this to 0xffffffff and then it
> > > freezes just the fd passed in, not the whole filesystem.
> > > Alternatively, FI_FREEZE_FILE/FI_THAW_FILE is simple to define...
> >
> > This sounds like you want a lease (aka oplock), which we already have
> > implemented.
>
> Yes, its possibly true.
> I think that it could make sense to skip the reflink optimization for files that
> are open for write in our workloads. I'll need to check with my peers.
>

Getting back to this.
Since the topic got a slot in the LSF agenda, here are my talking points.

First of all, I would like to rewrite the subject. "lazy clone" was a specific
use case I had and the discussion mostly revolved around the viability
of this use case, but I have other use cases.

The core topic perhaps would be better described as "file pre-modification
callback".
We already have several of those: fsnotify, leases/oplocks, but they are
inadequate for some use cases, namely when the file is already open for
write and have writable maps.

One use case I have is taking a VFS level snapshot when there are open
files with writable maps.
Another similar use case is filesystem change journal, which I presented
last year: https://lwn.net/Articles/755277/

Another use case presented by Miklos is cache coherency between
guest and host in virtio-fs.

I envision something like fsnotify pre modification one shot permission
event that is emitted only once when inode data is dirtied after flushing
file's dirty data.
Depending on the use case, it may need to be combined with a file
freeze/thaw API or simply emit the event immediately after flushing
dirty data if inode is dirty.

For the cache coherency use case, that would mean that client
(i.e. guest) is valid for as long as host inode remains non-dirty.
Not sure if this is sufficient to meet virtio-fs requirements, but
I think this is pretty much similar to the way that networking
filesystems client-server cache coherency works, but with finer
granularity (break oplock/lease on dirtying instead of on open).

I would like to discuss possible ways to implement this API
and hear other people's concerns and other possible use cases.

Thanks,
Amir.
