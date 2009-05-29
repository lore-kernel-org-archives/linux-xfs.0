Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TEoBmQ062069 for <xfs@oss.sgi.com>; Fri, 29 May 2009 09:50:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 726961B40D24
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 07:50:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FBfqF1VFT3hfDCwV for
	<xfs@oss.sgi.com>; Fri, 29 May 2009 07:50:26 -0700 (PDT)
Date: Fri, 29 May 2009 10:50:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests 206: test for overflow in growfs size
	calculation
Message-ID: <20090529145025.GA9205@infradead.org>
References: <4A1EF50D.8090900@redhat.com> <4A1EFE55.4020505@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1EFE55.4020505@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Richard.Ems@cape-horn-eng.com, xfs mailing list <xfs@oss.sgi.com>

On Thu, May 28, 2009 at 04:12:53PM -0500, Eric Sandeen wrote:
> Test trim of last small AG for large filesystem resizes
> 
> As reported at
> http://article.gmane.org/gmane.comp.file-systems.xfs.general/29187
> this trimming may cause an overflow in the new size calculation.
> 
> Patch to fix it, and testcase at
> http://article.gmane.org/gmane.comp.file-systems.xfs.general/29193
> 
> V2: now with proper expected (resized) output!

This fails for me in really weird ways (Debian -testing, i386):


--- 206.out	2009-05-29 14:44:54.000000000 +0000
+++ 206.out.bad	2009-05-29 14:46:01.000000000 +0000
@@ -1,30 +1,18 @@
 QA output created by 206
 === xfs_io ===
+ftruncate: File too large
 === mkfs.xfs ===
+existing superblock read failed: Success
+mkfs.xfs: pwrite64 failed: Invalid argument
 meta-data=FILE                   isize=256    agcount=52, agsize=76288719 blks
          =                       sectsz=512   attr=2
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
-log      =internal log           bsize=4096   blocks=32768, version=2
-         =                       sectsz=512   sunit=0 blks, lazy-count=0
-realtime =none                   extsz=4096   blocks=0, rtextents=0
-=== xfs_growfs ===
-meta-data=FILE                   isize=256    agcount=52, agsize=76288719 blks
-         =                       sectsz=512   attr=2
-data     =                       bsize=4096   blocks=3905982455, imaxpct=5
-         =                       sunit=0      swidth=0 blks
-naming   =version 2              bsize=4096   ascii-ci=0
-log      =internal               bsize=4096   blocks=32768, version=2
-         =                       sectsz=512   sunit=0 blks, lazy-count=0
-realtime =none                   extsz=4096   blocks=0, rtextents=0
-data blocks changed from 3905982455 to 4882478016
-=== xfs_info ===
-meta-data=FILE                   isize=256    agcount=64, agsize=76288719 blks
-         =                       sectsz=512   attr=2
-data     =                       bsize=4096   blocks=4882478016, imaxpct=5
-         =                       sunit=0      swidth=0 blks
-naming   =version 2              bsize=4096   ascii-ci=0
-log      =internal               bsize=4096   blocks=32768, version=2
+log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
 realtime =none                   extsz=4096   blocks=0, rtextents=0
+mount: /dev/loop0: can't read superblock
+!!! failed to loopback mount
+(see 206.full for details)
+umount: /mnt/test/tmpdir.4994: not mounted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
