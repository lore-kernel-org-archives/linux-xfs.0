Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41A137F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 17:09:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 308458F8054
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 15:09:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	E9x2ca7p3bre89nW for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 15:09:42 -0700 (PDT)
Date: Tue, 14 Oct 2014 09:09:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Mount: Structure needs cleaning
Message-ID: <20141013220940.GE17506@dastard>
References: <4ddef393-ad9e-49a1-80d7-9c29bcd74c8f@me.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ddef393-ad9e-49a1-80d7-9c29bcd74c8f@me.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tom Mason <tom_mason@me.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Oct 13, 2014 at 08:33:57PM +0000, Tom Mason wrote:
> =

> =

> On Oct 13, 2014, at 11:19 AM, Emmanuel Florac <eflorac@intellique.com> wr=
ote:
> =

> >Le Mon, 13 Oct 2014 11:05:49 +0100
> >Tom Mason <tom_mason@me.com    > =E9crivait:
> >
> >       >      > Which means the filesystem tried to read the offset at 6=
2GB and the
> >       >      > underlying device failed it with EIO. That's not an XFS =
failure.
> >       >      > What error is there in dmesg when you run that xfs_repai=
r command?
> >       >
> >       > What's EIO?
> >       > 'Error in dmesg' How would I report this info to you?
....
> [  862.456063] usb 1-3: new high-speed USB device number 4 using ehci-pci
> [  862.591595] usb 1-3: New USB device found, idVendor=3D1bcf, idProduct=
=3D0c31
> [  862.591601] usb 1-3: New USB device strings: Mfr=3D2, Product=3D3, Ser=
ialNumber=3D1
> [  862.591604] usb 1-3: Product: USB to Serial-ATA bridge
> [  862.591608] usb 1-3: Manufacturer: Sunplus Innovation Technology.
> [  862.591611] usb 1-3: SerialNumber: FAFFFFF0FDF13FF1BF901305
> [  864.683460] usb-storage 1-3:1.0: USB Mass Storage device detected
> [  864.683638] scsi6 : usb-storage 1-3:1.0
> [  864.683708] usbcore: registered new interface driver usb-storage
> [  865.690235] scsi 6:0:0:0: Direct-Access     SAMSUNG  HD103UJ          =
     PQ: 0 ANSI: 4
> [  865.690464] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [  865.694619] sd 6:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.0=
0 TB/931 GiB)
> [  865.700970] sd 6:0:0:0: [sdb] Write Protect is off
> [  865.700973] sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00
> [  865.707350] sd 6:0:0:0: [sdb] No Caching mode page found
> [  865.707352] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  865.721592] sd 6:0:0:0: [sdb] No Caching mode page found
> [  865.721595] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  865.741343]  sdb: sdb1 < > sdb2
> [  865.780852] sd 6:0:0:0: [sdb] No Caching mode page found
> [  865.780855] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  865.780857] sd 6:0:0:0: [sdb] Attached SCSI disk

Device plugged in....

> [  869.594066] SGI XFS with ACLs, security attributes, realtime, large bl=
ock/inode numbers, no debug enabled
> [  869.609228] XFS (sdb2): Mounting Filesystem
> [  869.687220] XFS (sdb2): Internal error xlog_clear_stale_blocks(2) at l=
ine 1368 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_log_recover.c.  Call=
er 0xffffffffa07a8951
.....
> [  869.687442] XFS (sdb2): failed to locate log tail
> [  869.687444] XFS (sdb2): log mount/recovery failed: error 117
> [  869.687486] XFS (sdb2): log mount failed

And that is XFS telling us that the log is corrupt and can't be
recovered.

> [ 1404.460745] sd 6:0:0:0: [sdb] Unhandled sense code
> [ 1404.460751] sd 6:0:0:0: [sdb] [ 1404.460753] Result:
> hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [ 1404.460756] sd 6:0:0:0: [sdb] [ 1404.460758] Sense Key : Medium
> Error [current]
> [ 1404.460763] sd 6:0:0:0: [sdb] [ 1404.460766] Add. Sense:
> Unrecovered read error
> [ 1404.460769] sd 6:0:0:0: [sdb] CDB:
> [ 1404.460771] Read(10): 28 00 07 63 bf 8d 00 00 eb 00
> [ 1404.460781] end_request: critical medium error, dev sdb, sector 123977=
613
> [ 1489.507727] sd 6:0:0:0: [sdb] Unhandled sense code
> [ 1489.507734] sd 6:0:0:0: [sdb] [ 1489.507736] Result:
> hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [ 1489.507739] sd 6:0:0:0: [sdb] [ 1489.507741] Sense Key : Medium
> Error [current]
> [ 1489.507746] sd 6:0:0:0: [sdb] [ 1489.507749] Add. Sense:
> Unrecovered read error
> [ 1489.507752] sd 6:0:0:0: [sdb] CDB:
> [ 1489.507754] Read(10): 28 00 07 63 bf 8d 00 00 eb 00
> [ 1489.507769] end_request: critical medium error, dev sdb, sector 123977=
613

And that is when you ran xfs_repair 10 minutes later? THose are IO
errors, and the "Unrecovered read error" and "critical medium error"
messages indicate that the drive has lost the data in those sectors
permanently. i.e. the disk has physically failed and it needs to be
replaced. As Emmanuel has already mentioned, the best you can
probably do at this point mount the filesystem "-o ro,norecover" and
copy everything you can off onto a new drive....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
