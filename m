Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2CEQ9LK260640 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 08:26:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ACCB235C11
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 06:27:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id a8N4i9WCZzuUuAV4 for
	<xfs@oss.sgi.com>; Fri, 12 Mar 2010 06:27:43 -0800 (PST)
Date: Fri, 12 Mar 2010 09:27:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100312142737.GA16244@infradead.org>
References: <20100304222611.GK14317@discord.disaster>
	<4B92C71C.5010003@dermichi.com>
	<20100308000601.GF28189@discord.disaster>
	<4B94EADD.2080108@dermichi.com> <4B953D3F.3090002@sandeen.net>
	<4B975C5C.5090806@dermichi.com> <20100311233934.GB4732@dastard>
	<4B9A0D2F.30506@dermichi.com>
	<20100312100019.GA13230@infradead.org>
	<20100312115645.GD4732@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100312115645.GD4732@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Michael Weissenbacher <mw@dermichi.com>, xfs@oss.sgi.com

On Fri, Mar 12, 2010 at 10:56:45PM +1100, Dave Chinner wrote:
> ->page_mkwrite executes without the inode iolock held, so we can't
> lock it out from creating new delalloc pages by holding the iolock
> like the bmap code does.
> 
> I don't think we're allowed to take the iolock in ->page_mkwrite, so
> effectively that leaves us with the situation where we can't do an
> atomic flush and map in the bmap code.
> 
> Christoph, I guess that means we need to make the bmap code
> handle/ignore delalloc extents rather than assume they never occur
> after the flush.  What do you think?

The current swapext code is supposed to skip any file that is mapped
into userspace via mmap.  So if you get a file that is actually mmaped
something is wrong with that check.  From a quick look the only problem
I see is that we don't take the iolock in ->mmap so we could add a new
mapping after the check, but I'd be surprise if that is what Michael
is seeing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
