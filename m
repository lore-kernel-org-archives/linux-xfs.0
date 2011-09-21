Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8L6PiRI121445 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 01:25:45 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C487017A39B
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 23:25:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4aCI0vCbkZ31oNnE for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 23:25:42 -0700 (PDT)
Date: Wed, 21 Sep 2011 16:25:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: convert xfsbufd to use a workqueue
Message-ID: <20110921062539.GN15688@dastard>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
	<1314341497-23910-5-git-send-email-david@fromorbit.com>
	<20110826082515.GD3551@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110826082515.GD3551@infradead.org>
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

On Fri, Aug 26, 2011 at 04:25:15AM -0400, Christoph Hellwig wrote:
> > index 13188df..a3d1784 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -494,7 +494,7 @@ xfs_ail_worker(
> >  
> >  	if (push_xfsbufd) {
> >  		/* we've got delayed write buffers to flush */
> > -		wake_up_process(mp->m_ddev_targp->bt_task);
> > +		flush_delayed_work(&mp->m_ddev_targp->bt_delwrite_work);
> 
> This is a huge change in behaviour.  wake_up_process just kicks the
> thread to wakeup from sleep as soon as the schedule selects it, while
> flush_delayed_work does not only queue a pending delayed work, but also
> waits for it to finish.

Which is precisely what I want here - to wait for all the delwri
buffers that were promoted to be submitted before continuing
onwards.  This makes the scanning algorithm self throttling -
instead of simply pushing the buffers to the delwri queue and
kicking a background thread and hoping it can flush buffers faster
than we can promote them from the AIL, it explicitly pushes the
delwri buffers before the next round of AIL scanning. The ensures we
start timely IO on the buffers and don't simple continue to scan the
AIL while we wait for the background thread to send them off to
disk and complete.

IOWs, instead of:

	AIL			bufd
	promote
	....
	promote
	wakeup
	short sleep
				woken
				sort
				dispatch
				....

<sometime later, maybe before, during or after xfsbufd has run>

	promote
	.....
	promote
	wakeup
	short sleep
				woken
				sort
				dispatch
				....

Where we *hope* the short sleep in the AIL processing is long enough
to avoid repeated scanning of the AIL while the queued IO is
dispatched. we end up with:

	AIL			bufd
	promote
	....
	promote
	flush_work
				sort
				dispatch
	short sleep

	promote
	....
	promote
	flush_work
				sort
				dispatch
	short sleep

Which is much more controlled and means that the short sleep that
that the AIL processing does actually gives time for IO completions
to occur before continuing. It means that dispatch of IO from the
AIL is throttled to the rate of device congestion as it now waits
for the IO dispatch to complete instead of just sholving as much Io
as possible into the bufd queue.

FWIW, if we move to building a direct IO buffer list in the AIL as
we were recently discussing, this is -exactly- the IO dispatch
patterns and delays that we will get from the AIL....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
