Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 13:22:19 -0700 (PDT)
Received: from SVITS26.main.ad.rit.edu (svits26.main.ad.rit.edu [129.21.18.136])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA1KMFsq003297
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 13:22:16 -0700
MIME-Version: 1.0
Subject: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
Date: Thu, 1 Nov 2007 16:06:35 -0400
Message-ID: <06CCEA2EB1B80A4A937ED59005FA855101AED1BE@svits26.main.ad.rit.edu>
From: "Jay Sullivan" <jpspgd@rit.edu>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have an XFS filesystem that has had the following happen twice in 3
months, both times with an impossibly large block number was requested.
Unfortunately my logs don't go back far enough for me to know if it was
the _exact_ same block both times...  I'm running xfsprogs 2.8.21.
Excerpt from syslog (hostname obfuscated to 'servername' to protect the
innocent):

 

##

Nov  1 14:06:32 servername dm-1: rw=0, want=39943195856896,
limit=7759462400

Nov  1 14:06:32 servername I/O error in filesystem ("dm-1") meta-data
dev dm-1 block 0x245400000ff8       ("xfs_trans_read_buf") error 5 buf
count 4096

Nov  1 14:06:32 servername xfs_force_shutdown(dm-1,0x1) called from line
415 of file fs/xfs/xfs_trans_buf.c.  Return address = 0xc02baa25

Nov  1 14:06:32 servername Filesystem "dm-1": I/O Error Detected.
Shutting down filesystem: dm-1

Nov  1 14:06:32 servername Please umount the filesystem, and rectify the
problem(s)

###

 

I ran xfs_repair -L on the FS and it could be mounted again, but how
long until it happens a third time?  What concerns me is that this is a
FS smaller than 4TB and 39943195856896 (or 0x245400000ff8) seems like a
block that I would only have if my FS was muuuuuch larger.  The
following is output from some pertinent programs:

 

###

servername ~ # xfs_info /mnt/san

meta-data=/dev/servername-sanvg01/servername-sanlv01 isize=256
agcount=5, agsize=203161600 blks

         =                       sectsz=512   attr=2

data     =                       bsize=4096   blocks=969932800,
imaxpct=25

         =                       sunit=0      swidth=0 blks, unwritten=1

naming   =version 2              bsize=4096  

log      =internal               bsize=4096   blocks=32768, version=1

         =                       sectsz=512   sunit=0 blks, lazy-count=0

realtime =none                   extsz=4096   blocks=0, rtextents=0

servername ~ # mount

/dev/sda3 on / type ext3 (rw,noatime,acl)

proc on /proc type proc (rw)

sysfs on /sys type sysfs (rw,nosuid,nodev,noexec)

udev on /dev type tmpfs (rw,nosuid)

devpts on /dev/pts type devpts (rw,nosuid,noexec)

shm on /dev/shm type tmpfs (rw,noexec,nosuid,nodev)

usbfs on /proc/bus/usb type usbfs
(rw,noexec,nosuid,devmode=0664,devgid=85)

binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
(rw,noexec,nosuid,nodev)

nfsd on /proc/fs/nfsd type nfsd (rw)

/dev/mapper/servername--sanvg01-servername--sanlv01 on /mnt/san type xfs
(rw,noatime,nodiratime,logbufs=8,attr2)

/dev/mapper/servername--sanvg01-servername--rendersharelv01 on
/mnt/san/rendershare type xfs (rw,noatime,nodiratime,logbufs=8,attr2)

rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)

servername ~ # uname -a

Linux servername 2.6.20-gentoo-r8 #7 SMP Fri Jun 29 14:46:02 EDT 2007
i686 Intel(R) Xeon(TM) CPU 3.20GHz GenuineIntel GNU/Linux

###

 

Does anyone know if this points to a bad block on a disk or if something
is corrupted and can be fixed with some expert knowledge of xfs_db?

 

~Jay



[[HTML alternate version deleted]]
