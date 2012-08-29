Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7U7dYgf155472 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 02:39:34 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id LTpZpHGxDY8wa1XN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Aug 2012 00:40:20 -0700 (PDT)
Received: by dadg9 with SMTP id g9so1361370dad.26
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 00:40:20 -0700 (PDT)
Date: Thu, 30 Aug 2012 07:39:46 +0800
From: Chen Baozi <baozich@gmail.com>
Subject: xfstest fails at 018
Message-ID: <20120829233946.GA30212@centos-guest>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
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
To: xfs@oss.sgi.com


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi, all!

I tried to run xfstest on my machine and failed when running 018.
I've no idea where I'm wrong. Or it is already a reported failure. 
I'm wondering if someone could show me any clues about this. Here 
are some details:

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 centos-guest 3.6.0-rc1+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdc1
MOUNT_OPTIONS -- /dev/sdc1 /mnt/sdc1

018      - output mismatch (see 018.out.bad)
--- 018.out     2012-08-28 14:32:33.034895208 +0800
+++ 018.out.bad 2012-08-30 07:12:05.753944304 +0800
@@ -1,17 +1,6 @@
QA output created by 018
*** init FS
*** compare logprint: 018.op with
018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
-*** compare logprint: 018.trans_inode with
018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
-*** compare logprint: 018.trans_buf with
018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
-*** compare logprint: 018.op with
018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_inode with
018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_buf with
018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.op with
018.fulldir/op.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_inode with
018.fulldir/trans_inode.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_buf with
018.fulldir/trans_buf.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.op with
018.fulldir/op.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_inode with
018.fulldir/trans_inode.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_buf with
018.fulldir/trans_buf.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.op with
018.fulldir/op.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_inode with
018.fulldir/trans_inode.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
-*** compare logprint: 018.trans_buf with
018.fulldir/trans_buf.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+0  split(s) found prior to diff cmd:  37c22
+logprint output 018.op differs to
018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
considering splits
+(see 018.full for details)
Ran: 018
Failures: 018
Failed 1 of 1 tests

Thanks.

        Baozi

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered.diff"

9,24c9
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x3c newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
---
> TRAN: type: CHECKPOINT tid: <TID> num_items: 282
37c22
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
41,42c26,27
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
44c29
< size 0xf nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
48,69d32
< LOCAL inode data
< SHORTFORM DIRECTORY size 15
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x3b newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
81c44
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 24
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
85,86c48,49
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
88c51
< size 0x18 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
92,113d54
< LOCAL inode data
< SHORTFORM DIRECTORY size 24
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x3a newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
125c66
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 36
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
129,130c70,71
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
132c73
< size 0x21 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
136,157d76
< LOCAL inode data
< SHORTFORM DIRECTORY size 33
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x39 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
169c88
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 44
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
173,174c92,93
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
176c95
< size 0x2a nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
180,201d98
< LOCAL inode data
< SHORTFORM DIRECTORY size 42
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x38 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
213c110
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 52
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
217,218c114,115
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
220c117
< size 0x33 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
224,245d120
< LOCAL inode data
< SHORTFORM DIRECTORY size 51
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x37 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
257c132
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 60
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
261,262c136,137
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
264c139
< size 0x3c nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
268,289d142
< LOCAL inode data
< SHORTFORM DIRECTORY size 60
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x36 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
301c154
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 72
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
305,306c158,159
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
308c161
< size 0x45 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
312,333d164
< LOCAL inode data
< SHORTFORM DIRECTORY size 69
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x35 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
345c176
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 80
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
349,350c180,181
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
352c183
< size 0x4e nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
356,377d186
< LOCAL inode data
< SHORTFORM DIRECTORY size 78
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x34 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
389c198
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 88
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
393,394c202,203
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
396c205
< size 0x57 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
400,421d208
< LOCAL inode data
< SHORTFORM DIRECTORY size 87
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x33 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
433c220
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 96
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
437,438c224,225
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
440c227
< size 0x60 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
444,462c231,232
< LOCAL inode data
< SHORTFORM DIRECTORY size 96
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x32 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
464c234,240
< BUF DATA
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
477c253
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 108
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
481,482c257,258
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
484c260
< size 0x69 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
488,509d263
< LOCAL inode data
< SHORTFORM DIRECTORY size 105
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x31 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
521c275
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 116
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
525,526c279,280
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
528c282
< size 0x72 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
532,553d285
< LOCAL inode data
< SHORTFORM DIRECTORY size 114
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x30 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
565c297
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 124
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
569,570c301,302
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
572c304
< size 0x7b nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
576,597d307
< LOCAL inode data
< SHORTFORM DIRECTORY size 123
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x2f newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
609c319
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 132
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
613,614c323,324
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
616c326
< size 0x84 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
620,641d329
< LOCAL inode data
< SHORTFORM DIRECTORY size 132
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x2e newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
653c341
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 144
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
657,658c345,346
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
660c348
< size 0x8d nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
664,685d351
< LOCAL inode data
< SHORTFORM DIRECTORY size 141
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 4
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x2d newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
697c363
< INODE: #regs:R ino: <INO> flags: 0x3 dsize: 152
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
701,702c367,368
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
704c370
< size 0x96 nblocks 0x0 extsize 0x0 nextents 0x0
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
708,729d373
< LOCAL inode data
< SHORTFORM DIRECTORY size 150
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 8
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x2c newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
741c385
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
745,746c389,390
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
748c392
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
752,792d395
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGF Buffer: XAGF
< ver: 1 seq#: 0 len:<LEN>
< root BNO: 1 CNT: 2
< level BNO: 1 CNT: 1
< 1st:<NUM> last:<NUM> cnt:<COUNT> freeblks:<COUNT> longest:<NUM>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x2b newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
804c407
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
808,809c411,412
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
811c414
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
815,839d417
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x2a newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
851c429
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
855,856c433,434
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
858c436
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
862,883c440,441
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x29 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
885c443,449
< BUF DATA
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
898c462
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
902,903c466,467
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
905c469
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
909c473,474
< EXTENTS inode data
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
911,932c476,482
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x28 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
945c495
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
949,950c499,500
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
952c502
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
956,980d505
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x27 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
992c517
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
996,997c521,522
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
999c524
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1003,1027d527
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x26 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1039c539
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1043,1044c543,544
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1046c546
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1050,1074d549
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x25 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1086c561
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1090,1091c565,566
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1093c568
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1097,1107c572,573
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1109,1116c575,581
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x24 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1118c583,584
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1120c586,592
< BUF DATA
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1133c605
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1137,1138c609,610
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1140c612
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1144c616,617
< EXTENTS inode data
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1146c619,625
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1148,1150c627,628
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1152c630,636
< TRAN: type: CREATE tid: <TID> num_items: 5
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1154c638,639
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1156,1163c641,647
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x23 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1165c649,650
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1167c652,658
< BUF DATA
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1180c671
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1184,1185c675,676
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1187c678
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1191c682
< EXTENTS inode data
---
> BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
1193c684,688
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> AGF Buffer: XAGF
> ver: 1 seq#: 0 len:<LEN>
> root BNO: 1 CNT: 2
> level BNO: 1 CNT: 1
> 1st:<NUM> last:<NUM> cnt:<COUNT> freeblks:<COUNT> longest:<NUM>
1195,1197c690
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
---
> BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
1199c692
< TRAN: type: CREATE tid: <TID> num_items: 5
---
> BUF DATA
1203,1210c696,700
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x22 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
---
> BUF DATA
> Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
> BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
> Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
> BUF DATA
1227c717
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1231,1232c721,722
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1234c724
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1238,1262d727
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x21 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1274c739
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1277,1302c742,748
< Not printing rest
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Left over region from split log item
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x20 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1315c761
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1319,1320c765,766
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1322c768
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1326,1350d771
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x1f newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1362c783
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1366,1367c787,788
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1369c790
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1373,1397d793
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x1e newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1409c805
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1413,1414c809,810
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1416c812
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1420,1444d815
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x1d newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1456c827
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1460,1461c831,832
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1463c834
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1467,1491d837
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x1c newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1503c849
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1507,1508c853,854
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1510c856
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1514,1538d859
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x1b newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
1550c871
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1554,1555c875,876
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1557c878
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1561,1571c882,883
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1573,1580c885,891
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x1a newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1582c893,894
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
>  blkno: <BLKNO> len:<LEN> boff: <BOFF>
1584c896,902
< BUF DATA
---
> INODE CORE
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
> atime <TIME> mtime <TIME> ctime <TIME>
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
1597c915
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
1601,1602c919,920
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
1604c922
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
1608,4108d925
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x19 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x18 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x17 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x16 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x15 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x14 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x13 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x12 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x11 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x10 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Not printing rest
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0xf newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0xe newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0xd newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0xc newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0xb newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0xa newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x9 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x8 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x7 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x6 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x5 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x4 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x3 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Not printing rest
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x1 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
< level: 1 free#: 0x0 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 7
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x40 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGF Buffer: XAGF
< ver: 1 seq#: 0 len:<LEN>
< root BNO: 1 CNT: 2
< level BNO: 1 CNT: 1
< 1st:<NUM> last:<NUM> cnt:<COUNT> freeblks:<COUNT> longest:<NUM>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 3
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 3
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x3f newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x3e newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x3d newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x3c newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x3b newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x3a newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Not printing rest
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Left over region from split log item
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x39 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x38 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x37 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x36 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x35 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x34 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x33 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x32 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x31 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x30 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x2f newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x2e newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Left over region from split log item
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x2d newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x2c newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x2b newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x2a newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x29 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x28 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x27 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x26 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x25 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4120,4155d936
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x24 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4167,4204d947
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Not printing rest
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Left over region from split log item
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x23 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4216,4251d958
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x22 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4260,4297c967,968
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x21 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
---
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen <GEN>
4310c981
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
4314,4315c985,986
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
4317c988
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
4321,4345d991
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x20 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4357c1003
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
4361,4362c1007,1008
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
4364c1010
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
4368,4392d1013
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x1f newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4404c1025
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
4408,4409c1029,1030
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
4411c1032
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
4415,4439d1035
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x1e newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4451c1047
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
4455,4456c1051,1052
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
4458c1054
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
4462,4486d1057
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x1d newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4498c1069
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
4502,4503c1073,1074
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
4505c1076
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
4509,4533d1079
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x1c newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4545c1091
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
4549,4550c1095,1096
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
4552c1098
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
4556,4580d1101
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x1b newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4592c1113
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
---
> INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
4596,4597c1117,1118
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
---
> magic 0x494e mode 0100644 version <VERS> format <FORMAT>
> nlink 1 uid 0 gid 0
4599c1120
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
---
> size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
4603,4612d1123
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4617c1128
< level: 1 free#: 0x1a newino: <INO>
---
> level: 1 free#: 0x19 newino: <INO>
4624c1135
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
---
> BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
4628,4638d1138
< INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 0100644 version <VERS> format <FORMAT>
< nlink 1 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4652,4661d1151
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Not printing rest
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< Left over region from split log item
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< TRAN: type: CREATE tid: <TID> num_items: 5
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4664,4674d1153
< AGI Buffer: XAGI
< ver: 1 seq#: 0 len:<LEN> cnt: 128 root: 3
< level: 1 free#: 0x19 newino: <INO>
< bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
< bucket[16 - 19]: 0xffffffff
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
4687,4703d1165
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
<  blkno: <BLKNO> len:<LEN> boff: <BOFF>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< INODE CORE
< magic 0x494e mode 040755 version <VERS> format <FORMAT>
< nlink 2 uid 0 gid 0
< atime <TIME> mtime <TIME> ctime <TIME>
< size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
< naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
< flags 0x0 gen <GEN>
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< EXTENTS inode data
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
< Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
< BUF DATA
4706a1169
> TRAN: type: CHECKPOINT tid: <TID> num_items: 2
4707a1171
> BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
4708a1173,1174
> SUPER BLOCK Buffer:
> icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
4711a1178
> TRAN: type: CHECKPOINT tid: <TID> num_items: 2
4712a1180
> BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
4713a1182,1183
> SUPER BLOCK Buffer:
> icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
4714a1185,1189
> Oper (OPNUM): tid: <TID> len:<LEN> clientid: LOG flags: UNMOUNT
> Unmount filesystem
> xfs_logprint: skipped <COUNT> zeroed blocks in range: <COUNT> - <COUNT>
> xfs_logprint: physical end of log
> xfs_logprint: logical end of log

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--HcAYCG3uE/tztfnV--
