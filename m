Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbeKQXtu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 17 Nov 2018 18:49:50 -0500
Date: Sat, 17 Nov 2018 08:33:06 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix shared extent data corruption due to missing
 cow reservation
Message-ID: <20181117133305.GA36660@bfoster>
References: <20181113170819.15220-1-bfoster@redhat.com>
 <20181115055020.GS4235@magnolia>
 <20181116043507.GB19305@dastard>
 <20181116133222.GB31603@bfoster>
 <20181116211936.GG19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116211936.GG19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Sat, Nov 17, 2018 at 08:19:36AM +1100, Dave Chinner wrote:
> On Fri, Nov 16, 2018 at 08:32:23AM -0500, Brian Foster wrote:
> > On Fri, Nov 16, 2018 at 03:35:08PM +1100, Dave Chinner wrote:
> > > On Wed, Nov 14, 2018 at 09:50:20PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Nov 13, 2018 at 12:08:19PM -0500, Brian Foster wrote:
> > > > > Page writeback indirectly handles shared extents via the existence
> > > > > of overlapping COW fork blocks. If COW fork blocks exist, writeback
> > > > > always performs the associated copy-on-write regardless if the
> > > > > underlying blocks are actually shared. If the blocks are shared,
> > > > > then overlapping COW fork blocks must always exist.
> > > > > 
> > > > > fstests shared/010 reproduces a case where a buffered write occurs
> > > > > over a shared block without performing the requisite COW fork
> > > > > reservation.  This ultimately causes writeback to the shared extent
> > > > > and data corruption that is detected across md5 checks of the
> > > > > filesystem across a mount cycle.
> > > > > 
> > > > > The problem occurs when a buffered write lands over a shared extent
> > > > > that crosses an extent size hint boundary and that also happens to
> > > > > have a partial COW reservation that doesn't cover the start and end
> > > > > blocks of the data fork extent.
> > > > > 
> > > > > For example, a buffered write occurs across the file offset (in FSB
> > > > > units) range of [29, 57]. A shared extent exists at blocks [29, 35]
> > > > > and COW reservation already exists at blocks [32, 34]. After
> > > > > accommodating a COW extent size hint of 32 blocks and the existing
> > > > > reservation at offset 32, xfs_reflink_reserve_cow() allocates 32
> > > > > blocks of reservation at offset 0 and returns with COW reservation
> > > > > across the range of [0, 34]. The associated data fork extent is
> > > > > still [29, 35], however, which isn't fully covered by the COW
> > > > > reservation.
> > > > > 
> > > > > This leads to a buffered write at file offset 35 over a shared
> > > > > extent without associated COW reservation. Writeback eventually
> > > > > kicks in, performs an overwrite of the underlying shared block and
> > > > > causes the associated data corruption.
> > > > > 
> > > > > Update xfs_reflink_reserve_cow() to accommodate the fact that a
> > > > > delalloc allocation request may not fully cover the extent in the
> > > > > data fork. Trim the data fork extent appropriately, just as is done
> > > > > for shared extent boundaries and/or existing COW reservations that
> > > > > happen to overlap the start of the data fork extent. This prevents
> > > > > shared/010 failures due to data corruption on reflink enabled
> > > > > filesystems.
> > > > > 
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > > 
> > > > > This is not fully tested yet beyond verification that it solves the
> > > > > problem reproduced by shared/010. I'll be running more tests today, but
> > > > > I'm sending sooner for review and testing due to the nature of the
> > > > > problem and the fact that it's a fairly isolated change. I'll follow up
> > > > > if I discover any resulting regressions..
> > > > 
> > > > Did you find any regressions?
> > > > 
> > > > I ran this through my overnight tests and saw no adverse effects, though
> > > > Dave was complaining yesterday about continuing generic/091 corruptions
> > > > (which I didn't see with this patch applied...)
> > > 
> > > I can say now that this patch hasn't caused any new corruptions. It
> > > hasn't fixed any of the (many) corruptions that I'm hitting, either,
> > > so from that perspective it's no better or worse than what we have
> > > now :P
> > 
> > So were you reproducing the shared/010 corruption or no?
> 
> No, I wasn't, because I already had a patch in my tree that fixed
> it, apparently (see followup to Darrick's flush-after-zero on
> reflink patch). Basically, the EOF zeroing+truncation problem is
> something fsx trips over quite quickly on 1k block size filesystems.
> I've had a patch for it in my tree for about a week now.
> 

Ok, that's a different issue. I happened to reproduce both via
shared/010 with the writeback assert rfc patch I posted yesterday. The
patch for this thread addresses a corruption due to failure to properly
perform COW reservation for a buffered write. Darrick's patch addresses
a corruption due to the EOF zeroing associated with dedupe leaving
around a dirty page over a shared block. Note that I reproduced this
latter issue with a page size == block size fs and Darrick (and you) had
apparently reproduced a slightly different problem caused by the same
zeroing code on 1k FSB. Darrick and I just happened to stumble on the
common cause at just about the same time..

Anyways, I'll try to confirm that your patch also resolves the issue I
reproduced (which it looks like it should)..

> So what I meant is that it didn't fix any of the fsx failures I'd
> been seeing, but it also didn't introduce any new fsx failures,
> either, as I was kind of hoping it would....
> 

Ok, I just wanted to make sure this patch doesn't get dropped on the
floor by thinking it's fixed by something else.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
