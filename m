Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I89MMx164507 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 03:09:22 -0500
Received: from smtp-out-04.shaw.ca (smtp-out-04.shaw.ca [64.59.134.12]) by
	cuda.sgi.com with ESMTP id 8JQtOxgrx5KOAFt7 for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 01:11:00 -0700 (PDT)
Subject: Re: [RFC, PATCH 0/2] fiemap: filesystem free space mapping
Mime-Version: 1.0 (Apple Message framework v1085)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1350537079-16246-1-git-send-email-david@fromorbit.com>
Date: Thu, 18 Oct 2012 02:10:59 -0600
Message-Id: <F8483A1E-AFBD-46C0-BE4E-1C84F65FB29A@dilger.ca>
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 2012-10-17, at 11:11 PM, Dave Chinner wrote:
> So, I was bored a few days ago, and I was sick of having to run
> xfs_db incorrectly report free space extents when the filesytem is
> mounted, so I decided to extend fiemap to export freespace mappings
> to userspace so I could get the information coherently through the
> mounted filesystem.
> 
> Yes, this could probably be considered interface abuse but, well, it
> was simple to do because extent mapping is exactly what fiemap is
> designed to do. Hence I didn't have to write new walkers/formatters
> and I was using code I knew worked correctly.

One question about the usage of this interface - is the ioctl()
called on an open fd for the root inode, or is it called on any
open fd in the filesystem?  In some sense, getting the free space
on the root (or preferably block dev inode if that would work)
would make the most sense, since FIEMAP is intended to be related
to a specific file.

That said, it is a lot easier to use if it can be on any open file
handle in the filesystem, and one could consider the free space as
being related to every file in the filesystem (e.g. for the next
block allocation or defrag migration).

> There are two methods of mapping - one is reporting free space in
> ascending extent start offset order, then other in ascending extent
> length order. Both a useful to have (e.g. defragmenter might want to
> know about the nearest free block to given offset or the largest
> free extent in a given region). Either way, XFS keeps indexes
> ordered in both ways, so they can be exported directly with minimal
> overhead.
> 
> The only "interesting" abuse of the interface is really the use of
> FIEMAP_EXTENT_LAST. This means that the last extent in a freespace
> index is being returned, rather than the last freespace extent. This
> is done because filesystems often have multiple free space indexes,
> and it may be difficult to sort/scan over multiple indexes in a
> single map.

I'm not sure I understand the distinction you are trying to convey here.
Could you elaborate?

> This means an application needs to keep track of what freespace has
> been returned to it and adjust it's fiemap ranges apprpritately, or
> be aware of the underlying filesystem structure to for requests that
> don't span free space indexes. I don't see this a bug problem,
> because any application that is digging in freespace maps needs to
> know how the filesystem is structured to make any sense of the
> infomration returned. As such, I see this interface purely for
> filesystem diagnostics or utilities tightly bound to the filesystem
> (e.g. xfs_fsr).
> 
> I'll attach a patch for a small utility that uses this interace to
> replicate the xfs_db freespace command in a short while so people
> can see how it is used. that shoul dmake it easier to comment on. :)
> 
> Cheers,
> 
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
