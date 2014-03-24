Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA2CC29DF7
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 13:19:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D84688F8054
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 11:19:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7v0H1YFTs993BiBC for
	<xfs@oss.sgi.com>; Mon, 24 Mar 2014 11:19:10 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2OIJ9qj003863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 14:19:09 -0400
Received: from redacted.bos.redhat.com ([10.18.17.143])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s2OIJ7bW001025
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 14:19:09 -0400
Date: Mon, 24 Mar 2014 14:19:07 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
Subject: [PATCH 1/2] xfsdump: getdents.c: clean up ifdef-hell around
	sys_getdents
Message-ID: <20140324181907.GF23291@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Remove the ifdef-hell imported from glibc around getdents64. Everything
since 2.4.1 supports things properly and this seems like a sensible
clean up, so lets just assume it exists and handle it by falling back
if not.

Additionally, if the old getdents syscall doesn't exist, just stub out
the actual syscall and return ENOSYS.

---
 common/getdents.c | 104 ++++++++++++++++++------------------------------------
 1 file changed, 34 insertions(+), 70 deletions(-)

diff --git a/common/getdents.c b/common/getdents.c
index e9ba25a..49d0d03 100644
--- a/common/getdents.c
+++ b/common/getdents.c
@@ -35,44 +35,6 @@
 
 #include <linux/posix_types.h>
 
-/* Copied from kernel-features.h for __ASSUME_GETDENTS64_SYSCALL */
-#ifndef __LINUX_KERNEL_VERSION
-/* We assume the worst; all kernels should be supported.  */
-# define __LINUX_KERNEL_VERSION 0
-#endif
-/* The getdents64 syscall was introduced in 2.4.0-test7.  We test for
-   2.4.1 for the earliest version we know the syscall is available.  */
-#if __LINUX_KERNEL_VERSION >= 132097
-# define __ASSUME_GETDENTS64_SYSCALL    1
-#endif
-/* There are an infinite number of PA-RISC kernel versions numbered
-   2.4.0.  But they've not really been released as such.  We require
-   and expect the final version here.  */
-#ifdef __hppa__
-# define __ASSUME_GETDENTS64_SYSCALL    1
-#endif
-
-#ifndef __set_errno
-#define __set_errno(e) (errno = (e))
-#endif
-
-
-#ifdef __NR_getdents64
-# ifndef __ASSUME_GETDENTS64_SYSCALL
-#  ifndef __GETDENTS
-/* The variable is shared between all *getdents* calls.  */
-int __have_no_getdents64;
-#  else
-extern int __have_no_getdents64;
-#  endif
-# endif
-/* Earlier versions of glibc don't define SYS_getdents64 at all */
-# ifndef SYS_getdents64
-#  define SYS_getdents64 __NR_getdents64
-# endif
-#endif
-
-
 /* For Linux we need a special version of this file since the
    definition of `struct dirent' is not the same for the kernel and
    the libc.  There is one additional field which might be introduced
@@ -97,11 +59,22 @@ struct kernel_dirent64
     char		d_name[256];
   };
 
-#ifndef DIRENT_TYPE
-# define DIRENT_TYPE struct dirent
+#define DIRENT_SET_DP_INO(dp, value) (dp)->d_ino = (value)
+
+#define __set_errno(e) (errno = (e))
+
+int __have_no_getdents64;
+
+#ifdef __NR_getdents64
+# define __SYS_GETDENTS64(fd, buf, len) (syscall(SYS_getdents64, fd, buf, len))
+#else
+# define __SYS_GETDENTS64(fd, buf, len) ({ __set_errno(ENOSYS); -1; })
 #endif
-#ifndef DIRENT_SET_DP_INO
-# define DIRENT_SET_DP_INO(dp, value) (dp)->d_ino = (value)
+
+#ifdef __NR_getdents
+# define __SYS_GETDENTS(fd, buf, len) (syscall(SYS_getdents, fd, buf, len))
+#else
+# define __SYS_GETDENTS(fd, buf, len) ({ __set_errno(ENOSYS); -1; })
 #endif
 
 /* The problem here is that we cannot simply read the next NBYTES
@@ -115,50 +88,43 @@ struct kernel_dirent64
 int
 getdents_wrap (int fd, char *buf, size_t nbytes)
 {
-  DIRENT_TYPE *dp;
+  struct dirent *dp;
   off64_t last_offset = -1;
   ssize_t retval;
 
-#ifdef __NR_getdents64
-# ifndef __ASSUME_GETDENTS64_SYSCALL
   if (!__have_no_getdents64)
-# endif
     {
-# ifndef __ASSUME_GETDENTS64_SYSCALL
       int saved_errno = errno;
-# endif
       char *kbuf = buf;
       size_t kbytes = nbytes;
-      if (offsetof (DIRENT_TYPE, d_name)
+      if (offsetof (struct dirent, d_name)
 	  < offsetof (struct kernel_dirent64, d_name)
-	  && nbytes <= sizeof (DIRENT_TYPE))
+	  && nbytes <= sizeof (struct dirent))
 	{
 	  kbytes = nbytes + offsetof (struct kernel_dirent64, d_name)
-		   - offsetof (DIRENT_TYPE, d_name);
+		   - offsetof (struct dirent, d_name);
 	  kbuf = alloca(kbytes);
 	}
-      retval = syscall(SYS_getdents64, fd, kbuf, kbytes);
-# ifndef __ASSUME_GETDENTS64_SYSCALL
-      if (retval != -1 && errno != -EINVAL)
-# endif
+      retval = __SYS_GETDENTS64(fd, kbuf, kbytes);
+      if (retval != -1)
 	{
 	  struct kernel_dirent64 *kdp;
 	  const size_t size_diff = (offsetof (struct kernel_dirent64, d_name)
-				    - offsetof (DIRENT_TYPE, d_name));
+				    - offsetof (struct dirent, d_name));
 
 	  /* If the structure returned by the kernel is identical to what we
 	     need, don't do any conversions.  */
-	  if (offsetof (DIRENT_TYPE, d_name)
+	  if (offsetof (struct dirent, d_name)
 	      == offsetof (struct kernel_dirent64, d_name)
 	      && sizeof (dp->d_ino) == sizeof (kdp->d_ino)
 	      && sizeof (dp->d_off) == sizeof (kdp->d_off))
 	    return retval;
 
-	  dp = (DIRENT_TYPE *)buf;
+	  dp = (struct dirent *)buf;
 	  kdp = (struct kernel_dirent64 *) kbuf;
 	  while ((char *) kdp < kbuf + retval)
 	    {
-	      const size_t alignment = __alignof__ (DIRENT_TYPE);
+	      const size_t alignment = __alignof__ (struct dirent);
 	      /* Since kdp->d_reclen is already aligned for the kernel
 		 structure this may compute a value that is bigger
 		 than necessary.  */
@@ -194,41 +160,39 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
 	      memmove (dp->d_name, kdp->d_name,
 		       old_reclen - offsetof (struct kernel_dirent64, d_name));
 
-	      dp = (DIRENT_TYPE *) ((char *) dp + new_reclen);
+	      dp = (struct dirent *) ((char *) dp + new_reclen);
 	      kdp = (struct kernel_dirent64 *) ((char *) kdp + old_reclen);
 	    }
 
 	  return (char *) dp - buf;
 	}
 
-# ifndef __ASSUME_GETDENTS64_SYSCALL
       __set_errno (saved_errno);
       __have_no_getdents64 = 1;
-# endif
     }
-#endif
+
+  /* fallback to getdents */
   {
     size_t red_nbytes;
     struct kernel_dirent *skdp, *kdp;
-    const size_t size_diff = (offsetof (DIRENT_TYPE, d_name)
+    const size_t size_diff = (offsetof (struct dirent, d_name)
 			      - offsetof (struct kernel_dirent, d_name));
 
     red_nbytes = MIN (nbytes
-		      - ((nbytes / (offsetof (DIRENT_TYPE, d_name) + 14))
+		      - ((nbytes / (offsetof (struct dirent, d_name) + 14))
 			 * size_diff),
 		      nbytes - size_diff);
 
-    dp = (DIRENT_TYPE *) buf;
+    dp = (struct dirent *) buf;
     skdp = kdp = alloca (red_nbytes);
 
-    retval = syscall(SYS_getdents, fd, kdp, red_nbytes);
-
+    retval = __SYS_GETDENTS(fd, kdp, red_nbytes);
     if (retval == -1)
       return -1;
 
     while ((char *) kdp < (char *) skdp + retval)
       {
-	const size_t alignment = __alignof__ (DIRENT_TYPE);
+	const size_t alignment = __alignof__ (struct dirent);
 	/* Since kdp->d_reclen is already aligned for the kernel structure
 	   this may compute a value that is bigger than necessary.  */
 	size_t new_reclen = ((kdp->d_reclen + size_diff + alignment - 1)
@@ -259,7 +223,7 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
 	memcpy (dp->d_name, kdp->d_name,
 		kdp->d_reclen - offsetof (struct kernel_dirent, d_name));
 
-	dp = (DIRENT_TYPE *) ((char *) dp + new_reclen);
+	dp = (struct dirent *) ((char *) dp + new_reclen);
 	kdp = (struct kernel_dirent *) (((char *) kdp) + kdp->d_reclen);
       }
     }
-- 
1.8.5.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
