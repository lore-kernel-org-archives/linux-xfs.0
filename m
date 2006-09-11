Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Sep 2006 05:27:25 -0700 (PDT)
Received: from mail.crc.dk (mail.crc.dk [130.226.184.8])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8BCRCDW004537
	for <linux-xfs@oss.sgi.com>; Mon, 11 Sep 2006 05:27:14 -0700
Message-ID: <45053B2D.50203@crc.dk>
Date: Mon, 11 Sep 2006 12:32:13 +0200
From: Mogens Kjaer <mk@crc.dk>
MIME-Version: 1.0
Subject: Mounting IRIX disk on Linux
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

When I try to mount a disk from our SGI Origin 200
machine under Linux (Fedora Core 5), I get the following error message:

# mount /dev/sda1 /mnt/sgi
mount: Function not implemented

The partitions are found during boot:

...
SCSI device sda: 143374738 512-byte hdwr sectors (73408 MB)
sda: Write Protect is off
sda: Mode Sense: 9f 00 10 08
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 143374738 512-byte hdwr sectors (73408 MB)
sda: Write Protect is off
sda: Mode Sense: 9f 00 10 08
SCSI device sda: drive cache: write back w/ FUA
 sda: sda1 sda2 sda9 sda11
...
# fdisk -l /dev/sda

Disk /dev/sda (SGI disk label): 255 heads, 63 sectors, 8924 cylinders
Units = cylinders of 16065 * 512 bytes

----- partitions -----
Pt#    Device  Info     Start       End   Sectors  Id  System
 1: /dev/sda1  boot        17      8924 143108498   a  SGI xfs
 2: /dev/sda2  swap         1        16    262144   3  SGI raw
 9: /dev/sda3               0         0      4096   0  SGI volhdr
11: /dev/sda4               0      8924 143374738   6  SGI volume
----- Bootinfo -----
Bootfile: /unix
----- Directory Entries -----

The only thing that gets logged during the mount is:

SGI XFS with ACLs, security attributes, large block numbers, no debug
enabled
SGI XFS Quota Management subsystem


How do I determine which of the requirements
listed in:

http://oss.sgi.com/projects/xfs/faq.html#useirixxfs

that hasn't been fulfilled?

Mogens
-- 
Mogens Kjaer, Carlsberg A/S, Computer Department
Gamle Carlsberg Vej 10, DK-2500 Valby, Denmark
Phone: +45 33 27 53 25, Fax: +45 33 27 47 08
Email: mk@crc.dk Homepage: http://www.crc.dk
