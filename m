Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 12:44:39 -0700 (PDT)
Received: from web35711.mail.mud.yahoo.com (web35711.mail.mud.yahoo.com [66.163.179.165])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8KJiUgf000776
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 12:44:31 -0700
Date: Thu, 20 Sep 2007 12:17:53 -0700 (PDT)
From: Mariella Petrini <mariellapetrini@yahoo.com>
Subject: xfs and Linux Linux 2.6.22 and Memory
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <435577.15025.qm@web35711.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi All,

I have compiled xfs that is available with Linux
2.6.22 on a Debian 4.0
The system is a 2 cpus (Intel Xeon 3 GHz) with 4 cores
each
The system has 8 GB of RAM + 2GB of swap

I have 4 Hard Drives on the system and each is
formatted using xfs
Each filesystem is mounted with noatime option
I am including the output generated during one of the
format:

mkfs.xfs -f /dev/sdb1

meta-data=/dev/sdb1              isize=256   
agcount=16, agsize=4881374 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096  
blocks=78101984, imaxpct=25
         =                       sunit=0      swidth=0
blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096  
blocks=32768, version=1
         =                       sectsz=512   sunit=0
blks
realtime =none                   extsz=65536 
blocks=0, rtextents=0


I have been using an sql server to populate the 4 xfs
filesystems.
So all the files represents part of a relational
database.

In each filesystem I have 5 top directory and each
directory contains 100,000 files, so in total each
filesystem has 500,000 regular files + 5 regular
directories.
The sql server is the only program that writes the
regular files into the xfs filesystems.

During the time taken to populate the 4 filesystems
(2,000,000 files)
I have noticed that approximately 5 GB of RAM were
taken.

Once all the filesystems were populated I have
shutdown the sql server (the only process that
accesses/reads/writes the filesystems) and the 5 GB of
RAM would not be released.

At that point I have unmounted the 4 xfs filesystems
and the 5 GB of RAM would be released (be available
again).


QUESTION:

Is there any way to release that amount of memory
without unmounting the file systems ?
Is that caused to some caching mechanism ?
Or could that be caused by something else ?

Could you please help ?
Thanks a lot in advance for your help,

Mariella





       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
