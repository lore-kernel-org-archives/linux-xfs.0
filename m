Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F8AA7F3F
	for <xfs@oss.sgi.com>; Sun, 21 Jul 2013 01:23:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B25E304059
	for <xfs@oss.sgi.com>; Sat, 20 Jul 2013 23:23:43 -0700 (PDT)
Received: from mail-gh0-f182.google.com (mail-gh0-f182.google.com
	[209.85.160.182]) by cuda.sgi.com with ESMTP id
	aOq5zZWQ2lqCUYon (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 20 Jul 2013 23:23:41 -0700 (PDT)
Received: by mail-gh0-f182.google.com with SMTP id z15so1758629ghb.13
	for <xfs@oss.sgi.com>; Sat, 20 Jul 2013 23:23:41 -0700 (PDT)
Message-ID: <51EB7E6B.8080607@gmail.com>
Date: Sun, 21 Jul 2013 02:23:39 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/49] current patch queue for 3.12
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/2013 02:24 AM, Dave Chinner wrote:
> Hi folks,
> 
> The following mass of patches is my current patch queue I have
> pending for the 3.12 cycle.

OK, it seems to be going okay:  The PC is still functioning, even on 
a CRC-enabled / partition.  The `git am` session had these anomalies:

# Patch #5
Applying: xfs: separate dquot on disk format definitions out of xfs_quota.h
/usr/src/kernel-git/linux/.git/rebase-apply/patch:138: trailing whitespace.
 * This header file defines all the on-disk format definitions for 
warning: 1 line adds whitespace errors.

# Patch #15
Applying: xfs: move getdents code into it's own file
/usr/src/kernel-git/linux/.git/rebase-apply/patch:1266: new blank line at EOF.
+
warning: 1 line adds whitespace errors.

########
There were build errors as well with gcc-4.8.1:

  CC      fs/xfs/xfs_inode_fork.o
fs/xfs/xfs_inode_fork.c:43:23: fatal error: xfs_utils.h: No such file or directory
 #include "xfs_utils.h"
                       ^
compilation terminated.
make[2]: *** [fs/xfs/xfs_inode_fork.o] Error 1
make[1]: *** [fs/xfs] Error 2
make: *** [fs] Error 2
# next try...
  CC      fs/xfs/xfs_inode_fork.o
fs/xfs/xfs_inode_fork.c:49:26: fatal error: xfs_vnodeops.h: No such file or directory
 #include "xfs_vnodeops.h"
                          ^
compilation terminated.
make[2]: *** [fs/xfs/xfs_inode_fork.o] Error 1
make[1]: *** [fs/xfs] Error 2
make: *** [fs] Error 2

########
Hopefully, I didn't leave a patch out.  To get the code to build fully, 
these patches were applied:

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index f06570b..123971b 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -40,10 +40,8 @@
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
-#include "xfs_utils.h"
 #include "xfs_quota.h"
 #include "xfs_filestream.h"
-#include "xfs_vnodeops.h"
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-- 
1.8.3.2

diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index e3f4b4e..9224296 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -137,7 +137,8 @@ xfs_log_calc_minimum_size(
 	 * it up to lsunit boundary if lsunit is specified.
 	 */
 	if (lsunit)
-		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
+		min_logblks = roundup((int)BTOBB(max_logres), lsunit) 
+			+ 2 * lsunit;
 	else
 		min_logblks = BTOBB(max_logres);
 	min_logblks *= XFS_MIN_LOG_FACTOR;
-- 
1.8.3.2

That's about all, so far.  There's something going wrong with a 2k 
non-CRC XFS filesystem that I should track before doing too much with 
xfstests.  The initial results on a 32-bit Pentium 4 looked promising.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
