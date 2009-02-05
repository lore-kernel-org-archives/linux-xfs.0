Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n15EpWFP219871 for <xfs@oss.sgi.com>; Thu, 5 Feb 2009 08:51:34 -0600
Received: from fk-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 792CBED0EE
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 06:50:52 -0800 (PST)
Received: from fk-out-0910.google.com (fk-out-0910.google.com
	[209.85.128.186]) by cuda.sgi.com with ESMTP id
	BWxVC7Bs3XjF9n16 for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2009 06:50:52 -0800 (PST)
Received: by fk-out-0910.google.com with SMTP id e30so306350fke.4
	for <xfs@oss.sgi.com>; Thu, 05 Feb 2009 06:50:52 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Feb 2009 14:43:29 +0000
Message-ID: <884979c90902050643m78d2e0dbt85aa7f4369e243ef@mail.gmail.com>
Subject: Does XFS support the sync mount option?
From: Ewan Chalmers <ewan.chalmers@gmail.com>
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

I am interested to know whether XFS supports the sync mount option.

I am using XFS on an external USB disk and automounting using the
ubuntu/debian usbmount package
(http://packages.ubuntu.com/intrepid/usbmount). The disk is connected
to a headless server. I would like to be able to safely switch the
disk on/off on demand without first logging in to the box to
sync/unmount. I believe the sync option is essential to this use case.
Using usbmount, it appears to work correctly, but the output to syslog
makes me wonder.

The default configuration for usbmount includes

FILESYSTEMS="ext2 ext3"
MOUNTOPTIONS="sync,noexec,nodev,noatime"

I have added xfs to the FILESYSTEMS list.

On switching off the disk, I see the following output in syslog

kernel: [1034259.923629] usb 1-2: USB disconnect, address 26
kernel: [1034259.936251] xfs_force_shutdown(sdb1,0x1) called from line
420 of file /build/buildd/linux-2.6.27/fs/xfs/xfs_rw.c.  Return
address = 0xe0a9ddb4
kernel: [1034259.936334] Filesystem "sdb1": I/O Error Detected.
Shutting down filesystem: sdb1
kernel: [1034259.936404] Please umount the filesystem, and rectify the
problem(s)
kernel: [1034259.949818] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034259.949851] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034259.949890] xfs_force_shutdown(sdb1,0x1) called from line
420 of file /build/buildd/linux-2.6.27/fs/xfs/xfs_rw.c.  Return
address = 0xe0a9ddb4
kernel: [1034259.968157] Filesystem "sdb1": xfs_log_force: error 5 returned.
usbmount[16307]: executing command: umount -l /media/usb0
kernel: [1034260.050924] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.057086] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.061208] xfs_force_shutdown(sdb1,0x1) called from line
420 of file /build/buildd/linux-2.6.27/fs/xfs/xfs_rw.c.  Return
address = 0xe0a9ddb4
kernel: [1034260.069650] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.073675] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.077672] xfs_force_shutdown(sdb1,0x1) called from line
420 of file /build/buildd/linux-2.6.27/fs/xfs/xfs_rw.c.  Return
address = 0xe0a9ddb4
usbmount[16307]: executing command: run-parts /etc/usbmount/umount.d
kernel: [1034260.084706] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.084735] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.084820] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.084864] Filesystem "sdb1": xfs_log_force: error 5 returned.
kernel: [1034260.084891] Filesystem "sdb1": xfs_log_force: error 5 returned.

But the disk remounts cleanly when it is switched back on.

kernel: [1034394.920087] usb 1-2: new high speed USB device using
ehci_hcd and address 27
kernel: [1034395.064826] usb 1-2: configuration #1 chosen from 1 choice
kernel: [1034395.078845] scsi25 : SCSI emulation for USB Mass Storage devices
kernel: [1034395.085992] usb-storage: device found at 27
kernel: [1034395.086033] usb-storage: waiting for device to settle
before scanning
kernel: [1034400.084595] usb-storage: device scan complete
kernel: [1034400.087474] scsi 25:0:0:0: Direct-Access     WDC WD10
EADS-00L5B1      0041 PQ: 0 ANSI: 0
kernel: [1034400.091636] sd 25:0:0:0: [sdb] 1953525168 512-byte
hardware sectors (1000205 MB)
kernel: [1034400.094271] sd 25:0:0:0: [sdb] Write Protect is off
kernel: [1034400.094309] sd 25:0:0:0: [sdb] Mode Sense: 03 00 00 00
kernel: [1034400.094328] sd 25:0:0:0: [sdb] Assuming drive cache: write through
kernel: [1034400.104985] sd 25:0:0:0: [sdb] 1953525168 512-byte
hardware sectors (1000205 MB)
kernel: [1034400.113058] sd 25:0:0:0: [sdb] Write Protect is off
kernel: [1034400.113094] sd 25:0:0:0: [sdb] Mode Sense: 03 00 00 00
kernel: [1034400.113114] sd 25:0:0:0: [sdb] Assuming drive cache: write through
kernel: [1034400.120193]  sdb: sdb1
kernel: [1034400.137434] sd 25:0:0:0: [sdb] Attached SCSI disk
kernel: [1034400.137980] sd 25:0:0:0: Attached scsi generic sg1 type 0
usbmount[16483]: executing command: mount -txfs
-osync,noexec,nodev,noatime /dev/sdb1 /media/usb0
kernel: [1034401.228110] XFS mounting filesystem sdb1
kernel: [1034401.710070] Ending clean XFS mount for filesystem: sdb1
usbmount[16483]: executing command: run-parts /etc/usbmount/mount.d

I would be interested to know whether it is reasonable to use XFS in
the way I have outlined.

Thanks,
Ewan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
