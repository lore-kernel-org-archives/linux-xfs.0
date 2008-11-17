Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAHEhkZH022785 for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 06:43:46 -0800
Received: from suzel.prosodie.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41EAD1589537
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 06:43:44 -0800 (PST)
Received: from suzel.prosodie.net (suzel.prosodie.net [213.139.100.41]) by
	cuda.sgi.com with ESMTP id hGb2dltyUvlwlGsd for
	<xfs@oss.sgi.com>; Mon, 17 Nov 2008 06:43:44 -0800 (PST)
Received: from DAVIDA.france.prosodie.local (unknown [172.17.18.44])
	by suzel.prosodie.net (Postfix) with ESMTP id ACA913B4455
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 15:43:43 +0100 (CET)
MIME-Version: 1.0
Subject: xfs_repair fail on arm based nas
Date: Mon, 17 Nov 2008 15:43:26 +0100
Message-ID: <B05F4A1DC32A064D991D31A878D8D2A710A0ED73@DAVIDA.france.prosodie.local>
From: "Tsapline Sylvain" <stsapline@prosodie.com>
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

hi
 
I own a arm9 based processor nas running on debian 4.
 
I had some issu with ISO on it so i decided to run some checks on it.
 
I ran xfs_check and the command show a lots of unreadable characters, I
had to disconnect the console because it became unusable.
 
I use xfs_repair on the volume and it did not find any superblock at
first eventually find a secondary and ask me to remount the partition to
run the logs.
 
Wich I tried and it didn't work, so as recommended i ran xfs_repair -L
to clear the logs.
It ended with a segmentation fault on stage 3, the version shipped with
debian stable is curently xfs_repair version 2.8.11
 
I download xfsprogs version xfs_repair version 2.10.1 and now I got the
following error (see log below)
 
Does anyone has a tip for me ? I'm feeling very confused about the
options left to retrieve my data.
 
 
 ./xfs_repair /dev/sda6
Phase 1 - find and verify superblock...
couldn't verify primary superblock - not enough secondary superblocks
with matching geometry !!!
 
attempting to find secondary superblock...
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
........................................................................
.................................................found candidate
secondary superblock...
verified secondary superblock...
writing modified primary superblock
sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 128
resetting superblock root inode pointer to 128
sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 129
resetting superblock realtime bitmap ino pointer to 129
sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 130
resetting superblock realtime summary ino pointer to 130
Phase 2 - using internal log
        - zero log...
XFS: Log inconsistent (didn't find previous header)
XFS: failed to find log head
zero_log: cannot find log head/tail (xlog_find_tail=5), zeroing it
anyway
        - scan filesystem freespace and inode maps...
bad magic # 0x60000 for agf 0
bad version # 536870912 for agf 0
bad length 0 for agf 0, should be 1048576
reset bad agf for ag 0
bad agbno 0 for btbno root, agno 0
bad agbno 0 for btbcnt root, agno 0
bad magic # 0x98f91a40 for agi 99
bad version # -1728505280 for agi 99
bad sequence # -1 for agi 99
bad length # -1 for agi 99, should be 1048576
reset bad agi for ag 99
bad magic # 0x41425442 in inobt block 99/1
expected level 62667 got 0 in inobt block 99/1
inode btree block claimed (state 7), agno 99, bno 1, suspect 0
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
bad magic # 0xed986abe in inobt block 99/1048507
bad magic # 0x20202020 in inobt block 99/69
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
xfs_repair: phase3.c:122: process_agi_unlinked: Assertion `no_modify ||
(((0) == 1) ? (agip->agi_seqno) : ((sizeof((agip->agi_seqno)) == 8) ?
((typeof((agip->agi_seqno)))((__builtin_constant_p((__u64)((__u64)((agip
->agi_seqno)))) ? ({ __u64 __x = (((__u64)((agip->agi_seqno))));
((__u64)( (__u64)(((__u64)(__x) & (__u64)0x00000000000000ffULL) << 56) |
(__u64)(((__u64)(__x) & (__u64)0x000000000000ff00ULL) << 40) |
(__u64)(((__u64)(__x) & (__u64)0x0000000000ff0000ULL) << 24) |
(__u64)(((__u64)(__x) & (__u64)0x00000000ff000000ULL) << 8) |
(__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >> 8) |
(__u64)(((__u64)(__x) & (__u64)0x0000ff0000000000ULL) >> 24) |
(__u64)(((__u64)(__x) & (__u64)0x00ff000000000000ULL) >> 40) |
(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56) )); }) :
__fswab64(((__u64)((agip->agi_seqno))))))) : ((sizeof((agip->agi_seqno))
== 4) ?
((typeof((agip->agi_seqno)))((__builtin_constant_p((__u32)((__u32)((agip
->agi_seqno)))) ? ({ __u32 __x = (((__u32)((agip->agi_seqno))));
((__u32)( (((__u32)(__x) & (__u32)0x000000ffUL) << 24) | (((__u32)(__x)
& (__u32)0x0000ff00UL) << 8) | (((__u32)(__x) & (__u32)0x00ff0000UL) >>
8) | (((__u32)(__x) & (__u32)0xff000000UL) >> 24) )); }) :
__fswab32(((__u32)((agip->agi_seqno))))))) : ((sizeof((agip->agi_seqno))
== 2) ?
((typeof((agip->agi_seqno)))((__builtin_constant_p((__u16)((__u16)((agip
->agi_seqno)))) ? ({ __u16 __x = (((__u16)((agip->agi_seqno))));
((__u16)( (((__u16)(__x) & (__u16)0x00ffU) << 8) | (((__u16)(__x) &
(__u16)0xff00U) >> 8) )); }) :
__fswab16(((__u16)((agip->agi_seqno))))))) : ((agip->agi_seqno))))) ) ==
agno' failed.
Aborted
 

Sylvain Nemtua



[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
