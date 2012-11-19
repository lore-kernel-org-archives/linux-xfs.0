Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAJNrRS4071071 for <xfs@oss.sgi.com>; Mon, 19 Nov 2012 17:53:27 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wZ1KwdZ1nsKf1rLk for <xfs@oss.sgi.com>;
	Mon, 19 Nov 2012 15:55:35 -0800 (PST)
Date: Tue, 20 Nov 2012 10:55:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
Message-ID: <20121119235530.GY14281@dastard>
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121119213913.GB29498@quack.suse.cz>
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
Cc: xfs@oss.sgi.com

On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:
> On Tue 13-11-12 01:36:13, Jan Kara wrote:
> > When project quota gets exceeded xfs_iomap_write_delay() ends up flushing
> > inodes because ENOSPC gets returned from xfs_bmapi_delay() instead of EDQUOT.
> > This makes handling of writes over project quota rather slow as a simple test
> > program shows:
> > 	fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > 	for (i = 0; i < 50000; i++)
> > 		pwrite(fd, buf, 4096, i*4096);
> > 
> > Writing 200 MB like this into a directory with 100 MB project quota takes
> > around 6 minutes while it takes about 2 seconds with this patch applied. This
> > actually happens in a real world load when nfs pushes data into a directory
> > which is over project quota.
> > 
> > Fix the problem by replacing XFS_QMOPT_ENOSPC flag with XFS_QMOPT_EPDQUOT.
> > That makes xfs_trans_reserve_quota_bydquots() return new error EPDQUOT when
> > project quota is exceeded. xfs_bmapi_delay() then uses this flag so that
> > xfs_iomap_write_delay() can distinguish real ENOSPC (requiring flushing)
> > from exceeded project quota (not requiring flushing).
> > 
> > As a side effect this patch fixes inconsistency where e.g. xfs_create()
> > returned EDQUOT even when project quota was exceeded.
>   Ping? Any opinions?

Busy, haven't had a chance to look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
