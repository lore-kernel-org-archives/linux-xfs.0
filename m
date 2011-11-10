Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZiFT127031 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:44 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 7/8] xfsprogs: clean up errors in libxfs_mount() consistently
Date: Thu, 10 Nov 2011 14:35:17 -0600
Message-Id: <fa64086e0baa316ab27ca7cffa1e9cd214525a87.1320955676.git.aelder@sgi.com>
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

Until the perag structures for the filesystem have been set up,
initialization of the mount point only assigns computed values and
has no other side-effects (such as allocating additional
structures).  So up to that point, returning a null pointer to
signal an error is adequate.  Once the perag initialization is done
there needs to be some teardown in case of an error.

Here the handling of errors is inconsistent.  If early perag
initialization fails, the code currently just exits.  Then, if
getting a reference to the root inode results in an error, a null
pointer is returned but without first cleaning up the perag
structures.  Next, if rtmount_inodes() returns an error, the
reference to the root inode (if any) is released, but again the
perag structures are not cleaned up.  Finally, when the perag data
is read in, if an error occurs, a null pointer is returned but the
root inode pointer reference is not released and the perag
structures are not cleaned up.

Remedy all of that by having each of these error cases jump to error
handling code at the end of the function.  That code needs to
release the reference to the root inode and release all of the perag
structures.  This (plus a few other things that will be no-ops at
this point in the mount process) is exactly what libxfs_umount(), so
just use that function to implement this cleanup activity.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxfs/init.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index d34fd8c..9dad5b7 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -757,7 +757,7 @@ libxfs_mount(
 	if (error) {
 		fprintf(stderr, _("%s: perag init failed\n"),
 			progname);
-		exit(1);
+		goto out_err;
 	}
 
 	/*
@@ -770,15 +770,12 @@ libxfs_mount(
 			fprintf(stderr, _("%s: cannot read root inode (%d)\n"),
 				progname, error);
 			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
-				return NULL;
+				goto out_err;
 		}
 		ASSERT(mp->m_rootip != NULL);
 	}
-	if ((flags & LIBXFS_MOUNT_ROOTINOS) && rtmount_inodes(mp)) {
-		if (mp->m_rootip)
-			libxfs_iput(mp->m_rootip, 0);
-		return NULL;
-	}
+	if ((flags & LIBXFS_MOUNT_ROOTINOS) && rtmount_inodes(mp))
+		goto out_err;
 
 	/*
 	 * mkfs calls mount before the AGF/AGI structures are written.
@@ -789,11 +786,16 @@ libxfs_mount(
 		if (error) {
 			fprintf(stderr, _("%s: cannot init perag data (%d)\n"),
 				progname, error);
-			return NULL;
+			goto out_err;
 		}
 	}
 
 	return mp;
+
+out_err:
+	libxfs_umount(mp);	/* clean up first */
+
+	return NULL;
 }
 
 void
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
