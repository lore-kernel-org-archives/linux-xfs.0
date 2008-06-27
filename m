Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 03:12:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RACqK9009670
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 03:12:54 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DD3DD64D52
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 03:13:52 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id jorJNRJ5bmlDfvln for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 03:13:52 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id 060288E00BE
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 03:16:16 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (BBY1EXG02.pmc-sierra.bc.ca [216.241.231.167])
	by bby1mta02.pmc-sierra.bc.ca (Postfix) with SMTP id E7B618E00B1
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 03:16:15 -0700 (PDT)
Message-ID: <4864BD5D.1050202@pmc-sierra.com>
Date: Fri, 27 Jun 2008 15:43:49 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed>
In-Reply-To: <20080626070215.GI11558@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Dave Chinner wrote:
> [please wrap your replies at 72 columns]
>
> On Wed, Jun 25, 2008 at 11:46:59PM -0700, Sagar Borikar wrote:
>   
>
> Yes, but all the same pattern of corruption, so it is likely
> that it is one problem.
>
>   
> All I can suggest is working out a reproducable test case in your
> development environment, attaching a debugger and start digging around
> in memory when the problem is hit and try to find out exactly what
> is corrupted. If you can't reproduce it or work out what is
> occurring to trigger the problem, then we're not going to be able to
> find the cause...
>
> Cheers,
>
> Dave.
>   
Thanks Dave
I did some experiments today with the corrupted filesystem.
setup : NAS box contains one volume /share and 10 subdirectories.
In first subdirectory sh1, I kept 512MB file. Through a script I 
continuously copy this file
simultaneously from sh2 to sh10 subdirectories.
The script looks like
....
while [ 1 ]
do
cp $1 $2
done


And when I check the process status using top, almost all the cp 
processes are in
uninterruptible sleep state continuously.  Ran xfs_repair with -n option 
on filesystem mounted on JBOD
Here is the output :



Fri Jun 27 02:13:01 2008
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
bad nblocks 8788 for inode 33554562, would reset to 15461
bad nextents 18 for inode 33554562, would reset to 32
        - agno = 2
entry "iozone_68.tst" in shortform directory 67108993 references free 
inode 67108995
would have junked entry "iozone_68.tst" in directory inode 67108993
data fork in ino 67108995 claims dup extent, off - 252, start - 
14711445, cnt 576
bad data fork in inode 67108995
would have cleared inode 67108995
        - agno = 3
entry "iozone_68.tst" in shortform directory 100663425 references free 
inode 100663427
would have junked entry "iozone_68.tst" in directory inode 100663425
inode 100663427 - bad extent starting block number 906006917242880, 
offset 2533274882670609
bad data fork in inode 100663427
would have cleared inode 100663427
        - agno = 4
bad nblocks 10214 for inode 134217859, would reset to 16761
bad nextents 22 for inode 134217859, would reset to 34
        - agno = 5
bad nblocks 23581 for inode 167772290, would reset to 27557
bad nextents 39 for inode 167772290, would reset to 45
        - agno = 6
bad nblocks 14527 for inode 201326722, would reset to 15697
bad nextents 31 for inode 201326722, would reset to 34
bad nblocks 12633 for inode 201326723, would reset to 16647
bad nextents 23 for inode 201326723, would reset to 35
        - agno = 7
bad nblocks 26638 for inode 234881154, would reset to 27557
bad nextents 53 for inode 234881154, would reset to 54
bad nblocks 85653 for inode 234881155, would reset to 85664
bad nextents 310 for inode 234881155, would reset to 311
        - agno = 8
bad nblocks 23241 for inode 268640387, would reset to 27565
bad nextents 32 for inode 268640387, would reset to 42
bad nblocks 81766 for inode 268640388, would reset to 86012
bad nextents 332 for inode 268640388, would reset to 344
        - agno = 9
entry "iozone_68.tst" in shortform directory 301990016 references free 
inode 301990019
would have junked entry "iozone_68.tst" in directory inode 301990016
data fork in ino 301990019 claims dup extent, off - 26402, start - 
19129002, cnt 450
bad data fork in inode 301990019
would have cleared inode 301990019
bad nblocks 70282 for inode 301990020, would reset to 71793
bad nextents 281 for inode 301990020, would reset to 294
        - agno = 10
entry "iozone_68.tst" in shortform directory 335544448 references free 
inode 335544451
would have junked entry "iozone_68.tst" in directory inode 335544448
bad nblocks 11261 for inode 335544451, would reset to 19853
bad nextents 24 for inode 335544451, would reset to 41
imap claims in-use inode 335544451 is free, correcting imap
bad nblocks 119952 for inode 335544452, would reset to 121178
bad nextents 301 for inode 335544452, would reset to 312
        - agno = 11
bad nblocks 24361 for inode 369098883, would reset to 29553
bad nextents 51 for inode 369098883, would reset to 57
bad nblocks 3173 for inode 369098884, would reset to 5851
bad nextents 10 for inode 369098884, would reset to 18
        - agno = 12
entry "iozone_68.tst" in shortform directory 402653313 references free 
inode 402653318
would have junked entry "iozone_68.tst" in directory inode 402653313
bad nblocks 16348 for inode 402653317, would reset to 21485
bad nextents 28 for inode 402653317, would reset to 37
data fork in ino 402653318 claims dup extent, off - 124142, start - 
29379669, cnt 2
bad data fork in inode 402653318
would have cleared inode 402653318
        - agno = 13
bad nblocks 18374 for inode 436207747, would reset to 19991
bad nextents 43 for inode 436207747, would reset to 47
bad nblocks 38390 for inode 436207748, would reset to 38914
bad nextents 300 for inode 436207748, would reset to 304
        - agno = 14
bad nblocks 20267 for inode 469762178, would reset to 23089
bad nextents 41 for inode 469762178, would reset to 45
        - agno = 15
entry "iozone_68.tst" in shortform directory 503316608 references free 
inode 503316609
would have junked entry "iozone_68.tst" in directory inode 503316608
imap claims in-use inode 503316609 is free, correcting imap
libxfs_bcache: 0x100020b0
Max supported entries = 524288
Max utilized entries = 562
Active entries = 562
Hash table size = 65536
Hits = 1009
Misses = 564
Hit ratio = 64.00
Hash buckets with   0 entries 65116 (  0%)
Hash buckets with   1 entries   391 ( 69%)
Hash buckets with   2 entries    20 (  7%)
Hash buckets with   3 entries     1 (  0%)
Hash buckets with  15 entries     1 (  2%)
Hash buckets with  16 entries     6 ( 17%)
Hash buckets with  17 entries     1 (  3%)
Fri Jun 27 02:13:08 2008
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem starting at / ...
        - agno = 0
        - agno = 1
        - agno = 2
entry "iozone_68.tst" in shortform directory inode 67108993 points to 
free inode 67108995
would junk entry "iozone_68.tst"
        - agno = 3
entry "iozone_68.tst" in shortform directory inode 100663425 points to 
free inode 100663427
would junk entry "iozone_68.tst"
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
entry "iozone_68.tst" in shortform directory inode 301990016 points to 
free inode 301990019
would junk entry "iozone_68.tst"
        - agno = 10
        - agno = 11
        - agno = 12
entry "iozone_68.tst" in shortform directory inode 402653313 points to 
free inode 402653318
would junk entry "iozone_68.tst"
        - agno = 13
        - agno = 14
        - agno = 15
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
libxfs_icache: 0x10002050
Max supported entries = 524288
Max utilized entries = 42
Active entries = 42
Hash table size = 65536
Hits = 0
Misses = 42
Hit ratio =  0.00
Hash buckets with   0 entries 65524 (  0%)
Hash buckets with   1 entries     9 ( 21%)
Hash buckets with   6 entries     1 ( 14%)
Hash buckets with  12 entries     1 ( 28%)
Hash buckets with  15 entries     1 ( 35%)
libxfs_bcache: 0x100020b0
Max supported entries = 524288
Max utilized entries = 562
Active entries = 17
Hash table size = 65536
Hits = 1035
Misses = 581
Hit ratio = 64.00
Hash buckets with   0 entries 65533 (  0%)
Hash buckets with   1 entries     2 ( 11%)
Hash buckets with  15 entries     1 ( 88%)
Fri Jun 27 02:13:10 2008
Phase 7 - verify link counts...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
libxfs_icache: 0x10002050
Max supported entries = 524288
Max utilized entries = 42
Active entries = 42
Hash table size = 65536
Hits = 0
Misses = 42
Hit ratio =  0.00
Hash buckets with   0 entries 65524 (  0%)
Hash buckets with   1 entries     9 ( 21%)
Hash buckets with   6 entries     1 ( 14%)
Hash buckets with  12 entries     1 ( 28%)
Hash buckets with  15 entries     1 ( 35%)
libxfs_bcache: 0x100020b0
Max supported entries = 524288
Max utilized entries = 562
Active entries = 16
Hash table size = 65536
Hits = 1051
Misses = 597
Hit ratio = 63.00
Hash buckets with   0 entries 65534 (  0%)
Hash buckets with   1 entries     1 (  6%)
Hash buckets with  15 entries     1 ( 93%)
Fri Jun 27 02:13:17 2008
No modify flag set, skipping filesystem flush and exiting.

So there are  several  bad blocks and extents present in all  ag, which 
are causing the problem.
top output reveals that all cp are in D state
  PID USER     STATUS   RSS  PPID %CPU %MEM COMMAND
 7455 root     R        984  1892  7.4  0.7 top
 6100 root     D        524  1973  2.9  0.4 cp
 6799 root     R        524  1983  2.9  0.4 cp
 6796 root     D        524  2125  2.9  0.4 cp
 6074 root     D        524  2109  1.4  0.4 cp
 6097 root     D        524  1979  1.4  0.4 cp
 6076 root     D        524  1975  1.4  0.4 cp
 6738 root     D        524  2123  1.4  0.4 cp
 6759 root     D        524  2115  1.4  0.4 cp
 7035 root     D        524  1977  1.4  0.4 cp
 7440 root     D        520  1985  1.4  0.4 cp
   73 root     SW<        0     6  1.4  0.0 xfsdatad/0
   67 root     SW         0     6  1.4  0.0 pdflush
...
..
This means that they are waiting for an IO  and sleeping in system call 
but not able
to come out as several inodes are corrupted. And hence the script never 
gets completed.

Thanks
Sagar

   
