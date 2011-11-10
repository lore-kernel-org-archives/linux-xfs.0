Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZiud127039 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:44 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 6/8] xfsprogs: xfs_db: unmount fs before exiting
Date: Thu, 10 Nov 2011 14:35:16 -0600
Message-Id: <f91d3489cdc9ad68b6dac8224cf761fb2c51ad1e.1320955676.git.aelder@sgi.com>
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
Cc: Kevan Rehm <kfr@sgi.com>, Alex Elder <aelder@sgi.com>

From: Kevan Rehm <kfr@sgi.com>

The main routine calls libxfs_mount() via init(), but never calls
libxfs_umount() at the end of the program so there could be
filesystem changes queued which never get flushed to disk.  This
adds the missing libxfs_umount() call.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 db/init.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/db/init.c b/db/init.c
index 2a5ef2b..5effaf9 100644
--- a/db/init.c
+++ b/db/init.c
@@ -170,7 +170,7 @@ main(
 	}
 	if (cmdline) {
 		xfree(cmdline);
-		return exitcode;
+		goto end;
 	}
 
 	while (!done) {
@@ -181,5 +181,9 @@ main(
 			done = command(c, v);
 		doneline(input, v);
 	}
+
+end:
+	libxfs_umount(mp);
+
 	return exitcode;
 }
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
