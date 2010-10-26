Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9Q7qKpM054360 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 02:52:20 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B87AC1977B36
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 00:53:37 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id vCmeLe07Vd4A2AcY
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 00:53:37 -0700 (PDT)
Message-ID: <4CC688FE.7010206@profihost.ag>
Date: Tue, 26 Oct 2010 09:53:34 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>	<20101026092205.086c0d89@galadriel.home>	<4CC68249.7050409@profihost.ag>
	<20101026094111.48670eb7@galadriel.home>
In-Reply-To: <20101026094111.48670eb7@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

>> /dev/sdc3 on /sdc3 type xfs (rw,noatime,nodiratime,nobarrier,prjquota)
>> /sdc3/serverbackup on /serverbackup type none (rw,bind)
>> /sdc3/serverbackup_rootserver on /serverbackup_rootserver type none
>> (rw,bind)
>
> OK, looks fine to me. Aren't there any messages related to /dev/sdc in
> dmesg? Apparently it's a single drive, any IO errors? What's the smart
> status like?
No it is a Raid 5 (3Ware Controller). First Message in dmesg is 
(attention reverse order):
2010-10-26 02:07:42     [1217871.154330] Pid: 8345, comm: rsync Not 
tainted 2.6.32.22intel #1
2010-10-26 02:07:42     [1217871.178925] Call Trace:
2010-10-26 02:07:42     [1217871.202924] [] ? xfs_da_read_buf+0x24/0x29
2010-10-26 02:07:42     [1217871.226724] [] ? xfs_da_do_buf+0x557/0x620
2010-10-26 02:07:42     [1217871.249821] [] ? xfs_da_read_buf+0x24/0x29
2010-10-26 02:07:42     [1217871.272475] [] ? xfs_da_read_buf+0x24/0x29
2010-10-26 02:07:42     [1217871.294558] [] ? 
xfs_dir2_block_lookup_int+0x45/0x197
2010-10-26 02:07:42     [1217871.316206] [] ? 
xfs_dir2_block_lookup_int+0x45/0x197
2010-10-26 02:07:42     [1217871.337603] [] ? 
xfs_dir2_block_lookup+0x18/0xb0
2010-10-26 02:07:42     [1217871.358986] [] ? xfs_dir_lookup+0xd5/0x147
2010-10-26 02:07:42     [1217871.380585] [] ? xfs_lookup+0x47/0xa3
2010-10-26 02:07:42     [1217871.402313] [] ? xfs_vn_lookup+0x3c/0x7b
2010-10-26 02:07:42     [1217871.424465] [] ? do_lookup+0xd5/0x1b3
2010-10-26 02:07:42     [1217871.445750] [] ? __link_path_walk+0x8f5/0xda2
2010-10-26 02:07:42     [1217871.466323] [] ? sock_aio_write+0xd6/0xe1
2010-10-26 02:07:42     [1217871.487141] [] ? path_walk+0x66/0xcb
2010-10-26 02:07:42     [1217871.507783] [] ? do_path_lookup+0x20/0x41
2010-10-26 02:07:42     [1217871.528673] [] ? user_path_at+0x48/0x7f
2010-10-26 02:07:42     [1217871.549518] [] ? 
autoremove_wake_function+0x0/0x2e
2010-10-26 02:07:42     [1217871.569930] [] ? vfs_fstatat+0x2c/0x58
2010-10-26 02:07:42     [1217871.589714] [] ? _atomic_dec_and_lock+0x33/0x50
2010-10-26 02:07:42     [1217871.609072] [] ? sys_newlstat+0x11/0x30
2010-10-26 02:07:42     [1217871.627679] [] ? mntput_no_expire+0x23/0xdf
2010-10-26 02:07:42     [1217871.645558] [] ? filp_close+0x5b/0x62
2010-10-26 02:07:41     [1217870.507397] ffff8803104df000: 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 ................
2010-10-26 02:07:41     [1217870.530516] Filesystem "sdc3": XFS internal 
error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c. 
Caller 0xffffffff8117bdea
2010-10-26 02:07:41     [1217870.530518]
2010-10-26 02:07:41     [1217870.603393] Pid: 8345, comm: rsync Not 
tainted 2.6.32.22intel #1
2010-10-26 02:07:41     [1217870.628925] Call Trace:

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
