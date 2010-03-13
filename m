Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2D0NhDo039493 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 18:23:43 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 271F914252C8
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 16:25:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	4dz5Z7wZJJvFFGq3 for <xfs@oss.sgi.com>;
	Fri, 12 Mar 2010 16:25:14 -0800 (PST)
Date: Sat, 13 Mar 2010 11:25:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100313002511.GF4732@dastard>
References: <4B92C71C.5010003@dermichi.com>
	<20100308000601.GF28189@discord.disaster>
	<4B94EADD.2080108@dermichi.com> <4B953D3F.3090002@sandeen.net>
	<4B975C5C.5090806@dermichi.com> <20100311233934.GB4732@dastard>
	<4B9A0D2F.30506@dermichi.com>
	<20100312100019.GA13230@infradead.org>
	<20100312115645.GD4732@dastard>
	<20100312142737.GA16244@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100312142737.GA16244@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Michael Weissenbacher <mw@dermichi.com>, xfs@oss.sgi.com

On Fri, Mar 12, 2010 at 09:27:37AM -0500, Christoph Hellwig wrote:
> On Fri, Mar 12, 2010 at 10:56:45PM +1100, Dave Chinner wrote:
> > ->page_mkwrite executes without the inode iolock held, so we can't
> > lock it out from creating new delalloc pages by holding the iolock
> > like the bmap code does.
> > 
> > I don't think we're allowed to take the iolock in ->page_mkwrite, so
> > effectively that leaves us with the situation where we can't do an
> > atomic flush and map in the bmap code.
> > 
> > Christoph, I guess that means we need to make the bmap code
> > handle/ignore delalloc extents rather than assume they never occur
> > after the flush.  What do you think?
> 
> The current swapext code is supposed to skip any file that is mapped
> into userspace via mmap.  So if you get a file that is actually mmaped
> something is wrong with that check.  From a quick look the only problem
> I see is that we don't take the iolock in ->mmap so we could add a new
> mapping after the check, but I'd be surprise if that is what Michael
> is seeing.

The swapext mmap check occurs a long time after we actually get the
extents from the file, so while the swapext will fail that check,
we're not getting to it. i.e. we're assert failing during the setup
for the data move before we do the swapext. Perhaps we should make
xfs_getbmap() return EBUSY for mmap()d files like swapext does?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
