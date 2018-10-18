Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38053 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbeJRKA2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 06:00:28 -0400
Received: by mail-ot1-f67.google.com with SMTP id l1so28235953otj.5
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 19:01:55 -0700 (PDT)
MIME-Version: 1.0
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
 <20181011103636.GC9467@quack2.suse.cz> <CAPcyv4iAD_wkjY1way1rOxr4=gC_TGx71VquF13ooAuUPz9RJw@mail.gmail.com>
 <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net> <20181012082154.GB30154@lst.de>
 <CAOxpaSWf=6RBTa3WM=Hnbr7MwpQ5mMSMAZ+B5FfZo3zKv4Nu7w@mail.gmail.com>
 <116ef687-f23d-b45c-1b48-fd444b346719@sandeen.net> <x491s8ofeg2.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iOH4o_1mBh2a1jEqJZGxwki2FHqp8UM0Cj-ZCzHoxQWQ@mail.gmail.com> <20181018010500.GD6311@dastard>
In-Reply-To: <20181018010500.GD6311@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Oct 2018 19:01:43 -0700
Message-ID: <CAPcyv4gSAsDg0uQkZwAWn-pASmxH0LKwx6MwQuWs-YKwnS1eRA@mail.gmail.com>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported devices
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david <david@fromorbit.com>
Cc: jmoyer <jmoyer@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, zwisler@kernel.org, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Oct 17, 2018 at 6:05 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Oct 17, 2018 at 02:44:55PM -0700, Dan Williams wrote:
> > On Wed, Oct 17, 2018 at 2:31 PM Jeff Moyer <jmoyer@redhat.com> wrote:
> > >
> > > Eric Sandeen <sandeen@sandeen.net> writes:
> > >
> > > > I've been thinking about the per-inode stuff a bit, and while I don't know
> > > > how to resolve some of the trickier issues, at least the expected behavior
> > > > seems like something we can narrow down and specify.
> > > >
> > > > Because it's an on-disk flag (in xfs today, in any case) it seems that
> > > > the only sane behavior to expect is either/or, i.e.:
> > > >
> > > > Mount option: All files always dax, per-inode flags ignored (or rejected)
> > > > Per-inode: Mount option cannot be specified; only inodes explicitly flagged are dax
> > > >
> > > > Think about it; what would mount-option-plus-per-inode mean?  We have
> > > > no "negative" dax flag, so while mount-option-with-flag surely means
> > > > "dax", what the heck does mount-option-without-flag mean, and how is it
> > > > distinguishable from mount option only?
> > > >
> > > > I submit that flags can only have meaning w/o the fs-wide mount option
> > > > enabled, so the question of "should we hard fail mount -o dax for devices
> > > > that cannot support it" seems to be orthogonal to the per-inode question.
> > > >
> > > > i.e. mount -o dax really can only mean "I want dax on everything" and so
> > > > again, I think we probably need to fail the mount if that can't be honored.
> > >
> > > I hate to even open up this can of worms, but what about killing the dax
> > > mount option?
> > >
> > > To quote Christoph:
> > >   How does an application "make use of DAX"?  What actual user visible
> > >   semantics are associated with a file that has this flag set?
> > >
> > > We're already talking about making caching decisions automatically, so
> > > does DAX even mean anything at that point?  If the storage and the file
> > > system support it, enable it.
> > >
> > > From what we've seen so far, aplications want:
> > > 1) to be able to make data persistent from userspace
> > >    For this, we have MAP_SYNC.
> > > 2) to determine whether or not page cache will be used
> > >    For this, we have O_DIRECT for read/write access, and MAP_SYNC for
> > >    mmap access (and maybe a third option coming, we'll see).
> >
> > As Jan has said, it's not safe to assume that 'no page cache' is
> > implied with MAP_SYNC. It's a side effect not a contract of the
> > current implementation.
>
> Even MAP_DIRECT shouldn't mean "no page cache". O_DIRECT is a hint,
> not a guarantee, and so it may very well use the page cache if it
> needs to (as I've just explained in detail in a different thread).
>
> > > The only thing users gain from a mount option is the ability to turn OFF
> > > dax.  I suppose there might be a use case that wants this, but I'm not
> > > aware of it.
> >
> > I think we're stuck with it as many scripts would break if it ever
> > went completely away. However, we could mark it deprecated / ignored
>
> I don't really care that much about this - it is still marked
> experimental.
>
> That said, deprecation is the best way forward here if we are going
> to remove the mount option. We've done this for other XFS mount
> options recently (e.g. barrier/nobarrier) where the functionality is
> now fully baked into the fileystem and there's no user option to
> control it anymore.
>
> What we really need is a document describing the expected behaviour
> of filesysetms on dax-capable storage. Let's nail down exactly what
> we need to do to pull DAX out of the experimental state before we
> start changing things. We've been doing things in a very ad-hoc way
> for a while now, and we're not really converging on an endpoint where we
> can say "we're done, have at it".
>
> I think we need to decide on:
>
> - default filesystem behaviour on dax-capable block devices
> - what information aout DAX do applications actually need? What
>   makes sense to provide them with that information?
> - how to provide hints to the kernel for desired behaviour
>   - on-disk inode flags, or something else?
>   - dax/nodax mount options or root dir inode flags become default
>     global hints?
>   - is a single hint flag sufficient or do we also need an
>     explicit "do not use dax" flag?
> - behaviour of MAP_SYNC w.r.t. non-DAX filesystems that can provide
>   required MAP_SYNC semnatics
> - behaviour of MAP_DIRECT - hint like O_DIRECT or guarantee?
> - default read/write path behaviour of dax-capable block devices
>   - automatically bypass the pagecache if bdev is capable?
> - default mmap behaviour on dax capable devices
>   - use dax always?
> - DAX vs get_user_pages_longterm
>   - turns off DAX dynamically?
>   - how do DAX-enabled filesystems interact with page fault capable
>     hardware? Can we allow DAX in those cases?
>
> I'm sure there's a heap more we need to document and nail down.
> There's a lot of stuff to sort out before we start hammering on
> random bits of code....

Nice, yes, I'll add some more:

- Is MADV_DIRECT_ACCESS a hint or a requirement?
- How does the kernel communicate the effective mode of a mapping
  taking into account madvise(), inode flags, mount options, and / or
  default fs behavior? New madvice() syscall?
- What is the behavior of dax in the presence of reflink'd extents?
  Just failing seems the 'experimental' behavior. What to do about
  page->index when page belongs to more than 1 file via reflink?
- Is there ever a case to force disable dax operation? To date we've
  only ever thought about interfaces to force *enable* dax operation
- The virtio-pmem use case wants dax mappings but requires an explicit
  fsync() instead of MAP_SYNC to flush software buffers, it's a DAX
  sub-set, should it have it's own name?
- DAX operation is loosely tied to block devices. There has been
  discussions of mounting filesystems on /dev/dax devices directly.
  Should we take that to its logical conclusion and support a
  block-layer-less conversion of dax-capable file systems?
- Willy has proposed that the Xarray cache file-offset-to-physical
  address lookups, currently it only tracks dirty mapping state
- The NVDIMM sub-system tracks badblocks, but the filesytem currently
  only finds out about them late when it attempts dax_direct_access().
  Applications want to be able to list files+offsets that have
  experienced media corruption.

> > provided we had a way for applications to query and override if DAX is
> > enabled. I also think it's important to keep separate the dax-mmap
> > behavior from the dax-read/write behavior. dax-mmap is where an
> > application would make different decisions if it can get a mapping
> > without page cache,
>
> The functionality people keep saying "requires DAX" really doesn't -
> what it really requires is that mmap() exposes filesystem tracked
> pmem in a CPU addressable memory range. DAX is not the only way to
> do that - a filesystem with a pmem-based persistent page cache can
> provide MAP_SYNC semantics to userspace without being a DAX
> filesystem.

*nod*
