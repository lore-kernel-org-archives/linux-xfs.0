Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E46D7F7D
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 02:22:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F09D0304071
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 00:22:46 -0800 (PST)
Received: from mail-oa0-f48.google.com (mail-oa0-f48.google.com
	[209.85.219.48]) by cuda.sgi.com with ESMTP id mzuMbYvRUEp6NF1B
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jan 2014 00:22:45 -0800 (PST)
Received: by mail-oa0-f48.google.com with SMTP id l6so64929oag.21
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 00:22:44 -0800 (PST)
Message-ID: <52E768CF.5040908@gmail.com>
Date: Tue, 28 Jan 2014 03:22:39 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [NOISE] merge window blues, XFS broken
References: <52E56386.5040802@gmail.com> <20140127015614.GD2212@dastard>
	<52E62ADA.2040800@gmail.com> <20140127233039.GF2212@dastard>
In-Reply-To: <20140127233039.GF2212@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 01/27/2014 06:30 PM, Dave Chinner wrote:
> On Mon, Jan 27, 2014 at 04:46:02AM -0500, Michael L. Semon wrote:
>> root@plbearer:~# ls $TEST_DIR/
>>
>> [   94.140207] XFS: Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49
>>
>> Entering kdb (current=0xc5298c30, pid 297) Oops: (null)
>> due to oops @ 0x791752c5
>> CPU: 0 PID: 297 Comm: ls Not tainted 3.13.0+ #1
>> Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
>> task: c5298c30 ti: c520e000 task.ti: c520e000
>> EIP: 0060:[<791752c5>] EFLAGS: 00010286 CPU: 0
>> EIP is at assfail+0x2b/0x2d
>> EAX: 00000071 EBX: c60ba600 ECX: 00000296 EDX: c5299098
>> ESI: c60ba61c EDI: c60ba600 EBP: c520fe40 ESP: c520fe2c
>>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> CR0: 80050033 CR2: 08f1612c CR3: 4d1f0000 CR4: 000007d0
>> Stack:
>>  00000000 79570bc8 79576e28 7956946d 00000031 c520fe70 791ce45f c520fe70
>>  7917ceb0 c520fec4 c50d5068 c520fe70 c55d8000 00000000 c50d5068 c607ae30
>>  c60ba600 c520fed4 791cb72b c607af80 c6c01e80 000000d8 c4294000 c520feec
>> Call Trace:
>>  [<791ce45f>] xfs_inode_item_format+0x4a/0x1c5
> 
> It's not clear to me that there's anything wrong with the inode log
> item structure, so I need to know what iovec we tripped over here.
> Can you post the disassembly of this function so we can see which
> call to xlog_prepare_iovec tripped the assert? i.e.:
> 
> gdb> disass xfs_inode_item_format
> 
> to give the raw disassembly output, and
> 
> gdb> disass /m xfs_inode_item_format
> 
> To output the c-code annotated version.
> 
> Or even just annotating the code with printk()s prior to each
> xlog_prepare_iovec() call in xfs_inode_item_format will do ;)
> 
> Cheers,
> 
> Dave.
> 

OK, I had to generate a new crash for this, so pardon the dust:

# ======= SERIAL SESSION

root@plbearer:/var/lib/xfstests# mkfs.xfs -f $TEST_DEV
meta-data=/dev/md3p3             isize=256    agcount=8, agsize=131056 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=1048448, imaxpct=25
         =                       sunit=16     swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@plbearer:/var/lib/xfstests# mount $TEST_DEV $TEST_DIR
root@plbearer:/var/lib/xfstests# ls $TEST_DIR/
[  218.561794] XFS: Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49

Entering kdb (current=0xc5289860, pid 320) Oops: (null)
due to oops @ 0x791752c5
CPU: 0 PID: 320 Comm: ls Not tainted 3.13.0+ #12
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
task: c5289860 ti: c5210000 task.ti: c5210000
EIP: 0060:[<791752c5>] EFLAGS: 00010286 CPU: 0
EIP is at assfail+0x2b/0x2d
EAX: 00000071 EBX: c5095500 ECX: 000002a3 EDX: c5289cc8
ESI: c509551c EDI: c5095500 EBP: c5211e40 ESP: c5211e2c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 80050033 CR2: 0860f12c CR3: 4c2a8000 CR4: 000007d0
Stack:
 00000000 79571d00 79577f60 7956a5a5 00000031 c5211e70 791ce45f c5211e70
 7917ceb0 c5211ec4 c6356068 c5211e70 c55cc000 00000000 c6356068 c607ab10
 c5095500 c5211ed4 791cb72b c607af80 c6c01e80 000000d8 c5121000 c5211eec
Call Trace:
 [<791ce45f>] xfs_inode_item_format+0x4a/0x1c5
 [<7917ceb0>] ? kmem_alloc+0x64/0xdf
 [<791cb72b>] xfs_log_commit_cil+0x391/0x4c4
 [<7917c763>] xfs_trans_commit+0xac/0x230
 [<79172cf1>] xfs_vn_update_time+0xdb/0x142
 [<79172c16>] ? xfs_setattr_mode.isra.10+0x63/0x63
 [<790eb7f2>] update_time+0x1e/0x9e
 [<790ed28c>] touch_atime+0xcb/0x103
 [<790e5e89>] iterate_dir+0x8f/0x9b
 [<790e6041>] SyS_getdents64+0x6d/0xcc
 [<790e5d18>] ? filldir+0xc7/0xc7
 [<7944f1b8>] sysenter_do_call+0x12/0x36
Code: 
55 89 e5 83 ec 14 3e 8d 74 26 00  89  4c 24 10 89 
54 24 0c 89 44 24 08 c7 44 24 04  00  1d 57 79 c7 
04 24 00 00 00 00 e8 ad fd ff ff <0f> 0b 55 89 e5 
83 ec 14 3e 8d 74 26 00 c7 44 24  10  01 00 00 00

# ===== CRASH SESSION

root@plbearer:/mnt/storage/crashdump# crash vmlinux System.map vmcore
# setup was snipped

  SYSTEM MAP: System.map
DEBUG KERNEL: vmlinux  
    DUMPFILE: vmcore
        CPUS: 1
        DATE: Mon Jan 27 23:39:03 2014
      UPTIME: 00:03:38
LOAD AVERAGE: 0.06, 0.04, 0.02
       TASKS: 63
    NODENAME: plbearer
     RELEASE: 3.13.0+
     VERSION: #12 Mon Jan 27 23:30:59 EST 2014
     MACHINE: i686  (1794 Mhz)
      MEMORY: 1.2 GB
       PANIC: "kernel BUG at fs/xfs/xfs_message.c:107!"
         PID: 320
     COMMAND: "ls"
        TASK: c5289860  [THREAD_INFO: c5210000]
         CPU: 0
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 320    TASK: c5289860  CPU: 0   COMMAND: "ls"
 #0 [c5211d04] crash_kexec at 79074890
 #1 [c5211d50] do_invalid_op at 790023c8
 #2 [c5211dec] error_code (via invalid_op) at 7944eeef
    EAX: 00000071  EBX: c5095500  ECX: 000002a3  EDX: c5289cc8  EBP: c5211e40 
    DS:  007b      ESI: c509551c  ES:  007b      EDI: c5095500  GS:  2342
    CS:  0060      EIP: 791752c5  ERR: ffffffff  EFLAGS: 00010286 
 #3 [c5211e20] assfail at 791752c5
 #4 [c5211e44] xfs_inode_item_format at 791ce45a
 #5 [c5211e74] xfs_log_commit_cil at 791cb728
 #6 [c5211ed8] xfs_trans_commit at 7917c75e
 #7 [c5211f04] xfs_vn_update_time at 79172cec
 #8 [c5211f28] update_time at 790eb7f0
 #9 [c5211f44] touch_atime at 790ed287
#10 [c5211f5c] iterate_dir at 790e5e84
#11 [c5211f78] sys_getdents64 at 790e603c
#12 [c5211fb0] ia32_sysenter_target at 7944f1b1
    EAX: 000000dc  EBX: 00000003  ECX: 08607128  EDX: 00008000 
    DS:  007b      ESI: 08607128  ES:  007b      EDI: 6f790000
    SS:  007b      ESP: 778278b0  EBP: 00000000  GS:  0000
    CS:  0073      EIP: 6f7b2424  ERR: 000000dc  EFLAGS: 00000216 
crash> gdb disass /m xfs_inode_item_format
Dump of assembler code for function xfs_inode_item_format:
367     {
   0x791ce415 <+0>:     push   %ebp
   0x791ce416 <+1>:     mov    %esp,%ebp
   0x791ce418 <+3>:     push   %edi
   0x791ce419 <+4>:     push   %esi
   0x791ce41a <+5>:     push   %ebx
   0x791ce41b <+6>:     sub    $0x1c,%esp
   0x791ce41e <+9>:     lea    %ds:0x0(%esi,%eiz,1),%esi
   0x791ce423 <+14>:    mov    %eax,-0x1c(%ebp)
   0x791ce426 <+17>:    mov    %edx,%ebx

368             struct xfs_inode_log_item *iip = INODE_ITEM(lip);
369             struct xfs_inode        *ip = iip->ili_inode;
   0x791ce428 <+19>:    mov    0x44(%eax),%eax
   0x791ce42b <+22>:    mov    %eax,-0x14(%ebp)

370             struct xfs_inode_log_format *ilf;
371             struct xfs_log_iovec    *vecp = NULL;
   0x791ce42e <+25>:    movl   $0x0,-0x10(%ebp)

372     
373             ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
374             ilf->ilf_type = XFS_LI_INODE;
   0x791ce464 <+79>:    movw   $0x123b,(%esi)

375             ilf->ilf_ino = ip->i_ino;
   0x791ce469 <+84>:    mov    -0x14(%ebp),%ecx
   0x791ce46c <+87>:    mov    0x14(%ecx),%edx
   0x791ce46f <+90>:    mov    0x10(%ecx),%eax
   0x791ce472 <+93>:    mov    %eax,0xc(%esi)
   0x791ce475 <+96>:    mov    %edx,0x10(%esi)

376             ilf->ilf_blkno = ip->i_imap.im_blkno;
   0x791ce478 <+99>:    mov    0x1c(%ecx),%edx
   0x791ce47b <+102>:   mov    0x18(%ecx),%eax
   0x791ce47e <+105>:   mov    %eax,0x24(%esi)
   0x791ce481 <+108>:   mov    %edx,0x28(%esi)

377             ilf->ilf_len = ip->i_imap.im_len;
   0x791ce484 <+111>:   movzwl 0x20(%ecx),%eax
   0x791ce488 <+115>:   mov    %eax,0x2c(%esi)

378             ilf->ilf_boffset = ip->i_imap.im_boffset;
   0x791ce48b <+118>:   mov    %ecx,%edx
   0x791ce48d <+120>:   movzwl 0x22(%ecx),%eax
   0x791ce491 <+124>:   mov    %eax,0x30(%esi)

379             ilf->ilf_fields = XFS_ILOG_CORE;
   0x791ce494 <+127>:   movl   $0x1,0x4(%esi)

380             ilf->ilf_size = 2; /* format + core */
   0x791ce49b <+134>:   movw   $0x2,0x2(%esi)

381             xlog_finish_iovec(lv, vecp, sizeof(struct xfs_inode_log_format));
   0x791ce4a1 <+140>:   mov    -0x10(%ebp),%edi

382     
383             if (ip->i_d.di_version == 1)
   0x791ce4af <+154>:   mov    %ecx,%eax
   0x791ce4b1 <+156>:   movzbl 0x13c(%ecx),%ecx
   0x791ce4b8 <+163>:   cmp    $0x1,%cl
   0x791ce4bb <+166>:   je     0x791ce5c1 <xfs_inode_item_format+428>
   0x791ce4c1 <+172>:   mov    %cl,-0x18(%ebp)

384                     xfs_inode_item_format_v1_inode(ip);
   0x791ce5c1 <+428>:   mov    %edx,%edi
   0x791ce5c3 <+430>:   call   0x791cdc1e <xfs_inode_item_format_v1_inode>
   0x791ce5c8 <+435>:   movzbl 0x13c(%edi),%eax
   0x791ce5cf <+442>:   mov    %al,-0x18(%ebp)
   0x791ce5d2 <+445>:   mov    -0x10(%ebp),%edi
   0x791ce5d5 <+448>:   jmp    0x791ce4c4 <xfs_inode_item_format+175>

385             xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICORE,
386                             &ip->i_d,
   0x791ce4dd <+200>:   mov    -0x14(%ebp),%eax
   0x791ce4e0 <+203>:   add    $0x138,%eax
   0x791ce4e5 <+208>:   mov    %eax,-0x18(%ebp)

387                             xfs_icdinode_size(ip->i_d.di_version));
388     
389             xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
   0x791ce55d <+328>:   lea    -0x10(%ebp),%edi
   0x791ce560 <+331>:   mov    %edi,(%esp)
   0x791ce563 <+334>:   mov    %ebx,%ecx
   0x791ce565 <+336>:   mov    %esi,%edx
   0x791ce567 <+338>:   mov    -0x1c(%ebp),%eax
   0x791ce56a <+341>:   call   0x791cdc99 <xfs_inode_item_format_data_fork>

390             if (XFS_IFORK_Q(ip)) {
   0x791ce56f <+346>:   mov    -0x14(%ebp),%eax
   0x791ce572 <+349>:   cmpb   $0x0,0x18a(%eax)
   0x791ce579 <+356>:   jne    0x791ce597 <xfs_inode_item_format+386>

391                     xfs_inode_item_format_attr_fork(iip, ilf, lv, &vecp);
   0x791ce597 <+386>:   mov    %edi,(%esp)
   0x791ce59a <+389>:   mov    %ebx,%ecx
   0x791ce59c <+391>:   mov    %esi,%edx
   0x791ce59e <+393>:   mov    -0x1c(%ebp),%ebx
   0x791ce5a1 <+396>:   mov    %ebx,%eax
   0x791ce5a3 <+398>:   call   0x791ce09d <xfs_inode_item_format_attr_fork>
   0x791ce5a8 <+403>:   mov    0x60(%ebx),%eax

392             } else {
393                     iip->ili_fields &=
   0x791ce57b <+358>:   mov    -0x1c(%ebp),%ebx
   0x791ce57e <+361>:   mov    0x60(%ebx),%eax
   0x791ce581 <+364>:   and    $0xfffffe3f,%eax
   0x791ce586 <+369>:   mov    %eax,0x60(%ebx)

394                             ~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
395             }
396     
397             /* update the format with the exact fields we actually logged */
398             ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
   0x791ce589 <+372>:   and    $0xbf,%ah
   0x791ce58c <+375>:   or     %eax,0x4(%esi)
   0x791ce5ab <+406>:   and    $0xbf,%ah
   0x791ce5ae <+409>:   or     %eax,0x4(%esi)

399     }
   0x791ce58f <+378>:   add    $0x1c,%esp
   0x791ce592 <+381>:   pop    %ebx
   0x791ce593 <+382>:   pop    %esi
   0x791ce594 <+383>:   pop    %edi
   0x791ce595 <+384>:   pop    %ebp
   0x791ce596 <+385>:   ret    
   0x791ce5b1 <+412>:   add    $0x1c,%esp
   0x791ce5b4 <+415>:   pop    %ebx
   0x791ce5b5 <+416>:   pop    %esi
   0x791ce5b6 <+417>:   pop    %edi
   0x791ce5b7 <+418>:   pop    %ebp
   0x791ce5b8 <+419>:   ret    

End of assembler dump.
crash> quit
root@plbearer:/mnt/storage/crashdump# exit

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
