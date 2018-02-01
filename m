Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:55536 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751710AbeBAXyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 18:54:55 -0500
Date: Fri, 2 Feb 2018 10:55:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: byte range buffer dirty region tracking
Message-ID: <20180201235548.7hmuu6ws5cxouzee@destitution>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180201051128.GO4849@magnolia>
 <20180201081452.gaavuhnxafoafunm@destitution>
 <20180201203526.GR4849@magnolia>
 <20180201231647.qsiq6vnmllqc32le@destitution>
 <20180201232258.GW4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201232258.GW4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 03:22:58PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 02, 2018 at 10:16:47AM +1100, Dave Chinner wrote:
> > On Thu, Feb 01, 2018 at 12:35:26PM -0800, Darrick J. Wong wrote:
> > > FWIW I also ran straight into this when I applied it for giggles and ran
> > > xfstests -g quick (generic/001 blew up):
> > 
> > I must have screwed up the forward port worse than usual - the
> > conflicts with the xfs_buf_log_item typedef removal were pretty
> > extensive.
> 
> Ah, sorry about that.  I'd thought it was just the xfs_buf rename. :/

Not your fault at all, Darrick!

I only complained about the xfs_buf typedef because it would cause
merge problems for ~80% of the patches in my current dev tree. This
was the only patch that the xfs_buf_log_item typedef removal
affected - more were affected by the trivial b_fspriv to b_log_item
changeover - and I figured that pain was worth it to get rid of
another typedef....

> > > [   31.909228] ================================================================================
> > > [   31.911258] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
> > > [   31.912375] IP: xfs_buf_item_init+0x33/0x350 [xfs]
> > 
> > Hmmmm - I'm seeing that on my subvol smoke test script but not
> > elsewhere. I've been looking through the subvol code to try to find
> > this, maybe it's not the subvol code.  What mkfs parameters where
> > you using?
> 
> mkfs.xfs -m rmapbt=1,reflink=1 -i sparse=1 /dev/pmem0

OK, nothing unusual, though I haven't been using sparse=1 recently.
I'll get onto it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
