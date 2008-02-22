Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 22:26:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M6QTU3020816
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 22:26:33 -0800
Message-ID: <47BE6C5C.2000605@sgi.com>
Date: Fri, 22 Feb 2008 17:31:56 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Marking inode dirty latency > 1000 msec on XFS!
References: <47B5DD9C.3080906@gmail.com>
In-Reply-To: <47B5DD9C.3080906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, xfs@oss.sgi.com

Török Edwin wrote:
> Hi,
> 
> Using LatencyTOP 0.3, on the latest 2.6.25-git I see latencies of over a
> second on __mark_ inode_dirty.
These are the maximum latencies, right?  What would be useful here is the
average latency time.  The average might actually be quite low but if just
once we have a maximum that is unusually large then just looking at that
figure can be misleading.

> [see a stacktrace at end of this email]
> 
> I tried to locate xfs's implementation of super_operations.dirty_inode,
> but it isn't specified in xfs_super.c.
Yeah, we don't currently have one.

> I don't know how mark_inode_dirty ends up calling xfs_trans_commit, but
It doesn't, but xfs_trans_commit() does eventually call mark_inode_dirty_sync()
through the IOP_FORMAT() log item operation.  If we are committing a transaction
that involves an inode then we must have just modified the inode so this is a
good time to mark it dirty so that it gets written out to disk later.

> is it required to commit the dirty status of an inode to the transaction
> log?
No, not the dirty status - just the changes that made it dirty (actually the
dirty status is in the Linux inode and we commit the xfs inode to the log).

> 
> FWIW, this is a slow laptop hdd (5400 rpm, ST96812AS), but latency of 1
> second is still big.
> 
> Are there any settings I can tweak to reduce latency?
Um, not that I am aware of.

> 
> LatencyTOP output during a 'svn up' on llvm-gcc source tree:
> 
> Cause                                                Maximum     Percentage
> Marking inode dirty                               1105.8 msec          7.8 %
> _xfs_buf_ioapply default_wake_function xlog_state_1065.2 msec          7.0 %
> Deleting an inode                                 964.8 msec         20.0 %
> _xfs_buf_ioapply default_wake_function xlog_state_780.1 msec          8.3 %
> _xfs_buf_ioapply default_wake_function xlog_state_679.4 msec          3.3 %
> _xfs_buf_ioapply default_wake_function xlog_state_610.1 msec          5.6 %
> XFS I/O wait                                      585.9 msec         12.6 %
> _xfs_buf_ioapply default_wake_function xlog_state_528.8 msec          6.8 %
> Creating block layer request                      499.6 msec          5.7 %
> 
> Earlier I've seen this latencyTOP output too:
> 
> Cause                                                Maximum     Percentage
> XFS I/O wait                                      407.6 msec         53.4 %
> Marking inode dirty                               173.0 msec          0.9 %
> Writing a page to disk                            141.6 msec         42.6 %
> __generic_unplug_device default_wake_function xfs_ 86.0 msec          0.3 %
> Page fault                                         44.1 msec          0.2 %
> kobject_put put_device blk_start_queueing __generi 15.9 msec          0.1 %
> Scheduler: waiting for cpubuf_find kmem_zone_alloc 12.4 msec          2.2 %
> put_device scsi_request_fn blk_start_queueing defa  4.9 msec          0.0 %
> Waiting for event (poll)                            4.7 msec          0.4 %
> 
> Process svn (10685)
> Writing a page to disk                             23.9 msec         55.9 %
> XFS I/O wait                                       15.9 msec         35.2 %
> Scheduler: waiting for cpu                          0.8 msec          8.9 %
> 
> Raw output from /proc/latency shows stacktrace:
> 
> 7 93862 26567 _xfs_buf_ioapply default_wake_function
> xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
> xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab xfs_create
> xfs_vn_mknod security_inode_permission
> 1 96331 96331 default_wake_function xlog_state_get_iclog_space
> xlog_state_release_iclog xlog_write xfs_log_write _xfs_trans_commit
> __mark_inode_dirty igrab xfs_create xfs_vn_mknod
> security_inode_permission xfs_vn_permission
> 
These don't look like valid stacktraces - are you sure they aren't just
the major offenders for latency delays?

Lachlan
