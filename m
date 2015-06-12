Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A722F7F47
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 05:15:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79684304048
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 03:15:33 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	suqHkBAecI5AzlTB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 03:15:30 -0700 (PDT)
Received: by wibdq8 with SMTP id dq8so12626761wib.1
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 03:15:29 -0700 (PDT)
MIME-Version: 1.0
From: Lampa <lampacz@gmail.com>
Date: Fri, 12 Jun 2015 12:14:49 +0200
Message-ID: <CAG_XuNWrbyb97h3moqgYJLdvMr3J1OPGb2VknDTpcO0-8upMnw@mail.gmail.com>
Subject: xfs_repair use all memory
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

i have 8TB filesystem but unable to check it or repair

df -h
/dev/mapper/vg0-data                                       8,0T  7,5T
525G  94% /home

df -i
/dev/mapper/vg0-data                                   1717983616
106594156 1611389460    7% /home

I got lot of "XFS (dm-0): xfs_log_force: error 5 returned" in log

trying to repair (check) filesystem but xfs repair is always killed by
oom - it use all memory (8GB).

xfs_repair -V
xfs_repair version 3.1.7

xfs_repair -n -m 2048 -vv /dev/mapper/vg0-data
Phase 1 - find and verify superblock...
        - max_mem = 2097152, icount = 109324864, imem = 427050, dblock
= 2147479552, dmem = 1048574
        - block cache size set to 71440 entries
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
libxfs_bcache: 0x147c4c0
Max supported entries = 71440
Max utilized entries = 11839
Active entries = 11839
Hash table size = 8930
Hits = 0
Misses = 11839
Hit ratio =  0,00
MRU 0 entries =  11839 (100%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries   3161 (  0%)
Hash buckets with   1 entries   2587 ( 21%)
Hash buckets with   2 entries   1615 ( 27%)
Hash buckets with   3 entries    823 ( 20%)
Hash buckets with   4 entries    416 ( 14%)
Hash buckets with   5 entries    203 (  8%)
Hash buckets with   6 entries     62 (  3%)
Hash buckets with   7 entries     35 (  2%)
Hash buckets with   8 entries     15 (  1%)
Hash buckets with   9 entries      6 (  0%)
Hash buckets with  10 entries      2 (  0%)
Hash buckets with  11 entries      2 (  0%)
Hash buckets with  12 entries      1 (  0%)
Hash buckets with  14 entries      1 (  0%)
Hash buckets with  15 entries      1 (  0%)
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
doubling cache size to 142880
doubling cache size to 285760
data fork in ino 700711615 claims free block 43794495
data fork in ino 700711615 claims free block 43794496
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
libxfs_bcache: 0x147c4c0
Max supported entries = 285760
Max utilized entries = 285760
Active entries = 285705
Hash table size = 8930
Hits = 26843840
Misses = 34163400
Hit ratio = 44,00
MRU 0 entries =   3933 (  1%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =   2311 (  0%)
MRU 3 entries =  14456 (  5%)
MRU 4 entries =    345 (  0%)
MRU 5 entries =  14955 (  5%)
MRU 6 entries = 216435 ( 75%)
MRU 7 entries =   3442 (  1%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =   5852 (  2%)
MRU 12 entries =    232 (  0%)
MRU 13 entries =  23545 (  8%)
MRU 14 entries =    199 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   9 entries      2 (  0%)
Hash buckets with  10 entries      5 (  0%)
Hash buckets with  11 entries      4 (  0%)
Hash buckets with  12 entries     13 (  0%)
Hash buckets with  13 entries      8 (  0%)
Hash buckets with  14 entries     22 (  0%)
Hash buckets with  15 entries     31 (  0%)
Hash buckets with  16 entries     75 (  0%)
Hash buckets with  17 entries     86 (  0%)
Hash buckets with  18 entries    112 (  0%)
Hash buckets with  19 entries    128 (  0%)
Hash buckets with  20 entries    200 (  1%)
Hash buckets with  21 entries    218 (  1%)
Hash buckets with  22 entries    274 (  2%)
Hash buckets with  23 entries    292 (  2%)
Hash buckets with  24 entries    342 (  2%)
Hash buckets with >24 entries   7118 ( 86%)
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
doubling cache size to 571520
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
libxfs_bcache: 0x147c4c0
Max supported entries = 571520
Max utilized entries = 571520
Active entries = 571506
Hash table size = 8930
Hits = 51552448
Misses = 71034716
Hit ratio = 42,05
MRU 0 entries =  16024 (  2%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =   9154 (  1%)
MRU 3 entries =  83965 ( 14%)
MRU 4 entries =    517 (  0%)
MRU 5 entries =    155 (  0%)
MRU 6 entries = 435429 ( 76%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =   8709 (  1%)
MRU 12 entries =    521 (  0%)
MRU 13 entries =  16818 (  2%)
MRU 14 entries =    214 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with >24 entries   8930 (100%)
No modify flag set, skipping phase 5
libxfs_bcache: 0x147c4c0
Max supported entries = 571520
Max utilized entries = 571520
Active entries = 571506
Hash table size = 8930
Hits = 51552448
Misses = 71034716
Hit ratio = 42,05
MRU 0 entries =  16024 (  2%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =   9154 (  1%)
MRU 3 entries =  83965 ( 14%)
MRU 4 entries =    517 (  0%)
MRU 5 entries =    155 (  0%)
MRU 6 entries = 435429 ( 76%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =   8709 (  1%)
MRU 12 entries =    521 (  0%)
MRU 13 entries =  16818 (  2%)
MRU 14 entries =    214 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with >24 entries   8930 (100%)
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - agno = 0
doubling cache size to 1143040
Killed (SIGKILL)

-- 
Lampa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
