Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2S1BmKK023836 for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 20:12:04 -0500
Received: from alopias.GreenKey.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEB8613D6241
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 18:11:31 -0700 (PDT)
Received: from alopias.GreenKey.net (alopias.GreenKey.net [209.209.60.60]) by
	cuda.sgi.com with ESMTP id QTSrw8AsFo17USC2 for
	<xfs@oss.sgi.com>; Fri, 27 Mar 2009 18:11:31 -0700 (PDT)
Received: from [10.1.1.124] (unknown [209.209.31.8])
	(Authenticated sender: curtis)
	by alopias.GreenKey.net (Postfix) with ESMTP id 7242F6F05C
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 18:10:58 -0700 (PDT)
Message-ID: <49CD7912.6080508@GreenKey.net>
Date: Fri, 27 Mar 2009 18:10:42 -0700
From: Curtis Doty <Curtis@greenkey.net>
MIME-Version: 1.0
Subject: why xfs_write() race with O_DIRECT only?
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
To: XFS <xfs@oss.sgi.com>

I'm guessing this is the race fixed in 2.6.29.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=25051158

But my app is running O_DIRECT and only calls pwrite(). Is there
something I'm missing that explains the aio stuff etc.?

../C

------------[ cut here ]------------
WARNING: at fs/xfs/linux-2.6/xfs_lrw.c:724 xfs_write+0x364/0x694()
Modules linked in: dm_mod sg usbhid usbkbd usbmouse qla2xxx
firmware_class scsi_transport_fc bnx2 hpilo ipmi_si ipmi_msghandler
container shpchp pci_hotplug rng_core iTCO_wdt iTCO_vendor_support
thermal button processor rtc_cmos rtc_core rtc_lib ehci_hcd uhci_hcd usbcore
Pid: 5789, comm: myServer Not tainted 2.6.28.9 #1
Call Trace:
 [<c0122d30>] warn_on_slowpath+0x41/0x5b
 [<c014f27b>] ? mempool_alloc+0x21/0xbc
 [<c0217d2c>] ? xfs_vm_direct_IO+0x90/0xb4
 [<c021800f>] ? xfs_get_blocks_direct+0x0/0x14
 [<c021754b>] ? xfs_end_io_direct+0x0/0x5c
 [<c014dde5>] ? generic_file_direct_write+0x184/0x1dc
 [<c0210409>] ? xfs_trans_unlocked_item+0x28/0x3e
 [<c021e034>] xfs_write+0x364/0x694
 [<c0107a21>] ? read_tsc+0x9/0x26
 [<c0136c67>] ? getnstimeofday+0x54/0xe4
 [<c021ae6b>] xfs_file_aio_write+0x50/0x58
 [<c016ba9d>] do_sync_write+0xab/0xe6
 [<c01322be>] ? autoremove_wake_function+0x0/0x33
 [<c03874b8>] ? schedule+0x737/0x785
 [<c0107a21>] ? read_tsc+0x9/0x26
 [<c016b9f2>] ? do_sync_write+0x0/0xe6
 [<c016c177>] vfs_write+0x8c/0x108
 [<c016c6a4>] sys_pwrite64+0x45/0x60
 [<c0102be5>] sysenter_do_call+0x12/0x21
 [<c0380000>] ? hpwdt_init_one+0x103/0x38d
---[ end trace 3985be2a3d46f5ef ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
