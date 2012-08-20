Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KNLDgX012861 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:21:13 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PVuHbABWzdsEeJs1 for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 16:21:12 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1T3bHS-0005VW-2s
	for xfs@oss.sgi.com; Tue, 21 Aug 2012 09:21:10 +1000
Date: Tue, 21 Aug 2012 09:21:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix race while discarding buffers [V4]
Message-ID: <20120820232110.GM19235@dastard>
References: <1344621711-8049-1-git-send-email-cmaiolino@redhat.com>
	<20120820205134.GB29979@sgi.com>
	<20120820224751.GA22096@orion.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120820224751.GA22096@orion.usersys.redhat.com>
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
To: xfs@oss.sgi.com

On Mon, Aug 20, 2012 at 07:47:51PM -0300, Carlos Maiolino wrote:
> Hi Ben,
> > 
> > 
> Thanks for the comments.
> > 
> > What was the symptom that led to the discovery of this problem?
> > 
> > Reviewed-by: Ben Myers <bpm@sgi.com>
> > 
> 
> It started with the messages like the example below being logged by syslog:
> 
> shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-61993820
> shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-146
> shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-240601220
> shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-152
> shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-2921236993
> 
> These messages came from shrink_slab().

Worth noting is that this warning came from a RHEL kernel, not a
mainline kernel. The mainline kernels don't screw up the nr_to_scan
calculations when a negative object count is returned to them.
Hence mainline kernels are not impacted by the accounting bug at
all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
