Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ACACF7F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 04:08:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B2DCAC002
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 02:08:48 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yYrUW7WGHPTLenZ8 for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 02:08:45 -0700 (PDT)
Date: Mon, 25 Aug 2014 19:08:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bad performance on touch/cp file on XFS system
Message-ID: <20140825090843.GE20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
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
To: Zhang Qiang <zhangqiang.buaa@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 25, 2014 at 04:47:39PM +0800, Zhang Qiang wrote:
> I have checked icount and ifree, but I found there are about 11.8 percent
> free, so the free inode should not be too few.
> 
> Here's the detail log, any new clue?
> 
> # mount /dev/sda4 /data1/
> # xfs_info /data1/
> meta-data=/dev/sda4              isize=256    agcount=4, agsize=142272384

4 AGs

> icount = 220619904
> ifree = 26202919

And 220 million inodes. There's your problem - that's an average
of 55 million inodes per AGI btree assuming you are using inode64.
If you are using inode32, then the inodes will be in 2 btrees, or
maybe even only one.

Anyway you look at it, searching btrees with tens of millions of
entries is going to consume a *lot* of CPU time. So, really, the
state your fs is in is probably unfixable without mkfs. And really,
that's probably pushing the boundaries of what xfsdump and
xfs-restore can support - it's going to take a long tiem to dump and
restore that data....

With that many inodes, I'd be considering moving to 32 or 64 AGs to
keep the btree size down to a more manageable size. The free inode
btree would also help, but, really, 220M inodes in a 2TB filesystem
is really pushing the boundaries of sanity.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
