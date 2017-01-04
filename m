Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28922 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760823AbdADVYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 16:24:15 -0500
Date: Wed, 4 Jan 2017 13:23:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH, RFC] xfs: use per-AG reservations for the finobt
Message-ID: <20170104212342.GH14031@birch.djwong.org>
References: <1483107598-6779-1-git-send-email-hch@lst.de>
 <20170103192426.GA14031@birch.djwong.org>
 <CAOQ4uxj0wxLq+=RXEo6FxCoEyncduheV0RC4gTfpS-=BLyuULA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj0wxLq+=RXEo6FxCoEyncduheV0RC4gTfpS-=BLyuULA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Wed, Jan 04, 2017 at 12:21:26PM +0200, Amir Goldstein wrote:
> On Tue, Jan 3, 2017 at 9:24 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> ...
> >
> > There's also the unsolved problem of what happens if we mount and find
> > agf_freeblks < (sum(ask) - sum(used)) -- right now we eat that state and
> > hope that we don't later ENOSPC and crash.  For reflink and rmap we will
> > have always had the AG reservation and therefore it should never happen
> > that we have fewer free blocks than reserved blocks.  (Unless the user
> > does something pathological like using CoW to create many billions of
> > separate rmap records...)
> >
> 
> Darrick,
> 
> Can you explain the "Unless the user..." part?
> 
> Is it not possible to actively limit the user from getting to the
> pathologic case?

It's difficult to avoid the pathologic case for CoW operations.  Say we
have a shared extent in AG0, which is full.  A CoW operation finds that
AG0 is full and allocates the new blocks in AG1, but updating the
reference counts might cause AG0's refcount btree to split, which we
can't do because there are no free blocks left in AG0.

> If AG reservation size is a function of the maximum block refcount, then
> an operation that is about to increase the maximum block refcount to a size
> that will increase the worst case reservation beyond a certain percentage
> of the AG (or beyond available space for that matter) should be denied
> by a conservative ENOSPC.

For the refcount btree there's an upper bound on how many refcount
records we'll ever need to store, so we introduced a per-AG block
reservation system to hide blocks from the allocators unless the
allocation request has the magic key.  In other words, we permanently
reserve all the blocks we'll ever need for the refcount tree, which
prevents us ever from encountering ENOSPC.  This costs us 0.6% of the
filesystem.

(So, yeah, XFS does what you outlined, though somewhat differently.)

However, it's the rmap btree that's the problem.  Any inode can reflink
the same block to all possible file block offsets, which (roughly) means
that (theoretically) we could need to store 2^63 * 2^51 * 2^31 = 2^145
records.  That exceeds the size of any AG, so we can't just hide some
blocks and expect that everything will be all right.

In theory we could, for each CoW reservation, calculate the worst case
per-AG btree block requirements for each AG in write_begin/page_mkwrite,
fail with ENOSPC if there's not enough space, and track the reservation
all the way to the conclusion in CoW remap.  That's problematic if we
keep CoW reservations around long term, which we do to reduce
fragmentation -- rarely do we actually /need/ the worst case.

Maybe we'll end up doing something like that some day, but for now the
focus is on reducing fragmentation and preventing clones on really full
AGs (see below) to try to keep the rmap size sane.  By default we
reserve enough space that each AG block can have its own rmap record.

> I imagine it would be much easier and also understandable from user
> POV to get a preventative ENOSPC for over cloning, then to get it
> some time in the far future for trying to delete or deduplicate blocks.

XFS sends the user a preemptive ENOSPC in response to a reflink request
when the per-AG reservation dips below 10% or the maximum number of
blocks needed for a full btree split in the hopes that the copy
operation will fall back to regular copy.  We also established a default
CoW extent allocation size hint of 32 blocks to reduce fragmentation,
which should reduce the pressure somewhat.

(So, yes.)

Keep in mind that reflink and rmap will be experimental for a while, so
we can tweak the reservations and/or re-engineer deficient parts.  The
upcoming xfs_spaceman will make it easier to monitor which AGs are
getting low on space while the fs is mounted.

--D

> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
