Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63B887F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 11:15:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08443AC009
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 09:15:15 -0700 (PDT)
Date: Thu, 24 Oct 2013 09:15:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 4/4] xfsprog: add mkfs.xfs sb v4 support for dirent
	filetype field
Message-ID: <20131024161514.GA14558@infradead.org>
References: <20131017152804.204045257@sgi.com>
	<20131017152955.689963160@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131017152955.689963160@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 17, 2013 at 10:28:08AM -0500, Mark Tinguely wrote:
> Add directory inode type feature to mkfs.xfs and its manual page.
> 
> In sb v4, "mkfs.xfs -n ftype=1" turns on the feature.
> 
> The feature is automatically turned on for "-m crc=1", but reject
> the use of the "-n ftype=0|1" with the "-m crc=1" option.

Seems like this causes a spurious failure in xfs/206:


--- tests/xfs/206.out	2013-09-09 14:41:08.000000000 +0000
+++ /root/xfstests/results//xfs/206.out.bad	2013-10-24 16:13:54.000000000 +0000
@@ -5,26 +5,26 @@
          =                       sectsz=512   attr=2
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
-naming   =version 2              bsize=4096   ascii-ci=0
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
 log      =internal log           bsize=4096   blocks=XXXXX, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
 realtime =none                   extsz=4096   blocks=0, rtextents=0
 === xfs_growfs ===
 meta-data=FILE                   isize=256    agcount=52, agsize=76288719 blks
-         =                       sectsz=512   attr=2
+         =                       sectsz=512   attr=2, projid32bit=1
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
-naming   =version 2              bsize=4096   ascii-ci=0
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
 log      =internal               bsize=4096   blocks=XXXXX, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
 realtime =none                   extsz=4096   blocks=0, rtextents=0
 data blocks changed from 3905982455 to 4882478016
 === xfs_info ===
 meta-data=FILE                   isize=256    agcount=64, agsize=76288719 blks
-         =                       sectsz=512   attr=2
+         =                       sectsz=512   attr=2, projid32bit=1
 data     =                       bsize=4096   blocks=4882478016, imaxpct=5
          =                       sunit=0      swidth=0 blks
-naming   =version 2              bsize=4096   ascii-ci=0
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
 log      =internal               bsize=4096   blocks=XXXXX, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
 realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
