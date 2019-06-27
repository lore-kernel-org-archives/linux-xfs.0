Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46803 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbfF0WhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 18:37:07 -0400
Date: Fri, 28 Jun 2019 08:35:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/12] iomap: add tracing for the address space operations
Message-ID: <20190627223557.GI7777@dread.disaster.area>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-13-hch@lst.de>
 <20190624234921.GE7777@dread.disaster.area>
 <20190625101515.GL1462@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625101515.GL1462@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 25, 2019 at 12:15:15PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 25, 2019 at 09:49:21AM +1000, Dave Chinner wrote:
> > > +#undef TRACE_SYSTEM
> > > +#define TRACE_SYSTEM iomap
> > 
> > Can you add a comment somewhere here that says these tracepoints are
> > volatile and we reserve the right to change them at any time so they
> > don't form any sort of persistent UAPI that we have to maintain?
> 
> Sure.  Note that we don't have any such comment in xfs either..

Yes, but that is buries inside the xfs code where we largely set our
own rules. This, however, is generic code where people have a habit
of arguing that tracepoints are stable API and they can never be
changed because some random userspace application may have hard
coded a dependency on it...

Hence we need to be explicit here that this is diagnostic/debug code
and anyone who tries to rely on it as a stable API gets to keep all
the broken bits to themselves.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
