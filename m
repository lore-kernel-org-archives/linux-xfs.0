Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 69C927F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 15:38:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56A438F8033
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:38:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	42RoyvQwSNnBRYkC for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 13:38:42 -0800 (PST)
Date: Thu, 13 Nov 2014 08:38:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: replace global xfslogd wq with per-mount
	xfs-iodone wq
Message-ID: <20141112213839.GA23575@dastard>
References: <1415722393-32223-1-git-send-email-bfoster@redhat.com>
	<20141111231246.GT28565@dastard>
	<20141112193751.GA2118@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141112193751.GA2118@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 12, 2014 at 02:37:51PM -0500, Brian Foster wrote:
> On Wed, Nov 12, 2014 at 10:12:46AM +1100, Dave Chinner wrote:
> > On Tue, Nov 11, 2014 at 11:13:13AM -0500, Brian Foster wrote:
> > > The xfslogd workqueue is a global, single-job workqueue for buffer ioend
> > > processing. This means we allow for a single work item at a time for all
> > > possible XFS mounts on a system. fsstress testing in loopback XFS over
> > > XFS configurations has reproduced xfslogd deadlocks due to the single
> > > threaded nature of the queue and dependencies introduced between the
> > > separate XFS instances by online discard (-o discard).
....
> > > I've left the wq in xfs_mount rather than moved to the buftarg in this
> > > version due to the questions expressed here:
> > > 
> > > http://oss.sgi.com/archives/xfs/2014-11/msg00117.html
> > 
> > <sigh>
> > 
> > Another email from you that hasn't reached my inbox. That's two in a
> > week now, I think.
> > 
> > > ... particularly around the potential creation of multiple (of what is
> > > now) max_active=1 queues per-fs.
> > 
> > So concern #1 is that it splits log buffer versus metadata buffer
> > processing to different work queues causing concurrent processing.
...
> > The xfslogd workqueue is tagged with WQ_HIGHPRI only to expedite the
> > log buffer io completions over XFS data io completions that may get
> > stuck waiting on log forces. i.e. the xfslogd_workqueue needs
> > higher priority than m_data_workqueue and m_unwritten_workqueue as
> > they can require log forces to complete their work. Hence if we
> > separate out the log buffer io completion processing from the
> > metadata IO completion processing we don't need to process all the
> > metadata buffer IO completion as high priority work anymore.
> > 
> 
> Ok, thanks. I didn't notice an explicit relationship between either of
> those queues and xfslogd. Is the dependency implicit in that those
> queues do transaction reservations, and thus can push on the log via the
> AIL (and if so, why wouldn't the cil queue be higher priority as well)?

IIRC, the main dependency problem we found had to do with data IO
completion on a loop device getting stuck waiting log IO completion
on the backing device which was stuck in a dispatch queue behind
more blocked completions on the loop device. using WQ_HIGHPRI meant
they didn't get stuck in dispatch queues behind other queued work -
they got dispatched immeidately....

> > Concern #2 is about the reason for max_active=1 and being
> > unclear as to why we only want a single completion active at a
> > time on a CPU.  The reason for this is that most metadata and
> > log buffer IO completion work does not sleep - they only ever
> > take spinlocks and so there are no built in schedule points
> > during work processing. Hence it is rare to need a second worker
> > thread to process the queue because the first is blocked on a
> > sleeping lock and so max-active=1 makes sense. In comparison,
> > the data/unwritten io completion processing is very different
> > due to needing to take sleeping inode locks, buffer locks, etc)
> > and hence they use the wq default for max active (512).
> > 
> 
> Ok, max_active sounds more like a hint to the workqueue
> infrastructure in this usage. E.g., there's no hard rule against
> activation of more than one item, it's just of questionable value.

Right. ISTR that there were worse lock contention problems on the
AIL and iclog locks when more concurency was introduced, so it was
just kept down to the minimum required.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
