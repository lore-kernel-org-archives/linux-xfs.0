Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5NCotPd025799 for <xfs@oss.sgi.com>; Sat, 23 Jun 2012 07:50:55 -0500
Received: from vserv.windfluechter.net (vserv.windfluechter.net
	[178.63.83.104]) by cuda.sgi.com with ESMTP id VRoBOs2yWacG90xI
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 23 Jun 2012 05:50:52 -0700 (PDT)
Received: from [172.16.10.1] (helo=hro.bluespice.org)
	by vserv.windfluechter.net with esmtps
	(TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16) (Exim 4.72)
	(envelope-from <ij@2012.bluespice.org>) id 1SiPne-0002sy-F8
	for xfs@oss.sgi.com; Sat, 23 Jun 2012 14:50:50 +0200
From: =?iso-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2012.bluespice.org>
Subject: mkfs.xfs states log stripe unit is too large
Date: Sat, 23 Jun 2012 14:50:49 +0200
Message-Id: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
Mime-Version: 1.0 (Apple Message framework v1084)
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

Hi!

I already brought this one up yesterday on #xfs@freenode where it was suggested to write this on this ML. Here I go... 

I'm running Debian unstable on my desktop and lately added a new RAID set consisting of 3x 4 TB disks (namely Hitachi HDS724040ALE640). My partition layout is: 

Model: ATA Hitachi HDS72404 (scsi)
Disk /dev/sdd: 4001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      17.4kB  1018kB  1000kB                     bios_grub
 2      2097kB  212MB   210MB   ext3               raid
 3      212MB   1286MB  1074MB  xfs                raid
 4      1286MB  4001GB  4000GB                     raid

Partition #2 is intended as /boot disk (RAID1), partition #3 as small rescue disk or swap (RAID1), partition #4 will be used as physical device for LVM (RAID5). 

muaddib:~# mdadm --detail /dev/md7
/dev/md7:
        Version : 1.2
  Creation Time : Fri Jun 22 22:47:15 2012
     Raid Level : raid5
     Array Size : 7811261440 (7449.40 GiB 7998.73 GB)
  Used Dev Size : 3905630720 (3724.70 GiB 3999.37 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sat Jun 23 13:47:19 2012
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : muaddib:7  (local to host muaddib)
           UUID : 0be7f76d:90fe734e:ac190ee4:9b5f7f34
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       8       68        0      active sync   /dev/sde4
       1       8       52        1      active sync   /dev/sdd4
       3       8       84        2      active sync   /dev/sdf4


So, a cat /proc/mdstat shows all of my RAID devices: 

muaddib:~# cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md7 : active raid5 sdf4[3] sdd4[1] sde4[0]
      7811261440 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      
md6 : active raid1 sdd3[0] sdf3[2] sde3[1]
      1048564 blocks super 1.2 [3/3] [UUU]
      
md5 : active (auto-read-only) raid1 sdd2[0] sdf2[2] sde2[1]
      204788 blocks super 1.2 [3/3] [UUU]
      
md4 : active raid5 sdc6[0] sda6[2] sdb6[1]
      1938322304 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      
md3 : active (auto-read-only) raid1 sdc5[0] sda5[2] sdb5[1]
      1052160 blocks [3/3] [UUU]
      
md2 : active raid1 sdc3[0] sda3[2] sdb3[1]
      4192896 blocks [3/3] [UUU]
      
md1 : active (auto-read-only) raid1 sdc2[0] sda2[2] sdb2[1]
      2096384 blocks [3/3] [UUU]
      
md0 : active raid1 sdc1[0] sda1[2] sdb1[1]
      256896 blocks [3/3] [UUU]
      
unused devices: <none>

The RAID devices /dev/md0 to /dev/md4 are on my old 3x 1 TB Seagate disks. Anyway, to finally come to the problem, when I try to create a filesystem on the new RAID5 I get the following:  

muaddib:~# mkfs.xfs /dev/lv/usr
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/lv/usr            isize=256    agcount=16, agsize=327552 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=5240832, imaxpct=25
         =                       sunit=128    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


As you can see I follow the "mkfs.xfs knows best, don't fiddle around with options unless you know what you're doing!"-advice. But apparently mkfs.xfs wanted to create a log stripe unit of 512 kiB, most likely because it's the same chunk size as the underlying RAID device. 

The problem seems to be related to RAID5, because when I try to make a filesystem on /dev/md6 (RAID1), there's no error message: 

muaddib:~# mkfs.xfs /dev/md6
meta-data=/dev/md6               isize=256    agcount=8, agsize=32768 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=262141, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Additional info: 
I first bought two 4 TB disks and ran them for about 6 weeks as a RAID1 and already did some tests (because the 4 TB Hitachis were sold out in the meantime). I can't remember seeing the log stripe error message during those tests while working with a RAID1. 

So, the question is: 
- is this a bug somewhere in XFS, LVM or Linux's software RAID implementation?
- will performance suffer from log stripe size adjusted to just 32 kiB? Some of my logical volumes will just store data, but one or the other will have some workload acting as storage for BackupPC. 
- would it be worth the effort to raise log stripe to at least 256 kiB?
- or would it be better to run with external log on the old 1 TB RAID?

End note: the 4 TB disks are not yet "in production", so I can run tests with both RAID setup as well as mkfs.xfs. Reshaping the RAID will take up to 10 hours, though... 

-- 
Ciao...            //      Fon: 0381-2744150
      Ingo       \X/       http://blog.windfluechter.net


gpg pubkey:  http://www.juergensmann.de/ij_public_key.asc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
