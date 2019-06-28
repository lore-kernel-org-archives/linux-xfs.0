Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58020 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF1RGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 13:06:31 -0400
Date: Fri, 28 Jun 2019 10:05:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/13] xfs: allow merging ioends over append boundaries
Message-ID: <20190628170557.GB1404256@magnolia>
References: <20190627104836.25446-1-hch@lst.de>
 <20190627104836.25446-8-hch@lst.de>
 <20190627182309.GP5171@magnolia>
 <20190628055143.GB27187@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628055143.GB27187@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 28, 2019 at 07:51:43AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 27, 2019 at 11:23:09AM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 27, 2019 at 12:48:30PM +0200, Christoph Hellwig wrote:
> > > There is no real problem merging ioends that go beyond i_size into an
> > > ioend that doesn't.  We just need to move the append transaction to the
> > > base ioend.  Also use the opportunity to use a real error code instead
> > > of the magic 1 to cancel the transactions, and write a comment
> > > explaining the scheme.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Reading through this patch, I have a feeling it fixes the crash that
> > Zorro has been seeing occasionally with generic/475...
> 
> So you think for some reason the disk i_size changes underneath and thus
> the xfs_ioend_is_append misfired vs the actual transaction allocations?
> I didn't even think of that, but using the different checks sure sounds
> dangerous.  So yes, we'd either need to backport my patch, or at least
> replace the checks in xfs_ioend_can_merge with direct checks of
> io_append_trans.

That's my working theory, yes.

1. Dirty pages 0 and 2 of an empty file.

2. Writeback gets scheduled for pages 0 and 2, creating ioends A and C.
Both ioends describe writes past the on-disk isize so we allocate
transactions.

3. ioend C completes immediately, sets the ondisk isize to (3 * PAGESIZE).

4. Dirty page 1 of the file and immediately schedule writeback for it,
creating ioend B.  ioend B describes a write within the on-disk isize so
we do not allocate setfilesize transaction.

5. ioend A and B complete and are sorted into the per-inode ioend
completion list.  xfs_ioend_try_merge looks at ioend A, sees that ioend
can be merged with ioend B (same type, same cow status, same current
setfilesize status (which does not reflect the setfilesize status when A
was created)) and therefore decides to merge them.

6. A has a setfilesize transaction so _try_merge calls
xfs_setfilesize_ioend(ioend B, -1) to cancel ioend B's transaction, but
as we saw in (4), ioend B has no transaction and crashes.

--D
