Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 02:26:47 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1MAQg85011255
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 02:26:43 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33E7FE90851
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 02:27:05 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158]) by cuda.sgi.com with ESMTP id K7lUshdNWNzghK1S for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 02:27:05 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so269479fga.8
        for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 02:27:04 -0800 (PST)
Message-ID: <47BEA1E7.3010107@gmail.com>
Date: Fri, 22 Feb 2008 12:20:23 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Marking inode dirty latency > 1000 msec on XFS!
References: <47B5DD9C.3080906@gmail.com> <47BE6C5C.2000605@sgi.com> <47BE8EE8.5020005@gmail.com>
In-Reply-To: <47BE8EE8.5020005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Arjan van de Ven <arjan@linux.intel.com>, xfs@oss.sgi.com, David Chinner <dgc@sgi.com>

Török Edwin wrote:
>> What would be useful here is the
>> average latency time.  The average might actually be quite low but if
>> just
>> once we have a maximum that is unusually large then just looking at that
>> figure can be misleading.
>>     
>
> I'll try to collect the raw numbers from /proc/latency_stats, that
> contain a count, total time, and max time.

I was not able to reproduce the 1 second latency with David Chinner's
reduce xaild wakeups patch, the maximum latency  I got was 685 msec.

See below the numbers I got from /proc/latency_stats, the counters are
reset every 30 seconds, so I did more captures, and noted the top 3 (for
the 2nd case).

Notice the irq_exit in the first case (w/o patch), which is present in
the top latencies. There is no irq_exit in the second case.
@Arjan: I am not sure if stacktraces containing irq_exit() are entirely
valid, or the stacktrace should be stopped when it is encountered.

Here are the numbers w/o the wakeups patch (1 capture of grep mark_inode
/proc/latency_stats)

<count> <sum> <maximum> <stacktrace>
----------------
2 47699 36897 xfs_buf_free default_wake_function xfs_buf_lock xfs_getsb
xfs_trans_getsb xfs_trans_apply_sb_deltas _xfs_trans_commit
xfs_dir_createname kmem_zone_alloc __mark_inode_dirty igrab xfs_create
1 1045646 1045646 wake_up_state default_wake_function xfs_buf_lock
xfs_getsb xfs_trans_getsb xfs_trans_apply_sb_deltas _xfs_trans_commit
irq_exit xfs_dir_createname kmem_zone_alloc __mark_inode_dirty igrab
1 818946 818946 default_wake_function xfs_buf_lock xfs_getsb
xfs_trans_getsb xfs_trans_apply_sb_deltas _xfs_trans_commit irq_exit
xfs_dir_createname kmem_zone_alloc __mark_inode_dirty igrab xfs_create

Average = 478072 usecs
-----------------

Here are the numbers w/ the wakeups patch:(3 captures of grep mark_inode
/proc/latency_stats)
<count> <sum> <maximum> <stacktrace>
-----------
1 685021 685021 xfs_buf_free default_wake_function xfs_buf_lock
xfs_getsb xfs_trans_getsb xfs_trans_apply_sb_deltas _xfs_trans_commit
xfs_dir_createname xfs_dir_ialloc __mark_inode_dirty igrab xfs_create

Only one sample, average=max
----------
20 153016 8989 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab xfs_create
xfs_vn_mknod security_inode_permission

Average: 153016/20 = 7650 usecs
----------
28 250553 28743 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab xfs_create
xfs_vn_mknod security_inode_permission
4 32829 8843 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_state_want_sync
xlog_write xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab
xfs_create xfs_vn_mknod
1 7554 7554 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
xfs_log_write _xfs_trans_commit xfs_bmap_last_offset xfs_dir_createname
xfs_dir_ialloc __mark_inode_dirty igrab
1 7011 7011 _xfs_buf_ioapply xfs_buf_iorequest xlog_bdstrat_cb
default_wake_function xlog_state_get_iclog_space xlog_write
__mark_inode_dirty kmem_free xfs_buf_item_format xfs_log_write
_xfs_trans_commit igrab
28 250553 28743 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab xfs_create
xfs_vn_mknod security_inode_permission
4 32829 8843 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_state_want_sync
xlog_write xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab
xfs_create xfs_vn_mknod
1 7554 7554 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
xfs_log_write _xfs_trans_commit xfs_bmap_last_offset xfs_dir_createname
xfs_dir_ialloc __mark_inode_dirty igrab
1 7011 7011 _xfs_buf_ioapply xfs_buf_iorequest xlog_bdstrat_cb
default_wake_function xlog_state_get_iclog_space xlog_write
__mark_inode_dirty kmem_free xfs_buf_item_format xfs_log_write
_xfs_trans_commit igra

Average = 8762 usecs

Best regards,
--Edwin
