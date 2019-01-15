Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30743 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728858AbfAOXSy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 18:18:54 -0500
Date: Wed, 16 Jan 2019 10:18:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: iomap_dio_rw() accesses freed memory
Message-ID: <20190115231851.GN4205@dastard>
References: <2762504.H5M01fycxG@localhost.localdomain>
 <20190110142552.GA9661@lst.de>
 <1829543.H1xe2kokQy@localhost.localdomain>
 <20190110170935.GY12689@magnolia>
 <20190115182745.GA12295@lst.de>
 <20190115205141.GL4205@dastard>
 <20190115210903.GA15737@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115210903.GA15737@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Chandan Rajendra <chandan@linux.ibm.com>, linux-xfs@vger.kernel.org

On Tue, Jan 15, 2019 at 10:09:03PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 16, 2019 at 07:51:41AM +1100, Dave Chinner wrote:
> > Atomic operations don't imply a memory barrier for dependent data,
> > right?
> 
> Documentation/atomic_t.txt says:
> 
> -------------------------- snip --------------------------
> The rule of thumb:
> 
>  - non-RMW operations are unordered;
> 
>  - RMW operations that have no return value are unordered;
> 
>  - RMW operations that have a return value are fully ordered;
> 
> [...]
> 
> Fully ordered primitives are ordered against everything prior and everything
> subsequent. Therefore a fully ordered primitive is like having an smp_mb()
> before and an smp_mb() after the primitive.

I guess I haven't looked at the documentation for a while. Or the
implementation for that matter.

/me goes off and looks.

Oh, they are now implemented with built in, explicit
smp_mb__before_atomic() and smp_mb__after_atomic() barriers. Ok,
so the necessary barriers are there, my brain was telling me they
still needed to be added manually and needed updating.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
