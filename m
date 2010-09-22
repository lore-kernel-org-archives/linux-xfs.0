Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M7QDrf052755 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 02:26:13 -0500
Received: from pirx.askja.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EDC4904E6
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 00:27:06 -0700 (PDT)
Received: from pirx.askja.de (pirx.askja.de [83.137.103.148]) by cuda.sgi.com
	with ESMTP id QsSdOpdcyALBqH94 for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 00:27:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by pirx.askja.de (Postfix) with ESMTP id 41E583014B
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 09:26:55 +0200 (CEST)
Received: from pirx.askja.de ([127.0.0.1])
	by localhost (pirx.askja.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 9iJ6z7jCXL+U for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 09:26:53 +0200 (CEST)
Date: Wed, 22 Sep 2010 09:26:53 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: XFS internal error xfs_da_do_buf(2)
Message-ID: <20100922072653.GA23326@pirx.askja.de>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi,

we've a fileserver withe the following setup:

Debian Lenny AMD64, 2.6.32 bpo Kernel

Infortrend RAID with BBU -> DRBD -> LVM -> XFS

This system is running since beginning of August and replaced some
older hardware.

Last week xfs began to print some warnings to syslog. The day before a DRBD
verify ended without showing differences between the 2 cluster nodes.

I asked on #xfs and #drbd IRC about this.

#xfs
14:52:11 run xfs_repair over it as soon as you can
14:52:22 this looks a bit like a missing cache flush induced corruption
14:52:48 so check if you have your disk write cache properly disabled when using drbd

#drbd
16:48:14  you got that one backwards
16:52:09 "this looks a bit like a missing cache flush induced corruption"
[...]

So I ran xfs_repair -n on the fs an it found some problems, put 7 inodes in
lost+found (I stupidly rebooted too fast to save the xfs_repair output).

Since this reboot there were no more messages in syslog.

The Infortrend device has a BBU, but the option to used the drive caches was
enabled. So there was a possibility to lose data in case of an power outage.
I've now disabled that option. Given that and that there was no power outage
since August, what could be cause of the corruption? I'm not sure where to
start looking. Before going into production with this server I ran memtest.

This seems not to happen all the time, the server was running 5 weeks without
these messages. And there were some full backups running during this
time which read every file on the fs.


Any hints what to look for or what to do to notice this corruption as soon as possible?



Sep 13 12:30:30 VU0EM003 kernel: [2834063.439771] block drbd0: conn( Connected -> VerifyS ) 
Sep 13 12:30:30 VU0EM003 kernel: [2834063.439803] block drbd0: Starting Online Verify from sector 0
Sep 15 03:06:59 VU0EM003 kernel: [2972785.494729] block drbd0: Online verify  done (total 138989 sec; paused 0 sec; 33716 K/sec)
Sep 15 03:06:59 VU0EM003 kernel: [2972785.494794] block drbd0: conn( VerifyS -> Connected ) 

Sep 16 12:18:16 VU0EM003 kernel: [3092032.035881] ffff8803e65c8000: 49 4e 00 00 02 02 00 00 00 00 14 1b 00 00 04 26  IN.............&
Sep 16 12:18:16 VU0EM003 kernel: [3092032.035936] Filesystem "dm-2": XFS internal error xfs_da_do_buf(2) at line 2112 of file /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa02b0a52
Sep 16 12:18:16 VU0EM003 kernel: [3092032.035938] 
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036031] Pid: 1691, comm: smbd Not tainted 2.6.32-bpo.5-amd64 #1
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036059] Call Trace:
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036096]  [<ffffffffa02b0a52>] ? xfs_da_read_buf+0x24/0x29 [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036143]  [<ffffffffa02b0922>] ? xfs_da_do_buf+0x558/0x61e [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036179]  [<ffffffffa02b0a52>] ? xfs_da_read_buf+0x24/0x29 [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036209]  [<ffffffff810fabd8>] ? poll_freewait+0x3d/0x8a
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036243]  [<ffffffffa02b0a52>] ? xfs_da_read_buf+0x24/0x29 [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036279]  [<ffffffffa02b4126>] ? xfs_dir2_block_lookup_int+0x45/0x19f [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036331]  [<ffffffffa02b4126>] ? xfs_dir2_block_lookup_int+0x45/0x19f [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036382]  [<ffffffffa02b46c1>] ? xfs_dir2_block_lookup+0x18/0x9f [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036419]  [<ffffffffa02b33b8>] ? xfs_dir_lookup+0xd5/0x147 [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036455]  [<ffffffffa02d5800>] ? xfs_lookup+0x47/0xa3 [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036507]  [<ffffffffa02dd8a3>] ? xfs_vn_lookup+0x3c/0x7b [xfs]
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036536]  [<ffffffff810f5657>] ? do_lookup+0xd3/0x15d
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036562]  [<ffffffff810f6084>] ? __link_path_walk+0x5a5/0x6f5
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036590]  [<ffffffff810f6402>] ? path_walk+0x66/0xc9
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036624]  [<ffffffff810f786c>] ? do_path_lookup+0x20/0x77
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036651]  [<ffffffff810f8d4e>] ? user_path_at+0x48/0x79
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036679]  [<ffffffff810f110b>] ? cp_new_stat+0xe9/0xfc
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036713]  [<ffffffff81064ae6>] ? autoremove_wake_function+0x0/0x2e
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036742]  [<ffffffff810f12d2>] ? vfs_fstatat+0x2c/0x57
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036769]  [<ffffffff810f13c5>] ? sys_newstat+0x11/0x30
Sep 16 12:18:16 VU0EM003 kernel: [3092032.036797]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[some more lines]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.210909] ffff8803e65c8000: 49 4e 00 00 02 02 00 00 00 00 14 1b 00 00 04 26  IN.............&
Sep 19 03:10:32 VU0EM003 kernel: [3317932.210959] Filesystem "dm-2": XFS internal error xfs_da_do_buf(2) at line 2112 of file /tmp/buildd/linux-2.
6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa02b0a52
Sep 19 03:10:32 VU0EM003 kernel: [3317932.210960] 
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211054] Pid: 27834, comm: rsync Not tainted 2.6.32-bpo.5-amd64 #1
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211082] Call Trace:
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211120]  [<ffffffffa02b0a52>] ? xfs_da_read_buf+0x24/0x29 [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211159]  [<ffffffffa02b0922>] ? xfs_da_do_buf+0x558/0x61e [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211196]  [<ffffffffa02b0a52>] ? xfs_da_read_buf+0x24/0x29 [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211232]  [<ffffffffa02db4ca>] ? xfs_dir_open+0x0/0x55 [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211267]  [<ffffffffa02b0a19>] ? xfs_da_reada_buf+0x31/0x46 [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211298]  [<ffffffff810ec6cd>] ? __dentry_open+0x1c4/0x2bf
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211326]  [<ffffffff810fa464>] ? filldir+0x0/0xb7
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211359]  [<ffffffffa02b0a52>] ? xfs_da_read_buf+0x24/0x29 [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211395]  [<ffffffffa02b4389>] ? xfs_dir2_block_getdents+0x66/0x1ab [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211446]  [<ffffffffa02b4389>] ? xfs_dir2_block_getdents+0x66/0x1ab [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211490]  [<ffffffff810f110b>] ? cp_new_stat+0xe9/0xfc
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211517]  [<ffffffff810fa464>] ? filldir+0x0/0xb7
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211543]  [<ffffffff810fa464>] ? filldir+0x0/0xb7
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211577]  [<ffffffffa02b319e>] ? xfs_readdir+0x8b/0xb0 [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211604]  [<ffffffff810fa464>] ? filldir+0x0/0xb7
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211637]  [<ffffffffa02db553>] ? xfs_file_readdir+0x34/0x43 [xfs]
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211666]  [<ffffffff810fa634>] ? vfs_readdir+0x75/0xa7
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211693]  [<ffffffff810fa79e>] ? sys_getdents+0x7a/0xc7
Sep 19 03:10:32 VU0EM003 kernel: [3317932.211721]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
