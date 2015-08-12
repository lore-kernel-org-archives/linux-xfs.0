Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A50D57CBE
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 06:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8338F8F8035
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 04:46:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n5ALloPVUzYwSv8o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 04:46:02 -0700 (PDT)
Date: Wed, 12 Aug 2015 13:43:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/2] xfs: kill lockdep false positives from readdir
Message-ID: <20150812114347.GB3712@redhat.com>
References: <1439330648-1057-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439330648-1057-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, xfs@oss.sgi.com

forgot to show the patch, sorry for double posting...

On 08/12, Dave Chinner wrote:
>
> Oleg and Jan, this patchset should fix the lockdep issues that have
> been seen with the freeze rework. Oleg, can you you try it with your
> current patchset and testing and let me know if there are any issues
> that you see?

Tested-by: Oleg Nesterov <oleg@redhat.com>



To clarify, I tested these patches with

	[PATCH v2 0/8] change sb_writers to use percpu_rw_semaphore

I sent yesterday first. Then I applied the additional patch (attached
below) which just restores the lockdep improvements from v1, everything
looks fine:

	Ran: generic/068 generic/085 generic/280 generic/311 xfs/011 xfs/119 xfs/297
	Passed all 7 tests

nothing interesting in dmesg.

Thanks Dave!

Oleg.


--- a/fs/super.c
+++ b/fs/super.c
@@ -1215,25 +1215,31 @@ EXPORT_SYMBOL(__sb_start_write);
 static void sb_wait_write(struct super_block *sb, int level)
 {
 	percpu_down_write(sb->s_writers.rw_sem + level-1);
-	/*
-	 * We are going to return to userspace and forget about this lock, the
-	 * ownership goes to the caller of thaw_super() which does unlock.
-	 *
-	 * FIXME: we should do this before return from freeze_super() after we
-	 * called sync_filesystem(sb) and s_op->freeze_fs(sb), and thaw_super()
-	 * should re-acquire these locks before s_op->unfreeze_fs(sb). However
-	 * this leads to lockdep false-positives, so currently we do the early
-	 * release right after acquire.
-	 */
-	percpu_rwsem_release(sb->s_writers.rw_sem + level-1, 0, _THIS_IP_);
 }
 
-static void sb_freeze_unlock(struct super_block *sb)
+/*
+ * We are going to return to userspace and forget about these locks, the
+ * ownership goes to the caller of thaw_super()->sb_freeze_acquire().
+ */
+static void sb_freeze_release(struct super_block *sb)
+{
+	int level;
+
+	for (level = SB_FREEZE_LEVELS; --level >= 0; )
+		percpu_rwsem_release(sb->s_writers.rw_sem + level, 0, _THIS_IP_);
+}
+
+static void sb_freeze_acquire(struct super_block *sb)
 {
 	int level;
 
 	for (level = 0; level < SB_FREEZE_LEVELS; ++level)
 		percpu_rwsem_acquire(sb->s_writers.rw_sem + level, 0, _THIS_IP_);
+}
+
+static void sb_freeze_unlock(struct super_block *sb)
+{
+	int level;
 
 	for (level = SB_FREEZE_LEVELS; --level >= 0; )
 		percpu_up_write(sb->s_writers.rw_sem + level);
@@ -1329,6 +1335,7 @@ int freeze_super(struct super_block *sb)
 	 * sees write activity when frozen is set to SB_FREEZE_COMPLETE.
 	 */
 	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
+	sb_freeze_release(sb);
 	up_write(&sb->s_umount);
 	return 0;
 }
@@ -1355,11 +1362,14 @@ int thaw_super(struct super_block *sb)
 		goto out;
 	}
 
+	sb_freeze_acquire(sb);
+
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
 		if (error) {
 			printk(KERN_ERR
 				"VFS:Filesystem thaw failed\n");
+			sb_freeze_release(sb);
 			up_write(&sb->s_umount);
 			return error;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
