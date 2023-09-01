Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE0BCA0FE4
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 16:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjIAQAd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbjIAQAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 12:00:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E9A1715
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 09:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A98FCB825C2
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 16:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E2FC433C7;
        Fri,  1 Sep 2023 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693584021;
        bh=BsmQoFTgFO+5Nj9Kw7/YVh62wt3GDN80Q1ybWRvOqoc=;
        h=Date:From:To:Cc:Subject:From;
        b=cm4d25ttWi7GweQ2Q2VrCadpMoasovVDv9Tpm632s9R9lX8ztRD5/MdZLDwdfcYGl
         a8tMvcpUKi3PUgTbUpIzEkIstwD6GeJE1Yu5kery+/DrKKLc1qxADByo54FZaO9LHy
         S24lIV4maagVnh8Y+5vj8Bd68lCIauq4tk8RINJfpHbKRIC8n9VEVJXWqjBc1tsigZ
         m/5DnaO6sUzEBY8kz7GoS14Y5qwZd2Y59XUa/pC2EZYs8F5kxOjHiZ31XrLLkBLFeh
         /Vp1hi892fSXePyFVK18Msanknnf6VkXA10KxfeXup6MM9w5XvjbEmt3wNBTjmlQBp
         f7xYvl2kuBjbQ==
Date:   Fri, 1 Sep 2023 09:00:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Bill O'Donnell <bodonnel@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH v4] xfs: load uncached unlinked inodes into memory on demand
Message-ID: <20230901160020.GT28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

shrikanth hegde reports that filesystems fail shortly after mount with
the following failure:

	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]

This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:

	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }

From diagnostic data collected by the bug reporters, it would appear
that we cleanly mounted a filesystem that contained unlinked inodes.
Unlinked inodes are only processed as a final step of log recovery,
which means that clean mounts do not process the unlinked list at all.

Prior to the introduction of the incore unlinked lists, this wasn't a
problem because the unlink code would (very expensively) traverse the
entire ondisk metadata iunlink chain to keep things up to date.
However, the incore unlinked list code complains when it realizes that
it is out of sync with the ondisk metadata and shuts down the fs, which
is bad.

Ritesh proposed to solve this problem by unconditionally parsing the
unlinked lists at mount time, but this imposes a mount time cost for
every filesystem to catch something that should be very infrequent.
Instead, let's target the places where we can encounter a next_unlinked
pointer that refers to an inode that is not in cache, and load it into
cache.

Note: This patch does not address the problem of iget loading an inode
from the middle of the iunlink list and needing to set i_prev_unlinked
correctly.

Eric Sandeen adds:

"One way to end up in this situation is to have at one point run a very
old kernel which did not contain this commit, merged in kernel v4.14:

commit 6f4a1eefdd0ad4561543270a7fceadabcca075dd
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Aug 8 18:21:49 2017 -0700

    xfs: toggle readonly state around xfs_log_mount_finish

    When we do log recovery on a readonly mount, unlinked inode
    processing does not happen due to the readonly checks in
    xfs_inactive(), which are trying to prevent any I/O on a
    readonly mount.

    This is misguided - we do I/O on readonly mounts all the time,
    for consistency; for example, log recovery.  So do the same
    RDONLY flag twiddling around xfs_log_mount_finish() as we
    do around xfs_log_mount(), for the same reason.

    This all cries out for a big rework but for now this is a
    simple fix to an obvious problem.

    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

"so if you:

1) Crash with unlinked inodes
2) mount -o ro <recovers log but skips unlinked inode recovery>
3) mount -o remount,rw
4) umount <writes clean log record>

"You now have a filesystem with on-disk unlinked inodes and a clean log,
and those inodes won't get cleaned up until log recovery runs again or
xfs_repair is run.

"And in testing an old OS (RHEL7) it does seem that the root filesystem
goes through a mount -o ro, mount -o remount,rw transition at boot time.
So this situation may be somewhat common."

Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
v4: update the comment for update_backref
v3: add RVB tags and historical context from sandeen
v2: log that we're doing runtime recovery, dont mess with DONTCACHE,
    and actually return ENOLINK
---
 fs/xfs/xfs_inode.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trace.h |   25 ++++++++++++++++
 2 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6ee266be45d4..3e3df3d8bcdd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1829,12 +1829,17 @@ xfs_iunlink_lookup(
 
 	rcu_read_lock();
 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+	if (!ip) {
+		/* Caller can handle inode not being in memory. */
+		rcu_read_unlock();
+		return NULL;
+	}
 
 	/*
-	 * Inode not in memory or in RCU freeing limbo should not happen.
-	 * Warn about this and let the caller handle the failure.
+	 * Inode in RCU freeing limbo should not happen.  Warn about this and
+	 * let the caller handle the failure.
 	 */
-	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
+	if (WARN_ON_ONCE(!ip->i_ino)) {
 		rcu_read_unlock();
 		return NULL;
 	}
@@ -1843,7 +1848,10 @@ xfs_iunlink_lookup(
 	return ip;
 }
 
-/* Update the prev pointer of the next agino. */
+/*
+ * Update the prev pointer of the next agino.  Returns -ENOLINK if the inode
+ * is not in cache.
+ */
 static int
 xfs_iunlink_update_backref(
 	struct xfs_perag	*pag,
@@ -1858,7 +1866,8 @@ xfs_iunlink_update_backref(
 
 	ip = xfs_iunlink_lookup(pag, next_agino);
 	if (!ip)
-		return -EFSCORRUPTED;
+		return -ENOLINK;
+
 	ip->i_prev_unlinked = prev_agino;
 	return 0;
 }
@@ -1902,6 +1911,62 @@ xfs_iunlink_update_bucket(
 	return 0;
 }
 
+/*
+ * Load the inode @next_agino into the cache and set its prev_unlinked pointer
+ * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
+ * to the unlinked list.
+ */
+STATIC int
+xfs_iunlink_reload_next(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agibp,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_perag	*pag = agibp->b_pag;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode	*next_ip = NULL;
+	xfs_ino_t		ino;
+	int			error;
+
+	ASSERT(next_agino != NULLAGINO);
+
+#ifdef DEBUG
+	rcu_read_lock();
+	next_ip = radix_tree_lookup(&pag->pag_ici_root, next_agino);
+	ASSERT(next_ip == NULL);
+	rcu_read_unlock();
+#endif
+
+	xfs_info_ratelimited(mp,
+ "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating recovery.",
+			next_agino, pag->pag_agno);
+
+	/*
+	 * Use an untrusted lookup just to be cautious in case the AGI has been
+	 * corrupted and now points at a free inode.  That shouldn't happen,
+	 * but we'd rather shut down now since we're already running in a weird
+	 * situation.
+	 */
+	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
+	if (error)
+		return error;
+
+	/* If this is not an unlinked inode, something is very wrong. */
+	if (VFS_I(next_ip)->i_nlink != 0) {
+		error = -EFSCORRUPTED;
+		goto rele;
+	}
+
+	next_ip->i_prev_unlinked = prev_agino;
+	trace_xfs_iunlink_reload_next(next_ip);
+rele:
+	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
+	xfs_irele(next_ip);
+	return error;
+}
+
 static int
 xfs_iunlink_insert_inode(
 	struct xfs_trans	*tp,
@@ -1933,6 +1998,8 @@ xfs_iunlink_insert_inode(
 	 * inode.
 	 */
 	error = xfs_iunlink_update_backref(pag, agino, next_agino);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
 	if (error)
 		return error;
 
@@ -2027,6 +2094,9 @@ xfs_iunlink_remove_inode(
 	 */
 	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
 			ip->i_next_unlinked);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
+				ip->i_next_unlinked);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 36bd42ed9ec8..f4e46bac9b91 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3832,6 +3832,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		  __entry->new_ptr)
 );
 
+TRACE_EVENT(xfs_iunlink_reload_next,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+		__entry->prev_agino = ip->i_prev_unlinked;
+		__entry->next_agino = ip->i_next_unlinked;
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x prev_unlinked 0x%x next_unlinked 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->prev_agino,
+		  __entry->next_agino)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
 	TP_ARGS(ip),
