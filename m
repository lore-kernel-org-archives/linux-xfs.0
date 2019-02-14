Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41679 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437904AbfBNKBC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id m1so2804328pgq.8
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:01 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 2/6] fs: add AT_UTIME_BTIME for utimensat()
Date: Thu, 14 Feb 2019 02:00:09 -0800
Message-Id: <383aea1b93edf69d4f96a898ef4878881867d33e.1550136164.git.osandov@fb.com>
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Now that we have a btime iattr, use it to allow updating btime from
utimensat(). We do so by adding a new AT_UTIME_BTIME flag. Iff this flag
is given, the btime is set to times[2] (unless times is NULL, in which
case the current time is used).

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/utimes.c                | 86 +++++++++++++++++++++++---------------
 include/uapi/linux/fcntl.h |  2 +
 2 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index bdcf2daf39c1..cb9fe77e5f91 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -16,7 +16,20 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-static int utimes_common(const struct path *path, struct timespec64 *times)
+static void init_time_attr(struct iattr *newattrs, struct timespec64 *time_attr,
+			   struct timespec64 time, unsigned int attr,
+			   unsigned int attr_set)
+{
+	if (time.tv_nsec == UTIME_OMIT) {
+		newattrs->ia_valid &= ~attr;
+	} else {
+		*time_attr = time;
+		newattrs->ia_valid |= attr_set;
+	}
+}
+
+static int utimes_common(const struct path *path, struct timespec64 *times,
+			 bool btime)
 {
 	int error;
 	struct iattr newattrs;
@@ -28,25 +41,21 @@ static int utimes_common(const struct path *path, struct timespec64 *times)
 		goto out;
 
 	if (times && times[0].tv_nsec == UTIME_NOW &&
-		     times[1].tv_nsec == UTIME_NOW)
+	    times[1].tv_nsec == UTIME_NOW &&
+	    (!btime || times[2].tv_nsec == UTIME_NOW))
 		times = NULL;
 
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
+	if (btime)
+		newattrs.ia_valid |= ATTR_BTIME;
 	if (times) {
-		if (times[0].tv_nsec == UTIME_OMIT)
-			newattrs.ia_valid &= ~ATTR_ATIME;
-		else if (times[0].tv_nsec != UTIME_NOW) {
-			newattrs.ia_atime.tv_sec = times[0].tv_sec;
-			newattrs.ia_atime.tv_nsec = times[0].tv_nsec;
-			newattrs.ia_valid |= ATTR_ATIME_SET;
-		}
-
-		if (times[1].tv_nsec == UTIME_OMIT)
-			newattrs.ia_valid &= ~ATTR_MTIME;
-		else if (times[1].tv_nsec != UTIME_NOW) {
-			newattrs.ia_mtime.tv_sec = times[1].tv_sec;
-			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
-			newattrs.ia_valid |= ATTR_MTIME_SET;
+		init_time_attr(&newattrs, &newattrs.ia_atime, times[0],
+			       ATTR_ATIME, ATTR_ATIME_SET);
+		init_time_attr(&newattrs, &newattrs.ia_mtime, times[1],
+			       ATTR_MTIME, ATTR_MTIME_SET);
+		if (btime) {
+			init_time_attr(&newattrs, &newattrs.ia_btime, times[2],
+				       ATTR_BTIME, ATTR_BTIME_SET);
 		}
 		/*
 		 * Tell setattr_prepare(), that this is an explicit time
@@ -90,14 +99,16 @@ static int utimes_common(const struct path *path, struct timespec64 *times)
 long do_utimes(int dfd, const char __user *filename, struct timespec64 *times,
 	       int flags)
 {
+	bool btime = flags & AT_UTIME_BTIME;
 	int error = -EINVAL;
 
 	if (times && (!nsec_valid(times[0].tv_nsec) ||
-		      !nsec_valid(times[1].tv_nsec))) {
+		      !nsec_valid(times[1].tv_nsec) ||
+		      (btime && !nsec_valid(times[2].tv_nsec)))) {
 		goto out;
 	}
 
-	if (flags & ~AT_SYMLINK_NOFOLLOW)
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_UTIME_BTIME))
 		goto out;
 
 	if (filename == NULL && dfd != AT_FDCWD) {
@@ -111,7 +122,7 @@ long do_utimes(int dfd, const char __user *filename, struct timespec64 *times,
 		if (!f.file)
 			goto out;
 
-		error = utimes_common(&f.file->f_path, times);
+		error = utimes_common(&f.file->f_path, times, btime);
 		fdput(f);
 	} else {
 		struct path path;
@@ -124,7 +135,7 @@ long do_utimes(int dfd, const char __user *filename, struct timespec64 *times,
 		if (error)
 			goto out;
 
-		error = utimes_common(&path, times);
+		error = utimes_common(&path, times, btime);
 		path_put(&path);
 		if (retry_estale(error, lookup_flags)) {
 			lookup_flags |= LOOKUP_REVAL;
@@ -139,16 +150,20 @@ long do_utimes(int dfd, const char __user *filename, struct timespec64 *times,
 SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
 		struct __kernel_timespec __user *, utimes, int, flags)
 {
-	struct timespec64 tstimes[2];
+	struct timespec64 tstimes[3];
 
 	if (utimes) {
-		if ((get_timespec64(&tstimes[0], &utimes[0]) ||
-			get_timespec64(&tstimes[1], &utimes[1])))
-			return -EFAULT;
-
+		int i, n = (flags & AT_UTIME_BTIME) ? 3 : 2;
+		bool all_omit = true;
+
+		for (i = 0; i < n; i++) {
+			if (get_timespec64(&tstimes[i], &utimes[i]))
+				return -EFAULT;
+			if (tstimes[i].tv_nsec != UTIME_OMIT)
+				all_omit = false;
+		}
 		/* Nothing to do, we must not even check the path.  */
-		if (tstimes[0].tv_nsec == UTIME_OMIT &&
-		    tstimes[1].tv_nsec == UTIME_OMIT)
+		if (all_omit)
 			return 0;
 	}
 
@@ -242,14 +257,19 @@ COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 
 COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename, struct old_timespec32 __user *, t, int, flags)
 {
-	struct timespec64 tv[2];
+	struct timespec64 tv[3];
 
 	if  (t) {
-		if (get_old_timespec32(&tv[0], &t[0]) ||
-		    get_old_timespec32(&tv[1], &t[1]))
-			return -EFAULT;
-
-		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
+		int i, n = (flags & AT_UTIME_BTIME) ? 3 : 2;
+		bool all_omit = true;
+
+		for (i = 0; i < n; i++) {
+			if (get_old_timespec32(&tv[i], &t[i]))
+				return -EFAULT;
+			if (tv[i].tv_nsec != UTIME_OMIT)
+				all_omit = false;
+		}
+		if (all_omit)
 			return 0;
 	}
 	return do_utimes(dfd, filename, t ? tv : NULL, flags);
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 6448cdd9a350..fc5b02439697 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -90,5 +90,7 @@
 #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
 #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
 
+#define AT_UTIME_BTIME		0x8000	/* Also update file creation time */
+
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.20.1
