Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Aug 2006 14:55:39 -0700 (PDT)
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7MLtSDW000529
	for <linux-xfs@oss.sgi.com>; Tue, 22 Aug 2006 14:55:29 -0700
Received: from madrid.max-t.internal ([192.168.1.189] ident=[U2FsdGVkX1+1JSQuQaWCtjqik/U9bLVPQ8fpQFKw9yA=])
	by mail.max-t.com with esmtp (Exim 4.43)
	id 1GFcRd-0005J2-W1
	for linux-xfs@oss.sgi.com; Tue, 22 Aug 2006 16:01:56 -0400
Date: Tue, 22 Aug 2006 16:01:10 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
Message-ID: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
MIME-Version: 1.0
Content-ID: <Pine.LNX.4.64.0608221410241.3139@madrid.max-t.internal>
Subject: Infinite loop in xfssyncd on full file system
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

I'm seeing what appears to be an infinite loop in xfssyncd. It is 
triggered when writing to a file system that is full or nearly full. I 
have pinpointed the change that introduced this problem: it's

     "TAKE 947395 - Fixing potential deadlock in space allocation and
     freeing due to ENOSPC"

git commit d210a28cd851082cec9b282443f8cc0e6fc09830.

I first saw the problem with a 2.6.17 kernel patched to add the 2.6.18-rc* 
XFS changes. I later confirmed that 2.6.17 does not exhibit this behavior, 
while addding just that one commit brings the problem back.

In the simplest case, I had a 7.5GB test file system, created with no 
mkfs.xfs option and mounted with no option. I filled it up, leaving half a 
GB free, simply using dd (single-threaded). Then I did

     while [ 1 ]; do dd if=/dev/zero of=f bs=1M; done
or
     i=1; while [ 1 ]; do echo $i; dd if=/dev/zero of=f$i bs=1M; \
                          i=$(($i+1)); done

and after very few iterations, my dd got stuck in uninterruptible 
sleep and I soon got: "BUG: soft lockup detected on CPU#1!" with xfssyncd 
at the bottom of the backtrace.

I took a few backtraces using KDB, letting it run a bit between taking 
each backtrace. All backtraces I saw had xfssyncd doing:

xfssyncd xfs_flush_inode_work filemap_flush __filemap_fdatawrite_range
do_writepages xfs_vm_writepage xfs_page_state_convert xfs_map_blocks
xfs_bmap xfs_iomap ...

then I've seen either:

xfs_iomap_write_allocate xfs_trans_reserve xfs_mod_incore_sb 
xfs_icsb_modify_counters xfs_icsb_modify_counters_int

or

xfs_iomap_write_allocate xfs_bmapi xfs_bmap_alloc xfs_bmap_btalloc 
xfs_alloc_vextent xfs_alloc_fix_freelist

or

xfs_icsb_balance_counter xfs_icsb_disable_counter

or

xfs_iomap_write_allocate xfs_trans_alloc _xfs_trans_alloc kmem_zone_zalloc

dd is doing: sys_write vfs_write do_sync_write xfs_file_aio_write 
xfs_write generic_file_buffered_write xfs_get_blocks __xfs_get_blocks 
xfs_bmap xfs_iomap xfs_iomap_write_delay xfs_flush_space xfs_flush_device 
_xfs_log_force xlog_state_sync_all schedule_timeout.

>From then on, other processes start piling up because of the held locks, 
and if I'm patient enough, something on my machine eventually eats away 
all the memory...

A similar problem was discussed here: 
http://oss.sgi.com/archives/xfs/2006-08/msg00144.html

For some reason I can't seem to find the original bug submission either in 
the list archives or in your bugzilla... I would comment that I have 
preemption disabled. AFAICT this is not a matter of spinlocks being held 
for too long. The "soft lockup" should trigger if a CPU doesn't reschedule 
for more than 10secs.

I saw the problem on two different machines, one has 8 pseudo CPUs 
(counting hyper-threading) and one has 4.

Most of my tests were done using a fast external storage array. But I also 
tried it on a 1GB file system that I made in a file on an ordinary disk 
and mounted using the loopback device. The lockup did not happen with dd 
as before, but then I umount'ed the file system and umount hung, and I got 
the same soft lockup for xfssyncd as before.

I hope you XFS experts see what might be wrong with that bug fix. It's 
ironic but for me, this (apparent) infinite loop seems much easier to hit 
than the out-of-order locking problem that the commit in question was 
supposed to fix. Let me know if I can get you any more info.

Thanks
