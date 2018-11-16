Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbeKPXou (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 18:44:50 -0500
Date: Fri, 16 Nov 2018 08:32:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix shared extent data corruption due to missing
 cow reservation
Message-ID: <20181116133222.GB31603@bfoster>
References: <20181113170819.15220-1-bfoster@redhat.com>
 <20181115055020.GS4235@magnolia>
 <20181116043507.GB19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116043507.GB19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Nov 16, 2018 at 03:35:08PM +1100, Dave Chinner wrote:
> On Wed, Nov 14, 2018 at 09:50:20PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 13, 2018 at 12:08:19PM -0500, Brian Foster wrote:
> > > Page writeback indirectly handles shared extents via the existence
> > > of overlapping COW fork blocks. If COW fork blocks exist, writeback
> > > always performs the associated copy-on-write regardless if the
> > > underlying blocks are actually shared. If the blocks are shared,
> > > then overlapping COW fork blocks must always exist.
> > > 
> > > fstests shared/010 reproduces a case where a buffered write occurs
> > > over a shared block without performing the requisite COW fork
> > > reservation.  This ultimately causes writeback to the shared extent
> > > and data corruption that is detected across md5 checks of the
> > > filesystem across a mount cycle.
> > > 
> > > The problem occurs when a buffered write lands over a shared extent
> > > that crosses an extent size hint boundary and that also happens to
> > > have a partial COW reservation that doesn't cover the start and end
> > > blocks of the data fork extent.
> > > 
> > > For example, a buffered write occurs across the file offset (in FSB
> > > units) range of [29, 57]. A shared extent exists at blocks [29, 35]
> > > and COW reservation already exists at blocks [32, 34]. After
> > > accommodating a COW extent size hint of 32 blocks and the existing
> > > reservation at offset 32, xfs_reflink_reserve_cow() allocates 32
> > > blocks of reservation at offset 0 and returns with COW reservation
> > > across the range of [0, 34]. The associated data fork extent is
> > > still [29, 35], however, which isn't fully covered by the COW
> > > reservation.
> > > 
> > > This leads to a buffered write at file offset 35 over a shared
> > > extent without associated COW reservation. Writeback eventually
> > > kicks in, performs an overwrite of the underlying shared block and
> > > causes the associated data corruption.
> > > 
> > > Update xfs_reflink_reserve_cow() to accommodate the fact that a
> > > delalloc allocation request may not fully cover the extent in the
> > > data fork. Trim the data fork extent appropriately, just as is done
> > > for shared extent boundaries and/or existing COW reservations that
> > > happen to overlap the start of the data fork extent. This prevents
> > > shared/010 failures due to data corruption on reflink enabled
> > > filesystems.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > This is not fully tested yet beyond verification that it solves the
> > > problem reproduced by shared/010. I'll be running more tests today, but
> > > I'm sending sooner for review and testing due to the nature of the
> > > problem and the fact that it's a fairly isolated change. I'll follow up
> > > if I discover any resulting regressions..
> > 
> > Did you find any regressions?
> > 
> > I ran this through my overnight tests and saw no adverse effects, though
> > Dave was complaining yesterday about continuing generic/091 corruptions
> > (which I didn't see with this patch applied...)
> 
> I can say now that this patch hasn't caused any new corruptions. It
> hasn't fixed any of the (many) corruptions that I'm hitting, either,
> so from that perspective it's no better or worse than what we have
> now :P
> 

So were you reproducing the shared/010 corruption or no? I suppose it
would be nice if this fixed some other problems, but it was only
intended to fix the problem Zorro was reproducing with shared/010.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
