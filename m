Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F11DC433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 00:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEE336024A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 00:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhDHA4u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 20:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhDHA4u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 20:56:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9922B611C9
        for <linux-xfs@vger.kernel.org>; Thu,  8 Apr 2021 00:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617843399;
        bh=yhtmjAvj/w5dmju6Nq4bNu34iRSKagXzY3knr7rtcbY=;
        h=Date:From:To:Subject:From;
        b=Y2RlR/IysH8aBLyBmGQFdxrWAVR3pXxbPej7yFyjgf2YyBW19ZZBZtoh0qNXq0B6i
         NToBrT/ZtgdnDrCY5/I25mW1LnmzzqSf31WS8yYVw7ap+Q9Xa/g/LXqC0k/zBEVMju
         iHQXoQZIPJXyHS41kYy0S6buUGeb8RGq70GRPlNaGREjjSlacPQQUT57tso2zM2rt6
         XLYcXkwzBfSarwy2zkURKuefCaseiSNtuIS8fcI3cR16AfHgB6XG6LOqpE91vUAIoa
         mc6b4zQw5un3WDMrLGyfwXF23x3Ig73VNT5cJr959lDp7wY2cgb0Gr+ORVVbqHdZkQ
         bqWbTkM9q/PVg==
Date:   Wed, 7 Apr 2021 17:56:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix scrub and remount-ro protection when running scrub
Message-ID: <20210408005636.GS3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running a new fstest that races a readonly remount with scrub
running in repair mode, I observed the kernel tripping over debugging
assertions in the log quiesce code that were checking that the CIL was
empty.  When the sysadmin runs scrub in repair mode, the scrub code
allocates real transactions (with reservations) to change things, but
doesn't increment the superblock writers count to block a readonly
remount attempt while it is running.

We don't require the userspace caller to have a writable file descriptor
to run repairs, so we have to call mnt_want_write_file to obtain freeze
protection and increment the writers count.  It's ok to remove the call
to sb_start_write for the dry-run case because commit 8321ddb2fa29
removed the behavior where scrub and fsfreeze fight over the buffer LRU.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c     |   31 +++++++++++++++++++------------
 fs/xfs/scrub/scrub.h     |    1 +
 fs/xfs/scrub/xfs_scrub.h |    4 ++--
 fs/xfs/xfs_ioctl.c       |    6 +++---
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 47c68c72bcac..9f8be81baf16 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -149,9 +149,10 @@ xchk_probe(
 STATIC int
 xchk_teardown(
 	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip_in,
 	int			error)
 {
+	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->filp));
+
 	xchk_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -168,7 +169,8 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
-	sb_end_write(sc->mp->m_super);
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		mnt_drop_write_file(sc->filp);
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
@@ -456,19 +458,22 @@ static inline void xchk_postmortem(struct xfs_scrub *sc)
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
-	struct xfs_inode		*ip,
+	struct file			*filp,
 	struct xfs_scrub_metadata	*sm)
 {
 	struct xfs_scrub		sc = {
-		.mp			= ip->i_mount,
+		.filp			= filp,
 		.sm			= sm,
 		.sa			= {
 			.agno		= NULLAGNUMBER,
 		},
 	};
+	struct xfs_inode		*ip = XFS_I(file_inode(filp));
 	struct xfs_mount		*mp = ip->i_mount;
 	int				error = 0;
 
+	sc.mp = mp;
+
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
 		(sizeof(struct xchk_meta_ops) * XFS_SCRUB_TYPE_NR));
 
@@ -492,12 +497,14 @@ xfs_scrub_metadata(
 	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
 retry_op:
 	/*
-	 * If freeze runs concurrently with a scrub, the freeze can be delayed
-	 * indefinitely as we walk the filesystem and iterate over metadata
-	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
-	 * be emptied) and that won't happen while checking is running.
+	 * When repairs are allowed, prevent freezing or readonly remount while
+	 * scrub is running with a real transaction.
 	 */
-	sb_start_write(mp->m_super);
+	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		error = mnt_want_write_file(sc.filp);
+		if (error)
+			goto out;
+	}
 
 	/* Set up for the operation. */
 	error = sc.ops->setup(&sc, ip);
@@ -512,7 +519,7 @@ xfs_scrub_metadata(
 		 * Tear down everything we hold, then set up again with
 		 * preparation for worst-case scenarios.
 		 */
-		error = xchk_teardown(&sc, ip, 0);
+		error = xchk_teardown(&sc, 0);
 		if (error)
 			goto out;
 		sc.flags |= XCHK_TRY_HARDER;
@@ -553,7 +560,7 @@ xfs_scrub_metadata(
 			 * get all the resources it needs; either way, we go
 			 * back to the beginning and call the scrub function.
 			 */
-			error = xchk_teardown(&sc, ip, 0);
+			error = xchk_teardown(&sc, 0);
 			if (error) {
 				xrep_failure(mp);
 				goto out;
@@ -565,7 +572,7 @@ xfs_scrub_metadata(
 out_nofix:
 	xchk_postmortem(&sc);
 out_teardown:
-	error = xchk_teardown(&sc, ip, error);
+	error = xchk_teardown(&sc, error);
 out:
 	trace_xchk_done(ip, sm, error);
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ad1ceb44a628..2a90642bac1a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -59,6 +59,7 @@ struct xfs_scrub {
 	struct xfs_scrub_metadata	*sm;
 	const struct xchk_meta_ops	*ops;
 	struct xfs_trans		*tp;
+	struct file			*filp;
 	struct xfs_inode		*ip;
 	void				*buf;
 	uint				ilock_flags;
diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
index 2897ba3a17e6..34eaa7bfccb9 100644
--- a/fs/xfs/scrub/xfs_scrub.h
+++ b/fs/xfs/scrub/xfs_scrub.h
@@ -7,9 +7,9 @@
 #define __XFS_SCRUB_H__
 
 #ifndef CONFIG_XFS_ONLINE_SCRUB
-# define xfs_scrub_metadata(ip, sm)	(-ENOTTY)
+# define xfs_scrub_metadata(filp, sm)	(-ENOTTY)
 #else
-int xfs_scrub_metadata(struct xfs_inode *ip, struct xfs_scrub_metadata *sm);
+int xfs_scrub_metadata(struct file *filp, struct xfs_scrub_metadata *sm);
 #endif /* CONFIG_XFS_ONLINE_SCRUB */
 
 #endif	/* __XFS_SCRUB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e6e4e248cd86..89961f8f5cb1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1847,7 +1847,7 @@ xfs_ioc_getfsmap(
 
 STATIC int
 xfs_ioc_scrub_metadata(
-	struct xfs_inode		*ip,
+	struct file			*filp,
 	void				__user *arg)
 {
 	struct xfs_scrub_metadata	scrub;
@@ -1859,7 +1859,7 @@ xfs_ioc_scrub_metadata(
 	if (copy_from_user(&scrub, arg, sizeof(scrub)))
 		return -EFAULT;
 
-	error = xfs_scrub_metadata(ip, &scrub);
+	error = xfs_scrub_metadata(filp, &scrub);
 	if (error)
 		return error;
 
@@ -2158,7 +2158,7 @@ xfs_file_ioctl(
 		return xfs_ioc_getfsmap(ip, arg);
 
 	case XFS_IOC_SCRUB_METADATA:
-		return xfs_ioc_scrub_metadata(ip, arg);
+		return xfs_ioc_scrub_metadata(filp, arg);
 
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
