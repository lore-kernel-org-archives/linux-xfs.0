Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZeIg126986 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:40 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 2/8] xfsprogs: unconditionally drop used buffer reference
Date: Thu, 10 Nov 2011 14:35:12 -0600
Message-Id: <f4640a738a62150c745c843b92c5d143ad1cb155.1320955675.git.aelder@sgi.com>
In-Reply-To: <1320957318-16269-1-git-send-email-aelder@sgi.com>
References: <1320957318-16269-1-git-send-email-aelder@sgi.com>
In-Reply-To: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
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
Cc: Alex Elder <aelder@sgi.com>

In libxfs_mount(), after reading the last block in the log device,
the buffer is released by a call to libxfs_putbuf().  But it's done
only if bp is non-null.  It always will be non-null at this point,
so just make the call unconditionally.

Also touch up a misleading indent.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxfs/init.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 08fc584..ba44c9b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -743,15 +743,14 @@ libxfs_mount(
 			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
 				return NULL;
 		}
-		if (bp)
-			libxfs_putbuf(bp);
+		libxfs_putbuf(bp);
 	}
 
 	/* Initialize realtime fields in the mount structure */
 	if (rtmount_init(mp, flags)) {
 		fprintf(stderr, _("%s: realtime device init failed\n"),
 			progname);
-			return NULL;
+		return NULL;
 	}
 
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
