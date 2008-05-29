Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 10:05:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TH4wpT027311
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:04:59 -0700
Received: from yx-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46D09C11E0F
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:05:49 -0700 (PDT)
Received: from yx-out-1718.google.com (yx-out-1718.google.com [74.125.44.156]) by cuda.sgi.com with ESMTP id 8s9lNuDh3GMZPKDJ for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:05:49 -0700 (PDT)
Received: by yx-out-1718.google.com with SMTP id 36so310197yxh.32
        for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:05:49 -0700 (PDT)
Message-ID: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
Date: Thu, 29 May 2008 13:05:48 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: XFS: SB validate failed
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello there :)

I have a Iomega Jaz cartrdige which seems to be formatted in xfs under
Irix 6.5.
When I insert the cartridge in a drive attached to an Octane machine
(running IRIX 6.5) I get an error message saying that the drive could not
be mounted:
The file system on device: /dev/dsk/dks1d3s7 cannot be mounted

I connected the Jaz drive to a Linux box using a SCSI-to-USB
adapter. When I do a fdisk I get:

$ sudo fdisk -l /dev/sdb

Disk /dev/sdb (SGI disk label): 33 heads, 62 sectors, 1022 cylinders
Units = cylinders of 2046 * 512 bytes

----- partitions -----
Pt#    Device  Info     Start       End   Sectors  Id  System
 8: /dev/sdb1               2      1021   2087936   a  SGI xfs
 9: /dev/sdb2               0         1      3072   0  SGI volhdr
11: /dev/sdb3               0      1021   2091008   6  SGI volume
----- Bootinfo -----
Bootfile: /unix
----- Directory Entries -----
 0: sgilabel   sector    3 size     512

But trying to mount the device fails:

$ sudo mount -t xfs /dev/sdb /mnt
$ sudo mount -t xfs /dev/sdb8 /mnt
$ sudo mount -t xfs /dev/sdb11 /mnt

Checking the log messages, I get:
[6815277.617579] XFS: bad magic number
[6815277.617587] XFS: SB validate failed

(I found similar problems reported here
http://osdir.com/ml/security.forensics/2006-04/msg00025.html)
# /usr/sysadm/privbin/getDiskParts -d dks1d3vol
7:10:3072:2087936;8:0:0:3072;10:6:0:2091008;

I also tried to use xfs_check and xfs_repair.
xfs_check crashes:
/usr/sbin/xfs_check: line 28: 25216 Segmentation fault
(core dumped) xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1

and xfs_repair reports that:
bad primary superblock - bad magic number !!!
attempting to find secondary superblock
Sorry, could not find valid secondary superblock
Exiting now.

My questions:
1-Is this related to the information stated in FAQ regarding
XLV support or v2 directories under Irix ?
2-Do I need to be concerned about byte ordering when it comes
to how the partition table info are stored on my Jaz cartridge ?
3-If this is a corrupt partition problem, would you suggest that
I attempt to fix it under Irix or the Linux xfs tools will be sufficient ?

I'd really appreciate any input that can help me resolve this issue.

thanks in advance.
