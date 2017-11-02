Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58021 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932201AbdKBXpw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 19:45:52 -0400
Date: Fri, 3 Nov 2017 10:45:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/18] xfs: pass an on-disk extent to
 xfs_bmbt_validate_extent
Message-ID: <20171102234549.GY5858@dastard>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-2-hch@lst.de>
 <20171031175311.GC7093@bfoster.bfoster>
 <20171031211520.GI4911@magnolia>
 <20171101135855.GA11709@bfoster.bfoster>
 <20171101230024.GF4922@magnolia>
 <20171102115710.GB15748@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102115710.GB15748@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 07:57:11AM -0400, Brian Foster wrote:
> On Wed, Nov 01, 2017 at 04:00:24PM -0700, Darrick J. Wong wrote:
> > On Wed, Nov 01, 2017 at 09:58:55AM -0400, Brian Foster wrote:
> > > On Tue, Oct 31, 2017 at 02:15:20PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Oct 31, 2017 at 01:53:12PM -0400, Brian Foster wrote:
> > > > > On Tue, Oct 31, 2017 at 04:22:13PM +0200, Christoph Hellwig wrote:
> > > > > > This prepares for getting rid of the current in-memory extent format.
> > > > > > 
> > > > > 
> > > > > Couldn't we port this function over to use whatever the new in-memory
> > > > > extent format is? IOW, just have the helper check for XFS_EXT_UNWRITTEN
> > > > > rather than the associated bit in the on-disk format..?
> > > > 
> > > > It's certainly possible, but in general verifiers are supposed to check
> > > > on-disk metadata before they end up in-core, and this would seem to get
> > > > us closer to that, right?
> > > > 
> > > 
> > > Yeah, but are any of these calls actually made in a buffer verifier
> > > path?
> > 
> > No.  They probably ought to be -- we can add them to the bmbt verifier and
> > the inode fork verifier (in the magical future when those exist :P), but
> > for now I think xfs_iread_extents is the closest we come to an "obvious"
> > place where we load disk data into/out of its in-core representation.
> > 
> 
> Ok.. I agree that verifiers are intended to check on-disk format, but I
> still don't see how that design aspect of buffer verifiers really has
> much bearing on this function given how it is currently used. This
> particular block has already passed the associated buffer verifier.
> Also, do we have any verifiers that consider fork state?
> 
> If the goal is to check the on-disk record, perhaps at least that part
> of this check (associated with the extent flag bit(s)) should be moved
> to the verifier? Even with doing that, it seems there still may be a
> need for a higher level sanity check based on the fork, and I don't see
> any reason why that necessarily needs to use the on-disk value as
> opposed to the in-core value. *shrug* Not that big of a deal though..

IMO, we shouldn't be moving the buffer contents verification to the
verifier.  IO completion context is a CPU and latency sensitive area
of the code. The verifier is there to verify the /structure/ of the
metadata is valid (e.g. btree block headers), not the individual
metadata records within the buffer contain valid values
(records/ptrs).

The CRC that the verifier checks tells us the metadata records
within the block are the same as what was last written, and that's
about as much of the buffer data as the verifier should be checking.
We do content based verification when we get the checked buffer into
the subsystem that parses the content.

IOWs, xfs_iread_extents() is, IMO, the right place to be verifying
that BMBT records being read from a buffer with "verified contents".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
