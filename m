Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SAvIIi103493 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 05:57:18 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 3/5] xfsprogs: libxcmd: kill "search" arg in fs_device_number()
Date: Wed, 28 Sep 2011 05:57:10 -0500
Message-Id: <1b14f28de48534ea9bff229a6a3ff235923857c9.1317207144.git.aelder@sgi.com>
In-Reply-To: <1317207432-8464-1-git-send-email-aelder@sgi.com>
References: <1317207432-8464-1-git-send-email-aelder@sgi.com>
In-Reply-To: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
References: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
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

The function fs_device_number() in libxcmd allows the caller to
optionally "search" in /dev for a given device path in order to look
up the dev_t that represents that device path.

If set, all that function does is prepend "/dev/" to the path to see
if that produces a device path that works.  So it appears this might
have been to support providing just the basename of a device as a
shorthand for its full path.

In practice, the paths passed to this function with "search" set are
those used in the mount options for a mounted XFS filesystem for the
optional log and real-time device paths.  When such paths are used
in the XFS mount path, they will have been subject to a AT_FDCWD
path lookup, so unless the process mounting the filesystem was
sitting in /dev no relative path would ever be specified as just the
basename.

Even though the "mounting with CWD=/dev" is a conceivable scenario,
I think it is not likely enough to warrant the special handling to
cover that case in fs_device_number().

So delete the code that retries with a "/dev" prepended, eliminate
the "search" argument that enables it, and fix the callers
accordingly.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   33 +++++++--------------------------
 1 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 5aa343b..f1cd6c7 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -76,33 +76,14 @@ fs_table_lookup(
 static char *
 fs_device_number(
 	char		*name,
-	dev_t		*devnum,
-	int		search)
+	dev_t		*devnum)
 {
 	struct stat64	sbuf;
-	int		len;
-
-	if (stat64(name, &sbuf) < 0) {
-		if (!search)
-			return NULL;
-		len = strlen(name) + 1;
-		name = realloc(name, len + 5);  /* "/dev/ */
-		if (!name) {
-			fprintf(stderr, _("%s: warning - out of memory\n"),
-				progname);
-			return NULL;
-		}
-		memmove(name + 5, name, len);
-		strncpy(name, "/dev/", 5);
-		if (stat64(name, &sbuf) < 0) {
-			fprintf(stderr,
-				_("%s: warning - cannot find %s: %s\n"),
-				progname, name, strerror(errno));
-			free(name);
-			return NULL;
-		}
-	}
+
+	if (stat64(name, &sbuf) < 0)
+		return NULL;
 	*devnum = sbuf.st_dev;
+
 	return name;
 }
 
@@ -122,11 +103,11 @@ fs_table_insert(
 		return EINVAL;
 
 	datadev = logdev = rtdev = 0;
-	if (!fs_device_number(dir, &datadev, 0))
+	if (!fs_device_number(dir, &datadev))
 		return errno;
-	if (fslog && (fslog = fs_device_number(fslog, &logdev, 1)) == NULL)
+	if (fslog && !fs_device_number(fslog, &logdev))
 		return errno;
-	if (fsrt && (fsrt = fs_device_number(fsrt, &rtdev, 1)) == NULL)
+	if (fsrt && !fs_device_number(fsrt, &rtdev))
 		return errno;
 
 	tmp_fs_table = realloc(fs_table, sizeof(fs_path_t) * (fs_count + 1));
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
