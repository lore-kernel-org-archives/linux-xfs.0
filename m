Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HMDt4m011956
	for <linux-xfs@oss.sgi.com>; Sat, 17 Jan 2009 16:13:55 -0600
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 450A8990CC
	for <linux-xfs@oss.sgi.com>; Sat, 17 Jan 2009 14:13:53 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by cuda.sgi.com with ESMTP id PN3UaSR6XcSmdl8t for
	<linux-xfs@oss.sgi.com>; Sat, 17 Jan 2009 14:13:53 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id 19so1049465fgg.8
	for <linux-xfs@oss.sgi.com>; Sat, 17 Jan 2009 14:13:52 -0800 (PST)
Subject: Re: kernel 2.6.28 XFS internal error xfs_da_do_buf(2) at line 2112
	of	file fs/xfs/xfs_da_btree.c
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <4972484E.5030204@sandeen.net>
References: <1232225359.8845.198.camel@champagne.cantina>
	<4972484E.5030204@sandeen.net>
Date: Sat, 17 Jan 2009 23:08:03 +0100
Message-Id: <1232230083.8845.220.camel@champagne.cantina>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, 2009-01-17 at 15:06 -0600, Eric Sandeen wrote:
> Alessandro Bono wrote:
> > Hi all
> > 
> > New kernel new problem
> > rsync over ssh to a usb disk get this scary message
> > 
> > Jan 17 17:39:50 champagne kernel: [30342.675488] 00000000: e8 1f 67 a1
> > 7f 9c 65 fc c7 e9 c7 3f e1 d7 17 a7  ..g...e....?....
> > Jan 17 17:39:50 champagne kernel: [30342.675504] Filesystem "sdb1": XFS
> > internal error xfs_da_do_buf(2) at line 2112 of file
> > fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0196e9f
> 
> This means that it read metadata with a bad magic number (the message
> could be clearer).
> 
> Any storage errors in dmesg prior to this?

In effect there is this message
Jan 17 17:39:49 champagne kernel: [30342.273029] usb 4-3: reset high
speed USB device using ehci_hcd and address 4

I was using a usb pen that I disconnected just a second prior errors
appear, for some reason plugging out usb pen caused a reset on usb disk
(two port located on two side on my notebook, I didn't touch usb disk
while disconnecting usb pen)

Jan 17 17:34:47 champagne kernel: [30039.760046] usb 4-5: new high speed
USB device using ehci_hcd and address 5
Jan 17 17:34:47 champagne kernel: [30039.902828] usb 4-5: configuration
#1 chosen from 1 choice
Jan 17 17:34:47 champagne kernel: [30039.955770] scsi7 : SCSI emulation
for USB Mass Storage devices
Jan 17 17:34:47 champagne kernel: [30039.959464] usb-storage: device
found at 5
Jan 17 17:34:47 champagne kernel: [30039.959470] usb-storage: waiting
for device to settle before scanning
Jan 17 17:34:52 champagne kernel: [30044.956409] usb-storage: device
scan complete
Jan 17 17:34:52 champagne kernel: [30044.957497] scsi 7:0:0:0:
Direct-Access     USB      Driver           0.00 PQ: 0 ANSI: 0 CCS
Jan 17 17:34:52 champagne kernel: [30045.242137] sd 7:0:0:0: [sdc]
31318016 512-byte hardware sectors: (16.0 GB/14.9 GiB)
Jan 17 17:34:52 champagne kernel: [30045.242644] sd 7:0:0:0: [sdc] Write
Protect is off
Jan 17 17:34:52 champagne kernel: [30045.242650] sd 7:0:0:0: [sdc] Mode
Sense: 23 00 00 00
Jan 17 17:34:52 champagne kernel: [30045.242655] sd 7:0:0:0: [sdc]
Assuming drive cache: write through
Jan 17 17:34:52 champagne kernel: [30045.249520] sd 7:0:0:0: [sdc]
31318016 512-byte hardware sectors: (16.0 GB/14.9 GiB)
Jan 17 17:34:52 champagne kernel: [30045.250007] sd 7:0:0:0: [sdc] Write
Protect is off
Jan 17 17:34:52 champagne kernel: [30045.250013] sd 7:0:0:0: [sdc] Mode
Sense: 23 00 00 00
Jan 17 17:34:52 champagne kernel: [30045.250018] sd 7:0:0:0: [sdc]
Assuming drive cache: write through
Jan 17 17:34:52 champagne kernel: [30045.250028]  sdc: sdc1
Jan 17 17:34:52 champagne kernel: [30045.250863] sd 7:0:0:0: [sdc]
Attached SCSI removable disk
Jan 17 17:34:52 champagne kernel: [30045.251074] sd 7:0:0:0: Attached
scsi generic sg3 type 0
Jan 17 17:39:49 champagne kernel: [30342.166347] usb 4-5: USB
disconnect, address 5
Jan 17 17:39:49 champagne kernel: [30342.273029] usb 4-3: reset high
speed USB device using ehci_hcd and address 4

Is this a usb problem? 

thanks Eric

> 
> -Eric
-- 
---
Cordiali Saluti
Alessandro Bono

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
