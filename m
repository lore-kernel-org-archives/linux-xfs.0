Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FC817F62
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71744304075
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id rR8PqEwyZQuJE6wi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:07 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Avoid lock inversion between i_mmap_mutex and
	transaction start
Date: Fri, 10 Oct 2014 16:23:13 +0200
Message-Id: <1412951028-4085-9-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

When DAX is enabled, it uses i_mmap_mutex as a protection against
truncate during page fault. This inevitably forces i_mmap_mutex to rank
outside of a transaction start and thus we have to avoid calling
pagecache purging operations when transaction is started.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8a064734e6eb..494a8645d63e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3631,13 +3631,19 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
-	/* Now release the pages again to reduce race window */
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+
+	/*
+	 * Now release the pages again to reduce race window. This has to happen
+	 * outside of a transaction to avoid lock inversion on i_mmap_mutex
+	 * when DAX is enabled.
+	 */
 	if (last_block_offset > first_block_offset)
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
-
-	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	goto out_dio;
 out_stop:
 	ext4_journal_stop(handle);
 out_dio:
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
