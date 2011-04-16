Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3G0LguL098784 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 19:21:42 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E04F93E587F
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 17:25:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uom7kF4RjZByqS11 for <xfs@oss.sgi.com>;
	Fri, 15 Apr 2011 17:25:04 -0700 (PDT)
Date: Sat, 16 Apr 2011 10:25:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110416002500.GO21395@dastard>
References: <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard> <87sjtjq4ir.fsf@rho.meyering.net>
	<20110415171629.GA9088@infradead.org> <4DA87F43.5040807@redhat.com>
	<20110415172603.GA20086@infradead.org>
	<DD59E27A-FD96-4983-A274-B76CCE99AE7A@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DD59E27A-FD96-4983-A274-B76CCE99AE7A@dilger.ca>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Jim Meyering <jim@meyering.net>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, coreutils@gnu.org, linux-ext4@vger.kernel.org, Eric Blake <eblake@redhat.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Fri, Apr 15, 2011 at 04:28:37PM -0600, Andreas Dilger wrote:
> On 2011-04-15, at 11:26 AM, Christoph Hellwig wrote:
> > On Fri, Apr 15, 2011 at 11:24:19AM -0600, Eric Blake wrote:
> >> Would it be worth borrowing from Solaris' semantics and adding SEEK_HOLE
> >> and SEEK_DATA to lseek(2), as a higher level (less-detailed, but easier
> >> to define and easier to use) interface for discovering the regions of a
> >> file that only contain NUL bytes?
> > 
> > Yes, I've already suggested that both in this thread and on IRC.
> > 
> > For efficient copies it's the only usable interface.
> 
> I suspect that these bugs would have still existed whether the
> interface is SEEK_HOLE/SEEK_DATA, or FIEMAP.  The main problem is
> that the delalloc pages were not accounted for correctly during
> layout traversal..

It's not delalloc that is the problem - XFS accounts for them just
fine in the extent map when asked. However, XFS does speculative
delayed allocation over regions that contain no data, so if the
core-utils folk are assuming that delalloc extents contain data and
need to be copied, they're in for a nasty surprise.

However, every example I've seen in this thread has had to do with
unwritten extents not changing state when data is written into the
page cache. i.e. people are struggling with the expected behaviour
of unwritten extents.

That is, unwritten extent remain unwritten extents until data has
been _physically_ written to them. If there is data in the page
cache over the unwritten extent, it is still an unwritten extent.
If the system crashes while in this state, then the extent _must_
remain an unwritten extent after recovery, otherwise it exposes
stale data.

Further, using FIEMAP to determine where the data is that needs
copying is extremely fragile. What happens when FIEMAP grows a
different type of extent that contains data? cp will break, because
it doesn't think it needs to copy data in extents of an unknown
type. Or it will break because it thinks it needs to copy it and
there's something in it that should not be copied.

Also, cp shoul dnot be trying to replicate the physical layout of
the file when copying it - that's for the filesystem to decide and
having userspace try to do this is a sure recipe for causing severe
filesystem fragmentation. The filesystems already do an excellent
job of optimising allocation - userspace should not be trying to
second guess what is optimal layout for the filesystem.

Fundamentally, what the core-utils guys want is FIEMAP to tell them
where data is in the file, regardless of whether it is in memory or
on disk. That is not what FIEMAP is intended for and matches
SEEK_HOLE/SEEK_DATA precisely.

SEEK_HOLE/SEEK_DATA have very well understood semantics and is
designed specifically for optimising acceess to sparse files. This
interface abstracts all the details of how different filesystems
store their data so the application doesn't need to care about it.
The API is so, so much simpler to use and understand, to. And if the
filesystem has data in cache over an unwritten extent, then by
definition it's still data to be returned by SEEK_DATA. If it fails
to return the range as such then the implementation is broken.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
