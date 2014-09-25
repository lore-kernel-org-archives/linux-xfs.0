Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C4E47F9F
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C384304051
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:42:07 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id bQPGLqwLdj6Hbz84 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:42:05 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Fix mmap data corruption when blocksize < pagesize
Date: Thu, 25 Sep 2014 14:41:56 +0200
Message-Id: <1411648916-16773-3-git-send-email-jack@suse.cz>
In-Reply-To: <1411648916-16773-1-git-send-email-jack@suse.cz>
References: <1411648916-16773-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Use truncate_isize_extended() when hole is being created in a file so that
->page_mkwrite() will get called for the partial tail page if it is
mmaped (see the first patch in the series for details).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9117c4..9e269489e094 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4536,8 +4536,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		} else
+		} else {
+			loff_t oldsize = inode->i_size;
+
 			i_size_write(inode, attr->ia_size);
+			pagecache_isize_extended(inode, oldsize, inode->i_size);
+		}
 
 		/*
 		 * Blocks are going to be removed from the inode. Wait
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
