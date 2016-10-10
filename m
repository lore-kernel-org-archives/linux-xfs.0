Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43203 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752159AbcJJM7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 08:59:43 -0400
Date: Mon, 10 Oct 2016 23:59:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: clear reflink flag if setting realtime flag
Message-ID: <20161010125938.GC23194@dastard>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588168294.12127.1609759616316145097.stgit@birch.djwong.org>
 <20161010102418.GG18359@infradead.org>
 <20161010122507.GA23194@dastard>
 <20161010124500.GA29158@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161010124500.GA29158@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Oct 10, 2016 at 05:45:00AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 10, 2016 at 11:25:08PM +1100, Dave Chinner wrote:
> > On Mon, Oct 10, 2016 at 03:24:18AM -0700, Christoph Hellwig wrote:
> > > On Fri, Oct 07, 2016 at 04:08:03PM -0700, Darrick J. Wong wrote:
> > > > Since we can only turn on the rt flag if there are no data extents,
> > > > we can safely turn off the reflink flag if the rt flag is being
> > > > turned on.
> > > 
> > > Why would the reflink flag ever be turned on if we have no data extents?
> > 
> > After a truncate?
> 
> Any why don't we simply clear the flag when we know there can't be
> any shared extents left?

Sure, go ahead. I'll queue it up for the next cycle....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
