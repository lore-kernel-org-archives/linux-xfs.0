Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0890E7CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:35:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C34FD304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 14:35:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CcmM8BOP9bc91GAR for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 14:35:41 -0700 (PDT)
Date: Wed, 19 Jun 2013 07:35:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/27] xfs: reshuffle dir2 definitions around for userspace
Message-ID: <20130618213505.GX29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-16-git-send-email-david@fromorbit.com>
	<20130617160515.GC26043@infradead.org>
	<20130618211256.GW29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618211256.GW29338@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jun 19, 2013 at 07:12:57AM +1000, Dave Chinner wrote:
> On Mon, Jun 17, 2013 at 09:05:15AM -0700, Christoph Hellwig wrote:
> > On Wed, Jun 12, 2013 at 08:22:35PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Many of the definitions within xfs_dir2_priv.h are needed in
> > > userspace outside libxfs. Definitions within xfs_dir2_priv.h are
> > > wholly contained within libxfs, so we need to shuffle some of the
> > > definitions around to keep consistency across files shared between
> > > user and kernel space.
> > 
> > I created the xfs_dir2_format.h header so that it would be self
> > contained.  Despite not mentioning it in the description this patch
> > also moves typedefs out of xfs_dir2_format.h which is something I'd
> > rather avoid.  Where in userspace would we need these defintions but
> > can't include xfs_dir2_format.h?
> 
> They are needed by the declarations of the public dir2 functions
> used by userspace. i.e. they aren't just on-disk format definitions
> - they are API definitions as well.
> 
> This was one of the problems I had with the previous libxfs/kernel
> sync - converting all the userspace code to use xfs_dir2_format.h.
> I had no idea exactly how you intended to structure the usrespace
> code, and so I was really flying blind.
> 
> The separation of dir2.h/format.h/priv.h is fine from the kernel
> side, but I found that a significant number of functions declared in
> xfs_dir2_priv.h are actually public functions in userspace and so
> need to be in xfs_dir2.h, not xfs_dir2_priv.h. And then that
> requires the definitions from xfs_fir2_format.h for the function
> prototypes in xfs_dir2.h....
> 
> Having just done all the other __KERNEL__ changes, I see this
> dir2 change in a different light now. I can probably rework the
> userspace includes to include xfs_dir2_format.h before xfs_dir2.h
> and hence remove the need to modify xfs_dir2_format.h...

Yes, it can. The problem was that xfs_dir2_format.h requires the
definition of struct xfs_mount (due to static inline functions),
but there are no such restrictions on xfs_dir2.h so it can be moved
to after the include for xfs_dir2_format.h.

Ok, so xfs_dir2_format.h doesn't need to change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
