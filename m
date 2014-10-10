Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 492897F67
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1AF718F8050
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id RjIacAhe8qXSLB4r (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:08 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Optimize jbd2_log_do_checkpoint() a bit
Date: Fri, 10 Oct 2014 16:23:24 +0200
Message-Id: <1412951028-4085-20-git-send-email-jack@suse.cz>
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

When we discover written out buffer in transaction checkpoint list we
don't have to recheck validity of a transaction. Either this is the last
buffer in a transaction - and then we are done - or this isn't and then
we can just take another buffer from the checkpoint list without
dropping j_list_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 993a187527f3..3722e2e53638 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -343,12 +343,15 @@ restart:
 		if (!buffer_dirty(bh)) {
 			if (unlikely(buffer_write_io_error(bh)) && !result)
 				result = -EIO;
-			get_bh(bh);
 			BUFFER_TRACE(bh, "remove from checkpoint");
-			__jbd2_journal_remove_checkpoint(jh);
-			spin_unlock(&journal->j_list_lock);
-			__brelse(bh);
-			goto retry;
+			if (__jbd2_journal_remove_checkpoint(jh)) {
+				/*
+				 * This was the last buffer attached to the
+				 * transaction. We are done.
+				 */
+				goto out;
+			}
+			continue;
 		}
 		/*
 		 * Important: we are about to write the buffer, and
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
