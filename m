Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40540 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfBSDAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 22:00:46 -0500
Date: Mon, 18 Feb 2019 18:55:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH v2 0/9] Block/XFS: Support alternative mirror device
 retry
Message-ID: <20190219025520.GB32253@magnolia>
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190218213150.GE14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218213150.GE14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, hch@infradead.org, adilger@dilger.ca

On Tue, Feb 19, 2019 at 08:31:50AM +1100, Dave Chinner wrote:
> On Wed, Feb 13, 2019 at 05:50:35PM +0800, Bob Liu wrote:
> > Motivation:
> > When fs data/metadata checksum mismatch, lower block devices may have other
> > correct copies. e.g. If XFS successfully reads a metadata buffer off a raid1 but
> > decides that the metadata is garbage, today it will shut down the entire
> > filesystem without trying any of the other mirrors.  This is a severe
> > loss of service, and we propose these patches to have XFS try harder to
> > avoid failure.
> > 
> > This patch prototype this mirror retry idea by:
> > * Adding @nr_mirrors to struct request_queue which is similar as
> >   blk_queue_nonrot(), filesystem can grab device request queue and check max
> >   mirrors this block device has.
> >   Helper functions were also added to get/set the nr_mirrors.
> > 
> > * Introducing bi_rd_hint just like bi_write_hint, but bi_rd_hint is a long bitmap
> > in order to support stacked layer case.
> > 
> > * Modify md/raid1 to support this retry feature.
> > 
> > * Adapter xfs to use this feature.
> >   If the read verify fails, we loop over the available mirrors and retry the read.
> 
> Why does the filesystem have to iterate every single posible
> combination of devices that are underneath it?
> 
> Wouldn't it be much simpler to be able to attach a verifier
> function to the bio, and have each layer that gets called iterate
> over all it's copies internally until the verfier function passes
> or all copies are exhausted?
> 
> This works for stacked mirrors - it can pass the higher layer
> verifier down as far as necessary. It can work for RAID5/6, too, by
> having that layer supply it's own verifier for reads that verifies
> parity and can reconstruct of failure, then when it's reconstructed
> a valid stripe it can run the verifier that was supplied to it from
> above, etc.
> 
> i.e. I dont see why only filesystems should drive retries or have to
> be aware of the underlying storage stacking. ISTM that each
> layer of the storage stack should be able to verify what has been
> returned to it is valid independently of the higher layer
> requirements. The only difference from a caller point of view should
> be submit_bio(bio); vs submit_bio_verify(bio, verifier_cb_func);

What if instead of constructing a giant pile of verifier call chain, we
simply had a return value from ->bi_end_io that would then be returned
from bio_endio()?  Stacked things like dm-linear would have to know how
to connect the upper endio to the lower endio though.  And that could
have its downsides, too.  How long do we tie up resources in the scsi
layer while upper levels are busy running verification functions...?

Hmmmmmmmmm....

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
