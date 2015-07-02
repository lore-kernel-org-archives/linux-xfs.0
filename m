Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5BDB7FAA
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 02:07:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E83FAC006
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 00:07:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	b5tDmUlRZboia0j6 for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2015 00:07:43 -0700 (PDT)
Date: Thu, 2 Jul 2015 17:07:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/14] xfs: minimize impact to non-reflink files via
	reflink per-inode flag
Message-ID: <20150702070711.GY22807@dastard>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625234016.4992.52406.stgit@birch.djwong.org>
	<20150701015843.GS22807@dastard>
	<20150702023208.GE10043@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150702023208.GE10043@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 07:32:08PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 01, 2015 at 11:58:43AM +1000, Dave Chinner wrote:
> > On Thu, Jun 25, 2015 at 04:40:16PM -0700, Darrick J. Wong wrote:
> > > Gate all the reflink functions (which generally involve an expensive
> > > trip to the reflink btree) on an inode flag which is applied to both
> > > inodes at reflink time.  This minimizes reflink's impact on non-CoW
> > > files.
> > 
> > Ah, I see you do this reflink inode flag here. This should be one of
> > the first patches, not the last.  i.e. the patch series should
> > build up all the supporting infrastructure in individual patches
> > before adding any of the actual reflink implementation....
> > 
> > Also, the flag needs to go into the di_flags2 field, as the last
> > flag in the di_flags field is reserved for a "more flags" flag if we
> > ever need to add more flags to a v2 inode in a v4 filesystem...
> 
> It looks to me like di_flags2 only exists in a v3 inode, and v3 inodes
> only exist on v5 filesystems.  I don't really mind using di_flags2 for
> reflink (on the off chance you want to use bit 15 of di_flags for a
> v2 inode) but I'm wondering how is it possible to have di_flags on a v4 fs?

You mean how is it possible to have di_flags2 on a v4 fs?

Internally when inodes are read off disk, they are converted to v3
format in memory. i.e. the struct xfs_icdinode is a v3 format
structure. Hence when reading in v2 inodes, the di_flags2 field is
present in the structure and it gets initialised to zero. When we
format the in-memory inode to disk (in xfs_iflush_int()), we don't
ever write the v3 fields back to the on disk inode structure, and
hence the in-memory value of the di_flags2 field doesn't ever get
written to disk.

So while the various v3 inode fields are always present in the
in-memory inode, if di_version = 2 then the v3 fields will be
initialised to zero on read and will never be written back to
disk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
