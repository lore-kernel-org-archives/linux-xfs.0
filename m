Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DF8A7F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 16:04:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B30B30404E
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 14:04:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AZ6dxEiL4OxlojWP for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 14:04:33 -0700 (PDT)
Message-ID: <53922CE5.4000401@sandeen.net>
Date: Fri, 06 Jun 2014 16:04:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfs_fsr: create a cleanup/return target in packfile()
References: <53922B49.1050005@redhat.com>
In-Reply-To: <53922B49.1050005@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Error handling is a mishmash of closes, frees, etc at every
error point.  Create an "out" target that does this all
in one place.

Minor comment/doc update while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 94d235c..8b191e6 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1205,14 +1205,20 @@ out:
  * We already are pretty sure we can and want to
  * defragment the file.  Create the tmp file, copy
  * the data (maintaining holes) and call the kernel
- * extent swap routinte.
+ * extent swap routine.
+ *
+ * Return values:
+ * -1: Some error was encountered
+ *  0: Successfully defragmented the file
+ *  1: No change / No Error
  */
 static int
 packfile(char *fname, char *tname, int fd,
 	 xfs_bstat_t *statp, struct fsxattr *fsxp)
 {
-	int 		tfd;
+	int 		tfd = -1;
 	int		srval;
+	int		retval = -1;	/* Failure is the default */
 	int		nextents, extent, cur_nextents, new_nextents;
 	unsigned	blksz_dio;
 	unsigned	dio_min;
@@ -1220,7 +1226,7 @@ packfile(char *fname, char *tname, int fd,
 	static xfs_swapext_t   sx;
 	struct xfs_flock64  space;
 	off64_t 	cnt, pos;
-	void 		*fbuf;
+	void 		*fbuf = NULL;
 	int 		ct, wc, wc_b4;
 	char		ffname[SMBUFSZ];
 	int		ffd = -1;
@@ -1236,7 +1242,8 @@ packfile(char *fname, char *tname, int fd,
 	if (cur_nextents == 1 || cur_nextents <= nextents) {
 		if (vflag)
 			fsrprintf(_("%s already fully defragmented.\n"), fname);
-		return 1; /* indicates no change/no error */
+		retval = 1; /* indicates no change/no error */
+		goto out;
 	}
 
 	if (dflag)
@@ -1248,15 +1255,14 @@ packfile(char *fname, char *tname, int fd,
 		if (vflag)
 			fsrprintf(_("could not open tmp file: %s: %s\n"),
 				   tname, strerror(errno));
-		return -1;
+		goto out;
 	}
 	unlink(tname);
 
 	/* Setup extended attributes */
 	if (fsr_setup_attr_fork(fd, tfd, statp) != 0) {
 		fsrprintf(_("failed to set ATTR fork on tmp: %s:\n"), tname);
-		close(tfd);
-		return -1;
+		goto out;
 	}
 
 	/* Setup extended inode flags, project identifier, etc */
@@ -1264,15 +1270,13 @@ packfile(char *fname, char *tname, int fd,
 		if (ioctl(tfd, XFS_IOC_FSSETXATTR, fsxp) < 0) {
 			fsrprintf(_("could not set inode attrs on tmp: %s\n"),
 				tname);
-			close(tfd);
-			return -1;
+			goto out;
 		}
 	}
 
 	if ((ioctl(tfd, XFS_IOC_DIOINFO, &dio)) < 0 ) {
 		fsrprintf(_("could not get DirectIO info on tmp: %s\n"), tname);
-		close(tfd);
-		return -1;
+		goto out;
 	}
 
 	dio_min = dio.d_miniosz;
@@ -1294,8 +1298,7 @@ packfile(char *fname, char *tname, int fd,
 
 	if (!(fbuf = (char *)memalign(dio.d_mem, blksz_dio))) {
 		fsrprintf(_("could not allocate buf: %s\n"), tname);
-		close(tfd);
-		return -1;
+		goto out;
 	}
 
 	if (nfrags) {
@@ -1306,9 +1309,7 @@ packfile(char *fname, char *tname, int fd,
 		if ((ffd = open(ffname, openopts, 0666)) < 0) {
 			fsrprintf(_("could not open fragfile: %s : %s\n"),
 				   ffname, strerror(errno));
-			close(tfd);
-			free(fbuf);
-			return -1;
+			goto out;
 		}
 		unlink(ffname);
 	}
@@ -1338,9 +1339,7 @@ packfile(char *fname, char *tname, int fd,
 			if (ioctl(tfd, XFS_IOC_RESVSP64, &space) < 0) {
 				fsrprintf(_("could not pre-allocate tmp space:"
 					" %s\n"), tname);
-				close(tfd);
-				free(fbuf);
-				return -1;
+				goto out;
 			}
 			lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR);
 		}
@@ -1348,11 +1347,7 @@ packfile(char *fname, char *tname, int fd,
 
 	if (lseek64(tfd, 0, SEEK_SET)) {
 		fsrprintf(_("Couldn't rewind on temporary file\n"));
-		close(tfd);
-		if (ffd != -1)
-			close(ffd);
-		free(fbuf);
-		return -1;
+		goto out;
 	}
 
 	/* Check if the temporary file has fewer extents */
@@ -1362,11 +1357,8 @@ packfile(char *fname, char *tname, int fd,
 	if (cur_nextents <= new_nextents) {
 		if (vflag)
 			fsrprintf(_("No improvement will be made (skipping): %s\n"), fname);
-		free(fbuf);
-		close(tfd);
-		if (ffd != -1)
-			close(ffd);
-		return 1; /* no change/no error */
+		retval = 1; /* no change/no error */
+		goto out;
 	}
 
 	/* Loop through block map copying the file. */
@@ -1437,11 +1429,7 @@ packfile(char *fname, char *tname, int fd,
 							tname);
 					}
 				}
-				free(fbuf);
-				close(tfd);
-				if (ffd != -1)
-					close(ffd);
-				return -1;
+				goto out;
 			}
 			if (nfrags) {
 				/* Do a matching write to the tmp file */
@@ -1455,12 +1443,8 @@ packfile(char *fname, char *tname, int fd,
 		}
 	}
 	ftruncate64(tfd, statp->bs_size);
-	if (ffd != -1)
-		close(ffd);
 	fsync(tfd);
 
-	free(fbuf);
-
 	sx.sx_stat     = *statp; /* struct copy */
 	sx.sx_version  = XFS_SX_VERSION;
 	sx.sx_fdtarget = fd;
@@ -1473,8 +1457,7 @@ packfile(char *fname, char *tname, int fd,
                 if (vflag)
                         fsrprintf(_("failed to fchown tmpfile %s: %s\n"),
                                    tname, strerror(errno));
-		close(tfd);
-                return -1;
+		goto out;
         }
 
 	/* Swap the extents */
@@ -1496,8 +1479,7 @@ packfile(char *fname, char *tname, int fd,
 			fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
 				  fname, strerror(errno));
 		}
-		close(tfd);
-		return -1;
+		goto out;
 	}
 
 	/* Report progress */
@@ -1506,8 +1488,15 @@ packfile(char *fname, char *tname, int fd,
 			  cur_nextents, new_nextents,
 			  (new_nextents <= nextents ? "DONE" : "    " ),
 		          fname);
-	close(tfd);
-	return 0;
+	retval = 0;
+
+out:
+	free(fbuf);
+	if (tfd != -1)
+		close(tfd);
+	if (ffd != -1)
+		close(ffd);
+	return retval;
 }
 
 char *

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
