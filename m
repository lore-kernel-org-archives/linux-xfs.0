Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 06:06:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VD6gqh001218
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 06:06:42 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08633564C84
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 06:06:41 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id X21vfOX306DvTkfZ for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 06:06:41 -0700 (PDT)
Date: Sat, 1 Nov 2008 00:06:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031130638.GA19509@disturbed>
References: <20081030085020.GP17077@disturbed> <490A833A.2090601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490A833A.2090601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 03:02:02PM +1100, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> Folks,
>>
>> I think I've finally found the bug(s) that is causing XFSQA test 182
>> to fail. Test 182 writes a bunch of files, then runs sync, then
>> shuts the filesystem down. It then unmounts and remounts the fs and
>> checks that all the files are the correct length and have the
>> correct contents. i.e. that sync semantics have been correctly
>> observed.
>>
>> The cause of the failure is that log recovery is replaying inode
>> allocation and overwriting the last inode writes that contained
>> unlogged changes (i.e. the inode size update that occurs at I/O
>> completion).
>>
>> The problem is that we've never been able to work out why recovery
>> is doing this.  What has been nagging at the back of my mind for
>> quite some time is the fact that we do actually write these inodes
>> to disk and that should allow the tail of the log to move forward
>> past the inode allocation transaction and hence it should not be
>> replayed during recovery.
>>
>> A solution that has been proposed in the past (by Lachlan) is to log
>> the inode size updates instead of writing the inode to disk.  In
>> that case, recovery also replays the inode modification transactions
>> and so we don't lose anything. It is a solution that would fix the
>> problem. However, always logging inodes instead of writing unlogged
>> changes has other performance implications that we'd prefer to avoid
>> (i.e. the number of extra transactions it will cause).
> Logging the inode every time a file size update occured increased log
> traffic by about 11% for the load that test 182 generates.

It increases the number of transactions by 33%, (i.e one to create
the file, one for the allocation, and an additional one for updating
the file size). That means a significant  increase in the CPU
overhead involved in writing inodes via pdflush, and we've still got
to write those inodes to disk at some point.

Besides, what do we do when we write inodes back from the AIL and we
find unlogged changes then? We can't issue transactions from the
AIL, as that would deadlock if the log is full. And we can't not push
the inodes out, as that will prevent the tail of the log moving
forward and that will deadlock the filesystemi as well...

On top of that, XFS already logs far, far too much information.
We need to be decreasing logging overhead, not increasing it by
a significant fraction....

> Logging the inode during inode writeout if, and only if, there are
> unlogged changes (ie i_update_core is set) has a negligible impact on
> log traffic or performance.

Every time you write beyond EOF that happens. That's a very
frequent occurrence, so I'd say that it's not negliable.

> I thought I understood this problem yet your description is a lot more
> detailed than I expected.  I agree with you that sync is updating
> everything on disk

It's not, and that is the problem - it's failing to write the
in-memory position of the tail of the log at the end of the sync.
So while all the data and metadata is up to date on disk, the
log is not. We haven't written everything we should be to
disk as part of the sync.

> and if it wasn't for log replay messing things up
> then everything would be good.  So although the inode on disk is up to
> date the history of changes to that inode in the log is missing the
> last changes involving file size updates. So when the log is replayed
> the inode loses the file size update.  And it's all because of the
> inode cluster buffer initialisation log entry that resets the cluster
> (and all the inodes in it) so even the di_flushiter hack can't save us.

That's a red herring. My last attempt at solving this problem a
couple of months ago was based on this premise - it (successfully)
avoided replaying the inode allocation transaction, but the inode
still got overwritten. It got overwritten by the allocation
transaction being replayed in exactly the manner described by the
log covering code....

> The obvious solution to me was to complete the history of the inode in
> the log so if replay wants to start from scratch it will make all the
> necessary changes to bring the inode to a state that matches what is
> on disk.  Logging unlogged changes during sync will achieve this.
>
> Avoiding log replay altogether is even better but that solution is
> only going to work if we've run sync just before our system crashes.
> If we haven't run sync before our system crashes then we'll still hit
> this problem with regressing inodes but if we haven't run sync there
> are no guarantees, right?

If the system crashes while busy, there's no guarantee that cached
write-behind data has been written out, let alone the inode or the
allocation transaction. Recent transactions will still be in memory,
and log buffers may have been written out of order so on a crash we
can lose up to the last 2MB of transactions from recovery. Logging
inodes instead of writing them back does not change this at all - we
just lose the inode changes from the log instead of from the on disk
location.

XFS has never attempted or claimed to provide data reliability
guarantees when a crash occurs - it was designed to ensure that
the filesystem metadata is consistent after recovery, not that
there was zero data loss.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
