Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2D08Oli169338 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 19:08:24 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wqMEKOBqrKETCv82 for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 17:08:22 -0700 (PDT)
Date: Tue, 13 Mar 2012 11:08:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 1B files, slow file creation, only AG0 used
Message-ID: <20120313000820.GC5091@dastard>
References: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
	<20120312005632.GY5091@dastard>
	<CAEm1Pvm4+K3dBm+CQad3O2LLYBi76trYx9nBazwv5MNC24sZBg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEm1Pvm4+K3dBm+CQad3O2LLYBi76trYx9nBazwv5MNC24sZBg@mail.gmail.com>
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
To: Michael Spiegle <mike@nauticaltech.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 12, 2012 at 02:54:20PM -0700, Michael Spiegle wrote:
> I believe we figured out what was going wrong:
> 1) You definitely need inode64 as a mount option
> 2) It seems that the AG metadata was being cached.  We had to unmount
> the system and remount it to get updated counts on per-AG usage.

If you were looking at it with xfs_db, then yes, that is what will
happen. Use "echo 1 > /proc/sys/vm/drop_caches" to get the cached
metadata dropped.

> For the moment, I've written a script to copy/rename/delete our files
> so that they are gradually migrated to new AGs.  FWIW, I noticed that
> this operation is significantly faster on an EL6.2-based kernel
> (2.6.32) compared to EL5 (2.6.18).  I'm also using the 'delaylog'
> mount option which probably helps a bit.  I still have a few other
> curiosities about this particular issue though:
> 
> On Sun, Mar 11, 2012 at 5:56 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Entirely normal. some operations require Io to complete (e.g.
> > reading directory blocks to find where to insert the new entry),
> > while adding the first file to a directory generally requires zero
> > IO. You're seeing the difference between cold cache and hot cache
> > performance.
> >
> 
> In this situation, any files written to the same directory exhibited
> this issue regardless of cache state.  For example:
> 
> Takes 300ms to complete:
> touch tmp/0
> 
> Takes 600ms to complete:
> touch tmp/0 tmp/1
> 
> Takes 1200ms to complete:
> touch tmp/0 tmp/1 tmp/2 tmp/3
> 
> I would expect the directory to be cached after the first file is
> created.  I don't understand why all subsequent writes were affected
> as well.

I don't have enough information to help you. I don't know what
hardware you are running on, how big the directory is, what they
layout of the directory is, etc. The "needs to do IO" was simply a
SWAG....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
