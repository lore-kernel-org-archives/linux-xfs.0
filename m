Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAA1C7F3F
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 21:09:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8D7B304053
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 19:09:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ofcXLaG9Ar92eNxo for <xfs@oss.sgi.com>;
	Wed, 27 Aug 2014 19:09:10 -0700 (PDT)
Date: Thu, 28 Aug 2014 12:08:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bad performance on touch/cp file on XFS system
Message-ID: <20140828020819.GQ20518@dastard>
References: <20140825051801.GY26465@dastard>
	<CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
	<20140825090843.GE20518@dastard>
	<CAKEtwsU4gywG7fVVMVU1Y_TG9Pgg_-sFV0=SPg_7Ob5EV6FTew@mail.gmail.com>
	<20140825222657.GF20518@dastard>
	<CAGpXXZL2=ynv4x6hhBSsBPZmBG9Ac8mPOgE-Ekjs3tLvQO9Uaw@mail.gmail.com>
	<20140826023754.GH20518@dastard>
	<CAKEtwsW=6Wh3rdaNvmNbiOq1iUm+=xAwL0FsNhcmpKwkQrN9Ww@mail.gmail.com>
	<20140826131354.GK20518@dastard>
	<CAKEtwsVwXq4NXcGKCXob-qte3AT2MJ6qgzPB9Sb5Av12WxjCMw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKEtwsVwXq4NXcGKCXob-qte3AT2MJ6qgzPB9Sb5Av12WxjCMw@mail.gmail.com>
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
Cc: Greg Freemyer <greg.freemyer@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 27, 2014 at 04:53:17PM +0800, Zhang Qiang wrote:
> 2014-08-26 21:13 GMT+08:00 Dave Chinner <david@fromorbit.com>:
> 
> > On Tue, Aug 26, 2014 at 06:04:52PM +0800, Zhang Qiang wrote:
> > > Thanks Dave/Greg for your analysis and suggestions.
> > >
> > > I can summarize what I should do next:
> > >
> > > - backup my data using xfsdump
> > > - rebuilt filesystem using mkfs with options: agcount=32 for 2T disk
> > > - mount filesystem with option inode64,nobarrier
> >
> > Ok up to here.
> >
> > > - applied patches about adding free list inode on disk structure
> >
> > No, don't do that. You're almost certain to get it wrong and corrupt
> > your filesysetms and lose data.
> >
> > > As we have about ~100 servers need back up, so that will take much
> > effort,
> > > do you have any other suggestion?
> >
> > Just remount them with inode64. Nothing else. Over time as you add
> > and remove files the inodes will redistribute across all 4 AGs.
> >
> OK.
> 
> How I can see  the layout number of inodes on each AGs? Here's my checking
> steps:
> 
> 1) Check unmounted file system first:
> [root@fstest data1]# xfs_db -c "sb 0"  -c "p" /dev/sdb1 |egrep
> 'icount|ifree'
> icount = 421793920
> ifree = 41
> [root@fstest data1]# xfs_db -c "sb 1"  -c "p" /dev/sdb1 |egrep
> 'icount|ifree'
> icount = 0
> ifree = 0

That's wrong. You need to check the AGI headers, not the superblock.
Only the primary superblock gets updated, and it's the aggregated of
all the AGI values, not the per AG values.

And, BTW, that's *421 million* inodes in that filesystem. Almost
twice as many as the filesystem you started showing problems on...

> OK, this is a social networking website back end servers, actually the CDN
> infrastructure, and different server located different cities.
> We have a global sync script to make all these 100 servers have the same
> data.
> 
> For each server we use RAID10 and XFS (CentOS6.3).
> 
> There are about 3M files (50K in size) generated every day, and we track
> the path of each files in database.

I'd suggest you are overestimating the size of the files being
storedi by an order of magnitude: 200M files at 50k in size is 10TB,
not 1.5TB.

But you've confirmed exactly what I thought - you're using the
filesystem as an anonymous object store for hundreds of millions of
small objects and that's exactly the situation I'd expect to see
these problems....

> Do you have any suggestions to improve our solution?

TANSTAAFL.

I've given you some stuff to try, worst case is reformating and
recopying all the data around. I don't really have much time to do
much more than that - talk to Red Hat (because you are using CentOS)
if you want help with a more targeted solution to your problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
