Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B2B47F90
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A405304053
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3Csx0TCUDEAkl2hB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] jbd2: Simplify calling convention around
	__jbd2_journal_clean_checkpoint_list
Date: Fri, 10 Oct 2014 16:23:47 +0200
Message-Id: <1412951028-4085-43-git-send-email-jack@suse.cz>
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

__jbd2_journal_clean_checkpoint_list() returns number of buffers it
freed but noone was using the value so just stop doing that. This
also allows for simplifying the calling convention for
journal_clean_once_cp_list().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 56 ++++++++++++++++++++++------------------------------
 include/linux/jbd2.h |  2 +-
 2 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index e39b2d0e1079..ef23d6f4a6a2 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -479,16 +479,15 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
  * release them.
  *
  * Called with j_list_lock held.
- * Returns number of buffers reaped (for debug)
+ * Returns 1 if we freed the transaction, 0 otherwise.
  */
-
-static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
+static int journal_clean_one_cp_list(struct journal_head *jh)
 {
 	struct journal_head *last_jh;
 	struct journal_head *next_jh = jh;
-	int ret, freed = 0;
+	int ret;
+	int freed = 0;
 
-	*released = 0;
 	if (!jh)
 		return 0;
 
@@ -499,11 +498,9 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
 		ret = __try_to_free_cp_buf(jh);
 		if (!ret)
 			return freed;
-		freed++;
-		if (ret == 2) {
-			*released = 1;
-			return freed;
-		}
+		if (ret == 2)
+			return 1;
+		freed = 1;
 		/*
 		 * This function only frees up some memory
 		 * if possible so we dont have an obligation
@@ -523,53 +520,48 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
  * Find all the written-back checkpoint buffers in the journal and release them.
  *
  * Called with j_list_lock held.
- * Returns number of buffers reaped (for debug)
  */
-
-int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
+void __jbd2_journal_clean_checkpoint_list(journal_t *journal)
 {
 	transaction_t *transaction, *last_transaction, *next_transaction;
 	int ret;
-	int freed = 0;
-	int released;
 
 	transaction = journal->j_checkpoint_transactions;
 	if (!transaction)
-		goto out;
+		return;
 
 	last_transaction = transaction->t_cpprev;
 	next_transaction = transaction;
 	do {
 		transaction = next_transaction;
 		next_transaction = transaction->t_cpnext;
-		ret = journal_clean_one_cp_list(transaction->
-				t_checkpoint_list, &released);
+		ret = journal_clean_one_cp_list(transaction->t_checkpoint_list);
 		/*
 		 * This function only frees up some memory if possible so we
 		 * dont have an obligation to finish processing. Bail out if
 		 * preemption requested:
 		 */
-		if (need_resched()) {
-			freed += ret;
-			goto out;
-		}
-		if (released) {
-			freed += ret;
+		if (need_resched())
+			return;
+		if (ret)
 			continue;
-		}
 		/*
 		 * It is essential that we are as careful as in the case of
 		 * t_checkpoint_list with removing the buffer from the list as
 		 * we can possibly see not yet submitted buffers on io_list
 		 */
-		ret += journal_clean_one_cp_list(transaction->
-				t_checkpoint_io_list, &released);
-		freed += ret;
-		if (need_resched() || !ret)
-			goto out;
+		ret = journal_clean_one_cp_list(transaction->
+				t_checkpoint_io_list);
+		if (need_resched())
+			return;
+		/*
+		 * Stop scanning if we couldn't free the transaction. This
+		 * avoids pointless scanning of transactions which still
+		 * weren't checkpointed.
+		 */
+ 		if (!ret)
+			return;
 	} while (transaction != last_transaction);
-out:
-	return freed;
 }
 
 /*
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0dae71e9971c..704b9a599b26 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1042,7 +1042,7 @@ void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
 extern void jbd2_journal_commit_transaction(journal_t *);
 
 /* Checkpoint list management */
-int __jbd2_journal_clean_checkpoint_list(journal_t *journal);
+void __jbd2_journal_clean_checkpoint_list(journal_t *journal);
 int __jbd2_journal_remove_checkpoint(struct journal_head *);
 void __jbd2_journal_insert_checkpoint(struct journal_head *, transaction_t *);
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
