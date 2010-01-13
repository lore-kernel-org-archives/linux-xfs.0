Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DN2UC9198933 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 17:02:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B544EF05B7B
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 15:03:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	oSdGArD7xlMvEiQT for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 15:03:25 -0800 (PST)
Date: Thu, 14 Jan 2010 10:03:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: xfs_swap_extents needs to handle dynamic fork offsets
Message-ID: <20100113230322.GS17483@discord.disaster>
References: <20100112130922.GA30985@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A6965@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6965@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 13, 2010 at 04:32:12PM -0600, Alex Elder wrote:
> Christoph Hellwig wrote:
> >> +	TP_printk("dev %d:%d %s inode 0x%llx, %s format, num_extents %d, "
> >> +		  "Max in-fork extents %d, broot size %d, fork offset %d",
> > 
> > It would be nice to keep the
> > 
> > 	"dev %d:%d ino 0x%llx"
> > 
> > prefix as a convention so that all trace records are similar at their
> > beginning.
> 
> Perhaps:
>     +	TP_printk("dev %d:%d inode 0x%llx (%s), %s format, num_extents %d, " 
>                                           ^
>                                           +--- symbolic entry->which
> 
> >>  #undef TRACE_INCLUDE_PATH
> >> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> >> @@ -53,7 +53,7 @@ xfs_swapext(
> >>  	xfs_swapext_t	*sxp)
> >>  {
> >>  	xfs_inode_t     *ip, *tip;
> >> -	struct file	*file, *target_file;
> >> +	struct file	*file, *tmp_file;
> > 
> > I think these xfs_swapext belong into a separate patch.  While they
> > make the code quite a bit more redable they're purely cleanups and
> > can wait for 2.6.34.  And while you're at it you might also want to
> > merge xfs_swap_extents into xfs_swapext - there's no need for that
> > split at all.
> 
> I agree.  The change here is good (it was confusing and wrong before).

I think this is all a bit crazy - I had to make this change before I
could understand the code clearly enough to fix the bug. I had to go
all the way back to xfs_fsr to work out what it was providing the
kernel to determine WTF the kernel code was doing.

Clarifying the temp/target inodes is especially important because
the bug fix results in enforcing the target/temp inode ordering by
checking the temp inode has less extents than the target otherwise
it will reject the swap. If you can't tell which inode is which,
how can you tell the code is correct?

> But Dave can you please re-submit this with only the critical changes
> so I can get them to Linus in this release cycle?  I think the trace
> addition is probably fine, just get rid of the gratuitous variable
> name change in xfs_swapext() and put that in a separate patch.

The tracing is there so if someone reports a problem with the new
code we can easily determine if the correct action was taken by
swap extents or whether there's some condition I haven't handled.

I'll split it out into three patches - the bug fix, the rename
and the tracing code so you can pick and chose which ones you want
to take first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
