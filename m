Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8794B7F3F
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 17:09:01 -0500 (CDT)
Received: from eagdhcp-232-174.americas.sgi.com
	(eagdhcp-232-174.americas.sgi.com [128.162.232.174])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C11C8F8040
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 15:08:58 -0700 (PDT)
Message-ID: <53A8A578.4070005@sgi.com>
Date: Mon, 23 Jun 2014 17:08:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
References: <53A8A0AF.9070009@gmail.com>
In-Reply-To: <53A8A0AF.9070009@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 06/23/14 16:48, Michael L. Semon wrote:
> At the ACL limit of v5-superblock XFS--with a directory filled with both default
> and access ACL entries--I'm getting a null pointer dereference on x86 after
> creating the directory successfully.
>
> Disclaimer:  There's some current issues on 32-bit x86 that, for instance, can
> make badblocks see phantom bad blocks on a read test.  My apologies in advance
> if this turns out to be a false alarm bug report.
>
> My first encounter with this issue involved fsstress.  Here's part of a `crash`
> session from the fsstress run.
>
> root@oldsvrhw:/mnt/crashdump/xfs-fsstress-max-acl-2# crash vmlinux System.map vmcore
> crash 7.0.4
> # setup was snipped.
> DEBUG KERNEL: vmlinux
>      DUMPFILE: vmcore
>          CPUS: 1
>          DATE: Fri Jun 20 13:04:23 2014
>        UPTIME: 00:29:49
> LOAD AVERAGE: 1.06, 1.56, 0.75
>         TASKS: 78
>      NODENAME: oldsvrhw
>       RELEASE: 3.16.0-rc1+
>       VERSION: #1 SMP Thu Jun 19 20:10:57 EDT 2014
>       MACHINE: i686  (730 Mhz)
>        MEMORY: 510.4 MB
>         PANIC: "Oops: 0000 [#1] SMP DEBUG_PAGEALLOC" (check log for details)
>           PID: 41
>       COMMAND: "kworker/0:1H"
>          TASK: de8f2ac0  [THREAD_INFO: de92e000]
>           CPU: 0
>         STATE: TASK_RUNNING (PANIC)
>
> crash>  dmesg
> # ### excerpt:
>
> # ### mounted $SCRATCH_DEV, applied ACLs to $SCRATCH_MNT/test_dir
> [ 1499.886170] XFS (hdc5): Mounting V5 Filesystem
> [ 1500.057759] XFS (hdc5): Ending clean mount
>
> # ### ran `fsstress -d $SCRATCH_MNT/test-dir/a -n 10000 -p 16`
> # ### BTW, does fsstress trash the existing directory before a run?
> [ 1654.043846] fsstress (610) used greatest stack depth: 4956 bytes left
> [ 1654.063619] fsstress (615) used greatest stack depth: 4920 bytes left
> [ 1654.082220] fsstress (623) used greatest stack depth: 4820 bytes left
> [ 1654.087344] fsstress (611) used greatest stack depth: 4800 bytes left
> [ 1654.094295] fsstress (614) used greatest stack depth: 4784 bytes left
> [ 1654.191650] fsstress (608) used greatest stack depth: 4768 bytes left
> [ 1663.452036] perf interrupt took too long (2537>  2500), lowering kernel.perf_event_max_sample_rate to 50000
>
> # ### This was OK, so I hit Ctrl-c, then ran this (not in child directory):
> # ### ran `fsstress -d $SCRATCH_MNT/test-dir -n 10000 -p 16`
> [ 1789.338622] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> [ 1789.338842] IP: [<c1263048>] xfs_ail_check+0x58/0xc0
> [ 1789.338994] *pde = 00000000
> [ 1789.339042] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ 1789.339042] CPU: 0 PID: 41 Comm: kworker/0:1H Not tainted 3.16.0-rc1+ #1
> [ 1789.339042] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
> [ 1789.339042] Workqueue: xfslogd xfs_buf_iodone_work
> [ 1789.339042] task: de8f2ac0 ti: de92e000 task.ti: de92e000
> [ 1789.339042] EIP: 0060:[<c1263048>] EFLAGS: 00010286 CPU: 0
> [ 1789.339042] EIP is at xfs_ail_check+0x58/0xc0
> [ 1789.339042] EAX: 00000000 EBX: dde37370 ECX: 0000330a EDX: 0000330a
> [ 1789.339042] ESI: 00000001 EDI: 00000001 EBP: de92fc9c ESP: de92fc90
> [ 1789.339042]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 1789.339042] CR0: 8005003b CR2: 0000000c CR3: 1c8ef000 CR4: 000007d0
> [ 1789.339042] Stack:
> [ 1789.339042]  dde37370 ddc4ea80 00000001 de92fcac c12630c3 dde37370 00000012 de92fd04
> [ 1789.339042]  c1263d1d 00000000 00000001 00000000 00000000 ddc4ea88 de92fd38 dc8bba28
> [ 1789.339042]  ddc4ea80 00000000 0000330a de92fd44 0000001f 00000001 00000012 00003362
> [ 1789.339042] Call Trace:
> [ 1789.339042]  [<c12630c3>] xfs_ail_delete+0x13/0x60
> [ 1789.339042]  [<c1263d1d>] xfs_trans_ail_update_bulk+0xad/0x3c0
> [ 1789.339042]  [<c11fbd35>] xfs_trans_committed_bulk+0x255/0x300
> [ 1789.339042]  [<c125dcac>] xlog_cil_committed+0x3c/0x160
> [ 1789.339042]  [<c1259f8c>] xlog_state_do_callback+0x17c/0x380
> [ 1789.339042]  [<c125a253>] xlog_state_done_syncing+0xc3/0xe0
> [ 1789.339042]  [<c125a2de>] xlog_iodone+0x6e/0x100
> [ 1789.339042]  [<c11dd08b>] xfs_buf_iodone_work+0x5b/0xe0
> [ 1789.339042]  [<c1055bc5>] process_one_work+0x1b5/0x570
> [ 1789.339042]  [<c1055b48>] ? process_one_work+0x138/0x570
> [ 1789.339042]  [<c10560e5>] ? worker_thread+0x165/0x470
> [ 1789.339042]  [<c1056077>] worker_thread+0xf7/0x470
> [ 1789.339042]  [<c1055f80>] ? process_one_work+0x570/0x570
> [ 1789.339042]  [<c105d061>] kthread+0xa1/0xc0
> [ 1789.339042]  [<c108509b>] ? trace_hardirqs_on+0xb/0x10
> [ 1789.339042]  [<c1500ae1>] ret_from_kernel_thread+0x21/0x30
> [ 1789.339042]  [<c105cfc0>] ? insert_kthread_work+0x80/0x80
> [ 1789.339042] Code: c1 b8 d8 9e 62 c1 e8 a8 00 f9 ff 8b 43 04 39 c6 74 10 8b 7b 0c 39 78 0c 8b 53 08 8b 48 08 74 43 73 45 8b 03 39 c6 74 24 8b 73 0c<39>  70 0c 8b 53 08 8b 48 08 74 4d 73 14 b9 38 00 00 00 ba e3 a3
> [ 1789.339042] EIP: [<c1263048>] xfs_ail_check+0x58/0xc0 SS:ESP 0068:de92fc90
> [ 1789.339042] CR2: 000000000000000c
>
> Since then, I've been trying out different ways of reproducing this
> message.
>
> # ------ shortest way found so far ------
>
> For a seed file, use this URL...
>
> https://docs.google.com/file/d/0B41268QKoNjtMEU5UUZvMXF6ZzQ
>
> Hopefully, the order will go like this (from memory):
>
> # get the seed file, and
> xz -d max_acl_file.xz
>
> mkfs.xfs -f -m crc=1 $SCRATCH_DEV
> mount $SCRATCH_DEV $SCRATCH_MNT
>
> mkdir $SCRATCH_MNT/acl-dir
>
> setfacl --set-file=max_acl_file $SCRATCH_MNT/acl-dir
>
> cd $SCRATCH_MNT/acl-dir
>
> # or `touch a b c; mkdir d e f`
> mkdir a b c
> sync
>
> rm -rv ./*
> sync
>
> # ----------------------------------------
>
> That's as short as I can get it...if it works.  If not, keep trying
> different things.  The tests need not be heavy:  A few seconds worth
> of fs_mark should populate the directory sufficiently.  The `rm -rv ./*`
> is key.  sync is not required, the oops will happen on its own.
>
> This seems to happen only at a point where one or both ACL limits
> have been hit.  I'm only guessing that when a default entry is made, space
> is allocated for the access entry, and vice versa.
>
> Thanks!
>
> Michael
>

Michael, do you have the vmcore dump for this or was this just from the 
messages.

Thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
