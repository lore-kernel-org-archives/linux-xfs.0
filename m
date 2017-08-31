Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41316 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752256AbdHaXtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 19:49:33 -0400
Date: Thu, 31 Aug 2017 16:49:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170831234903.GU3775@magnolia>
References: <20170818170607.GK4796@magnolia>
 <20170821081333.GB31761@infradead.org>
 <20170829151159.GA12841@infradead.org>
 <20170829222247.GF10621@dastard>
 <20170831001009.GD3775@magnolia>
 <20170831024320.GN10621@dastard>
 <bb27a635-a1d6-6a84-7810-b37cebac8350@sandeen.net>
 <20170831032736.GO10621@dastard>
 <20170831054443.GE3775@magnolia>
 <20170831233726.GV10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831233726.GV10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Sep 01, 2017 at 09:37:26AM +1000, Dave Chinner wrote:
> On Wed, Aug 30, 2017 at 10:44:43PM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 31, 2017 at 01:27:36PM +1000, Dave Chinner wrote:
> > > On Wed, Aug 30, 2017 at 10:05:25PM -0500, Eric Sandeen wrote:
> > > > On 8/30/17 9:43 PM, Dave Chinner wrote:
> > > > > On Wed, Aug 30, 2017 at 05:10:09PM -0700, Darrick J. Wong wrote:
> > > > >> On Wed, Aug 30, 2017 at 08:22:47AM +1000, Dave Chinner wrote:
> > > > >>> On Tue, Aug 29, 2017 at 08:11:59AM -0700, Christoph Hellwig wrote:
> > > > >>>> On Mon, Aug 21, 2017 at 01:13:33AM -0700, Christoph Hellwig wrote:
> > > > >>>>> So what do you think of the version that adds real printks for
> > > > >>>>> each condition including more details like the one verifier I
> > > > >>>>> did below?  Probably needs some unlikely annotations, though.
> > > > >>>>
> > > > >>>> Given that there was another resend of the series I'd be really
> > > > >>>> curious about the answer to this?
> > > > >>>
> > > > >>> If we increase the size of the hexdump on error, then most of the
> > > > >>> specific numbers in the print statements can be pulled from the
> > > > >>> hexdump. And if the verifier tells us exactly what check failed,
> > > > >>> we don't have to decode the entire hexdump to know what field was
> > > > >>> out of band.
> > > > >>
> > > > >> How much do we increase the size of the hexdump?  64 -> 128?  Or
> > > > >> whatever the structure header size is?
> > > > > 
> > > > > I choose 64 because it captured the primary header for most 
> > > > > structures for CRC enabled filesystems, so it would have
> > > > > owner/crc/uuid/etc in it. I wasn't really trying to capture the
> > > > > object specific metadata in it, but increasing to 128 bytes would
> > > > > capture most of that block headers, too. Won't really help with
> > > > > inodes, though, as the core is 176 bytes and the owner/crc stuff is
> > > > > at the end....
> > > > > 
> > > > >> How about if xfs_error_level >=
> > > > >> XFS_ERRORLEVEL_HIGH then we dump the entire buffer?
> > > > > 
> > > > > Excellent idea. We can easily capture the entire output for
> > > > > corruptions the users can easily trip over. Maybe put in the short
> > > > > dump a line "turn error level up to 11 to get a full dump of the
> > > > > corruption"?
> > > > 
> > > > Yep, the thing about "more info only if you tune it" is that nobody
> > > > will know to tune it.  Unless you printk that info...
> > > > 
> > > > Of course nobody will know what "turn error up ..." means, either.
> > > 
> > > Sure, I was just paraphrasing how an error message might look.  A
> > > few quick coats of paint on the bikeshed will result in something
> > > like:
> > > 
> > > "If this is a recurring error, please set
> > > /proc/sys/fs/xfs/error_level to ...."
> > > 
> > > > Hm, at one point I had a patch to add object size to the
> > > > xfs_buf_ops struct and print that many bytes, but can't find it now :/
> > > > (not that it was very complicated...)
> > > > 
> > > > Anyway, point is making it vary with the size of the object wouldn't
> > > > be too hard.
> > > 
> > > Probably not, but it is complicated by the fact we have a couple of
> > > different ways of dumping corruption errors. e.g. inode verifier
> > > warnings are dumped through XFS_CORRUPTION_ERROR() rather than
> > > xfs_verifier_error() as they are not buffer based verifiers. Other
> > > things like log record CRC failures are hard coded to dump 32 bytes,
> > > as is xlog_print_trans() on transaction overruns....
> > > 
> > > That's not a show stopper, but it would be nice to have consistent
> > > behaviour across all the mechanisms we use to dump object data that
> > > failed verification...
> > 
> > /me wonders if it'd suffice just to add an xfs_params value in /proc,
> > set its default to 128 bytes, and make the corruption reporters query
> > the xfs_param.  Then we could tell users to set it to some magic value
> > (-1? 0?) to get the entire buffer.
> 
> Let's avoid adding a new proc entries to configure error verbosity
> when we already have a proc entry that controls error verbosity....

Fair enough.

> > I just had another thought -- what if we always dump the whole buffer if
> > the corruption would result in fs shutdown?
> 
> How do you know that a verifier failure (or any specific call to
> XFS_CORRUPTION_ERROR) is going to result in a filesystem shutdown?

Nuts.  For a minute there I thought that if we were trying to get/read
a buffer we'd have assigned it to a transaction before calling the
verifier, but that's not true.  Oh well.  I'll start with a simpler
patch to increase the dump size if xfs_error_level is high.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
