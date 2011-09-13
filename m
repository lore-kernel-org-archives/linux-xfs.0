Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8D64dxC042702 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 01:04:39 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CFC2159079
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 23:04:37 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id 9VIKnzhP8vFdN68w
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 23:04:37 -0700 (PDT)
Message-ID: <4E6EF274.7050007@profihost.ag>
Date: Tue, 13 Sep 2011 08:04:36 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
In-Reply-To: <20110912200543.GA22409@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

> On Mon, Sep 12, 2011 at 06:46:26PM +0200, Stefan Priebe wrote:
>>> What kind of workload are you running?  Also did the workload run fine
>>> with an older kernel, and if yes which one?
>>
>> Mysql, Web, Mail, ftp ;-) yes it was with 2.6.32. I upgraded from that version.
>
> Just curious, is this the same system that also shows the freezes
> reported to the scsi list?  If I/Os don't get completed by lower layers
> I can see how we get everything in XFS waiting on the log reservations,
> given that we never get the log tail pushed.

I just reported it to the scsi list as i didn't knew where the problems 
is. But then some people told be it must be a XFS problem.

Some more informations:
1.) It's running with 2.6.32 and 2.6.38
2.) I can also write to another ext2 part on the same disk array(aacraid 
driver) while xfs stucks - so i think it must be an xfs problem
3.) I've also tried running 3.1-rc5 but then i'm seeing this error:

BUG: unable to handle kernel NULL pointer dereference at 000000000000012c
IP: [] inode_dio_done+0x4/0x25
PGD 293724067 PUD 292930067 PMD 0
Oops: 0002 [#1] SMP
CPU 5
Modules linked in: ipt_REJECT xt_tcpudp iptable_filter ip_tables 
x_tables coretemp k8temp

Pid: 4775, comm: mysqld Not tainted 3.1-rc5 #1 Supermicro X8DT3/X8DT3
RIP: 0010:[] [] inode_dio_done+0x4/0x25
RSP: 0018:ffff880292b5fad8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8806ab4927e0 RCX: 0000000000007524
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff880292b5fad8 R08: ffff880292b5e000 R09: 0000000000000000
R10: ffff88047f85e040 R11: ffff88042ddb5d88 R12: ffff88002b7f8800
R13: ffff88002b7f8800 R14: 0000000000000000 R15: ffff88042d896040
FS: 0000000045c79950(0063) GS:ffff88083fc40000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000012c CR3: 0000000293408000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mysqld (pid: 4775, threadinfo ffff880292b5e000, task 
ffff88042d896040)
Stack:
ffff880292b5faf8 ffffffff811938cd 0000000192b5fb18 0000000000004000
ffff880292b5fb18 ffffffff810feba2 0000000000000000 ffff88002b7f8920
ffff880292b5fbf8 ffffffff810ff4fb ffff880292b5fb78 ffff880292b5e000
Call Trace:
[] xfs_end_io_direct_write+0x6a/0x6e
[] dio_complete+0x90/0xbb
[] __blockdev_direct_IO+0x92e/0x964
[] ? mempool_alloc_slab+0x11/0x13
[] xfs_vm_direct_IO+0x90/0x101
[] ? __xfs_get_blocks+0x395/0x395
[] ? xfs_finish_ioend_sync+0x1a/0x1a
[] generic_file_direct_write+0xd7/0x147
[] xfs_file_dio_aio_write+0x1b9/0x1d1
[] ? wake_up_state+0xb/0xd
[] xfs_file_aio_write+0x16a/0x21d
[] ? do_futex+0xc0/0x988
[] do_sync_write+0xc7/0x10d
[] vfs_write+0xab/0x103
[] sys_pwrite64+0x5c/0x7d
[] system_call_fastpath+0x16/0x1b
Code: 00 48 8d 34 30 89 d9 4c 89 e7 e8 3a fe ff ff 85 c0 75 0b 44 89 e8 
49 01 84 24 90 00 00 00 41 5a 5b 41 5c 41 5d c9 c3 55 48 89 e5 ff 8f 2c 
01 00 00 0f 94 c0 84 c0 74 11 48 81 c7 90 00 00 00
RIP [] inode_dio_done+0x4/0x25
RSP
CR2: 000000000000012c
---[ end trace 79ce33ac2f7c10bd ]---


Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
