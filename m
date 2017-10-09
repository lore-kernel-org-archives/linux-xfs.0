Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:7529 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754470AbdJIMtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 08:49:09 -0400
Subject: Re: xfs clones crash issue - illegal state 13 in block map
References: <CAOQ4uxgCanEpWx20QvvLvwBbjJiJ2U3oz-e1ZXrv3ZV2d3EPRQ@mail.gmail.com>
 <20170907161330.GA6540@magnolia>
 <CAOQ4uxibPmwRS3P5A-k2JQvCX_hq9Mb_cSOThe-qcVd0136PpQ@mail.gmail.com>
 <20170919053843.GA7117@magnolia>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <e9ee9fb1-f5a3-b85e-2b6a-6beda6830aed@huawei.com>
Date: Mon, 9 Oct 2017 20:48:34 +0800
MIME-Version: 1.0
In-Reply-To: <20170919053843.GA7117@magnolia>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

Hi,

On 2017/9/19 13:38, Darrick J. Wong wrote:
> On Fri, Sep 08, 2017 at 11:34:58AM +0300, Amir Goldstein wrote:
>> On Thu, Sep 7, 2017 at 7:13 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>> On Thu, Sep 07, 2017 at 03:58:56PM +0300, Amir Goldstein wrote:
>>>> Hi guys,
>>>>
>>>> I am getting these errors often when running the crash tests
>>>> with cloned files (generic/502 in my xfstests patches).
>>>>
>>>> Hitting these errors requires first fixing 2 other issues
>>>> that shadow over this issue:
>>>> "xfs: fix incorrect log_flushed on fsync" (in master)
>>>> "xfs: fix leftover CoW extent after truncate"
>>>> available on my tree based on Darrick's simple fix:
>>>> https://github.com/amir73il/linux/commits/xfs-fsync
>>>>
>>>> I get the errors more often (1 out of 5) on a 100G fs on spinning disk.
>>>> On a 10G fs on SSD they are less frequent.
>>>> The log in this email was captured on patched stable 4.9.47 kernel,
>>>> but I am getting the same errors on patched upstream kernel.
>>>>
>>>> I wasn't able to create a deterministic reproducer, so attaching
>>>> the full log from a failed test along with an IO log that can be
>>>> replayed on your disk to examine the outcome.
>>>>
>>>> Following is the output of fsx process #5, which is the process
>>>> that wrote the problematic testfile5.mark0 to the log.
>>>> This process performs only read,zero,fsync before creating
>>>> the log mark.
>>>> The file testfile5 was cloned from an origin 256K file before
>>>> running fsx.
>>>> Later, I used the random seed 35484 in this log for all
>>>> processes and it seemed to increase the probability for failure.
>>>>
>>>> # /old/home/amir/src/xfstests-dev/ltp/fsx -N 100 -d -k -P
>>>> /mnt/test/fsxtests -i /dev/mapper/logwrites-test -S 0 -j 5
>>>> /mnt/scratch/testfile5
>>>> Seed set to 35484
>>>> file_size=262144
>>>> 5: 1 read 0x3f959 thru 0x3ffff (0x6a7 bytes)
>>>> 5: 2 zero from 0x3307e to 0x34f74, (0x1ef6 bytes)
>>>> 5: 3 fsync
>>>> 5: Dumped fsync buffer to testfile5.mark0
>>>>
>>>> In order to get to the crash state you need to get my
>>>> xfstests replay-log patches and replay the attached log
>>>> on a >= 100G scratch device:
>>>>
>>>> # ./src/log-writes/replay-log --log log.xfs.testfile5.mark0 --replay
>>>> $SCRATCH_DEV --end-mark testfile5.mark0
>>>> # mount $SCRATCH_DEV $SCRATCH_MNT
>>>> # umount $SCRATCH_MNT
>>>> # xfs_repair -n $SCRATCH_DEV
>>>> Phase 1 - find and verify superblock...
>>>> Phase 2 - using internal log
>>>>         - zero log...
>>>>         - scan filesystem freespace and inode maps...
>>>>         - found root inode chunk
>>>> Phase 3 - for each AG...
>>>>         - scan (but don't clear) agi unlinked lists...
>>>>         - process known inodes and perform inode discovery...
>>>>         - agno = 0
>>>>
>>>> fatal error -- illegal state 13 in block map 376
>>>>
>>>> Can anyone provide some insight?
>>>
>>> Looks like I missed a couple of extent states in process_bmbt_reclist_int.
>>>
>>> What happens if you add the following (only compile tested) patch to
>>> xfsprogs?
>>
>> This is what happens:
>>
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>> data fork in regular inode 134 claims CoW block 376
>> correcting nextents for inode 134
>> bad data fork in inode 134
>> would have cleared inode 134
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>> unknown block state, ag 0, block 376
>> unknown block state, ag 1, block 16
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>> entry "testfile2" in shortform directory 128 references free inode 134
>>         - agno = 3
>> would have junked entry "testfile2" in directory inode 128
>> imap claims in-use inode 134 is free, would correct imap
>> Missing reverse-mapping record for (0/376) len 1 owner 134 off 19
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> Phase 7 - verify link counts...
>> No modify flag set, skipping filesystem flush and exiting.
> 
> Hmm.
> 
> # xfs_db bugs.img
> xfs_db> inode 134
> xfs_db> bmap
> data offset 0 startblock 24 (0/24) count 19 flag 0
> data offset 19 startblock 376 (0/376) count 1 flag 0
> data offset 25 startblock 8388624 (1/16) count 4 flag 1
> data offset 29 startblock 53 (0/53) count 35 flag 0
> 
> Ok, so inode 134 thinks it owns block 376.
> 
> xfs_db> agf 0
> xfs_db> addr refcntroot
> xfs_db> p
> ...
> recs[1-22] = [startblock,blockcount,refcount,cowflag] 
> 1:[24,1,11,0] 
> ...
> 22:[87,1,6,0]
> xfs_db>
> 
> Ok, so the refcountbt doesn't know about block 376, so it's neither
> shared nor a cow staging extent.
> 
> xfs_db> agf 0 
> xfs_db> addr rmaproot
> xfs_db> p
> ...
> recs[1-38] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock] 
> 1:[0,1,-3,0,0,0,0] 
> ...
> 38:[376,1,-9,0,0,0,0]
> xfs_db> 
> 
> So it seems that the rmapbt is behind the times, since record 38 should
> be [376,1,134,19,0,0,0].  Either that's because there's something wrong
> with the regular deferred ops mechanism, or log recovery of deferred ops.
I think the log recovery of deferred ops is incorrect, and we also need to
add more checks when manipulating the b-tree of rmap.

I had reproduced the problem on my KVM VM, and i will explain the incorrectness of
log recovery of deferred ops by using my own example. If addition information is
needed, please just ask.

The phenomena is the same: a block extent had been assigned to a file, but in the
rmap b-tree the block extent belongs to COW procedure.

We can get the following output from xfs_db after mounting and umounting the device:

./src/log-writes/replay-log --replay /dev/vdd --end-mark testfile7.mark0 --log /dev/vde

xfs_logprint -o /dev/vdd > pre_mount.log
mount /dev/vdd /tmp/vdd
umount /tmp/vdd
xfs_logprint -o /dev/vdd > post_mount.log

xfs_db /dev/vdd
xfs_db> inode 137
xfs_db> p u3.bmx[3]
u3.bmx[3] = [startoff,startblock,blockcount,extentflag]
3:[58,341,2,0]

xfs_db> agf 0
xfs_db> addr rmaproot
xfs_db> p recs[44]
recs[44] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock]
44:[341,2,-9,0,0,0,0]

The last log record in pre_mount.log (generated before mount) has the following ops
which are related with inode 137:

# from pre_mount.log
# initiate by xfs_reflink_end_cow()
# decrease ref: [0x52, +2]
# free cow: [0x155, +2]
----------------------------------------------------------------------------
Oper (160): tid: c2350d60  len: 48  clientid: TRANS  flags: none
CUI:  #regs: 1  num_extents: 2  id: 0xffff88011b37c680
(s: 0x52, l: 2, f: 0x2)
(s: 0x155, l: 2, f: 0x4)
----------------------------------------------------------------------------

# map shared: [0x155, +2] to inode 137
----------------------------------------------------------------------------
Oper (161): tid: c2350d60  len: 48  clientid: TRANS  flags: none
BUI:  #regs: 1  num_extents: 1  id: 0xffff880117f0c300
(s: 0x155, l: 2, own: 137, off: 58, f: 0x1)
----------------------------------------------------------------------------

# for CUI Oper (160)
----------------------------------------------------------------------------
Oper (194): tid: c2350d60  len: 16  clientid: TRANS  flags: none
CUD:  #regs: 1                   id: 0xffff88011b37c680
----------------------------------------------------------------------------

# free rmap: [0x155, +2]
----------------------------------------------------------------------------
Oper (197): tid: c2350d60  len: 48  clientid: TRANS  flags: none
RUI:  #regs: 1  num_extents: 1  id: 0xffff880124a3ea00
(s: 0x155, l: 2, own: -9, off: 0, f: 0x8)
----------------------------------------------------------------------------
Oper (198): tid: c2350d60  len: 0  clientid: TRANS  flags: COMMIT
============================================================================

According to the implementation of xfs_defer_finish(), these ops should be completed
in the following sequence:

Have been done:
(1) CUI: Oper (160)
(2) BUI: Oper (161)
(3) CUD: Oper (194), for CUI Oper (160)
(4) RUI A: Oper (197), free rmap [0x155, 2, -9]

Should be done:
(5) BUD: for BUI Oper (161)
(6) RUI B: add rmap [0x155, 2, 137]
(7) RUD: for RUI A
(8) RUD: for RUI B

Actually be done by xlog_recover_process_intents()
(5) BUD: for BUI Oper (161)
(6) RUI B: add rmap [0x155, 2, 137]
(7) RUD: for RUI B
(8) RUD: for RUI A

So the rmap entry [0x155, 2, -9] for COW should be freed firstly,
then a new rmap entry [0x155, 2, 137] will be added. However, as we can see
from the log record in post_mount.log (generated after umount) and the trace
print, the new rmap entry [0x155, 2, 137] are added firstly, then the rmap
entry [0x155, 2, -9] are freed.

# from post_mount.log
----------------------------------------------------------------------------
Oper (2): tid: 3c5adcc1  len: 16  clientid: TRANS  flags: none
BUD:  #regs: 1                   id: 0xffff880117f0c300
----------------------------------------------------------------------------

# add rmap [0x155, 2, 137]
----------------------------------------------------------------------------
Oper (6): tid: 3c5adcc1  len: 48  clientid: TRANS  flags: none
RUI:  #regs: 1  num_extents: 1  id: 0xffff880125bdc2a0
(s: 0x155, l: 2, own: 137, off: 58, f: 0x2)
----------------------------------------------------------------------------
Oper (7): tid: 3c5adcc1  len: 16  clientid: TRANS  flags: none
RUD:  #regs: 1                   id: 0xffff880125bdc2a0
----------------------------------------------------------------------------

# remove rmap [0x155, 2, -9]
----------------------------------------------------------------------------
Oper (20): tid: 3c5adcc1  len: 16  clientid: TRANS  flags: none
RUD:  #regs: 1                   id: 0xffff880124a3ea00
----------------------------------------------------------------------------

# from trace print

# add rmap [0x155, 2, 137], find [0x12d, 46, -9], and insert [0x155, 2, 137]
xfs_rmap_defer: dev 253:48 op 1 agno 0 agbno 341 owner 137 data offset 58 len 2 state 0
xfs_rmap_deferred: dev 253:48 op 1 agno 0 agbno 341 owner 137 data offset 58 len 2 state 0
xfs_rmap_map: dev 253:48 agno 0 agbno 341 len 2 owner 137 offset 58 flags 0x0
xfs_rmap_find_left_neighbor_query: dev 253:48 agno 0 agbno 341 len 0 owner 137 offset 58 flags 0x0
xfs_rmap_find_left_neighbor_candidate: dev 253:48 agno 0 agbno 301 len 46 owner -9 offset 0 flags 0x0
xfs_rmap_insert: dev 253:48 agno 0 agbno 341 len 2 owner 137 offset 58 flags 0x0
xfs_rmap_map_done: dev 253:48 agno 0 agbno 341 len 2 owner 137 offset 58 flags 0x0

# del rmap [0x155, 2, -9], find [0x155, 2, 137], and remove [0x155, 2, 137]
xfs_rmap_deferred: dev 253:48 op 7 agno 0 agbno 341 owner -9 data offset 0 len 2 state 0
xfs_rmap_unmap: dev 253:48 agno 0 agbno 341 len 2 owner -9 offset 0 flags 0x0
xfs_rmap_lookup_le_range_result: dev 253:48 agno 0 agbno 341 len 2 owner 137 offset 58 flags 0x0
xfs_rmap_delete: dev 253:48 agno 0 agbno 341 len 2 owner 137 offset 58 flags 0x0
xfs_rmap_unmap_done: dev 253:48 agno 0 agbno 341 len 2 owner -9 offset 0 flags 0x0

# del rmap [0x12d, 40, -9]
xfs_rmap_unmap: dev 253:48 agno 0 agbno 301 len 40 owner -9 offset 0 flags 0x0
# del rmap [0x157, 4, -9]
xfs_rmap_unmap: dev 253:48 agno 0 agbno 343 len 4 owner -9 offset 0 flags 0x0
xfs_rmap_update: dev 253:48 agno 0 agbno 341 len 2 owner -9 offset 0 flags 0x0

Regards,

Tao

> Let's have a look at the log...
> 
> # xfs_logprint bugs.img | grep x178 -B3
> Oper (426): tid: 5c75a3f  len: 48  clientid: TRANS  flags: none
> CUI:  #regs: 1  num_extents: 2  id: 0xffff8f0e842f74b8
> (s: 0x2b, l: 1, f: 0x2) 
> (s: 0x178, l: 1, f: 0x4) 
> 
> ...ok, so we XFS_REFCOUNT_FREE_COW block 376, which removes it from from
> the refcountbt...
> 
> ----------------------------------------------------------------------------
> Oper (427): tid: 5c75a3f  len: 48  clientid: TRANS  flags: none
> BUI:  #regs: 1  num_extents: 1  id: 0xffff8f0e81f39000
> (s: 0x178, l: 1, own: 134, off: 19, f: 0x1) 
> 
> ...now we map block 376 into the data fork of inode 134 at offset 19...
> 
> --
> ----------------------------------------------------------------------------
> Oper (447): tid: 5c75a3f  len: 48  clientid: TRANS  flags: none
> RUI:  #regs: 1  num_extents: 1  id: 0xffff8f0e48254000
> (s: 0x178, l: 1, own: -9, off: 0, f: 0x8) 
> 
> ...now we XFS_RMAP_EXTENT_FREE the CoW extent @ block 376 from the rmap,
> which ought to remove the record...
> 
> --
> ----------------------------------------------------------------------------
> Oper (453): tid: e0ecea6a  len: 48  clientid: TRANS  flags: none
> RUI:  #regs: 1  num_extents: 1  id: 0xffff8f0e48254530
> (s: 0x178, l: 1, own: 134, off: 19, f: 0x2) 
> 
> ...and XFS_RMAP_EXTENT_MAP_SHARED a new rmapping for block 376, which
> should add the [376,1,134,19,0,0,0] that we'd expect to be there...
> 
> --
> ----------------------------------------------------------------------------
> Oper (13): tid: 17c5790c  len: 48  clientid: TRANS  flags: none
> RUI:  #regs: 1  num_extents: 1  id: 0xffff925955341f20
> (s: 0x178, l: 1, own: 134, off: 19, f: 0x2) 
> 
> ...strange, another rmap add?  Did the RUIs fail to complete?
> 
> # xfs_logprint bugs.img | egrep '(0xffff8f0e48254530|0xffff925955341f20)'
> RUI:  #regs: 1  num_extents: 1  id: 0xffff8f0e48254530
> RUD:  #regs: 1                   id: 0xffff8f0e48254530
> RUI:  #regs: 1  num_extents: 1  id: 0xffff925955341f20
> RUD:  #regs: 1                   id: 0xffff925955341f20
> 
> ...the first RUI is logged as operation 453 in tid e0ecea6a, and it has
> an RUD at 460.  However, I don't see a COMMIT, so I gather that log
> recovery tried to replay the RUI as operation 13 in tid 17c5790c.
> 
> ----------------------------------------------------------------------------
> Oper (13): tid: 17c5790c  len: 48  clientid: TRANS  flags: none
> RUI:  #regs: 1  num_extents: 1  id: 0xffff925955341f20
> (s: 0x178, l: 1, own: 134, off: 19, f: 0x2) 
> ----------------------------------------------------------------------------
> Oper (14): tid: 17c5790c  len: 16  clientid: TRANS  flags: none
> RUD:  #regs: 1                   id: 0xffff925955341f20
> ----------------------------------------------------------------------------
> Oper (15): tid: 17c5790c  len: 16  clientid: TRANS  flags: none
> RUD:  #regs: 1                   id: 0xffff8f0e48254000
> ----------------------------------------------------------------------------
> Oper (16): tid: 17c5790c  len: 24  clientid: TRANS  flags: none
> BUF:  #regs: 3   start blkno: 40 (0x28)  len: 8  bmap size: 1  flags: 0x2000
> Oper (17): tid: 17c5790c  len: 128  clientid: TRANS  flags: none
> BUF DATA
>  0 33424d52 31000000 ffffffff ffffffff        0 28000000  1000000 38000000 
>  8 3674196c 564cfddf 7798e496 591b6410        0 42249385        0  1000000 
> 10 ffffffff fdffffff        0        0  1000000  2000000 ffffffff fbffffff 
> 18        0        0  3000000  2000000 ffffffff faffffff        0        0 
> 
> Oper (18): tid: 17c5790c  len: 128  clientid: TRANS  flags: none
> BUF DATA
>  0        0        0 4d010000  9000000        0 8a000000        0 2a000000 
>  8 56010000  d000000 ffffffff f7ffffff        0        0 65010000 6b000000 
> 10 ffffffff f7ffffff        0        0 78010000  1000000        0 86000000 
> 18        0 13000000        0        0        0        0        0        0 
> 
> ----------------------------------------------------------------------------
> Oper (19): tid: 17c5790c  len: 0  clientid: TRANS  flags: COMMIT 
> 
> Ok, so those last two lines in operation 16 show that we've indeed added the
> new record to the rmapbt... <shrug> <confused> <tired>??
> 
> Are we sure that the log recovery actions actually get checkpointed
> correctly?  And just to check my own sanity, we generate a snapshot and
> then recover it and run xfs_repair, right?
> 
> --D
> 
>>
>>>
>>> (Normally I'd say send a metadump too for us mere mortals to work with,
>>> though I'm about to plunge into weddingland so I likely won't be able to
>>> do much until the 18th.)
>>>
>>
>> Attached (used xfs_metadump -ao)
>> Soon we will all be gods with powers to replay history ;)
>>
>>> ((Eric: If this doesn't turn out to be a totally garbage patch, feel
>>> free to add it to xfsprogs.))
>>>
>>> --D
>>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

