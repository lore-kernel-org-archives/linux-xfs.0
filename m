Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:23267 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726706AbeJRJDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 05:03:31 -0400
Date: Thu, 18 Oct 2018 12:05:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported
 devices
Message-ID: <20181018010500.GD6311@dastard>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
 <20181011103636.GC9467@quack2.suse.cz>
 <CAPcyv4iAD_wkjY1way1rOxr4=gC_TGx71VquF13ooAuUPz9RJw@mail.gmail.com>
 <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net>
 <20181012082154.GB30154@lst.de>
 <CAOxpaSWf=6RBTa3WM=Hnbr7MwpQ5mMSMAZ+B5FfZo3zKv4Nu7w@mail.gmail.com>
 <116ef687-f23d-b45c-1b48-fd444b346719@sandeen.net>
 <x491s8ofeg2.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iOH4o_1mBh2a1jEqJZGxwki2FHqp8UM0Cj-ZCzHoxQWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iOH4o_1mBh2a1jEqJZGxwki2FHqp8UM0Cj-ZCzHoxQWQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: jmoyer <jmoyer@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, zwisler@kernel.org, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Oct 17, 2018 at 02:44:55PM -0700, Dan Williams wrote:
> On Wed, Oct 17, 2018 at 2:31 PM Jeff Moyer <jmoyer@redhat.com> wrote:
> >
> > Eric Sandeen <sandeen@sandeen.net> writes:
> >
> > > I've been thinking about the per-inode stuff a bit, and while I don't know
> > > how to resolve some of the trickier issues, at least the expected behavior
> > > seems like something we can narrow down and specify.
> > >
> > > Because it's an on-disk flag (in xfs today, in any case) it seems that
> > > the only sane behavior to expect is either/or, i.e.:
> > >
> > > Mount option: All files always dax, per-inode flags ignored (or rejected)
> > > Per-inode: Mount option cannot be specified; only inodes explicitly flagged are dax
> > >
> > > Think about it; what would mount-option-plus-per-inode mean?  We have
> > > no "negative" dax flag, so while mount-option-with-flag surely means
> > > "dax", what the heck does mount-option-without-flag mean, and how is it
> > > distinguishable from mount option only?
> > >
> > > I submit that flags can only have meaning w/o the fs-wide mount option
> > > enabled, so the question of "should we hard fail mount -o dax for devices
> > > that cannot support it" seems to be orthogonal to the per-inode question.
> > >
> > > i.e. mount -o dax really can only mean "I want dax on everything" and so
> > > again, I think we probably need to fail the mount if that can't be honored.
> >
> > I hate to even open up this can of worms, but what about killing the dax
> > mount option?
> >
> > To quote Christoph:
> >   How does an application "make use of DAX"?  What actual user visible
> >   semantics are associated with a file that has this flag set?
> >
> > We're already talking about making caching decisions automatically, so
> > does DAX even mean anything at that point?  If the storage and the file
> > system support it, enable it.
> >
> > From what we've seen so far, aplications want:
> > 1) to be able to make data persistent from userspace
> >    For this, we have MAP_SYNC.
> > 2) to determine whether or not page cache will be used
> >    For this, we have O_DIRECT for read/write access, and MAP_SYNC for
> >    mmap access (and maybe a third option coming, we'll see).
> 
> As Jan has said, it's not safe to assume that 'no page cache' is
> implied with MAP_SYNC. It's a side effect not a contract of the
> current implementation.

Even MAP_DIRECT shouldn't mean "no page cache". O_DIRECT is a hint,
not a guarantee, and so it may very well use the page cache if it
needs to (as I've just explained in detail in a different thread).

> > The only thing users gain from a mount option is the ability to turn OFF
> > dax.  I suppose there might be a use case that wants this, but I'm not
> > aware of it.
> 
> I think we're stuck with it as many scripts would break if it ever
> went completely away. However, we could mark it deprecated / ignored

I don't really care that much about this - it is still marked
experimental.

That said, deprecation is the best way forward here if we are going
to remove the mount option. We've done this for other XFS mount
options recently (e.g. barrier/nobarrier) where the functionality is
now fully baked into the fileystem and there's no user option to
control it anymore.

What we really need is a document describing the expected behaviour
of filesysetms on dax-capable storage. Let's nail down exactly what
we need to do to pull DAX out of the experimental state before we
start changing things. We've been doing things in a very ad-hoc way
for a while now, and we're not really converging on an endpoint where we
can say "we're done, have at it".

I think we need to decide on:

- default filesystem behaviour on dax-capable block devices
- what information aout DAX do applications actually need? What
  makes sense to provide them with that information?
- how to provide hints to the kernel for desired behaviour
  - on-disk inode flags, or something else?
  - dax/nodax mount options or root dir inode flags become default
    global hints?
  - is a single hint flag sufficient or do we also need an
    explicit "do not use dax" flag?
- behaviour of MAP_SYNC w.r.t. non-DAX filesystems that can provide
  required MAP_SYNC semnatics
- behaviour of MAP_DIRECT - hint like O_DIRECT or guarantee?
- default read/write path behaviour of dax-capable block devices
  - automatically bypass the pagecache if bdev is capable?
- default mmap behaviour on dax capable devices
  - use dax always?
- DAX vs get_user_pages_longterm
  - turns off DAX dynamically?
  - how do DAX-enabled filesystems interact with page fault capable
    hardware? Can we allow DAX in those cases?

I'm sure there's a heap more we need to document and nail down.
There's a lot of stuff to sort out before we start hammering on
random bits of code....

> provided we had a way for applications to query and override if DAX is
> enabled. I also think it's important to keep separate the dax-mmap
> behavior from the dax-read/write behavior. dax-mmap is where an
> application would make different decisions if it can get a mapping
> without page cache,

The functionality people keep saying "requires DAX" really doesn't -
what it really requires is that mmap() exposes filesystem tracked
pmem in a CPU addressable memory range. DAX is not the only way to
do that - a filesystem with a pmem-based persistent page cache can
provide MAP_SYNC semantics to userspace without being a DAX
filesystem.

(see other thread again)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
