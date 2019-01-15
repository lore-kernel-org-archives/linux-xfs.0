Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55551 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730505AbfAOVJF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jan 2019 16:09:05 -0500
Date: Tue, 15 Jan 2019 22:09:03 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: BUG: iomap_dio_rw() accesses freed memory
Message-ID: <20190115210903.GA15737@lst.de>
References: <2762504.H5M01fycxG@localhost.localdomain> <20190110142552.GA9661@lst.de> <1829543.H1xe2kokQy@localhost.localdomain> <20190110170935.GY12689@magnolia> <20190115182745.GA12295@lst.de> <20190115205141.GL4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115205141.GL4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chandan Rajendra <chandan@linux.ibm.com>, linux-xfs@vger.kernel.org

On Wed, Jan 16, 2019 at 07:51:41AM +1100, Dave Chinner wrote:
> Atomic operations don't imply a memory barrier for dependent data,
> right?

Documentation/atomic_t.txt says:

-------------------------- snip --------------------------
The rule of thumb:

 - non-RMW operations are unordered;

 - RMW operations that have no return value are unordered;

 - RMW operations that have a return value are fully ordered;

[...]

Fully ordered primitives are ordered against everything prior and everything
subsequent. Therefore a fully ordered primitive is like having an smp_mb()
before and an smp_mb() after the primitive.


-------------------------- snip --------------------------

I think atomic_dec_and_test clearly falls into the third category,
and I can't see how much of the kernel could work if that wasn't the
case.
