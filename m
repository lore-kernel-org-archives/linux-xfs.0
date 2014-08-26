Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EBC287F3F
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 08:14:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE057304059
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 06:14:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nsyDhEQBAUZiFFiU for <xfs@oss.sgi.com>;
	Tue, 26 Aug 2014 06:13:57 -0700 (PDT)
Date: Tue, 26 Aug 2014 23:13:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bad performance on touch/cp file on XFS system
Message-ID: <20140826131354.GK20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
	<20140825090843.GE20518@dastard>
	<CAKEtwsU4gywG7fVVMVU1Y_TG9Pgg_-sFV0=SPg_7Ob5EV6FTew@mail.gmail.com>
	<20140825222657.GF20518@dastard>
	<CAGpXXZL2=ynv4x6hhBSsBPZmBG9Ac8mPOgE-Ekjs3tLvQO9Uaw@mail.gmail.com>
	<20140826023754.GH20518@dastard>
	<CAKEtwsW=6Wh3rdaNvmNbiOq1iUm+=xAwL0FsNhcmpKwkQrN9Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKEtwsW=6Wh3rdaNvmNbiOq1iUm+=xAwL0FsNhcmpKwkQrN9Ww@mail.gmail.com>
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

On Tue, Aug 26, 2014 at 06:04:52PM +0800, Zhang Qiang wrote:
> Thanks Dave/Greg for your analysis and suggestions.
> 
> I can summarize what I should do next:
> 
> - backup my data using xfsdump
> - rebuilt filesystem using mkfs with options: agcount=32 for 2T disk
> - mount filesystem with option inode64,nobarrier

Ok up to here.

> - applied patches about adding free list inode on disk structure

No, don't do that. You're almost certain to get it wrong and corrupt
your filesysetms and lose data.

> As we have about ~100 servers need back up, so that will take much effort,
> do you have any other suggestion?

Just remount them with inode64. Nothing else. Over time as you add
and remove files the inodes will redistribute across all 4 AGs.

> What I am testing (ongoing):
>  - created a new 2T partition filesystem
>  - try to create small files and fill whole spaces then remove some of them
> randomly
>  - check the performance of touch/cp files
>  - apply patches and verify it.
> 
> I have got more data from server:
> 
> 1) flush all cache(echo 3 > /proc/sys/vm/drop_caches), and umount filesystem
> 2) mount filesystem and testing with touch command
>   * The first touch new file command take about ~23s
>   * second touch command take about ~0.1s.

So it's cache population that is your issue. You didn't say that
first time around, which means the diagnosis was wrong. Again, it's having to
search a btree with 220 million inodes in it to find the first free
inode, and that btree has to be pulled in from disk and searched.
Once it's cached, then each subsequent allocation will be much
faster becaue the majority of the tree being searched will already
be in cache...

> I have compared the memory used, it seems that xfs try to load inode bmap
> block for the first time, which take much time, is that the reason to take
> so much time for the first touch operation?

No. reading the AGI btree to find the first free inode to allocate
is what is taking the time. If you spread the inodes out over 4 AGs
(using inode64) then the overhead of the first read will go down
proportionally. Indeed, that is one of the reasons for using more
AGs than 4 for filesystems lik ethis.

Still, I can't help but wonder why you are using a filesystem to
store hundreds of millions of tiny files, when a database is far
better suited to storing and indexing this type and quantity of
data....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
