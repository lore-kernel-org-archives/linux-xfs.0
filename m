Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL0qDKr200298 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 18:52:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F2991CE2402
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 16:54:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	l9LoxzYTdevWMr3O for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 16:54:08 -0800 (PST)
Date: Tue, 21 Dec 2010 11:54:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_efi_item slab leak
Message-ID: <20101221005405.GN5193@dastard>
References: <AANLkTi=LrU2CsC-VZmJ5M9U7eJpjqfAv8UgaEYv=Sg01@mail.gmail.com>
	<20101218000245.GG5193@dastard>
	<20101220113139.GA10324@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101220113139.GA10324@infradead.org>
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
Cc: Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com

On Mon, Dec 20, 2010 at 06:31:39AM -0500, Christoph Hellwig wrote:
> On Sat, Dec 18, 2010 at 11:02:45AM +1100, Dave Chinner wrote:
> > Ok, after unmounting everything I can see two items in remaining in
> > the xfs_efi_item cache after an xfstests run. ??t's probably to do
> > with a filesystem shutdown not cleaning them up correctly. I'll put
> > it on my list of stuff to track down.
> 
> Does it still happen with your working tree?  The incorrect handling
> of IOP_UNPING with remove == 1 looks like it could cause something
> similar.

I haven't checked the current patch set - just on the kernel that I
was currently running - I'll do more analysis later this afternoon.
I agree that the IOP_UNPIN() handling is a likely culprit, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
