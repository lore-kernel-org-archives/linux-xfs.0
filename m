Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36992 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdDLPv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 11:51:57 -0400
Received: by mail-wm0-f44.google.com with SMTP id u2so27394313wmu.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2017 08:51:56 -0700 (PDT)
Received: from [10.20.1.207] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id 36sm26021776wrk.15.2017.04.12.08.51.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Apr 2017 08:51:54 -0700 (PDT)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Deadlock between block allocation and block truncation
Message-ID: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
Date: Wed, 12 Apr 2017 18:51:53 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello, 

TL;DR 

2 process - one doing truncation the other allocation. Truncate process 
holds AGF0 buffer and waits on AGF1 buffer since it has to free 
an extent from that AG, whereas allocation process 
has failed doing an allocation the first time in xfs_bmap_btalloc 
(the first xfs_alloc_vextent) for a blkno falling in AGF1, and has returned 
with this buffer locked and is now trying a cyclic allocation 
beginning with AGF0. But both processes deadlock due to each holding 
the required AGF buffer. 

---- Detailed crash analysis follows ----

I've been investigating a rather peculiar deadlock between block 
allocation and block freeing. I've observed this on 3.12.72 as 
well as on 4.4.0 but not on 4.11-rc6 and 4.8 run is still pending.
 However I assume something in the code changed which made it 
harder to hit this race rather than a patch purposefully 
eliminating it. Essential running generic/299 sufficiently many 
times results in the following deadlock between 2 processes: 

ProcessA, doing allocation: 

PID: 4459   TASK: ffff8800a553d340  CPU: 3   COMMAND: "fio"
#0 [ffff8800b81cf218] __schedule at ffffffff8165be8b
 #1 [ffff8800b81cf270] schedule at ffffffff8165c80c
 #2 [ffff8800b81cf288] schedule_timeout at ffffffff816608ef
 #3 [ffff8800b81cf328] __down at ffffffff8165f791
 #4 [ffff8800b81cf378] down at ffffffff8109a4a1
 #5 [ffff8800b81cf398] xfs_buf_lock at ffffffff812e25e7
 #6 [ffff8800b81cf3c0] _xfs_buf_find at ffffffff812e28f4
 #7 [ffff8800b81cf410] xfs_buf_get_map at ffffffff812e2c8a
 #8 [ffff8800b81cf450] xfs_buf_read_map at ffffffff812e3f30
 #9 [ffff8800b81cf498] xfs_trans_read_buf_map at ffffffff81316a7c
#10 [ffff8800b81cf4d8] xfs_read_agf at ffffffff8129ee05
#11 [ffff8800b81cf538] xfs_alloc_read_agf at ffffffff8129ef54
#12 [ffff8800b81cf578] xfs_alloc_fix_freelist at ffffffff8129f3fc
#13 [ffff8800b81cf650] xfs_alloc_vextent at ffffffff8129f6e5   
#14 [ffff8800b81cf6a8] xfs_bmap_btalloc at ffffffff812b38b4 <- Called from if (args.fsbno == NULLFSBLOCK && nullfb) block
#15 [ffff8800b81cf788] xfs_bmap_alloc at ffffffff812b3a8e
#16 [ffff8800b81cf798] xfs_bmapi_write at ffffffff812b4476
#17 [ffff8800b81cf8e0] xfs_iomap_write_direct at ffffffff812f2eea
#18 [ffff8800b81cf980] __xfs_get_blocks at ffffffff812da63b
#19 [ffff8800b81cfa18] xfs_get_blocks_direct at ffffffff812db1a7
#20 [ffff8800b81cfa28] __blockdev_direct_IO at ffffffff811e0384
#21 [ffff8800b81cfc58] xfs_vm_direct_IO at ffffffff812d962b
#22 [ffff8800b81cfca0] xfs_file_dio_aio_write at ffffffff812e9b6f
#23 [ffff8800b81cfd38] xfs_file_write_iter at ffffffff812ea167
#24 [ffff8800b81cfd68] aio_run_iocb at ffffffff811ef6a2
#25 [ffff8800b81cfe60] do_io_submit at ffffffff811f1076
#26 [ffff8800b81cff40] sys_io_submit at ffffffff811f13e0
#27 [ffff8800b81cff50] entry_SYSCALL_64_fastpath at ffffffff81661eb6

So what happened here is that this process was called with the following 
xfs_bmalloca:

struct xfs_bmalloca {
  firstblock = 0xffff8800b81cf930, # When read this address shows (NULLFSBLOCK): ffff8800b81cf930:  ffffffffffffffff
  flist = 0xffff8800b81cf940, 
  tp = 0xffff880133c951d0, 
  ip = 0xffff88013a313400, 
  prev = {
    br_startoff = 1123392, 
    br_startblock = 88284, 
    br_blockcount = 32, 
    br_state = XFS_EXT_NORM
  }, 
  got = {
    br_startoff = 1124352, 
    br_startblock = 1102322, 
    br_blockcount = 32, 
    br_state = XFS_EXT_NORM
  }, 
  offset = 1124320, 
  length = 32, 
  blkno = 1102290, 
  cur = 0x0, 
  idx = 1655, 
  nallocs = 0, 
  logflags = 0, 
  total = 36, 
  minlen = 1, 
  minleft = 3, 
  eof = false, 
  wasdel = false, 
  aeof = false, 
  conv = false, 
  userdata = 1 '\001', 
  flags = 8
}
Based on that what likely happened is that we first called xfs_alloc_vextent with 
args->type = XFS_ALLOCTYPE_START_BNO set from xfs_bmap_btalloc_nullfb (this is 
is called since nullfb is true). In xfs_alloc_vextent we set args->agno = 1 
and args->type = XFS_ALLOCTYPE_THIS_AG and continue to call xfs_alloc_fix_freelist. 
It in turns reads AGN1 xfs_buf and eventually returns with this buffer locked and 
added to the transaction and args->agbp pointing to it. Subsequently we call 
xfs_alloc_ag_vextent which returns without an error and this breaks the out of the 
loop. However the following check in xfs_alloc_vextent triggers: 

if (args->agbno == NULLAGBLOCK)                                             
        args->fsbno = NULLFSBLOCK;

So despite xfs_alloc_ag_vextent not returning an error apparently it couldn't 
satisfy the block allocation. At this point we return to xfs_bmap_btalloc, which 
goes on to retry the allocation, this time iterating through every AG. The following
command confirms this: 

crash> dis -l ffffffff812b38b4
/home/nborisov/projects/kernel/source/fs/xfs/libxfs/xfs_bmap.c: 3850

Except this time xfs_alloc_vextent is entered with XFS_ALLOCTYPE_FIRST_AG and 
as soon as it starts iterating the AG's it block on trying to acquire AGF0 
xfs_buf. Here is the buf this process is actually waiting on: 
crash> struct xfs_buf.b_bn ffff8800a5f1c280
  b_bn = 1

At the same time it is holding AGF1 buf dirty. This is evident from the items in the 
transaction item list: 

crash> struct -ox xfs_trans.t_items 0xffff880133c951d0
struct xfs_trans {
  [ffff880133c95290] struct list_head t_items;
}
crash> list -s xfs_log_item_desc -l xfs_log_item_desc.lid_trans -H ffff880133c95290
ffff8800ba9955a8
struct xfs_log_item_desc {
  lid_item = 0xffff88013956d8e8, 
  lid_trans = {
    next = 0xffff8800ba995f88, 
    prev = 0xffff880133c95290
  }, 
  lid_flags = 0 '\000'
}
ffff8800ba995f88
struct xfs_log_item_desc {
  lid_item = 0xffff8800a60b1570, 
  lid_trans = {
    next = 0xffff880133c95290, 
    prev = 0xffff8800ba9955a8
  }, 
  lid_flags = 0 '\000'
}

crash> struct xfs_buf_log_item.bli_buf,bli_item 0xffff8800a60b1570
  bli_buf = 0xffff8800a5f1d900
  bli_item = {
    li_ail = {
      next = 0xffff8800b5d14640, 
      prev = 0xffff88013956d8e8
    }, 
    li_lsn = 8589944450, 
    li_desc = 0xffff8800ba995f80, 
    li_mountp = 0xffff8800a4e8b000, 
    li_ailp = 0xffff880139ef6f00, 
    li_type = 4668, 
    li_flags = 1, 
    li_bio_list = 0x0, 
    li_cb = 0xffffffff8130cbc0 <xfs_buf_iodone>, 
    li_ops = 0xffffffff8183d940 <xfs_buf_item_ops>, 
    li_cil = {
      next = 0xffff8800a60b15c0, 
      prev = 0xffff8800a60b15c0
    }, 
    li_lv = 0x0, 
    li_seq = 82
  }
crash> struct xfs_buf.b_bn 0xffff8800a5f1d900
  b_bn = 7680001

Checking what 7680001 corresponds to: 
xfs_db> agf 1
xfs_db> daddr
current daddr is 7680001

So this process is trully holding AGF1 locked. 

On the other hand I have the truncation process - ProcessB, whose 
call stack is: 

PID: 4532   TASK: ffff8800a5b03780  CPU: 3   COMMAND: "xfs_io"
 #0 [ffff8800a4dbb808] __schedule at ffffffff8165be8b
 #1 [ffff8800a4dbb860] schedule at ffffffff8165c80c
 #2 [ffff8800a4dbb878] schedule_timeout at ffffffff816608ef
 #3 [ffff8800a4dbb918] __down at ffffffff8165f791
 #4 [ffff8800a4dbb980] xfs_buf_lock at ffffffff812e25e7
 #5 [ffff8800a4dbb9a8] _xfs_buf_find at ffffffff812e28f4
 #6 [ffff8800a4dbb9f8] xfs_buf_get_map at ffffffff812e2c8a
 #7 [ffff8800a4dbba38] xfs_buf_read_map at ffffffff812e3f30
 #8 [ffff8800a4dbba80] xfs_trans_read_buf_map at ffffffff81316a7c
 #9 [ffff8800a4dbbac0] xfs_read_agf at ffffffff8129ee05
#10 [ffff8800a4dbbb20] xfs_alloc_read_agf at ffffffff8129ef54
#11 [ffff8800a4dbbb60] xfs_alloc_fix_freelist at ffffffff8129f3fc
#12 [ffff8800a4dbbc38] xfs_free_extent at ffffffff8129ff1d
#13 [ffff8800a4dbbcd8] xfs_trans_free_extent at ffffffff813177d6
#14 [ffff8800a4dbbd08] xfs_bmap_finish at ffffffff812dea09
#15 [ffff8800a4dbbd40] xfs_itruncate_extents at ffffffff812f903e
#16 [ffff8800a4dbbdd8] xfs_setattr_size at ffffffff812f541b
#17 [ffff8800a4dbbe28] xfs_vn_setattr at ffffffff812f54fb
#18 [ffff8800a4dbbe50] notify_change at ffffffff811bf152
#19 [ffff8800a4dbbe90] do_truncate at ffffffff8119fcd5
#20 [ffff8800a4dbbf00] do_sys_ftruncate.constprop.4 at ffffffff811a003b
#21 [ffff8800a4dbbf40] sys_ftruncate at ffffffff811a00ce
#22 [ffff8800a4dbbf50] entry_SYSCALL_64_fastpath at ffffffff81661eb6

So the first thing is inspecting what this process is waiting on:
crash> struct xfs_buf.b_bn ffff8800a5f1d900
  b_bn = 7680001

So a buffer describing AGF1 which is already held ProcessA.
Looking at the extent list it wants to truncate things add up: 

crash> struct xfs_bmap_free_t ffff8800a4dbbd98
struct xfs_bmap_free_t {
  xbf_first = 0xffff8800ba9555e8, 
  xbf_count = 1, 
  xbf_low = 0
}

crash> struct xfs_bmap_free_item 0xffff8800ba9555e8
struct xfs_bmap_free_item {
  xbfi_startblock = 1060329,  # >> 20 = AGF1
  xbfi_blockcount = 32, 
  xbfi_next = 0x0
}

Inspecting this process' transaction locked list I get the following
items: 

crash> list -s xfs_log_item_desc.lid_item,lid_flags -l xfs_log_item_desc.lid_trans -H ffff880133c95f40
ffff8800ba995f08
  lid_item = 0xffff8800b5d147d0
  lid_flags = 1 '\001'
ffff8800ba995248
  lid_item = 0xffff8801394ed2b8
  lid_flags = 1 '\001'
ffff8800ba9958a8
  lid_item = 0xffff8801394ed3a0
  lid_flags = 1 '\001'
ffff8800ba995448
  lid_item = 0xffff8801394ed488
  lid_flags = 1 '\001'

Printing each item's li_ops member reveals what they hold: 
crash> struct xfs_log_item.li_ops 0xffff8800b5d147d0
  li_ops = 0xffffffff8183d980 <xfs_efd_item_ops>
crash> struct xfs_log_item.li_ops 0xffff8801394ed2b8
  li_ops = 0xffffffff8183d940 <xfs_buf_item_ops>
crash> struct xfs_log_item.li_ops 0xffff8801394ed3a0
  li_ops = 0xffffffff8183d940 <xfs_buf_item_ops>
crash> struct xfs_log_item.li_ops 0xffff8801394ed488
  li_ops = 0xffffffff8183d940 <xfs_buf_item_ops>

So one xfs_efd_items_ops and 3 xfs_bufs. Printing each 
xfs_buf from the respective items: 

crash> struct xfs_buf_log_item.bli_buf 0xffff8801394ed2b8
  bli_buf = 0xffff8800a5f1c280
crash> struct xfs_buf_log_item.bli_buf 0xffff8801394ed3a0
  bli_buf = 0xffff8800b80a5180
crash> struct xfs_buf_log_item.bli_buf 0xffff8801394ed488
  bli_buf = 0xffff8800a5f1e300

crash> struct xfs_buf.b_bn 0xffff8800a5f1c280
  b_bn = 1    <= AGF0
crash> struct xfs_buf.b_bn 0xffff8800b80a5180
  b_bn = 8
crash> struct xfs_buf.b_bn 0xffff8800a5f1e300
  b_bn = 16

So we are holding on AGF0's buffer and 2 more buffers. At 
that point both processes are stuck each waiting for a buffer, held
by the opposite party. The only thing I'm worried about in the allocating
process is why doesn't it free the args->agbp if it fails allocating from 
that group. And under what conditions does the first execution of 
xfs_alloc_vextent return with no error and args->agbno = NULLAGBLOCK such that
args->fsbno is set to NULLFSBLOCK. 

On the other hand I haven't managed to figure out why the truncation process, 
wanting to free a block residing in AGF1 holds AGF0 locked. 

The only commit which contains anything remotely similar to this is 
e04426b9202b ("xfs: move allocation stack switch up to xfs_bmapi_allocate")

But it dates waaayy back in time, and this is already fixed in 4.4. 






