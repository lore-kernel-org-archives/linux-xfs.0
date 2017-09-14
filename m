Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:21706 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINKPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2017 06:15:44 -0400
Subject: Re: xfs: Uninitialized memory read at xlog_write
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20170911150157.GA13400@bfoster.bfoster>
        <201709131614.FAG69217.MSHFFVOFLJtQOO@I-love.SAKURA.ne.jp>
        <20170913094335.GV17782@dastard>
        <201709131859.AHB43227.SOFFOHJVMLFtOQ@I-love.SAKURA.ne.jp>
        <20170913214028.GX17782@dastard>
In-Reply-To: <20170913214028.GX17782@dastard>
Message-Id: <201709141915.HAD04123.FQOSHJtVOLFMFO@I-love.SAKURA.ne.jp>
Date: Thu, 14 Sep 2017 19:15:38 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: bfoster@redhat.com, sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

Dave Chinner wrote:
> On Wed, Sep 13, 2017 at 06:59:38PM +0900, Tetsuo Handa wrote:
> > Dave Chinner wrote:
> > > On Wed, Sep 13, 2017 at 04:14:37PM +0900, Tetsuo Handa wrote:
> > > > [  OK  ] Stopped target Switch Root.
> > > > 
> > > > [  OK  ] Stopped target Initrd File Systems.[ 1054.691505] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880135396660)
> > > > [ 1054.691506] 000000000000000093050a200000000000000000000000000000000000000000
> > > > [ 1054.691511]  u u u u u u u u i i i i i i i i u u u u u u u u u u u u u u u u
> > > > [ 1054.691515]  ^
> > > > [ 1054.691519] RIP: 0010:xlog_write+0x344/0x6b0
> > > 
> > > What line of code does this correspond to?
> > > 
> > 
> >                         /*
> >                          * Copy region.
> >                          *
> >                          * Unmount records just log an opheader, so can have
> >                          * empty payloads with no data region to copy. Hence we
> >                          * only copy the payload if the vector says it has data
> >                          * to copy.
> >                          */
> >                         ASSERT(copy_len >= 0);
> >                         if (copy_len > 0) {
> >                                 memcpy(ptr, reg->i_addr + copy_off, copy_len); // <= xlog_write+0x344/0x6b0
> >                                 xlog_write_adv_cnt(&ptr, &len, &log_offset,
> >                                                    copy_len);
> >                         }
> > 
> 
> Ok, that's what I suspected. The region being copied is set up
> in xlog_cil_insert_format_items(), so problem is in one of the
> ->iop_format methods it calls to format the dirty metadata into the
> region.
> 
> And given that the address is ...6660, it's likely the offset into
> the structure being copied is 96 bytes.
> 
> $ pahole...
> .....
> struct xfs_log_dinode {
> .....
>        xfs_agino_t                di_next_unlinked;     /*    96     4 */
> .....
> 
> Try the patch below.

That patch did not help.

I checked values passed to memcpy() using below patch.

----------
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c5107c7..f91c4c7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2476,6 +2476,8 @@
 			 */
 			ASSERT(copy_len >= 0);
 			if (copy_len > 0) {
+				printk(KERN_INFO "ptr=%p reg->i_addr=%p copy_off=%u copy_len=%u\n",
+				       ptr, reg->i_addr, copy_off, copy_len);
 				memcpy(ptr, reg->i_addr + copy_off, copy_len);
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 						   copy_len);
----------

The copy_len was not multiple of sizeof(struct xfs_log_dinode).
Thus, I guess we can't assume this is "struct xfs_log_dinode".

----------
         Starting Load/Save Random Seed...

         Starting Configure read-only root support...

[ 1106.927991] ptr=ffffc90001c08218 reg->i_addr=ffff880134c7fda8 copy_off=0 copy_len=16
[ 1106.928022] ptr=ffffc90001c08234 reg->i_addr=ffff88013395f858 copy_off=0 copy_len=56
[ 1106.928100] ptr=ffffc90001c08278 reg->i_addr=ffff88013395f890 copy_off=0 copy_len=96
[ 1106.932354] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff88013395f860)
[ 1106.932355] 58f895330188ffff0c0e06040000000000000000000000000000000000000000
[ 1106.932362]  u u u u u u u u i i i i i i i i u u u u u u u u u u u u u u u u
[ 1106.932368]  ^
[ 1106.932432] RIP: 0010:xlog_write+0x69a/0x730
[ 1106.932433] RSP: 0018:ffff880134c7fcc8 EFLAGS: 00010282
[ 1106.932434] RAX: 0000000000000038 RBX: ffff88013395f800 RCX: 000000000000000c
[ 1106.932434] RDX: ffffc90001c08234 RSI: ffff88013395f860 RDI: ffffc90001c0823c
[ 1106.932435] RBP: ffff880134c7fd70 R08: 0000000000000000 R09: 0000000000000000
[ 1106.932435] R10: ffffffff81dedfd8 R11: 0000000000000000 R12: 0000000000000038
[ 1106.932436] R13: 0000000000000002 R14: 0000000000000000 R15: ffff88013487f000
[ 1106.932437] FS:  0000000000000000(0000) GS:ffff88013f400000(0000) knlGS:0000000000000000
[ 1106.932438] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1106.932461] CR2: ffff88013486e418 CR3: 00000001339c9004 CR4: 00000000000606f0
[ 1106.932465]  xlog_write+0x69a/0x730
[ 1106.932467]  xlog_cil_push+0x240/0x460
[ 1106.932468]  xlog_cil_push_work+0x10/0x20
[ 1106.932470]  process_one_work+0x121/0x2a0
[ 1106.932471]  worker_thread+0x1b7/0x390
[ 1106.932472]  kthread+0xff/0x140
[ 1106.932506]  ret_from_fork+0x22/0x30
[ 1106.932509]  0xffffffffffffffff
[ 1137.332948] ptr=ffffc90001c10218 reg->i_addr=ffff880133bbbda8 copy_off=0 copy_len=16
[ 1137.332976] ptr=ffffc90001c10234 reg->i_addr=ffff880135240258 copy_off=0 copy_len=24
[ 1137.333024] ptr=ffffc90001c10258 reg->i_addr=ffff880135240270 copy_off=0 copy_len=384
[ 1167.850472] ptr=ffffc90001c18218 reg->i_addr=ffff88013182fda8 copy_off=0 copy_len=16
[ 1167.850503] ptr=ffffc90001c18234 reg->i_addr=ffff880136614a58 copy_off=0 copy_len=24
[ 1167.850555] ptr=ffffc90001c18258 reg->i_addr=ffff880136614a70 copy_off=0 copy_len=384
         Starting udev Coldplug all Devices...

         Starting Create Static Device Nodes in /dev...
----------

----------
[ 1561.441679] ptr=ffffc90001c08218 reg->i_addr=ffff880134c7fda8 copy_off=0 copy_len=16
[ 1561.441708] ptr=ffffc90001c08234 reg->i_addr=ffff8801319a4058 copy_off=0 copy_len=24
[ 1561.441755] ptr=ffffc90001c08258 reg->i_addr=ffff8801319a4070 copy_off=0 copy_len=128
[ 1561.441881] ptr=ffffc90001c082e4 reg->i_addr=ffff880131452068 copy_off=0 copy_len=24
[ 1561.441928] ptr=ffffc90001c08308 reg->i_addr=ffff880131452080 copy_off=0 copy_len=128
[ 1561.442048] ptr=ffffc90001c08394 reg->i_addr=ffff880131452100 copy_off=0 copy_len=3840
[ 1561.448086] ptr=ffffc90001c092a0 reg->i_addr=ffff88013636d068 copy_off=0 copy_len=24
[ 1561.448134] ptr=ffffc90001c092c4 reg->i_addr=ffff88013636d080 copy_off=0 copy_len=128
[ 1561.448253] ptr=ffffc90001c09350 reg->i_addr=ffff88013636d100 copy_off=0 copy_len=3456
[ 1561.454000] ptr=ffffc90001c0a0dc reg->i_addr=ffff880135b7a868 copy_off=0 copy_len=56
[ 1561.454073] ptr=ffffc90001c0a120 reg->i_addr=ffff880135b7a8a0 copy_off=0 copy_len=96
[ 1561.454170] ptr=ffffc90001c0a18c reg->i_addr=ffff880135b7a900 copy_off=0 copy_len=16
[ 1561.455971] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880135b7a874)
[ 1561.455973] 10000000070000003b12030005000000616310003a504e50e8ed120800000000
[ 1561.455979]  i i i i i i i i i i i i i i i i u u i i u u u u i i i i i i i i
[ 1561.455984]                                          ^
[ 1561.455989] RIP: 0010:xlog_write+0x69a/0x730
[ 1561.455989] RSP: 0018:ffff880134c7fcc8 EFLAGS: 00010282
[ 1561.455990] RAX: 0000000000000038 RBX: ffff880135b7a800 RCX: 000000000000000b
[ 1561.455991] RDX: ffffc90001c0a0dc RSI: ffff880135b7a874 RDI: ffffc90001c0a0e8
[ 1561.455991] RBP: ffff880134c7fd70 R08: 0000000000000000 R09: 0000000000000004
[ 1561.455992] R10: ffffffff81df2a14 R11: 0000000000000000 R12: 0000000000000038
[ 1561.455992] R13: 000000000000000a R14: 0000000000000000 R15: ffff88013487f170
[ 1561.455993] FS:  0000000000000000(0000) GS:ffff88013f400000(0000) knlGS:0000000000000000
[ 1561.455994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1561.455997] CR2: ffff88013486e418 CR3: 00000001319fc005 CR4: 00000000000606f0
[ 1561.455999]  xlog_write+0x69a/0x730
[ 1561.456000]  xlog_cil_push+0x240/0x460
[ 1561.456002]  xlog_cil_push_work+0x10/0x20
[ 1561.456003]  process_one_work+0x121/0x2a0
[ 1561.456004]  worker_thread+0x1b7/0x390
[ 1561.456005]  kthread+0xff/0x140
[ 1561.456007]  ret_from_fork+0x22/0x30
[ 1561.456009]  0xffffffffffffffff
----------
