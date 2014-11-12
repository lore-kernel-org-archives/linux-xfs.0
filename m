Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27CE27F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:38:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4C54AC00B
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 11:38:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8DKaHMrcxbmCkmgy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 11:38:03 -0800 (PST)
Date: Wed, 12 Nov 2014 14:37:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: replace global xfslogd wq with per-mount
	xfs-iodone wq
Message-ID: <20141112193751.GA2118@laptop.bfoster>
References: <1415722393-32223-1-git-send-email-bfoster@redhat.com>
	<20141111231246.GT28565@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141111231246.GT28565@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 12, 2014 at 10:12:46AM +1100, Dave Chinner wrote:
> On Tue, Nov 11, 2014 at 11:13:13AM -0500, Brian Foster wrote:
> > The xfslogd workqueue is a global, single-job workqueue for buffer ioend
> > processing. This means we allow for a single work item at a time for all
> > possible XFS mounts on a system. fsstress testing in loopback XFS over
> > XFS configurations has reproduced xfslogd deadlocks due to the single
> > threaded nature of the queue and dependencies introduced between the
> > separate XFS instances by online discard (-o discard).
> > 
> > Discard over a loopback device converts the discard request to a hole
> > punch (fallocate) on the underlying file. Online discard requests are
> > issued synchronously and from xfslogd context in XFS, hence the xfslogd
> > workqueue is blocked in the upper fs waiting on a hole punch request to
> > be servied in the lower fs. If the lower fs issues I/O that depends on
> > xfslogd to complete, both filesystems end up hung indefinitely. This is
> > reproduced reliabily by generic/013 on XFS->loop->XFS test devices with
> > the '-o discard' mount option.
> > 
> > Further, docker implementations appear to use this kind of configuration
> > for container instance filesystems by default (container fs->dm->
> > loop->base fs) and therefore are subject to this deadlock when running
> > on XFS.
> > 
> > Replace the global xfslogd workqueue with a per-mount variant. This
> > guarantees each mount access to a single worker and prevents deadlocks
> > due to inter-fs dependencies introduced by discard. Since the queue is
> > only responsible for iodone processing at this point in time, rename
> > xfslogd to xfs-iodone.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > I've left the wq in xfs_mount rather than moved to the buftarg in this
> > version due to the questions expressed here:
> > 
> > http://oss.sgi.com/archives/xfs/2014-11/msg00117.html
> 
> <sigh>
> 
> Another email from you that hasn't reached my inbox. That's two in a
> week now, I think.
> 
> > ... particularly around the potential creation of multiple (of what is
> > now) max_active=1 queues per-fs.
> 
> So concern #1 is that it splits log buffer versus metadata buffer
> processing to different work queues causing concurrent processing.
> 
> I see no problem there - the io completions have different iodone
> processing functions that mostly don't intersect. As it is, the
> "max-active=1" means 1 work item being processed per CPU, not "only
> one queue" (you need to use alloc_ordered_workqueue() to only
> get one queue). So there is already concurrency in the processing of
> io completions and hence I don't see any problem with separating
> the log iodone completions from the metadata iodone completions.
> 

Ah, I see. I misinterpreted the meaning of max_active. It's not a pure
concurrency limiter as such... moreso a limiter of scheduling multiple
active work items on a particular cpu. The workqueue.txt doc explains
it. That rules out the question that this change introduces concurrency.

> Further, it might be work considering pushing the log buffer
> completions to the m_log_workqueue rather than using a buftarg based
> workqueue so that they are always separated from the rest of the
> metadata completions regardless of whether we have an internal or
> external log device.
> 

Seems reasonable at first glance. I do like the side effect of
consistent behavior. I'll look into it.

> The xfslogd workqueue is tagged with WQ_HIGHPRI only to expedite the
> log buffer io completions over XFS data io completions that may get
> stuck waiting on log forces. i.e. the xfslogd_workqueue needs
> higher priority than m_data_workqueue and m_unwritten_workqueue as
> they can require log forces to complete their work. Hence if we
> separate out the log buffer io completion processing from the
> metadata IO completion processing we don't need to process all the
> metadata buffer IO completion as high priority work anymore.
> 

Ok, thanks. I didn't notice an explicit relationship between either of
those queues and xfslogd. Is the dependency implicit in that those
queues do transaction reservations, and thus can push on the log via the
AIL (and if so, why wouldn't the cil queue be higher priority as well)?

> Concern #2 is about the reason for max_active=1 and being unclear as
> to why we only want a single completion active at a time on a CPU.
> The reason for this is that most metadata and log buffer IO 
> completion work does not sleep - they
> only ever take spinlocks and so there are no built in schedule
> points during work processing. Hence it is rare to need a second
> worker thread to process the queue because the first is blocked
> on a sleeping lock and so max-active=1 makes sense. In comparison,
> the data/unwritten io completion processing is very
> different due to needing to take sleeping inode locks, buffer locks,
> etc) and hence they use the wq default for max active (512).
> 

Ok, max_active sounds more like a hint to the workqueue infrastructure
in this usage. E.g., there's no hard rule against activation of more
than one item, it's just of questionable value.

> So, really, a log workqueue with WQ_HIGHPRI, max_active = 1 and a
> buffer IO completion workqueue with just max_active = 1 would
> probably be fine.
> 

Thanks for the explanation.

Brian

> ....
> 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 9f622fe..ef55264 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -842,10 +842,16 @@ STATIC int
> >  xfs_init_mount_workqueues(
> >  	struct xfs_mount	*mp)
> >  {
> > +	mp->m_iodone_workqueue = alloc_workqueue("xfs-iodone/%s",
> > +			WQ_MEM_RECLAIM|WQ_HIGHPRI|WQ_FREEZABLE, 1,
> > +			mp->m_fsname);
> > +	if (!mp->m_iodone_workqueue)
> > +		goto out;
> 
> m_buf_workqueue would be better, because...
> 
> > +
> >  	mp->m_data_workqueue = alloc_workqueue("xfs-data/%s",
> 
> That's also an "iodone" workqueue for data IO, and ...
> 
> >  			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
> >  	if (!mp->m_data_workqueue)
> > -		goto out;
> > +		goto out_destroy_iodone;
> >  
> >  	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
> 
> That's another an "iodone" workqueue for data IO that needs unwritten
> extent conversion....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
