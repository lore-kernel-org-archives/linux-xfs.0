Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CC9529E13
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 16:04:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EA2830407F
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 14:04:11 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	n9ZuUZeiDdYOzXZA for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 14:04:06 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: dquot log reservations are too small
Date: Wed, 10 Jul 2013 07:04:01 +1000
Message-Id: <1373403841-16612-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1373403841-16612-1-git-send-email-david@fromorbit.com>
References: <1373403841-16612-1-git-send-email-david@fromorbit.com>
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
To: bpm@sgi.com
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

During review of the separate project quota inode patches, it became
obvious that the dquot log reservation calculation underestimated
the number dquots that can be modified in a transaction. This has
it's roots way back in the Irix quota implementation.

That is, when quotas were first implemented in XFS, it only
supported user and project quotas as Irix did not have group quotas.
Hence the worst case operation involving dquot modification was
calculated to involve 2 user dquots and 1 project dquot or 1 user
dequot and 2 project dquots. i.e. 3 dquots. This was determined back
in 1996, and has remained unchanged ever since.

However, back in 2001, the Linux XFS port dropped all support for
project quota and implmented group quotas over the top. This was
effectively done with a search-and-replace of project with group,
and as such the log reservation was not changed. However, with the
advent of group quotas, chmod and rename now could modify more than
3 dquots in a single transaction - both could modify 4 dquots. Hence
this log reservation has been wrong for a long time.

In 2005, project quota support was reintroduced into Linux, but it
was implemented to be mutually exclusive to group quotas and so this
didn't add any new changes to the dquot log reservation. Hence when
project quotas were in use (rather than group quotas) the log
reservation was again valid, just like in the Irix days.

Now, with the addition of the separate project quota inode, group
and project quotas are no longer mutually exclusive, and hence
operations can now modify three dquots per inode where previously it
was only two. The worst case here is the rename transaction, which
can allocate/free space on two different directory inodes, and if
they have different uid/gid/prid configurations and are world
writeable, then rename can actually modify 6 different dquots now.

Further, the dquot log reservation doesn't take into account the
space used by the dquot log format structure that precedes the dquot
that is logged, and hence further underestimates the worst case
log space required by dquots during a transaction. This has been
missing since the first commit in 1996.

Hence the worst case log reservation needs to be increased from 3 to
6, and it needs to take into account a log format header for each of
those dquots.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_quota.h       | 25 +++++++++++++++++++++----
 fs/xfs/xfs_trans_dquot.c |  9 ++++-----
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c3483ba..40d508b 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -108,11 +108,28 @@ typedef struct xfs_dqblk {
 	{ XFS_DQ_FREEING,	"FREEING" }
 
 /*
- * In the worst case, when both user and group quotas are on,
- * we can have a max of three dquots changing in a single transaction.
+ * We have the possibility of all three quota types being active at once, and
+ * hence free space modification requires modification of all three current
+ * dquots in a single transaction. For this case we need to have a reservation
+ * of at least 3 dquots.
+ *
+ * However, a chmod operation can change both UID and GID in a single
+ * transaction, resulting in requiring {old, new} x {uid, gid} dquots to be
+ * modified. Hence for this case we need to reserve space for at least 4 dquots.
+ *
+ * And in the worst case, there's a rename operation that can be modifying up to
+ * 4 inodes with dquots attached to them. In reality, the only inodes that can
+ * have their dquots modified are the source and destination directory inodes
+ * due to directory name creation and removal. That can require space allocation
+ * and/or freeing on both directory inodes, and hence all three dquots on each
+ * inode can be modified. And if the directories are world writeable, all the
+ * dquots can be unique and so 6 dquots can be modified....
+ *
+ * And, of course, we also need to take into account the dquot log format item
+ * used to describe each dquot.
  */
-#define XFS_DQUOT_LOGRES(mp)	(sizeof(xfs_disk_dquot_t) * 3)
-
+#define XFS_DQUOT_LOGRES(mp)	\
+	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
 /*
  * These are the structures used to lay out dquots and quotaoff
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3ba64d5..db041a5 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -291,11 +291,10 @@ xfs_trans_mod_dquot(
 
 
 /*
- * Given an array of dqtrx structures, lock all the dquots associated
- * and join them to the transaction, provided they have been modified.
- * We know that the highest number of dquots (of one type - usr OR grp),
- * involved in a transaction is 2 and that both usr and grp combined - 3.
- * So, we don't attempt to make this very generic.
+ * Given an array of dqtrx structures, lock all the dquots associated and join
+ * them to the transaction, provided they have been modified.  We know that the
+ * highest number of dquots of one type - usr, grp OR prj - involved in a
+ * transaction is 2 so we don't need to make this very generic.
  */
 STATIC void
 xfs_trans_dqlockedjoin(
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
