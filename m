Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D4F577F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 12:51:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2E5B8F8033
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 10:51:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VDqtzvsx7RFYJhd3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 10:51:16 -0800 (PST)
Date: Tue, 1 Dec 2015 13:51:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201185113.GG26129@bfoster.bfoster>
References: <20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565DD449.5090101@scylladb.com>
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

On Tue, Dec 01, 2015 at 07:09:29PM +0200, Avi Kivity wrote:
> 
> 
> On 12/01/2015 06:29 PM, Brian Foster wrote:
> >On Tue, Dec 01, 2015 at 06:08:51PM +0200, Avi Kivity wrote:
> >>
> >>On 12/01/2015 06:01 PM, Brian Foster wrote:
> >>>On Tue, Dec 01, 2015 at 05:22:38PM +0200, Avi Kivity wrote:
> >>>>On 12/01/2015 04:56 PM, Brian Foster wrote:
> >>>>>On Tue, Dec 01, 2015 at 03:58:28PM +0200, Avi Kivity wrote:
> >>>>>>On 12/01/2015 03:11 PM, Brian Foster wrote:
> >>>>>>>On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
> >>>>>>>>On 11/30/2015 06:14 PM, Brian Foster wrote:
> >>>>>>>>>On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
> >>>>>>>>>>On 11/30/2015 04:10 PM, Brian Foster wrote:
> >>>>>>>...
...
> >>>>>>Won't io_submit() also trigger metadata I/O?  Or is that all deferred to
> >>>>>>async tasks?  I don't mind them blocking each other as long as they let my
> >>>>>>io_submit alone.
> >>>>>>
> >>>>>Yeah, it can trigger metadata reads, force the log (the stale buffer
> >>>>>example) or push the AIL (wait on log space). Metadata changes made
> >>>>>directly via your I/O request are logged/committed via transactions,
> >>>>>which are generally processed asynchronously from that point on.
> >>>>>
> >>>>>>>  io_submit() can probably block in a variety of
> >>>>>>>places afaict... it might have to read in the inode extent map, allocate
> >>>>>>>blocks, take inode/ag locks, reserve log space for transactions, etc.
> >>>>>>Any chance of changing all that to be asynchronous?  Doesn't sound too hard,
> >>>>>>if somebody else has to do it.
> >>>>>>
> >>>>>I'm not following... if the fs needs to read in the inode extent map to
> >>>>>prepare for an allocation, what else can the thread do but wait? Are you
> >>>>>suggesting the request kick off whatever the blocking action happens to
> >>>>>be asynchronously and return with an error such that the request can be
> >>>>>retried later?
> >>>>Not quite, it should be invisible to the caller.
> >>>>
> >>>>That is, the code called by io_submit() (file_operations::write_iter, it
> >>>>seems to be called today) can kick off this operation and have it continue
> >>>>from where it left off.
> >>>Isn't that generally what happens today?
> >>You tell me.  According to $subject, apparently not enough.  Maybe we're
> >>triggering it more often, or we suffer more when it does trigger (the latter
> >>probably more likely).
> >>
> >The original mail describes looking at the sched:sched_switch tracepoint
> >which on a quick look, appears to fire whenever a cpu context switch
> >occurs. This likely triggers any time we wait on an I/O or a contended
> >lock (among other situations I'm sure), and it signifies that something
> >else is going to execute in our place until this thread can make
> >progress.
> 
> For us, nothing else can execute in our place, we usually have exactly one
> thread per logical core.  So we are heavily dependent on io_submit not
> sleeping.
> 

Yes, this "coroutine model" makes more sense to me from the application
perspective. I'm just trying to understand what you're after from the
kernel perspective.

> The case of a contended lock is, to me, less worrying.  It can be reduced by
> using more allocation groups, which is apparently the shared resource under
> contention.
> 

Yep.

> The case of waiting for I/O is much more worrying, because I/O latency are
> much higher.  But it seems like most of the DIO path does not trigger
> locking around I/O (and we are careful to avoid the ones that do, like
> writing beyond eof).
> 
> (sorry for repeating myself, I have the feeling we are talking past each
> other and want to be on the same page)
> 

Yeah, my point is just that just because the thread blocked on I/O,
doesn't mean the cpu can't carry on with some useful work for another
task.

> >
> >>>  We submit an I/O which is
> >>>asynchronous in nature and wait on a completion, which causes the cpu to
> >>>schedule and execute another task until the completion is set by I/O
> >>>completion (via an async callback). At that point, the issuing thread
> >>>continues where it left off. I suspect I'm missing something... can you
> >>>elaborate on what you'd do differently here (and how it helps)?
> >>Just apply the same technique everywhere: convert locks to trylock +
> >>schedule a continuation on failure.
> >>
> >I'm certainly not an expert on the kernel scheduling, locking and
> >serialization mechanisms, but my understanding is that most things
> >outside of spin locks are reschedule points. For example, the
> >wait_for_completion() calls XFS uses to wait on I/O boil down to
> >schedule_timeout() calls. Buffer locks are implemented as semaphores and
> >down() can end up in the same place.
> 
> But, for the most part, XFS seems to be able to avoid sleeping.  The call to
> __blockdev_direct_IO only launches the I/O, so any locking is only around
> cpu operations and, unless there is contention, won't cause us to sleep in
> io_submit().
> 
> Trying to follow the code, it looks like xfs_get_blocks_direct (and
> __blockdev_direct_IO's get_block parameter in general) is synchronous, so
> we're just lucky to have everything in cache.  If it isn't, we block right
> there.  I really hope I'm misreading this and some other magic is happening
> elsewhere instead of this.
> 

Nope, it's synchronous from a code perspective. The
xfs_bmapi_read()->xfs_iread_extents() path could have to read in the
inode bmap metadata if it hasn't been done already. Note that this
should only happen once as everything is stored in-core, so in most
cases this is skipped. It's also possible extents are read in via some
other path/operation on the inode before an async I/O happens to be
submitted (e.g., see some of the other xfs_bmapi_read() callers).

Either way, the extents have to be read in at some point and I'd expect
that cpu to schedule onto some other task while that thread waits on I/O
to complete (read-ahead could also be a factor here, but I haven't
really dug into how that is triggered for buffers).

Brian

> >Brian
> >
> >>>>Seastar (the async user framework which we use to drive xfs) makes writing
> >>>>code like this easy, using continuations; but of course from ordinary
> >>>>threaded code it can be quite hard.
> >>>>
> >>>>btw, there was an attempt to make ext[34] async using this method, but I
> >>>>think it was ripped out.  Yes, the mortal remains can still be seen with
> >>>>'git grep EIOCBQUEUED'.
> >>>>
> >>>>>>>It sounds to me that first and foremost you want to make sure you don't
> >>>>>>>have however many parallel operations you typically have running
> >>>>>>>contending on the same inodes or AGs. Hint: creating files under
> >>>>>>>separate subdirectories is a quick and easy way to allocate inodes under
> >>>>>>>separate AGs (the agno is encoded into the upper bits of the inode
> >>>>>>>number).
> >>>>>>Unfortunately our directory layout cannot be changed.  And doesn't this
> >>>>>>require having agcount == O(number of active files)?  That is easily in the
> >>>>>>thousands.
> >>>>>>
> >>>>>I think Glauber's O(nr_cpus) comment is probably the more likely
> >>>>>ballpark, but really it's something you'll probably just need to test to
> >>>>>see how far you need to go to avoid AG contention.
> >>>>>
> >>>>>I'm primarily throwing the subdir thing out there for testing purposes.
> >>>>>It's just an easy way to create inodes in a bunch of separate AGs so you
> >>>>>can determine whether/how much it really helps with modified AG counts.
> >>>>>I don't know enough about your application design to really comment on
> >>>>>that...
> >>>>We have O(cpus) shards that operate independently.  Each shard writes 32MB
> >>>>commitlog files (that are pre-truncated to 32MB to allow concurrent writes
> >>>>without blocking); the files are then flushed and closed, and later removed.
> >>>>In parallel there are sequential writes and reads of large files using 128kB
> >>>>buffers), as well as random reads.  Files are immutable (append-only), and
> >>>>if a file is being written, it is not concurrently read.  In general files
> >>>>are not shared across shards.  All I/O is async and O_DIRECT.  open(),
> >>>>truncate(), fdatasync(), and friends are called from a helper thread.
> >>>>
> >>>>As far as I can tell it should a very friendly load for XFS and SSDs.
> >>>>
> >>>>>>>  Reducing the frequency of block allocation/frees might also be
> >>>>>>>another help (e.g., preallocate and reuse files,
> >>>>>>Isn't that discouraged for SSDs?
> >>>>>>
> >>>>>Perhaps, if you're referring to the fact that the blocks are never freed
> >>>>>and thus never discarded..? Are you running fstrim?
> >>>>mount -o discard.  And yes, overwrites are supposedly more expensive than
> >>>>trim old data + allocate new data, but maybe if you compare it with the work
> >>>>XFS has to do, perhaps the tradeoff is bad.
> >>>>
> >>>Ok, my understanding is that '-o discard' is not recommended in favor of
> >>>periodic fstrim for performance reasons, but that may or may not still
> >>>be the case.
> >>I understand that most SSDs have queued trim these days, but maybe I'm
> >>optimistic.
> >>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
