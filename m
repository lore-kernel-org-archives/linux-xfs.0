Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4DKoMZg033683 for <xfs@oss.sgi.com>; Sun, 13 May 2012 15:50:22 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id rqpW11eeALZt4rsX
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 13 May 2012 13:50:21 -0700 (PDT)
Received: by dadg9 with SMTP id g9so6188247dad.26
	for <xfs@oss.sgi.com>; Sun, 13 May 2012 13:50:21 -0700 (PDT)
Date: Sun, 13 May 2012 13:50:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: [PATCH 1/2] xfs: hole-punch use truncate_pagecache_range
Message-ID: <alpine.LSU.2.00.1205131347120.1547@eggly.anvils>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

When truncating a file, we unmap pages from userspace first, as that's
usually more efficient than relying, page by page, on the fallback in
truncate_inode_page() - particularly if the file is mapped many times.

Do the same when punching a hole: 3.4 added truncate_pagecache_range()
to do the unmap and trunc, so use it in xfs_flushinval_pages(), instead
of calling truncate_inode_pages_range() directly.

Should xfs_tosspages() be using it too?  I don't know: left unchanged.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 fs/xfs/xfs_fs_subr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-20120511/fs/xfs/xfs_fs_subr.c	2012-01-17 20:42:07.879627688 -0800
+++ linux/fs/xfs/xfs_fs_subr.c	2012-05-12 18:01:14.988654723 -0700
@@ -53,7 +53,7 @@ xfs_flushinval_pages(
 	ret = filemap_write_and_wait_range(mapping, first,
 				last == -1 ? LLONG_MAX : last);
 	if (!ret)
-		truncate_inode_pages_range(mapping, first, last);
+		truncate_pagecache_range(VFS_I(ip), first, last);
 	return -ret;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
