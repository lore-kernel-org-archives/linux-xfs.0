Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBD77aij013696 for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 01:07:36 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2190172A608
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 23:07:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id JfeAi3WDGyejC6pB for <xfs@oss.sgi.com>;
	Fri, 12 Dec 2008 23:07:34 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id A11A0A883C2
	for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 01:07:32 -0600 (CST)
Message-ID: <49435F35.40109@sandeen.net>
Date: Sat, 13 Dec 2008 01:07:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix corruption case for block size < page size
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
To: xfs-oss <xfs@oss.sgi.com>

On a 4k page system and 512-byte blocksize, this:

xfs_io \
-c "pwrite -S 0x11 -b 4096 0 4096" \
-c "mmap -r 0 512" -c "mread 0 512" -c "munmap" \
-c "truncate 256" \
-c "truncate 513" \
-c "pwrite -S 0x22 -b 512 2048 512" \
-t -d -f testfile

leads to this in the resulting file:

# 00000000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
# *
# 00000100  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
# *
# 00000400  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................| <- BAD
# *
# 00000800  22 22 22 22 22 22 22 22  22 22 22 22 22 22 22 22  |""""""""""""""""|
# *
# 00000a00

laid out like this:

 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..4]:          63..67            0 (63..67)             5

which is wrong.  :)  The 2nd series of 1's should be a hole;
it is stale data left over from the original write which gets re-
mapped in xfs_page_state convert; this is largely because on
the previous truncate down, discard_buffer() leaves the discarded
bh uptodate - due to page vs. bh uptodate rules, I think.

This all got turned up by xfsqa 091 on ppc with 64k pages & 4k blocks;
see also http://oss.sgi.com/bugzilla/show_bug.cgi?id=801.
This would hit 64k page ia64 as well.

This could probably use a bit more investigation; why for example
is the mmap read needed above; but the below fixes the problem for
me, by recognizing an uptodate but not dirty or mapped buffer at
this stage as a hole.  At any rate it certainly doesn't need to
be written (not dirty)...

I previously submitted an xfsqa testcase for this too.

I've run it through qa but more soak time would probably be good.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c
@@ -1042,6 +1042,13 @@ xfs_page_state_convert(
 			continue;
 		}
 
+		/* This means its a hole (discard_buffer leaves uptodate set) */
+		if (!buffer_dirty(bh) && !buffer_mapped(bh) &&
+		    buffer_uptodate(bh)) {
+			iomap_valid = 0;
+			continue;
+		}
+
 		if (iomap_valid)
 			iomap_valid = xfs_iomap_valid(&iomap, offset);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
