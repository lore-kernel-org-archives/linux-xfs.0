Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 23:03:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7663ScW015594
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 23:03:29 -0700
Message-ID: <4899406D.5020802@sgi.com>
Date: Wed, 06 Aug 2008 16:10:53 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
References: <4897F691.6010806@sgi.com> <20080805073711.GA21635@disturbed> <489806C2.7020200@sgi.com> <20080805084220.GF21635@disturbed> <48990C4E.9070102@sgi.com> <20080806052053.GU6119@disturbed>
In-Reply-To: <20080806052053.GU6119@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Dave Chinner wrote:
> On Wed, Aug 06, 2008 at 12:28:30PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Tue, Aug 05, 2008 at 05:52:34PM +1000, Lachlan McIlroy wrote:
>>>> Dave Chinner wrote:
>>>>> On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
>>>>>> Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
>>>>>> gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O
>>>>> xfs_free()? What's that?
>>>> Sorry that should have been xfs_ifree() (we set the inode's mode to
>>>> zero in there).
>>>>
>>>>>> completions still running (file size updates and unwritten extent conversions)
>>>>>> may be working on an inode that is no longer valid.
>>>>> The linux inode does not get freed until after ->clear_inode
>>>>> completes, hence it is perfectly valid to reference it anywhere
>>>>> in the ->clear_inode path.
>>>> The problem I see is an assert in xfs_setfilesize() fail:
>>>>
>>>> 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
>>>>
>>>> The mode of the XFS inode is zero at this time.
>>> Ok, so the question has to be why is there I/O still in progress
>>> after the truncate is supposed to have already occurred and the
>>> vn_iowait() in xfs_itruncate_start() been executed.
>>>
>>> Something doesn't add up here - you can't be doing I/O on a file
>>> with no extents or delalloc blocks, hence that means we should be
>>> passing through the truncate path in xfs_inactive() before we
>>> call xfs_ifree() and therefore doing the vn_iowait()..
>>>
>>> Hmmmm - the vn_iowait() is conditional based on:
>>>
>>>         /* wait for the completion of any pending DIOs */
>>>         if (new_size < ip->i_size)
>>>                 vn_iowait(ip);
>>>
>>> We are truncating to zero (new_size == 0), so the only case where
>>> this would not wait is if ip->i_size == 0. Still - I can't see
>>> how we'd be doing I/O on an inode with a zero i_size. I suspect
>>> ensuring we call vn_iowait() if newsize == 0 as well would fix
>>> the problem. If not, there's something much more subtle going
>>> on here that we should understand....
>> If we make the vn_iowait() unconditional we might re-introduce the
>> NFS exclusivity bug that killed performance.  That was through
>> xfs_release()->xfs_free_eofblocks()->xfs_itruncate_start().
> 
> It won't reintroduce that problem because ->clear_inode()
> is not called on every NFS write operation.
Yes but xfs_itruncate_start() can be called from every NFS write so
modifying the above code will re-introduce the problem.

> 
>> So if we leave the above code as is then we need another
>> vn_iowait() in xfs_inactive() to catch any remaining workqueue
>> items that we didn't wait for in xfs_itruncate_start().
> 
> How do we have any new *data* I/O at all in progress at this point?
It's not new data I/O.  It's workqueue items that have been queued
from previous I/Os that are still outstanding.

> That does not explain why we need an additional vn_iowait() call.
> All I see from this is a truncate race that has somethign to do with
> the vn_iowait() call being conditional.
> 
> That is, if we truncate to zero, then the current code in
> xfs_itruncate_start() should wait unconditinally for *all* I/O to
> complete because, by definition, all that I/O is beyond the new EOF
> and we have to wait for it to complete before truncating the file.
That makes sense.  If new_size is zero and ip->i_size is not then we
will wait.  If ip->i_size is also zero we will not wait but if the
file size is already zero there should not be any I/Os in progress
and therefore no workqueue items outstanding.

> Seeing as we are in ->clear_inode(), no new data I/O can start
> while we are deep in this code, hence we should not be seeing
> I/O completions after the truncate starts and vn_iowait() has
> completed.
> 
> Hence we need to know, firstly, if the truncate code has been
> called; Secondly, what the value of i_size and i_new_size was when
> the truncate was started and, finally, whether ip->i_iocount was
> non-zero when the truncate was run.  That is, we need to gather
> enough data to determine whether we should have waited in the
> truncate but didn't.
> 
> If either the vn_iowait() in the truncate path is not sufficient, or
> the truncate code is not being called, there is *some other bug*
> that we don't yet understand.  Adding an unconditional vn_iowait()
> appear to me to be fixing a symptom, not the underlying cause of
> the problem....

I'm not adding a new call to vn_iowait().  I'm just moving the
existing one from xfs_ireclaim() so that we wait for all I/O to
complete before we tear the inode down.

Here's some info from the bug:

Stack traceback for pid 272
0xffff81007f3ea600      272        2  1    3   R  0xffff81007f3ea950 *xfsdatad/3
rsp                rip                Function (args)
0xffff81007e275e28 0xffffffff803b8cd0 assfail+0x1a (invalid, invalid, invalid)
0xffff81007e275e58 0xffffffff803adaad xfs_setfilesize+0x3d (0xffff8100383de7f8)
0xffff81007e275e78 0xffffffff803adc28 xfs_end_bio_written+0x10 (invalid)
0xffff81007e275e88 0xffffffff8023cf9a run_workqueue+0xdf (0xffff81007e7d0070)
0xffff81007e275ed8 0xffffffff8023da8f worker_thread+0xd8 (0xffff81007e7d0070)
0xffff81007e275f28 0xffffffff80240314 kthread+0x47 (invalid)
0xffff81007e275f48 0xffffffff8020bd08 child_rip+0xa (invalid, invalid)

<5>Filesystem "sdb1": Disabling barriers, not supported with external log device
<5>XFS mounting filesystem sdb1
<7>Ending clean XFS mount for filesystem: sdb1
<4>Assertion failed: (ip->i_d.di_mode & S_IFMT) == S_IFREG, file: fs/xfs/linux-2.6/xfs_aops.c, line: 178
<0>------------[ cut here ]------------
<2>kernel BUG at fs/xfs/support/debug.c:81!
<0>invalid opcode: 0000 [1] SMP 

[3]kdb> md8c20 0xffff8100383de7f8
0xffff8100383de7f8 0000000000000000 0000000000000020   ........ .......
0xffff8100383de808 5a5a5a5a00000000 ffff810054062048   ....ZZZZH .T....
0xffff8100383de818 0000000000000000 0000000000000000   ................
0xffff8100383de828 0000000000003400 00000000000fe200   .4..............
0xffff8100383de838 ffff81007e7d0070 ffff8100383de840   p.}~....@.=8....
0xffff8100383de848 ffff8100383de840 ffffffff803adc18   @.=8......:.....
0xffff8100383de858 ffffffff80b162a0 0000000000000000   .b..............
0xffff8100383de868 ffffffff80784c51 d84156c5635688c0   QLx.......Vc.VA.
0xffff8100383de878 ffffffff8025d1f6 09f911029d74e35b   ..%.....[.t.....
0xffff8100383de888 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk

I think io_type here is 0x20 which is IOMAP_UNWRITTEN.  Since we've come
through xfs_end_bio_written() (not xfs_end_bio_unwritten()) this must be
a direct I/O write to a written extent.

[3]kdb> inode ffff810054062048
struct inode at  0xffff810054062048
 i_ino = 80848951 i_count = 0 i_size 0
 i_mode = 0100666  i_nlink = 0  i_rdev = 0x0
 i_hash.nxt = 0x0000000000000000 i_hash.pprev = 0xffffc20000208518
 i_list.nxt = 0xffff810054062048 i_list.prv = 0xffff810054062048
 i_dentry.nxt = 0xffff810054061fe0 i_dentry.prv = 0xffff810054061fe0
 i_sb = 0xffff81006d5b0508 i_op = 0xffffffff806647a0 i_data = 0xffff810054062230 nrpages = 0
 i_fop= 0xffffffff806644e0 i_flock = 0x0000000000000000 i_mapping = 0xffff810054062230
 i_flags 0x0 i_state 0x21 [I_DIRTY_SYNC I_FREEING]  fs specific info @ 0xffff810054062418

Mode is 0100666.  S_IFREG is 0100000 so linux inode would not have failed
assert.  So why did XFS inode fail it?
