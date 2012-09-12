Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8CND5A8055477 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 18:13:05 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ANpx2aHYeWPVb5Ok for <xfs@oss.sgi.com>;
	Wed, 12 Sep 2012 16:14:09 -0700 (PDT)
Date: Thu, 13 Sep 2012 09:14:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: stop the sync worker before xfs_unmountfs
Message-ID: <20120912231406.GJ11511@dastard>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com> <20120830223504.GE15292@dastard>
	<5040FF25.1010501@sgi.com> <20120901230824.GB6896@infradead.org>
	<20120912183347.GO3274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120912183347.GO3274@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Sep 12, 2012 at 01:33:47PM -0500, Ben Myers wrote:
> See what you think of this.  Not heavily tested yet, and not pretty... but it
> is fairly minimal. 
....
> Signed-off-by: Ben Myers <bpm@sgi.com>
>
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c
> +++ xfs/fs/xfs/xfs_super.c
> @@ -919,6 +919,7 @@ xfs_fs_put_super(
>  	struct xfs_mount	*mp = XFS_M(sb);
>
>  	xfs_filestream_unmount(mp);
> +	cancel_delayed_work_sync(&mp->m_sync_work);
>  	xfs_unmountfs(mp);
>  	xfs_syncd_stop(mp);
>  	xfs_freesb(mp);

This is the only hunk in the patch needed to fix the problem.

The rest of the patch does not change the order in which the sync
worker is started and stopped - it just open codes it next to the
xfs_syncd_start/stop calls. Essentially, all it does is obfuscate
the real fix that is being made here and makes it harder to
understand what the relationship between xfs_sync_worker() and
xfs_syncd_start/stop is supposed to be.

So a minimal patch, IMO, is just the above hunk....

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
