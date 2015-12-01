Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FA1E7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 12:03:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B47B8F8039
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 10:03:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3bswctxmChfnB85Y (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 10:03:26 -0800 (PST)
Date: Tue, 1 Dec 2015 19:03:21 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201180321.GA4762@redhat.com>
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

Hi Avi,

> >else is going to execute in our place until this thread can make
> >progress.
> 
> For us, nothing else can execute in our place, we usually have exactly one
> thread per logical core.  So we are heavily dependent on io_submit not
> sleeping.
> 
> The case of a contended lock is, to me, less worrying.  It can be reduced by
> using more allocation groups, which is apparently the shared resource under
> contention.
> 

I apologize if I misread your previous comments, but, IIRC you said you can't
change the directory structure your application is using, and IIRC your
application does not spread files across several directories.

XFS spread files across the allocation groups, based on the directory these
files are created, trying to keep files as close as possible from their
metadata.
Directories are spreaded across the AGs in a 'round-robin' way, each
new directory, will be created in the next allocation group, and, xfs will try
to allocate the files in the same AG as its parent directory. (Take a look at
the 'rotorstep' sysctl option for xfs).

So, unless you have the files distributed across enough directories, increasing
the number of allocation groups may not change the lock contention you're
facing in this case.

I really don't remember if it has been mentioned already, but if not, it might
be worth to take this point in consideration.

anyway, just my 0.02

> The case of waiting for I/O is much more worrying, because I/O latency are
> much higher.  But it seems like most of the DIO path does not trigger
> locking around I/O (and we are careful to avoid the ones that do, like
> writing beyond eof).
> 
> (sorry for repeating myself, I have the feeling we are talking past each
> other and want to be on the same page)
> 
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
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
