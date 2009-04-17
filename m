Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3HFUYAb144758 for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 10:30:45 -0500
Received: from eu1sys200aog110.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B436B142D3CC
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 08:32:34 -0700 (PDT)
Received: from eu1sys200aog110.obsmtp.com (eu1sys200aog110.obsmtp.com
	[207.126.144.129]) by cuda.sgi.com with ESMTP id
	DHOeY2FGCXKFB8ZN for <xfs@oss.sgi.com>;
	Fri, 17 Apr 2009 08:32:34 -0700 (PDT)
Message-ID: <49E8A081.7020200@st.com>
Date: Fri, 17 Apr 2009 16:30:09 +0100
From: Stuart MENEFY <stuart.menefy@st.com>
MIME-Version: 1.0
Subject: Re: Help debugging a use after free
References: <49E37972.1070101@st.com> <49E4DF8C.4050800@thebarn.com>
In-Reply-To: <49E4DF8C.4050800@thebarn.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

Thanks for getting back to me.

Russell Cattelan wrote:
> Stuart MENEFY wrote:
>> Folks
>> 
>> For the last few days I've been trying to debug an apparent use
>> after free in XFS code. This is in a 2.6.23.17 kernel on an SH4
>> processor, so this could easily be an XFS problem which has already
>> been solved, or an architecture problem. This started because I've
>> been trying to work around the D-cache aliasing problems which the
>> SH4 suffers from because of XFS's use of vmap, so its also possible
>> this is an obscure aliasing problem. I've also been unable to
>> reproduce it on an x86_64, albeit with a slightly later kernel.
>> 
>> The problem occurs when running a loop which is essentially: mount
>> /dev/sda1 /mnt bonnie++  -u root -f -s0 -n16:1024:1024 -b -d /mnt
>> umount /mnt on an otherwise clean partition, and usually takes at
>> least 24 hours to appear.  The problem only occurs with SLAB
>> poisoning enabled, and results in a misaligned access because the
>> poison value when treated as a pointer is an illegal misaligned:
>> 
>> Unaligned kernel access on behalf of "bonnie++" pid=22419
>> pc=0x841a6c6c ins=0x8433 Pid : 22419, Comm:             bonnie++ PC
>> is at xfs_trans_unlocked_item+0xc/0x60 PC  : 841a6c6c SP  :
>> 87f29d3c SR  : 40008000 TEA : 00402ebe    Not tainted R0  :
>> 00000000 R1  : 841a6c60 R2  : 87f28000 R3  : 00000001 R4  :
>> 6b6b6b6b R5  : 6b6b6b6b R6  : 843342ac R7  : 840139c0 R8  :
>> 6b6b6b6b R9  : 6b6b6b6b R10 : 878cb000 R11 : 8452eb8c R12 :
>> 00003255 R13 : 00000625 R14 : 87f29d4c MACH: 00000000 MACL:
>> 0df75800 GBR : 297f9658 PR  : 84189d20
>> 
>> Call trace: [<84189d20>] xfs_iunlock+0x60/0xc0 [<841915da>]
>> xfs_inode_item_push+0x1a/0x40 [<841a6ff4>]
>> xfs_trans_push_ail+0x1b4/0x240 [<841971b6>]
>> xlog_grant_push_ail+0xf6/0x180 [<8419961c>]
>> xfs_log_reserve+0x3c/0xc0 [<841a540a>] xfs_trans_reserve+0x8a/0x220
>>  [<8418d6f0>] xfs_itruncate_finish+0x170/0x420 [<841a7de0>]
>> xfs_trans_ihold+0x0/0x20 [<841a7de0>] xfs_trans_ihold+0x0/0x20
>> [<841a7e60>] xfs_trans_ijoin+0x0/0xa0 [<841b112a>]
>> xfs_inactive+0x3ea/0x500 [<84189da0>] xfs_ilock+0x0/0xe0
>> [<841bf75c>] xfs_fs_clear_inode+0x3c/0xa0 [<843379a0>]
>> _spin_unlock+0x0/0x60 [<840818da>] clear_inode+0x5a/0x140
>> [<84081a92>] generic_delete_inode+0xd2/0x120 [<84081bc6>]
>> generic_drop_inode+0xe6/0x1c0 [<84080e2e>] iput+0x4e/0x80
>> [<840764ba>] do_unlinkat+0xfa/0x1a0 [<8408fdba>] do_fsync+0x7a/0xe0
>>  [<8408fe40>] __do_fsync+0x20/0x60 [<8407656e>] sys_unlink+0xe/0x20
>>  [<84076560>] sys_unlink+0x0/0x20 [<840088f8>] syscall_call+0xa/0xe
>> 
>> 
>> (Note that due to the way backtrace is implemented on SH
>> architectures there are spurious values in this backtrace, so it is
>> probably safe to ignore any entries of the form FN+0x0.)
>> 
>> The problem is caused by the "xfs_inode_t" which is passed into
>> xfs_iunlock() having already been freed at the SLAB level. Putting
>> some additional tracing code into the free path, this structure is
>> being freed by xfs_inode_item_destroy(), which is called from from
>> xfs_idestroy() which is called from xfs_ireclaim().
>
> I guess the first question is which thread has actually free'ed the
> inode? it sounds like a race

> that seems unlikely unless you are on a multi processor system. I
> don't know anything about the SH4 architecture
> but I assume this is a single processor system?

Correct, its a simple, in-order, uni-processor system.

> If you can instrument actually free that is causing the problem it
> would be good to print out the
> actually pid doing the free and as many return addresses that you can,
> so we can get an
> idea of the actual call chain.

The free is coming from the xfssyncd thread, the back trace looks like:

[<8418d0e2>] xfs_idestroy+0x22/0x100
[<8418a1b0>] xfs_ireclaim+0x50/0x80
[<841ad7f2>] xfs_finish_reclaim+0x32/0x1c0
[<841ada30>] xfs_finish_reclaim_all+0xb0/0x100
[<8418a780>] xfs_ilock_nowait+0x0/0x160
[<841a9df2>] xfs_syncsub+0x52/0x360
[<84335108>] schedule_timeout+0x48/0x100
[<841ab684>] xfs_sync+0x24/0x40
[<841e0ce0>] list_add+0x0/0x20
[<841c041c>] vfs_sync+0x1c/0x40
[<841bf37c>] vfs_sync_worker+0x1c/0x60
[<841bf6b6>] xfssyncd+0xb6/0x140
[<8402f0dc>] kthread+0x3c/0x80
[<84012440>] complete+0x0/0x60
[<841bf600>] xfssyncd+0x0/0x140
[<8402f060>] kthread_should_stop+0x0/0x20
[<84003984>] kernel_thread_helper+0x4/0x20
[<8402f0a0>] kthread+0x0/0x80
[<84003980>] kernel_thread_helper+0x0/0x20

with the same warning that there are probably some spurious entries here.

As before, any suggestions welcome.

Stuart

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
