Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39ED47F50
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 07:58:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8295AC014
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 05:58:51 -0700 (PDT)
Message-ID: <51543E67.1070309@oracle.com>
Date: Thu, 28 Mar 2013 20:58:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [ASSERT failure] transaction reservations changes bad?
References: <20130312062001.GJ21651@dastard> <20130312062531.GK21651@dastard>
	<513EE274.6090808@oracle.com> <20130312103138.GN21651@dastard>
	<513F0C07.1060000@oracle.com> <513F17F3.1010204@oracle.com>
	<20130312120545.GO21651@dastard> <51517506.1020906@oracle.com>
	<5151D057.1040604@sgi.com>
In-Reply-To: <5151D057.1040604@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 03/27/2013 12:44 AM, Mark Tinguely wrote:
> On 03/26/13 05:14, Jeff Liu wrote:
>> On 03/12/2013 08:05 PM, Dave Chinner wrote:
>>> On Tue, Mar 12, 2013 at 07:56:35PM +0800, Jeff Liu wrote:
>>>> More info, 3.7.0 is the oldest kernel on my environment, I ran into the
>>>> same problem.
>>>
>>> Thanks for following up so quickly, Jeff. So the problem is that a
>>> new test is tripping over a bug that has been around for a while,
>>> not that it is a new regression.
>>>
>>> OK, so I'll expunge that from my testing for the moment as I don't
>>> ahve time to dig in and find out what the cause is right now. If
>>> anyone else wants to.... :)
>>
>> I did some further tests to nail down this issue, just posting the analysis result here,
>> it might be of some use when we revising it again.
>>
>> The disk is formated with Dave's previous comments, i.e.
>> mkfs.xfs -f -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b /dev/xxx
>>
>> First of all, looks this bug stayed in hiding for years since I can reproduce it between upstream
>> 3.0 to 3.9.0-rc3, the oldest kernel I have tried is 2.6.39 which has the same problem.
>>
>> The following tests are running against kernel with CONFIG_XFS_DEBUG is enabled.
>>
>> 1) Create directory will cause kernel panic, observed same info to Dave's previous posts.
>>
>> [ 3846.705416] XFS: Assertion failed: BTOBB(need_bytes)<  log->l_logBBsize, file: fs/xfs/xfs_log.c, line:
> 
> Thanks Jeff for looking at this. I did not look beyond printing the 
> BTOBB(need_bytes) and log->l_logBBsize.
Sorry for my late response.
> 
> okay the reservation is larger than the logspace defined.
> 
>   Is the create directory reserving too much?
Yes, it need 3531 blocks, but only 2560 blocks is reserved for the logspace.
>   Is the minimum log size too small?
927 blocks(i.e. max_tr_res * XFS_MIN_LOG_FACTOR) which can be detected at mkfs stage.
> 
> I did not dig too deep into all the possible directory conversion that 
> could happen when one more entry was put in the directory.
> 
>>
>> 2) For a refreshed formated XFS partition, create a regular file via `touch /xfs/test_file`, the process
>> will hang and the following syslog were observed:
>>
>> Mar 26 14:15:35 linux64bit kernel: [  841.804353] INFO: task kworker/0:2:2118 blocked for more than 120 seconds.
>> Mar 26 14:15:35 linux64bit kernel: [  841.804361] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Mar 26 14:15:35 linux64bit kernel: [  841.804364] kworker/0:2     D ffffffff8180cfa0     0  2118      2 0x00000000
>> Mar 26 14:15:35 linux64bit kernel: [  841.804372]  ffff880079bfdc18 0000000000000046 ffff880076bdc5c0 0000000000014e40
>> Mar 26 14:15:35 linux64bit kernel: [  841.804378]  ffff880062b31720 ffff880079bfdfd8 ffff880079bfdfd8 ffff880079bfdfd8
>> Mar 26 14:15:35 linux64bit kernel: [  841.804382]  ffffffff81c13440 ffff880062b31720 ffff880079bfdc38 ffff880079165cf0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804387] Call Trace:
>> Mar 26 14:15:35 linux64bit kernel: [  841.804400]  [<ffffffff8169c399>] schedule+0x29/0x70
>> Mar 26 14:15:35 linux64bit kernel: [  841.804444]  [<ffffffffa037e15a>] xlog_grant_head_wait+0x15a/0x2b0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804466]  [<ffffffff81692bf3>] ? printk+0x61/0x63
>> Mar 26 14:15:35 linux64bit kernel: [  841.804500]  [<ffffffffa037e414>] xlog_grant_head_check+0x164/0x1d0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804530]  [<ffffffffa037ff8e>] xfs_log_reserve+0x24e/0x3e0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804561]  [<ffffffffa037b747>] xfs_trans_reserve+0x327/0x360 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804589]  [<ffffffffa032dd84>] ? kmem_zone_zalloc+0x34/0x50 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804613]  [<ffffffffa031bbb0>] xfs_fs_log_dummy+0x80/0x130 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804643]  [<ffffffffa0381524>] xfs_log_worker+0x54/0x120 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804650]  [<ffffffff8107805b>] process_one_work+0x16b/0x400
>> Mar 26 14:15:35 linux64bit kernel: [  841.804655]  [<ffffffff81078ce9>] worker_thread+0x119/0x360
>> Mar 26 14:15:35 linux64bit kernel: [  841.804660]  [<ffffffff81078bd0>] ? manage_workers+0x350/0x350
>> Mar 26 14:15:35 linux64bit kernel: [  841.804665]  [<ffffffff8107e200>] kthread+0xc0/0xd0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804669]  [<ffffffff8107e140>] ? flush_kthread_worker+0xb0/0xb0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804675]  [<ffffffff816a5d2c>] ret_from_fork+0x7c/0xb0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804679]  [<ffffffff8107e140>] ? flush_kthread_worker+0xb0/0xb0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804685] INFO: task touch:2323 blocked for more than 120 seconds.
>> Mar 26 14:15:35 linux64bit kernel: [  841.804687] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Mar 26 14:15:35 linux64bit kernel: [  841.804689] touch           D ffffffff8180cfa0     0  2323   2128 0x00000000
>> Mar 26 14:15:35 linux64bit kernel: [  841.804694]  ffff8800791419b8 0000000000000086 ffff880076bdc5c0 0000000000014e40
>> Mar 26 14:15:35 linux64bit kernel: [  841.804699]  ffff88003032ae40 ffff880079141fd8 ffff880079141fd8 ffff880079141fd8
>> Mar 26 14:15:35 linux64bit kernel: [  841.804703]  ffffffff81c13440 ffff88003032ae40 ffff8800791419d8 ffff880079993000
>> Mar 26 14:15:35 linux64bit kernel: [  841.804707] Call Trace:
>> Mar 26 14:15:35 linux64bit kernel: [  841.804713]  [<ffffffff8169c399>] schedule+0x29/0x70
>> Mar 26 14:15:35 linux64bit kernel: [  841.804740]  [<ffffffffa037e15a>] xlog_grant_head_wait+0x15a/0x2b0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804745]  [<ffffffff81692bf3>] ? printk+0x61/0x63
>> Mar 26 14:15:35 linux64bit kernel: [  841.804772]  [<ffffffffa037e461>] xlog_grant_head_check+0x1b1/0x1d0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804798]  [<ffffffffa037ff8e>] xfs_log_reserve+0x24e/0x3e0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804826]  [<ffffffffa037b747>] xfs_trans_reserve+0x327/0x360 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804854]  [<ffffffffa032ac34>] xfs_create+0x184/0x6f0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804880]  [<ffffffffa0322e4b>] xfs_vn_mknod+0xcb/0x1e0 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804904]  [<ffffffffa0322f93>] xfs_vn_create+0x13/0x20 [xfs]
>> Mar 26 14:15:35 linux64bit kernel: [  841.804913]  [<ffffffff811a29c5>] vfs_create+0xb5/0x130
>> Mar 26 14:15:35 linux64bit kernel: [  841.804918]  [<ffffffff811a37ca>] do_last+0xd8a/0xec0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804926]  [<ffffffff812fe01c>] ? apparmor_file_alloc_security+0x2c/0x60
>> Mar 26 14:15:35 linux64bit kernel: [  841.804932]  [<ffffffff811a39b8>] path_openat+0xb8/0x4c0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804937]  [<ffffffff81158741>] ? handle_mm_fault+0x271/0x390
>> Mar 26 14:15:35 linux64bit kernel: [  841.804943]  [<ffffffff811a4552>] do_filp_open+0x42/0xa0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804949]  [<ffffffff811b1675>] ? __alloc_fd+0xe5/0x170
>> Mar 26 14:15:35 linux64bit kernel: [  841.804955]  [<ffffffff811941de>] do_sys_open+0xfe/0x1e0
>> Mar 26 14:15:35 linux64bit kernel: [  841.804960]  [<ffffffff811942e1>] sys_open+0x21/0x30
>> Mar 26 14:15:35 linux64bit kernel: [  841.804966]  [<ffffffff816a5dd9>] system_call_fastpath+0x16/0x1b
>>
>> It most likely a deadlock or dead loop was occurred according to above tracing info.
>> Then I did some investigation to check what had happened in transaction log space reservations
>> between mount a refreshed formated XFS partition and create a new file by adding some debugging code.
>>
>> As per the current disk formating, the totally log space is 2560 * 1024 = 2621440 bytes.
>> By default, there are 1310720 bytes free space on both l_reserve_head.grant and l_write_head.grant separately.
> 
> The reserve and write grant use the whole space. Look at the xlog and 
> CIL CTX values when hung.
But the maximum reservation size can not larger than a half the log.
>>
>> Firstly, I observed a non-permanent CIL ticket allocation at xlog_cil_init_post_recovery() for xfs_log_mount(),
>> and it has no affect to our situation.
>>
>> Secondly, xfs_vn_update_time() is invoked per mount the partition, and hence the XFS_TRANS_FSYNC_TS transaction
>> was happened, it need 532916 bytes for the space reservation, then give back 208 bytes at xlog_ungrant_log_space()
>> after xfs_trans_commit().  Therefore, it only reserved (532916 - 208) bytes in this transaction, now there has
>> 1310720 - (532916 - 208) = 778012 bytes left at l_reserve_head.grant.
>>
>> Finally, creating a file will make XFS_TRANS_CREATE happened, and it need to reserve 1205208 bytes, however, there
>> only has 778012 bytes can be reserved, so that the process hang at the loop of xlog_grant_head_wait() and then call
>> schedule() to let other processes wake up and running.
>>
>> In this situation, xfs_log_worker() will up and running, as this is the 1st time it was issued, the call chains was
>> shown as following:
>> ........
>> ......
>> xlog_log_force()
>>    __xfs_log_force() ->  xfs_sync()
>>      xlog_cil_force_lsn()
>>        xlog_cil_push()
>>          xlog_log_done()
>>            xlog_ungrant_log_space()
>> 	    xlog_log_space_wake()
>> 	      xlog_grant_head_wake()...
>>
>> Up to now, there should left 1306396 bytes in l_reserve_head.grant since I observed this CHECKPOINT transaction
>> gave back 528384 bytes at xlog_ungrant_log_space(), so that 528384 + 778012 = 1306396 bytes, but that's is not
>> exactly, because it reserved 257820 bytes at xfs_sync(), so the left space is 1306396 - 257820 = 1048576 bytes.
>>
>> Once xfs_log_worker() run completed, the previous XFS_TRANS_CREATE is revived at the point after schedule(),
>> but the free space(1048576) is less than the required(1205208), as a result, it got blocked again.
>>
>> Periodicity, xfs_log_worker() comes up, but this time it gone through XFS_TRANS_DUMMY instead.  In this case, the
>> current free space is enough for this reservations because it requires 533172 bytes only, however, it also hang at
>> the point of xlog_grant_head_wait() before schedule() because there only has one log transaction related process
>> belong to the file creation would be scheduled, but this process will be blocked again due to the lack of log space.
> 
> Yes, it will get blocked behind the previous allocations.
> 
>>
>> The question is that even if XFS_TRANS_DUMMY was not got involved, XFS_TRANS_CREATE would still be blocked as the log
>> space reservation can not be satisfied.  IMHO, looks the major cause is related to the 'sunit' parameter, since it would
>> affect the log space unit calculations by '2*log->l_mp->m_sb.sb_logsunit' at xlog_ticket_alloc().  However, we don't include
>> this factor into consideration at mkfs or mount stage, should we take it into account?
>>
> 
> There is at least one other (controversial) log (over-) allocation, but 
> this is not involved here.
> 
> It is easy to hang small logs. I classify them as soft and hard hands.
> 
> Soft hangs can be restarted with a new transactions (touch/mkdir) that 
> request grant space and forces a push the AIL up to the last_sync value.
> 
> This looks like a hard hang. Most of the time, the CIL, CTX ticket and 
> any permanent tickets can enough hold space that a simple AIL push 
> cannot get it going again. Tickets have to allocate for the worse case. 
> Most time they give back this worse case space when the CIL is pushed.
> 
> 2 log blocksize or log stripe unit for rounding is added to every 
> allocation, so that is already counted in the "bytes_needed".
Thanks for the clarification. Yes, there are particular additional bytes
are padded to every allocation for rounding, however, that's belong to the
runtime space reservation requests IMHO, but we ran into this issue because
the specified log space is too small for current configuration.

Regards,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
