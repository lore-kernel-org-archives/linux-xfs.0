Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B691CFA9
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505138; cv=none; b=suZ28yoUIK5mjxWEqqhE5hzInmQCYvb2kfzxhujRb+0Gn0cfjW5q6yEY2fQ+h6oSikk+z3g+VY+Uu2kJ5EUP6G8EFnBtsNgkOBFuOrUikyYG8Z99RtAmB0iIlyZ6uRPNF1zhhcZxsw1MYpC6Xm4+la/g2dVAfTbiMcv/f3TbN60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505138; c=relaxed/simple;
	bh=ti5dI4YMsy0jOShQ7L6HDuUd+fmNiQRoPWheizrRsQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GamD/tq/fCkABmFZrt+UKNx90M9S4+csF5OICm0+Q5KsYvSRcF4wfxUFYPLpg/wEvpk5lOBkyfsKjFs1lzvbOjLh2I2HLLIOODGR1rJSCxJ3Yj+r9dZdsYUdw5GOrX3hM0pLK/K1oyaHUcBCJe5GHvHxOgR+7Hr0NuqeP/e7tYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1O1n3PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1O1n3PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E922BC433C7;
	Wed, 27 Mar 2024 02:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505138;
	bh=ti5dI4YMsy0jOShQ7L6HDuUd+fmNiQRoPWheizrRsQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L1O1n3PLnfwOr+eUlaI4k1hnvs7Z3aHzcfKayjuzqhsgQFsAP///zGqLhUiqTw/ai
	 gfERMx6xTBS0V3UeySLL52gDvz2VQdgPLeFrQ19NNDMVDr47EOI7nl5UgA7rIZQ3dX
	 BkakDKco+/fU11UX9PGo0jUaqMZIoUZ3Gh9CW+MUzi3R5I/5XSBcLOQqEco1EmBCnO
	 fG8V8faMK++PRuweW2xsrzNn9a837jvFQbKl/5PO8ROTuxsxLjczLzPUDJztwHtKNY
	 w8KZwUIWkpV1NQ1Yd+yxWGwW/EUFbicLBu1sLU26Tfy+3JvWXQRhPxxHs8jskHKAx1
	 JYFvwz0OL0KsQ==
Date: Tue, 26 Mar 2024 19:05:37 -0700
Subject: [PATCH 3/3] xfs: ensure dentry consistency when the orphanage adopts
 a file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150384004.3218170.11522076633144738534.stgit@frogsfrogsfrogs>
In-Reply-To: <171150383944.3218170.18380002449523163405.stgit@frogsfrogsfrogs>
References: <171150383944.3218170.18380002449523163405.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When the orphanage adopts a file, that file becomes a child of the
orphanage.  The dentry cache may have entries for the orphanage
directory and the name we've chosen, so (1) make sure we abort if the
dcache has a positive entry because something's not right; and (2)
invalidate and purge negative dentries if the adoption goes through.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/orphanage.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h     |   42 ++++++++++++++++++++++
 2 files changed, 130 insertions(+)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 0aedc5c70b632..e1024a7bc9e96 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -418,6 +418,87 @@ xrep_adoption_compute_name(
 	return 0;
 }
 
+/*
+ * Make sure the dcache does not have a positive dentry for the name we've
+ * chosen.  The caller should have checked with the ondisk directory, so any
+ * discrepancy is a sign that something is seriously wrong.
+ */
+static int
+xrep_adoption_check_dcache(
+	struct xrep_adoption	*adopt)
+{
+	struct qstr		qname = QSTR_INIT(adopt->xname.name,
+						  adopt->xname.len);
+	struct dentry		*d_orphanage, *d_child;
+	int			error = 0;
+
+	d_orphanage = d_find_alias(VFS_I(adopt->sc->orphanage));
+	if (!d_orphanage)
+		return 0;
+
+	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	if (d_child) {
+		trace_xrep_adoption_check_child(adopt->sc->mp, d_child);
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
+	d_child = d_find_alias(VFS_I(adopt->sc->ip));
+	if (d_child) {
+		trace_xrep_adoption_check_alias(adopt->sc->mp, d_child);
+		ASSERT(d_child->d_parent == NULL);
+
+		dput(d_child);
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
+xrep_adoption_zap_dcache(
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
+		trace_xrep_adoption_invalidate_child(adopt->sc->mp, d_child);
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
  * Move the current file to the orphanage under the computed name.
  *
@@ -436,6 +517,10 @@ xrep_adoption_move(
 	trace_xrep_adoption_reparent(sc->orphanage, &adopt->xname,
 			sc->ip->i_ino);
 
+	error = xrep_adoption_check_dcache(adopt);
+	if (error)
+		return error;
+
 	/* Create the new name in the orphanage. */
 	error = xfs_dir_createname(sc->tp, sc->orphanage, xname, sc->ip->i_ino,
 			adopt->orphanage_blkres);
@@ -466,6 +551,9 @@ xrep_adoption_move(
 	 * recorded in the log.
 	 */
 	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, xname);
+
+	/* Remove negative dentries from the lost+found's dcache */
+	xrep_adoption_zap_dcache(adopt);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 618f98cddc3df..7915648012c66 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2663,6 +2663,48 @@ TRACE_EVENT(xrep_nlinks_set_record,
 		  __entry->children)
 );
 
+DECLARE_EVENT_CLASS(xrep_dentry_class,
+	TP_PROTO(struct xfs_mount *mp, const struct dentry *dentry),
+	TP_ARGS(mp, dentry),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, flags)
+		__field(unsigned long, ino)
+		__field(bool, positive)
+		__field(unsigned long, parent_ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, dentry->d_name.len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->flags = dentry->d_flags;
+		__entry->positive = d_is_positive(dentry);
+		if (dentry->d_parent && d_inode(dentry->d_parent))
+			__entry->parent_ino = d_inode(dentry->d_parent)->i_ino;
+		else
+			__entry->parent_ino = -1UL;
+		__entry->ino = d_inode(dentry) ? d_inode(dentry)->i_ino : 0;
+		__entry->namelen = dentry->d_name.len;
+		memcpy(__get_str(name), dentry->d_name.name, dentry->d_name.len);
+	),
+	TP_printk("dev %d:%d flags 0x%x positive? %d parent_ino 0x%lx ino 0x%lx name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->flags,
+		  __entry->positive,
+		  __entry->parent_ino,
+		  __entry->ino,
+		  __entry->namelen,
+		  __get_str(name))
+);
+#define DEFINE_REPAIR_DENTRY_EVENT(name) \
+DEFINE_EVENT(xrep_dentry_class, name, \
+	TP_PROTO(struct xfs_mount *mp, const struct dentry *dentry), \
+	TP_ARGS(mp, dentry))
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_child);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_alias);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_dentry);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_invalidate_child);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

