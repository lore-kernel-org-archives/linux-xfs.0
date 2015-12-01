Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A01F7F58
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 10:01:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AB208F804B
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 08:01:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0Mdc2tBEF47w7XXR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 08:01:36 -0800 (PST)
Date: Tue, 1 Dec 2015 11:01:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201160133.GE26129@bfoster.bfoster>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565DBB3E.2010308@scylladb.com>
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

On Tue, Dec 01, 2015 at 05:22:38PM +0200, Avi Kivity wrote:
> 
> 
> On 12/01/2015 04:56 PM, Brian Foster wrote:
> >On Tue, Dec 01, 2015 at 03:58:28PM +0200, Avi Kivity wrote:
> >>
> >>On 12/01/2015 03:11 PM, Brian Foster wrote:
> >>>On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
> >>>>On 11/30/2015 06:14 PM, Brian Foster wrote:
> >>>>>On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
> >>>>>>On 11/30/2015 04:10 PM, Brian Foster wrote:
> >>>...
> >>>>>The agsize/agcount mkfs-time heuristics change depending on the type of
> >>>>>storage. A single AG can be up to 1TB and if the fs is not considered
> >>>>>"multidisk" (e.g., no stripe unit/width is defined), 4 AGs is the
> >>>>>default up to 4TB. If a stripe unit is set, the agsize/agcount is
> >>>>>adjusted depending on the size of the overall volume (see
> >>>>>xfsprogs-dev/mkfs/xfs_mkfs.c:calc_default_ag_geometry() for details).
> >>>>We'll experiment with this.  Surely it depends on more than the amount of
> >>>>storage?  If you have a high op rate you'll be more likely to excite
> >>>>contention, no?
> >>>>
> >>>Sure. The absolute optimal configuration for your workload probably
> >>>depends on more than storage size, but mkfs doesn't have that
> >>>information. In general, it tries to use the most reasonable
> >>>configuration based on the storage and expected workload. If you want to
> >>>tweak it beyond that, indeed, the best bet is to experiment with what
> >>>works.
> >>We will do that.
> >>
> >>>>>>Are those locks held around I/O, or just CPU operations, or a mix?
> >>>>>I believe it's a mix of modifications and I/O, though it looks like some
> >>>>>of the I/O cases don't necessarily wait on the lock. E.g., the AIL
> >>>>>pushing case will trylock and defer to the next list iteration if the
> >>>>>buffer is busy.
> >>>>>
> >>>>Ok.  For us sleeping in io_submit() is death because we have no other thread
> >>>>on that core to take its place.
> >>>>
> >>>The above is with regard to metadata I/O, whereas io_submit() is
> >>>obviously for user I/O.
> >>Won't io_submit() also trigger metadata I/O?  Or is that all deferred to
> >>async tasks?  I don't mind them blocking each other as long as they let my
> >>io_submit alone.
> >>
> >Yeah, it can trigger metadata reads, force the log (the stale buffer
> >example) or push the AIL (wait on log space). Metadata changes made
> >directly via your I/O request are logged/committed via transactions,
> >which are generally processed asynchronously from that point on.
> >
> >>>  io_submit() can probably block in a variety of
> >>>places afaict... it might have to read in the inode extent map, allocate
> >>>blocks, take inode/ag locks, reserve log space for transactions, etc.
> >>Any chance of changing all that to be asynchronous?  Doesn't sound too hard,
> >>if somebody else has to do it.
> >>
> >I'm not following... if the fs needs to read in the inode extent map to
> >prepare for an allocation, what else can the thread do but wait? Are you
> >suggesting the request kick off whatever the blocking action happens to
> >be asynchronously and return with an error such that the request can be
> >retried later?
> 
> Not quite, it should be invisible to the caller.
> 
> That is, the code called by io_submit() (file_operations::write_iter, it
> seems to be called today) can kick off this operation and have it continue
> from where it left off.
> 

Isn't that generally what happens today? We submit an I/O which is
asynchronous in nature and wait on a completion, which causes the cpu to
schedule and execute another task until the completion is set by I/O
completion (via an async callback). At that point, the issuing thread
continues where it left off. I suspect I'm missing something... can you
elaborate on what you'd do differently here (and how it helps)?

> Seastar (the async user framework which we use to drive xfs) makes writing
> code like this easy, using continuations; but of course from ordinary
> threaded code it can be quite hard.
> 
> btw, there was an attempt to make ext[34] async using this method, but I
> think it was ripped out.  Yes, the mortal remains can still be seen with
> 'git grep EIOCBQUEUED'.
> 
> >
> >>>It sounds to me that first and foremost you want to make sure you don't
> >>>have however many parallel operations you typically have running
> >>>contending on the same inodes or AGs. Hint: creating files under
> >>>separate subdirectories is a quick and easy way to allocate inodes under
> >>>separate AGs (the agno is encoded into the upper bits of the inode
> >>>number).
> >>Unfortunately our directory layout cannot be changed.  And doesn't this
> >>require having agcount == O(number of active files)?  That is easily in the
> >>thousands.
> >>
> >I think Glauber's O(nr_cpus) comment is probably the more likely
> >ballpark, but really it's something you'll probably just need to test to
> >see how far you need to go to avoid AG contention.
> >
> >I'm primarily throwing the subdir thing out there for testing purposes.
> >It's just an easy way to create inodes in a bunch of separate AGs so you
> >can determine whether/how much it really helps with modified AG counts.
> >I don't know enough about your application design to really comment on
> >that...
> 
> We have O(cpus) shards that operate independently.  Each shard writes 32MB
> commitlog files (that are pre-truncated to 32MB to allow concurrent writes
> without blocking); the files are then flushed and closed, and later removed.
> In parallel there are sequential writes and reads of large files using 128kB
> buffers), as well as random reads.  Files are immutable (append-only), and
> if a file is being written, it is not concurrently read.  In general files
> are not shared across shards.  All I/O is async and O_DIRECT.  open(),
> truncate(), fdatasync(), and friends are called from a helper thread.
> 
> As far as I can tell it should a very friendly load for XFS and SSDs.
> 
> >
> >>>  Reducing the frequency of block allocation/frees might also be
> >>>another help (e.g., preallocate and reuse files,
> >>Isn't that discouraged for SSDs?
> >>
> >Perhaps, if you're referring to the fact that the blocks are never freed
> >and thus never discarded..? Are you running fstrim?
> 
> mount -o discard.  And yes, overwrites are supposedly more expensive than
> trim old data + allocate new data, but maybe if you compare it with the work
> XFS has to do, perhaps the tradeoff is bad.
> 

Ok, my understanding is that '-o discard' is not recommended in favor of
periodic fstrim for performance reasons, but that may or may not still
be the case.

Brian

> 
> >
> >If so, it would certainly impact that by holding blocks as allocated to
> >inodes as opposed to putting them in free space trees where they can be
> >discarded. If not, I don't see how it would make a difference, but
> >perhaps I misunderstand the point. That said, there's probably others on
> >the list who can more definitively discuss SSD characteristics than I...
> 
> 
> 
> >
> >>We can do that for a subset of our files.
> >>
> >>We do use XFS_IOC_FSSETXATTR though.
> >>
> >>>'mount -o ikeep,'
> >>Interesting.  Our files are large so we could try this.
> >>
> >Just to be clear... this behavior change is more directly associated
> >with file count than file size (though indirectly larger files might
> >mean you have less of them, if that's your point).
> 
> Yes, that's what I meant, and especially that if a lot of files are removed
> we'd be losing the inode space allocated to them.
> 
> >
> >To generalize a bit, I'd be more weary of using this option if your
> >filesystem can be used in an unstructured manner in any way. For
> >example, if the file count can balloon up and back down temporarily,
> >that's going to allocate a bunch of metadata space for inodes that won't
> >ever be reclaimed or reused for anything other than inodes.
> 
> Exactly.  File count can balloon, but files will be large, so even the worst
> case waste is very limited.
> 
> >
> >>>etc.). Beyond that, you probably want to make sure the log is large
> >>>enough to support all concurrent operations. See the xfs_log_grant_*
> >>>tracepoints for a window into if/how long transaction reservations might
> >>>be waiting on the log.
> >>I see that on an 400G fs, the log is 180MB.  Seems plenty large for write
> >>operations that are mostly large sequential, though I've no real feel for
> >>the numbers.  Will keep an eye on this.
> >>
> >FWIW, XFS on recent kernels has grown some sysfs entries that might help
> >give an idea of log reservation state at runtime. See the entries under
> >/sys/fs/xfs/<dev>/log for details.
> 
> Great.  We will study those with great interest.
> 
> >
> >Brian
> >
> >>Thanks for all the info.
> >>
> >>>Brian
> >>>
> >>>>_______________________________________________
> >>>>xfs mailing list
> >>>>xfs@oss.sgi.com
> >>>>http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
