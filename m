Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 00:59:08 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M8x0Cg005680
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:59:01 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A83260613E
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:59:25 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156]) by cuda.sgi.com with ESMTP id bdLNauLsRveNpfjc for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:59:25 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so253485fga.8
        for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:59:24 -0800 (PST)
Message-ID: <47BE8EE8.5020005@gmail.com>
Date: Fri, 22 Feb 2008 10:59:20 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Marking inode dirty latency > 1000 msec on XFS!
References: <47B5DD9C.3080906@gmail.com> <47BE6C5C.2000605@sgi.com>
In-Reply-To: <47BE6C5C.2000605@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Arjan van de Ven <arjan@linux.intel.com>, xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Török Edwin wrote:
>> Hi,
>>
>> Using LatencyTOP 0.3, on the latest 2.6.25-git I see latencies of over a
>> second on __mark_ inode_dirty.
> These are the maximum latencies, right?  

Yes.
> What would be useful here is the
> average latency time.  The average might actually be quite low but if
> just
> once we have a maximum that is unusually large then just looking at that
> figure can be misleading.

I'll try to collect the raw numbers from /proc/latency_stats, that
contain a count, total time, and max time.

>> I don't know how mark_inode_dirty ends up calling xfs_trans_commit, but
> It doesn't, but xfs_trans_commit() does eventually call
> mark_inode_dirty_sync()
> through the IOP_FORMAT() log item operation.  If we are committing a
> transaction
> that involves an inode then we must have just modified the inode so
> this is a
> good time to mark it dirty so that it gets written out to disk later.

Ok, then I misinterpreted the stacktrace, see below.
[@Arjan: are the stacktraces below valid?]
I thought mark_inode_dirty calls xfs_trans_commit().

>>
>> 7 93862 26567 _xfs_buf_ioapply default_wake_function
>> xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
>> xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab xfs_create
>> xfs_vn_mknod security_inode_permission
>> 1 96331 96331 default_wake_function xlog_state_get_iclog_space
>> xlog_state_release_iclog xlog_write xfs_log_write _xfs_trans_commit
>> __mark_inode_dirty igrab xfs_create xfs_vn_mknod
>> security_inode_permission xfs_vn_permission
>>
> These don't look like valid stacktraces - are you sure they aren't just
> the major offenders for latency delays?

Looking at this entry, I assumed stacktraces are meant to be interpreted
right to left (sys_read calls do_sync_read, etc.)

4 8 2 hrtick_set pipe_wait autoremove_wake_function pipe_read
do_sync_read autoremove_wake_function __resched_task
security_file_permission rw_verify_area vfs_read do_sync_read sys_read

However here,  if _xfs_trans_commit is calling __mark_inode_dirty,  I am
confused.

Also we have default_wake_function here, does that somehow invalidate
the stacktrace, or change the direction I should be reading it? Arjan?

7 93862 26567 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab xfs_create
xfs_vn_mknod security_inode_permission

Best regards,
--Edwin
