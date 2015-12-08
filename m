Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 726977F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 17:38:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FDD48F8033
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 15:38:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jeFbTpoyJvDS7OfJ for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 15:38:35 -0800 (PST)
Date: Wed, 9 Dec 2015 10:32:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151208233219.GH19802@dastard>
References: <20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
	<565DF472.8080101@scylladb.com>
	<20151202001329.GA9633@bfoster.bfoster>
	<565EAD06.5060403@scylladb.com> <20151208060343.GC19802@dastard>
	<5666E1A4.4070805@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5666E1A4.4070805@scylladb.com>
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
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Tue, Dec 08, 2015 at 03:56:52PM +0200, Avi Kivity wrote:
> On 12/08/2015 08:03 AM, Dave Chinner wrote:
> >On Wed, Dec 02, 2015 at 10:34:14AM +0200, Avi Kivity wrote:
> >>On 12/02/2015 02:13 AM, Brian Foster wrote:
> >>>Metadata is modified in-core and handed off to the logging
> >>>infrastructure via a transaction. The log is flushed to disk some time
> >>>later and metadata writeback occurs asynchronously via the xfsaild
> >>>thread.
> >>Unless, I expect, if the log is full.  Since we're hammering on the
> >>disk quite heavily, the log would be fighting with user I/O and
> >>possibly losing.
> >>
> >>Does XFS throttle user I/O in order to get the log buffers recycled faster?
> >No. XFS tags the metadata IO with REQ_META that the IO schedulers
> >can tell the difference between metadata and data IO, and schedule
> >them appropriately. Further. log buffers are also tagged with
> >REQ_SYNC to indicate they are latency sensitive IOs, whcih the IO
> >schedulers again treat differently to minimise latency in the face
> >of bulk async IO which is not latency sensitive.
> >
> >IOWs, IO prioritisation and dispatch scheduling is the job of the IO
> >scheduler, not the filesystem. The filesystem just tells the
> >scheduler how to treat the different types of IO...
> >
> >>Is there any way for us to keep track of it, and reduce disk
> >>pressure when it gets full?
> >Only if you want to make more problems for yourself - second
> >guessing what the filesystem is going to do will only lead you to
> >dancing the Charlie Foxtrot on a regular basis. :/
> 
> So far the best approach I found that doesn't conflict with this is
> to limit io_submit iodepth to the natural disk iodepth (or a small
> multiple thereof).  This seems to keep XFS in its comfort zone, and
> is good for latency anyway.

That's pretty much what I just explained in my previous reply.  ;)

> The only issue is that the only way to obtain this parameter is to
> measure it.

Yup, exactly what I've been saying ;)

However, You can get a pretty good guess on max concurrency from the
device characteristics in sysfs:

/sys/block/<dev>/queue/nr_requests

gives you the maximum IO scheduler request queue depth, and

/sys/block/<dev>/device/queue_depth

gives you the hardware command queue depth.

E.g. a random iscsi device I have attached to a test VM:

$ cat /sys/block/sdc/device/queue_depth 
32
$ cat /sys/block/sdc/queue/nr_requests
127

Which means 32 physical IOs can be in flight concurrently, and the
IO scheduler will queue up to roughly another 100 discrete IOs
before it starts blocking incoming IO requests (127 is the typical
io scheduler queue depth default). That means maximum non-blocking
concurrency is going to be around 100-130 IOs in flight at once.

> I wrote a small tool to do this [1], but it's a hassle for users.
> 
> [1] https://github.com/avikivity/diskplorer

I note that the NVMe device you tested in the description hits
maximum performance with concurrency at around 110-120 read IOs in
flight. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
