Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LC1lMo173913 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 06:01:47 -0600
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id RDrrPchlXWnDFFTg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 21 Feb 2012 04:01:46 -0800 (PST)
Received: by bkcit16 with SMTP id it16so5936171bkc.26
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 04:01:45 -0800 (PST)
Message-ID: <4F4387A7.2070009@gmail.com>
Date: Tue, 21 Feb 2012 13:01:43 +0100
From: kfx <kadafax@gmail.com>
MIME-Version: 1.0
Subject: XFS, empty files after a crash
Reply-To: kadafax@gmail.com
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
To: xfs@oss.sgi.com

Hi,

After a crash, a lot of files on a xfs file system report an empty size 
with "ls -a" but not with "du".
xfs_check and xfs_repair don't report any problem to repair (although an 
internal log is used) :(
So if I understand correctly, those empty files actually use space on 
the disk but are incorrectly reported as empty by the system.
Is there a way to copy back the used blocks to recover the files ?

Example for a previously not empty file:
# ls -l myfile
-rw-r--r-- 1 me me 0 2012-01-24 15:29 myfile

# du  myfile
27460    myfile

# du --apparent-size myfile
0    myfile

# xfs_bmap myfile
myfile: no extents

System: Ubuntu 11.04  2.6.38-8-server x86_64

xfs_info /dev/sdc1
meta-data=/dev/sdc1              isize=256    agcount=10, 
agsize=268435328 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2441215488, imaxpct=5
          =                       sunit=128    swidth=640 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
