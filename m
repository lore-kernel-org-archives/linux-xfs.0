Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2I3aVOo010804 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 22:36:37 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC62A13C4A27
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 20:39:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hifFOSYmLXMiLBO7 for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2011 20:39:16 -0700 (PDT)
Date: Fri, 18 Mar 2011 14:39:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: introduce a xfssyncd workqueue
Message-ID: <20110318033913.GD30195@dastard>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-3-git-send-email-david@fromorbit.com>
	<20110310173405.GB19609@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310173405.GB19609@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Mar 10, 2011 at 12:34:05PM -0500, Christoph Hellwig wrote:
> > - out_sysctl_unregister:
> > +out_destroy_xfs_syncd:
> > +	destroy_workqueue(xfs_syncd_wq);
> > +out_sysctl_unregister:
> >  	xfs_sysctl_unregister();
> > - out_cleanup_procfs:
> > +out_cleanup_procfs:
> >  	xfs_cleanup_procfs();
> > - out_buf_terminate:
> > +out_buf_terminate:
> >  	xfs_buf_terminate();
> > - out_filestream_uninit:
> > +out_filestream_uninit:
> >  	xfs_filestream_uninit();
> > - out_mru_cache_uninit:
> > +out_mru_cache_uninit:
> >  	xfs_mru_cache_uninit();
> > - out_destroy_zones:
> > +out_destroy_zones:
> 
> What's the point of these random formatting changes?
> 

Removed.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
