Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 654417F50
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 14:15:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3AEAA8F8035
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 12:15:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1EGQGc2v6FyEmT5r for <xfs@oss.sgi.com>;
	Sun, 22 Dec 2013 12:15:02 -0800 (PST)
Date: Mon, 23 Dec 2013 07:14:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS blocked task in xlog_cil_force_lsn
Message-ID: <20131222201450.GB3220@dastard>
References: <52B102FF.8040404@pzystorm.de> <52B118A9.8080905@hardwarefreak.com>
	<52B178AA.6040302@pzystorm.de> <52B2FE9E.50307@hardwarefreak.com>
	<52B41B67.9030308@pzystorm.de> <52B439D1.3020205@hardwarefreak.com>
	<20131221053032.GA3220@dastard>
	<52B6AE4D.5020104@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B6AE4D.5020104@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@pzystorm.de, xfs@oss.sgi.com

On Sun, Dec 22, 2013 at 03:18:05AM -0600, Stan Hoeppner wrote:
> On 12/20/2013 11:30 PM, Dave Chinner wrote:
> > On Fri, Dec 20, 2013 at 06:36:33AM -0600, Stan Hoeppner wrote:
> >> On 12/20/2013 4:26 AM, Kevin Richter wrote:
> >>> 'top' while copying with stripe size of 2048 (the source disk is ntfs):
> >>>> top - 10:48:24 up 1 day,  1:41,  2 users,  load average: 5.66, 3.53, 2.17
> >>>> Tasks: 210 total,   2 running, 208 sleeping,   0 stopped,   0 zombie
> >>>> Cpu(s):  0.1%us, 35.8%sy,  0.0%ni, 46.0%id, 17.9%wa,  0.0%hi,  0.2%si,  0.0%st
> >>>> Mem:  32913992k total, 32709208k used,   204784k free, 10770344k buffers
> >>>> Swap:  7812496k total,        0k used,  7812496k free, 20866844k cached
> >>>>
> >>>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >>>> 19524 root      20   0     0    0    0 R   93  0.0   4:00.12 kworker/3:1
> >>>> 23744 root      20   0     0    0    0 S   55  0.0   0:50.84 kworker/0:1
> >>>> 23738 root      20   0     0    0    0 S   29  0.0   0:56.94 kworker/4:0
> >>>>  3893 root      20   0     0    0    0 S   28  0.0  36:47.50 md2_raid6
> >>>>  4551 root      20   0 22060 3328  720 D   25  0.0  20:21.61 mount.ntfs
> >>>> 23273 root      20   0     0    0    0 S   22  0.0   1:54.86 kworker/7:2
> >>>> 23734 root      20   0 21752 1280 1040 D   21  0.0   0:49.84 cp
> >>>>    84 root      20   0     0    0    0 S    7  0.0   8:19.34 kswapd1
> >>>>    83 root      20   0     0    0    0 S    6  0.0  11:55.81 kswapd0
> >>>> 23745 root      20   0     0    0    0 S    2  0.0   0:33.60 kworker/1:2
> >>>> 21598 root      20   0     0    0    0 D    1  0.0   0:11.33 kworker/u17:1
> >>
> >> Hmm, what's kworker/3:1?  That's not a crypto thread eating 93% of a
> >> SandyBridge core at only ~180 MB/s throughput is it?
> > 
> > Kworkers are an anonymous kernel worker threads that do work that
> > has been pushed to a workqueue. kworker/3:1 is the 2nd worker thread
> > on CPU 3 (3:0 is the first). The kworker is a thread pool that grows
> > and shrinks according to demand.
> > 
> > As the naming suggests, kworker threads are per-CPU, and there can
> > be hundreds of them per CPU is there is enough workqueue work blocks
> > during execution of the work (e.g. on locks, waiting for IO, etc).
> > If there is little blocking occurring, there might on ly be a couple
> > of kworker threads that do all the work, and hence you see them
> > consuming huge amounts of CPU on behalf of other systems...
> > 
> > XFS uses workqueues for lots of things, so it's not unusual to see
> > an IO or metadata heavy workload end up with this huge numbers of
> > kworker threads doing work:
> > 
> > <run parallel fsmark test>
> > ....
> > $ ps -ef |grep kworker |wc -l
> > 91
> 
> For the record, again, I've never used dm-crypt.  I'm just trying to
> work through the layers to identify the source of Kevin's problems.  So
> please don't clobber me too hard for going OT, or trying to speak
> (somewhat) intelligently about something I'm just learning about...
> 
> So, how does one identify who is doing work inside a worker thread?  In
> this case we're trying to figure out if dm-crypt might be eating a CPU
> core thus limiting its throughput.  However...

perf top is your friend for finding out where the kernel is spending
it's CPU time. It will tell you functions (and call chains) that are
consuming CPU time rather than what individual threads are doing.

If you really want to know what worker threads are doing,
/proc/sysrq-trigger dumps the kworker threads with the name of the
workqueue they are doing work on behalf of as well as the stack
trace.

> 
> I just read a thread on dm-devel about dm-crypt performance dated late
> March 2013.  It wasn't clear to me if dm-crypt yet uses unbound
> workqueues, if it dispatches work to multiple queues, or if it still
> uses the hand built dispatcher, as of kernel 3.11, which Kevin just
> updated to.

dm-crypt uses workqueues with a concurrency depth of 1, and kcryptd
is defined as CPU intensive and so is scheduled like a long running
kernel thread rather than a workqueue. Reads decrypting is done on
IO completion, so if you've only got one CPU processing IO
completions, then read decryption will effectively be single
threaded due to the nature of per-cpu work queues and a concurrency
depth of 1.

> What was clear is that as of March dm-crypt was not preserving IO
> ordering.  If this is still the case, that would imply RMW with md
> parity arrays, which would tend to explain Kevin's write throughput
> being ~1/3rd of his read, and less than a single disk.

encryption adds IO latency, so unless you have lots of concurrency
to hide the latency, dm-crypt will almost always be slower than the
same IO an equivalent unencrypted disk.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
