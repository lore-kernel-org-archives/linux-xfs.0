Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 209897F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 17:13:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95815AC003
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 15:13:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IrWLCQikneQ9Ln3r for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 15:13:43 -0800 (PST)
Date: Wed, 9 Dec 2015 10:13:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151208231341.GG19802@dastard>
References: <20151201180321.GA4762@redhat.com> <565DEFE2.2000308@scylladb.com>
	<20151201211914.GZ19199@dastard> <565E1355.4020900@scylladb.com>
	<20151201230644.GD19199@dastard> <565EB390.3020309@scylladb.com>
	<20151202231933.GL19199@dastard> <56603AF8.1080209@scylladb.com>
	<20151204031648.GC26718@dastard> <5666E0B4.70401@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5666E0B4.70401@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Tue, Dec 08, 2015 at 03:52:52PM +0200, Avi Kivity wrote:
> >>>With the way the XFS allocator works, it fills AGs from lowest to
> >>>highest blocks, and if you free lots of space down low in the AG
> >>>then that tends to get reused before the higher offset free space.
> >>>hence the XFS allocates space in the above workload would result in
> >>>roughly 1/3rd of the LBA space associated with the filesystem
> >>>remaining unused. This is another allocator behaviour designed for
> >>>spinning disks (to keep the data on the faster outer edges of
> >>>drives) that maps very well to internal SSD allocation/reclaim
> >>>algorithms....
> >>Cool.  So we'll keep fstrim usage to daily, or something similarly low.
> >Well, it's something you'll need to monitor to determine what the
> >best frequency is, as even fstrim doesn't come for free (esp. if the
> >storage does not support queued TRIM commands).
> 
> I was able to trigger a load where discard caused io_submit to sleep
> even on my super-fast nvme drive.
> 
> The bad news is, disabling discard and running fstrim in parallel
> with this load also caused io_submit to sleep.

Well, yes.  fstrim is not a magic bullet that /prevents/ discard
from interrupting your application's IO - it's just a method under
which the impact can be /somewhat controlled/ as it can be scheduled
for periods where the impact has minimal interruption (e.g. when
load is likely to be light, such as at 3am just before nightly
backups are run).

Regardless, it sounds like your steady state load could be described
as "throwing as much IO as we possible can at the device", but you
are then then having "blocking trouble" when maintenance (expensive)
operations like TRIM need to be are run. I'm not sure this
"blocking" can be prevented completely, because it assumes that you
have a device of infinite IO capacity.

That is, if you exceed the device's command queue depth and the IO
scheduler request queue depth, the block layer will block in the IO
scheduler waiting for a request queue slot to come free. Put simply:
if you overload the IO subsystem, it will block.  There's nothing we
can do in the filesystem about this - this is the way the block
layer works, and it's architected this way to provide the necessary
feedback control for buffered write IO throttling and other
congestion control mechanisms in the kernel.

Sure, you can set the IO scheduler request queue depth to be really
deep to avoid blocking, but this then simply increases your average
and worst-case IO latency in overload situations. At some point you
have to consider the IO subsystem is overloaded and the application
driving it needs to back off. Something has to block when this
happens...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
