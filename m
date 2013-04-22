Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 903927F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 10:11:38 -0500 (CDT)
Message-ID: <5175532B.3050509@sgi.com>
Date: Mon, 22 Apr 2013 10:11:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: shutdown filesystem if xfs_perag_get fails
References: <20130419204102.736961610@sgi.com>
	<20130421174107.007313126@sgi.com>
	<5174603A.8030208@sandeen.net> <51753EDE.6000301@sgi.com>
	<51754A13.5000808@sandeen.net>
In-Reply-To: <51754A13.5000808@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 04/22/13 09:32, Eric Sandeen wrote:
> On 4/22/13 8:45 AM, Mark Tinguely wrote:
>> On 04/21/13 16:55, Eric Sandeen wrote:
>>> On 4/21/13 12:41 PM, Mark Tinguely wrote:
>>>
>>>> This problem happened locally with a bad inode number from xfs
>>>> recovery. xfs_perag_get() can return NULL if given a bad agno.
>>>> Most callers of xfs_perag_get() do not check for a NULL before
>>>> using the pointer. This patch forces a shutdown of the filesystem
>>>> for those callers that do not check the return value rather than
>>>> crashing on a dereferenced NULL pointer.
>>>
>>> Hi Mark -
>>>
>>> I'm curious, what was the callchain when this happened?  Was it
>>> during recovery?  If so, would aborting recovery be more prudent?
>>>
>>> I might be missing something, but I'm not sure how shutting
>>> down avoids a subsequent null ptr deref&   crash.
>>>
>>> i.e. if a caller does something like:
>>>
>>>           pag = xfs_perag_get(mp, agno);
>>>           spin_lock(&pag->pagb_lock);
>>>
>>> shutting down in xfs_perag_get doesn't save us from a
>>> null pag pointer, would it?
>>>
>>> Thanks,
>>> -Eric
>>
>> You are correct, we have to exit the routine(s) to avoid the dereference. Let the callers handle the error.
>>
>> Sorry for the noise.
>
> No problem, glad I'm useful on the rare occasion.  ;)
>
> Can you share the backtrace on the null deref you saw?
>
> Thanks,
> -Eric
>
PID: 7965   TASK: ffff88013566c040  CPU: 0   COMMAND: "mount"
  #0 [ffff8801356035d0] machine_kexec at ffffffff810265ce
  #1 [ffff880135603620] crash_kexec at ffffffff810a3b5a
  #2 [ffff8801356036f0] oops_end at ffffffff81442de8
  #3 [ffff880135603710] __bad_area_nosemaphore at ffffffff81032995
  #4 [ffff8801356037d0] do_page_fault at ffffffff8144558b
  #5 [ffff8801356038d0] page_fault at ffffffff81442065
     [exception RIP: _raw_spin_lock+5]
     RIP: ffffffff81441985  RSP: ffff880135603980  RFLAGS: 00010206
     RAX: 0000000000010000  RBX: ffff880135530340  RCX: 0000000000000000
     RDX: 0000000000000001  RSI: 0000000000000013  RDI: 0000000000000090
     RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000003
     R10: ffff880134d96d00  R11: ffffffff8101ff60  R12: 0000000000000000
     R13: 00000042bb4c2000  R14: 0000000000002000  R15: ffff880135530340
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #6 [ffff880135603980] _xfs_buf_find at ffffffffa01a7fef [xfs]
  #7 [ffff8801356039f0] xfs_buf_get at ffffffffa01a824a [xfs]
  #8 [ffff880135603a30] xfs_buf_read at ffffffffa01a83a4 [xfs]
  #9 [ffff880135603a60] xlog_recover_inode_pass2 at ffffffffa0193629 [xfs]
#10 [ffff880135603ac0] xlog_recover_commit_trans at ffffffffa0194166 [xfs]
#11 [ffff880135603af0] xlog_recover_process_data at ffffffffa0194351 [xfs]
#12 [ffff880135603b50] xlog_do_recovery_pass at ffffffffa0194804 [xfs]
#13 [ffff880135603c80] xlog_do_log_recovery at ffffffffa0194aa7 [xfs]
#14 [ffff880135603cb0] xlog_do_recover at ffffffffa0194aea [xfs]
#15 [ffff880135603cd0] xlog_recover at ffffffffa019592e [xfs]
#16 [ffff880135603cf0] xfs_log_mount at ffffffffa018d524 [xfs]
#17 [ffff880135603d20] xfs_mountfs at ffffffffa0198a13 [xfs]
#18 [ffff880135603d70] xfs_fs_fill_super at ffffffffa01b0ac9 [xfs]
#19 [ffff880135603db0] mount_bdev at ffffffff811544fe
#20 [ffff880135603e20] mount_fs at ffffffff81153ece
#21 [ffff880135603e60] vfs_kern_mount at ffffffff8116f975
#22 [ffff880135603e90] do_kern_mount at ffffffff8116fa63
#23 [ffff880135603ed0] do_mount at ffffffff81170a7d
#24 [ffff880135603f30] sys_mount at ffffffff81170b80
#25 [ffff880135603f80] system_call_fastpath at ffffffff81449692
     RIP: 00007fd46cac51ea  RSP: 00007fff910bdde8  RFLAGS: 00010206
     RAX: 00000000000000a5  RBX: ffffffff81449692  RCX: ffffffffc0ed0000
     RDX: 0000000000626fb0  RSI: 000000000061de90  RDI: 000000000061de70
     RBP: 00007fff910be0cc   R8: 0000000000000000   R9: 00007fff910bdad0
     R10: ffffffffc0ed0000  R11: 0000000000000206  R12: 0000000000626fb0
     R13: 0000000000000000  R14: 00000000c0ed0000  R15: 00007fff910be040
     ORIG_RAX: 00000000000000a5  CS: 0033  SS: 002b


The recovery value is bad and is a problem on its own, but XFS does not 
verify the validity of ag number when doing a xfs_perag_get().

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
