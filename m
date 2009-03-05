Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n25EMD2v149667 for <xfs@oss.sgi.com>; Thu, 5 Mar 2009 08:22:13 -0600
Received: from mail-fx0-f176.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69BDA1737EC
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2009 06:21:46 -0800 (PST)
Received: from mail-fx0-f176.google.com (mail-fx0-f176.google.com
	[209.85.220.176]) by cuda.sgi.com with ESMTP id
	JOgzmdYULUCNyKWE for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2009 06:21:46 -0800 (PST)
Received: by fxm24 with SMTP id 24so3291169fxm.20
	for <xfs@oss.sgi.com>; Thu, 05 Mar 2009 06:21:45 -0800 (PST)
From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 05 Mar 2009 15:20:25 +0100
Message-ID: <20090305141912.22775.64010.stgit@f10box.hanneseder.net>
MIME-Version: 1.0
Subject: [PATCH 3/3 v2] xfs: include header files for prototypes
In-Reply-To: <20090305133917.GC14854@lst.de>
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net>
	<20090304183418.525.22262.stgit@f10box.hanneseder.net>
	<20090305133917.GC14854@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Fix this sparse warnings:
  fs/xfs/linux-2.6/xfs_ioctl.c:72:1: warning: symbol 'xfs_find_handle' was not declared. Should it be static?
  fs/xfs/linux-2.6/xfs_ioctl.c:249:1: warning: symbol 'xfs_open_by_handle' was not declared. Should it be static?
  fs/xfs/linux-2.6/xfs_ioctl.c:361:1: warning: symbol 'xfs_readlink_by_handle' was not declared. Should it be static?
  fs/xfs/linux-2.6/xfs_ioctl.c:496:1: warning: symbol 'xfs_attrmulti_attr_get' was not declared. Should it be static?
  fs/xfs/linux-2.6/xfs_ioctl.c:525:1: warning: symbol 'xfs_attrmulti_attr_set' was not declared. Should it be static?
  fs/xfs/linux-2.6/xfs_ioctl.c:555:1: warning: symbol 'xfs_attrmulti_attr_remove' was not declared. Should it be static?
  fs/xfs/linux-2.6/xfs_ioctl.c:657:1: warning: symbol 'xfs_ioc_space' was not declared. Should it be static?
  fs/xfs/linux-2.6/xfs_ioctl.c:1340:1: warning: symbol 'xfs_file_ioctl' was not declared. Should it be static?
  fs/xfs/support/debug.c:65:1: warning: symbol 'xfs_fs_vcmn_err' was not declared. Should it be static?
  fs/xfs/support/debug.c:112:1: warning: symbol 'xfs_hex_dump' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Christoph Hellwig <hch@lst.de>
---

On Thu, Mar 5, 2009 at 2:39 PM, Christoph Hellwig <hch@lst.de> wrote:
> looks good, except for a tiny nit-pick:

I still treat this as a Acked-by: ... Ok?

>> +++ b/fs/xfs/support/debug.c
>> @@ -19,6 +19,7 @@
>>  #include "debug.h"
>>
>>  /* xfs_mount.h drags a lot of crap in, sorry.. */
>> +#include "xfs_error.h"
>>  #include "xfs_sb.h"
>>  #include "xfs_inum.h"
>>  #include "xfs_ag.h"
>
> as xfs_mount.h doesn't require xfs_error.h it should be included
> above that comment.

hm. but that way it is still included before xfs_mount.h.


 fs/xfs/linux-2.6/xfs_ioctl.c |    1 +
 fs/xfs/support/debug.c       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 6f04493..d0b4994 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -34,6 +34,7 @@
 #include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_ioctl.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_rtalloc.h"
diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index ae54829..930bb34 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -17,6 +17,7 @@
  */
 #include <xfs.h>
 #include "debug.h"
+#include "xfs_error.h"
 
 /* xfs_mount.h drags a lot of crap in, sorry.. */
 #include "xfs_sb.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
