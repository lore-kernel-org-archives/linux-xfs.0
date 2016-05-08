Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 379787CA4
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 09:13:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1E4B304032
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 07:13:13 -0700 (PDT)
Received: from co02.mbox.net (co02.mbox.net [165.212.64.32]) by cuda.sgi.com
	with ESMTP id x6f8xPnoVjIZgqb5 (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 May 2016 07:13:07 -0700 (PDT)
Received: from co02.mbox.net (localhost [127.0.0.1])
	by co02.mbox.net (Postfix) with ESMTP id 3r2nXy3bPxzKVGW
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 14:13:06 +0000 (UTC)
From: Issa Gorissen <issa-gorissen@usa.net>
Subject: Unable to mount a XFS filesystem
Message-ID: <30479c32-e298-c64b-1964-f9c9824bfe7a@usa.net>
Date: Sun, 8 May 2016 16:12:59 +0200
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

After I have upgraded my htpc from openSuse 12.3 running kernel 3.7.10 
to openSuse Tumbleweed running kernel 4.5.2; I am unable to mount my XFS 
filesystem anymore.

I probably made some mistakes as I tried some things but did not note 
them because I thought the problem would not be hard to solve.

As I still cannot mount it, I am asking for help.

Here is the details.

The XFS filesystem is on /dev/md0 device which is a RAID1 on top of two 
partitions hosted on two hard disks.

cat /proc/mdstat gives
Personalities : [raid1]
md0 : active raid1 sdc1[1] sdb1[0]
       2930264896 blocks super 1.0 [2/2] [UU]
       bitmap: 0/22 pages [0KB], 65536KB chunk

unused devices: <none>


tv:/ # hdparm -N /dev/sdb

/dev/sdb:
  max sectors   = 5860533168/5860533168, HPA is disabled
tv:/ # hdparm -N /dev/sdc

/dev/sdc:
  max sectors   = 5860533168/5860533168, HPA is disabled


tv:/ # mdadm -Evvvvvvvvs /dev/sdb1 /dev/sdc1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 227f22af:6aa194ed:254ca070:f896b2ce
            Name : any:0
   Creation Time : Sun May  1 23:07:01 2016
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 5860529896 (2794.52 GiB 3000.59 GB)
      Array Size : 2930264896 (2794.52 GiB 3000.59 GB)
   Used Dev Size : 5860529792 (2794.52 GiB 3000.59 GB)
    Super Offset : 5860530160 sectors
    Unused Space : before=0 sectors, after=344 sectors
           State : clean
     Device UUID : 8f585fbd:6cf98a5b:60f7b824:a87e424f

Internal Bitmap : -24 sectors from superblock
     Update Time : Sun May  8 15:28:25 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 12a61779 - correct
          Events : 6600


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 227f22af:6aa194ed:254ca070:f896b2ce
            Name : any:0
   Creation Time : Sun May  1 23:07:01 2016
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 5860529896 (2794.52 GiB 3000.59 GB)
      Array Size : 2930264896 (2794.52 GiB 3000.59 GB)
   Used Dev Size : 5860529792 (2794.52 GiB 3000.59 GB)
    Super Offset : 5860530160 sectors
    Unused Space : before=0 sectors, after=344 sectors
           State : clean
     Device UUID : da81fee9:5b4fd038:a1967771:b9a5c6b9

Internal Bitmap : -24 sectors from superblock
     Update Time : Sun May  8 15:28:25 2016
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : d3cd5d06 - correct
          Events : 6600


    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)



tv:/ # xfs_db /dev/md0
xfs_db: error - read only 0 of 512 bytes
xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 732566238
rblocks = 0
rextents = 0
uuid = 2259f9c7-4f2a-4c02-a9f4-a12e91771126
logstart = 536870916
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 22892695
agcount = 32
rbmblocks = 0
logblocks = 357698
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 25
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 54720
ifree = 1112
fdblocks = 555446971
frextents = 0
uquotino = null
gquotino = null
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0xa
bad_features2 = 0xa
features_compat = 0
features_ro_compat = 0
features_incompat = 0
features_log_incompat = 0
crc = 0 (unchecked)
spino_align = 0
pquotino = 0
lsn = 0
meta_uuid = 00000000-0000-0000-0000-000000000000
xfs_db>



tv:/ # mount -t xfs /dev/md0 /data
mount: /dev/md0: can't read superblock

dmesg outputs


[ 5525.861750] SGI XFS with ACLs, security attributes, realtime, no 
debug enabled
[ 5525.862231] attempt to access beyond end of device
[ 5525.862232] md0: rw=32, want=5860529904, limit=5860529792
[ 5525.862234] XFS (md0): last sector read failed




Any pointers to fix this ? It seems the disks still contains a XFS 
filesystem but for some reason, I cannot access it.

Thanks
--
Issa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
