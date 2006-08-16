Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 12:02:29 -0700 (PDT)
Received: from 217-133-29-81.b2b.tiscali.it (217-133-29-81.b2b.tiscali.it [217.133.29.81])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7GJ2HDW017942
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 12:02:17 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by 217-133-29-81.b2b.tiscali.it (Postfix) with ESMTP id D4C868012D
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 20:01:54 +0200 (CEST)
Received: from 217-133-29-81.b2b.tiscali.it ([127.0.0.1])
	by localhost (solstizio.toel.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 18308-08 for <xfs@oss.sgi.com>;
	Wed, 16 Aug 2006 20:01:39 +0200 (CEST)
Received: from [10.0.11.232] (unknown [10.0.2.114])
	by 217-133-29-81.b2b.tiscali.it (Postfix) with ESMTP id 4E7E18012C
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 20:01:39 +0200 (CEST)
From: "Daniele P." <daniele@interline.it>
Subject: Re: xfsdump -s unacceptable performances
References: <200608161515.00543.daniele@interline.it> <44E32DE6.9090602@gmx.net>
In-Reply-To: <44E32DE6.9090602@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 16 Aug 2006 20:01:10 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200608162001.10342.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wednesday 16 August 2006 16:38, you wrote:
> Daniele P. schrieb:
> Hi Daniele,
>
> hum, so the 2.2.27 was running 3657m39.120s and the 2.2.38 is running
> the same (?) in 0m17.575s. Where is your performance problem running now
> 10000 times faster than the old 2.2.27 version???
> Or did i miss something?

Hi Klaus,
Yes, there was a huge performance improvement for /small/ filesystem,
(40.000 inodes, in my test case).
But xfsdump still doesn't scale down well with a small subtree on a
large filesystem.
Now the test on the /large/ (11.000.000 inodes) filesystem has ended.

ori:~# find /media/xfs-large/backup/pin/ -type f | wc -l
2
ori:~# find /media/xfs-large/backup/pin/ -type d | wc -l
2
ori:~# find /media/xfs-large/backup/pin/ | wc -l
4
ori:~# du -s /media/xfs-large/backup/pin/
8       /media/xfs-large/backup/pin/

I stopped the test with 2.2.27 after 5 days of "phase 3".
Here is the test with 2.2.38, which is still too slow:

time /usr/local/bin/xfsdump -p 60 -v drive=debug,media=debug \
-s backup/pin - /media/xfs-large | dd of=/dev/null
/usr/local/bin/xfsdump: using file dump (drive_simple) strategy
/usr/local/bin/xfsdump: version 2.2.38 (dump format 3.0) - Running 
single-threaded
/usr/local/bin/xfsdump: level 0 dump of ori:/media/xfs-large
/usr/local/bin/xfsdump: dump date: Wed Aug 16 12:56:57 2006
/usr/local/bin/xfsdump: session id: a293b79a-a5ac-4e49-be3e-55fbc5f8fba2
/usr/local/bin/xfsdump: session label: ""
/usr/local/bin/xfsdump: ino map phase 1: constructing initial dump list
/usr/local/bin/xfsdump: status at 12:58:12: 75 seconds elapsed
/usr/local/bin/xfsdump: ino map phase 2: skipping (no pruning necessary)
/usr/local/bin/xfsdump: ino map phase 3: skipping (only one dump stream)
/usr/local/bin/xfsdump: status at 12:58:57: inomap phase 3 79568/11017767 inos 
scanned, 120 seconds elaps
ed
[...]
/usr/local/bin/xfsdump: status at 13:10:58: inomap phase 3 1890564/11017767 
inos scanned, 841 seconds elapsed
/usr/local/bin/xfsdump: ino map construction complete
/usr/local/bin/xfsdump: estimated dump size: 5617536 bytes
/usr/local/bin/xfsdump: Media op: begin media file
/usr/local/bin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/local/bin/xfsdump: dumping ino map
/usr/local/bin/xfsdump: flushing write buf addr 0xb7e58000 size 0x40000
[...]
/usr/local/bin/xfsdump: flushing write buf addr 0xb7e58000 size 0x40000
/usr/local/bin/xfsdump: dumping directories
/usr/local/bin/xfsdump: dumping non-directory files
/usr/local/bin/xfsdump: status at 13:44:48: 1/2 files dumped, 31.6% data 
dumped, 2871 seconds elapsed
[...]
/usr/local/bin/xfsdump: status at 14:02:57: 2/2 files dumped, 44.5% data 
dumped, 3960 seconds elapsed
/usr/local/bin/xfsdump: ending media file
/usr/local/bin/xfsdump: Media op: end media file
/usr/local/bin/xfsdump: flushing write buf addr 0xb7e58000 size 0x1a6b8
/usr/local/bin/xfsdump: media file size 5613240 bytes
/usr/local/bin/xfsdump: dump size (non-dir files) : 3648 bytes
/usr/local/bin/xfsdump: dump complete: 3999 seconds elapsed
/usr/local/bin/xfsdump: Dump Status: SUCCESS
10963+1 records in
10963+1 records out
5613240 bytes transferred in 3998.904421 seconds (1404 bytes/sec)

real    66m38.933s
user    0m2.882s
sys     0m36.289s

Regards,
Daniele
