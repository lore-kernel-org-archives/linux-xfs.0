Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK02M74072461 for <xfs@oss.sgi.com>; Mon, 19 Nov 2012 18:02:22 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GZAKBmGkRMfHqxW9 for <xfs@oss.sgi.com>;
	Mon, 19 Nov 2012 16:04:30 -0800 (PST)
Date: Tue, 20 Nov 2012 11:04:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
Message-ID: <20121120000428.GZ14281@dastard>
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

FWIW, it doesn't look like it'll apply to a current XFs tree:

> > @@ -441,8 +442,11 @@ retry:
> >  	 */
> >  	if (nimaps == 0) {
> >  		trace_xfs_delalloc_enospc(ip, offset, count);
> > -		if (flushed)
> > -			return XFS_ERROR(error ? error : ENOSPC);
> > +		if (flushed) {
> > +			if (error == 0 || error == EPDQUOT)
> > +				error = ENOSPC;
> > +			return XFS_ERROR(error);
> > +		}
> >  
> >  		if (error == ENOSPC) {
> >  			xfs_iunlock(ip, XFS_ILOCK_EXCL);

This xfs_iomap_write_delay() looks like this now:

        /*
         * If bmapi returned us nothing, we got either ENOSPC or EDQUOT. Retry
         * without EOF preallocation.
         */
        if (nimaps == 0) {
                trace_xfs_delalloc_enospc(ip, offset, count);
                if (prealloc) {
                        prealloc = 0;
                        error = 0;
                        goto retry;
                }
                return XFS_ERROR(error ? error : ENOSPC);
        }

The flushing is now way up in xfs_file_buffered_aio_write(), and the
implementation of xfs_flush_inodes() has changed as well. Hence it
may or may not behave differently not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
