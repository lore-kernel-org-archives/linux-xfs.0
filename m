Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:5890 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfBGC1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 21:27:01 -0500
Date: Thu, 7 Feb 2019 13:26:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
Message-ID: <20190207022657.GI14116@dastard>
References: <87h8dgefee.fsf@esperi.org.uk>
 <20190206234328.GH14116@dastard>
 <20190207002425.GX24140@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207002425.GX24140@tuebingen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>

On Thu, Feb 07, 2019 at 01:24:25AM +0100, Andre Noll wrote:
> On Thu, Feb 07, 10:43, Dave Chinner wrote
> > File data readahead: REQ_RAHEAD
> > Metadata readahead: REQ_META | REQ_RAHEAD
> > 
> > drivers/md/bcache/request.c::check_should_bypass():
> > 
> >         /*
> >          * Flag for bypass if the IO is for read-ahead or background,
> >          * unless the read-ahead request is for metadata (eg, for gfs2).
> >          */
> >         if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
> >             !(bio->bi_opf & REQ_PRIO))
> >                 goto skip;
> > 
> > bcache needs fixing - it thinks REQ_PRIO means metadata IO. That's
> > wrong - REQ_META means it's metadata IO, and so this is a bcache
> > bug.
> 
> Do you think 752f66a75abad is bad (ha!) and should be reverted?

Yes, that change is just broken. From include/linux/blk_types.h:

	__REQ_META,             /* metadata io request */
	__REQ_PRIO,             /* boost priority in cfq */


i.e. REQ_META means that it is a metadata request, REQ_PRIO means it
is a "high priority" request. Two completely different things, often
combined, but not interchangeable.

So, yeah, that needs to be reverted if you want bcache to function
properly for metadata caching.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
