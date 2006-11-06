Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Nov 2006 02:41:11 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA6Af6aG018301
	for <xfs@oss.sgi.com>; Mon, 6 Nov 2006 02:41:06 -0800
Received: from server1.spsn.net (server1.spsn.net [195.234.231.102])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CB08D1BDEE0
	for <xfs@oss.sgi.com>; Mon,  6 Nov 2006 01:28:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by server1.spsn.net (Postfix) with ESMTP id E4F8EACC01A
	for <xfs@oss.sgi.com>; Mon,  6 Nov 2006 10:28:47 +0100 (CET)
Received: from server1.spsn.net ([127.0.0.1])
	by localhost (server1.spsn.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 82ck1zPyNP9p for <xfs@oss.sgi.com>;
	Mon,  6 Nov 2006 10:28:47 +0100 (CET)
Received: from saschatest.adtech.de (unknown [213.200.64.124])
	by server1.spsn.net (Postfix) with ESMTP id 506E5ACC01A
	for <xfs@oss.sgi.com>; Mon,  6 Nov 2006 10:28:47 +0100 (CET)
From: Sascha Nitsch <sgi@linuxhowtos.org>
Subject: Weird performance decrease
Date: Mon, 6 Nov 2006 10:28:08 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200611061028.08963.sgi@linuxhowtos.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I'm observing a rather strange behaviour of the filesystem cache algorithm.

I have a server running the following app scenario:

A filesystem tree with a depth of 7 directories and 4 character directory 
names.
In the deepest directories are files.
filesize from 100 bytes to 5kb.
Filesystem is XFS.

The app creates dirs in the tree and reads/writes files into the deepest dirs 
in the tree.

CPU: Dual Xeon 3.0 Ghz w/HT 512KB cache each, 2GB RAM, SCSI-HDD 15k RPM

The first while, all is fine and extremely fast. After a while the buffer size 
is about 3.5 MB
and cache size about 618 MB.
Until that moment ~445000 directories and ~106000 files have been created

Thats where the weird behaviour starts.

The buffer size drops to ~200 kb and cache size starts decreasing fast.
This results in a drastic performace drop in my app.
(avg. read/write times increase from 0.3ms to 4ms)
not a constant increase, a jumping increase. During the next while it 
constantly gets slower (19ms and more).

After running a while (with still reducing cache size) the buffer size stays 
at
~700kb and cache about 400 MB. Performane is terrible. Way slower than 
starting up with no cache.

restarting the app makes no change, neither remounting the partition.

cmd to create the fs:
mkfs.xfs -b size=512 -i maxpct=0 -l version=2 -n size=16k /dev/sdc
mounting with
mount /dev/sdc /data

I'm open for suggestion on mkfs calls, mount options and kernel tuning via 
procfs.
I have a testcase to reproduce the problem. It happens after ~45 minutes.

xfs_info /data/
meta-data=/data                  isize=256    agcount=16, agsize=8960921 blks
         =                       sectsz=512
data     =                       bsize=512    blocks=143374736, imaxpct=0
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=16384
log      =internal               bsize=512    blocks=65536, version=2
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

kernel:
a 2.6.9-34.0.2.ELsmp #1 SMP Mon Jul 17 21:41:41 CDT 2006 i686 i686 i386 
GNU/Linux

filesystem usage is < 1%
