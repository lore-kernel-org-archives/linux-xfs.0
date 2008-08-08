Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Aug 2008 01:24:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m788OR43003212
	for <xfs@oss.sgi.com>; Fri, 8 Aug 2008 01:24:29 -0700
Message-ID: <489C0481.4060204@sgi.com>
Date: Fri, 08 Aug 2008 18:32:01 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
References: <4897F691.6010806@sgi.com> <20080805073711.GA21635@disturbed> <489806C2.7020200@sgi.com> <20080805084220.GF21635@disturbed> <48990C4E.9070102@sgi.com> <20080806052053.GU6119@disturbed> <4899406D.5020802@sgi.com> <20080806093844.GZ6119@disturbed> <489AB596.1010505@sgi.com>
In-Reply-To: <489AB596.1010505@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Wed, Aug 06, 2008 at 04:10:53PM +1000, Lachlan McIlroy wrote:
>>> Dave Chinner wrote:
>>>> On Wed, Aug 06, 2008 at 12:28:30PM +1000, Lachlan McIlroy wrote:
>>>>> Dave Chinner wrote:
>>>>>> On Tue, Aug 05, 2008 at 05:52:34PM +1000, Lachlan McIlroy wrote:
>>>>>>> Dave Chinner wrote:
>>>>>>>> On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
>>>>>>>>> Currently by the time we get to vn_iowait() in xfs_reclaim() we 
>>>>>>>>> have already
>>>>>>>>> gone through xfs_inactive()/xfs_free() and recycled the inode.  
>>>>>>>>> Any I/O
>>>>>>>> xfs_free()? What's that?
>>>>>>> Sorry that should have been xfs_ifree() (we set the inode's mode to
>>>>>>> zero in there).
>>>>>>>
>>>>>>>>> completions still running (file size updates and unwritten 
>>>>>>>>> extent conversions)
>>>>>>>>> may be working on an inode that is no longer valid.
>>>>>>>> The linux inode does not get freed until after ->clear_inode
>>>>>>>> completes, hence it is perfectly valid to reference it anywhere
>>>>>>>> in the ->clear_inode path.
>>>>>>> The problem I see is an assert in xfs_setfilesize() fail:
>>>>>>>
>>>>>>>     ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
>>>>>>>
>>>>>>> The mode of the XFS inode is zero at this time.
>>>>>> Ok, so the question has to be why is there I/O still in progress
>>>>>> after the truncate is supposed to have already occurred and the
>>>>>> vn_iowait() in xfs_itruncate_start() been executed.
>>>>>>
>>>>>> Something doesn't add up here - you can't be doing I/O on a file
>>>>>> with no extents or delalloc blocks, hence that means we should be
>>>>>> passing through the truncate path in xfs_inactive() before we
>>>>>> call xfs_ifree() and therefore doing the vn_iowait()..
>>>>>>
>>>>>> Hmmmm - the vn_iowait() is conditional based on:
>>>>>>
>>>>>>         /* wait for the completion of any pending DIOs */
>>>>>>         if (new_size < ip->i_size)
>>>>>>                 vn_iowait(ip);
>>>>>>
>>>>>> We are truncating to zero (new_size == 0), so the only case where
>>>>>> this would not wait is if ip->i_size == 0. Still - I can't see
>>>>>> how we'd be doing I/O on an inode with a zero i_size. I suspect
>>>>>> ensuring we call vn_iowait() if newsize == 0 as well would fix
>>>>>> the problem. If not, there's something much more subtle going
>>>>>> on here that we should understand....
>>>>> If we make the vn_iowait() unconditional we might re-introduce the
>>>>> NFS exclusivity bug that killed performance.  That was through
>>>>> xfs_release()->xfs_free_eofblocks()->xfs_itruncate_start().
>>>> It won't reintroduce that problem because ->clear_inode()
>>>> is not called on every NFS write operation.
>>> Yes but xfs_itruncate_start() can be called from every NFS write so
>>> modifying the above code will re-introduce the problem.
>>
>> Ah, no. The case here is new_size == 0, which will almost never be
>> the case in the ->release call...
> True.
> 
>>
>>>>> So if we leave the above code as is then we need another
>>>>> vn_iowait() in xfs_inactive() to catch any remaining workqueue
>>>>> items that we didn't wait for in xfs_itruncate_start().
>>>> How do we have any new *data* I/O at all in progress at this point?
>>> It's not new data I/O.
>>
>> Then why isn't is being caught by the vn_iowait() in the truncate
>> code?????
> No idea.
> 
>>
>>>  It's workqueue items that have been queued
>>> from previous I/Os that are still outstanding.
>>
>> The iocount is decremented when the completion is finished, not when it
>> is queued. Hence vn_iowait() should be taking into account this case.
> Hmmm.  It should.
> 
>>
>>>> That does not explain why we need an additional vn_iowait() call.
>>>> All I see from this is a truncate race that has somethign to do with
>>>> the vn_iowait() call being conditional.
>>>>
>>>> That is, if we truncate to zero, then the current code in
>>>> xfs_itruncate_start() should wait unconditinally for *all* I/O to
>>>> complete because, by definition, all that I/O is beyond the new EOF
>>>> and we have to wait for it to complete before truncating the file.
>>> That makes sense.  If new_size is zero and ip->i_size is not then we
>>> will wait.  If ip->i_size is also zero we will not wait but if the
>>> file size is already zero there should not be any I/Os in progress
>>> and therefore no workqueue items outstanding.
>>
>> I note from the debug below that the linux inode size is zero,
>> but you didn't include the dump of the xfs inode so we can't see
>> what the other variables are.
> I tried to dump the xfs inode at the time but kdb encountered a bad
> address.  I'm pretty sure I was able to get a dump of the XFS inode
> on another crash - that's how I found the mode to be zero.  I can't
> be sure now - I'll have to reproduce the problem again.
> 
>>
>> Also, i_size is updated after write I/O is dispatched. If we are
>> doing synchronous I/O, then i_size is not updated until after the
>> I/O completes (in xfs_write()). Hence we could have the situation of
>> I/O being run while i_size = 0. This is why I wanted to know what
>> i_new_size is, because that gets set before the I/O is issued.
>>
>> if i_new_size is non-zero and i_size is zero,that tends to imply
>> the conditional vn_iowait() in the truncate path needs to take
>> MAX(ip->i_size, ip->i_new_size) for the check, not just ip->i_size...
>>
>> FWIW, from the dump below, we have:
>>
>> typedef struct xfs_ioend {
>>         struct xfs_ioend        *io_list = NULL
>>         unsigned int            io_type = 0x20 = IOMAP_UNWRITTEN
>>         int                     io_error = 0
>>         atomic_t                io_remaining = 0;
>>         struct inode            *io_inode = 0xffff810054062048
>>         struct buffer_head      *io_buffer_head = NULL
>>         struct buffer_head      *io_buffer_tail = NULL
>>         size_t                  io_size = 0x3400
>>         xfs_off_t               io_offset = 0xfe200
>>         struct work_struct      io_work;        /* xfsdatad work queue */
>> } xfs_ioend_t;
>>
>> So the I/O was not even close to offset zero.
>>
>> Also, the fact that the stack trace says it came through the
>> written path, but the io_type says unwritten which says that there's
>> something fishy here.  Either the stack trace is wrong, or there's
>> been a memory corruption....
> I'm pretty sure that's because it was a direct I/O write to a written
> extent.  The I/O starts out as IOMAP_UNWRITTEN and if we didn't map to
> an unwritten extent it's completion handler is switched to the written
> one.  Looking at the direct I/O write path I can see where the direct
> I/O write would wait for the bio's to complete but it's not waiting for
> the workqueue items to be flushed.  Not sure if that's part of the
> problem though.
> 
>>
>>>> If either the vn_iowait() in the truncate path is not sufficient, or
>>>> the truncate code is not being called, there is *some other bug*
>>>> that we don't yet understand.  Adding an unconditional vn_iowait()
>>>> appear to me to be fixing a symptom, not the underlying cause of
>>>> the problem....
>>> I'm not adding a new call to vn_iowait().  I'm just moving the
>>> existing one from xfs_ireclaim() so that we wait for all I/O to
>>> complete before we tear the inode down.
>>
>> Yes, but that is there to catch inodes with non-zero link counts because
>> we are not doing a truncate in that case. We still need to get to the
>> bottom of why the truncate is not waiting for all I/O.
> 
> I'm wondering if we have an extra decrement on the i_iocount atomic counter
> that tricked vn_iowait() into thinking that all I/Os have completed.
> 
> Should this code in xfs_vm_direct_IO():
> 
>     if (unlikely(ret != -EIOCBQUEUED && iocb->private))
>         xfs_destroy_ioend(iocb->private);
> 
> be:
> 
>     if (unlikely(ret < 0 && ret != -EIOCBQUEUED && iocb->private))
>         xfs_destroy_ioend(iocb->private);
> 
> Ordinarily we'd drop the i_iocount reference by calling 
> xfs_end_io_direct().
> 

I think I'm able to reproduce this at will now.

The stacktrace from kdb has no arguments so I added a printk
to give us the key items.

inode->i_size, ip->i_size, ip->i_new_size and ip->i_d.di_size are all zero
ip->i_iocount is 1
inode->i_mode is valid but ip->i_d.di_mode is zero

This assert triggered when the filesystem became full.  I suspect
that a direct I/O write failed due to ENOSPC (and that's why the
file size is still zero) but the ioend still got queued.

<5>XFS mounting filesystem dm-0
<7>Ending clean XFS mount for filesystem: dm-0
<7>xfs_setfilesize: ip 0xffff810fd3920c90, inode 0xffff810fd391fc18, iocount 1, ioend 0xffff810f96059be8
<4>Assertion failed: (ip->i_d.di_mode & S_IFMT) == S_IFREG, file: fs/xfs/linux-2.6/xfs_aops.c, line: 180
<0>------------[ cut here ]------------
<2>kernel BUG at fs/xfs/support/debug.c:81!
[1]kdb> 
[1]kdb> 
[1]kdb> xnode 0xffff810fd3920c90,
mount 0xffff81101acc0488 mnext 0xffff810f8e54c670 mprev 0xffff810f5b90a050 vnode 0xffff810fd391fc18 
dev fe00000 ino 4048200[7:5c54:8]
blkno 0x1ee2a0 len 0x10 boffset 0x800
transp 0x0000000000000000 &itemp 0xffff810f32236240
&lock 0xffff810fd3920d40 &iolock 0xffff810fd3920da8 &flush 0xffff810fd3920e10 (1) pincount 0x0
udquotp 0x0000000000000000 gdquotp 0x0000000000000000
new_size 0
flags 0x0 <> 
update_core 0 update size 0
gen 0x0 delayed blks 0size 0
 trace 0xffff810fcc693620
 bmap_trace 0xffff810fcc6935f0
 bmbt trace 0xffff810fcc6935c0
 rw trace 0xffff810fcc693590
 ilock trace 0xffff810fcc693560
 dir trace 0xffff810fcc693530

data fork
 bytes 0x0 real_bytes 0x0 lastex 0x0 u1:extents 0x0000000000000000
 broot 0x0000000000000000 broot_bytes 0x0 ext_max 9 flags 0x2 <extents > 
 u2 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
attr fork empty
[1]more> 

magic 0x494e mode 00 (?------------) version 0x2 format 0x2 (extents)
nlink 0 uid 0 gid 0 projid 0 flushiter 0
atime 1218176355:126020521 mtime 1218176355d:554017996 ctime 1218176355:554017996
size 0 nblocks 0 extsize 0x0 nextents 0x0 anextents 0x0
forkoff 0 aformat 0x2 (extents) dmevmask 0x0 dmstate 0x0 flags 0x0 <> gen 0x593e66c8
--> itrace @ 0xffff810fd3920c90/0xffff810fcc693620
ref @fs/xfs/xfs_vnodeops.c:1589(xfs_create+0x390) i_count = 1
  cpu = 6 pid = 9502   ra = xfs_vn_mknod+0x144
hold @fs/xfs/xfs_vnodeops.c:1642(xfs_create+0x568) i_count 1 => 2 
  cpu = 6 pid = 9502   ra = xfs_vn_mknod+0x144
entry to xfs_iput i_count = 2
  cpu = 6 pid = 9502   ra = xfs_trans_unlock_chunk+0x77
rele @fs/xfs/xfs_iget.c:421(xfs_iput+0x42) i_count 2 => 1 
  cpu = 6 pid = 9502   ra = xfs_trans_unlock_chunk+0x77
entry to xfs_vn_getattr i_count = 1
  cpu = 1 pid = 9502   ra = vfs_fstat+0x29
entry to xfs_vn_getattr i_count = 1
  cpu = 1 pid = 9502   ra = vfs_fstat+0x29
entry to xfs_ioctl i_count = 1
  cpu = 1 pid = 9502   ra = xfs_file_ioctl+0x26
entry to xfs_vn_getattr i_count = 1
  cpu = 1 pid = 9502   ra = vfs_fstat+0x29
[1]more> 
entry to xfs_remove i_count = 2
  cpu = 1 pid = 9502   ra = xfs_vn_unlink+0x37
hold @fs/xfs/xfs_vnodeops.c:1958(xfs_remove+0x26d) i_count 2 => 3 
  cpu = 1 pid = 9502   ra = xfs_vn_unlink+0x37
entry to xfs_iput i_count = 3
  cpu = 1 pid = 9502   ra = xfs_trans_unlock_chunk+0x77
rele @fs/xfs/xfs_iget.c:421(xfs_iput+0x42) i_count 3 => 2 
  cpu = 1 pid = 9502   ra = xfs_trans_unlock_chunk+0x77
exit from xfs_remove i_count = 2
  cpu = 1 pid = 9502   ra = xfs_vn_unlink+0x37
entry to xfs_fs_clear_inode i_count = 0
  cpu = 1 pid = 9502   ra = clear_inode+0x9c
entry to xfs_inactive i_count = 0
  cpu = 1 pid = 9502   ra = xfs_fs_clear_inode+0xbd
entry to xfs_reclaim i_count = 0
  cpu = 1 pid = 9502   ra = xfs_fs_clear_inode+0xde
[1]kdb> inode 0xffff810fd391fc18
struct inode at  0xffff810fd391fc18
 i_ino = 4048200 i_count = 0 i_size 0
 i_mode = 0100666  i_nlink = 0  i_rdev = 0x0
 i_hash.nxt = 0x0000000000000000 i_hash.pprev = 0xffffc20005712980
 i_list.nxt = 0xffff810fd391fc18 i_list.prv = 0xffff810fd391fc18
 i_dentry.nxt = 0xffff810fd391fbb0 i_dentry.prv = 0xffff810fd391fbb0
 i_sb = 0xffff810f1ca10148 i_op = 0xffffffff80690e20 i_data = 0xffff810fd391fe00 nrpages = 0
 i_fop= 0xffffffff80690b40 i_flock = 0x0000000000000000 i_mapping = 0xffff810fd391fe00
 i_flags 0x0 i_state 0x21 [I_DIRTY_SYNC I_FREEING]  fs specific info @ 0xffff810fd391ffe8
[1]kdb> 
[1]kdb> md8c20 0xffff810f96059be8
0xffff810f96059be8 0000000000000000 0000000000000020   ........ .......
0xffff810f96059bf8 5a5a5a5a00000000 ffff810fd391fc18   ....ZZZZ........
0xffff810f96059c08 0000000000000000 0000000000000000   ................
0xffff810f96059c18 0000000000001800 000000000002f800   ................
0xffff810f96059c28 ffff8110270654d0 ffff810f96059c30   .T.'....0.......
0xffff810f96059c38 ffff810f96059c30 ffffffff803b0b69   0.......i.;.....
0xffff810f96059c48 ffffffff80b7f698 0000000000000000   ................
0xffff810f96059c58 ffffffff807c0b92 d84156c5635688c0   ..|.......Vc.VA.
0xffff810f96059c68 ffffffff8025c2b6 09f911029d74e35b   ..%.....[.t.....
0xffff810f96059c78 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
[1]kdb> bt
Stack traceback for pid 379
0xffff811029484680      379        2  1    1   R  0xffff8110294849c8 *xfsdatad/1
sp                ip                Function (args)
0xffff81102708be28 0xffffffff803bbf40 assfail+0x1a (invalid, invalid, invalid)
kdb_bb: address 0x0000000000010286 not recognised
Using old style backtrace, unreliable with no arguments
sp                ip                Function (args)
0xffff81102708bdb8 0xffffffff803b0b69 xfs_end_bio_written
0xffff81102708be28 0xffffffff803bbf40 assfail+0x1a
0xffff81102708be58 0xffffffff803b0a50 xfs_setfilesize+0x6a
0xffff81102708be78 0xffffffff803b0b79 xfs_end_bio_written+0x10
0xffff81102708be88 0xffffffff8023bb02 run_workqueue+0xdf
0xffff81102708bed8 0xffffffff8023c5bd worker_thread+0xd8
0xffff81102708bef0 0xffffffff8023ef6e autoremove_wake_function
0xffff81102708bf20 0xffffffff8023c4e5 worker_thread
0xffff81102708bf28 0xffffffff8023ee5c kthread+0x47
0xffff81102708bf30 0xffffffff802294a8 schedule_tail+0x27
0xffff81102708bf48 0xffffffff8020bea8 child_rip+0xa


As suggested, I'm now running with this patch:

--- fs/xfs/xfs_inode.c_1.518	2008-08-08 17:31:02.000000000 +1000
+++ fs/xfs/xfs_inode.c	2008-08-08 17:35:11.000000000 +1000
@@ -1414,7 +1414,7 @@ xfs_itruncate_start(
 	mp = ip->i_mount;
 
 	/* wait for the completion of any pending DIOs */
-	if (new_size < ip->i_size)
+	if (new_size == 0 || new_size < ip->i_size)
 		vn_iowait(ip);
 
 	/*

and so far so good.
