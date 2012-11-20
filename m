Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKKIVpQ208926 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 14:18:31 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eYq3KbENCrAz6jQp for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 12:20:40 -0800 (PST)
Date: Wed, 21 Nov 2012 07:20:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
Message-ID: <20121120202038.GF2591@dastard>
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
	<20121120161511.GE27055@sgi.com>
	<20121120170354.GF1408@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120170354.GF1408@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Tue, Nov 20, 2012 at 06:03:54PM +0100, Jan Kara wrote:
> On Tue 20-11-12 10:15:11, Ben Myers wrote:
> > Hi Jan,
> > 
> > On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:
> > > On Tue 13-11-12 01:36:13, Jan Kara wrote:
> > > > When project quota gets exceeded xfs_iomap_write_delay() ends up flushing
> > > > inodes because ENOSPC gets returned from xfs_bmapi_delay() instead of EDQUOT.
> > > > This makes handling of writes over project quota rather slow as a simple test
> > > > program shows:
> > > > 	fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > > > 	for (i = 0; i < 50000; i++)
> > > > 		pwrite(fd, buf, 4096, i*4096);
> > > > 
> > > > Writing 200 MB like this into a directory with 100 MB project quota takes
> > > > around 6 minutes while it takes about 2 seconds with this patch applied. This
> > > > actually happens in a real world load when nfs pushes data into a directory
> > > > which is over project quota.
> > > > 
> > > > Fix the problem by replacing XFS_QMOPT_ENOSPC flag with XFS_QMOPT_EPDQUOT.
> > > > That makes xfs_trans_reserve_quota_bydquots() return new error EPDQUOT when
> > > > project quota is exceeded. xfs_bmapi_delay() then uses this flag so that
> > > > xfs_iomap_write_delay() can distinguish real ENOSPC (requiring flushing)
> > > > from exceeded project quota (not requiring flushing).
> > > > 
> > > > As a side effect this patch fixes inconsistency where e.g. xfs_create()
> > > > returned EDQUOT even when project quota was exceeded.
> > >   Ping? Any opinions?
> > 
> > I think that there may be good reason to flush inodes even in the project quota
> > case.  Speculative allocation beyond EOF might need to be cleaned up.

The flushing at ENOSPC doesn't clear up speculative preallocation.
It writes back data which releases metadata reservations that
delalloc extents hold in addition to the data. The reservations are
held so that tree splits during allocation have block reserved and
we don't ENOSPC on delalloc all the time.

> >
> > I'm all
> > for passing back some data about why we hit ENOSPC.  Then we can combine this
> > with Brian Foster's work and flush only inodes that touch a given project,
> > user, or group quota.

Brian had more patches that throttled specualtive prealloc when
quota got low, as well as triggered a specific specualtive
allocation trimming passes when EDQUOT is hit. This will remove the
global inode flush from the project uota cae when it is done.

>   Yes, I agree flushing might be useful even for project quota but then why
> don't we flush inodes also for user quota?

It's by design. Directory tree quota is used as a method of
exporting multiple sub-dirs from a single filesystem but having them
appear to NFS clients just like a standalone filesystem. Hence when
you run out of projet quota, it is treated like an ENOSPC condition
for the directory sub-tree - it flushes as much of the metadata
reservations out as possible to maximise the data space for the
directory tree.

For user/group quotas, this requirement of behaving like a
standalone filesystem does not exist, and so when you EDQUOT a
user/group there is no need to reclaim metadata reservations to make
more data space available....

> Also the performance impact
> is really huge - and here I agree that unless you are writing over NFS you
> won't notice because only NFS tries to push X MB to the filesystem page by
> page only to get ENOSPC each time...

The problem is the speculative allocation can trigger this behaviour
prematurely and repeatedly. That's where Brians prealloc throttle
patches come in - it reduces the occurrence of ENOSPC as the quota
limit is approached, and hence reduces the number of inode flushes.

> And NFS is arguably doing a stupid
> thing but it is a common setup and you don't always have the freedom to fix
> clients to be more clever. So I'd be happy if XFS accomodated such use.

Sure, but there's more to it than just avoiding the inode flush,
unfortunately...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
