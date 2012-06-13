Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D1u5jI062005 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 20:56:06 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y2XCkIpKOqTaBbWV for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 18:56:03 -0700 (PDT)
Date: Wed, 13 Jun 2012 11:55:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] vfs: add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613015553.GP22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<1339515364-17374-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339515364-17374-2-git-send-email-pbonzini@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Jun 12, 2012 at 05:36:03PM +0200, Paolo Bonzini wrote:
> Add a new operation mode to fallocate, called FALLOC_FL_ZERO_RANGE.
> It resembles the similarly named XFS ioctl.  Filesystems should
> preallocate blocks for regions that span holes in the file, and convert
> the entire range to unwritten extents. 

You've described filesystem implementation details, not a
description of the functionality. The functionality is simply that
after this call is made the range of the file specified will return
zeros when read.  You need to write the addition to the fallocate()
man page, and that will help you describe what the API is supposed
to do, not how a filesystem implements it....

FWIW, It is up to the filesytem to optimise this as best they can.
XFS, as you've described, implements with preallocation and
real->unwritten conversion. Other filesystems might simply implement
it as "hole punch + preallocation", for whatever those filesystems
use for that functionality (for some, preallocation means "write
zeros to disk").

> This operation is a fast method
> of overwriting any from the range specified with zeros without removing
> any blocks or having to write zeros to disk.

Well, that is the method XFS uses, but the idea is to avoid that if
they can. i.e. be fast.  Think about that for a moment - if the
range is fragmented or sparse, it may be faster makes sense to punch
out the existing extents and preallocate a single new extent in this
case that to have to allocate multiple (potentially hundreds or
thousands) small extents to fill holes.

Just because I implemented it the easy way in XFS for the person
that requested it (i.e. zeroing preallocated VM images that were
already perfectly laid out) doesn't mean that is the only way it can
be implemented.

> Any subsequent read in the given range will return zeros until new
> data is written.

That should be the second sentence of the commit message.

> This functionality requires filesystems to support unwritten extents.
> If xfs_info(8) reports unwritten=1, then the filesystem was made to
> flag unwritten extents.  It is okay to report EOPNOTSUPP and let the
> application deal with the outcome, but it is not okay to succeed or
> report EOPNOTSUPP for the same inode depending on the other arguments.

I don't think that is true, nor necessary, for the commit message -
filesystems without unwritten extents can implement this quite
easily just by writing zeros to the range just like some do for
preallocation.

> FALLOC_FL_PUNCH_HOLE|FALLOC_FL_ZERO_RANGE is ruled out here, at the
> vfs level, rather than leaving it to the filesystems.  This way, in the
> future 0x6 could be used as a third mode.

We have more than enough feature bits that we don't need to
contemplate mixing various combinations to provide different
features in future.

Besides, a filesystem could interpret that pair as "punch the range,
then preallocate it" rather than "convert to unwritten and hole fill
with preallocation", so I do not see them as mutually exclusive. If
the filesystem wants to treat them that way, then they are welcome
to, but I can definitely see a use case for allowing them both to be
set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
