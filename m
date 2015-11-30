Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 647CC29DF5
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 17:12:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 024FEAC005
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 15:12:46 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AciB4m71McPXacaE for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 15:12:38 -0800 (PST)
Date: Tue, 1 Dec 2015 10:10:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151130231027.GO26718@dastard>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
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
To: Glauber Costa <glauber@scylladb.com>
Cc: Avi Kivity <avi@scylladb.com>, xfs@oss.sgi.com

On Fri, Nov 27, 2015 at 09:43:50PM -0500, Glauber Costa wrote:
> Hello my dear XFSers,
> 
> For those of you who don't know, we at ScyllaDB produce a modern NoSQL
> data store that, at the moment, runs on top of XFS only. We deal
> exclusively with asynchronous and direct IO, due to our
> thread-per-core architecture. Due to that, we avoid issuing any
> operation that will sleep.
> 
> While debugging an extreme case of bad performance (most likely
> related to a not-so-great disk), I have found a variety of cases in
> which XFS blocks. To find those, I have used perf record -e
> sched:sched_switch -p <pid_of_db>, and I am attaching the perf report
> as xfs-sched_switch.log. Please note that this doesn't tell me for how
> long we block, but as mentioned before, blocking operations outside
> our control are detrimental to us regardless of the elapsed time.
> 
> For those who are not acquainted to our internals, please ignore
> everything in that file but the xfs functions. For the xfs symbols,
> there are two kinds of events: the ones that are a children of
> io_submit, where we don't tolerate blocking, and the ones that are
> children of our helper IO thread, to where we push big operations that
> we know will block until we can get rid of them all. We care about the
> former and ignore the latter.
> 
> Please allow me to ask you a couple of questions about those findings.
> If we are doing anything wrong, advise on best practices is truly
> welcome.
> 
> 1) xfs_buf_lock -> xfs_log_force.
> 
> I've started wondering what would make xfs_log_force sleep. But then I
> have noticed that xfs_log_force will only be called when a buffer is
> marked stale. Most of the times a buffer is marked stale seems to be
> due to errors. Although that is not my case (more on that), it got me
> thinking that maybe the right thing to do would be to avoid hitting
> this case altogether?

The buffer is stale because it has recently been freed, and we
cannot re-use it until the transaction that freed it has been
committed to the journal. e.g. this trace:

   --3.15%-- _xfs_log_force
             xfs_log_force
             xfs_buf_lock
             _xfs_buf_find
             xfs_buf_get_map
             xfs_trans_get_buf_map
             xfs_btree_get_bufl
             xfs_bmap_extents_to_btree
             xfs_bmap_add_extent_hole_real
             xfs_bmapi_write
             xfs_iomap_write_direct
             __xfs_get_blocks
             xfs_get_blocks_direct
             do_blockdev_direct_IO
             __blockdev_direct_IO
             xfs_vm_direct_IO
             xfs_file_dio_aio_write
             xfs_file_write_iter
             aio_run_iocb
             do_io_submit
             sys_io_submit
             entry_SYSCALL_64_fastpath
             io_submit
             0x46d98a

implies something like this has happened:

truncate
  free extent
    extent list now fits inline in inode
    btree-to-extent format change
      free last bmbt block X
        mark block contents stale
	add block to busy extent list
	place block on AGFL

AIO write
  allocate extent
    inline extents full
    extent-to-btree conversion
        allocate bmbt block
	  grab block X from free list
	  get locked buffer for block X
	    xfs_buf_lock
	      buffer stale
	        log force to commit previous free transaction to disk
		.....
		log force completes
		  buffer removed from busy extent list
		  buffer no longer stale
	 add bmbt record to new block
	 update btree indexes
	 ....


And, looking at the trace you attached, we see this:

dump_stack
xfs_buf_stale
xfs_trans_binval
xfs_bmap_btree_to_extents		<<<<<<<<<
xfs_bunmapi
xfs_itruncate_extents

So I'd say this is a pretty clear indication that we're immediately
recycling freed blocks from the free list here....

> The file example-stale.txt contains a backtrace of the case where we
> are being marked as stale. It seems to be happening when we convert
> the the inode's extents from unwritten to real. Can this case be
> avoided? I won't pretend I know the intricacies of this, but couldn't
> we be keeping extents from the very beginning to avoid creating stale
> buffers?
> 
> 2) xfs_buf_lock -> down
> This is one I truly don't understand. What can be causing contention
> in this lock? We never have two different cores writing to the same
> buffer, nor should we have the same core doingCAP_FOWNER so.

As Brian pointed out, this is probably AGF or AGI contention -
attempting to allocate/free extents or inodes in the same AG at the
same time will show this sort of pattern. This trace shows AGF
contention:

  down
  xfs_buf_lock
  _xfs_buf_find
  xfs_buf_get_map
  xfs_buf_read_map
  xfs_trans_read_buf_map
  xfs_read_agf
  .....

This trace shows AGI contention:

  down
  xfs_buf_lock
  _xfs_buf_find
  xfs_buf_get_map
  xfs_buf_read_map
  xfs_trans_read_buf_map
  xfs_read_agi
  ....

> 3) xfs_file_aio_write_checks -> file_update_time -> xfs_vn_update_time

This trace?:

 rwsem_down_write_failed
 call_rwsem_down_write_failed
 xfs_ilock
 xfs_vn_update_time
 file_update_time
 xfs_file_aio_write_checks
 xfs_file_dio_aio_write
 xfs_file_write_iter
 aio_run_iocb
 do_io_submit
 sys_io_submit
 entry_SYSCALL_64_fastpath
 io_submit
 0x46d98a

Which is an mtime timestamp update racing with another operation
that takes the internal metadata lock (e.g. block mapping/allocation
for that inode).

> You guys seem to have an interface to avoid that, by setting the
> FMODE_NOCMTIME flag.

We've talked about exposing this through open() for Ceph.

http://www.kernelhub.org/?p=2&msg=744325
https://lkml.org/lkml/2015/5/15/671

Read the first thread for why it's problematic to expose this to
userspace - I won't repeat it all here.

As it is, there was some code recently hacked into ext4 to reduce
mtime overhead - the MS_LAZYTIME superblock option. What it does it
prevent the inode from being marked dirty when timestamps are
updated and hence the timestamps are never journalled or written
until something else marks the inode metadata dirty (e.g. block
allocation). ext4 gets away with this because it doesn't actually
journal timestamp changes - they get captured in the journal by
other modifications that are journalled, but still rely on the inod
being marked dirty for fsync, writeback and inode cache eviction
doing the right thing.

The ext4 implementation looks like the timestamp updates can be
thrown away, as the inodes are not marked dirty and so on memory
pressure they will simply be reclaimed without writing back the
updated timestamps that are held in memory. I suspect fsync will
also have problems on ext4 as the inode is not metadata dirty or
journalled, and hence the timestamp changes will never get written
back.

And, IMO, the worst part of the ext4 implementation is that the
inode buffer writeback code in ext4 now checks to see if any of the
other inodes in the buffer being written back need to have their
inode timestamps updated. IOWs, ext4 now does writeback of
/unjournalled metadata/ to inodes that are purely timestamp dirty.

We /used/ to do shit like this in XFS. We got rid of it in
preference of journalling everything because the corner cases in log
recovery meant that after a crash the inodes were in inconsistent
states, and that meant we had unexpected, unpredictable recovery
behaviour where files weren't the expected size and/or didn't
contain the expected data. Hence going back to the bad old days of
hacking around the journal "for speed" doesn't exactly fill me with
joy.

Let me have a think about how we can implement lazytime in a sane
way, such that fsync() works correctly, we don't throw away
timstamp changes in memory reclaim and we don't write unlogged
changes to the on-disk locations....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
