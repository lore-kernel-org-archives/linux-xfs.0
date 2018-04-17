Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54146 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbeDQFjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 01:39:12 -0400
Date: Mon, 16 Apr 2018 22:39:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: prevent creating negative-sized file via INSERT_RANGE
Message-ID: <20180417053907.GE5203@magnolia>
References: <20180416204630.177682-1-ebiggers3@gmail.com>
 <20180417005218.GC5203@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417005218.GC5203@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

How about this instead?

--D

---
From: Eric Biggers <ebiggers@google.com>

During the "insert range" fallocate operation, i_size grows by the
specified 'len' bytes.  XFS verifies that i_size + len < s_maxbytes, as
it should.  But this comparison is done using the signed 'loff_t', and
'i_size + len' can wrap around to a negative value, causing the check to
incorrectly pass, resulting in an inode with "negative" i_size.  This is
possible on 64-bit platforms, where XFS sets s_maxbytes = LLONG_MAX.
ext4 and f2fs don't run into this because they set a smaller s_maxbytes.

Fix it by doing an unsigned comparison instead.

Reproducer:
    xfs_io -f file -c "truncate $(((1<<63)-1))" -c "finsert 0 4096"

Fixes: a904b1ca5751 ("xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate")
Cc: <stable@vger.kernel.org> # v4.1+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: rearrange this whole function to use subtraction to avoid
 overflow of the signed integer addition]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9fd9dd7..a385334 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -779,21 +779,27 @@ xfs_file_fallocate(
 			goto out_unlock;
 	} else if (mode & FALLOC_FL_INSERT_RANGE) {
 		unsigned int blksize_mask = i_blocksize(inode) - 1;
+		loff_t		isize;
 
-		new_size = i_size_read(inode) + len;
-		if (offset & blksize_mask || len & blksize_mask) {
-			error = -EINVAL;
+		isize = i_size_read(inode);
+
+		/*
+		 * New inode size must not exceed ->s_maxbytes, accounting for
+		 * possible signed overflow.
+		 */
+		if (inode->i_sb->s_maxbytes - isize < len) {
+			error = -EFBIG;
 			goto out_unlock;
 		}
 
-		/* check the new inode size does not wrap through zero */
-		if (new_size > inode->i_sb->s_maxbytes) {
-			error = -EFBIG;
+		if (offset & blksize_mask || len & blksize_mask) {
+			error = -EINVAL;
 			goto out_unlock;
 		}
 
+		new_size = isize + len;
 		/* Offset should be less than i_size */
-		if (offset >= i_size_read(inode)) {
+		if (offset >= isize) {
 			error = -EINVAL;
 			goto out_unlock;
 		}
