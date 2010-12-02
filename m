Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2Dsv5p021141 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 07:54:58 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18A831C88DF7
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 05:56:40 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id 68BrRAf1qEQrmksx for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 05:56:40 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUY6C6IIV4LS7885@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Thu, 02 Dec 2010 14:55:09 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUY6C3HEJKLVVT6P@mx.isti.cnr.it> for xfs@oss.sgi.com; Thu,
	02 Dec 2010 14:55:05 +0100 (MET)
Date: Thu, 02 Dec 2010 14:55:05 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-id: <4CF7A539.1050206@shiftmail.org>
MIME-version: 1.0
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
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-lvm@redhat.com

Hello all

I noticed what seem to be 4 bugs.
(kernel v2.6.37-rc4 but probably also before)

First two are one in mkfs.xfs and one in device mapper (lvm mailing list 
I suppose, otherwise pls forward it):

Steps to reproduce:

Boot with a large ramdisk, like ramdisk_size=2097152
(actually I had 14GB ramdisk when I tried this but I don't think it will 
make a difference)

Now partition it with a 1GB partition:
   fdisk /dev/ram0
   n
   p
   1
   1
   +1G
   w
(only one 1GB physical partition)

Make a devmapper mapping for the partition
   kpartx -av /dev/ram0

mkfs.xfs -f /dev/mapper/ram0p1
     meta-data=/dev/mapper/ram0p1     isize=256    agcount=4, 
agsize=66266 blks
             =                       sectsz=512   attr=2
     data     =                       bsize=4096   blocks=265064, imaxpct=25
             =                       sunit=0      swidth=0 blks
     naming   =version 2              bsize=4096   ascii-ci=0
     log      =internal log           bsize=4096   blocks=2560, version=2
             =                       sectsz=512   sunit=0 blks, lazy-count=1
     realtime =none                   extsz=4096   blocks=0, rtextents=0

Now, lo and behold, partition is gone!
   fdisk  /dev/ram0
   p
will show no partitions!

you can also check with
   dd if=/dev/ram bs=1M count=1 | hexdump -C
All first MB of /dev/ram is zeroed!!

also
   mount /dev/ram0p1 /mnt
will fail. Unknown filesystem

I think this shows 2 bugs: firstly mkfs.xfs dares to do stuff before the 
beginning of the device on which it should work.
Secondly, device mapper does not constrain access within the boundaries 
of the device, which I think it should do.

Then I have 2 more bugs for you. Please see my thread in linux-rdma called:
     "NFS-RDMA hangs: connection closed (-103)"
     in particular this post 
http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg06632.html
with NFS over <RDMA or IPoIB> over Infiniband over XFS over ramdisk it 
is possible to write a file (2.3GB) which is larger than the size of the 
device (1.5GB): one bug I think is for XFS people (because I think XFS 
should check if the space on the filesystem is finished), and another 
one I think is for /dev/ram people (what mailing list? I am adding 
lkml), because I think the device should check if someone is writing 
beyond the end of it.

Thank you
PS: I am not subscribed to lkml so please do not reply ONLY to lkml.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
