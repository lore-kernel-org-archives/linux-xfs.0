Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20781 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdIRWE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 18:04:27 -0400
Date: Mon, 18 Sep 2017 15:04:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
 fs/iomap.c:993
Message-ID: <20170918220412.GB6533@magnolia>
References: <1505746565.6990.18.camel@abdul.in.ibm.com>
 <20170918152706.GA11482@lst.de>
 <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
 <20170918213143.GJ10621@dastard>
 <21c53d3f-5ca9-886d-a326-cb6f1bbddffd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21c53d3f-5ca9-886d-a326-cb6f1bbddffd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On Mon, Sep 18, 2017 at 05:00:58PM -0500, Eric Sandeen wrote:
> On 9/18/17 4:31 PM, Dave Chinner wrote:
> > On Mon, Sep 18, 2017 at 09:28:55AM -0600, Jens Axboe wrote:
> >> On 09/18/2017 09:27 AM, Christoph Hellwig wrote:
> >>> On Mon, Sep 18, 2017 at 08:26:05PM +0530, Abdul Haleem wrote:
> >>>> Hi,
> >>>>
> >>>> A warning is triggered from:
> >>>>
> >>>> file fs/iomap.c in function iomap_dio_rw
> >>>>
> >>>>     if (ret)
> >>>>         goto out_free_dio;
> >>>>
> >>>>     ret = invalidate_inode_pages2_range(mapping,
> >>>>             start >> PAGE_SHIFT, end >> PAGE_SHIFT);
> >>>>>>  WARN_ON_ONCE(ret);
> >>>>     ret = 0;
> >>>>
> >>>>     inode_dio_begin(inode);
> >>>
> >>> This is expected and an indication of a problematic workload - which
> >>> may be triggered by a fuzzer.
> >>
> >> If it's expected, why don't we kill the WARN_ON_ONCE()? I get it all
> >> the time running xfstests as well.
> > 
> > Because when a user reports a data corruption, the only evidence we
> > have that they are running an app that does something stupid is this
> > warning in their syslogs.  Tracepoints are not useful for replacing
> > warnings about data corruption vectors being triggered.
> 
> Is the full WARN_ON spew really helpful to us, though?  Certainly
> the user has no idea what it means, and will come away terrified
> but none the wiser.
> 
> Would a more informative printk_once() still give us the evidence
> without the ZOMG I THINK I OOPSED that a WARN_ON produces?  Or do we 
> want/need the backtrace?

Maybe we could state a little more directly what's going on:

if (err)
	printk_once(KERN_INFO "Urk, collision detected between direct IO and page cache, YHL. HAND.\n"); ?

8-)

--D

> 
> -Eric
> 
> > It needs to be on by default, bu tI'm sure we can wrap it with
> > something like an xfs_alert_tag() type of construct so the tag can
> > be set in /proc/fs/xfs/panic_mask to suppress it if testers so
> > desire.
> > 
> > Cheers,
> > 
> > Dave.
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
