Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A1967F66
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 17:18:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F0EAAC004
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 15:17:57 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	syJkfkrEXeBqHwnB for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 15:17:51 -0800 (PST)
Date: Mon, 20 Jan 2014 10:17:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Message-ID: <20140119231745.GF18112@dastard>
References: <20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Sun, Jan 19, 2014 at 11:38:22AM +0200, Alex Lyakas wrote:
> Hi Dave,
> I believe I understand your intent of having the discard tree almost
> fully disconnected from the busy extents tree. I planned to use the
> the same pagb_lock for the discard tree as well, which solves the
> atomicity and ordering issues you have described. If we use a
> different lock (mutex), then some additional care is needed.

You can probably just change the pagb_lock to a mutex. In the
uncontended case they are almost as fast as spinlocks, and I don't
think there's much contention on this lock right now...

> One thing I like less about such approach, is that we need to be
> careful of not growing the discard tree too large. If, for some
> reason, the worker thread is not able to keep up discarding extents
> while they are queued for discard, we may end up with too many discard
> ranges in the tree.

If that happens, then we'll burn CPU managing the discard tree on
every allocation and waiting for discards to complete. It should
self throttle.

> Also at the same time user can trigger an offline
> discard, which will add more discard ranges to the tree. While the
> online discard that you have, kind of throttles itself. So if the
> underlying block device is slow on discarding, the whole system will
> be slowed down accordingly.

discard already slows the whole system down badly. Moving them to
the background won't prevent that - but it will reduce the impact
because it discards in the transaction commit completion path
completely stall the entire file system for the duration of the
discards.

This is the primary reason why mounting with -o discard is so slow -
discards are done in a path of global serialisation. Moving it to
the background avoids this problem, so regardless of how much
discard work we queue up, the filesystem is still going to be faster
than the current code because we've removed the global serialisation
point.

In the case of fstrim, this makes fstrim run very quickly because it
doesn't issue synchronous discards with the AGF locked.  We still do
the same amount of discard work in the same amount of time in the
background, but we don't block AGs or userspace while we wait for
the discards to be done. That's also a pretty major win.

IOWs, I think the first step is to push all the discard into the
background via it's own rbtree as you've been doing. If we add
tracepoints and stats to the code, we can track the discard queue
depth easily enough with a bit of perf or trace-cmd output
scripting, and then determine whether throttling is necessary.

We can use the loop device to run tests as it implements discard via
hole punching the backing file, and that will tells us pretty
quickly if we need additional throttling by looking at the queue
depths and the amount of CPU being spent manipulating the discard
rbtree (i.e. via perf profiling). Throttling a workqueue isn't hard
to do, but there's no point in doing it if it isn't necessary...

> [snip]
> 
> I have one additional question regarding your comment on metadata
> 
> >> Q1: why it is ok to do so? why it is ok for "metadata" to reuse part
> >> (or all) of the busy extent before its extent-free-intent is
> >> committed?
> >
> > The metadata changes are logged, and crash recovery allows correct
> > ordering of the free, realloc and modify process for metadata. Hence
> > it doesn't matter that we overwrite the contents of the block before
> > the free transaction is on disk - the correct contents will always
> > be present after recovery.
> >
> > We can't do that for user data because we don't log user data.
> > Therefore if we allow user data to overwrite the block whil eit is
> > still busy, crash recovery may not result in the block having the
> > correct contents (i.e. the transaction that freed the block never
> > reaches the journal) and we hence expose some other user's data or
> > metadata in the file.
> If that is the case, why cannot we just issue an async discard before
> the busy extent is committed? I understand that if we crashed, we
> might have knocked off some of the user data (or changed it to some
> new data).

Because a user data extent is not free fo us to make arbitrary
changes to it until the transaction that frees it commits. i.e.  If
we crash then the file must either contain the original data or be
completely gone. Go google "null files after crash" and you'll see
just how important people consider files being intact after a
crash....

> But can XFS get corrupted (unmountable) this way? You said
> earlier that it can, but now you are saying that reusing a metadata
> block, before its busy extent commits, is fine.

No, not exactly. There are 4 different cases to take into account:

1. metadata -> free -> alloc as metadata is the situation where
there are not problems reusing the busy extent because all the
modifications are in the log. Hence crash recovery always ends up
with the correct result no mater where the crash occurs.

2. user data -> free -> alloc as metadata is safe because the
metadata can't be written in place until the free transaction and
the metadata changes are fully committed in the journal. Hence on a
crash the user will either see in-tact data in their file, or the
file will have had the extent removed successfully and the
filesystem has safely reused it for metadata.

3. metadata -> free -> alloc as user data and
4. user data -> free -> alloc as user data are the problematic cases
when it comes to IO ordering - if we allow reallocation of busy
extents, then the new userdata can be written to disk before the
free/alloc transactions are committed to the journal. If we crash
at this point, the after recovery the new data will be pointed to
by the old user.

If the old user is user data, then we've corrupted
their file by exposing some other users data to them.

If the old user is metadata, then we've corrupted the filesystem
because the metadata has been overwritten by user data before the
journal recovery has read and freed the metadata block. That will
cause recovery (and hence mount) to fail.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
