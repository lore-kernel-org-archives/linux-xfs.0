Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4EBFF7CA3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 21:34:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3DE888F8039
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 19:34:38 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	lyoIl7dandCvqFcx for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 19:34:37 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 2/6] ext2, ext4: only set S_DAX for regular inodes
Date: Tue, 16 Feb 2016 20:34:15 -0700
Message-Id: <1455680059-20126-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@poochiereds.net>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

When S_DAX is set on an inode we assume that if there are pages attached
to the mapping (mapping->nrpages != 0), those pages are clean zero pages
that were used to service reads from holes.  Any dirty data associated with
the inode should be in the form of DAX exceptional entries
(mapping->nrexceptional) that is written back via
dax_writeback_mapping_range().

With the current code, though, this isn't always true.  For example, ext2
and ext4 directory inodes can have S_DAX set, but have their dirty data
stored as dirty page cache entries.  For these types of inodes, having
S_DAX set doesn't really make sense since their I/O doesn't actually happen
through the DAX code path.

Instead, only allow S_DAX to be set for regular inodes for ext2 and ext4.
This allows us to have strict DAX vs non-DAX paths in the writeback code.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext2/inode.c | 2 +-
 fs/ext4/inode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 338eefd..27e2cdd 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1296,7 +1296,7 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX))
+	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
 		inode->i_flags |= S_DAX;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 83bc8bf..7088aa5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4127,7 +4127,7 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX))
+	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
 		new_fl |= S_DAX;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
