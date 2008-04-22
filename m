Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 19:35:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M2Yv2l020881
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 19:34:59 -0700
Date: Tue, 22 Apr 2008 12:35:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Wrong patch checked in....
Message-ID: <20080422023533.GS103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Folks,

I just noticed my builds were coming up with warnings inside
QUOTADEBUG code. I never saw a patch go past that enabled it
for debug kernels, so I was kinda confused until I found this:

chook 232% p_modinfo -h xfs-linux-melb:xfs-kern:30878a

mod xfs-linux-melb:xfs-kern:30878a header
==========================================
 - SM_Location:  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
 - Workarea:     linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
 - xfs-linux-melb:xfs-kern:30878a 04/15/08
 - PV Incidents affected:        971046
 - Inspected by:         hch
 - Description:
   Remove unused HAVE_SPLICE macro.

   HAVE_SPLICE was part of the infrastructure for building 2.4 and 2.6
   kernels out of the same tree. Now we don't build 2.4 kernels this
 - Files affected:       xfs.h 1.51
 - Author:       donaldd
 - xfs.h:
   Remove unused HAVE_SPLICE macro.

Which was supposed to be:

http://oss.sgi.com/archives/xfs/2008-04/msg00246.html

--- a/fs/xfs/linux-2.6/xfs_linux.h      2008-04-08 13:23:55.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_linux.h      2008-04-08 12:09:22.455341741 +1000
@@ -99,7 +99,6 @@
 /*
  * Feature macros (disable/enable)
  */
-#define HAVE_SPLICE    /* a splice(2) exists in 2.6, but not in 2.4 */
 #ifdef CONFIG_SMP
 #define HAVE_PERCPU_SB /* per cpu superblock counters are a 2.6 feature */
 #else

What got checked in was:

% p_rdiff -uM xfs-linux-melb:xfs-kern:30878a
--- a/xfs.h     2008-04-22 12:28:12.000000000 +1000
+++ b/xfs.h     2008-04-22 12:28:12.000000000 +1000
@@ -22,7 +22,7 @@
 #define STATIC
 #define DEBUG 1
 #define XFS_BUF_LOCK_TRACKING 1
-/* #define QUOTADEBUG 1 */
+#define QUOTADEBUG 1
 #endif

 #ifdef CONFIG_XFS_TRACE

Seeing as this mod has already made it to Linus, we can't revert it easily.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e687330b5ed1ea899fdaf0dea50aba196b6e019a

Donald, can you do another checkin that returns xfs.h to it's previous
state and removes the HAVE_SPLICE stuff correctly?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
