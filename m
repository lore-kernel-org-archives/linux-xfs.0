Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:13312 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750788AbeFEEoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 00:44:03 -0400
Date: Tue, 5 Jun 2018 14:44:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: more verifications!
Message-ID: <20180605044400.GC10363@dastard>
References: <20180605024313.18737-1-david@fromorbit.com>
 <20180605033800.GA9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605033800.GA9437@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 08:38:00PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2018 at 12:43:10PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This patchset addresses a series of corruptions noticed in an image
> > provided by Wen Xu. The patches only address detecting corruptions
> > before they can do damage - it does not address/fix the crash the
> > image caused but instead prevents the bad information from getting
> > to the point where it can cause a crash.
> > 
> > The third patch addresses a general btree record validation issue;
> > we should probably dirve this inwards to each btree implementation
> > with a ->verify_record() callout, as this patch does not address
> > all the places that btree records are traversed during searches. It
> > will catch any attempt to use a bad record that a search lands on,
> > however.
> > 
> > Comments?
> 
> So, uh, does xfs_repair catch all these things and fix them?

Don't know - I couldn't test repair on the damaged image because it
was a single AG and repair barfed on the primary superblock and
couldn't recover it.

Yes, both Eric and I have asked for this fuzzing to be done on 2 AG
filesystems so we can reliably test the userspace tools against
them, too, but we're not making any progress there...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
