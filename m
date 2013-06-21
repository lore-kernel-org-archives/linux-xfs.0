Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A8C367F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 13:45:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9540D304051
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 11:45:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xk9gH8mHqNDDgtqA for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 11:45:47 -0700 (PDT)
Message-ID: <51C49F5A.3020907@sandeen.net>
Date: Fri, 21 Jun 2013 13:45:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: group for tests that are dangerous for verifiers?
References: <51C341E1.8000302@sgi.com>
In-Reply-To: <51C341E1.8000302@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/20/13 12:54 PM, Mark Tinguely wrote:
> Do we need a xfstest verifier dangerous group?
> 
> xfstest 111 purposely damages inodes. In hindsight it make sense
> that it asserts when running with verifiers.

But it only asserts on a debug kernel... 

This isn't the only place where corruption could ASSERT on debug;
see xlog_recover_add_to_trans() for example.

But if the test intentionally corrupts it and that leads to
an ASSERT that does seem problematic for anyone testing w/ debug
enabled.

I guess I'd vote for removing the ASSERT unless there's
some reason it should be there - Dave?

-Eric

>  mkfs.xfs  -f /dev/sda3
> meta-data=/dev/sda3              isize=256    agcount=4, agsize=4194496 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=16777984, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=8192, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> db/xfs_db /dev/sda3
> xfs_db> sb 0
> xfs_db> p
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 16777984
> rblocks = 0
> rextents = 0
> uuid = fd78c924-79c8-4cc4-af42-c5a8b505ab05
> logstart = 16777220
> rootino = 128
> rbmino = 129
> rsumino = 130
> rextsize = 1
> agblocks = 4194496
> agcount = 4
> rbmblocks = 0
> logblocks = 8192
> versionnum = 0xb4a4
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 23
> rextslog = 0
> inprogress = 0
> imax_pct = 25
> icount = 64
> ifree = 61
> fdblocks = 16769772
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 1
> features2 = 0xa
> bad_features2 = 0xa
> 
> 72715.142266] XFS (sda3): Mounting Filesystem
> [72715.811778] XFS (sda3): Corruption detected. Unmount and run xfs_repair
> [72715.818396] XFS (sda3): bad inode magic/vsn daddr 64 #8 (magic=5858)
> [72715.824748] XFS: Assertion failed: 0, file: /root/xfs/fs/xfs/xfs_inode.c, line: 417
> 
> PID: 271    TASK: ffff88034fb365c0  CPU: 1   COMMAND: "kworker/1:1H"
>  #0 [ffff88034f407a10] machine_kexec at ffffffff8102a0c0
>  #1 [ffff88034f407a60] crash_kexec at ffffffff810a4943
>  #2 [ffff88034f407b30] oops_end at ffffffff8145dc10
>  #3 [ffff88034f407b60] die at ffffffff81005693
>  #4 [ffff88034f407b90] do_trap at ffffffff8145d583
>  #5 [ffff88034f407bf0] do_invalid_op at ffffffff81002de0
>  #6 [ffff88034f407c90] invalid_op at ffffffff81465ca8
>     [exception RIP: assfail+29]
>     RIP: ffffffffa04614dd  RSP: ffff88034f407d48  RFLAGS: 00010296
>     RAX: 0000000000000047  RBX: ffff88034dedc800  RCX: 0000000000000dda
>     RDX: 0000000000000000  RSI: 0000000000000082  RDI: ffffffff81a2dfc0
>     RBP: ffff88034f407d48   R8: ffffffff81cd4848   R9: ffffffff81ce7003
>     R10: 0000000000000068  R11: 000000000002d89c  R12: 0000000000000008
>     R13: ffff88034f57ee40  R14: ffff88034f0ba800  R15: 0000000000000020
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffff88034f407d50] xfs_inode_buf_verify at ffffffffa04aa400 [xfs]
>  #8 [ffff88034f407db0] xfs_inode_buf_read_verify at ffffffffa04aa4b9 [xfs]
>  #9 [ffff88034f407dc0] xfs_buf_iodone_work at ffffffffa044fd45 [xfs]
> #10 [ffff88034f407df0] process_one_work at ffffffff81059c8f
> #11 [ffff88034f407e50] worker_thread at ffffffff8105ad3b
> #12 [ffff88034f407ec0] kthread at ffffffff810612fb
> #13 [ffff88034f407f50] ret_from_fork at ffffffff81464b6c
> 
> 
> PID: 20866  TASK: ffff880351f24180  CPU: 1   COMMAND: "mount"
>  #0 [ffff88035175f7c8] __schedule at ffffffff8145b6fe
>  #1 [ffff88035175f850] schedule at ffffffff8145bb34
>  #2 [ffff88035175f860] schedule_timeout at ffffffff81459bd5
>  #3 [ffff88035175f910] wait_for_completion at ffffffff8145ac6d
>  #4 [ffff88035175f970] xfs_buf_iowait at ffffffffa0450a09 [xfs]
>  #5 [ffff88035175f9b0] _xfs_buf_read at ffffffffa0450bf9 [xfs]
>  #6 [ffff88035175f9d0] xfs_buf_read_map at ffffffffa0450cf3 [xfs]
>  #7 [ffff88035175fa20] xfs_trans_read_buf_map at ffffffffa04ca0e9 [xfs]
>  #8 [ffff88035175fa90] xfs_imap_to_bp at ffffffffa04aa52b [xfs]
>  #9 [ffff88035175fb10] xfs_iread at ffffffffa04b0e5d [xfs]
> #10 [ffff88035175fb80] xfs_iget_cache_miss at ffffffffa04586a0 [xfs]
> #11 [ffff88035175fbf0] xfs_iget at ffffffffa0459589 [xfs]
> #12 [ffff88035175fc80] xfs_mountfs at ffffffffa04bad49 [xfs]
> #13 [ffff88035175fcf0] xfs_fs_fill_super at ffffffffa0464ad7 [xfs]
> #14 [ffff88035175fd30] mount_bdev at ffffffff81155f85
> #15 [ffff88035175fdb0] xfs_fs_mount at ffffffffa04626d0 [xfs]
> #16 [ffff88035175fdc0] mount_fs at ffffffff81156bee
> #17 [ffff88035175fe10] vfs_kern_mount at ffffffff8116fe21
> #18 [ffff88035175fe60] do_new_mount at ffffffff8117136f
> #19 [ffff88035175fec0] do_mount at ffffffff811729b6
> #20 [ffff88035175ff20] sys_mount at ffffffff81172a8b
> #21 [ffff88035175ff80] system_call_fastpath at ffffffff81464c12
>     RIP: 00007fbcdfd09daa  RSP: 00007fffcb9f6f38  RFLAGS: 00010202
>     RAX: 00000000000000a5  RBX: ffffffff81464c12  RCX: ffffffffffffffc8
>     RDX: 00007fbce0a6ce80  RSI: 00007fbce0a6ce60  RDI: 00007fbce0a6ce40
>     RBP: 00000000c0ed0400   R8: 0000000000000000   R9: 0101010101010101
>     R10: ffffffffc0ed0400  R11: 0000000000000202  R12: 00007fbce0a6ce60
>     R13: 00007fbce0a6cde0  R14: 0000000000000400  R15: 0000000000000000
>     ORIG_RAX: 00000000000000a5  CS: 0033  SS: 002b
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
