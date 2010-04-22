Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPZg0227406 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:35 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A25E1AE6281
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:36 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id d05dH8a0nigpnthv for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:36 -0700 (PDT)
Message-Id: <20100422190908.571068638@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:44 -0700
From: Greg KH <gregkh@suse.de>
Subject: [013/197] xfs: Fix error return for fallocate() on XFS
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

commit 44a743f68705c681439f264deb05f8f38e9048d3 upstream

Noticed that through glibc fallocate would return 28 rather than -1
and errno = 28 for ENOSPC. The xfs routines uses XFS_ERROR format
positive return error codes while the syscalls use negative return
codes.  Fixup the two cases in xfs_vn_fallocate syscall to convert to
negative.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -573,8 +573,8 @@ xfs_vn_fallocate(
 	bf.l_len = len;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				      0, XFS_ATTR_NOLOCK);
+	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
+				       0, XFS_ATTR_NOLOCK);
 	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode))
 		new_size = offset + len;
@@ -585,7 +585,7 @@ xfs_vn_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
