Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38980 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfB1Vtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Feb 2019 16:49:53 -0500
Date: Fri, 1 Mar 2019 08:49:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 0/9] Block/XFS: Support alternative mirror device
 retry
Message-ID: <20190228214949.GO23020@dastard>
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190218213150.GE14116@dastard>
 <ba78a587-04ba-58a4-f282-63e200c81e2d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba78a587-04ba-58a4-f282-63e200c81e2d@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

On Thu, Feb 28, 2019 at 10:22:02PM +0800, Bob Liu wrote:
> On 2/19/19 5:31 AM, Dave Chinner wrote:
> > On Wed, Feb 13, 2019 at 05:50:35PM +0800, Bob Liu wrote:
> >> Motivation:
> >> When fs data/metadata checksum mismatch, lower block devices may have other
> >> correct copies. e.g. If XFS successfully reads a metadata buffer off a raid1 but
> >> decides that the metadata is garbage, today it will shut down the entire
> >> filesystem without trying any of the other mirrors.  This is a severe
> >> loss of service, and we propose these patches to have XFS try harder to
> >> avoid failure.
> >>
> >> This patch prototype this mirror retry idea by:
> >> * Adding @nr_mirrors to struct request_queue which is similar as
> >>   blk_queue_nonrot(), filesystem can grab device request queue and check max
> >>   mirrors this block device has.
> >>   Helper functions were also added to get/set the nr_mirrors.
> >>
> >> * Introducing bi_rd_hint just like bi_write_hint, but bi_rd_hint is a long bitmap
> >> in order to support stacked layer case.
> >>
> >> * Modify md/raid1 to support this retry feature.
> >>
> >> * Adapter xfs to use this feature.
> >>   If the read verify fails, we loop over the available mirrors and retry the read.
> > 
> > Why does the filesystem have to iterate every single posible
> > combination of devices that are underneath it?
> > 
> > Wouldn't it be much simpler to be able to attach a verifier
> > function to the bio, and have each layer that gets called iterate
> > over all it's copies internally until the verfier function passes
> > or all copies are exhausted?
> > 
> > This works for stacked mirrors - it can pass the higher layer
> > verifier down as far as necessary. It can work for RAID5/6, too, by
> > having that layer supply it's own verifier for reads that verifies
> > parity and can reconstruct of failure, then when it's reconstructed
> > a valid stripe it can run the verifier that was supplied to it from
> > above, etc.
> > 
> > i.e. I dont see why only filesystems should drive retries or have to
> > be aware of the underlying storage stacking. ISTM that each
> > layer of the storage stack should be able to verify what has been
> > returned to it is valid independently of the higher layer
> > requirements. The only difference from a caller point of view should
> > be submit_bio(bio); vs submit_bio_verify(bio, verifier_cb_func);
> > 
> 
> We already have bio->bi_end_io(), how about do the verification inside bi_end_io()?
> 
> Then the whole sequence would like:
> bio_endio()
>     > 1.bio->bi_end_io()
>         > xfs_buf_bio_end_io()
>             > verify, set bio->bi_status = "please retry" if verify fail
>         
>     > 2.if found bio->bi_status = retry
>     > 3.resubmit bio

As I mentioned to Darrick, this isn't cwas simple as it seems
because what XFS actually does is this:

IO completion thread			Workqueue Thread
bio_endio(bio)
  bio->bi_end_io(bio)
    xfs_buf_bio_end_io(bio)
      bp->b_error = bio->bi_status
      xfs_buf_ioend_async(bp)
        queue_work(bp->b_ioend_wq, bp)
      bio_put(bio)
<io completion done>
					.....
					xfs_buf_ioend(bp)
					  bp->b_ops->read_verify()
					.....

IOWs, XFS does not do read verification inside the bio completion
context, but instead defers it to an external workqueue so it does
not delay processing incoming bio IO completions. Hence there is no
way to get the verification status back to the bio completion (the
bio has already been freed!) to resubmit from there.

This is one of the reasons I suggested a verifier be added to the
submission, so the bio itself is wholly responsible for running it,
not an external, filesystem level completion function that may
operate outside of bio scope....

> Is it fine to resubmit a bio inside bio_endio()?

Depends on the context the bio_endio() completion is running in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
