Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71A537F77
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60AE0304070
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id wx8RJaBlErHBNTGj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] sync: don't block the flusher thread waiting on IO
Date: Fri, 10 Oct 2014 16:23:34 +0200
Message-Id: <1412951028-4085-30-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

From: Dave Chinner <dchinner@redhat.com>

When sync does it's WB_SYNC_ALL writeback, it issues data Io and
then immediately waits for IO completion. This is done in the
context of the flusher thread, and hence completely ties up the
flusher thread for the backing device until all the dirty inodes
have been synced. On filesystems that are dirtying inodes constantly
and quickly, this means the flusher thread can be tied up for
minutes per sync call and hence badly affect system level write IO
performance as the page cache cannot be cleaned quickly.

We already have a wait loop for IO completion for sync(2), so cut
this out of the flusher thread and delegate it to wait_sb_inodes().
Hence we can do rapid IO submission, and then wait for it all to
complete.

Effect of sync on fsmark before the patch:

FSUse%        Count         Size    Files/sec     App Overhead
.....
     0       640000         4096      35154.6          1026984
     0       720000         4096      36740.3          1023844
     0       800000         4096      36184.6           916599
     0       880000         4096       1282.7          1054367
     0       960000         4096       3951.3           918773
     0      1040000         4096      40646.2           996448
     0      1120000         4096      43610.1           895647
     0      1200000         4096      40333.1           921048

And a single sync pass took:

  real    0m52.407s
  user    0m0.000s
  sys     0m0.090s

After the patch, there is no impact on fsmark results, and each
individual sync(2) operation run concurrently with the same fsmark
workload takes roughly 7s:

  real    0m6.930s
  user    0m0.000s
  sys     0m0.039s

IOWs, sync is 7-8x faster on a busy filesystem and does not have an
adverse impact on ongoing async data write operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/fs-writeback.c         | 9 +++++++--
 include/linux/writeback.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3be57189efd5..a85ac4e33436 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -45,6 +45,7 @@ struct wb_writeback_work {
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
+	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -443,9 +444,11 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	/*
 	 * Make sure to wait on the data before writing out the metadata.
 	 * This is important for filesystems that modify metadata on data
-	 * I/O completion.
+	 * I/O completion. We don't do it for sync(2) writeback because it has a
+	 * separate, external IO completion path and ->sync_fs for guaranteeing
+	 * inode metadata is written back correctly.
 	 */
-	if (wbc->sync_mode == WB_SYNC_ALL) {
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
 		int err = filemap_fdatawait(mapping);
 		if (ret == 0)
 			ret = err;
@@ -578,6 +581,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 		.tagged_writepages	= work->tagged_writepages,
 		.for_kupdate		= work->for_kupdate,
 		.for_background		= work->for_background,
+		.for_sync		= work->for_sync,
 		.range_cyclic		= work->range_cyclic,
 		.range_start		= 0,
 		.range_end		= LLONG_MAX,
@@ -1362,6 +1366,7 @@ void sync_inodes_sb(struct super_block *sb)
 		.range_cyclic	= 0,
 		.done		= &done,
 		.reason		= WB_REASON_SYNC,
+		.for_sync	= 1,
 	};
 
 	/* Nothing to do? */
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 579a5007c696..abfe11787af3 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -78,6 +78,7 @@ struct writeback_control {
 	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
+	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 };
 
 /*
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
