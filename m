Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11109 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbeKMHkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 02:40:21 -0500
Date: Tue, 13 Nov 2018 08:45:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove noinline from #define STATIC
Message-ID: <20181112214515.GN19305@dastard>
References: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
 <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Joe Perches <joe@perches.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, Nov 12, 2018 at 02:12:08PM -0600, Eric Sandeen wrote:
> On 11/10/18 7:21 PM, Joe Perches wrote:
> > Reduce total object size quite a bit (~32KB) and presumably
> > improve performance at the same time.
> > 
> > Total object size old vs new (x86-64 defconfig with xfs)
> > 
> >     text	   data	    bss	    dec	    hex	filename
> > - 959351	 165573	    632	1125556	 112cb4	(TOTALS) (old)
> > + 924683	 165669	    632	1090984	 10a5a8	(TOTALS) (new)
> 
> And what does it do to maximum stack excursions?

Better yet: what does it do to corruption stack traces and debugging
tools like profiling traces?

i.e. this noinline directive isn't about stack usage, this is about
being able to debug production code. Basically the compiler inliner
is so agressive on static functions that it makes it impossible to
decipher the stack traces. It flattens them way too much to
be able to tell how we got to a specific location in the code.

In reality, being able to find problems quickly and efficiently is
far more important to us than being able to run everything at
ludicrous speed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
