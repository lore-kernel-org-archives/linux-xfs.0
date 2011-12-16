Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBGJqZmu066461 for <xfs@oss.sgi.com>; Fri, 16 Dec 2011 13:52:35 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B7F616F42BB
	for <xfs@oss.sgi.com>; Fri, 16 Dec 2011 11:52:32 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id OYIo7yXB7DRldMeJ for <xfs@oss.sgi.com>;
	Fri, 16 Dec 2011 11:52:32 -0800 (PST)
Message-Id: <20111216194211.843986725@clark.kroah.org>
Date: Fri, 16 Dec 2011 11:40:38 -0800
From: Greg KH <gregkh@suse.de>
Subject: [31/45] xfs: fix nfs export of 64-bit inodes numbers on 32-bit kernels
In-Reply-To: <20111216194603.GA15028@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com
Cc: Ben Myers <bpm@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit c29f7d457ac63311feb11928a866efd2fe153d74 upstream.

The i_ino field in the VFS inode is of type unsigned long and thus can't
hold the full 64-bit inode number on 32-bit kernels.  We have the full
inode number in the XFS inode, so use that one for nfs exports.  Note
that I've also switched the 32-bit file handles types to it, just to make
the code more consistent and copy & paste errors less likely to happen.

Reported-by: Guoquan Yang <ygq51@hotmail.com>
Reported-by: Hank Peng <pengxihan@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_export.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -98,22 +98,22 @@ xfs_fs_encode_fh(
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 		spin_lock(&dentry->d_lock);
-		fid->i32.parent_ino = dentry->d_parent->d_inode->i_ino;
+		fid->i32.parent_ino = XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid->i32.parent_gen = dentry->d_parent->d_inode->i_generation;
 		spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN:
-		fid->i32.ino = inode->i_ino;
+		fid->i32.ino = XFS_I(inode)->i_ino;
 		fid->i32.gen = inode->i_generation;
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 		spin_lock(&dentry->d_lock);
-		fid64->parent_ino = dentry->d_parent->d_inode->i_ino;
+		fid64->parent_ino = XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid64->parent_gen = dentry->d_parent->d_inode->i_generation;
 		spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		fid64->ino = inode->i_ino;
+		fid64->ino = XFS_I(inode)->i_ino;
 		fid64->gen = inode->i_generation;
 		break;
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
