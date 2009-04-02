Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n32NnSl0171133 for <xfs@oss.sgi.com>; Thu, 2 Apr 2009 18:49:38 -0500
Received: from alopias.GreenKey.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13E9D1C91C4E
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2009 16:48:45 -0700 (PDT)
Received: from alopias.GreenKey.net (alopias.GreenKey.net [209.209.60.60]) by
	cuda.sgi.com with ESMTP id 9sTHfyG8xZcNayHU for
	<xfs@oss.sgi.com>; Thu, 02 Apr 2009 16:48:45 -0700 (PDT)
Date: Thu, 2 Apr 2009 16:48:44 -0700 (PDT)
From: Curtis Doty <Curtis@greenkey.net>
Subject: Re: why xfs_write() race with O_DIRECT only?
In-Reply-To: <49CD7912.6080508@GreenKey.net>
References: <49CD7912.6080508@GreenKey.net>
MIME-Version: 1.0
Message-Id: <20090402234844.AA78E6F064@alopias.GreenKey.net>
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
To: XFS <xfs@oss.sgi.com>

Mar 27 Curtis Doty said:

> I'm guessing this is the race fixed in 2.6.29.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=25051158
>
> But my app is running O_DIRECT and only calls pwrite(). Is there
> something I'm missing that explains the aio stuff etc.?
>
> ------------[ cut here ]------------
> WARNING: at fs/xfs/linux-2.6/xfs_lrw.c:724 xfs_write+0x364/0x694()
> Modules linked in: dm_mod sg usbhid usbkbd usbmouse qla2xxx
> firmware_class scsi_transport_fc bnx2 hpilo ipmi_si ipmi_msghandler
> container shpchp pci_hotplug rng_core iTCO_wdt iTCO_vendor_support
> thermal button processor rtc_cmos rtc_core rtc_lib ehci_hcd uhci_hcd usbcore
> Pid: 5789, comm: myServer Not tainted 2.6.28.9 #1
>

No luck with 2.6.29. It's still occuring.

------------[ cut here ]------------
WARNING: at fs/xfs/linux-2.6/xfs_lrw.c:715 xfs_write+0x34b/0x67e()
Hardware name: ProLiant DL360 G5
Modules linked in: dm_mod sg usbhid usbkbd usbmouse qla2xxx firmware_class 
scsi_transport_fc ipmi_si ipmi_msghandler hpilo bnx2 container thermal 
button processor ehci_hcd rtc_cmos rng_core rtc_core shpchp rtc_lib 
iTCO_wdt pci_hotplug iTCO_vendor_support uhci_hcd usbcore
Pid: 5681, comm: diskServer Not tainted 2.6.29 #1
Call Trace:
  [<c0124fed>] warn_slowpath+0x74/0x8a
  [<c015d61f>] ? __pagevec_release+0x18/0x21
  [<c015d8b4>] ? invalidate_inode_pages2_range+0x1c4/0x20c
  [<c021ec00>] ? __xfs_get_blocks+0x179/0x239
  [<c021e152>] ? xfs_end_io_direct+0x0/0x66
  [<c01570ff>] ? generic_file_direct_write+0xfe/0x1dc
  [<c0217de3>] ? xfs_trans_unlocked_item+0x2a/0x41
  [<c0224ce6>] xfs_write+0x34b/0x67e
  [<c011e27d>] ? default_wake_function+0xb/0xd
  [<c0119a5c>] ? __wake_up_common+0x2f/0x5a
  [<c013de20>] ? wake_futex+0x22/0x2f
  [<c02219bd>] xfs_file_aio_write+0x5b/0x63
  [<c0175bde>] do_sync_write+0xab/0xe6
  [<c01344d2>] ? autoremove_wake_function+0x0/0x33
  [<c0175b33>] ? do_sync_write+0x0/0xe6
  [<c017623b>] vfs_write+0x8c/0x108
  [<c01767f9>] sys_pwrite64+0x45/0x60
  [<c0102c41>] sysenter_do_call+0x12/0x21
  [<c0390000>] ? mxcsr_feature_mask_init+0xe/0x47
---[ end trace f75be9e7e7f9aa47 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
