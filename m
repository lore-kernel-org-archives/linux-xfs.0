Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 11:14:12 -0700 (PDT)
Received: from isls-mx20.wmin.ac.uk (isls-mx20.wmin.ac.uk [161.74.14.113])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5RIE5tL000719
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 11:14:07 -0700
Received: from groucho.wmin.ac.uk ([161.74.160.74])
	by isls-mx20.wmin.ac.uk with esmtp (Exim 4.60)
	(envelope-from <S.Illes@westminster.ac.uk>)
	id 1I3bmi-0004es-7b
	for xfs@oss.sgi.com; Wed, 27 Jun 2007 18:58:32 +0100
Received: from sunset.cpc.wmin.ac.uk (5ac093cf.bb.sky.com [90.192.147.207])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by groucho.wmin.ac.uk (Postfix) with ESMTP id 00F78321B3B
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 18:58:29 +0100 (BST)
Date: Wed, 27 Jun 2007 18:58:29 +0100
Subject: After reboot fs with barrier faster deletes then fs with nobarrier
From: "Szabolcs Illes" <S.Illes@westminster.ac.uk>
Content-Type: text/plain; format=flowed; delsp=yes; charset=us-ascii
MIME-Version: 1.0
Message-ID: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I am using XFS on my laptop, I have realized that nobarrier mount options  
sometimes slows down deleting large number of small files, like the kernel  
source tree. I made four tests, deleting the kernel source right after  
unpack and after reboot, with both barrier and nobarrier options:

mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync &&  
reboot

After reboot:
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m28.127s
user    0m0.044s
sys     0m2.924s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m14.872s
user    0m0.044s
sys     0m2.872s

-------------------------------------------------------------------
mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2,nobarrier

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync &&  
reboot
After reboot:

illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    1m12.738s
user    0m0.032s
sys     0m2.548s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m7.884s
user    0m0.028s
sys     0m2.008s

It looks like with barrier it's faster deleting files after reboot. ( 28  
sec vs 72 sec !!! ).
I thought it was supposed to be faster using the nobarrier mount options,  
but is not, very strange.

However deleting right after the unpack ( so everything in mem cache )  is  
faster with nobarrier ( 15 sec vs 9 sec ), not to much surprise here.

I repeated this test several times, same results. I made sure nothing was  
running while I was doing the tests, cpu was idle, hdd led was not on, etc.

I have found nothing in the logs regarding to barrier is not working.

Can anyone explain this?
Is it normal?
Is there any point using barrier (expect it's sometimes faster :) ) on a  
laptop?

Cheers,
Szabolcs


Some info:
Test system: opensuse10.2
xfsprogs-2.8.11_1-11

sunset:~ # uname -a
Linux sunset 2.6.18.8-0.3-default #1 SMP Tue Apr 17 08:42:35 UTC 2007 i686  
i686 i386 GNU/Linux

sunset:~ # xfs_info:

meta-data=/dev/hda3              isize=256    agcount=8, agsize=946078 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=7568623, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=3695, version=2
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

sunset:~ # hdparm /dev/hda

/dev/hda:
  multcount    = 16 (on)
  IO_support   =  1 (32-bit)
  unmaskirq    =  0 (off)
  using_dma    =  1 (on)
  keepsettings =  0 (off)
  readonly     =  0 (off)
  readahead    = 256 (on)
  geometry     = 16383/255/63, sectors = 78140160, start = 0
