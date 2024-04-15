Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CA51591F9
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225215; cv=none; b=Abe3WAN34D3IPo/VJstJbVjg8YYL/czggeOwtN6MiMyP0bm7eTHR+sOBYYkgm4T7S65KQegOGqqmSft6rnQdE8Y6q40gwrYWvbQQ7d2ob7+rY9pv3f+zTm02xZPxKoRAaCuIhBiraOQ8VEooCoWAVSYGuggjmianpVJ/3mKv3cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225215; c=relaxed/simple;
	bh=83VzqMBj+PhVb1aaosJBAAH02qAPcI+UozHk8WD0ogU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n07j72u82C2eodwQarENz4fYrlpZCHk6CgnS1J6kB6WA7YemSMdQKmqfVOUY31sHHWuiIH7PNN5WU19mycYIwA+2s2b6OZa+Lb8o4jES/syYna0rfJ5dSEnL3pvhq2us2FZuWIf63LaCsTsk8soxTKktJMCRdX9XfzWvthmtDA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OydR/ey2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OydR/ey2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA366C113CC;
	Mon, 15 Apr 2024 23:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225214;
	bh=83VzqMBj+PhVb1aaosJBAAH02qAPcI+UozHk8WD0ogU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OydR/ey2nMlSmxpOZkP33i0xFKn/+nIVhKA3ap51OvLZh3qm0w8hJFYsuy7rUQhJ6
	 nA1UEEfNEnL8NkYknLZLFE5fCRrp/zGXag83F/ZIkht/GseidYT6EO0+0PyMKBf57h
	 YlWVz8tNpkocD8gFfPkKdYdxnfXLTn4JqdEx5F4hZFTG9GbJKhxS8yqwLSea1LQv5d
	 pAgA7xoNLLgR2IOU98KDivE5pNuRrVS/J/W3nftcWaoKIWUGQNIhoFLGckgPoZBYrs
	 KLJsxNp7ZoVGaf/rsnxtl+8t1S0aW1uxmzya9vYVLm38BtqtDgKFNg1U5F4iO/qPlH
	 AErZ5JAg3e98w==
Date: Mon, 15 Apr 2024 16:53:34 -0700
Subject: [PATCH 3/3] xfs: ensure dentry consistency when the orphanage adopts
 a file
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322384325.89422.17462796643212181808.stgit@frogsfrogsfrogs>
In-Reply-To: <171322384265.89422.12835876074903686240.stgit@frogsfrogsfrogs>
References: <171322384265.89422.12835876074903686240.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/orphanage.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h     |   42 +++++++++++++++++++++
 2 files changed, 133 insertions(+)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 41733be3ef45..885b7d478a0a 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -418,6 +418,90 @@ xrep_adoption_compute_name(
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
+	struct qstr		qname = QSTR_INIT(adopt->xname->name,
+						  adopt->xname->len);
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
+	 * repaired?  There shouldn't be a hashed dentry with a parent since
+	 * the file had nonzero nlink but wasn't connected to any parent dir.
+	 */
+	d_child = d_find_alias(VFS_I(adopt->sc->ip));
+	if (!d_child)
+		return 0;
+
+	trace_xrep_adoption_check_alias(adopt->sc->mp, d_child);
+
+	if (d_child->d_parent && !d_unhashed(d_child)) {
+		ASSERT(d_child->d_parent == NULL || d_unhashed(d_child));
+		error = -EFSCORRUPTED;
+	}
+
+	dput(d_child);
+	return error;
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
+	struct qstr		qname = QSTR_INIT(adopt->xname->name,
+						  adopt->xname->len);
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
@@ -435,6 +519,10 @@ xrep_adoption_move(
 	trace_xrep_adoption_reparent(sc->orphanage, adopt->xname,
 			sc->ip->i_ino);
 
+	error = xrep_adoption_check_dcache(adopt);
+	if (error)
+		return error;
+
 	/* Create the new name in the orphanage. */
 	error = xfs_dir_createname(sc->tp, sc->orphanage, adopt->xname,
 			sc->ip->i_ino, adopt->orphanage_blkres);
@@ -465,6 +553,9 @@ xrep_adoption_move(
 	 * recorded in the log.
 	 */
 	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, adopt->xname);
+
+	/* Remove negative dentries from the lost+found's dcache */
+	xrep_adoption_zap_dcache(adopt);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 2a4c54f7992a..668da6ff2ca2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2669,6 +2669,48 @@ TRACE_EVENT(xrep_nlinks_set_record,
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

