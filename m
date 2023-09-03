Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B052DC71153
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Sep 2023 16:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbjICQQE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 12:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbjICQQD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2023 12:16:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A11FE
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 09:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECD106108E
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 16:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B6DC433C8;
        Sun,  3 Sep 2023 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693757759;
        bh=wOF4TfQGWQNFxcSW3lna33Pywg25LRX7hwgz5DXQruU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jGigBycTlRuzffws3WfCL6rc0muryzawSVz7IbtTx1zKGRU0RTFs9nAS/XYteZfdH
         9IpKvwIeqgXkZSXjpR1bHPwhrqUNUxAV3qxlZp56JRntTBTGM6YirGMaCWzTxbTr69
         EZ4osapyeoDdHDgwgflQUHVoQs0/iqpLK+UZ2F1z0MguXN3vmB+BQE0mk2FTFow4Rs
         4Dhpw9QhKNba73rAcYrwRQv9wYGwTjki1sS6xIxOuXzC0zOi6Nsb9PNR37/JLI4yTB
         c0em1Jk/zNteynXFUbM+9tfwtrObj1sLCqUUQPYKEpBYKHi5FFYgYEjaWV46sxyzE0
         m0RlVBkhgjAvw==
Subject: [PATCH 2/3] xfs: reload entire unlinked bucket lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 03 Sep 2023 09:15:59 -0700
Message-ID: <169375775896.3323693.9893712061608339722.stgit@frogsfrogsfrogs>
In-Reply-To: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The previous patch to reload unrecovered unlinked inodes when adding a
newly created inode to the unlinked list is missing a key piece of
functionality.  It doesn't handle the case that someone calls xfs_iget
on an inode that is not the last item in the incore list.  For example,
if at mount time the ondisk iunlink bucket looks like this:

AGI -> 7 -> 22 -> 3 -> NULL

None of these three inodes are cached in memory.  Now let's say that
someone tries to open inode 3 by handle.  We need to walk the list to
make sure that inodes 7 and 22 get loaded cold, and that the
i_prev_unlinked of inode 3 gets set to 22.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_export.c |    6 +++
 fs/xfs/xfs_inode.c  |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |    9 +++++
 fs/xfs/xfs_itable.c |    9 +++++
 fs/xfs/xfs_trace.h  |   20 ++++++++++
 5 files changed, 144 insertions(+)


diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 1064c2342876..f71ea786a6d2 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -146,6 +146,12 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
+	error = xfs_inode_reload_unlinked(ip);
+	if (error) {
+		xfs_irele(ip);
+		return ERR_PTR(error);
+	}
+
 	if (VFS_I(ip)->i_generation != generation) {
 		xfs_irele(ip);
 		return ERR_PTR(-ESTALE);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6cd2f29b540a..56f6bde6001b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3607,3 +3607,103 @@ xfs_iunlock2_io_mmap(
 	if (ip1 != ip2)
 		inode_unlock(VFS_I(ip1));
 }
+
+/*
+ * Reload the incore inode list for this inode.  Caller should ensure that
+ * the link count cannot change, either by taking ILOCK_SHARED or otherwise
+ * preventing other threads from executing.
+ */
+int
+xfs_inode_reload_unlinked_bucket(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agibp;
+	struct xfs_agi		*agi;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		prev_agino, next_agino;
+	unsigned int		bucket;
+	bool			foundit = false;
+	int			error;
+
+	/* Grab the first inode in the list */
+	pag = xfs_perag_get(mp, agno);
+	error = xfs_ialloc_read_agi(pag, tp, &agibp);
+	xfs_perag_put(pag);
+	if (error)
+		return error;
+
+	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
+	agi = agibp->b_addr;
+
+	trace_xfs_inode_reload_unlinked_bucket(ip);
+
+	xfs_info_ratelimited(mp,
+ "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating list recovery.",
+			agino, agno);
+
+	prev_agino = NULLAGINO;
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+	while (next_agino != NULLAGINO) {
+		struct xfs_inode	*next_ip = NULL;
+
+		if (next_agino == agino) {
+			/* Found this inode, set its backlink. */
+			next_ip = ip;
+			next_ip->i_prev_unlinked = prev_agino;
+			foundit = true;
+		}
+		if (!next_ip) {
+			/* Inode already in memory. */
+			next_ip = xfs_iunlink_lookup(pag, next_agino);
+		}
+		if (!next_ip) {
+			/* Inode not in memory, reload. */
+			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
+					next_agino);
+			if (error)
+				break;
+
+			next_ip = xfs_iunlink_lookup(pag, next_agino);
+		}
+		if (!next_ip) {
+			/* No incore inode at all?  We reloaded it... */
+			ASSERT(next_ip != NULL);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		prev_agino = next_agino;
+		next_agino = next_ip->i_next_unlinked;
+	}
+
+	xfs_trans_brelse(tp, agibp);
+	/* Should have found this inode somewhere in the iunlinked bucket. */
+	if (!error && !foundit)
+		error = -EFSCORRUPTED;
+	return error;
+}
+
+/* Decide if this inode is missing its unlinked list and reload it. */
+int
+xfs_inode_reload_unlinked(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_inode_unlinked_incomplete(ip))
+		error = xfs_inode_reload_unlinked_bucket(tp, ip);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_trans_cancel(tp);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 65aae8925509..a111b5551ecd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -593,4 +593,13 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
+static inline bool
+xfs_inode_unlinked_incomplete(
+	struct xfs_inode	*ip)
+{
+	return VFS_I(ip)->i_nlink == 0 && !xfs_inode_on_unlinked_list(ip);
+}
+int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_inode_reload_unlinked(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f225413a993c..ea38d69b9922 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -80,6 +80,15 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out;
 
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked_bucket(tp, ip);
+		if (error) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			return error;
+		}
+	}
+
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f4e46bac9b91..31418d56618d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3857,6 +3857,26 @@ TRACE_EVENT(xfs_iunlink_reload_next,
 		  __entry->next_agino)
 );
 
+TRACE_EVENT(xfs_inode_reload_unlinked_bucket,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x bucket %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->agino % XFS_AGI_UNLINKED_BUCKETS)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
 	TP_ARGS(ip),

