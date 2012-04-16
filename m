Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GKx4jF245880 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 15:59:05 -0500
Received: from andromeda.usersys.redhat.com (186.215.132.159.static.gvt.net.br
	[186.215.132.159]) by cuda.sgi.com with ESMTP id
	N7ccyPbPNsaTnBKv for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 13:59:03 -0700 (PDT)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] mkfs: Set a clean output in case of invalid inode size
Date: Mon, 16 Apr 2012 17:56:56 -0300
Message-Id: <1334609816-8473-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Carlos Maiolino <cmaiolino@redhat.com>

Remove an unnecessary usage() call after a mkfs failure due an invalid inode
size.
A call to usage() at this point confuses the output message which may cause the
user to think it used wrong arguments to mkfs, instead of an invalid inode size.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5445b6f..19d4815 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1898,7 +1898,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 			fprintf(stderr,
 	_("allowable inode size with %d byte blocks is between %d and %d\n"),
 				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
-		usage();
+		exit(1);
 	}
 
 	/* if lsu or lsunit was specified, automatically use v2 logs */
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
