Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48MVXfG032951 for <xfs@oss.sgi.com>; Tue, 8 May 2012 17:31:34 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	R79XvNOZ60PKieRI for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 15:31:31 -0700 (PDT)
Date: Wed, 9 May 2012 08:31:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate bug?
Message-ID: <20120508223127.GH5091@dastard>
References: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
	<20120507235955.GE5091@dastard>
	<CAF7KpS_02NjAzY1wOQ9U0kwjKH+SzA0O_3VqSfjJgv0P6Hjk=g@mail.gmail.com>
	<20120508044039.GF5091@dastard>
	<CAF7KpS906EpxfAMjzW1zx8fSdGacoxkg+Fz=P0Sb3yONMhe7gw@mail.gmail.com>
	<20120508054703.GG5091@dastard>
	<CAF7KpS8oyteCDFM9tYWMp1K_vVeD0LTCY+10dSEiM_99KU9sJw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF7KpS8oyteCDFM9tYWMp1K_vVeD0LTCY+10dSEiM_99KU9sJw@mail.gmail.com>
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
To: Zhu Han <schumi.han@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, May 08, 2012 at 11:25:05PM +0800, Zhu Han wrote:
> On Tue, May 8, 2012 at 1:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Tue, May 08, 2012 at 01:10:55PM +0800, Zhu Han wrote:
> > > On Tue, May 8, 2012 at 12:40 PM, Dave Chinner <david@fromorbit.com>
> > wrote:
> > > > On Tue, May 08, 2012 at 11:24:52AM +0800, Zhu Han wrote:
> > > > > On Tue, May 8, 2012 at 7:59 AM, Dave Chinner <david@fromorbit.com>
> > > > wrote:
> > > > > > And so now you've triggered the speculative delayed allocation
> > > > > > beyond EOF, which is normal behaviour. Hence there are currently
> > > > > > unused blocks beyond EOF which will get removed either when the
> > next
> > > > > > close(fd) occurs on the file or the inode is removed from the
> > cache.
> > > > > >
> > > > >
> > > > > Close(fd) should be invoked before dd quits. But why the extra blocks
> > > > > beyond EOF are not freed?
> > > >
> > > > The removal is conditional on how many times the fd has been closed
> > > > with dirty data on the inode.
> > > >
> > > > > The only way I found to remove the extra blocks is truncate the file
> > to
> > > > its
> > > > > real size.
> > > >
> > > > If the close() didn't remove them, they will be removed when the
> > > > inode ages out of the cache. Why do you even care about them?
> > >
> > > Our distributed system depends on the real length of files to account the
> > > space usage.
> >
> > That's ..... naive. It's never been valid to assume that the file
> > size is an accurate reflection of space usage, especially as it will
> > *always* be wrong for sparse files. In the same light, you also
> > cannot assume that it is an accurate reflection for non-sparse files
> > because we can do both explicit and speculative allocation beyond
> > EOF which only du will show. Not to mention that metadata is not
> > accounted in the file length, and that can consume a significant
> > amount of space, too.
> >
> > > This behavior make the account inaccurate.
> >
> > The block usage reported by XFS is both accurate and correct. The
> > file size reported by XFS is both accurate and correct. You're
> > "account inaccuracy" is assuming that they are the same. Perhaps you
> > should be using quotas for accurate space usage accounting?
> >
> > Anyway, if you really want to stop speculative delayed allocation
> > beyond EOF, then use the allocsize mount option to control it.
> >
> 
> 
> Thanks for help.
> 
> I can control the size of pre-allocation, so no data are written beyond the
> pre-allocated block range, so no speculative allocation is triggered.
> Besides it, our system can sync the accurate space usage of mount point
> periodically.
> 
> Can you give any hints about the most lightweight approach to get the
> accurate block usage of whole file system?

If you are just after the whole filesystem, then statfs(2) will give
you blocks used and free. If you are after a finer breakdown, then
quotas are probably what you want - they can be used for accounting
separately to the space limiting enforcement. Hence you get
accurate, up-to-date per user, group or project space accounting
without actually limiting space usage at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
