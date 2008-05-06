Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 09:11:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m46GAqKJ030176
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 09:10:55 -0700
Received: from dubiel.endor.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F53B164EBBD
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 09:11:30 -0700 (PDT)
Received: from dubiel.endor.pl (mail.dubiel.pl [91.194.228.21]) by cuda.sgi.com with ESMTP id vkT6UGnIFAHblxg4 for <xfs@oss.sgi.com>; Tue, 06 May 2008 09:11:30 -0700 (PDT)
Received: from [192.168.18.34] (ident=leszek)
	by orion with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <Leszek.Dubiel@dubielvitrum.pl>)
	id 1JtPlI-0006Dp-0T
	for xfs@oss.sgi.com; Tue, 06 May 2008 18:11:28 +0200
Message-ID: <4820832B.3070903@dubielvitrum.pl>
Date: Tue, 06 May 2008 18:11:23 +0200
From: Leszek Dubiel <Leszek.Dubiel@dubielvitrum.pl>
MIME-Version: 1.0
Subject: XFS for lots of small files
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hello!

I consider moving server from reiserfs to xfs. In all benchmarks I have 
read both file systems have had comparable results.

But I've made a test:

1. formated /dev/hda2 with reiserfs with default options and made 10.000 
files
2. formated /dev/hda2 with xfs with default options and made 10.000

Reiserfs created those files in 2 (two) seconds, and xfs created them in 
35 (thirty five) seconds.

Is that normal? What I am doing wrong?

My system is Debian, current stable version. Below is a log of operation.


Thanks in advance.



debian:/mnt/hdc2# mkfs.xfs /dev/hdc2 -f; mount /dev/hdc2 /mnt/hdc2; cd /mnt/hdc2; mount | egrep hdc2
meta-data=/dev/hdc2              isize=256    agcount=16, agsize=1220688 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=19531008, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=9536, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
/dev/hdc2 on /mnt/hdc2 type xfs (rw)



debian:/mnt/hdc2# time for f in `seq 9999`; do echo $f > $f; done

real	0m35.558s
user	0m0.256s
sys	0m1.080s

debian:/mnt/hdc2# time cat * | wc -l 
9999

real	0m0.239s
user	0m0.020s
sys	0m0.172s



debian:/mnt/hdc2# cd /; umount /dev/hdc2; mkreiserfs /dev/hdc2 -f; mount /dev/hdc2 /mnt/hdc2; cd /mnt/hdc2; mount | egrep hdc2
mkreiserfs 3.6.19 (2003 www.namesys.com)
[...]
ReiserFS is successfully created on /dev/hdc2.
/dev/hdc2 on /mnt/hdc2 type reiserfs (rw)



debian:/mnt/hdc2# time for f in `seq 9999`; do echo $f > $f; done

real	0m1.075s
user	0m0.232s
sys	0m0.844s

debian:/mnt/hdc2# time cat * | wc -l
9999

real	0m0.257s
user	0m0.028s
sys	0m0.256s



debian:/mnt/hdc2# exit
