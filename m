Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o11HTJQk123353
	for <linux-xfs@oss.sgi.com>; Mon, 1 Feb 2010 11:29:20 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E973C1520B5B
	for <linux-xfs@oss.sgi.com>; Mon,  1 Feb 2010 09:30:25 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id cHf2Cfxj10UhFCHm for <linux-xfs@oss.sgi.com>;
	Mon, 01 Feb 2010 09:30:25 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Nc06O-0004nq-AT
	for linux-xfs@oss.sgi.com; Mon, 01 Feb 2010 18:30:20 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 01 Feb 2010 18:30:20 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 01 Feb 2010 18:30:20 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: Filesystem corrupted: "Sorry, could not find valid secondary
	superblock"
Date: Mon, 01 Feb 2010 12:29:55 -0500
Message-ID: <hk732i$8vt$1@ger.gmane.org>
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

Hello,

Unfortunately I am still having big problems with this filesystem. I can
mount it OK but there are problems reading files:

du: cannot access `./DCIS 2 AB': Structure needs cleaning

The previous goes together with a lot of these in dmesg:

[  431.976517] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ................
[  431.988072] Filesystem "sda1": XFS internal error xfs_da_do_buf(2) at
line 2085 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa016749f
[  431.993185] Pid: 4246, comm: du Not tainted 2.6.26-2-amd64 #1
[  431.998308]
[  431.998309] Call Trace:
[  432.010348]  [<ffffffffa016749f>] :xfs:xfs_da_read_buf+0x24/0x29
[  432.015530]  [<ffffffffa016734d>] :xfs:xfs_da_do_buf+0x54e/0x636
[  432.020696]  [<ffffffffa016749f>] :xfs:xfs_da_read_buf+0x24/0x29
[  432.025860]  [<ffffffffa019580c>] :xfs:_xfs_buf_lookup_pages+0x298/0x2ca
[  432.031974]  [<ffffffffa016749f>] :xfs:xfs_da_read_buf+0x24/0x29
[  432.037173]  [<ffffffffa016c66f>] :xfs:xfs_dir2_leaf_getdents+0x381/0x61a
[  432.042391]  [<ffffffffa016c66f>] :xfs:xfs_dir2_leaf_getdents+0x381/0x61a
[  432.047617]  [<ffffffffa0196f68>] :xfs:xfs_hack_filldir+0x0/0x5b
[  432.052673]  [<ffffffffa0196f68>] :xfs:xfs_hack_filldir+0x0/0x5b
[  432.057517]  [<ffffffffa01695d8>] :xfs:xfs_readdir+0xa6/0xb5
[  432.062197]  [<ffffffffa0196f1b>] :xfs:xfs_file_readdir+0xff/0x14c
[  432.066835]  [<ffffffff802a6bec>] filldir+0x0/0xb7
[  432.071987]  [<ffffffff802a6bec>] filldir+0x0/0xb7
[  432.076557]  [<ffffffff802a6d18>] vfs_readdir+0x75/0xa7
[  432.081137]  [<ffffffff802a6f68>] sys_getdents+0x75/0xbd
[  432.085716]  [<ffffffff802a65da>] sys_fcntl+0x2eb/0x2f7
[  432.090267]  [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f

The server has 2GB of RAM and 4GB of swap. I have tried several times to
xfs_repair but it always fails because of memory problems, even if I use
'xfs_repair -m1500 /dev/sda1' to limit the memory usage.
xfs_repair produces an awful lot of output. I could of course send it
but it's 130k lines long. Here is what it is currently printing, I have
started "xfs_repair -t15 -m500 /dev/sda1" again a few minutes ago. It is
currently in Phase 3.

bp=(bno 1211109312, len 8192 bytes) key=(bno 1211109312, len 4096 bytes)
429f7950: Badness in key lookup (length)
bp=(bno 1211109328, len 8192 bytes) key=(bno 1211109328, len 4096 bytes)
bad directory block magic # 0x2f49cdbc in block 2 for directory inode
2952790372
corrupt block 2 in directory inode 2952790372
        will junk block
bad directory block magic # 0 in block 5 for directory inode 2952790372
corrupt block 5 in directory inode 2952790372
        will junk block
no . entry for directory 2952790372
no .. entry for directory 2952790372
bad directory block magic # 0 in block 0 for directory inode 2952790373
corrupt block 0 in directory inode 2952790373
        will junk block
bad directory block magic # 0 in block 1 for directory inode 2952790373
corrupt block 1 in directory inode 2952790373
        will junk block
doubling cache size to 66768
doubling cache size to 133536
doubling cache size to 267072
doubling cache size to 534144
doubling cache size to 1068288


Any ideas on how I could repair this filesystem?

Thanks a lot!

-- 
Nico

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
