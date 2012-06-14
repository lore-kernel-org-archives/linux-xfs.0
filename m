Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5EHDFGM005461 for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 12:13:15 -0500
Message-ID: <4FDA1BA8.4080402@sgi.com>
Date: Thu, 14 Jun 2012 12:13:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard> <20120524223952.GU16099@sgi.com>
	<20120525204536.GA4721@sgi.com> <20120606042647.GK22848@dastard>
	<20120611204516.GR4721@sgi.com> <4FD65F00.1010309@sgi.com>
	<20120611233618.GD22848@dastard>
In-Reply-To: <20120611233618.GD22848@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 06/11/12 18:36, Dave Chinner wrote:
> On Mon, Jun 11, 2012 at 04:11:28PM -0500, Mark Tinguely wrote:
>> On 06/11/12 15:45, Ben Myers wrote:
>> ...
>>
>>> That sounds pretty good.  In particular, I think that making the start
>>> and stop of the workqueues correct should be the high priority.  I'm not
>>> as concerned about the accuracy of the names, or cleaning up xfs_sync.c
>>> and xfs_iget.c, but cleanups are worth doing too.
>>>
>>> I hit a crash related to the xfslogd workqueue awhile back.  Mark has
>>> taken it up, so there might be a little coordination to do with him.
>>>
>>> Regards,
>>> 	Ben
>>
>> To not leave a teaser out there:
>>
>> PID: 25879  TASK: ffff88012ac20340  CPU: 3   COMMAND: "kworker/3:3"
>>   #0 [ffff8801a72af920] machine_kexec at ffffffff810244e9
>>   #1 [ffff8801a72af990] crash_kexec at ffffffff8108d053
>>   #2 [ffff8801a72afa60] oops_end at ffffffff813ad1b8
>>   #3 [ffff8801a72afa90] no_context at ffffffff8102bd48
>>   #4 [ffff8801a72afae0] __bad_area_nosemaphore at ffffffff8102c04d
>>   #5 [ffff8801a72afb30] bad_area_nosemaphore at ffffffff8102c12e
>>   #6 [ffff8801a72afb40] do_page_fault at ffffffff813afaee
>>   #7 [ffff8801a72afc50] page_fault at ffffffff813ac635
>>      [exception RIP: xlog_assign_tail_lsn_locked+72]
>>      RIP: ffffffffa040da68  RSP: ffff8801a72afd00  RFLAGS: 00010246
>>      RAX: 0000000000000000  RBX: 0000000000000000  RCX: dead000000200200
>>      RDX: ffff88013b32d550  RSI: dead000000100100  RDI: ffff88013b32d550
>>      RBP: ffff8801a72afd10   R8: ffff8801a72ae000   R9: 0000000000000000
>>      R10: 0000000000000000  R11: 0000000000000000  R12: ffff88013b32d568
>>      R13: 0000000000000001  R14: ffff8801a72afd90  R15: ffff88013b32d540
>>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>   #8 [ffff8801a72afd18] xfs_trans_ail_delete_bulk at ffffffffa0414b2a [xfs]
>>   #9 [ffff8801a72afd78] xfs_buf_iodone at ffffffffa04119c7 [xfs]
>> #10 [ffff8801a72afdb8] xfs_buf_do_callbacks at ffffffffa041166c [xfs]
>> #11 [ffff8801a72afdd8] xfs_buf_iodone_callbacks at ffffffffa04117de [xfs]
>> #12 [ffff8801a72afdf8] xfs_buf_iodone_work at ffffffffa03ad7e1 [xfs]
>> #13 [ffff8801a72afe18] process_one_work at ffffffff8104c53b
>> #14 [ffff8801a72afe68] worker_thread at ffffffff8104f0e3
>> #15 [ffff8801a72afee8] kthread at ffffffff8105395e
>> #16 [ffff8801a72aff48] kernel_thread_helper at ffffffff813b3ae4
>>
>> I am just digging through that crash. It appears that xfs_umountfs()
>> did a good job in cleaning the AIL and the m_ddev_targp, but it
>> needs to wait for the xfslogd to be finished before deallocating the
>> log.
>
> It is supposed to be already idle before the log is torn down.  The
> log is forced synchronously while flushes remaining CIL items, then
> the AIL is emptied synchronously. That should result in no
> outstanding log operations to be run. Then xfs_log_unmount_write()
> is called, which is supposed to wait for the log write to complete
> before allowing the log to be torn down in xfs_log_unmount(). i.e.
> it is also synchronous.
>
> So the question that needs to be answered is this: what is the
> transaction/checkpoint that is being completed here?
>
>> Since workqueues are cheap, maybe it would be smart to have a
>> per-filesystem xfslogd too.
>
> That's overkill. If all we need is to ensure that we have emptied
> the logd wq, then a synchronous flush is all that is necessary. But
> first we need to find the cause of the above problem, and I'd
> suggest a new thread for that...
>
> Cheers,
>
> Dave.

I know this should be a separate thread, but a quick FYI that the buffer
that is being flushed has the XFS_SB_MAGIC in it. A late dirty of the
superblock from the shutdown process?


--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
