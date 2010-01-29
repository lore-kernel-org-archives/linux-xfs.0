Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0TJvLvJ150425
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 13:57:24 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E66B136404B
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 11:58:25 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id IGKeswRBYjWYLIOr for <linux-xfs@oss.sgi.com>;
	Fri, 29 Jan 2010 11:58:25 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Nawz1-0005eu-Il
	for linux-xfs@oss.sgi.com; Fri, 29 Jan 2010 20:58:23 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 20:58:23 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 20:58:23 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: Filesystem corrupted: "Sorry, could not find valid secondary
	superblock"
Date: Fri, 29 Jan 2010 14:58:02 -0500
Message-ID: <hjvek9$jas$1@ger.gmane.org>
References: <hjus58$6oi$1@ger.gmane.org>	<4B63010D.1080608@sandeen.net>	<hjv12n$r2o$1@ger.gmane.org>	<4B631704.8080902@sandeen.net>	<hjv6l0$j2g$1@ger.gmane.org>
	<4B6325E2.2040703@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4B6325E2.2040703@sandeen.net>
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
To: linux-xfs@oss.sgi.com

Hi Eric,

Thanks so much for your help,

On 1/29/10 1:16 PM, Eric Sandeen wrote:
>> # mount/ dev/sda1 mount: Structure needs cleaning
> 
> dmesg at this point would be good

This particular command does not produce any output in dmesg, but
previous commands did, especially when I mounted the filesystem with
no-recovery.

[205411.967412] XFS: log mount/recovery failed: error 117
[205411.972696] XFS: log mount failed
[205469.205586] Mounting filesystem "sda1" in no-recovery mode.
Filesystem will be inconsistent.
[205483.946417] XFS mounting filesystem sda1
[205484.136159] Starting XFS recovery on filesystem: sda1 (logdev: internal)
[205484.488176] Filesystem "sda1": xfs_inode_recover: Bad inode magic
number, dino ptr = 0xffff81004d109f00, dino bp = 0xffff81002e85be80, ino
= 2954558655
[205484.493476] Filesystem "sda1": XFS internal error
xlog_recover_do_inode_trans(1) at line 2326 of file
fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa018553a
[205484.498909] Pid: 27800, comm: mount Not tainted 2.6.26-2-amd64 #1
[205484.506907]
[205484.506908] Call Trace:
[205484.516417]  [<ffffffffa018553a>] :xfs:xlog_recover_do_trans+0x64/0xfd
[205484.523162]  [<ffffffffa0184e33>]
:xfs:xlog_recover_do_inode_trans+0x23c/0x766
[205484.528729]  [<ffffffffa01966b0>] :xfs:xfs_buf_iostart+0x29/0x86
[205484.534304]  [<ffffffffa018553a>] :xfs:xlog_recover_do_trans+0x64/0xfd
[205484.539907]  [<ffffffffa0185605>]
:xfs:xlog_recover_commit_trans+0x32/0x4b
[205484.545489]  [<ffffffffa018576b>]
:xfs:xlog_recover_process_data+0x14d/0x1c9
[205484.551117]  [<ffffffffa0185a2f>] :xfs:xlog_do_recovery_pass+0x248/0x661
[205484.556736]  [<ffffffffa0185e9a>] :xfs:xlog_do_log_recovery+0x52/0x75
[205484.564000]  [<ffffffffa0185ec9>] :xfs:xlog_do_recover+0xc/0xf3
[205484.568026]  [<ffffffffa018602a>] :xfs:xlog_recover+0x7a/0x84
[205484.573631]  [<ffffffffa0180460>] :xfs:xfs_log_mount+0xb1/0x105
[205484.579270]  [<ffffffffa01880dc>] :xfs:xfs_mountfs+0x25a/0x5ac
[205484.584866]  [<ffffffffa0193311>] :xfs:kmem_alloc+0x60/0xc4
[205484.590483]  [<ffffffffa01933d1>] :xfs:kmem_zalloc+0x9/0x21
[205484.596066]  [<ffffffffa018deb4>] :xfs:xfs_mount+0x29b/0x347
[205484.601625]  [<ffffffffa019c3ea>] :xfs:xfs_fs_fill_super+0x0/0x1ee
[205484.607231]  [<ffffffffa019c49f>] :xfs:xfs_fs_fill_super+0xb5/0x1ee
[205484.612727]  [<ffffffff8029d290>] get_sb_bdev+0xf8/0x145
[205484.618174]  [<ffffffff8029ccb4>] vfs_kern_mount+0x93/0x11b
[205484.623745]  [<ffffffff8029cd8f>] do_kern_mount+0x43/0xe3
[205484.629183]  [<ffffffff802b1805>] do_new_mount+0x5b/0x95
[205484.634627]  [<ffffffff802b19fc>] do_mount+0x1bd/0x1e7
[205484.639990]  [<ffffffff80276909>] __alloc_pages_internal+0xd6/0x3bf
[205484.645219]  [<ffffffff802b1ab0>] sys_mount+0x8a/0xce
[205484.650275]  [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f

>> Is the use of -L the only way to go? I wonder, since it will cause
>> data loss...
> 
> if you can't mount it, yeah

I'm going ahead and doing that.
There is an awful lot of output but at least it's doing something.

>> Also here is the output of xfs_db:
>> 
>> # xfs_db /dev/sda1 xfs_db> sb 0 xfs_db> p magicnum = 0x58465342
> 
> ok, odd; you got:
> 
>>> # xfs_repair /dev/sda Phase 1 - find and verify superblock... bad
>>> primary superblock - bad magic number !!!
> 
> but this magic number is fine ...

Yes, I figured that I had used /dev/sda instead of /dev/sda1, my bad :(
So now the magic number is ok...

-- 
Nico

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
