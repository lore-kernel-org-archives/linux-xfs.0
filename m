Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3765B4D98FD
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 11:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778585705; cv=none; b=hIlu7zeLEZiH16kcp7MPZ8CyNz5s+WBwNRZPXlNY0ZfccXLD5x6Qe1id1sl5kG2JpD7ionI8/9qlqHanpg2+rL9CUH21KFn0GYCzvfM1sZJ1bRMclhJbnt4+FxdlZPgxOZYwh5znSFAD9AplIMkwnN6WZYKqGgy870aFC+4eBzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778585705; c=relaxed/simple;
	bh=Wf1k5jCSkeyMl6borMZ+pHNCJaEdTHw2l9Vp6dR3hVY=;
	h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=bn5LY8QeOYKuZoy30+oSz5gCK0jMawqiLx8JNU4wTCiHqlP2KxNbX+iQ6H2ggBrCniyGQ/TGfX6US9v+T0kVBVD6AJYmHmG+1Q1GLbhQ1fw5yE1esAmCyvW2WLwQPmcw6TMvE6mPt9CRGTzcs6sNkyiaYoVX76eDSUQHWhCLRds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gFDy43xqqzKHLv9
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 19:34:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EBCEE40562
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 19:34:56 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1tgEANq5_cbCA--.59767S3;
	Tue, 12 May 2026 19:34:56 +0800 (CST)
To: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de, dgc@kernel.org
From: yebin <yebin@huaweicloud.com>
Subject: [bug report] kernel BUG at fs/xfs/xfs_message.c:102!
Message-ID: <6A031038.9030708@huaweicloud.com>
Date: Tue, 12 May 2026 19:34:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3v1tgEANq5_cbCA--.59767S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKry5CFyfAryUXFyfKF45ZFb_yoWxuFyxpr
	ZxCr1UGF4vqw18ZFsrAw15tr1fAw47CF4UJF4Ikr1fZa98CryIqrWDtF4YqFyDXrWrZFy2
	qF4Yy34vyw1YvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UWHqcUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

Hello Darrick and all,

Recently, I encountered a problem where a BUG was triggered in the write-back process.
The detailed problem information is as follows:
```
XFS (sde): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0xaa6/0xc60 (fs/xfs/xfs_trans.c:351).  Shutting.
XFS (sde): Please unmount the filesystem and rectify the problem(s)
XFS: Assertion failed: tp->t_blk_res || tp->t_fdblocks_delta >= 0, file: fs/xfs/xfs_trans.c, line: 610
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
RIP: 0010:assfail+0x9f/0xb0
Code: fe 84 db 75 20 e8 51 2e 33 fe 0f 0b 5b 5d 41 5c 41 5d c3 cc cc cc cc 48 c7 c7 58 ae 2b 8d e8 08 73 a2 fe eb cc e8 310
RSP: 0018:ffffc9000f6372e0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff838c91a6
RDX: ffff8881a856bb00 RSI: ffffffff838c91cf RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: fffff52001ec6ded
R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8a956520
R13: 0000000000000262 R14: 0000000000000000 R15: ffffffffffffffff
FS:  00007f7ee1f5b740(0000) GS:ffff88878bb45000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0e632788f0 CR3: 00000001b524a000 CR4: 00000000000006f0
Call Trace:
  <TASK>
  xfs_trans_unreserve_and_mod_sb+0xb86/0xd00
  __xfs_trans_commit+0x38b/0xe00
  xfs_trans_commit+0xeb/0x1a0
  xfs_bmapi_convert_one_delalloc+0xbca/0x1270
  xfs_bmapi_convert_delalloc+0x101/0x350
  xfs_writeback_range+0x76c/0x12d0
  iomap_writeback_folio+0x9ed/0x2100
  iomap_writepages+0x13c/0x2a0
  xfs_vm_writepages+0x278/0x330
  do_writepages+0x247/0x5c0
  filemap_writeback+0x22c/0x2e0
  xfs_file_release+0x442/0x580
  __fput+0x407/0xb50
  fput_close_sync+0x114/0x210
  __x64_sys_close+0x94/0x120
  do_syscall_64+0xc4/0xf80
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
```

After analyzing the above issues, the possible triggering process
is as follows:
```
xfs_bmapi_convert_delalloc
  xfs_bmapi_convert_one_delalloc
   xfs_bmapi_allocate
    xfs_bmap_add_extent_delay_real
     da_old = startblockval(PREV.br_startblock); // da_old = 5
     case BMAP_LEFT_FILLING:
      ifp->if_nextents++;  // 21 + 1 = 22
      if (xfs_bmap_needs_btree(bma->ip, whichfork))  // 22 > 21
       xfs_bmap_extents_to_btree     // convert to btree
         cur->bc_ino.allocated++;
       da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
                                startblockval(PREV.br_startblock) -
                                (bma->cur ? bma->cur->bc_ino.allocated : 0));  // da_new = 5 - 1 = 4
       PREV.br_startblock = nullstartblock(da_new); //xfs_bmapi_convert_one_delalloc() return

                                                  xfs_bmap_del_extent_real
                                                    case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
                                                     ifp->if_nextents--;  // 22 - 1 = 21
                                                     if (xfs_bmap_needs_btree(ip, whichfork))
                                                       xfs_bmap_extents_to_btree
                                                     else
                                                       xfs_bmap_btree_to_extents  // convert to extents
... // Alternate a few times in the middle.
da_old = 4
da_old = 3
da_old = 2
da_old = 1
...
xfs_bmapi_convert_delalloc
  xfs_bmapi_convert_one_delalloc
   error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, XFS_TRANS_RESERVE, &tp);  // Both blocks and rtextents are 0
    tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
    error = xfs_trans_reserve(tp, resp, blocks, rtextents);
    if (blocks > 0)
     error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
     tp->t_blk_res += blocks;    // The value of blocks is 0, so the value of tp->t_blk_res is 0
    xfs_bmapi_allocate
     xfs_bmap_add_extent_delay_real
      da_old = startblockval(PREV.br_startblock); // da_old = 0
      case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:   // The current delay extent is just exhausted.
       ifp->if_nextents++;  // 21 + 1 + 22

     if (xfs_bmap_needs_btree(bma->ip, whichfork))  // 22 > 21
      error = xfs_bmap_extents_to_btree(bma->tp, bma->ip, &bma->cur, da_old > 0, &tmp_logflags, whichfork);     // Converted to btree. da_old > 0 is false.
       args.wasdel = wasdel;   //  wasdel is false
       error = xfs_alloc_vextent(&args);
        xfs_alloc_ag_vextent(args, 0)
         xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
          case XFS_AG_RESV_NONE:
           field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS : XFS_TRANS_SB_FDBLOCKS; //args->wasdel  == false
           xfs_trans_mod_sb(args->tp, field, -(int64_t)args->len);
            case XFS_TRANS_SB_FDBLOCKS:
             if (delta < 0)
              tp->t_blk_res_used += (uint)-delta;
              if (tp->t_blk_res_used > tp->t_blk_res)  // ***tp->t_blk_res is 0, thus triggering xfs_force_shutdown()***
               xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
```

The logic that triggers the issue above was designed by me to facilitate the
construction of the problem. Besides the scenario where XFS_DINODE_FMT_BTREE
and XFS_DINODE_FMT_EXTENTS are converted back and forth, there is also the
scenario of btree splitting.

The core reason for the issue is that in xfs_bmapi_convert_delalloc(), the
call to xfs_bmap_worst_indlen() calculates the worst-case number of reserved
blocks, which is the number of additional blocks required after a complete
conversion of the entire delayed extent. It assumes that the entire conversion
process is atomic. However, the current process cannot guarantee such atomicity.
In the case of a fragmented filesystem, the most extreme scenario is that every
block conversion triggers a full btree split, in which case the reserved blocks
are far from sufficient. When this issue is triggered, the filesystem fragmentation
in the environment is indeed quite severe.

Further analysis of this abnormal model shows that because the reserved blocks
are continuously consumed, they may eventually exceed the reserved amount. When
the space is nearly exhausted, xfs_bmap_extents_to_btree() may fail to allocate
blocks, triggering a warning. This failure to allocate additional blocks can lead
to issues with normal block allocation.

Additionally, in xfs_bmap_add_extent_delay_real(), if a delayed extent is split
into two, xfs_bmap_worst_indlen() is recalculated to reserve blocks. In the case
of nearly exhausted space, it may be impossible to reserve the newly required
blocks, leading to a writeback failure.

During the reservation phase, reserving more blocks by considering the worst-case
scenario would require occupying a lot of extra space, which is not very practical.
I was thinking that we could convert all the delay extents at once to ensure
atomicity, which would ensure that the two issues analyzed above do not exist.
However, I am not sure what negative impacts this approach might have. The only
thing I can think of is that the reserved space would be repeatedly allocated and
released, but I believe the current logic already has similar situations.

I haven't thought of a better solution at the moment. I wonder if anyone has any
good ideas?


Thanks,
Ye Bin

