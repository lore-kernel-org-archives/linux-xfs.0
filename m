Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54990 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfF1Sg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 14:36:28 -0400
Subject: [PATCH 4/4] vfs: don't allow most setxattr to immutable files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 28 Jun 2019 11:35:07 -0700
Message-ID: <156174690758.1557469.9258105121276292687.stgit@magnolia>
In-Reply-To: <156174687561.1557469.7505651950825460767.stgit@magnolia>
References: <156174687561.1557469.7505651950825460767.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The chattr manpage has this to say about immutable files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

However, we don't actually check the immutable flag in the setattr code,
which means that we can update inode flags and project ids and extent
size hints on supposedly immutable files.  Therefore, reject setflags
and fssetxattr calls on an immutable file if the file is immutable and
will remain that way.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/inode.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)


diff --git a/fs/inode.c b/fs/inode.c
index cf07378e5731..4261c709e50e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2214,6 +2214,14 @@ int vfs_ioc_setflags_prepare(struct inode *inode, unsigned int oldflags,
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
+	/*
+	 * We aren't allowed to change any other flags if the immutable flag is
+	 * already set and is not being unset.
+	 */
+	if ((oldflags & FS_IMMUTABLE_FL) && (flags & FS_IMMUTABLE_FL) &&
+	    oldflags != flags)
+		return -EPERM;
+
 	/*
 	 * Now that we're done checking the new flags, flush all pending IO and
 	 * dirty mappings before setting S_IMMUTABLE on an inode via
@@ -2284,6 +2292,25 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 		return -EINVAL;
 
+	/*
+	 * We aren't allowed to change any fields if the immutable flag is
+	 * already set and is not being unset.
+	 */
+	if ((old_fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
+	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE)) {
+		if (old_fa->fsx_xflags != fa->fsx_xflags)
+			return -EPERM;
+		if (old_fa->fsx_projid != fa->fsx_projid)
+			return -EPERM;
+		if ((fa->fsx_xflags & (FS_XFLAG_EXTSIZE |
+				       FS_XFLAG_EXTSZINHERIT)) &&
+		    old_fa->fsx_extsize != fa->fsx_extsize)
+			return -EPERM;
+		if ((old_fa->fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
+		    old_fa->fsx_cowextsize != fa->fsx_cowextsize)
+			return -EPERM;
+	}
+
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
