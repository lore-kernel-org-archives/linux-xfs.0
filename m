Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGAPpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 11:45:54 -0400
Date: Mon, 1 Jul 2019 08:42:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/4] vfs: don't allow most setxattr to immutable files
Message-ID: <20190701154200.GK1404256@magnolia>
References: <156174687561.1557469.7505651950825460767.stgit@magnolia>
 <156174690758.1557469.9258105121276292687.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156174690758.1557469.9258105121276292687.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
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
v2: use memcmp instead of open coding a bunch of checks
---
 fs/inode.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index cf07378e5731..31f694e405fe 100644
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
@@ -2284,6 +2292,15 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 		return -EINVAL;
 
+	/*
+	 * We aren't allowed to change any fields if the immutable flag is
+	 * already set and is not being unset.
+	 */
+	if ((old_fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
+	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
+	    memcmp(fa, old_fa, offsetof(struct fsxattr, fsx_pad)))
+		return -EPERM;
+
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
