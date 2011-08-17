Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7H8gJQk036357 for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 03:42:19 -0500
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D8B618D847C
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 01:42:14 -0700 (PDT)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id CtHDZ0fQPmVlEFKJ for
	<xfs@oss.sgi.com>; Wed, 17 Aug 2011 01:42:14 -0700 (PDT)
Subject: Bug#638158: xfsprogs: Damaged filesystem causes xfs_repair to
	sometimes (but not always) segfault
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.638158.B.131357038111613@bugs.debian.org>
Message-Id: <E1QtbO1-0005u8-5N@eamp.org>
From: "Robert Jacobs" <debbtsb06@eamp.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----- =_aaaaaaaaaa0"
Content-ID: <22694.1313569293.0@eamp.org>
Date: Wed, 17 Aug 2011 01:22:05 -0700
Reply-To: Robert Jacobs <debbtsb06@eamp.org>, 638158@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: submit@bugs.debian.org

------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22694.1313569293.1@eamp.org>

Subject: xfsprogs: Damaged filesystem causes xfs_repair to sometimes (but not always) segfault
Package: xfsprogs
Version: 3.1.5
Severity: normal

*** Please type your report below this line ***

My filesystem was damaged by a series of whole-system crashes, but
after the last one it seems unrecoverably cranky: xfs_repair either
segfaults (what this bug is about) or gives me a "fatal error --
illegal state -1 in block map 20815240".

I've attached the outputs of xfs_check and three different runs of
xfs_repair (with backtrace, when available).

 - Robert Jacobs

-- System Information:
Debian Release: wheezy/sid
  APT prefers unstable
  APT policy: (500, 'unstable'), (500, 'stable')
Architecture: i386 (i686)

Kernel: Linux 3.0.0-1-686-pae (SMP w/1 CPU core)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash

Versions of packages xfsprogs depends on:
ii  libblkid1                     2.19.1-5   block device id library
ii  libc6                         2.13-16    Embedded GNU C Library: Shared lib
ii  libreadline5                  5.2-9      GNU readline and history libraries
ii  libuuid1                      2.19.1-5   Universally Unique ID library

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl                           2.2.51-3   Access control list utilities
ii  attr                          1:2.4.46-3 Utilities for manipulating filesys
pn  quota                         <none>     (no description available)
ii  xfsdump                       3.0.5      Administrative utilities for the X

-- no debconf information



------- =_aaaaaaaaaa0
Content-Type: text/plain; name="xfs_repair.output.localbuild.ggdb.txt";
	charset="us-ascii"
Content-ID: <22694.1313569293.2@eamp.org>

(gdb) b dinode.c:549
Breakpoint 2 at 0x8053c8e: file dinode.c, line 549.
(gdb) R
Starting program: /home/klaws/buildd/xfsprogs-3.1.5/repair/xfs_repair -v -P /dev/sdc1
[Thread debugging using libthread_db enabled]
Phase 1 - find and verify superblock...
        - block cache size set to 61472 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 2 tail block 2
        - scan filesystem freespace and inode maps...
[New Thread 0xb7a98b70 (LWP 28860)]
[New Thread 0xb7297b70 (LWP 28861)]
[New Thread 0xb6a96b70 (LWP 28862)]
[New Thread 0xb6295b70 (LWP 28863)]
[New Thread 0xb5a94b70 (LWP 28864)]
[New Thread 0xb5293b70 (LWP 28865)]
[New Thread 0xb4a92b70 (LWP 28866)]
[New Thread 0xb4291b70 (LWP 28867)]
[New Thread 0xb3a90b70 (LWP 28868)]
[New Thread 0xb328fb70 (LWP 28869)]
[New Thread 0xb2a8eb70 (LWP 28870)]
[New Thread 0xb228db70 (LWP 28871)]
[New Thread 0xb1a8cb70 (LWP 28872)]
[New Thread 0xb128bb70 (LWP 28873)]
[New Thread 0xb0a8ab70 (LWP 28874)]
[New Thread 0xb0289b70 (LWP 28875)]
[New Thread 0xafa88b70 (LWP 28876)]
[New Thread 0xaf287b70 (LWP 28877)]
[New Thread 0xaea86b70 (LWP 28878)]
[New Thread 0xae285b70 (LWP 28879)]
[New Thread 0xada84b70 (LWP 28880)]
[New Thread 0xad283b70 (LWP 28881)]
[New Thread 0xaca82b70 (LWP 28882)]
[New Thread 0xac281b70 (LWP 28883)]
[New Thread 0xaba80b70 (LWP 28884)]
[New Thread 0xab27fb70 (LWP 28885)]
[New Thread 0xaaa7eb70 (LWP 28886)]
[New Thread 0xaa27db70 (LWP 28887)]
[New Thread 0xa9a7cb70 (LWP 28888)]
[New Thread 0xa927bb70 (LWP 28889)]
[New Thread 0xa8a7ab70 (LWP 28890)]
[New Thread 0xa8279b70 (LWP 28891)]
[Thread 0xafa88b70 (LWP 28876) exited]
[Thread 0xada84b70 (LWP 28880) exited]
[Thread 0xaba80b70 (LWP 28884) exited]
[Thread 0xac281b70 (LWP 28883) exited]
[Thread 0xa9a7cb70 (LWP 28888) exited]
[Thread 0xaea86b70 (LWP 28878) exited]
[Thread 0xaa27db70 (LWP 28887) exited]
[Thread 0xb128bb70 (LWP 28873) exited]
[Thread 0xaca82b70 (LWP 28882) exited]
[Thread 0xab27fb70 (LWP 28885) exited]
[Thread 0xaf287b70 (LWP 28877) exited]
[Thread 0xb328fb70 (LWP 28869) exited]
[Thread 0xb1a8cb70 (LWP 28872) exited]
[Thread 0xaaa7eb70 (LWP 28886) exited]
[Thread 0xb7297b70 (LWP 28861) exited]
[Thread 0xa8a7ab70 (LWP 28890) exited]
[Thread 0xad283b70 (LWP 28881) exited]
[Thread 0xb3a90b70 (LWP 28868) exited]
[Thread 0xb5a94b70 (LWP 28864) exited]
[Thread 0xb7a98b70 (LWP 28860) exited]
[Thread 0xb6a96b70 (LWP 28862) exited]
[Thread 0xb4291b70 (LWP 28867) exited]
[Thread 0xb0289b70 (LWP 28875) exited]
[Thread 0xb4a92b70 (LWP 28866) exited]
[Thread 0xae285b70 (LWP 28879) exited]
[Thread 0xb0a8ab70 (LWP 28874) exited]
[Thread 0xa927bb70 (LWP 28889) exited]
[Thread 0xb2a8eb70 (LWP 28870) exited]
[Thread 0xa8279b70 (LWP 28891) exited]
[Thread 0xb228db70 (LWP 28871) exited]
[Thread 0xb6295b70 (LWP 28863) exited]
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
[Thread 0xb5293b70 (LWP 28865) exited]
        - agno = 1
bad magic number 0x0 on inode 65462593
bad version number 0x0 on inode 65462593
bad magic number 0x694e on inode 65462594
bad version number 0x21 on inode 65462594
bad magic number 0x2000 on inode 65462595
bad version number 0x20 on inode 65462595
inode 65462595 has RT flag set but there is no RT deviceinode 65462595 not rt bitmapbad magic number 0x4e45 on inode 65462596
bad version number 0xd on inode 65462596
bad inode format in inode 65462596
bad magic number 0x46b0 on inode 65462598
bad version number 0x12 on inode 65462598
bad inode format in inode 65462598
bad magic number 0x4ce1 on inode 65462600
bad version number 0xa on inode 65462600
bad inode format in inode 65462600
bad magic number 0x4ce1 on inode 65462602
bad version number 0xc on inode 65462602
bad inode format in inode 65462602
bad magic number 0x4ce1 on inode 65462603
bad version number 0xd on inode 65462603
bad inode format in inode 65462603
bad magic number 0x4ce1 on inode 65462605
bad version number 0x9 on inode 65462605
bad inode format in inode 65462605
bad magic number 0x46b0 on inode 65462607
bad version number 0x7 on inode 65462607
bad inode format in inode 65462607
bad magic number 0x4ce1 on inode 65462609
bad version number 0x9 on inode 65462609
bad inode format in inode 65462609
bad magic number 0x4ce1 on inode 65462610
bad version number 0xa on inode 65462610
bad inode format in inode 65462610
bad magic number 0x694e on inode 65462612
bad version number 0x21 on inode 65462612
bad magic number 0x2000 on inode 65462613
bad version number 0x20 on inode 65462613
bad magic number 0x694e on inode 65462614
bad version number 0x21 on inode 65462614
bad magic number 0x694e on inode 65462616
bad version number 0x21 on inode 65462616
bad magic number 0x2000 on inode 65462618
bad version number 0x20 on inode 65462618
bad magic number 0x2000 on inode 65462620
bad version number 0x20 on inode 65462620
bad magic number 0x4ce1 on inode 65462621
bad version number 0x11 on inode 65462621
bad inode format in inode 65462621
bad magic number 0x2000 on inode 65462622
bad version number 0x20 on inode 65462622
bad magic number 0x694e on inode 65462623
bad version number 0x21 on inode 65462623
zero length entry in shortform dir 65462592, junking 255 entries
corrected entry count in directory 65462592, was 32, now 0
corrected directory 65462592 size, was 69, now 6
bad magic number 0x0 on inode 65462593, resetting magic number
bad version number 0x0 on inode 65462593, resetting version number
imap claims a free inode 65462593 is in use, correcting imap and clearing inode
cleared inode 65462593
bad magic number 0x694e on inode 65462594, resetting magic number
bad version number 0x21 on inode 65462594, resetting version number
cleared inode 65462594
bad magic number 0x2000 on inode 65462595, resetting magic number
bad version number 0x20 on inode 65462595, resetting version number
imap claims a free inode 65462595 is in use, correcting imap and clearing inode
cleared inode 65462595
bad magic number 0x4e45 on inode 65462596, resetting magic number
bad version number 0xd on inode 65462596, resetting version number
bad inode format in inode 65462596
cleared inode 65462596
inode 65462597 - bad extent starting block number 1099511630080, offset 4503599636807680
bad data fork in inode 65462597
cleared inode 65462597
bad magic number 0x46b0 on inode 65462598, resetting magic number
bad version number 0x12 on inode 65462598, resetting version number
bad inode format in inode 65462598
cleared inode 65462598
data fork in regular inode 65462599 claims used block 6909
bad data fork in inode 65462599
cleared inode 65462599
bad magic number 0x4ce1 on inode 65462600, resetting magic number
bad version number 0xa on inode 65462600, resetting version number
bad inode format in inode 65462600
cleared inode 65462600
bad non-zero extent size 1706551223 for non-realtime/extsize inode 65462601, resetting to zero
bad attr fork offset 234 in inode 65462601, max=19
cleared inode 65462601
bad magic number 0x4ce1 on inode 65462602, resetting magic number
bad version number 0xc on inode 65462602, resetting version number
bad inode format in inode 65462602
cleared inode 65462602
bad magic number 0x4ce1 on inode 65462603, resetting magic number
bad version number 0xd on inode 65462603, resetting version number
bad inode format in inode 65462603
cleared inode 65462603
bad non-zero extent size 1722839748 for non-realtime/extsize inode 65462604, resetting to zero
directory inode 65462604 has bad size 2305843009750565232
cleared inode 65462604
bad magic number 0x4ce1 on inode 65462605, resetting magic number
bad version number 0x9 on inode 65462605, resetting version number
bad inode format in inode 65462605
cleared inode 65462605
bad non-zero extent size 1706534470 for non-realtime/extsize inode 65462606, resetting to zero
bad attr fork offset 234 in inode 65462606, max=19
cleared inode 65462606
bad magic number 0x46b0 on inode 65462607, resetting magic number
bad version number 0x7 on inode 65462607, resetting version number
bad inode format in inode 65462607
cleared inode 65462607
inode 65462608 - bad extent starting block number 1099511630080, offset 4503599636807680
bad data fork in inode 65462608
cleared inode 65462608
bad magic number 0x4ce1 on inode 65462609, resetting magic number
bad version number 0x9 on inode 65462609, resetting version number
bad inode format in inode 65462609
cleared inode 65462609
bad magic number 0x4ce1 on inode 65462610, resetting magic number
bad version number 0xa on inode 65462610, resetting version number
bad inode format in inode 65462610
cleared inode 65462610
bad non-zero extent size 1706542192 for non-realtime/extsize inode 65462611, resetting to zero
bad attr fork offset 234 in inode 65462611, max=19
cleared inode 65462611
bad magic number 0x694e on inode 65462612, resetting magic number
bad version number 0x21 on inode 65462612, resetting version number
bad non-zero extent size 536870912 for non-realtime/extsize inode 65462612, resetting to zero
inode 65462612 - bad extent starting block number 1099511659384, offset 4503599628419072
bad data fork in inode 65462612
cleared inode 65462612
bad magic number 0x2000 on inode 65462613, resetting magic number
bad version number 0x20 on inode 65462613, resetting version number
imap claims a free inode 65462613 is in use, correcting imap and clearing inode
cleared inode 65462613
bad magic number 0x694e on inode 65462614, resetting magic number
bad version number 0x21 on inode 65462614, resetting version number
zero length extent (off = 0, fsbno = 0) in ino 65462614
bad data fork in inode 65462614
cleared inode 65462614
data fork in regular inode 65462615 claims used block 34418
bad data fork in inode 65462615
cleared inode 65462615
bad magic number 0x694e on inode 65462616, resetting magic number
bad version number 0x21 on inode 65462616, resetting version number
inode 65462616 - bad extent starting block number 1099511663973, offset 1048576
bad data fork in inode 65462616
cleared inode 65462616
bad non-zero extent size 1706539959 for non-realtime/extsize inode 65462617, resetting to zero
bad attr fork offset 234 in inode 65462617, max=19
cleared inode 65462617
bad magic number 0x2000 on inode 65462618, resetting magic number
bad version number 0x20 on inode 65462618, resetting version number
imap claims a free inode 65462618 is in use, correcting imap and clearing inode
cleared inode 65462618
data fork in regular inode 65462619 claims used block 38086
bad data fork in inode 65462619
cleared inode 65462619
bad magic number 0x2000 on inode 65462620, resetting magic number
bad version number 0x20 on inode 65462620, resetting version number
imap claims a free inode 65462620 is in use, correcting imap and clearing inode
cleared inode 65462620
bad magic number 0x4ce1 on inode 65462621, resetting magic number
bad version number 0x11 on inode 65462621, resetting version number
bad inode format in inode 65462621
cleared inode 65462621
bad magic number 0x2000 on inode 65462622, resetting magic number
bad version number 0x20 on inode 65462622, resetting version number
imap claims a free inode 65462622 is in use, correcting imap and clearing inode
cleared inode 65462622
bad magic number 0x694e on inode 65462623, resetting magic number
bad version number 0x21 on inode 65462623, resetting version number
zero length extent (off = 0, fsbno = 0) in ino 65462623
bad data fork in inode 65462623
cleared inode 65462623
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5

Program received signal SIGSEGV, Segmentation fault.
btree_search (root=0x80cb370, key=2006577) at btree.c:301
301		return btree_do_search(root, key);
(gdb) bt
#0  btree_search (root=0x80cb370, key=2006577) at btree.c:301
#1  0x080503ad in btree_find (root=0x80cb370, key=2006577, actual_key=0xbffff04c) at btree.c:313
#2  0x08062707 in get_bmap_ext (agno=7, agbno=2006577, maxbno=2006588, blen=0xbffff14c) at incore.c:157
#3  0x080542b8 in process_bmbt_reclist_int (mp=0xbffff50c, rp=0x8ab5c64, numrecs=1, type=5, ino=182879898, tot=0xbffff270, blkmapp=0xbffff294, 
    first_key=0xbffff1e0, last_key=0xbffff1e8, check_dups=0, whichfork=0) at dinode.c:754
#4  0x080546c7 in process_bmbt_reclist (mp=0xbffff50c, rp=0x8ab5c64, numrecs=1, type=5, ino=182879898, tot=0xbffff270, blkmapp=0xbffff294, 
    first_key=0xbffff1e0, last_key=0xbffff1e8, whichfork=0) at dinode.c:816
#5  0x08055c8b in process_exinode (mp=0xbffff50c, agno=5, ino=15107738, dip=0x8ab5c00, type=5, dirty=0xbffff3b8, tot=0xbffff270, nex=0xbffff280, 
    blkmapp=0xbffff294, whichfork=0, check_dups=0) at dinode.c:1327
#6  0x08057ddf in process_inode_data_fork (mp=0xbffff50c, dino=0x8ab5c00, agno=5, ino=15107738, was_free=0, dirty=0xbffff3b8, used=0xbffff3b4, 
    verify_mode=0, uncertain=0, ino_discovery=1, check_dups=0, extra_attr_check=1, isa_dir=0xbffff3bc, parent=0xbffff3a8) at dinode.c:2042
#7  process_dinode_int (mp=0xbffff50c, dino=0x8ab5c00, agno=5, ino=15107738, was_free=0, dirty=0xbffff3b8, used=0xbffff3b4, verify_mode=0, 
    uncertain=0, ino_discovery=1, check_dups=0, extra_attr_check=1, isa_dir=0xbffff3bc, parent=0xbffff3a8) at dinode.c:2692
#8  0x08058d27 in process_dinode (mp=0xbffff50c, dino=0x8ab5c00, agno=5, ino=15107738, was_free=0, dirty=0xbffff3b8, used=0xbffff3b4, 
    ino_discovery=1, check_dups=0, extra_attr_check=1, isa_dir=0xbffff3bc, parent=0xbffff3a8) at dinode.c:2834
#9  0x08050e85 in process_inode_chunk (mp=0xbffff50c, agno=5, first_irec=0xa, ino_discovery=1, check_dups=0, extra_attr_check=1, bogus=0xbffff40c, 
    num_inos=<value optimized out>) at dino_chunks.c:777
#10 0x0805262f in process_aginodes (mp=0xbffff50c, pf_args=0x0, agno=5, ino_discovery=1, check_dups=0, extra_attr_check=1) at dino_chunks.c:1024
#11 0x08065f96 in process_ag_func (wq=0x815e608, agno=5, arg=0x0) at phase3.c:154
#12 0x080666f4 in process_ags (mp=0xbffff50c) at phase3.c:193
#13 phase3 (mp=0xbffff50c) at phase3.c:232
#14 0x0804a01f in main (argc=4, argv=0xbffff7f4) at xfs_repair.c:724

------- =_aaaaaaaaaa0
Content-Type: text/plain;
	name="xfs_repair.output.segv.backtrace.nodebugging.txt";
	charset="us-ascii"
Content-ID: <22694.1313569293.3@eamp.org>

# xfs_repair -P -v /dev/sdc1
Phase 1 - find and verify superblock...
        - block cache size set to 61472 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 2 tail block 2
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
bad magic number 0x0 on inode 65462593
bad version number 0x0 on inode 65462593
bad magic number 0x694e on inode 65462594
bad version number 0x21 on inode 65462594
bad magic number 0x2000 on inode 65462595
bad version number 0x20 on inode 65462595
inode 65462595 has RT flag set but there is no RT deviceinode 65462595 not rt bitmapbad magic number 0x4e45 on inode 65462596
bad version number 0xd on inode 65462596
bad inode format in inode 65462596
bad magic number 0x46b0 on inode 65462598
bad version number 0x12 on inode 65462598
bad inode format in inode 65462598
bad magic number 0x4ce1 on inode 65462600
bad version number 0xa on inode 65462600
bad inode format in inode 65462600
bad magic number 0x4ce1 on inode 65462602
bad version number 0xc on inode 65462602
bad inode format in inode 65462602
bad magic number 0x4ce1 on inode 65462603
bad version number 0xd on inode 65462603
bad inode format in inode 65462603
bad magic number 0x4ce1 on inode 65462605
bad version number 0x9 on inode 65462605
bad inode format in inode 65462605
bad magic number 0x46b0 on inode 65462607
bad version number 0x7 on inode 65462607
bad inode format in inode 65462607
bad magic number 0x4ce1 on inode 65462609
bad version number 0x9 on inode 65462609
bad inode format in inode 65462609
bad magic number 0x4ce1 on inode 65462610
bad version number 0xa on inode 65462610
bad inode format in inode 65462610
bad magic number 0x694e on inode 65462612
bad version number 0x21 on inode 65462612
bad magic number 0x2000 on inode 65462613
bad version number 0x20 on inode 65462613
bad magic number 0x694e on inode 65462614
bad version number 0x21 on inode 65462614
bad magic number 0x694e on inode 65462616
bad version number 0x21 on inode 65462616
bad magic number 0x2000 on inode 65462618
bad version number 0x20 on inode 65462618
bad magic number 0x2000 on inode 65462620
bad version number 0x20 on inode 65462620
bad magic number 0x4ce1 on inode 65462621
bad version number 0x11 on inode 65462621
bad inode format in inode 65462621
bad magic number 0x2000 on inode 65462622
bad version number 0x20 on inode 65462622
bad magic number 0x694e on inode 65462623
bad version number 0x21 on inode 65462623
zero length entry in shortform dir 65462592, junking 255 entries
corrected entry count in directory 65462592, was 32, now 0
corrected directory 65462592 size, was 69, now 6
bad magic number 0x0 on inode 65462593, resetting magic number
bad version number 0x0 on inode 65462593, resetting version number
imap claims a free inode 65462593 is in use, correcting imap and clearing inode
cleared inode 65462593
bad magic number 0x694e on inode 65462594, resetting magic number
bad version number 0x21 on inode 65462594, resetting version number
cleared inode 65462594
bad magic number 0x2000 on inode 65462595, resetting magic number
bad version number 0x20 on inode 65462595, resetting version number
imap claims a free inode 65462595 is in use, correcting imap and clearing inode
cleared inode 65462595
bad magic number 0x4e45 on inode 65462596, resetting magic number
bad version number 0xd on inode 65462596, resetting version number
bad inode format in inode 65462596
cleared inode 65462596
inode 65462597 - bad extent starting block number 1099511630080, offset 4503599636807680
bad data fork in inode 65462597
cleared inode 65462597
bad magic number 0x46b0 on inode 65462598, resetting magic number
bad version number 0x12 on inode 65462598, resetting version number
bad inode format in inode 65462598
cleared inode 65462598
data fork in regular inode 65462599 claims used block 6909
bad data fork in inode 65462599
cleared inode 65462599
bad magic number 0x4ce1 on inode 65462600, resetting magic number
bad version number 0xa on inode 65462600, resetting version number
bad inode format in inode 65462600
cleared inode 65462600
bad non-zero extent size 1706551223 for non-realtime/extsize inode 65462601, resetting to zero
bad attr fork offset 234 in inode 65462601, max=19
cleared inode 65462601
bad magic number 0x4ce1 on inode 65462602, resetting magic number
bad version number 0xc on inode 65462602, resetting version number
bad inode format in inode 65462602
cleared inode 65462602
bad magic number 0x4ce1 on inode 65462603, resetting magic number
bad version number 0xd on inode 65462603, resetting version number
bad inode format in inode 65462603
cleared inode 65462603
bad non-zero extent size 1722839748 for non-realtime/extsize inode 65462604, resetting to zero
directory inode 65462604 has bad size 2305843009750565232
cleared inode 65462604
bad magic number 0x4ce1 on inode 65462605, resetting magic number
bad version number 0x9 on inode 65462605, resetting version number
bad inode format in inode 65462605
cleared inode 65462605
bad non-zero extent size 1706534470 for non-realtime/extsize inode 65462606, resetting to zero
bad attr fork offset 234 in inode 65462606, max=19
cleared inode 65462606
bad magic number 0x46b0 on inode 65462607, resetting magic number
bad version number 0x7 on inode 65462607, resetting version number
bad inode format in inode 65462607
cleared inode 65462607
inode 65462608 - bad extent starting block number 1099511630080, offset 4503599636807680
bad data fork in inode 65462608
cleared inode 65462608
bad magic number 0x4ce1 on inode 65462609, resetting magic number
bad version number 0x9 on inode 65462609, resetting version number
bad inode format in inode 65462609
cleared inode 65462609
bad magic number 0x4ce1 on inode 65462610, resetting magic number
bad version number 0xa on inode 65462610, resetting version number
bad inode format in inode 65462610
cleared inode 65462610
bad non-zero extent size 1706542192 for non-realtime/extsize inode 65462611, resetting to zero
bad attr fork offset 234 in inode 65462611, max=19
cleared inode 65462611
bad magic number 0x694e on inode 65462612, resetting magic number
bad version number 0x21 on inode 65462612, resetting version number
bad non-zero extent size 536870912 for non-realtime/extsize inode 65462612, resetting to zero
inode 65462612 - bad extent starting block number 1099511659384, offset 4503599628419072
bad data fork in inode 65462612
cleared inode 65462612
bad magic number 0x2000 on inode 65462613, resetting magic number
bad version number 0x20 on inode 65462613, resetting version number
imap claims a free inode 65462613 is in use, correcting imap and clearing inode
cleared inode 65462613
bad magic number 0x694e on inode 65462614, resetting magic number
bad version number 0x21 on inode 65462614, resetting version number
zero length extent (off = 0, fsbno = 0) in ino 65462614
bad data fork in inode 65462614
cleared inode 65462614
data fork in regular inode 65462615 claims used block 34418
bad data fork in inode 65462615
cleared inode 65462615
bad magic number 0x694e on inode 65462616, resetting magic number
bad version number 0x21 on inode 65462616, resetting version number
inode 65462616 - bad extent starting block number 1099511663973, offset 1048576
bad data fork in inode 65462616
cleared inode 65462616
bad non-zero extent size 1706539959 for non-realtime/extsize inode 65462617, resetting to zero
bad attr fork offset 234 in inode 65462617, max=19
cleared inode 65462617
bad magic number 0x2000 on inode 65462618, resetting magic number
bad version number 0x20 on inode 65462618, resetting version number
imap claims a free inode 65462618 is in use, correcting imap and clearing inode
cleared inode 65462618
data fork in regular inode 65462619 claims used block 38086
bad data fork in inode 65462619
cleared inode 65462619
bad magic number 0x2000 on inode 65462620, resetting magic number
bad version number 0x20 on inode 65462620, resetting version number
imap claims a free inode 65462620 is in use, correcting imap and clearing inode
cleared inode 65462620
bad magic number 0x4ce1 on inode 65462621, resetting magic number
bad version number 0x11 on inode 65462621, resetting version number
bad inode format in inode 65462621
cleared inode 65462621
bad magic number 0x2000 on inode 65462622, resetting magic number
bad version number 0x20 on inode 65462622, resetting version number
imap claims a free inode 65462622 is in use, correcting imap and clearing inode
cleared inode 65462622
bad magic number 0x694e on inode 65462623, resetting magic number
bad version number 0x21 on inode 65462623, resetting version number
zero length extent (off = 0, fsbno = 0) in ino 65462623
bad data fork in inode 65462623
cleared inode 65462623
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
Segmentation fault (core dumped)
# gdb /sbin/xfs_repair core 
GNU gdb (GDB) 7.2-debian
Copyright (C) 2010 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i486-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /sbin/xfs_repair...(no debugging symbols found)...done.
[New Thread 29246]

warning: Can't read pathname for load map: Input/output error.
Reading symbols from /lib/libuuid.so.1...(no debugging symbols found)...done.
Loaded symbols for /lib/libuuid.so.1
Reading symbols from /lib/i386-linux-gnu/i686/cmov/librt.so.1...Reading symbols from /usr/lib/debug/lib/i386-linux-gnu/i686/cmov/librt-2.13.so...done.
done.
Loaded symbols for /lib/i386-linux-gnu/i686/cmov/librt.so.1
Reading symbols from /lib/i386-linux-gnu/i686/cmov/libpthread.so.0...Reading symbols from /usr/lib/debug/lib/i386-linux-gnu/i686/cmov/libpthread-2.13.so...done.
done.
Loaded symbols for /lib/i386-linux-gnu/i686/cmov/libpthread.so.0
Reading symbols from /lib/i386-linux-gnu/i686/cmov/libc.so.6...Reading symbols from /usr/lib/debug/lib/i386-linux-gnu/i686/cmov/libc-2.13.so...done.
done.
Loaded symbols for /lib/i386-linux-gnu/i686/cmov/libc.so.6
Reading symbols from /lib/ld-linux.so.2...(no debugging symbols found)...done.
Loaded symbols for /lib/ld-linux.so.2
Core was generated by `xfs_repair -P -v /dev/sdc1'.
Program terminated with signal 11, Segmentation fault.
#0  0x0804ed60 in ?? ()
(gdb) bt
#0  0x0804ed60 in ?? ()
#1  0x0804ee9d in ?? ()
#2  0x08064823 in ?? ()
#3  0x08053dc3 in ?? ()
#4  0x080541ff in ?? ()
#5  0x0805433d in ?? ()
#6  0x0805650f in ?? ()
#7  0x0805908d in ?? ()
#8  0x0805999e in ?? ()
#9  0x080505ab in ?? ()
#10 0x08050f8a in ?? ()
#11 0x080681d3 in ?? ()
#12 0x08068967 in ?? ()
#13 0x0807f7c6 in ?? ()
#14 0xb75c5e46 in __libc_start_main (main=0x807f510, argc=4, ubp_av=0xbfdbafb4, init=0x80b8e90, fini=0x80b8e80, rtld_fini=0xb775e2f0, 
    stack_end=0xbfdbafac) at libc-start.c:228
#15 0x08049c71 in ?? ()

------- =_aaaaaaaaaa0
Content-Type: text/plain; name="xfs_repair.noact.txt"; charset="us-ascii"
Content-ID: <22694.1313569293.4@eamp.org>

# xfs_repair -n -v -P /dev/sdc1
Phase 1 - find and verify superblock...
        - block cache size set to 61472 entries
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
bad magic number 0x0 on inode 65462593
bad version number 0x0 on inode 65462593
bad magic number 0x694e on inode 65462594
bad version number 0x21 on inode 65462594
bad magic number 0x2000 on inode 65462595
bad version number 0x20 on inode 65462595
inode 65462595 has RT flag set but there is no RT deviceinode 65462595 not rt bitmapbad magic number 0x4e45 on inode 65462596
bad version number 0xd on inode 65462596
bad inode format in inode 65462596
bad magic number 0x46b0 on inode 65462598
bad version number 0x12 on inode 65462598
bad inode format in inode 65462598
bad magic number 0x4ce1 on inode 65462600
bad version number 0xa on inode 65462600
bad inode format in inode 65462600
bad magic number 0x4ce1 on inode 65462602
bad version number 0xc on inode 65462602
bad inode format in inode 65462602
bad magic number 0x4ce1 on inode 65462603
bad version number 0xd on inode 65462603
bad inode format in inode 65462603
bad magic number 0x4ce1 on inode 65462605
bad version number 0x9 on inode 65462605
bad inode format in inode 65462605
bad magic number 0x46b0 on inode 65462607
bad version number 0x7 on inode 65462607
bad inode format in inode 65462607
bad magic number 0x4ce1 on inode 65462609
bad version number 0x9 on inode 65462609
bad inode format in inode 65462609
bad magic number 0x4ce1 on inode 65462610
bad version number 0xa on inode 65462610
bad inode format in inode 65462610
bad magic number 0x694e on inode 65462612
bad version number 0x21 on inode 65462612
bad magic number 0x2000 on inode 65462613
bad version number 0x20 on inode 65462613
bad magic number 0x694e on inode 65462614
bad version number 0x21 on inode 65462614
bad magic number 0x694e on inode 65462616
bad version number 0x21 on inode 65462616
bad magic number 0x2000 on inode 65462618
bad version number 0x20 on inode 65462618
bad magic number 0x2000 on inode 65462620
bad version number 0x20 on inode 65462620
bad magic number 0x4ce1 on inode 65462621
bad version number 0x11 on inode 65462621
bad inode format in inode 65462621
bad magic number 0x2000 on inode 65462622
bad version number 0x20 on inode 65462622
bad magic number 0x694e on inode 65462623
bad version number 0x21 on inode 65462623
zero length entry in shortform dir 65462592, would junk 255 entries
would have corrected entry count in directory 65462592 from 32 to 0
would have corrected directory 65462592 size from 69 to 6
bad magic number 0x0 on inode 65462593, would reset magic number
bad version number 0x0 on inode 65462593, would reset version number
imap claims a free inode 65462593 is in use, would correct imap and clear inode
would have cleared inode 65462593
bad magic number 0x694e on inode 65462594, would reset magic number
bad version number 0x21 on inode 65462594, would reset version number
version 2 inode 65462594 claims > 65535 links, would update superblock version number
would clear obsolete nlink field in version 2 inode 65462594, currently 1
would have cleared inode 65462594
bad magic number 0x2000 on inode 65462595, would reset magic number
bad version number 0x20 on inode 65462595, would reset version number
imap claims a free inode 65462595 is in use, would correct imap and clear inode
would have cleared inode 65462595
bad magic number 0x4e45 on inode 65462596, would reset magic number
bad version number 0xd on inode 65462596, would reset version number
bad inode format in inode 65462596
would have cleared inode 65462596
inode 65462597 - bad extent starting block number 1099511630080, offset 4503599636807680
bad data fork in inode 65462597
would have cleared inode 65462597
bad magic number 0x46b0 on inode 65462598, would reset magic number
bad version number 0x12 on inode 65462598, would reset version number
bad inode format in inode 65462598
would have cleared inode 65462598
data fork in regular inode 65462599 claims used block 6909
bad data fork in inode 65462599
would have cleared inode 65462599
bad magic number 0x4ce1 on inode 65462600, would reset magic number
bad version number 0xa on inode 65462600, would reset version number
bad inode format in inode 65462600
would have cleared inode 65462600
bad non-zero extent size 1706551223 for non-realtime/extsize inode 65462601, would reset to zero
bad attr fork offset 234 in inode 65462601, max=19
would have cleared inode 65462601
bad magic number 0x4ce1 on inode 65462602, would reset magic number
bad version number 0xc on inode 65462602, would reset version number
bad inode format in inode 65462602
would have cleared inode 65462602
bad magic number 0x4ce1 on inode 65462603, would reset magic number
bad version number 0xd on inode 65462603, would reset version number
bad inode format in inode 65462603
would have cleared inode 65462603
bad non-zero extent size 1722839748 for non-realtime/extsize inode 65462604, would reset to zero
directory inode 65462604 has bad size 2305843009750565232
would have cleared inode 65462604
bad magic number 0x4ce1 on inode 65462605, would reset magic number
bad version number 0x9 on inode 65462605, would reset version number
bad inode format in inode 65462605
would have cleared inode 65462605
bad non-zero extent size 1706534470 for non-realtime/extsize inode 65462606, would reset to zero
bad attr fork offset 234 in inode 65462606, max=19
would have cleared inode 65462606
bad magic number 0x46b0 on inode 65462607, would reset magic number
bad version number 0x7 on inode 65462607, would reset version number
bad inode format in inode 65462607
would have cleared inode 65462607
inode 65462608 - bad extent starting block number 1099511630080, offset 4503599636807680
bad data fork in inode 65462608
would have cleared inode 65462608
bad magic number 0x4ce1 on inode 65462609, would reset magic number
bad version number 0x9 on inode 65462609, would reset version number
bad inode format in inode 65462609
would have cleared inode 65462609
bad magic number 0x4ce1 on inode 65462610, would reset magic number
bad version number 0xa on inode 65462610, would reset version number
bad inode format in inode 65462610
would have cleared inode 65462610
bad non-zero extent size 1706542192 for non-realtime/extsize inode 65462611, would reset to zero
bad attr fork offset 234 in inode 65462611, max=19
would have cleared inode 65462611
bad magic number 0x694e on inode 65462612, would reset magic number
bad version number 0x21 on inode 65462612, would reset version number
bad non-zero extent size 536870912 for non-realtime/extsize inode 65462612, would reset to zero
inode 65462612 - bad extent starting block number 1099511659384, offset 4503599628419072
bad data fork in inode 65462612
would have cleared inode 65462612
bad magic number 0x2000 on inode 65462613, would reset magic number
bad version number 0x20 on inode 65462613, would reset version number
imap claims a free inode 65462613 is in use, would correct imap and clear inode
would have cleared inode 65462613
bad magic number 0x694e on inode 65462614, would reset magic number
bad version number 0x21 on inode 65462614, would reset version number
zero length extent (off = 0, fsbno = 0) in ino 65462614
bad data fork in inode 65462614
would have cleared inode 65462614
data fork in regular inode 65462615 claims used block 34418
bad data fork in inode 65462615
would have cleared inode 65462615
bad magic number 0x694e on inode 65462616, would reset magic number
bad version number 0x21 on inode 65462616, would reset version number
inode 65462616 - bad extent starting block number 1099511663973, offset 1048576
bad data fork in inode 65462616
would have cleared inode 65462616
bad non-zero extent size 1706539959 for non-realtime/extsize inode 65462617, would reset to zero
bad attr fork offset 234 in inode 65462617, max=19
would have cleared inode 65462617
bad magic number 0x2000 on inode 65462618, would reset magic number
bad version number 0x20 on inode 65462618, would reset version number
imap claims a free inode 65462618 is in use, would correct imap and clear inode
would have cleared inode 65462618
data fork in regular inode 65462619 claims used block 38086
bad data fork in inode 65462619
would have cleared inode 65462619
bad magic number 0x2000 on inode 65462620, would reset magic number
bad version number 0x20 on inode 65462620, would reset version number
imap claims a free inode 65462620 is in use, would correct imap and clear inode
would have cleared inode 65462620
bad magic number 0x4ce1 on inode 65462621, would reset magic number
bad version number 0x11 on inode 65462621, would reset version number
bad inode format in inode 65462621
would have cleared inode 65462621
bad magic number 0x2000 on inode 65462622, would reset magic number
bad version number 0x20 on inode 65462622, would reset version number
imap claims a free inode 65462622 is in use, would correct imap and clear inode
would have cleared inode 65462622
bad magic number 0x694e on inode 65462623, would reset magic number
bad version number 0x21 on inode 65462623, would reset version number
zero length extent (off = 0, fsbno = 0) in ino 65462623
bad data fork in inode 65462623
would have cleared inode 65462623
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5

fatal error -- illegal state -1 in block map 20815240

------- =_aaaaaaaaaa0
Content-Type: application/x-gzip; name="xfs_check.txt.gz"
Content-ID: <22694.1313569293.5@eamp.org>
Content-Transfer-Encoding: base64

H4sICN90S04CA3hmc19jaGVja19zZGMxLnR4dAC83UtuHcYRheG5V3EXICC3urtOVa0lyEAPKiAk
kYIejpTVh5JjI4oYmP8ZhIAHFLvvg/+hIH+Q4RfPX13ubr58uny+e3t79+bm1eX6ZV1/+7i8vv9w
ub27f3VzUR6tnPXLq9sPf3xyubn79OHr5fLi4THuX7/+ePPpsv/0xOMH/uzjPx7g+uMDfPvKx9t/
3jy80H8/2PNPl5xfvv36u+d/v315ufv87sXNh8sjb2c/cuqL5tz8fPQ8dnQ9+k3Kx46em5M/H9X3
o0///tcvP376/d2/eHv/8s3vzxTXmYzQvl77evlrrrO6n619PX979vt38OR154y2+loP//z2Ir4/
zMdLPPKszy4v7z/fffr24h59b3rxyGvtR9/bq9e/ffx8/iHZ9zdy/YvmOpebL+9vXn57yk9f3988
PMKbu/t/3F3+fv/p8ur5p+c/nn359vntu4ejL77+10M+u7z/cPPr7f3njw9f+PzuEvvxOC9vfnrb
ul5RHF3j+/mHX37zx9b3+V/HnvQK1tOP7p+eXPr51Hn6AyZ893rau9dTB6RrwVfQv/z46f/jh+Ph
af7sh+PR7+48+Whcn/SNjXjq72WK9dTfyxT76Y960M+7Iv/4Gd7nRD/1B/7b4QGH15UcDnJ4kcOb
HD7kcJLDIoeLHCYFFym4ScFNCm5ScJOCmxTcpOAmBTcpuEnBTQoeUvCQgocUPKTgIQUPKXhIwUMK
HlLwkIJJCiYpmKRgkoJJCiYpmKRgkoJJCiYpKFJQpKBIQZGCIgVFCooUFCkoUlCkYJGCRQoWKVik
YJGCRQoWKVikYJGCRQo2KdikYJOCTQo2KdikYJOCTQo2Kdik4JCCQwoOKTik4JCCQwoOKTik4JCC
Awrm9UoOBzm8yOFNDh9yOMlhkcNFDjc5TAoGKRikYJCCQQoGKRikYJCCQQoSk0liMklMJonJJDGZ
JCaTxGSSmEwSk0liMklMJonJJDGZJCaTxGSSmEwSk0liMklMJonJJDGZJCaTxGSSmEwSk0liMklM
JonJJDGZJCaTxGSSmEwSk0liMklMJonJJDGZJCaTxGSSmEwSk0liMklMJonJJDGZJCaTxGSSmEwS
k0liMklMJonJJDGZJCaTxGSSmEwSk0liMklMJonJJDGZJCaTxGSSmEwSk0liMklMJonJJDGZJCaT
xGSSmEwSk0liMklMJonJJDGZJCaTxGSSmEwSk0liMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIi
JiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYj
YjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2Iy
IiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiIm
I2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjJFTKaI
yRQxmSImU8RkiphMEZMpYjJFTKaIyRQxmSImU8RkiphMEZMpYjJFTKaIyRQxmSImU8RkiphMEZMp
YjJFTKaIyRQxmSImU8RkiphMEZMpYjJFTKaIyRQxmSImU8RkiphMEZMpYjJFTKaIyRQxmSImU8Rk
iphMEZMpYjJFTKaIyRQxmSImU8RkiphMEZMpYjJFTKaIyRQxmSImU8RkiphMEZMpYjJFTKaIyRQx
mSImU8RkiphMEZMpYjJFTKaIyRQxmSImU8RkiphMEZMpYjJFTKaIyRQxmSImU8RkiphMEZMpYjJF
TKaIyRQxmSImU8RkiphMEZMpYjJFTKaIyRQxmSIm08RkmphME5NpYjJNTKaJyTQxmSYm08RkmphM
E5NpYjJNTKaJyTQxmSYm08RkmphME5NpYjJNTKaJyTQxmSYm08RkmphME5NpYjJNTKaJyTQxmSYm
08RkmphME5NpYjJNTKaJyTQxmSYm08RkmphME5NpYjJNTKaJyTQxmSYm08RkmphME5NpYjJNTKaJ
yTQxmSYm08RkmphME5NpYjJNTKaJyTQxmSYm08RkmphME5NpYjJNTKaJyTQxmSYm08RkmphME5Np
YjJNTKaJyTQxmSYm08RkmphME5NpYjJNTKaJyTQxmSYm08RkmphME5NpYjJNTKaJyTQxmSYm08Rk
mphME5NpYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwx
mSEmM8RkhpjMEJMZYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJD
TGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwxmSEmM8RkhpjM
EJMZYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwxmSEm
M8RkhpjMEJMZYjJDTGaIyQwxmSEmM8RkhpjMEJMZYjJDTGaIyQwxmQEmk1dgMg+Hgxxe5PAmhw85
nOSwyOEih5scJgWDFAxSMEjBIAWDFAxSMEjBIAWDFAxScJGCixRcpOAiBRcpuEjBRQouUnCRgosU
3KTgJgU3KbhJwU0KblJwk4KbFNyk4CYFDyl4SMFDCh5S8JCChxQ8pOAhBQ8peEjBJAWTFExSMEnB
JAWTFExSMEnBJAWTFBQpKFJQpKBIQZGCIgVFCooUFCkoUrBIwSIFixQsUrBIwSIFixQsUrBIwSIF
mxRsUrBJwSYFmxRsUrBJwSYFmxRsUnBIwSEFhxQcUnBIwSEFhxQcUnBIQWIyQUwmiMkEMZkgJhPE
ZIKYTBCTCWIyQUwmiMkEMZkgJhPEZIKYTBCTCWIyQUwmiMkEMZkgJhPEZIKYTBCTCWIyQUwmiMkE
MZkgJhPEZIKYTBCTCWIyQUwmiMkEMZkgJhPEZIKYTBCTCWIyQUwmiMkEMZkgJhPEZIKYTBCTCWIy
QUwmiMkEMZkgJhPEZIKYTBCTCWIyQUwmiMkEMZkgJhPEZIKYTBCTCWIyQUwmiMkEMZkgJhPEZIKY
TBCTCWIyQUwmiMkEMZkgJhPEZIKYTBCTCWIyQUwmiMkEMZkgJhPEZIKYTBCTCWIyQUwmiMkEMZkg
JhPEZIKYTBCTCWIyQUwmiMkEMZkgJrOIySxiMouYzCIms4jJLGIyi5jMIiaziMksYjKLmMwiJrOI
ySxiMouYzCIms4jJLGIyi5jMIiaziMksYjKLmMwiJrOIySxiMouYzCIms4jJLGIyi5jMIiaziMks
YjKLmMwiJrOIySxiMouYzCIms4jJLGIyi5jMIiaziMksYjKLmMwiJrOIySxiMouYzCIms4jJLGIy
i5jMIiaziMksYjKLmMwiJrOIySxiMouYzCIms4jJLGIyi5jMIiaziMksYjKLmMwiJrOIySxiMouY
zCIms4jJLGIyi5jMIiaziMksYjKLmMwiJrOIySxiMouYzCIms4jJLGIyi5jMIiaziMksYjKLmMwi
JrOIySxiMouYzCIms4nJbGIym5jMJiaziclsYjKbmMwmJrOJyWxiMpuYzCYms4nJbGIym5jMJiaz
iclsYjKbmMwmJrOJyWxiMpuYzCYms4nJbGIym5jMJiaziclsYjKbmMwmJrOJyWxiMpuYzCYms4nJ
bGIym5jMJiaziclsYjKbmMwmJrOJyWxiMpuYzCYms4nJbGIym5jMJiaziclsYjKbmMwmJrOJyWxi
MpuYzCYms4nJbGIym5jMJiaziclsYjKbmMwmJrOJyWxiMpuYzCYms4nJbGIym5jMJiaziclsYjKb
mMwmJrOJyWxiMpuYzCYms4nJbGIym5jMJiaziclsYjKbmMwmJrOJyWxiMpuYzCYms4nJbGIym5jM
JiZziMkcYjKHmMwhJnOIyRxiMoeYzCEmc4jJHGIyh5jMISZziMkcYjKHmMwhJnOIyRxiMoeYzCEm
c4jJHGIyh5jMISZziMkcYjKHmMwhJnOIyRxiMoeYzCEmc4jJHGIyh5jMISZziMkcYjKHmMwhJnOI
yRxiMoeYzCEmc4jJHGIyh5jMISZziMkcYjKHmMwhJnOIyRxiMoeYzCEmc4jJHGIyh5jMISZziMkc
YjKHmMwhJnOIyRxiMoeYzCEmc4jJHGIyh5jMISZziMkcYjKHmMwhJnOIyRxiMoeYzCEmc4jJHGIy
h5jMISZziMkcYjKHmMwhJnOIyRxiMoeYzCEmc4jJHGIyh5jMISZziMkcYjKHmMwhJpPEZJKYTBKT
SWIySUwmickkMZkkJpPEZJKYTBKTSWIySUwmickkMZkkJpPEZJKYTBKTSWIySUwmickkMZkkJpPE
ZJKYTBKTSWIySUwmickkMZkkJpPEZJKYTBKTSWIySUwmickkMZkkJpPEZJKYTBKTSWIySUwmickk
MZkkJpPEZJKYTBKTSWIySUwmickkMZkkJpPEZJKYTBKTSWIySUwmickkMZkkJpPEZJKYTBKTSWIy
SUwmickkMZkkJpPEZJKYTBKTSWIySUwmickkMZkkJpPEZJKYTBKTSWIySUwmickkMZkkJpPEZJKY
TBKTSWIySUwmickkMZkkJpPEZJKYTBKTSWIyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2Iy
IiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiIm
I2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNi
MiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIiJiNiMiImI2IyIiYjYjIi
JiNiMiImI2IyIv8v7G9/3f3l2+e37x7Ovvh6ub27f3Vz0be/Sffw7xnPLu8/3Px6e//548MXPr+7
RF5/uDr21Yc/4ttXw7+6/Kvbv3r8q+lflX+1/Kv+mpa/pu2vaftr2v6atr+m7a9p+2va/pq2v6bt
r2n7azr+mo6/puOv6fhrOv6ajr+m46/p+Gs6/pqOv6b015T+mtJfU/prSn9N6a8p/TWlv6b015T+
muSvSf6a5K9J/prkr0n+muSvSf6a5K9J/prKX1P5ayp/TeWvqfw1lb+m8tdU/prKX1P5a2p/Te2v
qf01tb+m9tfU/praX1P7a2p/Te2vafw1jb+m8dc0/prGX9P4axp/TeOvafw1jb2mb/+pjX01/KvL
v7r9q8e/mv5V+VfLv9r+VX9N4a8p/DWFv6bw1xT+msJfU/hrCn9NvoWnb+HpW3j6Fp6+hadv4elb
ePoWnr6Fp2/h6Vt4+haevoWnb+HpW3j6Fp6+hadv4elbePoWnr6Fp2/h6Vt4+haevoWnb+HpW3j6
Fp6+hadv4elbePoWnr6Fp2/h6Vt4+haevoWnb+HpW3j6Fp6+hadv4elbePoWnr6Fp2/h6Vt4+hae
voWnb+HpW3j6Fp6+hadv4elbePoWnr6Fp2/h6Vt4+haevoWnb+HpW3j6Fp6+hadv4elbePoWnr6F
p2/h6Vt4+haevoWnb+HpW3j6Fp6+hadv4elbePoWnr6Fp2/h8i1cvoXLt3D5Fi7fwuVbuHwLl2/h
8i1cvoXLt3D5Fi7fwuVbuHwLl2/h8i1cvoXLt3D5Fi7fwuVbuHwLl2/h8i1cvoXLt3D5Fi7fwuVb
uHwLl2/h8i1cvoXLt3D5Fi7fwuVbuHwLl2/h8i1cvoXLt3D5Fi7fwuVbuHwLl2/h8i1cvoXLt3D5
Fi7fwuVbuHwLl2/h8i1cvoXLt3D5Fi7fwuVbuHwLl2/h8i1cvoXLt3D5Fi7fwuVbuHwLl2/h8i1c
voWLWXj8cDX9q/Kvln+1/atjX2UW/uPV8K8u/+r2r/pran9N7a+p/TW1v6b21zT+msZf0/hrGn9N
469p/DWNv6bx1zT+msZeU12v/tXwry7/6vavHv9q+lflXy3/avtX/TWFv6bw1xT+msJfU/hrCn9N
4a8p/DWFv6bw17T8NS1/Tctf0/LXtPw1LX9Ny1/T8te0/DUtf03bX9P217T9NW1/Tdtf0/bXtP01
bX9N21/T9td0/DUdf03HX9Px13T8NR1/Tcdf0/HXdPw1HX9N6a8p/TWlv6b015T+mtJfU/prSn9N
6a8p/TXJX5P8Nclfk/w1yV+T/DXJX5P8Nclfk/w1lb+m8tdU/prKX5Nv4eVbePkWXr6Fl2/h5Vt4
+RZevoWXb+HlW3j5Fl6+hZdv4eVbePkWXr6Fl2/h5Vt4+RZevoWXb+HlW3j5Fl6+hZdv4eVbePsW
3r6Ft2/h7Vt4+xbevoW3b+HtW3j7Ft6+hbdv4e1bePsW3r6Ft2/h7Vt4+xbevoW3b+HtW3j7Ft6+
hbdv4e1bePsW3r6Ft2/h7Vt4+xbevoW3b+HtW3j7Ft6+hbdv4e1bePsW3r6Ft2/h7Vt4+xbevoW3
b+HtW3j7Ft6+hbdv4e1bePsW3r6Ft2/h7Vt4+xbevoW3b+HtW3j7Ft6+hbdv4e1bePsW3r6Ft2/h
7Vt4+xbevoW3b+HtW3j7Ft6+hbdv4e1bePsW3r6Ft2/h7Vt4+xbevoW3b+HtW3j7Ft6+hbdv4e1b
ePsW3r6Ft2/h7Vt4+xbevoW3b+HtW3j7Ft6+hbdv4e1bePsW3r6Ft2/h7Vv4+BY+voWPb+HjW/j4
Fj6+hY9v4eNb+PgWPr6Fj2/h41v4+BY+voWPb+HjW/j4Fj6+hY9v4eNb+PgWPr6Fj2/h41v4+BY+
voWPb+HjW/j4Fj6+hY9v4eNb+PgWPr6Fj2/h41v4+BY+voWPb+HjW/j4Fj6+hY9v4eNb+PgWPr6F
j2/h41v4+BY+voWPb+HjW/j4Fj6+hY9v4eNb+PgWPr6Fj2/h41v4+BY+voWPb+HjW/j4Fj6+hY9v
4eNb+PgWPr6Fj2/h41v4+BY+voWPb+HjW/j4Fj6+hY9v4eNb+PgWPr6Fj2/h41v4+BY+voWPb+Hj
W/j4Fj6+hY9v4eNb+PgWPr6Fj2/h41v4+BY+voWPb+FjW3hebQt/uBr+1eVf3f7V419N/6r8q+Vf
bf+qv6bw1xT+msJfU/hrCn9N4a8p/DX9i7O72Q2zusIofCu+gA68f8/5LieAqSJKgiC0cPd1YVCl
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
k2liMk1MponJNDGZJibTxGSamEwTk2liMk1MponJNDGZJibTxGSamEwTk2liMk1MponJNDGZJibT
xGSamEwTk2liMk1MponJNDGZJibTxGSamEwTk2liMk1MponJNDGZJibTxGSamEwTk2liMk1MponJ
NDGZJibTxGSamEwTk2liMk1MponJNDGZJibTxGSamEwTk2liMk1MponJNDGZJibTxGSamEwTk2li
Mk1MponJNDGZJibTxGSamEwTk2liMk1MponJNDGZJibTxGSamEwTk2liMk1MZojJDDGZISYzxGSG
mMwQkxliMkNMZojJDDGZISYzxGSGmMwQkxliMkNMZojJDDGZISYzxGSGmMwQkxliMkNMZojJDDGZ
ISYzxGSGmMwQkxliMkNMZojJDDGZISYzxGSGmMwQkxliMkNMZojJDDGZISYzxGSGmMwQkxliMkNM
ZojJDDGZISYzxGSGmMwQkxliMkNMZojJDDGZISYzxGSGmMwQkxliMkNMZojJDDGZISYzxGSGmMwQ
kxliMkNMZojJDDGZISYzxGSGmMwQkxliMkNMZojJDDGZISYzxGSGmMwQkxliMkNMZojJDDGZISYz
xGSGmMwQkxliMkNMZojJDDGZISYzxGSWmMwSk1liMktMZonJLDGZJSazxGSWmMwSk1liMktMZonJ
LDGZJSazxGSWmMwSk1liMktMZonJLDGZJSazxGSWmMwSk1liMktMZonJLDGZJSazxGSWmMwSk1li
MktMZonJLDGZJSazxGSWmMwSk1liMktMZonJLDGZJSazxGSWmMwSk1liMktMZonJLDGZJSazxGSW
mMwSk1liMktMZonJLDGZJSazxGSWmMwSk1liMktMZonJLDGZJSazxGSWmMwSk1liMktMZonJLDGZ
JSazxGSWmMwSk1liMktMZonJLDGZJSazxGSWmMwSk1liMktMZonJLDGZJSazxGSWmMwSk1liMktM
5hCTOcRkDjGZQ0zmEJM5xGQOMZlDTOYQkznEZA4xmUNM5hCTOcRkDjGZQ0zmEJM5xGQOMZlDTOYQ
kznEZA4xmUNM5hCTOcRkDjGZQ0zmEJM5xGQOMZlDTOYQkznEZA4xmUNM5hCTOcRkDjGZQ0zmEJM5
xGQOMZlDTOYQkznEZA4xmUNM5hCTOcRkDjGZQ0zmEJM5xGQOMZlDTOYQkznEZA4xmUNM5hCTOcRk
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
c27hObfwnFt4zi085xaecwvPuYXn3MJzbuE5t/CcW3jOLTznFp5zC6+5hdfcwmtu4TW38JpbeM0t
vOYWXnMLr7mF19zCa27hNbfwmlt4zS285hZecwuvuYXX3MJrbuE1t/CaW3jNLbzmFl5zC6+5hdfc
wmtu4TW38JpbeM0tvOYWXnMLr7mF19zCa27hNbfwmlt4zS285hZecwuvuYXX3MJrbuE1t/CaW3jN
LbzmFl5zC6+5hdfcwmtu4TW38JpbeM0tvOYWXnMLr7mF19zCa27hNbfwmlt4zS285hZecwuvuYXX
3MJrbuE1t/CaW3jNLbzmFl5zC6+5hdfcwmtu4TW38JpbeM0tvOYWXnMLr7mF19zCa27hNbfwmlt4
zS285hZecwuvuYXX3MJrbuE1t/CaW3jNLbzmFl5zC6+5hdfcwmtu4TW38J5beM8tvOcW3nML77mF
99zCe27hPbfwnlt4zy285xbecwvvuYX33MJ7buE9t/CeW3jPLbznFt5zC++5hffcwntu4T238J5b
eM8tvOcW3nML77mF99zCe27hPbfwnlt4zy285xbecwvvuYX33MJ7buE9t/CeW3jPLbznFt5zC++5
hffcwntu4T238J5beM8tvOcW3nML77mF99zCe27hPbfwnlt4zy285xbecwvvuYX33MJ7buE9t/Ce
W3jPLbznFt5zC++5hffcwntu4T238J5beM8tvOcW3nML77mF99zCe27hPbfwnlt4zy285xbecwvv
uYX33MJ7buE9t/CeW3jPLbznFt5zC++5hffcwntu4T238J5beM8tvOcW3nMLv3MLv3MLv3MLv3ML
v3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3ML
v3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3ML
v3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3ML
v3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3ML
v3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3MLv3ML
v3MLf+YW/swt/Jlb+DO38Gdu4c/cwp+5hT9zC3/mFv7MLfyZW/gzt/BnbuHP3MKfuYU/cwt/5hb+
zC38mVv4M7fwZ27hz9zCn99t4d9+9/L25eN/fPn8z/7l4w+/+qB3H396+/T5893TX+bff/sfH969
fP4Ef37/w8vr3/fr5+/C///j9us/m8a797/+J/byz7r/2bSeeP/r6fnlKuub8/Lpf/72/uWnt7++
ffzvt5e3j59e3v/9b+/fff6a/rEJ2CRsCjYNm53r51+NxOHRYegwdShf8Hqe2OnL1uXnV40tTxxe
Bi9Tl8X/nZ+f7r+13N+sswpm+fln19Uw/PlPtcMp9zfP2T//zgoM+/z8a2E4vDp8cLjoik/Xur5c
vNy8PLwMXiYvi5fNy8vLR5cPN3q40cONHvjO8fn/vHHOeXQZr7xcvNy85K9Ivhf+skxeFi+bl5eX
3Ci5UXKj5EbJjZIbJTdKbpTcKLlRcqPiRsWNihsVNypuVNyouFFxo+JGxY2aGzU3am7U3Ki5UXOj
5kbNjZobNTe63Ohyo8uNLje63Ohyo8uNLje63Ohyo4cbPdzo4Ub+U9DDjR5u9HCjhxs93OjRRvH6
ysvFy83Lw8vgZfKyeNm8pEYd69V+Vvyy9M/56NJ+VvyyXLzcvDy8DF4mL4uX3Ci5UXKj4kbFjYob
FTcqblTcqLhRcaPiRsWNmhs1N2pu1NyouVFzo+ZGzY2aGzU3utzocqPLjS43utzocqPLjS43utzo
cqOHGz3c6OFGDzd6uNHDjR5u9HCjhxs92mi9vvJy8XLz8vAyeJm8LF42Ly8vudHiRosbLW60uNHi
RosbLW60uNHiRosbbW60udHmRpsbbW60udHmRpsbbW60udHhRocbHW50uNHhRocbHW50uNHhRocb
BTcKbhTcKLhRcKPgRsGN2BkWO8NiZ1jsDIudYbEzLHaGxc6w2BkWO8NiZ1jsDIudYbEzLHaGxc6w
2BkWO8NiZ1jsDIudYbEzLHaGxc6w2BkWO8NiZ1jsDIudYbEzLHaGxc6w2BkWO8NiZ1jsDIudYbEz
LHaGxc6w2BkWO8NiZ1jsDIudYbEzLHaGxc6w2BkWO8NiZ1jsDIudYbMzbHaGzc6w2Rk2O8NmZ9js
DJudYbMzbHaGzc6w2Rk2O8NmZ9jsDJudYbMzbHaGzc6w2Rk2O8NmZ9jsDJudYbMzbHaGzc6w2Rk2
O8NmZ9jsDJudYbMzbHaGzc6w2Rk2O8NmZ9jsDJudYbMzbHaGzc6w2Rk2O8NmZ9jsDJudYbMzbHaG
zc6w2Rk2O8NmZ9jsDJudYbMzbHaGzc6w2Rk2O8NmZ9jsDJudYbMzbHaGzc6w2Rk2O8NmZ9jsDJud
YbMzbHaGzc6w2Rk2O8NmZ9jsDJudYbMzbHaGzc6w2Rk2O8NmZ9jsDJudYbMzbHaGzc6w2Rk2O8Nm
Z9jsDJudYbMzbHaGzc6w2RkOO8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjsDIed4bAzHHaGw85w
2BkOO8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjsDIed4bAz
HHaGw85w2BkOO8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjs
DIed4bAzHHaGw85w2BkOO8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjsDIed4bAzHHaGw85w2BkO
O8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjsDIed4bAzHHaGw85w2BkOO8NhZzjsDIedIdgZgp0h
2BmCnSHYGYKdIdgZgp3Bf8c22BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKd
IdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHY
GYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmC
nSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h2BmCnSHYGYKdIdgZgp0h
2BnCnGG97lckyK/T5dPt0+PT3/FlpU/Lp+3T69OHp9drXa91vdb1WtdrXa91vdb1WtdrXa/1eK3H
az1e6/Fav+NbxuO1Hq/1eK3Haz1cC4Hy63T5dPv0+DR8mj4tn7ZPr0+91vJay2str7W81vJay2st
r7W81vJay2ttr7W91vZa22ttr7W91vZa22ttr7W91vFax2sdr3W81vFax2sdr3W81vFax2uF1wqv
FV4rvFZ4rfBa4bXCa4XXCq+VXiu9Vnqt9FrptdJrpddKr5VeK71Wea3yWuW1ymuV1yqvVV6rvFZ5
rfJabhnhlhFuGeGWEW4Z4ZYRbhnhlhFuGeGWEW4Z4ZYRbhnhlhFuGeGWEW4Z4ZYRbhnhlhFuGeGW
EW4Z4ZbxO/gz3DLCLSPcMsItI9wy0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLS
LSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j
3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y
0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtIt
I90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMtItI90y0i0j3TLSLSPdMsoto9wyyi2j3DLKLaPc
Msoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLK
LaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j
3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wy
yi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsoto9wyyi2j3DLKLaPcMsot
o9wyyi2j3DLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPd
Mtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLa
LaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j
3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90y
2i2j3TLaLaPdMtoto90y2i2j3TLaLaPdMtoto90yrlvGdcu4bhnXLeO6ZVy3jOuWcd0yrlvGdcu4
bhnXLeO6ZVy3jOuWcd0yrlvGdcu4bhnXLeO6ZVy3jOuWcd0yrlvGdcu4bhnXLeO6ZVy3jOuWcd0y
rlvGdcu4bhnXLeO6ZVy3jOuWcd0yrlvGdcu4aBlZ+vdnv06vTx+e4ovzy3T51C+AL84v0/Bp+rR8
6rXKa5XXaq/VXqu9Vnut9lrttdprtddqr9Ve63qt67Wu17pe63qt67Wu17pe63qt67Uer/V4rcdr
PV7r8VqP13q81uO1Hq/1cC38U7Vfp8un26fHp+HT9Gn5tH16feq1ltdaXmt5reW1ltdaXmt5reW1
ltdaXmt7re21ttfaXmt7re21ttfaXmt7re21jtc6Xut4reO1jtc6Xut4reO1jtc6Xiu8Vngtf3Hi
X7X9OvVa4bXCa4XXCq8VXiu9Vnqt9FrptdJrpddKr+WWcdwyjlvGccs4bhnHLeO4ZRy3jOOWcdwy
jlvGccs4bhnHLeO4ZRy3jOOWcdwyjlvGccs4bhnHLeO4ZRy3jOOWcdwyjlvGccs4bhnHLeO4ZRy3
jOOWcdwyjlvGccs4bhnHLeO4ZRy3jOOWcdwyjltGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhl
hFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRb
RrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4
ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWE
W0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrhlhFtGuGWEW0a4ZYRbRrplpFtG
umWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrpl
pFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRb
RrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6
ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWkW0a6ZaRbRrplpFtGumWk
W0a6ZaRbRrplpFtGumWkW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtG
uWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrll
lFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRb
RrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5ZZRbRrlllFtGuWWUW0a5
ZZRbxr/+axP/9eHtry/vPv709unl+w8/fv/tp3f/+fKXjz+8fHj7+N37l88/TP3727ffv3/50x/+
+PL2Zbv++HX+/ruX/Rsffdfz649//b+PX//23Ycf3318e/vyn/LLB0VknNfX+49/71+MHhitVxkt
GW0ZHRmFjFJGJaOWkVx8ycW3XHzLxbdcfMvFt1x8y8W3XHzLxbdcfMvFj1z8yMWPXPzIxY9c/MjF
j1z8yMWPXPzIxUMuHnLxkIuHXDzk4iEXD7l4yMVDLh5y8ZSLp1w85eIpF0+5eMrFUy6ecvGUi6dc
vOTiJRcvuXjJxUsuXnLxkouXXLzk4iUXb7l4y8VbLt5y8ZaLt1y85eItF2+5eMvFr1z8ysWvXPzK
xa9c/MrFr1z8ysWvXPzKxR+5+CMXf+Tij1z8kYs/cvFHLv7IxR+5+AMXX6+vMloy2jI6MgoZpYxK
Ri2jKyO5uLw5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5l7w5
l7w512+8OSujopM+k2SRh+mSh+mSh+mSh+n639buKLlxHAbC8PuexgBJkLz/xTau2DWuyuzyk2be
O4Dyq0GzaVuWYBoSTEOCaUgwDQmmIcE0JJiGBNOQYBoSTEOCaUgwDQmmIcE0JJiGBNOQYBoSTEOC
aUgwDQmmIcE0JJgGLRgSTEOCaUgwDQmmIcE0JJiGBNOQYBoSTEOCaUgwDQmmIcE0JJiGBNOQYBqf
wfT/34d4vqrl+M17EfPzvYz/bjQuNmr33vSIz4BMjfrdRvNio3G30brYqO42Ehd/hn26mnXzauTA
ID4PDOBqnh8cvXk17WKjuNuoX2yUdxuNi43uTuSqi43uTuSaFxvdnci1Lja6O5Gfh0HUaN5sJAdK
8XmgRFez717NxamOu1O9L0513J3qfXGq4zDVVOPuwO6LK0PcHVg56It9carj7rDti1Md8y/co/Xn
NfLxF2pcN/bzD2e/+nKVebfRRVNmu9uojqc7X6IpoiWiDaLD8vwShYhSRE1EXURDREJ8C/EtxDcQ
H4+HiEJEKaImoi6iIaIS0RTREpEQDyEeQjyEeAjxEOIhxEOIhxAPIR5n4n003l2ur+AUzx81v7qk
zhpt5eGs6SUKEaWImoi6iIaISkRTREtEG0RTiE8hPoX4FJhTYE6BOQXmFJhTYC6BuQTmEphL7LuE
+BLiS4gvIb6E+BLiW4hvIb6F+BbiW4hvIb6F+GG/E89na45xsMFbNUhVpLLrWqTaojqY4a0KUiWp
GqmI/Sb2m9ibJzax38K+Hg9SBamSVAf2Oebqq1mtTrUa1RpUq1OtolqDak2qVVRrUa1JtTbVEq/W
IRq8a5GjDwniVauT7w9B412LpiPI9518H+T7Tr4P8n0n3wf5vpPvg3zfyfdBvu/k+yDfd/J9ku87
+T7J94N8n+T7Qb5P8v0g3yf5fpDvk3w/yPdJvh/k+yTfD/J9ku8H+T7J94N838j3g3zfyPdFvm/k
+yLfN/J9ke8b+b7I9418XyffV9stbZVrNB01qKN5YkotWwuPO5jvWuaJTbXIE8cdzHct8sRxB/Nd
i9bC4w7muxathccdzHctWgs7OdrWwk5etbXwuIP5rkW+7+T7IucUeaLobhfdR1tzbJ0oolrGi1aA
otmexH4S+0nsJ7GfxH4S+0nsJ7GfxH4S+0XsF7FfxH4R+0XsF7FfxH4R+0XsF7HfxH4T+03sN7Hf
xH4T+03sN7HfxH4L+/Z4kCpIlaRqpOqkGqQqUk1SLVIR+yD2pzOriP18/EqSqpGqk2qQqkg1SbVI
tUV1Ol15qYh9Evsk9knsk9gnsU9in8Q+iX0j9o3YN2LfiH0j9o3YN2LfiH0j9o3Yd2LfiX0n9p3Y
d2LfiX0n9p3Yd2Lfif0g9oPYD2I/iP0g9oPYD2I/iP0g9oPYF7EvYl/Evoh9Efsi9kXsi9gXsS9i
P4n9JPaT2E9iP4n9Kdc+cnztvk776JcqSJWkaqTqpLL/sUg1SbVItUUVxD6IfRD7IPZB7IPYB7EP
Yh/EPoh9Evsk9knsk9gnsU9in8Q+iX0S+yT2jdg3Yt+IfSP2jdg3Yt+IfSP2jb/j8/xBv/Z83MmP
zzzXr888j9+2qmr9+PH5t2qRaovqtAi+VEGqgxn2rJan58K+VVTrZNKXymrx9/pifSWd51MBf9zm
8es290OR0WrNx/6zL+3F41FVX9fz81upzx3iu0zlP/8C/olslW+qBAA=

------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------- =_aaaaaaaaaa0--
