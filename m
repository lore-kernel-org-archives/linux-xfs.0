Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77BA97F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 03:56:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17068AC002
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 01:56:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Hn6vM6H65bkVG1O0 for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 01:56:19 -0700 (PDT)
Date: Mon, 25 Aug 2014 18:56:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bad performance on touch/cp file on XFS system
Message-ID: <20140825085616.GD20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsWWoJ4QK1Od4WUT+hx7iFeX2bKfXk3QF9f2yG6vJ+TgxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKEtwsWWoJ4QK1Od4WUT+hx7iFeX2bKfXk3QF9f2yG6vJ+TgxQ@mail.gmail.com>
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

On Mon, Aug 25, 2014 at 04:09:05PM +0800, Zhang Qiang wrote:
> Thanks for your quick and clear response. Some comments bellow:
> 
> 
> 2014-08-25 13:18 GMT+08:00 Dave Chinner <david@fromorbit.com>:
> 
> > On Mon, Aug 25, 2014 at 11:34:34AM +0800, Zhang Qiang wrote:
> > > Dear XFS community & developers,
> > >
> > > I am using CentOS 6.3 and xfs as base file system and use RAID5 as
> > hardware
> > > storage.
> > >
> > > Detail environment as follow:
> > >    OS: CentOS 6.3
> > >    Kernel: kernel-2.6.32-279.el6.x86_64
> > >    XFS option info(df output): /dev/sdb1 on /data type xfs
> > > (rw,noatime,nodiratime,nobarrier)
....

> > > It's very greatly appreciated if you can give constructive suggestion
> > about
> > > this issue, as It's really hard to reproduce from another system and it's
> > > not possible to do upgrade on that online machine.
> >
> > You've got very few free inodes, widely distributed in the allocated
> > inode btree. The CPU time above is the btree search for the next
> > free inode.
> >
> > This is the issue solved by this series of recent commits to add a
> > new on-disk free inode btree index:
> >
> [Qiang] This meas that if I want to fix this issue, I have to apply the
> following patches and build my own kernel.

Yes. Good luck, even I wouldn't attempt to do that.

And then use xfsprogs 3.2.1, and make a new filesystem that enables
metadata CRCs and the free inode btree feature.

> As the on-disk structure has been changed, so should I also re-create xfs
> filesystem again?

Yes, you need to download the latest xfsprogs (3.2.1) to be able to
make it with the necessary feature bits set.

> is there any user space tools to convert old disk
> filesystem to new one, and don't need to backup and restore currently data?

No, we don't write utilities to mangle on disk formats. dump, mkfs
and restore is far more reliable than any "in-place conversion" code
we could write. It will probably be faster, too.

> > Which is of no help to you, however, because it's not available in
> > any CentOS kernel.
> >
> [Qiang] Do you think if it's possible to just backport these patches to
> kernel  6.2.32 (CentOS 6.3) to fix this issue?
> 
> Or it's better to backport to 3.10 kernel, used in CentOS 7.0?

You can try, but if you break it you get to keep all the pieces
yourself. Eventually someone who maintains the RHEL code will do a
backport that will trickle down to CentOS. If you need it any
sooner, then you'll need to do it yourself, or upgrade to RHEL
and ask your support contact for it to be included in RHEL 7.1....

> > There's really not much you can do to avoid the problem once you've
> > punched random freespace holes in the allocated inode btree. IT
> > generally doesn't affect many people; those that it does affect are
> > normally using XFS as an object store indexed by a hard link farm
> > (e.g. various backup programs do this).
> >
> OK, I see.
> 
> Could you please guide me to reproduce this issue easily? as I have tried
> to use a 500G xfs partition, and use about 98 % spaces, but still can't
> reproduce this issue. Is there any easy way from your mind?

Search the archives for the test cases that were used for the patch
set. There's a performance test case documented in the review
discussions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
