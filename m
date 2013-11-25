Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F82B7F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 02:51:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4DA358F8039
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 00:51:03 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kUoJ2EpIx8VvmoKP for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 00:51:01 -0800 (PST)
Date: Mon, 25 Nov 2013 19:50:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: defer EFI and EFD log formatting until
	iop_format time
Message-ID: <20131125085049.GB8803@dastard>
References: <20131123151151.716201348@bombadil.infradead.org>
	<20131123151534.204073240@bombadil.infradead.org>
	<20131124091830.GA6253@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131124091830.GA6253@infradead.org>
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

On Sun, Nov 24, 2013 at 01:18:30AM -0800, Christoph Hellwig wrote:
> On Sat, Nov 23, 2013 at 07:11:56AM -0800, Christoph Hellwig wrote:
> > No need to allocate large chunks of memory to format each extent into
> > an array when logging the EFI or EFD items.  Instead just point to the
> > bmap free list and only generate the log format at iop_format time.
> > 
> > Also get rid of the now almost empty xfs_trans_extfree.c by merging it
> > into xfs_extfree_item.c.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Turns out this version can fairly easily cause use after frees, so it'll
> need a bit of an overhaul to get the lifetime rules right.

Yeah, you can't use the freelist structure like that - it's a
linked, which you copy the freelist structure when logging the
EFI/EFD, and then free the items on the linked list. Then when
formatting the structure, you walk the list attached to the copy of
the freelist structure, which has alreayd been freed.

Basically, we've got a bunch of nasty life cycle issues around the
EFI/EFD that need to be fixed. Firstly, the EFD code assumes that
the EFI always outlives it, but we don't take a reference when we
connect the EFD to the EFI - the EFI is created with the reference
for the EFD already added to it. Then in abort cases we simply free
the EFI, even though there may be an EFD that still references it...

So I think that this needs to be fixed up before you can even
consider sharing something like a reference counted freelist
structure between the EFI/EFD structures....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
