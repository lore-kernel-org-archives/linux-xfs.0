Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CFaJZE261427 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 10:36:19 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id Bspg8W5GmJEyju0Z
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jun 2012 08:36:18 -0700 (PDT)
Received: by mail-pz0-f53.google.com with SMTP id g9so8817054dad.26
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 08:36:18 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] vfs: add FALLOC_FL_ZERO_RANGE to fallocate
Date: Tue, 12 Jun 2012 17:36:03 +0200
Message-Id: <1339515364-17374-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

Add a new operation mode to fallocate, called FALLOC_FL_ZERO_RANGE.
It resembles the similarly named XFS ioctl.  Filesystems should
preallocate blocks for regions that span holes in the file, and convert
the entire range to unwritten extents.   This operation is a fast method
of overwriting any from the range specified with zeros without removing
any blocks or having to write zeros to disk.  Any subsequent read in
the given range will return zeros until new data is written.

This functionality requires filesystems to support unwritten extents.
If xfs_info(8) reports unwritten=1, then the filesystem was made to
flag unwritten extents.  It is okay to report EOPNOTSUPP and let the
application deal with the outcome, but it is not okay to succeed or
report EOPNOTSUPP for the same inode depending on the other arguments.

FALLOC_FL_PUNCH_HOLE|FALLOC_FL_ZERO_RANGE is ruled out here, at the
vfs level, rather than leaving it to the filesystems.  This way, in the
future 0x6 could be used as a third mode.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 fs/open.c              |    8 +++++++-
 include/linux/falloc.h |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index d6c79a0..dd812b3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -222,8 +222,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (offset < 0 || len <= 0)
 		return -EINVAL;
 
+	/* Punch hole and write-zeroes are mutually exclusive */
+	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
+	    (mode & FALLOC_FL_ZERO_RANGE))
+		return -EINVAL;
+
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 73e0b62..9aa9599 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -3,6 +3,7 @@
 
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
+#define FALLOC_FL_ZERO_RANGE	0x04 /* write zeroes */
 
 #ifdef __KERNEL__
 
-- 
1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
