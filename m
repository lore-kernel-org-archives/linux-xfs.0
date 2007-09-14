Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 11:31:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EIV24p023833
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 11:31:05 -0700
Message-ID: <46EAD364.7060305@sandeen.net>
Date: Fri, 14 Sep 2007 13:31:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/4] simplify xfs_create/mknod/symlink prototype
References: <20070914163041.GG7110@lst.de>
In-Reply-To: <20070914163041.GG7110@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> (sorry, go the patch numbering one off)
> 
> Simplify the prototype for xfs_create/xfs_mkdir/xfs_symlink by not
> passing down a bhv_vattr_t that just hogs stack space.  Instead pass
> down the mode in a mode_t and in case of xfs_crate the rdev as a scalar
> type aswell.

With this whole patch series, I see these stack reductions on my x86
box, nice!

--- before      2007-09-14 06:41:25.000000000 -0500
+++ after       2007-09-14 06:42:25.000000000 -0500
-vn_revalidate [xfs]: 100
+vn_revalidate [xfs]: 4
-xfs_bmbt_delrec [xfs]: 212
+xfs_bmbt_delrec [xfs]: 204
-xfs_free_file_space [xfs]: 196
+xfs_free_file_space [xfs]: 188
+xfs_ioc_fsgetxattr [xfs]: 28
-xfs_ioctl [xfs]: 64
+xfs_ioctl [xfs]: 68
-xfs_symlink [xfs]: 240
+xfs_symlink [xfs]: 256
-xfs_validate_fields [xfs]: 4
+xfs_validate_fields [xfs]: 8
-xfs_vn_getattr [xfs]: 104
+xfs_vn_getattr [xfs]: 12
-xfs_vn_link [xfs]: 108
+xfs_vn_link [xfs]: 8
-xfs_vn_mknod [xfs]: 128
+xfs_vn_mknod [xfs]: 32
-xfs_vn_rename [xfs]: 108
-xfs_vn_rmdir [xfs]: 104
+xfs_vn_rename [xfs]: 8
-xfs_vn_symlink [xfs]: 120
+xfs_vn_symlink [xfs]: 20
-xfs_vn_unlink [xfs]: 104
