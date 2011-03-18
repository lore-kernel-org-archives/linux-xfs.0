Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2IF5klJ040591 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:05:51 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4E161598F84
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 08:08:41 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id VrpApLzdyP5rJ4Cg for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 08:08:41 -0700 (PDT)
Date: Fri, 18 Mar 2011 11:08:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Message-ID: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
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
To: linux-usb@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>

Hi,

I can write to just about the entire USB stick, with no errors:

atom:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             5.8G  1.5G  4.3G  26% /
tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
udev                   10M  140K  9.9M   2% /dev
tmpfs                 2.0G     0  2.0G   0% /dev/shm
atom:~# cd /
atom:/# ls
bin   cdrom  etc   lib    media  nfs  proc  sbin     srv  tmp  var
boot  dev    home  lib64  mnt    opt  root  selinux  sys  usr
atom:/# dd if=/dev/zero of=bigfile bs=1M count=4000
4000+0 records in
4000+0 records out
4194304000 bytes (4.2 GB) copied, 135.536 s, 30.9 MB/s
atom:/# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             5.8G  5.4G  350M  95% /
tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
udev                   10M  140K  9.9M   2% /dev
tmpfs                 2.0G     0  2.0G   0% /dev/shm
atom:/# rm bigfile

However, after some amount of time, the errors occur below, is this USB
stick failing?  Since it has no SMART, is there any other way to verify
the 'health' of a USB stick?

Mar 18 07:55:12 atom [   10.034310] e1000e 0000:03:00.0: eth1: 10/100 speed: disabling TSO

[ .. no errors .. ]

Mar 18 08:32:44 atom [ 2261.883848] usb 1-1: USB disconnect, address 2
Mar 18 08:32:44 atom [ 2261.884465] Buffer I/O error on device sda2, logical block 1317256
Mar 18 08:32:44 atom [ 2261.884525] lost page write due to I/O error on sda2
Mar 18 08:32:44 atom [ 2261.884713] Buffer I/O error on device sda2, logical block 1307821
Mar 18 08:32:44 atom [ 2261.884764] lost page write due to I/O error on sda2
Mar 18 08:33:06 atom [ 2283.744165] sd 6:0:0:0: Device offlined - not ready after error recovery
Mar 18 08:33:06 atom [ 2283.744264] sd 6:0:0:0: [sda] Unhandled error code
Mar 18 08:33:06 atom [ 2283.744298] sd 6:0:0:0: [sda]
Mar 18 08:33:06 atom Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Mar 18 08:33:06 atom [ 2283.744356] sd 6:0:0:0: [sda] CDB:
Mar 18 08:33:06 atom Write(10)
Mar 18 08:33:06 atom :
Mar 18 08:33:06 atom  2a
Mar 18 08:33:06 atom  00
Mar 18 08:33:06 atom  00
Mar 18 08:33:06 atom  99
Mar 18 08:33:06 atom  0f
Mar 18 08:33:06 atom  7e
Mar 18 08:33:06 atom  00
Mar 18 08:33:06 atom  00
Mar 18 08:33:06 atom  02
Mar 18 08:33:06 atom  00
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.744450] end_request: I/O error, dev sda, sector 10030974
Mar 18 08:33:06 atom [ 2283.744544] I/O error in filesystem ("sda2") meta-data dev sda2 block 0x5c05c5       ("xlog_iodone") error 5 buf count 1024
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.744591] xfs_force_shutdown(sda2,0x2) called from line 893 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff811c9834
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.744669] Filesystem sda2: Log I/O Error Detected.  Shutting down filesystem: sda2
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.744732] Please umount the filesystem, and rectify the problem(s)
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.744779] Buffer I/O error on device sda2, logical block 1318284
Mar 18 08:33:06 atom [ 2283.744831] lost page write due to I/O error on sda2
Mar 18 08:33:06 atom [ 2283.745659] Filesystem sda2: xfs_log_force: error 5 returned.
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.746109] Filesystem sda2: xfs_log_force: error 5 returned.
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.746168] xfs_force_shutdown(sda2,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xffffffff811e1e1c
Mar 18 08:33:06 atom
Mar 18 08:33:06 atom [ 2283.963059] usb 1-1: new high speed USB device using ehci_hcd and address 4
Mar 18 08:33:06 atom [ 2284.080647] usb 1-1: New USB device found, idVendor=0325, idProduct=ac02
Mar 18 08:33:06 atom [ 2284.080707] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar 18 08:33:06 atom [ 2284.080752] usb 1-1: Product: R2_TURBO
Mar 18 08:33:06 atom [ 2284.080794] usb 1-1: Manufacturer: OCZ Technology
Mar 18 08:33:06 atom [ 2284.080831] usb 1-1: SerialNumber: (removed)
Mar 18 08:33:06 atom [ 2284.082082] scsi7 : usb-storage 1-1:1.0
Mar 18 08:33:07 atom [ 2285.083417] scsi 7:0:0:0: Direct-Access     OCZ      R2_TURBO         1100 PQ: 0 ANSI: 0 CCS
Mar 18 08:33:07 atom [ 2285.085539] sd 7:0:0:0: [sdb] 16056320 512-byte logical blocks: (8.22 GB/7.65 GiB)
Mar 18 08:33:07 atom [ 2285.086520] sd 7:0:0:0: [sdb] Write Protect is off
Mar 18 08:33:07 atom [ 2285.089383] sd 7:0:0:0: [sdb] No Caching mode page present
Mar 18 08:33:07 atom [ 2285.089435] sd 7:0:0:0: [sdb] Assuming drive cache: write through
Mar 18 08:33:07 atom [ 2285.094025] sd 7:0:0:0: [sdb] No Caching mode page present
Mar 18 08:33:07 atom [ 2285.094071] sd 7:0:0:0: [sdb] Assuming drive cache: write through
Mar 18 08:33:07 atom [ 2285.094888]  sdb: sdb1 sdb2
Mar 18 08:33:07 atom [ 2285.097544] sd 7:0:0:0: [sdb] No Caching mode page present
Mar 18 08:33:07 atom [ 2285.097602] sd 7:0:0:0: [sdb] Assuming drive cache: write through
Mar 18 08:33:07 atom [ 2285.097647] sd 7:0:0:0: [sdb] Attached SCSI removable disk
Mar 18 08:33:36 atom [ 2313.744037] Filesystem sda2: xfs_log_force: error 5 returned.
Mar 18 08:34:06 atom
Mar 18 08:34:06 atom [ 2343.745039] Filesystem sda2: xfs_log_force: error 5 returned.
Mar 18 08:34:36 atom
Mar 18 08:34:36 atom [ 2373.745039] Filesystem sda2: xfs_log_force: error 5 returned.
Mar 18 08:35:06 atom


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
