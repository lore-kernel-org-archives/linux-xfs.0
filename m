Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F9EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbiLaACl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiLaACk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:02:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8C01E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C538BB81DAF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1A3C433EF;
        Sat, 31 Dec 2022 00:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444956;
        bh=pK4lCzOtjQKF9kAGAlhS5Ml5fZOENt0luz7HjH9XaSs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n8pvngOCrDwiu+sruvDU9oPSMup61XcuzBtLyHJP2uOYHFsRKRpRqHRC4NyHTSoAS
         SYC82WLVI+OY0b9g+WLOPd6hSJF82lHgtIOfteIq5hYNvzU01A1gMuKpIRKH1vQVXi
         rkrwDkTMJ/DKWwIwNBpKZOrHaNVyegPSr7xus/6iJM9A/F/mDQ4ZrLwL0gEwXWTB+x
         w6fhdhxaP2OuAvP+mZUHKuu98vECZclsdOrb1iyx94W7QCKnwGVb5QVhIJa8fb/+CV
         1CS8RNV8ceGb/RzOeKUqlB4uuJltTgz/TjbM9qLdEWXnX6AbUOeO78nE6f9I95q8BL
         q/MWkJCbi7RaA==
Subject: [PATCH 3/3] xfs: ensure dentry consistency when the orphanage adopts
 a file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:20 -0800
Message-ID: <167243846012.700780.86032622922709412.stgit@magnolia>
In-Reply-To: <167243845965.700780.5558696077743355523.stgit@magnolia>
References: <167243845965.700780.5558696077743355523.stgit@magnolia>
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
 fs/xfs/scrub/orphanage.c |  100 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h     |   32 +++++++++++++++
 2 files changed, 127 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 1fe7935433bf..08ff273dbb39 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -356,6 +356,89 @@ xrep_orphanage_adoption_prep(
 	return 0;
 }
 
+/*
+ * Make sure the dcache does not have a positive dentry for the name we've
+ * chosen.  The caller should have checked with the ondisk directory, so any
+ * discrepancy is a sign that something is seriously wrong.
+ */
+static int
+xrep_orphanage_check_dcache(
+	struct xrep_orphanage_req	*orph)
+{
+	struct qstr			qname = QSTR_INIT(orph->xname.name,
+							  orph->xname.len);
+	struct dentry			*d_orphanage, *d_child, *dentry;
+	int				error = 0;
+
+	d_orphanage = d_find_alias(VFS_I(orph->sc->orphanage));
+	if (!d_orphanage)
+		return 0;
+
+	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	if (d_child) {
+		trace_xrep_orphanage_check_child(orph->sc->mp, d_child);
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
+	dentry = d_find_alias(VFS_I(orph->sc->ip));
+	if (dentry) {
+		trace_xrep_orphanage_check_dentry(orph->sc->mp, d_child);
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
+static int
+xrep_orphanage_zap_dcache(
+	struct xrep_orphanage_req	*orph)
+{
+	struct qstr			qname = QSTR_INIT(orph->xname.name,
+							  orph->xname.len);
+	struct dentry			*d_orphanage, *d_child;
+	int				error = 0;
+
+	d_orphanage = d_find_alias(VFS_I(orph->sc->orphanage));
+	if (!d_orphanage)
+		return 0;
+
+	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	while (d_child != NULL) {
+		trace_xrep_orphanage_zap_child(orph->sc->mp, d_child);
+
+		ASSERT(d_is_negative(d_child));
+		d_invalidate(d_child);
+		dput(d_child);
+		d_child = d_lookup(d_orphanage, &qname);
+	}
+
+	dput(d_orphanage);
+	return error;
+}
+
 /*
  * Move the current file to the orphanage.
  *
@@ -375,6 +458,10 @@ xrep_orphanage_adopt(
 
 	trace_xrep_orphanage_adopt(sc->orphanage, &orph->xname, sc->ip->i_ino);
 
+	error = xrep_orphanage_check_dcache(orph);
+	if (error)
+		return error;
+
 	/*
 	 * Create the new name in the orphanage, and bump the link count of
 	 * the orphanage if we just added a directory.
@@ -390,12 +477,15 @@ xrep_orphanage_adopt(
 		xfs_bumplink(sc->tp, sc->orphanage);
 	xfs_trans_log_inode(sc->tp, sc->orphanage, XFS_ILOG_CORE);
 
-	if (!isdir)
-		return 0;
+	if (isdir) {
+		/* Replace the dotdot entry in the child directory. */
+		error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
+				sc->orphanage->i_ino, orph->child_blkres);
+		if (error)
+			return error;
+	}
 
-	/* Replace the dotdot entry in the child directory. */
-	return xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
-			sc->orphanage->i_ino, orph->child_blkres);
+	return xrep_orphanage_zap_dcache(orph);
 }
 
 /* Release the orphanage. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 116f03c2fe48..b29ed4dde427 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2564,6 +2564,38 @@ TRACE_EVENT(xrep_nlinks_set_record,
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
 
 

