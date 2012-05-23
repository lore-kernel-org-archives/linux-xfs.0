Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4NIJbj8224348 for <xfs@oss.sgi.com>; Wed, 23 May 2012 13:19:37 -0500
Message-ID: <4FBD2A33.8080403@sgi.com>
Date: Wed, 23 May 2012 13:19:31 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v3 2/2] xfs: fix xfsaild hang due to lost wake ups
References: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
	<1337704714-50235-3-git-send-email-bfoster@redhat.com>
	<20120523005830.GL25351@dastard> <4FBD2306.8090000@redhat.com>
In-Reply-To: <4FBD2306.8090000@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 05/23/12 12:48, Brian Foster wrote:
> On 05/22/2012 08:58 PM, Dave Chinner wrote:
> snip
>>
>> Finally, rather than calling wake_up_process() in the
>> xfs_ail_push*() functions, call wake_up(&ailp->xa_idle); There can
>> only be one thread sleeping on that (the xfsaild) so there is no
>> need to use the wake_up_all() variant...
>>
>> FWIW, you might be able to do this without the idle wait queue and
>> just use wake_up_process() -
>>
>
> Hi Dave,
>
> I have a working version of your suggested algorithm. It looks mostly the same with the exception of a spin_unlock fix. I also have the below version that uses a wait_queue and that I plan to test overnight tonight:
>
...

FYI. Test 273 in a loop will still cause the sync_worker to lock when it 
tries to allocate a dummy transaction.

PID: 29214  TASK: ffff8807e66404c0  CPU: 1   COMMAND: "kworker/1:15"
  #0 [ffff88081f551b60] __schedule at ffffffff814175d0
  #1 [ffff88081f551ca8] schedule at ffffffff81417944
  #2 [ffff88081f551cb8] xlog_grant_head_wait at ffffffffa055a6d5 [xfs]
  #3 [ffff88081f551d08] xlog_grant_head_check at ffffffffa055a856 [xfs]
  #4 [ffff88081f551d48] xfs_log_reserve at ffffffffa055a95f [xfs]
  #5 [ffff88081f551d88] xfs_trans_reserve at ffffffffa0557ee4 [xfs]
  #6 [ffff88081f551dd8] xfs_fs_log_dummy at ffffffffa050cf88 [xfs]
  #7 [ffff88081f551df8] xfs_sync_worker at ffffffffa0518454 [xfs]
  #8 [ffff88081f551e18] process_one_work at ffffffff810564ad
  #9 [ffff88081f551e68] worker_thread at ffffffff81059203
#10 [ffff88081f551ee8] kthread at ffffffff8105dd2e
#11 [ffff88081f551f48] kernel_thread_helper at ffffffff81421a64

I understand why the dummy transaction was added and I think we can 
anticipate the hang before it happens and avoid it.


--Mark T.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
