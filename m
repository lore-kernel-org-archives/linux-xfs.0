Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84A107F5E
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 18:13:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59064304032
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 16:13:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EbLhYIQEgFtP9wMf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 16:13:32 -0800 (PST)
Date: Tue, 1 Dec 2015 19:13:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151202001329.GA9633@bfoster.bfoster>
References: <20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
	<565DF472.8080101@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565DF472.8080101@scylladb.com>
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

On Tue, Dec 01, 2015 at 09:26:42PM +0200, Avi Kivity wrote:
> On 12/01/2015 08:51 PM, Brian Foster wrote:
> >On Tue, Dec 01, 2015 at 07:09:29PM +0200, Avi Kivity wrote:
> >>
> >>On 12/01/2015 06:29 PM, Brian Foster wrote:
> >>>On Tue, Dec 01, 2015 at 06:08:51PM +0200, Avi Kivity wrote:
> >>>>On 12/01/2015 06:01 PM, Brian Foster wrote:
> >>>>>On Tue, Dec 01, 2015 at 05:22:38PM +0200, Avi Kivity wrote:
> >>>>>>On 12/01/2015 04:56 PM, Brian Foster wrote:
> >>>>>>>On Tue, Dec 01, 2015 at 03:58:28PM +0200, Avi Kivity wrote:
> >>>>>>>>On 12/01/2015 03:11 PM, Brian Foster wrote:
> >>>>>>>>>On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
> >>>>>>>>>>On 11/30/2015 06:14 PM, Brian Foster wrote:
> >>>>>>>>>>>On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
> >>>>>>>>>>>>On 11/30/2015 04:10 PM, Brian Foster wrote:
...
> >>The case of waiting for I/O is much more worrying, because I/O latency are
> >>much higher.  But it seems like most of the DIO path does not trigger
> >>locking around I/O (and we are careful to avoid the ones that do, like
> >>writing beyond eof).
> >>
> >>(sorry for repeating myself, I have the feeling we are talking past each
> >>other and want to be on the same page)
> >>
> >Yeah, my point is just that just because the thread blocked on I/O,
> >doesn't mean the cpu can't carry on with some useful work for another
> >task.
> 
> In our case, there is no other task.  We run one thread per logical core, so
> if that thread gets blocked, the cpu idles.
> 
> The whole point of io_submit() is to issue an I/O and let the caller
> continue processing immediately.  It is the equivalent of O_NONBLOCK for
> networking code.  If O_NONBLOCK did block from time to time, practically all
> modern network applications would see a huge performance drop.
> 

Ok, but my understanding is that O_NONBLOCK would return an error code
in the blocking case such that userspace can do something else or retry
from a blockable context. I think this is similar to what hch posted wrt
to the pwrite2() bits for nonblocking buffered I/O or what I was asking
about earlier on with regard to returning an error if some blocking
would otherwise occur.

> >
> >>>>>  We submit an I/O which is
> >>>>>asynchronous in nature and wait on a completion, which causes the cpu to
> >>>>>schedule and execute another task until the completion is set by I/O
> >>>>>completion (via an async callback). At that point, the issuing thread
> >>>>>continues where it left off. I suspect I'm missing something... can you
> >>>>>elaborate on what you'd do differently here (and how it helps)?
> >>>>Just apply the same technique everywhere: convert locks to trylock +
> >>>>schedule a continuation on failure.
> >>>>
> >>>I'm certainly not an expert on the kernel scheduling, locking and
> >>>serialization mechanisms, but my understanding is that most things
> >>>outside of spin locks are reschedule points. For example, the
> >>>wait_for_completion() calls XFS uses to wait on I/O boil down to
> >>>schedule_timeout() calls. Buffer locks are implemented as semaphores and
> >>>down() can end up in the same place.
> >>But, for the most part, XFS seems to be able to avoid sleeping.  The call to
> >>__blockdev_direct_IO only launches the I/O, so any locking is only around
> >>cpu operations and, unless there is contention, won't cause us to sleep in
> >>io_submit().
> >>
> >>Trying to follow the code, it looks like xfs_get_blocks_direct (and
> >>__blockdev_direct_IO's get_block parameter in general) is synchronous, so
> >>we're just lucky to have everything in cache.  If it isn't, we block right
> >>there.  I really hope I'm misreading this and some other magic is happening
> >>elsewhere instead of this.
> >>
> >Nope, it's synchronous from a code perspective. The
> >xfs_bmapi_read()->xfs_iread_extents() path could have to read in the
> >inode bmap metadata if it hasn't been done already. Note that this
> >should only happen once as everything is stored in-core, so in most
> >cases this is skipped. It's also possible extents are read in via some
> >other path/operation on the inode before an async I/O happens to be
> >submitted (e.g., see some of the other xfs_bmapi_read() callers).
> 
> Is there (could we add) some ioctl to prime this cache?  We could call it
> from a worker thread where we don't mind blocking during open.
> 

I suppose that's possible, or the worker thread could perform some
existing operation known to prime the cache. I don't think it's worth
getting into without a concrete example, however. The extent read
example we're batting around might not ever be a problem (as you've
noted due to file size), if files are truncated and recycled, for
example.

> What is the eviction policy for this cache?   Is it simply the block
> device's page cache?
> 

IIUC the extent list stays around until the inode is reclaimed. There's
a separate buffer cache for metadata buffers. Both types of objects
would be reclaimed based on memory pressure.

> What about the write path, will we see the same problems there?  I would
> guess the problem is less severe there if the metadata is written with
> writeback policy.
> 

Metadata is modified in-core and handed off to the logging
infrastructure via a transaction. The log is flushed to disk some time
later and metadata writeback occurs asynchronously via the xfsaild
thread.

Brian

> >
> >Either way, the extents have to be read in at some point and I'd expect
> >that cpu to schedule onto some other task while that thread waits on I/O
> >to complete (read-ahead could also be a factor here, but I haven't
> >really dug into how that is triggered for buffers).
> 
> To provide an example, our application, which is a database, faces this
> problem exact at a higher level.  Data is stored in data files, and data
> items' locations are stored in index files. When we read a bit of data, we
> issue an index read, and pass it a continuation to be executed when the read
> completes.  This latter continuation parses the data and passes it to the
> code that prepares it for merging with data from other data files, and an
> eventual return to the user.
> 
> Having written code for over a year in this style, I've come to expect it to
> be used everywhere asynchronous I/O is used, but I realize it is fairly hard
> without good support from a framework that allows continuations to be
> composed in a natural way.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
