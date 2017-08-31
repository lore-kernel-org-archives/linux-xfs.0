Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:49973 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750757AbdHaCnX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 22:43:23 -0400
Date: Thu, 31 Aug 2017 12:43:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170831024320.GN10621@dastard>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
 <20170818070516.GA15291@infradead.org>
 <20170818170607.GK4796@magnolia>
 <20170821081333.GB31761@infradead.org>
 <20170829151159.GA12841@infradead.org>
 <20170829222247.GF10621@dastard>
 <20170831001009.GD3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831001009.GD3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 05:10:09PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 30, 2017 at 08:22:47AM +1000, Dave Chinner wrote:
> > On Tue, Aug 29, 2017 at 08:11:59AM -0700, Christoph Hellwig wrote:
> > > On Mon, Aug 21, 2017 at 01:13:33AM -0700, Christoph Hellwig wrote:
> > > > So what do you think of the version that adds real printks for
> > > > each condition including more details like the one verifier I
> > > > did below?  Probably needs some unlikely annotations, though.
> > > 
> > > Given that there was another resend of the series I'd be really
> > > curious about the answer to this?
> > 
> > If we increase the size of the hexdump on error, then most of the
> > specific numbers in the print statements can be pulled from the
> > hexdump. And if the verifier tells us exactly what check failed,
> > we don't have to decode the entire hexdump to know what field was
> > out of band.
> 
> How much do we increase the size of the hexdump?  64 -> 128?  Or
> whatever the structure header size is?

I choose 64 because it captured the primary header for most 
structures for CRC enabled filesystems, so it would have
owner/crc/uuid/etc in it. I wasn't really trying to capture the
object specific metadata in it, but increasing to 128 bytes would
capture most of that block headers, too. Won't really help with
inodes, though, as the core is 176 bytes and the owner/crc stuff is
at the end....

> How about if xfs_error_level >=
> XFS_ERRORLEVEL_HIGH then we dump the entire buffer?

Excellent idea. We can easily capture the entire output for
corruptions the users can easily trip over. Maybe put in the short
dump a line "turn error level up to 11 to get a full dump of the
corruption"?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
