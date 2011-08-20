Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7KJcOfP171850 for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 14:38:25 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39A9A1377464
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 12:40:48 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id 1xJC7eZ3FVfX5mBX for <xfs@oss.sgi.com>;
	Sat, 20 Aug 2011 12:40:48 -0700 (PDT)
Date: Sat, 20 Aug 2011 15:38:21 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 3.0.1: xfs hang
Message-ID: <alpine.DEB.2.02.1108201536510.14176@p34.internal.lan>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

Forgot to remove 'delaylog' from my fstab on one of my machines, while rm 
-rf a large directory with many files:

[ 2880.313073] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2880.313147] rm              D 0000000100255dc1     0  2270   2253 0x00000000
[ 2880.313198]  ffff88012b4f9810 0000000000000086 ffff8800bd632010 0000000000004000
[ 2880.313276]  ffff88012b4f9810 ffff8800bd633fd8 ffff8800bd633fd8 0000000000000001
[ 2880.313352]  ffff88012b4bf790 ffff88012b4f9a78 0000000412eec110 00000008bd633a58
[ 2880.313428] Call Trace:
[ 2880.313467]  [<ffffffff810ceeb0>] ? mempool_alloc+0x60/0x140
[ 2880.313513]  [<ffffffff812d272e>] ? submit_bio+0x5e/0xe0
[ 2880.313557]  [<ffffffff815ded05>] ? schedule_timeout+0x1f5/0x250
[ 2880.313603]  [<ffffffff812ab174>] ? xfs_buf_rele+0x74/0x110
[ 2880.313645]  [<ffffffff815dfbd1>] ? __down+0x61/0xa0
[ 2880.313688]  [<ffffffff812abf73>] ? _xfs_buf_find+0x163/0x260
[ 2880.313733]  [<ffffffff81092666>] ? down+0x46/0x50
[ 2880.313775]  [<ffffffff812aa459>] ? xfs_buf_lock+0x59/0xc0
[ 2880.313817]  [<ffffffff812abf73>] ? _xfs_buf_find+0x163/0x260
[ 2880.313861]  [<ffffffff812ac0da>] ? xfs_buf_get+0x6a/0x1b0
[ 2880.313906]  [<ffffffff812ac244>] ? xfs_buf_read+0x24/0x110
[ 2880.313951]  [<ffffffff812a2366>] ? xfs_trans_read_buf+0x206/0x400
[ 2880.313999]  [<ffffffff8127577f>] ? xfs_da_do_buf+0x2af/0x770
[ 2880.314057]  [<ffffffff81117869>] ? dput+0x39/0x310
[ 2880.314100]  [<ffffffff81275cb4>] ? xfs_da_read_buf+0x24/0x30
[ 2880.314145]  [<ffffffff8127a5db>] ? xfs_dir2_block_getdents+0xab/0x220
[ 2880.314193]  [<ffffffff8127a5db>] ? xfs_dir2_block_getdents+0xab/0x220
[ 2880.314240]  [<ffffffff81113e50>] ? filldir64+0xe0/0xe0
[ 2880.314283]  [<ffffffff81113e50>] ? filldir64+0xe0/0xe0
[ 2880.314324]  [<ffffffff81113e50>] ? filldir64+0xe0/0xe0
[ 2880.314366]  [<ffffffff81278eea>] ? xfs_readdir+0xca/0x130
[ 2880.314410]  [<ffffffff81113e50>] ? filldir64+0xe0/0xe0
[ 2880.314452]  [<ffffffff812acfa4>] ? xfs_file_readdir+0x34/0x50
[ 2880.314497]  [<ffffffff811140c8>] ? vfs_readdir+0xb8/0xd0
[ 2880.314542]  [<ffffffff81114244>] ? sys_getdents+0x84/0xe0
[ 2880.314586]  [<ffffffff815e0cbb>] ? system_call_fastpath+0x16/0x1b

(will remove delaylog, (but FYI))

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
