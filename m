Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IL5c32213335 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 16:05:38 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gshr6Qg8FVx7MIdJ for <xfs@oss.sgi.com>;
	Thu, 18 Oct 2012 14:07:16 -0700 (PDT)
Date: Fri, 19 Oct 2012 08:07:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/2] fiemap: filesystem free space mapping
Message-ID: <20121018210713.GT2739@dastard>
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
	<F8483A1E-AFBD-46C0-BE4E-1C84F65FB29A@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F8483A1E-AFBD-46C0-BE4E-1C84F65FB29A@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 18, 2012 at 02:10:59AM -0600, Andreas Dilger wrote:
> On 2012-10-17, at 11:11 PM, Dave Chinner wrote:
> > So, I was bored a few days ago, and I was sick of having to run
> > xfs_db incorrectly report free space extents when the filesytem is
> > mounted, so I decided to extend fiemap to export freespace mappings
> > to userspace so I could get the information coherently through the
> > mounted filesystem.
> > 
> > Yes, this could probably be considered interface abuse but, well, it
> > was simple to do because extent mapping is exactly what fiemap is
> > designed to do. Hence I didn't have to write new walkers/formatters
> > and I was using code I knew worked correctly.
> 
> One question about the usage of this interface - is the ioctl()
> called on an open fd for the root inode, or is it called on any
> open fd in the filesystem?  In some sense, getting the free space
> on the root (or preferably block dev inode if that would work)
> would make the most sense, since FIEMAP is intended to be related
> to a specific file.

fiemap in XFs is currently only hooked up to files, not directories.
I didn't change that, so it needs an open regular file in the
filesystem to work. I need to change that for it to work on
directories - I think that having it work on the root dir of a
filesystem is the right thing to do, but really having it behave
like fstatfs(2) is where it shoul dend up, I think.

> That said, it is a lot easier to use if it can be on any open file
> handle in the filesystem, and one could consider the free space as
> being related to every file in the filesystem (e.g. for the next
> block allocation or defrag migration).

*nod*

> > There are two methods of mapping - one is reporting free space in
> > ascending extent start offset order, then other in ascending extent
> > length order. Both a useful to have (e.g. defragmenter might want to
> > know about the nearest free block to given offset or the largest
> > free extent in a given region). Either way, XFS keeps indexes
> > ordered in both ways, so they can be exported directly with minimal
> > overhead.
> > 
> > The only "interesting" abuse of the interface is really the use of
> > FIEMAP_EXTENT_LAST. This means that the last extent in a freespace
> > index is being returned, rather than the last freespace extent. This
> > is done because filesystems often have multiple free space indexes,
> > and it may be difficult to sort/scan over multiple indexes in a
> > single map.
> 
> I'm not sure I understand the distinction you are trying to convey here.
> Could you elaborate?

XFs has multiple Allocation Groups with separate indexes in each AG.
It only make sense for filesystem tools to be finding free space in
a specific region (i.e. the AG they want to allocate in). xfs-fsr
already controls the AG that the new extents are allocated in, but
it has no idea of whether that is the best AG to relocate the data
to - it just follows the kernel allocation rules based on the
location of the inode. If we want to select a new AG based on, say,
largest free extent size, then we need to know what the largest
sizes in each AG are. Hence we want to know when we reach the end of
an AG index when pulling the freespace data out of the kernel so we
categorise it by AG.

I suspect a similar thing might be useful for btrfs, with per-device
freespace mappings...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
