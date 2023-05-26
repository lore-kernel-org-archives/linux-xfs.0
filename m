Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE251C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjEZBgm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbjEZBgl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:36:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554091B0
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCDED64C35
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB68C433EF;
        Fri, 26 May 2023 01:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064996;
        bh=DiNYpDz0YR37BXiKPOah0B4uZzRhRxvFbz14qG2qs3w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=K9SjlXzcfdXyC32WFh/ZQKzKQUpMueqCpZQxmF6Nd+J7VHe9dsGRMk9+pxMq0cX/C
         nG1EJaqvY3POUhJJ/aX5LETH3ptTS+5UWYebAv8ZSlczDB3Mrk5rSl6jS5oRjkxmf6
         DbwBr+zY8Ls+ylYTS7BF4kVdq4paqDXqU4vuHtPtVXRbz7uPv+sw5qTdB5D8QJk1lI
         yjXT422k7p1cMGMp/lRMnBl3+jlmD2M8Vz+eQF0vbeXmDeCk6Mk723bj+BujmfljT3
         ytKHFY47pliIsAJKh67fjcuQT1wCepHqfMT6RoYT4UNjkQ6AFzRFkJwnuUnjceYgSO
         ssYMqHMhVLnFg==
Date:   Thu, 25 May 2023 18:36:35 -0700
Subject: [PATCH 3/3] xfs: ensure dentry consistency when the orphanage adopts
 a file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067687.3737779.7303295970042971734.stgit@frogsfrogsfrogs>
In-Reply-To: <168506067639.3737779.12844625794200417040.stgit@frogsfrogsfrogs>
References: <168506067639.3737779.12844625794200417040.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When the orphanage adopts a file, that file becomes a child of the
orphanage.  The dentry cache may have entries for the orphanage
directory and the name we've chosen, so (1) make sure we abort if the
dcache has a positive entry because something's not right; and (2)
invalidate and purge negative dentries if the adoption goes through.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/orphanage.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h     |   32 ++++++++++++++++
 2 files changed, 124 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index aece4f94398e..5daa69923641 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -364,6 +364,87 @@ xrep_adoption_prep(
 	return 0;
 }
 
+/*
+ * Make sure the dcache does not have a positive dentry for the name we've
+ * chosen.  The caller should have checked with the ondisk directory, so any
+ * discrepancy is a sign that something is seriously wrong.
+ */
+static int
+xrep_orphanage_check_dcache(
+	struct xrep_adoption	*adopt)
+{
+	struct qstr		qname = QSTR_INIT(adopt->xname.name,
+						  adopt->xname.len);
+	struct dentry		*d_orphanage, *d_child, *dentry;
+	int			error = 0;
+
+	d_orphanage = d_find_alias(VFS_I(adopt->sc->orphanage));
+	if (!d_orphanage)
+		return 0;
+
+	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	if (d_child) {
+		trace_xrep_orphanage_check_child(adopt->sc->mp, d_child);
+
+		if (d_is_positive(d_child)) {
+			ASSERT(d_is_negative(d_child));
+			error = -EFSCORRUPTED;
+		}
+
+		dput(d_child);
+	}
+
+	dput(d_orphanage);
+	if (error)
+		return error;
+
+	/*
+	 * Do we need to update d_parent of the dentry for the file being
+	 * repaired?  In theory there shouldn't be one since the file had
+	 * nonzero nlink but wasn't connected to any parent dir.
+	 */
+	dentry = d_find_alias(VFS_I(adopt->sc->ip));
+	if (dentry) {
+		trace_xrep_orphanage_check_dentry(adopt->sc->mp, d_child);
+		ASSERT(dentry->d_parent == NULL);
+
+		dput(dentry);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Remove all negative dentries from the dcache.  There should not be any
+ * positive entries, since we've maintained our lock on the orphanage
+ * directory.
+ */
+static void
+xrep_orphanage_zap_dcache(
+	struct xrep_adoption	*adopt)
+{
+	struct qstr		qname = QSTR_INIT(adopt->xname.name,
+						  adopt->xname.len);
+	struct dentry		*d_orphanage, *d_child;
+
+	d_orphanage = d_find_alias(VFS_I(adopt->sc->orphanage));
+	if (!d_orphanage)
+		return;
+
+	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	while (d_child != NULL) {
+		trace_xrep_orphanage_zap_child(adopt->sc->mp, d_child);
+
+		ASSERT(d_is_negative(d_child));
+		d_invalidate(d_child);
+		dput(d_child);
+		d_child = d_lookup(d_orphanage, &qname);
+	}
+
+	dput(d_orphanage);
+}
+
 /*
  * Move the current file to the orphanage.
  *
@@ -383,6 +464,10 @@ xrep_adoption_commit(
 
 	trace_xrep_adoption_commit(sc->orphanage, &adopt->xname, sc->ip->i_ino);
 
+	error = xrep_orphanage_check_dcache(adopt);
+	if (error)
+		return error;
+
 	/*
 	 * Create the new name in the orphanage, and bump the link count of
 	 * the orphanage if we just added a directory.
@@ -412,7 +497,13 @@ xrep_adoption_commit(
 	 * recorded in the log.
 	 */
 	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, xname);
-	return xrep_defer_finish(sc);
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+
+	/* Remove negative dentries from the lost+found's dcache */
+	xrep_orphanage_zap_dcache(adopt);
+	return 0;
 }
 
 /* Cancel a proposed relocation of a file to the orphanage. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cbac347b4a79..c90a444fe0c5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2593,6 +2593,38 @@ TRACE_EVENT(xrep_nlinks_set_record,
 		  __entry->children)
 );
 
+DECLARE_EVENT_CLASS(xrep_dentry_class,
+	TP_PROTO(struct xfs_mount *mp, const struct dentry *dentry),
+	TP_ARGS(mp, dentry),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(unsigned long, ino)
+		__field(bool, positive)
+		__field(bool, has_parent)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->type = __d_entry_type(dentry);
+		__entry->positive = d_is_positive(dentry);
+		__entry->has_parent = dentry->d_parent != NULL;
+		__entry->ino = d_inode(dentry) ? d_inode(dentry)->i_ino : 0;
+	),
+	TP_printk("dev %d:%d type 0x%x positive? %d parent? %d ino 0x%lx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->positive,
+		  __entry->has_parent,
+		  __entry->ino)
+);
+#define DEFINE_REPAIR_DENTRY_EVENT(name) \
+DEFINE_EVENT(xrep_dentry_class, name, \
+	TP_PROTO(struct xfs_mount *mp, const struct dentry *dentry), \
+	TP_ARGS(mp, dentry))
+DEFINE_REPAIR_DENTRY_EVENT(xrep_orphanage_check_child);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_orphanage_check_dentry);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_orphanage_zap_child);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 

