Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLNtmsH084428 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 17:55:49 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D360730407F
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 15:56:31 -0800 (PST)
Received: from [128.162.233.117] (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id B3F0570001C8
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 17:56:31 -0600 (CST)
Message-ID: <4B300B2F.7080305@sgi.com>
Date: Mon, 21 Dec 2009 17:56:31 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2]  add lpath_to_handle to libhandle
References: <4AE08DC7.7000200@sgi.com> <20091024133904.GB23125@infradead.org>
In-Reply-To: <20091024133904.GB23125@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 10/24/2009 08:39 AM, Christoph Hellwig wrote:
> On Thu, Oct 22, 2009 at 11:52:23AM -0500, Bill Kendall wrote:
>> path_to_handle() is not reliable when called on a path which
>> is a symlink. If the symlink is dangling, or if its points
>> to a non-XFS filesystem then path_to_handle() will fail. The
>> reason is that path_to_handle() must open the path in order
>> to obtain an fd for the xfsctl call.
>>
>> It's common during xfsrestore to have dangling symlinks since
>> the target of the link may not be restored before the symlink.
>>
>> This patch adds a new function to libhandle, lpath_to_handle.
>> It is just like path_to_handle, except it takes a filesystem
>> path in addition to the path which you want convert to a
>> handle.
> 
> I'm not sure this is a good API.  We can derive a useful path for
> the ioctl by using basename on the filename if it is a link without
> needing to expose the details to the caller.

Based on Christoph's suggestion here's a rework of the patch
(that I've been sitting on for a while). This requires no change
to the libhandle API and no changes in xfsdump (and hence just
this one patch. The previously posted patch 2/2 is dropped).


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
@@ -114,18 +121,45 @@ path_to_handle(
  	int		fd;
  	int		result;
  	comarg_t	obj;
+	char		*fspath;
+
+	fspath = path_to_fspath(path);
+	if (fspath == NULL)
+		return -1;

-	fd = open(path, O_RDONLY);
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
+ * an fd for xfsctl calls. In most circumstances the input path is
+ * sufficient. However, if the input path is a sym link the
+ * parent directory is returned so as to avoid issues with
+ * dangling links and links pointing into other filesystems.
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
+	if (S_ISLNK(statbuf.st_mode)) {
+		strcpy(dirpath, path);
+		return dirname(dirpath);
+	}
+
+	return path;
+}

  int
  fd_to_handle (

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
