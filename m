Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 08:31:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m24GUsvd005661
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 08:30:55 -0800
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C45F564D5A7
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2008 08:31:23 -0800 (PST)
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.191]) by cuda.sgi.com with ESMTP id FmQKtoholXYeRcFp for <xfs@oss.sgi.com>; Tue, 04 Mar 2008 08:31:23 -0800 (PST)
Received: by ti-out-0910.google.com with SMTP id d10so1204261tib.18
        for <xfs@oss.sgi.com>; Tue, 04 Mar 2008 08:31:21 -0800 (PST)
Message-ID: <47CD7950.9040001@gmail.com>
Date: Tue, 04 Mar 2008 17:31:12 +0100
From: =?UTF-8?B?QXJ0dXIgTWFrw7N3a2E=?= <artur.makowka@gmail.com>
MIME-Version: 1.0
Subject: creating new array
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

i want to create new array, because my last one (raid 0) is gone... now 
it is going to be raid 5.

this will be on xfs fs of course. now the problem is i don't really know 
what chunk size i should use, to get the best performance, but i can 
still mount old array read-only and check what is average file size 
there - just don't know how. (doing ls -lR * , adding sizes and dividing 
by number is probably going to take days to complete)

there was some xfs command that showed it, but i really have no idea 
what it was, xfs_info doesnt give me much information

the currect situation is like this:

meta-data=/dev/md0               isize=256    agcount=32, agsize=5723342 
blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=183146912, imaxpct=25
          =                       sunit=2      swidth=6 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=24576  blocks=0, rtextents=0


some of the files are not on it anymore, as i said, it is damaged RAID 0

the system is going to have millions of small files, (up to 3MB), or 
even hundreds of millions (very popular free hosting)

could you advice me any xfs and mdadm options? i plan to use lazyblocks 
option with latest 2.6.24 kernel. any other ideas?

this is going to be RAID 5, the stability is NOT very important, i will 
have full backups, the most important thing is performance. i can get 
hundreds of hits per second at peak times, i was planning to build it 
from 5 * 500GB disks and it will be just partition for users file, 
system is on another disk. (probably on lvm to give me option to resize 
it in future)

fs performance is critical, as i have many thousands of accounts, mostly 
with just small websites, so it's impossible to put it all in RAM.

if you have any xfs/mdadm creating advice (or mounting options), please 
share with me. i installed xfsprogs 2.9.7, and i will compile 2.6.24 
kernel for creation time ( i can even risk using 2.6.25-rcX if there is 
some important thing changed that i need durning array/filesystem 
creation, just not -mm as XFS version from -mm once corrupted some of my 
users files )
