Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE1AF7F4E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 17:34:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5591BAC002
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 15:34:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	n0bBzAjXoHJmC1uV for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 15:34:36 -0700 (PDT)
Date: Wed, 21 May 2014 08:33:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/18] xfs: add xfs_da_geometry to inode forks
Message-ID: <20140520223357.GJ8554@dastard>
References: <1399537188-26509-1-git-send-email-david@fromorbit.com>
	<1399537188-26509-19-git-send-email-david@fromorbit.com>
	<20140509073127.GC7882@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140509073127.GC7882@infradead.org>
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

On Fri, May 09, 2014 at 12:31:27AM -0700, Christoph Hellwig wrote:
> On Thu, May 08, 2014 at 06:19:48PM +1000, Dave Chinner wrote:
> > While this might seem wasteful to burn a pointer in the data fork
> > for all files, consider that the geometry information
> > for data allocation can be abstracted from the xfs_mount in exactly
> > the same way as has been done for the directory geometry.
> > Effectively it's a hook to carry allocation policy around in....
> > 
> > So, add the geometry pointer to the inode fork, and initialise is
> > appropriately and use it for all the directory and attribute
> > operation setup instead ofthe xfs_mount version.
> 
> A definitively NAK to bloating the inode without actually making
> use of this.  I can see where you might want to go with this, but
> until we actuall support different dir block sizes per inodes or
> similar, and it actually proves to be useful this is not something
> that should go in.

Yeah, that's fine. it's more just a demonstration of where this
takes us. That said, it's pretty trivial to add directory block size
config to the on-disk format. We can use the high bits of the extent
size hint field so we don't take any more sapce.

That is, di_extsize is a 32 bit field that holds a log2 value of the
hint. The hint is set in bytes via a u32 in the ioctl structure,
so at most can have a value that represents an extent size of 4GB.
That's an ondisk value range of 0-25, which only requires the lower
5 bits of the di_extsize field on disk.

For directories, we currently set the value only with the
XFS_XFLAG_EXTSZINHERIT flag to indicate that the di_extsize hint
field contains the value new children should inherit. If we allow
the XFS_XFLAG_EXTSZ to also be set and use the upper
16 bits of the di_extsize field to indicate the directory block
size, then we have a method for configuring per-directory block
sizes without needing to add any new userspace interfaces....

> The rest of the series looks okay as long as we don't touch the
> inode, but I'll have to do a slightly more detailed review.

I need to clean it up and make it work properly before that. Wait
for the resend. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
