Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 622397F91
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 17:22:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 440448F8049
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 15:22:50 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sXcYQvN4I7HRf9EA for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 15:22:48 -0800 (PST)
Date: Tue, 5 Nov 2013 10:22:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/30 V2] libxfs: fix root inode handling inconsistencies
Message-ID: <20131104232242.GS6188@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-26-git-send-email-david@fromorbit.com>
	<20131030102318.GA31519@infradead.org>
	<20131030215940.GH6188@dastard> <20131031041343.GK6188@dastard>
	<20131031150024.GP22359@infradead.org>
	<20131031220438.GP4446@dastard>
	<20131101130316.GB14898@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131101130316.GB14898@infradead.org>
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

On Fri, Nov 01, 2013 at 06:03:16AM -0700, Christoph Hellwig wrote:
> On Fri, Nov 01, 2013 at 09:04:38AM +1100, Dave Chinner wrote:
> > > > -	if ((flags & LIBXFS_MOUNT_ROOTINOS) && sbp->sb_rootino != NULLFSINO &&
> > > > +	if (sbp->sb_rootino != NULLFSINO &&
> > > >  	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > 
> > > Oh, I hadn't noticed that LIBXFS_MOUNT_ROOTINOS does more than reading
> > > the root inode.  Seems like mkfs might need the rt inodes if a file with
> > > the rt flag is specified in the proto file.
> > 
> > mkfs always allocates the rt inodes directly after the root
> > directory is created.
> 
> True, we obviosuly create them in mkfs.  In fact looking over the code
> the only call into the rtalloc code in userspace ever is mkfs
> initializing those using libxfs_rtfree_extent.
> 
> So removing the call to rtmount_inodes is fine, and we should remove
> the declaration of it as well as it's now unused.

You are right, they are otherwise unused. repair and db just look at
the raw inode numbers, and do direct libxfs_iget calls to get an
xfs_inode and hence don't use the cached values at all. I'll kill it
completely, then.

> In the future I
> suspect we should simplify the mkfs code to not even require
> xfs_rtalloc.c for just marking the inodes as entirely free, but that's
> not something for this series.

Yeah, it seems that way - xfs_repair does all the rebuild itself
without needing the libxfs code, so that seems quite doable.

> > > I can't see how xfs_copy could need either the rt inodes nor the perag
> > > data.
> > 
> > Right, it doesn't need them, but it doesn't hurt at all to
> > initialise them because all the ag headers are about to be read to
> > find all the used space, anyway.
> 
> xfs_initialize_perag_data does the following:
> 
>  - read in AGI/AGF.  This is something we lazily do whenever we need it
>    anyway, so no one should rely on it.
>  - update the in-core superblock global counters.  Seems like the old
>    xfs_check relies on this and still needs an equivalent if we care
>    enough.  No one else seems to care.

So you are suggesting that I move that initialisation to the
xfs_check code rather than just doing it in the mount code? Or
something else?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
