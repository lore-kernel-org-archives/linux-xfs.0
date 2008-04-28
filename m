Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 14:43:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SLgmxV009033
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 14:42:49 -0700
Received: from mail.brightcove.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1798E10C9AE1
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 14:43:28 -0700 (PDT)
Received: from mail.brightcove.com (mail.brightcove.com [38.113.27.188]) by cuda.sgi.com with ESMTP id 8I2ljNZMJ1PJ4Swr for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 14:43:28 -0700 (PDT)
From: Lance Reed <lreed@brightcove.com>
Date: Mon, 28 Apr 2008 17:42:40 -0400
Subject: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
Message-ID: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL>
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I recently experienced a problem trying to expand an existing LVM + XFS installation.
The core problem was that xfs_growfs did not correctly resize the XFS filesystem while trying to expand from 11 TB to about 21 TB.

The previous setup had 5 x 2.18 TB LUNs using LVM2 for a total of just under 11 TB.
This is a 64bit Linux system.
Linux nfs3 2.6.18-8.1.15.el5 #1 SMP Mon Oct 22 08:32:28 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
CentOS release 5 (Final)

XFS versions:
xfsprogs-2.9.4-1.el5.centos
xfsdump-2.2.46-1.el5.centos
kmod-xfs-0.4-1.2.6.18_8.1.15.el5

LVM:
lvm2-2.02.16-3.el5

The plan was to expand to 5 more 2.18 TB LUNs for a total just under 21 TB.  This should be allowed since this is a 64 bit install.

Five new Physical LVM volumes were created and added into the LVM VG.
I extended the LVM Logical Volume by 1 TB to test.

# lvextend -L+1T  /dev/VolGroupNAS200/LogVolNAS200
  Extending logical volume LogVolNAS200 to 11.39 TB
  Logical volume LogVolNAS200 successfully resized

Then used xfs_growfs to extend the XFS filesystem.

# xfs_growfs /nas2
meta-data=/dev/VolGroupNAS200/LogVolNAS200 isize=256    agcount=34, agsize=83886080 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2789212160, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 2789212160 to 3057647616

This seemed fine and checked the XFS filesystem:

# df -Ph /nas2
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroupNAS200-LogVolNAS200   12T  9.0T  2.5T  79% /nas2

Then decided to add in the rest of the remaining space to the LVM Logical Volume (saving about 512 GB)

# lvextend -L+10179G  /dev/VolGroupNAS200/LogVolNAS200
  Extending logical volume LogVolNAS200 to 21.33 TB
  Logical volume LogVolNAS200 successfully resized

[root@nfs4.arc ~]# vgdisplay VolGroupNAS200
  --- Volume group ---
  VG Name               VolGroupNAS200
  System ID
  Format                lvm2
  Metadata Areas        10
  Metadata Sequence No  10
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                10
  Act PV                10
  VG Size               21.83 TB
  PE Size               4.00 MB
  Total PE              5722830
  Alloc PE / Size       5591808 / 21.33 TB
  Free  PE / Size       131022 / 511.80 GB
  VG UUID               iNQ6VK-tdaO-fDrk-WwXk-uL3s-2zmw-j5zAcm

Then attempted to grow XFS:

~]# xfs_growfs /nas2
meta-data=/dev/VolGroupNAS200/LogVolNAS200 isize=256    agcount=37, agsize=83886080 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=3057647616, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

PROBLEM:
The xfs_growfs  returned but did not give the "data blocks changed from X to Y".

A quick google search confirmed that this would be a problem.
Attempting to umount and remount the file system proved to be a problem.

When the mount was attempted:

Apr 25 00:13:19 nfs3 kernel: SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no
debug enabled
Apr 25 00:13:19 nfs3 kernel: SGI XFS Quota Management subsystem
Apr 25 00:13:19 nfs3 kernel: attempt to access beyond end of device
Apr 25 00:13:19 nfs3 kernel: dm-5: rw=0, want=67155001344, limit=45808091136
Apr 25 00:13:19 nfs3 kernel: I/O error in filesystem ("dm-5") meta-data dev dm-5 block 0xfa2bfffff       ("xf
s_read_buf") error 5 buf count 512
Apr 25 00:13:19 nfs3 kernel: XFS: size check 2 failed
Apr 25 00:13:19 nfs3 Filesystem[4236]: [4293]: ERROR: Couldn't mount filesystem /dev/VolGroupNAS200/LogVolNAS
200 on /nas2
Apr 25 00:13:19 nfs3 Filesystem[4225]: [4294]: ERROR:  Generic error

The first attempt to run xfs_repair  did not succeed, as the terminal lost connection (network).
The second attempt to run  xfs_repair did succeed .  In this case xfs_repaired the sizes and the volume was able to be mounted.
However the filesystem is at the size of the last successful xfs_grow of 11664G (Just under 12 TB).

XFS mounting filesystem dm-5
Ending clean XFS mount for filesystem: dm-5

So, XFS did not expand correctly.  I do not know why.
I don't think this is a problem with LVM, as I have used large volumes before on LVM, and this was an expansion from an existing LVM setup that basically went from 5 x 2.18 TB LUNs to 10 x 2.18 TB LUNs.

If anyone has any ideas it would be great.
I do not know if I should attempt to expand the filesystem in 1 TB amounts using " -D size or -R size ?" option?
Should I shrink the LVM Logical volume down to something more reasonable?


Thanks in advance for any help....








[[HTML alternate version deleted]]
