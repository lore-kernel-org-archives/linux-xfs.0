Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n971HPae148806 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 20:17:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C45A0121E44F
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 18:18:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8mKEgdAT4De6NKzd for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 18:18:51 -0700 (PDT)
Date: Tue, 6 Oct 2009 21:18:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091007011850.GA32032@infradead.org>
References: <1235789111.21721254856913943.JavaMail.root@mail-au.aconex.com>
	<837780486.21741254857073773.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <837780486.21741254857073773.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> It might be a bit cleaner to add this in with the existing platform-
> specific code in libxfs/linux.c (or perhaps include/platform_defs.h)
> with wrappers for the other platforms, rather than putting it directly
> in mkfs like this?  repair may want to use this someday too, I guess.

How about this one?

-- 

Subject: [PATCH] mkfs: add discard support
From: Christoph Hellwig <hch@lst.de>

Cal the BLKDISCARD ioctl to mark the whole disk as unused before creating
a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
and virtual machines to make smarter allocation decisions.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2009-10-06 18:46:06.000000000 +0000
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2009-10-07 01:09:49.000000000 +0000
@@ -605,6 +605,20 @@ done:
 	free(buf);
 }
 
+static void
+discard_blocks(dev_t dev, __uint64_t nsectors)
+{
+	int fd;
+
+	/*
+	 * We intentionally ignore errors from the discard ioctl.  It is
+	 * not nessecary for the mkfs functionality but just an optimization.
+	 */
+	fd = libxfs_device_to_fd(dev);
+	if (fd > 0)
+		platform_discard_blocks(fd, 0, nsectors << 9);
+}
+
 int
 main(
 	int			argc,
@@ -1645,6 +1659,12 @@ main(
 		}
 	}
 
+	discard_blocks(xi.ddev, xi.dsize);
+	if (xi.rtdev)
+		discard_blocks(xi.rtdev, xi.rtsize);
+	if (xi.logdev && xi.logdev != xi.ddev)
+		discard_blocks(xi.logdev, xi.logBBsize);
+
 	if (!liflag && !ldflag)
 		loginternal = xi.logdev == 0;
 	if (xi.logname)
Index: xfsprogs-dev/include/linux.h
===================================================================
--- xfsprogs-dev.orig/include/linux.h	2009-10-07 01:06:00.000000000 +0000
+++ xfsprogs-dev/include/linux.h	2009-10-07 01:13:12.000000000 +0000
@@ -93,6 +93,20 @@ static __inline__ void platform_uuid_cop
 	uuid_copy(*dst, *src);
 }
 
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	__uint64_t range[2] = { start, end };
+
+	if (ioctl(fd, BLKDISCARD, &range) < 0)
+		return errno;
+	return 0;
+}
+
 #if (__GLIBC__ < 2) || ((__GLIBC__ == 2) && (__GLIBC_MINOR__ <= 1))
 # define constpp	const char * const *
 #else
Index: xfsprogs-dev/include/darwin.h
===================================================================
--- xfsprogs-dev.orig/include/darwin.h	2009-10-07 01:15:38.000000000 +0000
+++ xfsprogs-dev/include/darwin.h	2009-10-07 01:16:19.000000000 +0000
@@ -154,4 +154,10 @@ typedef unsigned char	uchar_t;
 
 #define HAVE_FID	1
 
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	return 0;
+}
+
 #endif	/* __XFS_DARWIN_H__ */
Index: xfsprogs-dev/include/freebsd.h
===================================================================
--- xfsprogs-dev.orig/include/freebsd.h	2009-10-07 01:15:38.000000000 +0000
+++ xfsprogs-dev/include/freebsd.h	2009-10-07 01:16:06.000000000 +0000
@@ -139,4 +139,10 @@ static __inline__ void platform_uuid_cop
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	return 0;
+}
+
 #endif	/* __XFS_FREEBSD_H__ */
Index: xfsprogs-dev/include/irix.h
===================================================================
--- xfsprogs-dev.orig/include/irix.h	2009-10-07 01:15:38.000000000 +0000
+++ xfsprogs-dev/include/irix.h	2009-10-07 01:16:29.000000000 +0000
@@ -337,6 +337,12 @@ static __inline__ void platform_uuid_cop
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	return 0;
+}
+
 static __inline__ char * strsep(char **s, const char *ct)
 {
 	char *sbegin = *s, *end;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
