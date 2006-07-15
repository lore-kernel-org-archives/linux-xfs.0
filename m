Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Jul 2006 10:13:51 -0700 (PDT)
Received: from smtp.funpic.de (smtp.funpic.de [213.202.225.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6FHDZDW008136
	for <xfs@oss.sgi.com>; Sat, 15 Jul 2006 10:13:39 -0700
Date: Sat, 15 Jul 2006 19:13:10 +0200
From: "A. Liemen" <maillist@liemen.net>
MIME-Version: 1.0
Subject: Bonnie getc reading hitting exact 65536 kb/s
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <20060715171304.59053A00A8A@smtp.funpic.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

during some xfs tuning tests I discovered the following phenomenon. 
Maybe someone can explain it to me:

Bonnie++ Reading with getc()... hits exactly an almost constant
65536 kbyte/s with only ~15% IO usage.

iostat and bonnie output can be found under:

http://alexander.liemen.net/bonnie.txt

sdb is a 14 disk RAID10 (128kb stripe) 2.8Tbyte XFS Volume with an 
external log (128Mb) on sda7 (Raid1)

mount options are:

noatime,nodiratime,logbufs=8,ihashsize=65536,logdev=/dev/sda7

mkfs:

mkfs.xfs -f -d sunit=256,swidth=1792 -l 
version=2,size=128m,logdev=/dev/sda7  /dev/sdb

scheduler: deadline

system:
- debian testing 2.6.15-1-amd64-k8-smp
- dual opteron 275-285 (both tested)
- 16gb ram
- areca pci-x 1160 controller 1gb cache v1.41 firmware
- WD400YR disks

CPU usage is 100% (on one of the cpus) but i don't think that's the 
limiting factor since it hits that 16bit value absolut constantly.

I have also tested it with exactly the same server but faster CPUs and 
it's hitting the same barrier + tested it with no mkfs.xfs options + no 
mount options on a second identical server. Same problem.

Intelligent reading is way above with 350+ Mb/s (check bonnie.txt)


Anyone got an idea why it is hitting that 16bit value / barrier?

Also of interest would be why the random seeks are so bad.


Thanks a lot
Alex
