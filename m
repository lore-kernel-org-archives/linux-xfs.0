Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B9377CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 20:32:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78A8E304039
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 18:32:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	l6Np02FMsFPhA6Ee for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 18:32:46 -0700 (PDT)
Date: Thu, 21 Mar 2013 12:32:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/21] xfs: add CRC checks to remote symlinks
Message-ID: <20130321013243.GJ17758@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-11-git-send-email-david@fromorbit.com>
	<20130320220334.GN22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130320220334.GN22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 20, 2013 at 05:03:34PM -0500, Ben Myers wrote:
> On Tue, Mar 12, 2013 at 11:30:43PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add a header to the remote symlink block, containing location and
> > owner information, as well as CRCs and LSN fields. This requires
> > verifiers to be added to the remote symlink buffers for CRC enabled
> > filesystems.
> > 
> > This also fixes a bug reading multiple block symlinks, where the second block
> > overwrites the first block when copying out the link name.
> 
> More comments below.
....
> 
> >   */
> >  STATIC void
> >  xfs_bmap_local_to_extents_init_fn(
> > @@ -1332,23 +1334,12 @@ xfs_bmap_local_to_extents_init_fn(
> >  	struct xfs_inode	*ip,
> >  	struct xfs_ifork	*ifp)
> >  {
> > +	ASSERT(0);
> 
> That has nothing to do with crcs.

It most definitely does. This path is completely invalid to take now
that CRCs are enabled for remote symlink blocks.

Every caller through this function requires a transformation of
opaque data to block format. For CRC enable blocks, that means a
type specific handler *must* be used for header initialisation and
copying the data. Hence for debug kernels we want to know
immediately if this path is *ever* taken, because it is indicative
of an unhandled local-to-extent format transition out of
xfs_bmapi_write().

This is *exactly* the path that caused the bmbt verifier failures on
remote symlink buffers in 3.8.0. Once I've had time to study the
code more thoroughly, I'll probably remove the entire
local-to-extents path from xfs_bmapi_write() because there should be
no existing users of the path and callers should do the format
transformation themselves as is done right now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
