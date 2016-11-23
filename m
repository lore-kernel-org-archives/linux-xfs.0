Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:41858 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933483AbcKWXyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 18:54:12 -0500
Date: Thu, 24 Nov 2016 10:53:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161123235324.GQ28177@dastard>
References: <cover.1479427384.git.osandov@fb.com>
 <20161123020210.GW21290@hungrycats.org>
 <20161123042632.GQ31101@dastard>
 <20161123135559.GC8685@hungrycats.org>
 <20161123221328.GR31101@dastard>
 <20161123231446.GD8685@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161123231446.GD8685@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com

On Wed, Nov 23, 2016 at 06:14:47PM -0500, Zygo Blaxell wrote:
> On Thu, Nov 24, 2016 at 09:13:28AM +1100, Dave Chinner wrote:
> > On Wed, Nov 23, 2016 at 08:55:59AM -0500, Zygo Blaxell wrote:
> > > On Wed, Nov 23, 2016 at 03:26:32PM +1100, Dave Chinner wrote:
> > > > On Tue, Nov 22, 2016 at 09:02:10PM -0500, Zygo Blaxell wrote:
> > > > > On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> > > > > > 3. Both XFS and Btrfs cap each dedupe operation to 16MB, but the
> > > > > >    implicit EOF gets around this in the existing XFS implementation. I
> > > > > >    copied this for the Btrfs implementation.
> > > > > 
> > > > > Somewhat tangential to this patch, but on the dedup topic:  Can we raise
> > > > > or drop that 16MB limit?
> > > > > 
> > > > > The maximum btrfs extent length is 128MB.  Currently the btrfs dedup
> > > > > behavior for a 128MB extent is to generate 8x16MB shared extent references
> > > > > with different extent offsets to a single 128MB physical extent.
> > > > > These references no longer look like the original 128MB extent to a
> > > > > userspace dedup tool.  That raises the difficulty level substantially
> > > > > for a userspace dedup tool when it tries to figure out which extents to
> > > > > keep and which to discard or rewrite.
> > > > 
> > > > That, IMO, is a btrfs design/implementation problem, not a problem
> > > > with the API. Applications are always going to end up doing things
> > > > that aren't perfectly aligned to extent boundaries or sizes
> > > > regardless of the size limit that is placed on the dedupe ranges.
> > > 
> > > Given that XFS doesn't have all the problems btrfs does, why does XFS
> > > have the same aribitrary size limit?  Especially since XFS demonstrably
> > > doesn't need it?
> > 
> > Creating a new-but-slightly-incompatible jsut for XFS makes no
> > sense - we have multiple filesystems that support this functionality
> > and so they all should use the same APIs and present (as far as is
> > possible) the same behaviour to userspace.
> 
> OK.  Let's just remove the limit on all the filesystems then.
> XFS doesn't need it, and btrfs can be fixed.

Yet applications still have to support kernel versions where btrfs
has a limit. IOWs, we can remove the limit for future improvement,
but that doesn't mean userspace is free from having to know about
the existing limit constraints.

That is, once a behaviour has been exposed to userspace through an
API, we can't just change it and act like it was always that way -
apps still have to support kernels that expose the old behaviour.
i.e. the old behaviour is there forever, and this why designing
userspace APIs is /hard/. It's also why it's better to use an
existing, slightly less than ideal API than invent a new one that
will simply have different problems exposed in future...

> > IOWs it's more important to use existing APIs than to invent a new
> > one that does almost the same thing. This way userspace applications
> > don't need to be changed to support new XFS functionality and we
> > make life easier for everyone. 
> 
> Except removing the limit doesn't work that way.  An application that
> didn't impose an undocumented limit on itself wouldn't break when moved
> to a filesystem that imposed no such limit, i.e. if XFS had no limit,
> an application that moved from btrfs to XFS would just work.

It goes /both ways/ though. Write an app on XFS that does not care
about limits and it won't work on btrfs because it gets unexpected
errors.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
