Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:62455 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751600AbdH2WDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 18:03:46 -0400
Date: Wed, 30 Aug 2017 08:03:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS reflinks
Message-ID: <20170829220316.GD10621@dastard>
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
 <20170829160308.GR4757@magnolia>
 <20170829162310.GA22552@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829162310.GA22552@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Chris Cottam <chris.cottam@bytemark.co.uk>, linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 09:23:10AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 29, 2017 at 09:03:08AM -0700, Darrick J. Wong wrote:
> > First, should we land the incore extent map rework (not that I've seen a
> > patchset yet) so that the increased extent map fragmentation resulting
> > from cow/dedupe don't overwhelm the memory allocator with high order
> > allocations?  Incore extent map memory usage hasn't been an issue here...
> 
> Working on this now, but so far this hasn't been a major issue.
> The main workload where the extent list currently hurts and that
> prompted my work in this area doesn't even involve reflinks (sparse
> VM image).

Yup, that's a problem, and it's going to be even more of a problem
once people start using reflink to snapshot sparse VM images. I
think that the extent rework is probably the most important thing we
need to solve for COW to be generally usable.

Christoph, ignoring the CoW consideration, this is top of my list of
"things we've been ignoring for too long that need to be fixed
ASAP". I've got the time to work on this right now, so if you don't
have time to get it done in the next merge cycle I can probably make
that happen....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
