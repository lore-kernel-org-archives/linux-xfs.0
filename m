Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3F5580CF
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:25:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8DE730408D
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:25:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VFGA3PmoqjQdynvb for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:25:07 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/14] xfsprogs: fix various fd leaks
Date: Tue,  8 Apr 2014 18:24:51 -0500
Message-Id: <1396999504-13769-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Coverity spotted these; several paths where we don't
close fds when we return.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c      |   10 +++++++++-
 io/readdir.c       |    1 +
 libhandle/handle.c |    1 +
 mkfs/proto.c       |   12 +++++++++---
 quota/quot.c       |    1 +
 rtcp/xfs_rtcp.c    |    2 ++
 6 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6f00b41..6b5d260 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -706,6 +706,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
 		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
 			  mntdir);
+		close(fsfd);
 		return -1;
 	}
 
@@ -1346,6 +1347,8 @@ packfile(char *fname, char *tname, int fd,
 	if (lseek64(tfd, 0, SEEK_SET)) {
 		fsrprintf(_("Couldn't rewind on temporary file\n"));
 		close(tfd);
+		if (ffd != -1)
+			close(ffd);
 		free(fbuf);
 		return -1;
 	}
@@ -1359,6 +1362,8 @@ packfile(char *fname, char *tname, int fd,
 			fsrprintf(_("No improvement will be made (skipping): %s\n"), fname);
 		free(fbuf);
 		close(tfd);
+		if (ffd != -1)
+			close(ffd);
 		return 1; /* no change/no error */
 	}
 
@@ -1432,6 +1437,8 @@ packfile(char *fname, char *tname, int fd,
 				}
 				free(fbuf);
 				close(tfd);
+				if (ffd != -1)
+					close(ffd);
 				return -1;
 			}
 			if (nfrags) {
@@ -1446,7 +1453,8 @@ packfile(char *fname, char *tname, int fd,
 		}
 	}
 	ftruncate64(tfd, statp->bs_size);
-	if (ffd > 0) close(ffd);
+	if (ffd != -1)
+		close(ffd);
 	fsync(tfd);
 
 	free(fbuf);
diff --git a/io/readdir.c b/io/readdir.c
index 822818a..7133204 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -171,6 +171,7 @@ readdir_f(
 	gettimeofday(&t2, NULL);
 
 	closedir(dir);
+	close(dfd);
 
 	t2 = tsub(t2, t1);
 	timestr(&t2, ts, sizeof(ts), 0);
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 9a232fa..9f81483 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -97,6 +97,7 @@ path_to_fshandle(
 		/* new filesystem. add it to the cache */
 		fdhp = malloc(sizeof(struct fdhash));
 		if (fdhp == NULL) {
+			close(fd);
 			errno = ENOMEM;
 			return -1;
 		}
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 4d3680d..b7e0761 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -59,18 +59,19 @@ setup_proto(
 	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
 		fprintf(stderr, _("%s: failed to open %s: %s\n"),
 			progname, fname, strerror(errno));
-		exit(1);
+		goto out_fail;
 	}
+
 	buf = malloc(size + 1);
 	if (read(fd, buf, size) < size) {
 		fprintf(stderr, _("%s: read failed on %s: %s\n"),
 			progname, fname, strerror(errno));
-		exit(1);
+		goto out_fail;
 	}
 	if (buf[size - 1] != '\n') {
 		fprintf(stderr, _("%s: proto file %s premature EOF\n"),
 			progname, fname);
-		exit(1);
+		goto out_fail;
 	}
 	buf[size] = '\0';
 	/*
@@ -79,7 +80,12 @@ setup_proto(
 	(void)getstr(&buf);	/* boot image name */
 	(void)getnum(&buf);	/* block count */
 	(void)getnum(&buf);	/* inode count */
+	close(fd);
 	return buf;
+
+out_fail:
+	close(fd);
+	exit(1);
 }
 
 static long
diff --git a/quota/quot.c b/quota/quot.c
index a7782b4..96d449e 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -165,6 +165,7 @@ quot_bulkstat_mount(
 	buf = (xfs_bstat_t *)calloc(NBSTAT, sizeof(xfs_bstat_t));
 	if (!buf) {
 		perror("calloc");
+		close(fsfd);
 		return;
 	}
 
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index f0b5936..b81b1e1 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -224,6 +224,7 @@ rtcp( char *source, char *target, int fextsize)
 		if ( !(fsxattr.fsx_xflags & XFS_XFLAG_REALTIME) ) {
 			fprintf(stderr, _("%s: %s is not a realtime file.\n"),
 				progname, tbuf);
+			close( tofd );
 			return( -1 );
 		}
 
@@ -234,6 +235,7 @@ rtcp( char *source, char *target, int fextsize)
 			fprintf(stderr, _("%s: %s file extent size is %d, "
 					"instead of %d.\n"),
 				progname, tbuf, fsxattr.fsx_extsize, fextsize);
+			close( tofd );
 			return( -1 );
 		}
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
