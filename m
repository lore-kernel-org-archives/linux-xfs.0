Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D7uebM008626 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 02:56:40 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eABGVt2u7N5TSgwC for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 00:56:38 -0700 (PDT)
Date: Fri, 13 Apr 2012 17:56:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120413075634.GD6734@dastard>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
	<CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
	<20120413071905.GA823@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120413071905.GA823@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: David Fuller <dfuller@epoch.com>, xfs@oss.sgi.com

On Fri, Apr 13, 2012 at 08:19:05AM +0100, Brian Candler wrote:
> On Thu, Apr 12, 2012 at 05:09:40PM -0700, David Fuller wrote:
> >    The total LVM volume group is 4.5 TB.  The logical volume is around
> >    2.3TB where the mysql data
> 
> Hence you have a 2.3TB XFS filesystem? You need inode64.  The side warning
> "performance sucks" is very true. 

In some cases.

You can't just blindly assert that something is needed purely on
the size of the filesystem. Much more information is needed such as
block maps, which files the database regularly uses, how large those
files are, how they are laid out in the directory structure, etc.

For a workload with lots of files and directories, inode64 will be
better, but for a database with realtively few large files the
locality that inode64 gives you may not be any advantage at all.

And sometimes inode32 is the best option available because it
effectievly separates data from metadata until the filesystem is
nearly full.

> In particular, if you create a bunch of
> files in the same directory, without inode64 XFS will scatter the extents
> all over the disk

It doesn't scatter them randomly like you are implying - it places
each subsequent new file in a different AG to balance the data load
across the entire filesystem address space. If you are writing lots
of large files in parallel, that's *exactly* the behaviour you want
to minimise fragmentation and maximise back end drive utilisation.

> rather than trying to allocate them next to each other

Which has always caused much more file fragmentation than the
inode32 style of allocation. That's why we have much more aggressive
speculative delayed allocation now - to make concurrent file writes
behaviour and fragmentation much more like the inode32 allocator
without destroying locality too much.

> (possibly not a problem if you're only storing mysql data chunks though)

Almost definitely not a problem, which is exactly why I'm responding
here. inode64 is not the right solution for every problem, and
there's much more to selecting the right allocation policy for your
workloads than just looking at filesystem size.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
