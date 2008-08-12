Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 19:32:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7C2WVgB006258
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 19:32:32 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4B313841D7
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 19:33:44 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id C8fVtCBMFs0eAQjq for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 19:33:44 -0700 (PDT)
Message-ID: <48A0F686.2090700@tlinx.org>
Date: Mon, 11 Aug 2008 19:33:42 -0700
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net>
In-Reply-To: <48A09CA9.9080705@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> the explanation for xfs_fsr, at least, is the same as the last time you
> brought it up ;)
> http://lkml.org/lkml/2008/2/12/86
> -Eric
>   
---
Ah...Looks like the 1st xfs_fsr prob is the same as the one 6 months 
ago...(sorry)
    xfs_ilock & xfs_ilock

But... the 3 imapds and the sort process were all 4 holding
     xfs_ilock     &    shrink_icache_memory

And the other two xfs_fsr's were holding different locks than the 
6-month-ago bug:
    dio_get_page   &   xfs_ilock

Are these the same as well?

I.e. looks like 3 possibly different probs:
    #1 (same as 6 months ago)...
    #2 (3)imapds & sort:      holding   xfs_ilock   &  shrink_icache
    #3 xfs_fsr with two different locks:      dio_get_page   &   xfs_ilock


(clipped output below...)
----------------

(#0)
Cause unknown...why dump?
---
Jul 25 18:21:28 kern: Clocksource tsc unstable (delta = 571817442154 ns)
Jul 25 18:21:28 kern: Modules linked in: uhci_hcd
Jul 25 18:21:28 kern:
Jul 25 18:21:28 kern: Pid: 183, comm: cifsoplockd Not tainted 
(2.6.26-ish #2)
Jul 25 18:21:28 kern: EIP: 0060:[<b0412437>] EFLAGS: 00000286 CPU: 1
Jul 25 18:21:28 kern: EIP is at _spin_unlock_irqrestore+0x7/0x10
Jul 25 18:21:28 kern: EAX: b05a8d00 EBX: efb13f54 ECX: b05a8d00 EDX: 
00000286
Jul 25 18:21:28 kern: ESI: 00000000 EDI: b01eaa90 EBP: efb13f24 ESP: 
efb13f24
Jul 25 18:21:28 kern:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jul 25 18:21:28 kern: CR0: 8005003b CR2: a7a2c000 CR3: 37c10000 CR4: 
000006d0
Jul 25 18:21:28 kern: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 
00000000
Jul 25 18:21:28 kern: DR6: ffff0ff0 DR7: 00000400
Jul 25 18:21:28 kern:  [<b012df2a>] try_to_del_timer_sync+0x4a/0x60
Jul 25 18:21:28 kern:  [<b012df51>] del_timer_sync+0x11/0x20
Jul 25 18:21:28 kern:  [<b0410dbf>] schedule_timeout+0x4f/0xc0
Jul 25 18:21:28 kern:  [<b012db20>] ? process_timeout+0x0/0x10
Jul 25 18:21:28 kern:  [<b0410db3>] ? schedule_timeout+0x43/0xc0
Jul 25 18:21:28 kern:  [<b01eabee>] cifs_oplock_thread+0x15e/0x230
Jul 25 18:21:28 kern:  [<b011a836>] ? complete+0x46/0x60
Jul 25 18:21:28 kern:  [<b01eaa90>] ? cifs_oplock_thread+0x0/0x230
Jul 25 18:21:28 kern:  [<b01375b2>] kthread+0x42/0x70
Jul 25 18:21:28 kern:  [<b0137570>] ? kthread+0x0/0x70
Jul 25 18:21:28 kern:  [<b0103c4f>] kernel_thread_helper+0x7/0x18
Jul 25 18:21:28 kern:  =======================


xfs_fsr#1    (looks like dup of 6-month-old bug)....
Jul 28 02:10:38 kern: 
=======================================================
Jul 28 02:10:38 kern: [ INFO: possible circular locking dependency 
detected ]
Jul 28 02:10:38 kern: 2.6.24.2-ish #5
Jul 28 02:10:38 kern: 
-------------------------------------------------------
Jul 28 02:10:38 kern: xfs_fsr/17758 is trying to acquire lock:
Jul 28 02:10:38 kern:  (&(&ip->i_lock)->mr_lock/2){----}, at: 
[<b025eced>]xfs_ilock+0x6d/0xb0
Jul 28 02:10:38 kern: but task is already holding lock:
Jul 28 02:10:38 kern:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
[<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern: other info that might help us debug this:
Jul 28 02:10:39 kern:
Jul 28 02:10:39 kern: 2 locks held by xfs_fsr/17758:
Jul 28 02:10:39 kern:  #0:  (&(&ip->i_iolock)->mr_lock/2){--..}, at: 
[<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern:  #1:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
[<b025ed17>] xfs_ilock+0x97/0xb0
-------------------



#2--imapds - shrink_icache_memory_xfs_ilock
Jul 29 02:07:29 kern: 
=======================================================
Jul 29 02:07:29 kern: [ INFO: possible circular locking dependency 
detected ]
Jul 29 02:07:29 kern: 2.6.25.12-ish #2
Jul 29 02:07:29 kern: 
-------------------------------------------------------
Jul 29 02:07:29 kern: imapds/26747 is trying to acquire lock:
Jul 29 02:07:29 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250
Jul 29 02:07:29 kern: but task is already holding lock:
Jul 29 02:07:29 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Jul 29 02:07:29 kern: other info that might help us debug this:
Jul 29 02:07:29 kern
Jul 29 02:07:29 kern: 2 locks held by imapds/26747:
Jul 29 02:07:29 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Jul 29 02:07:29 kern:  #1:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170




#3--xfs_fsr -- (doesn't look like previous bug)
    dio_get_page+xfs_ilock?
Jul 31 02:13:19 kern: 
=======================================================
Jul 31 02:13:19 kern: [ INFO: possible circular locking dependency 
detected ]
Jul 31 02:13:19 kern: 2.6.25.12-ish #2
Jul 31 02:13:19 kern: 
-------------------------------------------------------
Jul 31 02:13:19 kern: xfs_fsr/12232 is trying to acquire lock:
Jul 31 02:13:19 kern:  (&mm->mmap_sem){----}, at: [<c029d8aa>] 
dio_get_page+0x6a/0x170  
Jul 31 02:13:19 kern: but task is already holding lock:
Jul 31 02:13:19 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Jul 31 02:13:19 kern: which lock already depends on the new lock.

Jul 31 02:13:19 kern: 1 lock held by xfs_fsr/12232:
Jul 31 02:13:19 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0


#5 -- sort -- shrink_icache_memory & xfs_ilock
Aug  2 02:04:51 kern: 
=======================================================
Aug  2 02:04:51 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  2 02:04:51 kern: 2.6.25.12-ish #2
Aug  2 02:04:51 kern: 
-------------------------------------------------------
Aug  2 02:04:51 kern: sort/24453 is trying to acquire lock:
Aug  2 02:04:51 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250
Aug  2 02:04:51 kern: but task is already holding lock:
Aug  2 02:04:51 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b47>] xfs_ilock+0x97/0xb0

Aug  2 02:04:51 kern: other info that might help us debug this:
Aug  2 02:04:51 kern: 3 locks held by sort/24453:
Aug  2 02:04:51 kern:  #0:  (&sb->s_type->i_mutex_key#3){--..}, at: 
[<c038462f>] xfs_write+0x39f/0x7f0
Aug  2 02:04:51 kern:  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b47>] xfs_ilock+0x97/0xb0
Aug  2 02:04:51 kern:  #2:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170





#6 xfs_fsr -- dio_get_page+xfs_ilock
Aug  3 02:11:17 kern: 
=======================================================
Aug  3 02:11:17 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  3 02:11:17 kern: 2.6.25.12-ish #2
Aug  3 02:11:17 kern: 
-------------------------------------------------------
Aug  3 02:11:17 kern: xfs_fsr/4455 is trying to acquire lock:
Aug  3 02:11:17 kern:  (&mm->mmap_sem){----}, at: [<c029d8aa>] 
dio_get_page+0x6a/0x170  
Aug  3 02:11:17 kern: but task is already holding lock:
Aug  3 02:11:17 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0




#7 imapds - shrink_icache_memory + xfs_ilock


---
Aug  5 02:32:13 kern: 
=======================================================
Aug  5 02:32:13 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  5 02:32:13 kern: 2.6.25.12-ish #2
Aug  5 02:32:13 kern: 
-------------------------------------------------------
Aug  5 02:32:13 kern: imapds/2051 is trying to acquire lock:
Aug  5 02:32:13 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250  
Aug  5 02:32:13 kern: but task is already holding lock:
Aug  5 02:32:13 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0

Aug  5 02:32:13 kern: other info that might help us debug this:
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: 2 locks held by imapds/2051:
Aug  5 02:32:13 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug  5 02:32:13 kern:  #1:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170




#9 -< mount probs>
Aug  6 02:49:37 kern: Pid: 2304, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:49:37 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:49:37 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:49:37 kern:  =======================
Aug  6 02:49:37 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:49:37 kern: XFS: log mount failed
Aug  6 02:50:18 kern: Pid: 2333, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:18 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:18 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:18 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:18 kern:  =======================
Aug  6 02:50:18 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:18 kern: XFS: log mount failed
Aug  6 02:50:26 kern: Pid: 2335, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:26 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:26 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:26 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:26 kern:  =======================
Aug  6 02:50:26 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:26 kern: XFS: log mount failed
Aug  6 02:50:37 kern: Pid: 2340, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:37 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:37 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:37 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:37 kern:  =======================
Aug  6 02:50:37 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:37 kern: XFS: log mount failed
Aug  6 02:50:55 kern: Pid: 2342, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:55 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:55 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:55 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:55 kern:  =======================
Aug  6 02:50:55 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:55 kern: XFS: log mount failed
Aug  6 02:51:07 kern: Pid: 2346, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:51:07 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:51:07 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:51:07 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:51:07 kern:  =======================
Aug  6 02:51:07 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:51:07 kern: XFS: log mount failed
Aug  6 12:41:04 kern: XFS: failed to read RT inodes
Aug  6 21:51:37 Ish mountd[13571]: could not open /var/lib/nfs/xtab for 
locking
Aug  6 22:00:29 Ish mountd[13572]: could not open /var/lib/nfs/rmtab for 
locking
Aug  6 22:00:41 Ish last message repeated 5 times



#10 - imapds shrink_icache_memory+xfs_ilock 
Aug  7 02:09:48 kern: 
=======================================================
Aug  7 02:09:48 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  7 02:09:48 kern: 2.6.24.2-ish #5
Aug  7 02:09:48 kern: 
-------------------------------------------------------
Aug  7 02:09:48 kern: imapds/17962 is trying to acquire lock:
Aug  7 02:09:48 kern:  (iprune_mutex){--..}, at: [<b018b973>] 
shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern: but task is already holding lock:
Aug  7 02:09:48 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<b025ecdb>] xfs_ilock+0x5b/0xb0
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: other info that might help us debug this:
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: 2 locks held by imapds/17962:
Aug  7 02:09:48 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<b025ecdb>] xfs_ilock+0x5b/0xb0
Aug  7 02:09:48 kern:  #1:  (shrinker_rwsem){----}, at: [<b01620b6>] 
shrink_slab+0x26/0x170



#11 -- (previos damage?)
Aug  9 02:44:52 kern: Clocksource tsc unstable (delta = 9374169734 ns)
Aug  9 02:59:05 kern: XFS: bad magic number
Aug  9 02:59:05 kern: XFS: SB validate failed
Aug  9 02:59:09 kern: XFS: bad magic number
Aug  9 02:59:09 kern: XFS: SB validate failed



#12 - shrink_icache_memory  & xfs_ilock
---
<5>Linux version 2.6.25.12-ish (lw@Ast) (gcc version 4.2.1 (SUSE Linux)) 
#2 SMP Mon Jul 28 12:51:23 PDT 2008
---
Aug 11 02:04:56 kern: 
=======================================================
Aug 11 02:04:56 kern: [ INFO: possible circular locking dependency 
detected ]
Aug 11 02:04:56 kern: 2.6.25.12-ish #2
Aug 11 02:04:56 kern: 
-------------------------------------------------------
Aug 11 02:04:56 kern: imapds/31560 is trying to acquire lock:
Aug 11 02:04:56 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250
Aug 11 02:04:56 kern: but task is already holding lock:
Aug 11 02:04:56 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug 11 02:04:56 kern: which lock already depends on the new lock.

Aug 11 02:04:56 kern: other info that might help us debug this:
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: 2 locks held by imapds/31560:
Aug 11 02:04:56 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug 11 02:04:56 kern:  #1:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170
