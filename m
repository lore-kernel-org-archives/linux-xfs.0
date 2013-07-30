Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0EB537CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:27:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 806BEAC003
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 16:27:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UIrndAaxbfGXNHpd for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 16:27:49 -0700 (PDT)
Date: Wed, 31 Jul 2013 09:27:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 6/7] xfs: add capable check to free eofblocks ioctl
Message-ID: <20130730232746.GP13468@dastard>
References: <20130729230705.128e4509@oracle.com> <51F7B2A3.7030007@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F7B2A3.7030007@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Tue, Jul 30, 2013 at 08:33:39AM -0400, Brian Foster wrote:
> On 07/29/2013 11:07 PM, Dwight Engen wrote:
> > Check for CAP_SYS_ADMIN since the caller can truncate preallocated
> > blocks from files they do not own nor have write access to. A more
> > fine grained access check was considered: require the caller to
> > specify their own uid/gid and to use inode_permission to check for
> > write, but this would not catch the case of an inode not reachable
> > via path traversal from the callers mount namespace.
> > 
> > Add check for read-only filesystem to free eofblocks ioctl.
> > 
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 6e72eff..b1990ac 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1613,6 +1613,12 @@ xfs_file_ioctl(
> >  		struct xfs_fs_eofblocks eofb;
> >  		struct xfs_eofblocks keofb;
> >  
> > +		if (!capable(CAP_SYS_ADMIN))
> > +			return -EPERM;
> > +
> 
> I see that we aren't using XFS_ERROR() on the EPERM returns in
> xfs_file_ioctl(), but I see it used for other capability checks
> elsewhere (i.e., down in xfs_growfs_data()). Perhaps somebody can chime
> in as to the reasoning for that..? I guess it could be that we wouldn't
> want to fire a BUG() at the interface point (ioctl()) on debug kernels
> for every time a user attempts an operation they don't have the ability
> to perform (e.g., we should notice on internal failures, not when
> userspace sends us something wrong).

Essentially.

The error trapping is used to pinpoint where an error first occurs.
e.g.  where a ENOMEM error is first detected. There might be tens of
memory allocations inside a transaction that is failing with ENOMEM
and shutting down, so tracking down where it came from is quite
hard. Hence trapping the first ENOMEM occurrence with a BUG() via
XFS_ERROR() will tell you exactly where it came from. Similarly,
some ioctls can return EINVAL for 20 different reasons (e.g.
xfs_swapext() path) and so trapping them can be useful if it's a
random failure that can't be captured otherwise.

Because all the EPERM checks are in the outer layers and generally
easy to spot, they are easy to test for and easy to track down when
they occur. Hence, in general, we don't need to trap them. 

> 
> > +		if (IS_RDONLY(inode))
> > +			return -XFS_ERROR(EROFS);
> > +
> 
> This should probably be consistent with the other read-only checks in
> the ioctl code and check the xfs_mount structure:
> 
> 	if (mp->m_flags & XFS_MOUNT_RDONLY)
> 		return -XFS_ERROR(EROFS);

Oh, I didn't even think about that - IS_RDONLY() actually checks the
superblock flag, so it's no different to checking the xfs_mount
flags. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
