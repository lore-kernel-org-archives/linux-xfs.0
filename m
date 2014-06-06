Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4B377F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 16:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F6F9AC006
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 14:06:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LqR3aSedM3mEVGFK for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 14:06:43 -0700 (PDT)
Message-ID: <53922D67.2060906@sandeen.net>
Date: Fri, 06 Jun 2014 16:06:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3] xfs_fsr: test for more potential failures in packfile()
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

Test for lseek, ftruncate, and fsync failures in packfile()

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 8b191e6..48629fd 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1325,7 +1325,11 @@ packfile(char *fname, char *tname, int fd,
 				fsrprintf(_("could not trunc tmp %s\n"),
 					   tname);
 			}
-			lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR);
+			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
+				   tname, strerror(errno));
+				goto out;
+			}
 			continue;
 		} else if (outmap[extent].bmv_length == 0) {
 			/* to catch holes at the beginning of the file */
@@ -1341,7 +1345,11 @@ packfile(char *fname, char *tname, int fd,
 					" %s\n"), tname);
 				goto out;
 			}
-			lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR);
+			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
+				   tname, strerror(errno));
+				goto out;
+			}
 		}
 	} /* end of space allocation loop */
 
@@ -1365,8 +1373,16 @@ packfile(char *fname, char *tname, int fd,
 	for (extent = 0; extent < nextents; extent++) {
 		pos = outmap[extent].bmv_offset;
 		if (outmap[extent].bmv_block == -1) {
-			lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR);
-			lseek64(fd, outmap[extent].bmv_length, SEEK_CUR);
+			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
+				   tname, strerror(errno));
+				goto out;
+			}
+			if (lseek64(fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+				fsrprintf(_("could not lseek in file: %s : %s\n"),
+				   fname, strerror(errno));
+				goto out;
+			}
 			continue;
 		} else if (outmap[extent].bmv_length == 0) {
 			/* to catch holes at the beginning of the file */
@@ -1442,8 +1458,16 @@ packfile(char *fname, char *tname, int fd,
 			}
 		}
 	}
-	ftruncate64(tfd, statp->bs_size);
-	fsync(tfd);
+	if (ftruncate64(tfd, statp->bs_size) < 0) {
+		fsrprintf(_("could not truncate tmpfile: %s : %s\n"),
+				fname, strerror(errno));
+		goto out;
+	}
+	if (fsync(tfd) < 0) {
+		fsrprintf(_("could not fsync tmpfile: %s : %s\n"),
+				fname, strerror(errno));
+		goto out;
+	}
 
 	sx.sx_stat     = *statp; /* struct copy */
 	sx.sx_version  = XFS_SX_VERSION;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
