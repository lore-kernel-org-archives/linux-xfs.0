Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41C7D7F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 02:19:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A1B330406A
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 00:19:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O9THQ1XtpvjsZGOA for
	<xfs@oss.sgi.com>; Thu, 31 Jan 2013 00:19:27 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0V8JQb4016389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 03:19:27 -0500
Received: from dhcp-1-104.brq.redhat.com (dhcp-1-104.brq.redhat.com
	[10.34.1.104])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r0V8JN8h002573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 03:19:26 -0500
Date: Thu, 31 Jan 2013 09:19:23 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Xfs fails in xfstests 013
Message-ID: <alpine.LFD.2.00.1301310910080.14328@dhcp-1-104.brq.redhat.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi.

I've just run xfstest 013 on xfs and it fails with this backtrace


Jan 31 03:09:07 rhel6_vm1 kernel: ffff88020b6d1000: 78 78 78 78 78 78 78 78 78 78 2f 78 78 78 78 78  xxxxxxxxxx/xxxxx
Jan 31 03:09:07 rhel6_vm1 kernel: XFS (sda): Internal error xfs_bmbt_verify at line 747 of file fs/xfs/xfs_bmap_btree.c.  Caller 0xffffffffa025486e
Jan 31 03:09:07 rhel6_vm1 kernel:
Jan 31 03:09:07 rhel6_vm1 kernel: Pid: 8909, comm: xfsaild/sda Tainted: GF            3.8.0-rc5-orig+ #8
Jan 31 03:09:07 rhel6_vm1 kernel: Call Trace:
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa022877f>] xfs_error_report+0x3f/0x50 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa025486e>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa02287ee>] xfs_corruption_error+0x5e/0x90 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa0254710>] xfs_bmbt_verify+0x80/0x1d0 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa025486e>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa025486e>] xfs_bmbt_write_verify+0xe/0x10 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa02269a5>] _xfs_buf_ioapply+0x65/0x150 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffff8108d170>] ? try_to_wake_up+0x2b0/0x2b0
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa02270a5>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa0226fef>] xfs_buf_iorequest+0x4f/0xa0 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa02270a5>] xfs_bdstrat_cb+0x65/0xd0 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa0227218>] __xfs_buf_delwri_submit+0x108/0x200 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa02273c0>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa02273c0>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa0282376>] xfsaild_push+0x1b6/0x520 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa0282778>] xfsaild+0x98/0x130 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffffa02826e0>] ? xfsaild_push+0x520/0x520 [xfs]
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffff8107968e>] kthread+0xce/0xe0
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffff810795c0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffff8155cdec>] ret_from_fork+0x7c/0xb0
Jan 31 03:09:07 rhel6_vm1 kernel: [<ffffffff810795c0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 31 03:09:07 rhel6_vm1 kernel: XFS (sda): Corruption detected. Unmount and run xfs_repair
Jan 31 03:09:07 rhel6_vm1 kernel: XFS (sda): xfs_do_force_shutdown(0x8) called from line 1358 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffffa0226a85
Jan 31 03:09:07 rhel6_vm1 kernel: XFS (sda): Corruption of in-memory data detected.  Shutting down filesystem
Jan 31 03:09:07 rhel6_vm1 kernel: XFS (sda): Please umount the filesystem and rectify the problem(s)
Jan 31 03:09:07 rhel6_vm1 kernel: XFS (sda): xfs_log_force: error 5 returned.


I can reproduce it every time with xfstest 013 on 3.8.0-rc5.

-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
