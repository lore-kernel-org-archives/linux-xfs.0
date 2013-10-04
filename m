Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 240937F5F
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 02:19:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98BDEAC006
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 00:19:11 -0700 (PDT)
Received: from moltke.seatribe.se (moltke.seatribe.se [178.63.100.209]) by
	cuda.sgi.com with ESMTP id WHTHgP911cOCLjNq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Oct 2013 00:19:09 -0700 (PDT)
Received: from [2002:5c20:ff61::1] (helo=nerv.dolda2000.com)
	by moltke.seatribe.se with esmtp (Exim 4.72)
	(envelope-from <fredrik@dolda2000.com>) id 1VRzfH-0000qA-4n
	for xfs@oss.sgi.com; Fri, 04 Oct 2013 09:19:07 +0200
Received: from [2002:5c20:ff61:200:ca60:ff:fe16:97ac]
	([IPv6:2002:5c20:ff61:200:ca60:ff:fe16:97ac]) (authenticated bits=0)
	by nerv.dolda2000.com (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r947J6wD028773
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 4 Oct 2013 09:19:06 +0200
Date: Fri, 4 Oct 2013 09:19:06 +0200 (CEST)
From: Fredrik Tolf <fredrik@dolda2000.com>
Subject: Corruption errors with growfs
Message-ID: <alpine.DEB.2.10.1310040905380.3223@shack.dolda2000.com>
MIME-Version: 1.0
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

Dear list,

I recently consolidated two filesystems that have previously been 
separate; I'll refer to them below as /home and /home/pub (since that's 
what they're actually called).

When I first did so, I needed to grow /home quite a bit to accomodate the 
files in /home/pub. This is on LVM, so I extended the LV quite a bit 
(from about 550 GB to about 3.5 TB), and tried to grow the filesystem. At 
this point I encountered an error about corruption, prompting me to 
unmount the filesystem and run xfs_repair on it. I did so, it completed 
successfully and retained the filesystem at the size it was supposed to be 
grown to, so I ascribed the errors to some latent corruption by some older 
kernel version or something and went on with my life.

However, today I tried to grow the filesystem by another 500 GB, 
encountering again a very similar error. Clearly, this couldn't just be 
left-over corruption from some earlier kernel bug since I'm still using 
the exact same kernel. What's worse, however, is that xfs_repair restored 
the filesystem to its size prior to running growfs, so it seems I can't 
grow the filesystem and am stuck at its current size.

Does someone know what is happening, and what I can do to fix it?

The kernel I'm running is vanilla Linux 3.10.5, and I'm using xfsprogs 
3.1.4 (standard Debian Squeeze version). I unfortunately lost the original 
error I got from growfs since I had to close that terminal to unmount the 
filesystem (and I didn't think of copying it), but this is in the dmesg, 
and probably more useful anyway:

[205909.076160] ffff88002e8f6200: 58 46 53 42 00 00 10 00 00 00 00 00 48 c0 00 00  XFSB........H...
[205909.085110] ffff88002e8f6210: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[205909.093986] ffff88002e8f6220: f6 18 71 30 51 8c 4a 63 a5 86 cc e2 91 35 16 f3  ..q0Q.Jc.....5..
[205909.104116] ffff88002e8f6230: 00 00 00 00 04 00 00 04 00 00 00 00 00 00 00 80  ................
[205909.113001] XFS (dm-1): Internal error xfs_sb_read_verify at line 730 of file fs/xfs/xfs_mount.c.  Caller 0xffffffffa02471da
[205909.113001]
[205909.125884] CPU: 1 PID: 303 Comm: kworker/1:1H Not tainted 3.10.5 #1
[205909.136336] Hardware name:    /M57SLI-S4, BIOS FE 11/22/2007
[205909.138721] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[205909.146918]  ffffffff8138be52 ffff88003fc92dc0 ffffffffa0248fb5 ffffffffa02471da
[205909.159978]  ffffffff000002da ffff880037b36360 ffff8800314a3e00 0000000000000075
[205909.168660]  ffff880037cce000 ffff88002e8f6200 ffffffffa028be6d ffffffffa02471da
[205909.176469] Call Trace:
[205909.179155]  [<ffffffff8138be52>] ? dump_stack+0x10/0x1e
[205909.184593]  [<ffffffffa0248fb5>] ? xfs_corruption_error+0x54/0x6f [xfs]
[205909.191397]  [<ffffffffa02471da>] ? xfs_buf_iodone_work+0x40/0x77 [xfs]
[205909.198177]  [<ffffffffa028be6d>] ? xfs_sb_read_verify+0xa9/0xc8 [xfs]
[205909.204812]  [<ffffffffa02471da>] ? xfs_buf_iodone_work+0x40/0x77 [xfs]
[205909.211540]  [<ffffffff8138d038>] ? __schedule+0x514/0x541
[205909.217148]  [<ffffffffa02471da>] ? xfs_buf_iodone_work+0x40/0x77 [xfs]
[205909.223857]  [<ffffffff8104aaf2>] ? process_one_work+0x1f9/0x2fc
[205909.229974]  [<ffffffff8104ad52>] ? worker_thread+0x15d/0x268
[205909.235827]  [<ffffffff8104abf5>] ? process_one_work+0x2fc/0x2fc
[205909.241977]  [<ffffffff8104ea6b>] ? kthread_freezable_should_stop+0x56/0x56
[205909.249037]  [<ffffffff8104abf5>] ? process_one_work+0x2fc/0x2fc
[205909.255153]  [<ffffffff8104eb16>] ? kthread+0xab/0xb3
[205909.260311]  [<ffffffff8104ea6b>] ? kthread_freezable_should_stop+0x56/0x56
[205909.267380]  [<ffffffff8139336c>] ? ret_from_fork+0x7c/0xb0
[205909.273070]  [<ffffffff8104ea6b>] ? kthread_freezable_should_stop+0x56/0x56
[205909.280126] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[205909.286853] XFS (dm-1): metadata I/O error: block 0x32000000 ("xfs_trans_read_buf_map") error 117 numblks 1
[205909.296703] XFS (dm-1): error 117 reading secondary superblock for ag 16

This is what xfs_info has to say about the filesystem:

meta-data=/dev/mapper/ravol-home isize=256    agcount=187, agsize=6553600 blks
          =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=1220542464, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

Thanks for reading!

--
Fredrik Tolf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
