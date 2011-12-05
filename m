Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB5Ip3wX147104 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 12:51:03 -0600
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A988D1A20C66
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 10:50:59 -0800 (PST)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id 5qN2wiOUH4EAIxkV
	for <xfs@oss.sgi.com>; Mon, 05 Dec 2011 10:50:59 -0800 (PST)
Received: by vbbff1 with SMTP id ff1so1894336vbb.26
	for <xfs@oss.sgi.com>; Mon, 05 Dec 2011 10:50:58 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 5 Dec 2011 13:50:58 -0500
Message-ID: <CAOO4vO7ewwsqNgpkgk=Pf1XUPts66S5bGLjcFS1OteobfXjkVw@mail.gmail.com>
Subject: RAID60/mdadm/xfs performance tuning
From: Paul Anderson <pha@umich.edu>
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
To: xfs-oss <xfs@oss.sgi.com>

I've set up an software RAID-60 array composed of 7 software RAID6's,
each with 32k chunks, 18 devices total (16 data, 2 parity), and in
theory appropriate setup parameters according to a nice white paper
written by Christoph and presented this last summer at LinuxCon.

My question is, if the mdraid and XFS are all configured properly,
would I expect to see any read operations when doing a write-only
test?  I would have assumed that I would not, since XFS should write
stripe-aligned sets of data, and in theory nothing needs to be read
(no read-modify-write going on, I would think).

The performance is great, but I'm wondering if I need to keep looking.

Thanks,

Paul Anderson

Here's the details for kernel 2.6.38.5:

mdadm --detail /dev/md0  (md1, md2, md3, md4, md5, and md6 all the same)
/dev/md0:
        Version : 01.02
  Creation Time : Fri Dec  2 14:54:23 2011
     Raid Level : raid6
     Array Size : 31256214528 (29808.25 GiB 32006.36 GB)
  Used Dev Size : 3907026816 (3726.03 GiB 4000.80 GB)
   Raid Devices : 18
  Total Devices : 18
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Dec  5 13:38:52 2011
          State : clean
 Active Devices : 18
Working Devices : 18
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 32K

/dev/md8 is the RAID0 that concatenates the above RAID6's, making a
single RAID60:

 mdadm --detail /dev/md8
/dev/md8:
        Version : 01.02
  Creation Time : Fri Dec  2 14:55:36 2011
     Raid Level : raid0
     Array Size : 218793480192 (208657.73 GiB 224044.52 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 8
    Persistence : Superblock is persistent

    Update Time : Fri Dec  2 14:55:36 2011
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 4096K (this is what the RAID0 container thinks, but
I ignore it for xfs)

xfs_info /exports/
meta-data=/dev/md8               isize=256    agcount=204, agsize=268435448 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=54698370048, imaxpct=1
         =                       sunit=8      swidth=1024 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I made the filesystem like this:
mkfs.xfs -L $(hostname) -l su=32768 -d su=32768,sw=128 /dev/md8

mount options: inode64,largeio,swalloc,delaylog,logbsize=256k,logbufs=8,noatime,nodiratime

I intended to make it with an external log, but forgot.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
