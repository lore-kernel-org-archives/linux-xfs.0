Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 881C07F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 11:17:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11B80AC005
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 09:17:06 -0700 (PDT)
Received: from mail-vc0-f176.google.com (mail-vc0-f176.google.com
	[209.85.220.176]) by cuda.sgi.com with ESMTP id
	UO9enYdztnckQbrC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 09:17:00 -0700 (PDT)
Received: by mail-vc0-f176.google.com with SMTP id ha11so711759vcb.7
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 09:17:00 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 May 2013 12:17:00 -0400
Message-ID: <CAC=U0a1QhhCkorapaDrSm6PDHQr0s81Z1DH=3RzCyE5hBqziyA@mail.gmail.com>
Subject: Kernel 3.3 XFS: Assertion failed: xfs_trans_get_block_res(tp) > 0
From: Kamal Dasu <kdasu.kdev@gmail.com>
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
To: xfs@oss.sgi.com

Hi,

obsering kernel 3.3. instability with

When writing  3 realtime and 1 regular file on disk simultaneously
(sync is blocking function). the rcu stall detection kicks in every
time when 3rd-4th attempt.

Just wanted understand the  root cause of the problem

This ithe info on the stack dumps without xfs debug and with cxfs
debug enabled repectively.


/dev/sda1 is XFS real time partition
/dev/sda2 is XFS non-real time partition.

count=1;
while [ 1 ];do
    #create file on disk /dev/sda1 (-R realtime)
    xfs_io -c open -f -R "/opt/corefiles/$count" -c "pwrite 0
20000000" -c close >> /dev/null &
    let a=$count%3;
    if [ $a -eq 0 ]; then
      let count+=1;
      #create file on disk /dev/sda2
      xfs_io -c open -f "/opt/corefiles/$count" -c "pwrite 0 200000"
-c close >> /dev/null &
      echo "sync";
      sync /opt;
    fi;
    let count+=1;
done

Oops Log:

# ./xfs.sh
sync
INFO: rcu_sched detected stall on CPU 0 (t=60000 jiffies)
Call Trace:
[<805d3814>] dump_stack+0x8/0x34
[<80084398>] __rcu_pending+0x260/0x4c4
[<80084f00>] rcu_check_callbacks+0x118/0x180
[<80034ea0>] update_process_times+0x40/0x6c
[<8006e324>] tick_sched_timer+0x74/0xe4
[<8004cc50>] __run_hrtimer.clone.30+0x64/0x140
[<8004dc20>] hrtimer_interrupt+0x19c/0x4bc
[<8000bff8>] c0_compare_interrupt+0x50/0x88
[<8007c678>] handle_irq_event_percpu+0x5c/0x234
[<80080a74>] handle_percpu_irq+0x8c/0xc0
[<8007bd14>] generic_handle_irq+0x34/0x54
[<80006084>] do_IRQ+0x18/0x24
[<800034a4>] plat_irq_dispatch+0xd0/0x128
[<80004364>] ret_from_irq+0x0/0x4
[<8028b1c0>] xfs_inode_item_format_extents+0x1c/0xf0
[<8028b5a0>] xfs_inode_item_format+0x30c/0x320
[<80288fcc>] xfs_log_commit_cil+0xe0/0x564
[<8028346c>] xfs_trans_commit+0x148/0x2d0
[<8022ad40>] xfs_iomap_write_allocate+0x1b0/0x560
[<8021c12c>] xfs_map_blocks+0x224/0x278
[<8021d3d8>] xfs_vm_writepage+0x240/0x6ec
[<80092690>] __writepage+0x18/0xc8
[<80092ae0>] write_cache_pages+0x264/0x4c0
[<80092d84>] generic_writepages+0x48/0x84
[<800f0234>] writeback_single_inode+0x160/0x390
[<800f08c4>] writeback_sb_inodes+0x1c0/0x2a4
[<800f0f08>] __writeback_inodes_wb+0xbc/0x114
[<800f132c>] wb_writeback+0x204/0x20c
[<800f1cb4>] wb_do_writeback+0x29c/0x2a4
[<800f1d64>] bdi_writeback_thread+0xa8/0x1ac
[<80047d0c>] kthread+0x90/0x98
[<8000636c>] kernel_thread_helper+0x10/0x18

INFO: rcu_sched detected stall on CPU 0 (t=240030 jiffies)
Call Trace:
[<805d3814>] dump_stack+0x8/0x34
[<80084398>] __rcu_pending+0x260/0x4c4
[<80084f00>] rcu_check_callbacks+0x118/0x180
[<80034ea0>] update_process_times+0x40/0x6c
[<8006e324>] tick_sched_timer+0x74/0xe4
[<8004cc50>] __run_hrtimer.clone.30+0x64/0x140
[<8004dc20>] hrtimer_interrupt+0x19c/0x4bc
[<8000bff8>] c0_compare_interrupt+0x50/0x88
[<8007c678>] handle_irq_event_percpu+0x5c/0x234
[<80080a74>] handle_percpu_irq+0x8c/0xc0
[<8007bd14>] generic_handle_irq+0x34/0x54
[<80006084>] do_IRQ+0x18/0x24
[<800034a4>] plat_irq_dispatch+0xd0/0x128
[<80004364>] ret_from_irq+0x0/0x4
[<802c7c88>] arch_local_irq_restore+0x18/0x30
[<800c2b7c>] kmem_cache_alloc+0x78/0xd0
[<80238a40>] kmem_zone_alloc+0xa4/0x130
[<80238ae4>] kmem_zone_zalloc+0x18/0x54
[<80282f08>] xfs_trans_add_item+0x28/0x64
[<8028c98c>] _xfs_trans_bjoin+0x6c/0xcc
[<8028cddc>] xfs_trans_read_buf+0x234/0x304
[<8028d638>] xfs_rtbuf_get+0x148/0x168
[<8028df10>] xfs_rtmodify_summary+0x94/0x124
[<8028ed28>] xfs_rtallocate_range+0x180/0x328
[<8028f748>] xfs_rtallocate_extent_exact+0xc4/0x158
[<80290054>] xfs_rtallocate_extent_near+0xb0/0x448
[<80290ce4>] xfs_rtallocate_extent+0x1c8/0x1fc
[<8024a9fc>] xfs_bmap_rtalloc+0x1bc/0x3f8
[<8024df20>] xfs_bmapi_allocate+0xec/0x354
[<8025139c>] xfs_bmapi_write+0x264/0x82c
[<8022ad18>] xfs_iomap_write_allocate+0x188/0x560
[<8021c12c>] xfs_map_blocks+0x224/0x278
[<8021d3d8>] xfs_vm_writepage+0x240/0x6ec
[<80092690>] __writepage+0x18/0xc8
[<80092ae0>] write_cache_pages+0x264/0x4c0
[<80092d84>] generic_writepages+0x48/0x84
[<800f0234>] writeback_single_inode+0x160/0x390
[<800f08c4>] writeback_sb_inodes+0x1c0/0x2a4
[<800f0f08>] __writeback_inodes_wb+0xbc/0x114
[<800f132c>] wb_writeback+0x204/0x20c
[<800f1cb4>] wb_do_writeback+0x29c/0x2a4
[<800f1d64>] bdi_writeback_thread+0xa8/0x1ac
[<80047d0c>] kthread+0x90/0x98
[<8000636c>] kernel_thread_helper+0x10/0x18


With the xfs debug enabled this is the assert I  get :

XFS: Assertion failed: xfs_trans_get_block_res(tp) > 0, file: fs/xfs/xfs_bmap.c,
 line: 5203
Kernel bug detected[#1]:
Cpu 0
$ 0 : 00000000 30008700 00000062 806b9dc4
$ 4 : 30008701 30008701 00000266 8032b24c
$ 8 : 00000010 00000002 00000001 00000000
$12 : 00000102 000003ff 00000000 00000000
$16 : 00000000 00000000 00001fff cf9b1300
$20 : 00001313 cf7dc000 cf76e420 00000002
$24 : 00000010 8032a9d0
$28 : cf672000 cf673c50 806416c8 80230718
Hi : 00000000
Lo : b0f9b000
epc : 80230718 assfail+0x28/0x2c
    Not tainted
ra : 80230718 assfail+0x28/0x2c
Status: 30008703 KERNEL EXL IE
Cause : 00800024
PrId : 00025a11 (Broadcom BMIPS5000)
Modules linked in:
Process xfs_io (pid: 602, threadinfo=cf672000, task=cfcba9d8, tls=7729f460)
Stack : 817bc3a0 00000000 80642b64 806416c8 00001453 00000000 00000000 8025ab7c
        00000d00 00000d00 cf76e400 00000000 00000000 cf673c9c cf673ca0 cf673cd8
        cf673cf8 cf673d6c 00000000 00000001 00000002 00000000 cf673d98 80250778
        ffffff83 000003ff 00001313 00000000 fffe0015 000fffff 00000ced 00000000
        00000000 8023b9c4 00001000 00000000 fffe0015 000fffff 00001000 00000000
        ...
Call Trace:
[<80230718>] assfail+0x28/0x2c
[<8025ab7c>] xfs_bunmapi+0xcb8/0x12f8
[<80285144>] xfs_itruncate_extents+0x290/0x488
[<80237200>] xfs_free_eofblocks+0x2d4/0x354
[<80237c50>] xfs_release+0x1b8/0x294
[<80222fb0>] xfs_file_release+0x10/0x20
[<800c8978>] fput+0x104/0x288
[<800c3a50>] filp_close+0x6c/0xa0
[<800c3b50>] sys_close+0xcc/0x12c
[<8000db5c>] stack_done+0x20/0x40


Code: afbf001c 0c08c0f6 00403021 <0200000d> 27bdffd8 afa40014 afa50018 3c04
8064 3c058062
---[ end trace 8e5cc13475cfce38 ]---



Thank You
Kamal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
