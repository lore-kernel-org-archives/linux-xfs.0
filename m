Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54098 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbeG3R2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 13:28:08 -0400
Date: Mon, 30 Jul 2018 08:52:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: fix cow_seq locking behavior
Message-ID: <20180730155207.GV30972@magnolia>
References: <20180730055539.GT30972@magnolia>
 <20180730081456.GA25004@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730081456.GA25004@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 30, 2018 at 01:14:56AM -0700, Christoph Hellwig wrote:
> On Sun, Jul 29, 2018 at 10:55:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In Christoph Hellwig's patch "xfs: avoid COW fork extent lookups in
> > writeback if the fork didn't change" (which has not yet graduated to
> > for-next), we sample the COW fork sequence number without taking the
> > ilock.  This is a little strange, since in general we always take it
> > before accessing anything in a block mapping.  I think we get lucky in
> > that the unlocking during actual cow fork changes will erect the
> > necessary memory barriers (on x86 anyway) but let's not play fast and
> > loose with breaking everyone else's model of how locking works.
> 
> What exaxtly do you want to protect here?  It's not like we have any
> multiple fields we need to synchronize access to to.

Protecting against us screwing up the locking here some day due to a
subtlety that nobody will remember in 6 months. :)

> And it's not like this is superficials - in addition to not providing
> any actual synchronization this also means we have to take the ilock
> for every page, which reduces a large part of the improvements in the
> series.

Agreed!  I nearly tagged this RFCRAP instead.  Sometimes I send patches
to try to provoke a response... <cough>D :0

Now that I've had a night to think it over (and it's no longer 100F but
the sky is still blood red) I think we ought to have a comment
explaining how the synchronization works such that we don't need to take
the ILOCK before testing cow_seq....

/*
 * COW fork blocks can overlap data fork blocks even if the blocks
 * aren't shared.  COW I/O always takes precedent, so we must always
 * check for overlap on reflink inodes unless the mapping is already a
 * COW one.
 *
 * It's safe to check the COW fork if_seq here without the ILOCK because
 * we've indirectly protected against concurrent updates: writeback has
 * the page locked, which prevents concurrent invalidations by reflink
 * and directio and prevents concurrent buffered writes to the same
 * page.  Concurrent changes to other parts of the COW fork will drop
 * the i_lock on their way out, which provides the necessary memory
 * barrier to ensure that we see the updated if_seq.
 */

I'm not actually sure about the last sentence anymore -- that's what I
was thinking the first time I looked at this patch, before Dave spoke
up.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
