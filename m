Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B29B7F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 06:21:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2F47AC009
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 04:21:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SQBJ17oWBXf29QIN for
	<xfs@oss.sgi.com>; Fri, 06 Sep 2013 04:21:02 -0700 (PDT)
Message-ID: <5229B9C1.5050505@redhat.com>
Date: Fri, 06 Sep 2013 07:17:21 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/11] xfs: introduce the free inode btree
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<5228F4D6.4050306@gmail.com>
In-Reply-To: <5228F4D6.4050306@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 09/05/2013 05:17 PM, Michael L. Semon wrote:
> On 09/03/2013 02:24 PM, Brian Foster wrote:
>> Hi all,
>>
>> This is an RFC for the kernel work to support a free inode btree. The free inode
>> btree (finobt) is equivalent to the existing inode allocation btree with the
>> exception that the finobt only tracks inode chunks with at least one free inode.
>> The purpose is to improve lookups for free inode clusters for inode allocation.
>>
>> Newly allocated inode chunks by definition contain free inodes and are thus
>> inserted into the finobt immediately. The record for a previously full inode
>> chunk is inserted to the finobt when the first inode is freed. A record is
>> removed from the finobt when the last free inode has been allocated or the
>> entire chunk is completely deallocated.
>>
>> Patches 1-3 refactor some ialloc btree code to introduce the new finobt type and
>> feature bit. Patches 4-7 fix up the transaction handling for inode allocation
>> and deallocation to account for the new tree. Patches 8-10 add the finobt
>> management code to insert, remove and modify records as appropriate. Patch 11
>> fixes growfs to support the finobt.
>>
>> Thoughts, reviews, flames appreciated.
> 
> I'm looking for Dave's judgement call on whether I should run this code 
> full-time.  The patchset applied well on top of Dave's latest work--only 
> a "trailing whitespace" warning on Patch #9 (I think)--and the code 
> compiled without error.  There was a lockdep while running xfstests, 
> before generic/013 (I think), so I switched back to my normal git branch 
> and have your patchset in a separate branch.
> 

Hi Michael,

Thanks for giving this a burn. I actually haven't tested with lockdep
yet, so I've made a note to do so and see if I can reproduce that or any
other problems.

With regard to running "full-time," I'd suggest to hold off at least
until I post a non-RFC version (the next version will probably be a real
v1). The review feedback has shown that a few areas need some
non-trivial rework that change the behavior enough (i.e., the flush on
inactive thing, transaction reservation management, etc.) that any
issues at this point might be worth retesting for on the later version
anyways.

> My setup here is slow--x86, old IDE hardware, write cache off, debug 
> kernel--but the patchset made things seem a little slower.  At the 
> right time--not necessarily now--performance numbers might be nice.  
> I didn't time it but did a copy of 3 kernel gits to v5 1k-block-size 
> XFS and just felt something was off.  The copy did complete, though.  
> Will try timing this on another day.
> 

That's interesting. I had a chat with Dave with regard to the existing
lookup allocation algorithm and the best way to test the improved
lookup, and I am able to reproduce a nice inode allocation improvement
under certain conditions. I could understand seeing some general effect
in performance via the addition of the new tree (there's more work to do
now to manage it, after all), but my expectation is that for finobt=0
filesystems, there should be no effect whatsoever.

> Anyway, good work so far!  No additional stack traces were caused by 
> your code in limited testing, and the filesystems were are still 
> intact.
> 

Thanks again for testing. Most of my testing so far has been with finobt
enabled, so that's a good bit of news! :)

Brian

> Thanks!
> 
> Michael
> 
> [lockdep from xfstests generic/0-ten-something follows:]
> 
> [  763.993429] XFS (sdb4): Mounting Filesystem
> [  764.258701] XFS (sdb4): Ending clean mount
> [  768.798390] XFS (sdb5): Mounting Filesystem
> [  769.061280] XFS (sdb5): Ending clean mount
> [  770.030277] XFS (sdb4): Mounting Filesystem
> [  770.313502] XFS (sdb4): Ending clean mount
> [  788.932588] XFS (sdb4): Mounting Filesystem
> [  789.256815] XFS (sdb4): Ending clean mount
> [  792.639933] XFS (sdb4): Mounting Filesystem
> [  792.965477] XFS (sdb4): Ending clean mount
> [  795.166220] XFS (sdb4): Mounting Filesystem
> [  795.507372] XFS (sdb4): Ending clean mount
> [  802.870263] XFS (sdb4): Mounting Filesystem
> [  803.516422] XFS (sdb4): Ending clean mount
> [  814.376620] XFS (sdb4): Mounting Filesystem
> [  815.050778] XFS (sdb4): Ending clean mount
> [  823.169368] 
> [  823.170932] ======================================================
> [  823.172146] [ INFO: possible circular locking dependency detected ]
> [  823.172146] 3.11.0+ #5 Not tainted
> [  823.172146] -------------------------------------------------------
> [  823.172146] dirstress/5276 is trying to acquire lock:
> [  823.172146]  (sb_internal){.+.+.+}, at: [<c11c5e60>] xfs_trans_alloc+0x1f/0x35
> [  823.172146] 
> [  823.172146] but task is already holding lock:
> [  823.172146]  (&(&ip->i_lock)->mr_lock){+++++.}, at: [<c1206cfb>] xfs_ilock+0x100/0x1f1
> [  823.172146] 
> [  823.172146] which lock already depends on the new lock.
> [  823.172146] 
> [  823.172146] 
> [  823.172146] the existing dependency chain (in reverse order) is:
> [  823.172146] 
> [  823.172146] -> #1 (&(&ip->i_lock)->mr_lock){+++++.}:
> [  823.172146]        [<c1070a11>] __lock_acquire+0x345/0xa11
> [  823.172146]        [<c1071c45>] lock_acquire+0x88/0x17e
> [  823.172146]        [<c14bff98>] _raw_spin_lock+0x47/0x74
> [  823.172146]        [<c1116247>] __mark_inode_dirty+0x171/0x38c
> [  823.172146]        [<c111acab>] __set_page_dirty+0x5f/0x95
> [  823.172146]        [<c111b93e>] mark_buffer_dirty+0x58/0x12b
> [  823.172146]        [<c111baff>] __block_commit_write.isra.17+0x64/0x82
> [  823.172146]        [<c111c197>] block_write_end+0x2b/0x53
> [  823.172146]        [<c111c201>] generic_write_end+0x42/0x9a
> [  823.172146]        [<c11a42d5>] xfs_vm_write_end+0x60/0xbe
> [  823.172146]        [<c10bd47a>] generic_file_buffered_write+0x140/0x20f
> [  823.172146]        [<c11b2347>] xfs_file_buffered_aio_write+0x10b/0x205
> [  823.172146]        [<c11b24ee>] xfs_file_aio_write+0xad/0xec
> [  823.172146]        [<c10f0c5f>] do_sync_write+0x60/0x87
> [  823.172146]        [<c10f0e0f>] vfs_write+0x9c/0x189
> [  823.172146]        [<c10f0fc6>] SyS_write+0x49/0x81
> [  823.172146]        [<c14c14bb>] sysenter_do_call+0x12/0x32
> [  823.172146] 
> [  823.172146] -> #0 (sb_internal){.+.+.+}:
> [  823.172146]        [<c106e972>] validate_chain.isra.35+0xfc7/0xff4
> [  823.172146]        [<c1070a11>] __lock_acquire+0x345/0xa11
> [  823.172146]        [<c1071c45>] lock_acquire+0x88/0x17e
> [  823.172146]        [<c10f36eb>] __sb_start_write+0xad/0x177
> [  823.172146]        [<c11c5e60>] xfs_trans_alloc+0x1f/0x35
> [  823.172146]        [<c120a823>] xfs_inactive+0x129/0x4a3
> [  823.172146]        [<c11c280d>] xfs_fs_evict_inode+0x6c/0x114
> [  823.172146]        [<c1106678>] evict+0x8e/0x15d
> [  823.172146]        [<c1107126>] iput+0xc4/0x138
> [  823.172146]        [<c1103504>] dput+0x1b2/0x257
> [  823.172146]        [<c10f1a30>] __fput+0x140/0x1eb
> [  823.172146]        [<c10f1b0f>] ____fput+0xd/0xf
> [  823.172146]        [<c1048477>] task_work_run+0x67/0x90
> [  823.172146]        [<c1001ea5>] do_notify_resume+0x61/0x63
> [  823.172146]        [<c14c0cfa>] work_notifysig+0x1f/0x25
> [  823.172146] 
> [  823.172146] other info that might help us debug this:
> [  823.172146] 
> [  823.172146]  Possible unsafe locking scenario:
> [  823.172146] 
> [  823.172146]        CPU0                    CPU1
> [  823.172146]        ----                    ----
> [  823.172146]   lock(&(&ip->i_lock)->mr_lock);
> [  823.172146]                                lock(sb_internal);
> [  823.172146]                                lock(&(&ip->i_lock)->mr_lock);
> [  823.172146]   lock(sb_internal);
> [  823.172146] 
> [  823.172146]  *** DEADLOCK ***
> [  823.172146] 
> [  823.172146] 1 lock held by dirstress/5276:
> [  823.172146]  #0:  (&(&ip->i_lock)->mr_lock){+++++.}, at: [<c1206cfb>] xfs_ilock+0x100/0x1f1
> [  823.172146] 
> [  823.172146] stack backtrace:
> [  823.172146] CPU: 0 PID: 5276 Comm: dirstress Not tainted 3.11.0+ #5
> [  823.172146] Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
> [  823.172146]  c1c26060 c1c26060 da34fd58 c14ba216 da34fd78 c14b7317 c15f171b da34fdb4
> [  823.172146]  dcaa1440 00000001 dcaa18b0 00000000 da34fde4 c106e972 dcaa1888 00000001
> [  823.172146]  da34fdb4 c1057e0f 00000000 00003f61 c1c28660 00000000 dcaa1888 dcaa18b0
> [  823.172146] Call Trace:
> [  823.172146]  [<c14ba216>] dump_stack+0x16/0x18
> [  823.172146]  [<c14b7317>] print_circular_bug+0x1b8/0x1c2
> [  823.172146]  [<c106e972>] validate_chain.isra.35+0xfc7/0xff4
> [  823.172146]  [<c1057e0f>] ? sched_clock_local.constprop.3+0x39/0x131
> [  823.172146]  [<c1057fd4>] ? sched_clock_cpu+0x8f/0xe2
> [  823.172146]  [<c1070a11>] __lock_acquire+0x345/0xa11
> [  823.172146]  [<c1070a36>] ? __lock_acquire+0x36a/0xa11
> [  823.172146]  [<c1071c45>] lock_acquire+0x88/0x17e
> [  823.172146]  [<c11c5e60>] ? xfs_trans_alloc+0x1f/0x35
> [  823.172146]  [<c10f36eb>] __sb_start_write+0xad/0x177
> [  823.172146]  [<c11c5e60>] ? xfs_trans_alloc+0x1f/0x35
> [  823.172146]  [<c11c5e60>] ? xfs_trans_alloc+0x1f/0x35
> [  823.172146]  [<c1206cfb>] ? xfs_ilock+0x100/0x1f1
> [  823.172146]  [<c11c5e60>] xfs_trans_alloc+0x1f/0x35
> [  823.172146]  [<c120a823>] xfs_inactive+0x129/0x4a3
> [  823.172146]  [<c106f21f>] ? trace_hardirqs_on+0xb/0xd
> [  823.172146]  [<c14c01e5>] ? _raw_spin_unlock_irq+0x27/0x36
> [  823.172146]  [<c11c280d>] xfs_fs_evict_inode+0x6c/0x114
> [  823.172146]  [<c1106678>] evict+0x8e/0x15d
> [  823.172146]  [<c1107126>] iput+0xc4/0x138
> [  823.172146]  [<c1103504>] dput+0x1b2/0x257
> [  823.172146]  [<c10f1a30>] __fput+0x140/0x1eb
> [  823.172146]  [<c10f1b0f>] ____fput+0xd/0xf
> [  823.172146]  [<c1048477>] task_work_run+0x67/0x90
> [  823.172146]  [<c1001ea5>] do_notify_resume+0x61/0x63
> [  823.172146]  [<c14c0cfa>] work_notifysig+0x1f/0x25
> [  824.015366] Clocksource tsc unstable (delta = 486645129 ns)
> [  825.324019] XFS (sdb4): Mounting Filesystem
> [  825.743317] XFS (sdb4): Ending clean mount
> [  827.223193] XFS (sdb4): Mounting Filesystem
> [  827.668493] XFS (sdb4): Ending clean mount
> [  837.524673] XFS (sdb4): Mounting Filesystem
> [  837.986097] XFS (sdb4): Ending clean mount
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
