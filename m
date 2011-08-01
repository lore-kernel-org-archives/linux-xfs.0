Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71ITpo3019475 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 13:29:52 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA478BD94D9
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 11:30:29 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id MzDTA2YGxfQTVBBf for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2011 11:30:29 -0700 (PDT)
Message-ID: <4E36F086.4070900@oracle.com>
Date: Mon, 01 Aug 2011 13:29:26 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: [PATCH]  jfs: flush journal completely before releasing metadata
	inodes
References: <20110729155039.GA28306@infradead.org>
	<4E32D9EB.9020406@oracle.com>
In-Reply-To: <4E32D9EB.9020406@oracle.com>
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
Cc: jfs-discussion@lists.sourceforge.net, xfs@oss.sgi.com

On 07/29/2011 11:03 AM, Dave Kleikamp wrote:
> On 07/29/2011 10:50 AM, Christoph Hellwig wrote:
>> The patch below adds basic jfs support to xfstests.  Unfortunately it
>> doesn't get very far, as test 001 already blows up with a kernel crash,
>> as do 011 and 013 as other random picks.
> 
> Great :-)
> 
> Seems to be a good idea to support jfs. I'll carve out some time to
> reproduce and debug the crashes.

This fixes a race during unmount. We need to not only make sure that
the journal is completely written, but that the metadata changes make
it to disk before releasing ipimap and ipbmap.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/jfs/jfs_umount.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_umount.c b/fs/jfs/jfs_umount.c
index adcf92d..7971f37 100644
--- a/fs/jfs/jfs_umount.c
+++ b/fs/jfs/jfs_umount.c
@@ -68,7 +68,7 @@ int jfs_umount(struct super_block *sb)
 		/*
 		 * Wait for outstanding transactions to be written to log:
 		 */
-		jfs_flush_journal(log, 1);
+		jfs_flush_journal(log, 2);
 
 	/*
 	 * close fileset inode allocation map (aka fileset inode)
@@ -146,7 +146,7 @@ int jfs_umount_rw(struct super_block *sb)
 	 *
 	 * remove file system from log active file system list.
 	 */
-	jfs_flush_journal(log, 1);
+	jfs_flush_journal(log, 2);
 
 	/*
 	 * Make sure all metadata makes it to disk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
