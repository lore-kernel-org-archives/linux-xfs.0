Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDC0929E03
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 21:56:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFE128F8050
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 19:56:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EOKBLMWQGaOhtUBp for
	<xfs@oss.sgi.com>; Tue, 21 May 2013 19:56:13 -0700 (PDT)
Date: Tue, 21 May 2013 22:56:05 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522025605.GA29767@redhat.com>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522001603.GZ29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, May 22, 2013 at 10:16:03AM +1000, Dave Chinner wrote:

Seems like I can trigger this from paths other than truncate too.. (eg, sys_open)

Here's what I ended up with for debug

diff --git a/fs/dcache.c b/fs/dcache.c
index 2b39d16..b579dfe 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2792,6 +2792,7 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 Elong:
        return ERR_PTR(-ENAMETOOLONG);
 }
+EXPORT_SYMBOL(dentry_path);
 
 /*
  * NOTE! The user-level library version returns a
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d82efaa..8419e63 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -47,6 +47,7 @@
 #include <linux/security.h>
 #include <linux/fiemap.h>
 #include <linux/slab.h>
+#include <linux/dcache.h>
 
 static int
 xfs_initxattrs(
@@ -714,9 +715,20 @@ xfs_setattr_size(
                return XFS_ERROR(error);
 
        ASSERT(S_ISREG(ip->i_d.di_mode));
-       ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+       if ((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
                        ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0) {
+
+               struct dentry *dentry = d_find_any_alias(VFS_I(ip));
+               char buf[MAXPATHLEN];
+
+               dentry_path(dentry, buf, MAXPATHLEN);
+               dput(dentry);
+               xfs_warn(mp, "%s: mask 0x%x mismatch on file %s\n",
+                        __func__, mask, buf);
+
+                ASSERT(0);
+       }
 
        if (!(flags & XFS_ATTR_NOLOCK)) {
                lock_flags |= XFS_IOLOCK_EXCL;


Something isn't right though I think.. Because the filenames it outputs
look like crap.

[   71.406552] XFS (sda2): xfs_setattr_size: mask 0xa068 mismatch on file 0\xffffffee<\xffffff88\xffffffff\xffffffff\xffffff80O\xffffff82\xffffffff\xffffffff\xffffffff\xffffffff

The mask is always 0xa068 though if that helps.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
