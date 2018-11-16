Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30233 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727124AbeKPOp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 09:45:58 -0500
Date: Fri, 16 Nov 2018 15:35:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix shared extent data corruption due to missing
 cow reservation
Message-ID: <20181116043507.GB19305@dastard>
References: <20181113170819.15220-1-bfoster@redhat.com>
 <20181115055020.GS4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115055020.GS4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Nov 14, 2018 at 09:50:20PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 13, 2018 at 12:08:19PM -0500, Brian Foster wrote:
> > Page writeback indirectly handles shared extents via the existence
> > of overlapping COW fork blocks. If COW fork blocks exist, writeback
> > always performs the associated copy-on-write regardless if the
> > underlying blocks are actually shared. If the blocks are shared,
> > then overlapping COW fork blocks must always exist.
> > 
> > fstests shared/010 reproduces a case where a buffered write occurs
> > over a shared block without performing the requisite COW fork
> > reservation.  This ultimately causes writeback to the shared extent
> > and data corruption that is detected across md5 checks of the
> > filesystem across a mount cycle.
> > 
> > The problem occurs when a buffered write lands over a shared extent
> > that crosses an extent size hint boundary and that also happens to
> > have a partial COW reservation that doesn't cover the start and end
> > blocks of the data fork extent.
> > 
> > For example, a buffered write occurs across the file offset (in FSB
> > units) range of [29, 57]. A shared extent exists at blocks [29, 35]
> > and COW reservation already exists at blocks [32, 34]. After
> > accommodating a COW extent size hint of 32 blocks and the existing
> > reservation at offset 32, xfs_reflink_reserve_cow() allocates 32
> > blocks of reservation at offset 0 and returns with COW reservation
> > across the range of [0, 34]. The associated data fork extent is
> > still [29, 35], however, which isn't fully covered by the COW
> > reservation.
> > 
> > This leads to a buffered write at file offset 35 over a shared
> > extent without associated COW reservation. Writeback eventually
> > kicks in, performs an overwrite of the underlying shared block and
> > causes the associated data corruption.
> > 
> > Update xfs_reflink_reserve_cow() to accommodate the fact that a
> > delalloc allocation request may not fully cover the extent in the
> > data fork. Trim the data fork extent appropriately, just as is done
> > for shared extent boundaries and/or existing COW reservations that
> > happen to overlap the start of the data fork extent. This prevents
> > shared/010 failures due to data corruption on reflink enabled
> > filesystems.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > This is not fully tested yet beyond verification that it solves the
> > problem reproduced by shared/010. I'll be running more tests today, but
> > I'm sending sooner for review and testing due to the nature of the
> > problem and the fact that it's a fairly isolated change. I'll follow up
> > if I discover any resulting regressions..
> 
> Did you find any regressions?
> 
> I ran this through my overnight tests and saw no adverse effects, though
> Dave was complaining yesterday about continuing generic/091 corruptions
> (which I didn't see with this patch applied...)

I can say now that this patch hasn't caused any new corruptions. It
hasn't fixed any of the (many) corruptions that I'm hitting, either,
so from that perspective it's no better or worse than what we have
now :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
