Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 47FB97F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:07:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE8FCAC002
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 11:07:45 -0800 (PST)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
	[209.85.215.41]) by cuda.sgi.com with ESMTP id Ipz7WJEjRMKyG7Kg
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 11:07:42 -0800 (PST)
Received: by lfdl133 with SMTP id l133so21622716lfd.2
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 11:07:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151201185113.GG26129@bfoster.bfoster>
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
	<20151201185113.GG26129@bfoster.bfoster>
Date: Tue, 1 Dec 2015 14:07:41 -0500
Message-ID: <CAD-J=zZKD_JHV=1C==Kpz_=paaR9MNM_mBNF7VkahvL=19+uwA@mail.gmail.com>
Subject: Re: sleeps and waits during io_submit
From: Glauber Costa <glauber@scylladb.com>
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
Cc: Avi Kivity <avi@scylladb.com>, xfs@oss.sgi.com

Hi Brian,


>
> Either way, the extents have to be read in at some point and I'd expect
> that cpu to schedule onto some other task while that thread waits on I/O
> to complete (read-ahead could also be a factor here, but I haven't
> really dug into how that is triggered for buffers).
>


Being a datastore, we expect to run practically alone in any box we're
at. That means that there is no other task to run. If io_submit
blocks, the system blocks. The assumption that blocking will just
yield the processor for another thread makes sense in the general case
where you assume more than one application running and/or more than
one thread within the same application.

>From our user's perspective, however, every time that happens we can't
make progress. It doesn't really matter where it blocks.

If io_submit returns without blocking, we can still push more work,
even though the kernel is still not ready to proceed. If it blocks,
we're dead.

> Brian
>
>> >Brian
>> >
>> >>>>Seastar (the async user framework which we use to drive xfs) makes writing
>> >>>>code like this easy, using continuations; but of course from ordinary
>> >>>>threaded code it can be quite hard.
>> >>>>
>> >>>>btw, there was an attempt to make ext[34] async using this method, but I
>> >>>>think it was ripped out.  Yes, the mortal remains can still be seen with
>> >>>>'git grep EIOCBQUEUED'.
>> >>>>
>> >>>>>>>It sounds to me that first and foremost you want to make sure you don't
>> >>>>>>>have however many parallel operations you typically have running
>> >>>>>>>contending on the same inodes or AGs. Hint: creating files under
>> >>>>>>>separate subdirectories is a quick and easy way to allocate inodes under
>> >>>>>>>separate AGs (the agno is encoded into the upper bits of the inode
>> >>>>>>>number).
>> >>>>>>Unfortunately our directory layout cannot be changed.  And doesn't this
>> >>>>>>require having agcount == O(number of active files)?  That is easily in the
>> >>>>>>thousands.
>> >>>>>>
>> >>>>>I think Glauber's O(nr_cpus) comment is probably the more likely
>> >>>>>ballpark, but really it's something you'll probably just need to test to
>> >>>>>see how far you need to go to avoid AG contention.
>> >>>>>
>> >>>>>I'm primarily throwing the subdir thing out there for testing purposes.
>> >>>>>It's just an easy way to create inodes in a bunch of separate AGs so you
>> >>>>>can determine whether/how much it really helps with modified AG counts.
>> >>>>>I don't know enough about your application design to really comment on
>> >>>>>that...
>> >>>>We have O(cpus) shards that operate independently.  Each shard writes 32MB
>> >>>>commitlog files (that are pre-truncated to 32MB to allow concurrent writes
>> >>>>without blocking); the files are then flushed and closed, and later removed.
>> >>>>In parallel there are sequential writes and reads of large files using 128kB
>> >>>>buffers), as well as random reads.  Files are immutable (append-only), and
>> >>>>if a file is being written, it is not concurrently read.  In general files
>> >>>>are not shared across shards.  All I/O is async and O_DIRECT.  open(),
>> >>>>truncate(), fdatasync(), and friends are called from a helper thread.
>> >>>>
>> >>>>As far as I can tell it should a very friendly load for XFS and SSDs.
>> >>>>
>> >>>>>>>  Reducing the frequency of block allocation/frees might also be
>> >>>>>>>another help (e.g., preallocate and reuse files,
>> >>>>>>Isn't that discouraged for SSDs?
>> >>>>>>
>> >>>>>Perhaps, if you're referring to the fact that the blocks are never freed
>> >>>>>and thus never discarded..? Are you running fstrim?
>> >>>>mount -o discard.  And yes, overwrites are supposedly more expensive than
>> >>>>trim old data + allocate new data, but maybe if you compare it with the work
>> >>>>XFS has to do, perhaps the tradeoff is bad.
>> >>>>
>> >>>Ok, my understanding is that '-o discard' is not recommended in favor of
>> >>>periodic fstrim for performance reasons, but that may or may not still
>> >>>be the case.
>> >>I understand that most SSDs have queued trim these days, but maybe I'm
>> >>optimistic.
>> >>
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
