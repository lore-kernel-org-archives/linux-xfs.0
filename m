Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 21:24:37 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m155OB2F027535
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 21:24:14 -0800
Date: Tue, 5 Feb 2008 16:24:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Possible fix for 2.6.24 xfs_file_readdir crash
Message-ID: <20080205052418.GU155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: xfs@oss.sgi.com, Tobias Ulmer <tu@emlix.com>, Andrea Perotti <andreamtp@goodfellow.it>

Sven, Tomas, Andrea:

Can you try the patch attached below to see if it fixes the
xfs_file_readdir() oops you are seeing and let me know if it fixes
the problem?

It looks like we're deferencing a pointer beyond the end of a buffer
if the buffer is filled exactly. This bug does not crash ia64 (even
with memory poisoning enabled), which is why the targeted corner
case testing I did a while back did not pick this up when fixing a
similar bug a month ago.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
Fix yet another corner case oops in xfs_file_readdir().

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_file.c	2008-01-16 16:24:01.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c	2008-02-05 15:13:17.153110696 +1100
@@ -351,8 +351,8 @@ xfs_file_readdir(
 
 		size = buf.used;
 		de = (struct hack_dirent *)buf.dirent;
-		curr_offset = de->offset /* & 0x7fffffff */;
 		while (size > 0) {
+			curr_offset = de->offset /* & 0x7fffffff */;
 			if (filldir(dirent, de->name, de->namlen,
 					curr_offset & 0x7fffffff,
 					de->ino, de->d_type)) {
@@ -363,7 +363,6 @@ xfs_file_readdir(
 				       sizeof(u64));
 			size -= reclen;
 			de = (struct hack_dirent *)((char *)de + reclen);
-			curr_offset = de->offset /* & 0x7fffffff */;
 		}
 	}
 
