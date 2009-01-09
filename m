Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09HKXX7027608 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 11:20:33 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 343AD753F3
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 09:20:26 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	hq9aNShmcjPp6KIz for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2009 09:20:26 -0800 (PST)
Message-ID: <49678756.10303@thebarn.com>
Date: Fri, 09 Jan 2009 11:20:22 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: XFS: xfs_trans_cancel Filesystem shutdown
References: <4963B97D.1020201@gmx.net>
In-Reply-To: <4963B97D.1020201@gmx.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Carsten Menke <bootsy52@gmx.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Carsten Menke wrote:
> Hi,
>
> Yesterday I was called for a problem, one of the servers hat hung up 
> during
> the christmas days. When I looked into it, I saw there were a 
> filesystem error.
>
> This is the first time I expierence this with an XFS Filesystem, 
> however as the machine is in full production I had to solve the 
> problem and what I post here is what I have as debug information to 
> investigate. The machine was running
> on a 2.6.23.17 for 8 month without a problem. Then on Dec 22th, the 
> machine first reported a Filesystem shutdown to syslog for the /opt 
> partition and later hung up completley.
>
> I have unmounted the filesystem, run xfs_repair on it, (didn't create 
> any files in lost+found) and did not report any errors, then mounted 
> the filesystem again
> no problem so far. But as soon as I started the mailserver the 
> Filesystem was shutdown again. I did the steps several times always 
> with the same result. I then updated to Kernel 2.6.27.10 with the same 
> symphtoms. This is a Debian 3.0 system with xfs_reapir Version 2.6.20. 
> The /opt partition is on a soft raid
> /dev/md4 (/dev/sda8, /dev/sdb8). After destroying the partition, the 
> raid and repartition and reformat with xfsprogs 2.10.2 and restore 
> from backup, the server now runs again stable. The /opt partition is 
> only 51% full
>
> /dev/md4               47G   24G   24G  51% /opt

cc the xfs list.

Since you have wiped the file system it is going to be hard to get to 
the bottom of th issue.
It looks like you hit two different issues here, one is a shutdown and 
one look like a deadlock?


In the future it would be helpful to xfs_metadump the file system and 
then file a bug and attach the metadump image.


>
> Following are the first debug message and then the next after inital 
> xfs_repair and clean mount
>
> Dec 22 17:40:19 hauptserver kernel: Filesystem "md4": XFS internal 
> error xfs_trans_cancel at line 1169 of file fs/xfs/xfs_trans.c.  
> Caller 0xc
> Dec 22 17:40:19 hauptserver kernel:  [xfs_trans_cancel+93/231] 
> xfs_trans_cancel+0x5d/0xe7
> Dec 22 17:40:19 hauptserver kernel:  [xfs_create+1438/1499] 
> xfs_create+0x59e/0x5db
> Dec 22 17:40:19 hauptserver kernel:  [xfs_create+1438/1499] 
> xfs_create+0x59e/0x5db
> Dec 22 17:40:19 hauptserver kernel:  [xfs_acl_vhasacl_default+54/71] 
> xfs_acl_vhasacl_default+0x36/0x47
> Dec 22 17:40:19 hauptserver kernel:  [xfs_vn_mknod+379/654] 
> xfs_vn_mknod+0x17b/0x28e
> Dec 22 17:40:19 hauptserver kernel:  [xfs_vn_permission+15/19] 
> xfs_vn_permission+0xf/0x13
> Dec 22 17:40:19 hauptserver kernel:  [permission+209/214] 
> permission+0xd1/0xd6
> Dec 22 17:40:19 hauptserver kernel:  [vfs_create+198/261] 
> vfs_create+0xc6/0x105
> Dec 22 17:40:19 hauptserver kernel:  [open_namei_create+71/136] 
> open_namei_create+0x47/0x88
> Dec 22 17:40:19 hauptserver kernel:  [open_namei+342/1294] 
> open_namei+0x156/0x50e
> Dec 22 17:40:19 hauptserver kernel:  [vfs_stat_fd+25/64] 
> vfs_stat_fd+0x19/0x40
> Dec 22 17:40:19 hauptserver kernel:  [do_filp_open+37/57] 
> do_filp_open+0x25/0x39
> Dec 22 17:40:19 hauptserver kernel:  [get_unused_fd_flags+89/194] 
> get_unused_fd_flags+0x59/0xc2
> Dec 22 17:40:19 hauptserver kernel:  [do_sys_open+68/197] 
> do_sys_open+0x44/0xc5
> Dec 22 17:40:19 hauptserver kernel:  [sys_open+26/28] sys_open+0x1a/0x1c
> Dec 22 17:40:19 hauptserver kernel:  [syscall_call+7/11] 
> syscall_call+0x7/0xb
> Dec 22 17:40:19 hauptserver kernel:  =======================
> Dec 22 17:40:19 hauptserver kernel: xfs_force_shutdown(md4,0x8) called 
> from line 1170 of file fs/xfs/xfs_trans.c.  Return address = 0xc022041e
> Dec 22 17:40:19 hauptserver kernel: Filesystem "md4": Corruption of 
> in-memory data detected.  Shutting down filesystem: md4
> Dec 22 17:40:19 hauptserver kernel: Please umount the filesystem, and 
> rectify the problem(s)
>
> Jan  5 16:36:25 hauptserver kernel: BUG: soft lockup - CPU#1 stuck for 
> 11s! [mailserver:8172]
> Jan  5 16:36:25 hauptserver kernel:
> Jan  5 16:36:25 hauptserver kernel: Pid: 8172, comm:           mailserver
> Jan  5 16:36:25 hauptserver kernel: EIP: 
> 0060:[block_read_full_page+499/737] CPU: 1
> Jan  5 16:36:25 hauptserver kernel: EIP is at 
> block_read_full_page+0x1f3/0x2e1
> Jan  5 16:36:25 hauptserver kernel:  EFLAGS: 00210246    Not tainted  
> (2.6.23.17 #1)
> Jan  5 16:36:25 hauptserver kernel: EAX: 00000000 EBX: c710c8d0 ECX: 
> 000003d0 EDX: 00001000
> Jan  5 16:36:25 hauptserver kernel: ESI: c10610a0 EDI: c30850c0 EBP: 
> 00000000 DS: 007b ES: 007b FS: 00d8
> Jan  5 16:36:25 hauptserver kernel: CR0: 8005003b CR2: 08d86b18 CR3: 
> 01bee000 CR4: 00000690
> Jan  5 16:36:25 hauptserver kernel: DR0: 00000000 DR1: 00000000 DR2: 
> 00000000 DR3: 00000000
> Jan  5 16:36:25 hauptserver kernel: DR6: ffff0ff0 DR7: 00000400
> Jan  5 16:36:25 hauptserver kernel:  [update_curr+271/310] 
> update_curr+0x10f/0x136
> Jan  5 16:36:25 hauptserver kernel:  [xfs_get_blocks+0/45] 
> xfs_get_blocks+0x0/0x2d
> Jan  5 16:36:25 hauptserver kernel:  [update_curr+271/310] 
> update_curr+0x10f/0x136
> Jan  5 16:36:25 hauptserver kernel:  [do_mpage_readpage+1338/1364] 
> do_mpage_readpage+0x53a/0x554
> Jan  5 16:36:25 hauptserver kernel:  
> [__check_preempt_curr_fair+67/103] __check_preempt_curr_fair+0x43/0x67
> Jan  5 16:36:25 hauptserver kernel:  [run_timer_softirq+48/370] 
> run_timer_softirq+0x30/0x172
> Jan  5 16:36:25 hauptserver kernel:  [__rcu_process_callbacks+143/161] 
> __rcu_process_callbacks+0x8f/0xa1
> Jan  5 16:36:25 hauptserver kernel:  [tasklet_action+77/145] 
> tasklet_action+0x4d/0x91
> Jan  5 16:36:25 hauptserver kernel:  [mpage_readpage+75/94] 
> mpage_readpage+0x4b/0x5e
> Jan  5 16:36:25 hauptserver kernel:  [xfs_get_blocks+0/45] 
> xfs_get_blocks+0x0/0x2d
> Jan  5 16:36:25 hauptserver kernel:  [find_lock_page+26/126] 
> find_lock_page+0x1a/0x7e
> Jan  5 16:36:25 hauptserver kernel:  [filemap_fault+608/661] 
> filemap_fault+0x260/0x295
> Jan  5 16:36:25 hauptserver kernel:  [__do_fault+104/764] 
> __do_fault+0x68/0x2fc
> Jan  5 16:36:25 hauptserver kernel:  [handle_mm_fault+248/579] 
> handle_mm_fault+0xf8/0x243
> Jan  5 16:36:25 hauptserver kernel:  [do_page_fault+565/1466] 
> do_page_fault+0x235/0x5ba
> Jan  5 16:36:25 hauptserver kernel:  [do_futex+93/242] do_futex+0x5d/0xf2
> Jan  5 16:36:25 hauptserver kernel:  [do_page_fault+0/1466] 
> do_page_fault+0x0/0x5ba
> Jan  5 16:36:25 hauptserver kernel:  [error_code+114/120] 
> error_code+0x72/0x78
> Jan  5 16:36:25 hauptserver kernel:  [xfrm_state_find+665/1175] 
> xfrm_state_find+0x299/0x497
> Jan  5 16:36:25 hauptserver kernel:  =======================
>
> Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
