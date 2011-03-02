Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p22HtB7F036242 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 11:55:12 -0600
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 243AC30B86F
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 09:57:59 -0800 (PST)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id vbJrRlRiNK4DZ4tt for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2011 09:57:59 -0800 (PST)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PuqJC-0007Xg-7b
	for xfs@oss.sgi.com; Wed, 02 Mar 2011 17:57:58 +0000
Received: from [10.0.0.20] (helo=yama)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PuqJB-0001eO-W3
	for xfs@oss.sgi.com; Wed, 02 Mar 2011 17:57:58 +0000
Received: from root by yama with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1PuqJA-00029c-Ux
	for xfs@oss.sgi.com; Wed, 02 Mar 2011 18:57:57 +0100
Date: Wed, 2 Mar 2011 18:57:56 +0100
From: Marc Lehmann <schmorp@schmorp.de>
Subject: corruption, xfs_repair 3.1.4 segfaults
Message-ID: <20110302175756.GA8279@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi!

I had a case of filesystem corruption a day ago:

Mar  1 21:31:28 doom kernel: [566626.329885] ffff880082a8f400: f3 6e 16 9b 4e ae cd 1c 49 75 21 65 86 c0 8c 3a  .n..N...Iu!e...:
2/debian/build/source_amd64_none/fs/xfs/xfs_btree.c.  Caller 0xffffffffa10721d0
Mar  1 21:31:28 doom kernel: [566626.329902] Filesystem "loop18": XFS internal error xfs_btree_check_sblock at line 124 of file /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.3
Mar  1 21:31:28 doom kernel: [566626.329909] 
Mar  1 21:31:28 doom kernel: [566626.329918] Pid: 27165, comm: expire Tainted: P         C 2.6.32-5-amd64 #1
Mar  1 21:31:28 doom kernel: [566626.329923] Call Trace:
Mar  1 21:31:28 doom kernel: [566626.329973]  [<ffffffffa10721d0>] ? xfs_btree_read_buf_block+0x6d/0x8f [xfs]
Mar  1 21:31:28 doom kernel: [566626.330005]  [<ffffffffa10720a7>] ? xfs_btree_check_sblock+0xbd/0xc4 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330037]  [<ffffffffa10721d0>] ? xfs_btree_read_buf_block+0x6d/0x8f [xfs]
Mar  1 21:31:28 doom kernel: [566626.330068]  [<ffffffffa10721d0>] ? xfs_btree_read_buf_block+0x6d/0x8f [xfs]
Mar  1 21:31:28 doom kernel: [566626.330100]  [<ffffffffa10731d7>] ? xfs_btree_lookup_get_block+0x87/0xac [xfs]
Mar  1 21:31:28 doom kernel: [566626.330132]  [<ffffffffa107379d>] ? xfs_btree_lookup+0x12a/0x3cc [xfs]
Mar  1 21:31:28 doom kernel: [566626.330166]  [<ffffffffa109d70e>] ? kmem_zone_zalloc+0x1e/0x2e [xfs]
Mar  1 21:31:28 doom kernel: [566626.330194]  [<ffffffffa10620e2>] ? xfs_allocbt_init_cursor+0x35/0x91 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330222]  [<ffffffffa105fe75>] ? xfs_free_ag_extent+0x5b/0x665 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330251]  [<ffffffffa1061c2f>] ? xfs_free_extent+0x9a/0xb8 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330284]  [<ffffffffa10989fa>] ? xfs_trans_get_efd+0x21/0x29 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330315]  [<ffffffffa106d02a>] ? xfs_bmap_finish+0xef/0x162 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330349]  [<ffffffffa1087050>] ? xfs_itruncate_finish+0x17d/0x295 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330383]  [<ffffffffa109bf69>] ? xfs_inactive+0x1d4/0x3f0 [xfs]
Mar  1 21:31:28 doom kernel: [566626.330395]  [<ffffffff810fff23>] ? clear_inode+0x79/0xd0
Mar  1 21:31:28 doom kernel: [566626.330403]  [<ffffffff8110066c>] ? generic_delete_inode+0xf4/0x168
Mar  1 21:31:28 doom kernel: [566626.330411]  [<ffffffff810f935c>] ? do_unlinkat+0xf7/0x149
Mar  1 21:31:28 doom kernel: [566626.330419]  [<ffffffff810ef19e>] ? sys_write+0x60/0x6e
Mar  1 21:31:28 doom kernel: [566626.330428]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
amd64_none/fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa106d05f
Mar  1 21:31:28 doom kernel: [566626.330448] xfs_force_shutdown(loop18,0x8) called from line 4341 of file /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.32/debian/build/source_
Mar  1 21:31:28 doom kernel: [566626.342806] Filesystem "loop18": Corruption of in-memory data detected.  Shutting down filesystem: loop18
Mar  1 21:31:28 doom kernel: [566626.342819] Please umount the filesystem, and rectify the problem(s)

I tried to use xfs_repair on it, but it crashes (and, as I may grudgingly
add, as usual it crashes because thats what xfsrepair does almost always).

The xfs_repair is from debians xfsprogs 3.1.4, and here is an strace just
before it crashes:

   pread(4, "IN\201\200\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\6"..., 8192, 125284311040) = 8192
   pread(4, "IN\201\200\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\6"..., 8192, 125284319232) = 8192
   pread(4, "IN\201\200\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\6"..., 8192, 125284327424) = 8192
   pread(4, "IN\201\200\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\10"..., 8192, 125284483072) = 8192
   pread(4, "INA\300\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\f"..., 8192, 125284491264) = 8192
   pread(4, "XD2D\0000\17\320\0\0\0\0\0\0\0\0\0\0\0\0 \17q\234\1.\\\237\321\16\0\20"..., 4096, 126276620288) = 4096
   pread(4, "XD2D\0\340\0010\0\20\0\300\2\340\0\260\377\377\0\300\223\370_\347\003508\0\311\0\20"..., 4096, 126284730880) = 4096
   pread(4, "XD2D\t \6\340\3`\1\200\0\240\1p\377\377\0\20\223\370\251\235\003763\0\0\0\20"..., 4096, 126284970496) = 4096
   pread(4, "XD2D\0000\7\200\t\20\0\360\n\20\0\360\0\0\0\0 \17q\237\1.+\2000\214\0\20"..., 4096, 126333133824) = 4096
   pread(4, "XD2D\1`\16\240\0\20\1@\0\0\0\0\377\377\1@\224\254\204,\003253\0\311\0\20"..., 4096, 126338785792) = 4096
   pread(4, "XD2D\6\360\t\20\0\20\5\340\0060\0\260\377\377\5\340\224\255\7d\003508\0\0\0\20"..., 4096, 126341941760) = 4096
   pread(4, "XD2D\10\340\7 \0000\4\260\6\220\2@\0\0\0\0 \17q\240\1.\21y\0\210\0\20"..., 4096, 126343030272) = 4096
   pread(4, "XD2D\0\20\t\300\t\340\6 \0\0\0\0\377\377\t\300\225\37t\346\003253\0\210\0\20"..., 4096, 126343054848) = 4096
   pread(4, "XD2D\0000\17\320\0\0\0\0\0\0\0\0\0\0\0\0 \17q\242\1.\0\0\0\0\0\20"..., 4096, 125026532864) = 4096
   pread(4, "XD2D\7p\10\220\0\20\5@\6\360\0 \377\377\5@\226\fi\275\003508\0\0\0\20"..., 4096, 125026524672) = 4096
   mmap(NULL, 3107426304, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f84388d1000
   pread(4, 0x7f84388d1200, 18446744072522006528, 51859947520) = -1 EFAULT (Bad address)
   open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
   open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
   open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
   open("/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
   open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
   open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
   write(2, "xfs_repair: read failed: Bad add"..., 37) = 37
   --- SIGSEGV (Segmentation fault) @ 0 (0) ---

apparently an mmap goes wrong (and if mmap fails, xfs_repair crashes here
already), and then it tries to read a block beyond the end of the device,
and then crashes.

Any idea on where to go from here? I tried to build the git xfsprogs, but
they don't build due to missing -fPIC - and as usual, thanks for any help :)

Here is the output from the xfs_repair run:

xfs_repair -m 990 -P /dev/loop18
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
bad magic # 0x103404f in btbno block 9/10857
expected level 0 got 33692 in btbno block 9/10857
bad btree nrecs (42150, min=31, max=62) in btbno block 9/10857
invalid start block 2293577425 in record 0 of 4629836 btree block 9/10857
invalid start block 2285812568 in record 1 of 4629836 btree block 9/10857
invalid start block 1881255310 in record 2 of 4629836 btree block 9/10857
invalid start block 3446559310 in record 3 of 4629836 btree block 9/10857
invalid start block 675798585 in record 4 of 4629836 btree block 9/10857
invalid start block 1988423791 in record 5 of 4629836 btree block 9/10857
invalid start block 1478079706 in record 6 of 4629836 btree block 9/10857
invalid start block 988724204 in record 7 of 4629836 btree block 9/10857
invalid start block 2507314510 in record 8 of 4629836 btree block 9/10857
invalid start block 2971518545 in record 9 of 4629836 btree block 9/10857
invalid start block 690057367 in record 10 of 4629836 btree block 9/10857
invalid start block 2865073461 in record 11 of 4629836 btree block 9/10857
invalid start block 1912136343 in record 12 of 4629836 btree block 9/10857
invalid start block 2593100555 in record 13 of 4629836 btree block 9/10857
invalid start block 1890364231 in record 14 of 4629836 btree block 9/10857
invalid start block 1138733060 in record 15 of 4629836 btree block 9/10857
invalid start block 1780107146 in record 16 of 4629836 btree block 9/10857
invalid start block 2459595538 in record 17 of 4629836 btree block 9/10857
invalid length 967647152 in record 18 of 4629836 btree block 9/10857
invalid start block 2356139990 in record 19 of 4629836 btree block 9/10857
invalid start block 3025317822 in record 20 of 4629836 btree block 9/10857
invalid start block 2576064389 in record 21 of 4629836 btree block 9/10857
invalid start block 2951059818 in record 22 of 4629836 btree block 9/10857
invalid start block 318397717 in record 23 of 4629836 btree block 9/10857
invalid start block 433828196 in record 24 of 4629836 btree block 9/10857
block (9,33424265-33424265) multiply claimed by bno space tree, state - 7
block (9,56547788-56547788) multiply claimed by bno space tree, state - 7
block (9,67118454-67118454) multiply claimed by bno space tree, state - 7
block (9,67118456-67118456) multiply claimed by bno space tree, state - 7
block (9,67118459-67118459) multiply claimed by bno space tree, state - 7
block (9,67118462-67118462) multiply claimed by bno space tree, state - 7
block (9,67118511-67118512) multiply claimed by bno space tree, state - 7
block (9,67118515-67118515) multiply claimed by bno space tree, state - 7
[... lots of similar lines snipped...]
invalid start block 3236179925 in record 57 of 4629832 btree block 9/10795
invalid start block 410235468 in record 58 of 4629832 btree block 9/10795
invalid start block 3353408206 in record 59 of 4629832 btree block 9/10795
invalid start block 1222326613 in record 60 of 4629832 btree block 9/10795
invalid start block 1521123165 in record 61 of 4629832 btree block 9/10795
cnt freespace btree block claimed (state 1), agno 9, bno 56547789, suspect 0
agf_freeblks 7328791, counted 4374413 in ag 9
agf_longest 32866, counted 4292013384 in ag 9
sb_icount 0, counted 4854528
sb_ifree 0, counted 328679
sb_fdblocks 0, counted 4487315964
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
xfs_repair: read failed: Bad address

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
