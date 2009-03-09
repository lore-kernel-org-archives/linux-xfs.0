Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n293NMYN112563 for <xfs@oss.sgi.com>; Sun, 8 Mar 2009 22:23:23 -0500
Received: from millhouse.houseofnate.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 319301C2826F
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2009 20:22:55 -0700 (PDT)
Received: from millhouse.houseofnate.net
	(dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by
	cuda.sgi.com with ESMTP id NJm4vvvWi8z3RYcO for
	<xfs@oss.sgi.com>; Sun, 08 Mar 2009 20:22:55 -0700 (PDT)
Message-ID: <49B48B8E.3030602@houseofnate.net>
Date: Sun, 08 Mar 2009 23:22:54 -0400
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: open filesystem device exclusively
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
To: xfs@oss.sgi.com

Hi folks,

I'm sure there is a better way to fix this, but without this patch, two
xfs_repair processes will happily operate on the same filesystem device
at the same time.  It is also possible to mount a filesystem that is in
the process of being repaired.

This seems like it's probably not ideal, so this patch just modifies
xfs_repair to open the filesystem device with O_EXCL unless it was
invoked in "no modify" or "dangerous" mode.

The net effect is that a 2nd xfs_repair will now safely fail with
"xfs_repair: cannot open /dev/foo: Device or resource busy", and a mount
command will fail with (the slightly cryptic) "mount: /dev/foo already
mounted or /mountpoint busy".

Note that this has no effect if the filesystem is stored in a regular
file instead of on a block device.

(Error messages could probably be improved to be more user-friendly in
this new failure case, and it probably wouldn't hurt to add a BLKROGET
ioctl to check for read-only block devices with read-write permissions,
but this should at least make things a bit safer.)

Signed-off-by: Nathaniel W. Turner <nate@houseofnate.net>
---
 repair/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/repair/init.c b/repair/init.c
index 8e508c4..3d88b8b 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -142,6 +142,8 @@ xfs_init(libxfs_init_t *args)
                args->isreadonly = (LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE);
        else if (dangerously)
                args->isreadonly = (LIBXFS_ISINACTIVE | LIBXFS_DANGEROUSLY);
+   else
+               args->isreadonly = LIBXFS_EXCLUSIVELY;

        if (!libxfs_init(args))
                do_error(_("couldn't initialize XFS library\n"));
-- 
1.5.6.3

-- 
Nathaniel W. Turner
http://houseofnate.net/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
