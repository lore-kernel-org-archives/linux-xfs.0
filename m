Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p182K97V084188 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 20:20:09 -0600
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDCDE2BB2B0
	for <xfs@oss.sgi.com>; Mon,  7 Feb 2011 18:22:42 -0800 (PST)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	aXdlVXPUd5wx19vC for <xfs@oss.sgi.com>;
	Mon, 07 Feb 2011 18:22:42 -0800 (PST)
Received: by mail-vx0-f181.google.com with SMTP id 38so2217943vxc.26
	for <xfs@oss.sgi.com>; Mon, 07 Feb 2011 18:22:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=FMmJEipcJPa--y3Pmg+K9W8e3JVyhgSpBP-qu@mail.gmail.com>
References: <AANLkTim2nm9SXPmpRUmK8eWxXYFkPcrzc-gw2ceJ-m2-@mail.gmail.com>
	<1297127823.2078.24.camel@doink>
	<AANLkTi=FMmJEipcJPa--y3Pmg+K9W8e3JVyhgSpBP-qu@mail.gmail.com>
Date: Tue, 8 Feb 2011 11:22:42 +0900
Message-ID: <AANLkTimzasfep=tcTZzUe1M6V_hOxHndG+qRwx0qG=3F@mail.gmail.com>
Subject: Re: [patch] xfsprogs: unhandled error check in libxfs_trans_read_buf
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: aelder@sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

xfsprogs: unhandled error check in libxfs_trans_read_buf

libxfs_trans_read_buf() is used in both mkfs.xfs & xfs_repair.
During stability testing we found some time occur pagefault in mkfs.xfs,
code inspection shows that if libxfs_readbuf() fails then occurs a
page fault in xfs_buf_item_init() called in libxfs_trans_read_buf().

mkfs.xfs: unhandled page fault (11) at 0x00000070, code 0x017

Added NULL check and errno handling.

diff -Nurp xfsprogs/libxfs/rdwr.c xfsprogs-dirty/libxfs/rdwr.c
--- xfsprogs/libxfs/rdwr.c      2011-01-28 20:22:11.000000000 +0900
+++ xfsprogs-dirty/libxfs/rdwr.c        2011-02-02 16:59:16.000000000 +0900
@@ -207,10 +207,11 @@ libxfs_trace_readbuf(const char *func, c
 {
        xfs_buf_t       *bp = libxfs_readbuf(dev, blkno, len, flags);

-       bp->b_func = func;
-       bp->b_file = file;
-       bp->b_line = line;
-
+       if (bp){
+               bp->b_func = func;
+               bp->b_file = file;
+               bp->b_line = line;
+       }
        return bp;
 }

diff -Nurp xfsprogs/libxfs/trans.c xfsprogs-dirty/libxfs/trans.c
--- xfsprogs/libxfs/trans.c     2011-01-28 20:22:11.000000000 +0900
+++ xfsprogs-dirty/libxfs/trans.c       2011-02-02 17:00:42.000000000 +0900
@@ -508,6 +508,10 @@ libxfs_trans_read_buf(
        }

        bp = libxfs_readbuf(dev, blkno, len, flags);
+       if (!bp){
+               *bpp = NULL;
+               return errno;
+       }
 #ifdef XACT_DEBUG
        fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
 #endif

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
