Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNJKOep259005 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 13:20:24 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6B66AC014
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 11:21:04 -0800 (PST)
Date: Wed, 23 Dec 2009 13:21:04 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: Re: [PATCH 1/2]  add lpath_to_handle to libhandle
Message-ID: <20091223192101.GA3578@sgi.com>
References: <4AE08DC7.7000200@sgi.com> <20091024133904.GB23125@infradead.org>
	<4B300B2F.7080305@sgi.com> <20091223131535.GA23394@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091223131535.GA23394@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Dec 23, 2009 at 08:15:35AM -0500, Christoph Hellwig wrote:
> One thing that could be changes is to also do the fspath conversion for
> block and chacater special files.  While we can open those they will not
> end up in the xfs file operations and thus not provide the nessecary
> ioctl.

Parent dir is now used for all types except regular files and directories.
Special file conversions still fail, but at least it's XFS making that
decision. Also this prevents calling open on named pipes, which could
block.

> Btw, it would be nice if you could write a testcase for xfstests that
> fails with the old version on links but works with the new one.

I'll take a look at this and post a separate patch.


Signed-off-by: Bill Kendall <wkendall@sgi.com>

Index: xfsprogs-kernel.org/libhandle/handle.c
===================================================================
--- xfsprogs-kernel.org.orig/libhandle/handle.c
+++ xfsprogs-kernel.org/libhandle/handle.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <libgen.h>
 #include <xfs/xfs.h>
 #include <xfs/handle.h>
 #include <xfs/parent.h>
@@ -40,6 +41,7 @@ typedef union {
 
 static int obj_to_handle(char *, int, unsigned int, comarg_t, void**, size_t*);
 static int handle_to_fsfd(void *, char **);
+static char *path_to_fspath(char *path);
 
 
 /*
@@ -70,13 +72,18 @@ path_to_fshandle(
 	comarg_t	obj;
 	struct fdhash	*fdhp;
 	char		*tmppath;
+	char		*fspath;
 
-	fd = open(path, O_RDONLY);
+	fspath = path_to_fspath(path);
+	if (fspath == NULL)
+		return -1;
+
+	fd = open(fspath, O_RDONLY);
 	if (fd < 0)
 		return -1;
 
 	obj.path = path;
-	result = obj_to_handle(path, fd, XFS_IOC_PATH_TO_FSHANDLE,
+	result = obj_to_handle(fspath, fd, XFS_IOC_PATH_TO_FSHANDLE,
 				obj, fshanp, fshlen);
 	if (result < 0) {
 		close(fd);
@@ -95,7 +102,7 @@ path_to_fshandle(
 		}
 
 		fdhp->fsfd = fd;
-		strncpy(fdhp->fspath, path, sizeof(fdhp->fspath));
+		strncpy(fdhp->fspath, fspath, sizeof(fdhp->fspath));
 		memcpy(fdhp->fsh, *fshanp, FSIDSIZE);
 
 		fdhp->fnxt = fdhash_head;
@@ -114,18 +121,46 @@ path_to_handle(
 	int		fd;
 	int		result;
 	comarg_t	obj;
+	char		*fspath;
 
-	fd = open(path, O_RDONLY);
+	fspath = path_to_fspath(path);
+	if (fspath == NULL)
+		return -1;
+
+	fd = open(fspath, O_RDONLY);
 	if (fd < 0)
 		return -1;
 
 	obj.path = path;
-	result = obj_to_handle(path, fd, XFS_IOC_PATH_TO_HANDLE,
+	result = obj_to_handle(fspath, fd, XFS_IOC_PATH_TO_HANDLE,
 				obj, hanp, hlen);
 	close(fd);
 	return result;
 }
 
+/* Given a path, return a suitable "fspath" for use in obtaining
+ * an fd for xfsctl calls. For regular files and directories the
+ * input path is sufficient. For other types the parent directory
+ * is used to avoid issues with opening dangling symlinks and
+ * potentially blocking in an open on a named pipe. Also
+ * symlinks to files on other filesystems would be a problem,
+ * since an fd would be obtained for the wrong fs.
+ */
+static char *
+path_to_fspath(char *path)
+{
+	static char dirpath[MAXPATHLEN];
+	struct stat statbuf;
+
+	if (lstat(path, &statbuf) != 0)
+		return NULL;
+
+	if (S_ISREG(statbuf.st_mode) || S_ISDIR(statbuf.st_mode))
+		return path;
+
+	strcpy(dirpath, path);
+	return dirname(dirpath);
+}
 
 int
 fd_to_handle (

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
