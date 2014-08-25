Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F6FC7F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 17:27:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D44B8F8050
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 15:27:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PAzwso3CTMSf5Q6z for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 15:27:02 -0700 (PDT)
Date: Tue, 26 Aug 2014 08:26:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bad performance on touch/cp file on XFS system
Message-ID: <20140825222657.GF20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
	<20140825090843.GE20518@dastard>
	<CAKEtwsU4gywG7fVVMVU1Y_TG9Pgg_-sFV0=SPg_7Ob5EV6FTew@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKEtwsU4gywG7fVVMVU1Y_TG9Pgg_-sFV0=SPg_7Ob5EV6FTew@mail.gmail.com>
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

On Mon, Aug 25, 2014 at 06:31:10PM +0800, Zhang Qiang wrote:
> 2014-08-25 17:08 GMT+08:00 Dave Chinner <david@fromorbit.com>:
> 
> > On Mon, Aug 25, 2014 at 04:47:39PM +0800, Zhang Qiang wrote:
> > > I have checked icount and ifree, but I found there are about 11.8 percent
> > > free, so the free inode should not be too few.
> > >
> > > Here's the detail log, any new clue?
> > >
> > > # mount /dev/sda4 /data1/
> > > # xfs_info /data1/
> > > meta-data=/dev/sda4              isize=256    agcount=4, agsize=142272384
> >
> > 4 AGs
> >
> Yes.
> 
> >
> > > icount = 220619904
> > > ifree = 26202919
> >
> > And 220 million inodes. There's your problem - that's an average
> > of 55 million inodes per AGI btree assuming you are using inode64.
> > If you are using inode32, then the inodes will be in 2 btrees, or
> > maybe even only one.
> >
> 
> You are right, all inodes stay on one AG.
> 
> BTW, why i allocate 4 AGs, and all inodes stay in one AG for inode32?,

Because the top addresses in the 2nd AG go over 32 bits, hence only
AG 0 can be used for inodes. Changing to inode64 will give you some
relief, but any time allocation occurs in AG0 is will be slow. i.e.
you'll be trading always slow for "unpredictably slow".

> > With that many inodes, I'd be considering moving to 32 or 64 AGs to
> > keep the btree size down to a more manageable size. The free inode
> 
> btree would also help, but, really, 220M inodes in a 2TB filesystem
> > is really pushing the boundaries of sanity.....
> >
> 
> So the better inodes size in one AG is about 5M,

Not necessarily. But for your storage it's almost certainly going to
minimise the problem you are seeing.

> is there any documents
> about these options I can learn more?

http://xfs.org/index.php/XFS_Papers_and_Documentation

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
