Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 18:03:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F1350j020919
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 18:03:09 -0700
Date: Thu, 15 May 2008 11:03:51 +1000
Subject: VFS case-insenstive dcache code (was Re: [PATCH 0/4] XFS: ASCII case-insensitivity support)
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080514075244.738514733@chook.melbourne.sgi.com> <20080514084344.GA4333@infradead.org>
Message-ID: <op.ua57wpji3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080514084344.GA4333@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Anton Altaparmakov <aia21@cam.ac.uk>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, 14 May 2008 18:43:44 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> All patches looks good to me, but please add a comment describing the
> conditional d_reash in the create case.

I'm separating the "return name" patch into two patches: one for the dcache
code which Anton wrote and one with the XFS specific code.

So, how does one apply the Signed-off line and copyright for the dcache
code (below - possibly mangled)?

Regards,
Barry.

--

VFS: Add case-insensitive support d_ci_add() routine

This add a dcache entry to the dcache for lookup, but changing the name
that is associated with the entry rather than the one passed in to the
lookup routine.

First, it sees if the case-exact match already exists in the dcache and
uses it if one exists. Otherwise, it allocates a new node with the new
name and splices it into the dcache.


---
  fs/dcache.c            |  104  
+++++++++++++++++++++++++++++++++++++++++++++++++
  include/linux/dcache.h |    1
  2 files changed, 105 insertions(+)

Index: kern_ci/fs/dcache.c
===================================================================
--- kern_ci.orig/fs/dcache.c
+++ kern_ci/fs/dcache.c
@@ -1191,6 +1191,109 @@ struct dentry *d_splice_alias(struct ino
  	return new;
  }

+/**
+ * d_add_ci - lookup or allocate new dentry with case-exact name
+ * @inode:  the inode case-insensitive lookup has found
+ * @dentry: the negative dentry that was passed to the parent's lookup  
func
+ * @name:   the case-exact name to be associated with the returned dentry
+ *
+ * This is to avoid filling the dcache with case-insensitive names to the
+ * same inode, only the actual correct case is stored in the dcache for
+ * case-insensitive filesystems.
+ *
+ * For a case-insensitive lookup match and if the the case-exact dentry
+ * already exists in in the dcache, use it and return it.
+ *
+ * If no entry exists with the exact case name, allocate new dentry with
+ * the exact case, and return the spliced entry.
+ */
+
+struct dentry *d_add_ci(struct inode *inode, struct dentry *dentry,
+			struct qstr *name)
+{
+	int error;
+	struct dentry *found;
+	struct dentry *new;
+
+	/* Does a dentry matching the name exist already? */
+	found = d_hash_and_lookup(dentry->d_parent, name);
+	/* If not, create it now and return */
+	if (!found) {
+		new = d_alloc(dentry->d_parent, name);
+		if (!new) {
+			error = -ENOMEM;
+			goto err_out;
+		}
+		found = d_splice_alias(inode, new);
+		if (found) {
+			dput(new);
+			return found;
+		}
+		return new;
+	}
+	/* Matching dentry exists, check if it is negative. */
+	if (found->d_inode) {
+		if (unlikely(found->d_inode != inode)) {
+			/* This can't happen because bad inodes are unhashed. */
+			BUG_ON(!is_bad_inode(inode));
+			BUG_ON(!is_bad_inode(found->d_inode));
+		}
+		/*
+		 * Already have the inode and the dentry attached, decrement
+		 * the reference count to balance the iget() done
+		 * earlier on.  We found the dentry using d_lookup() so it
+		 * cannot be disconnected and thus we do not need to worry
+		 * about any NFS/disconnectedness issues here.
+		 */
+		iput(inode);
+		return found;
+	}
+	/*
+	 * Negative dentry: instantiate it unless the inode is a directory and
+	 * has a 'disconnected' dentry (i.e. IS_ROOT and DCACHE_DISCONNECTED),
+	 * in which case d_move() that in place of the found dentry.
+	 */
+	if (!S_ISDIR(inode->i_mode)) {
+		/* Not a directory; everything is easy. */
+		d_instantiate(found, inode);
+		return found;
+	}
+	spin_lock(&dcache_lock);
+	if (list_empty(&inode->i_dentry)) {
+		/*
+		 * Directory without a 'disconnected' dentry; we need to do
+		 * d_instantiate() by hand because it takes dcache_lock which
+		 * we already hold.
+		 */
+		list_add(&found->d_alias, &inode->i_dentry);
+		found->d_inode = inode;
+		spin_unlock(&dcache_lock);
+		security_d_instantiate(found, inode);
+		return found;
+	}
+	/*
+	 * Directory with a 'disconnected' dentry; get a reference to the
+	 * 'disconnected' dentry.
+	 */
+	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
+	dget_locked(new);
+	spin_unlock(&dcache_lock);
+	/* Do security vodoo. */
+	security_d_instantiate(found, inode);
+	/* Move new in place of found. */
+	d_move(new, found);
+	/* Balance the iget() we did above. */
+	iput(inode);
+	/* Throw away found. */
+	dput(found);
+	/* Use new as the actual dentry. */
+	return new;
+
+err_out:
+	iput(inode);
+	return ERR_PTR(error);
+}
+

  /**
   * d_lookup - search for a dentry
@@ -2178,6 +2281,7 @@ EXPORT_SYMBOL(d_path);
  EXPORT_SYMBOL(d_prune_aliases);
  EXPORT_SYMBOL(d_rehash);
  EXPORT_SYMBOL(d_splice_alias);
+EXPORT_SYMBOL(d_add_ci);
  EXPORT_SYMBOL(d_validate);
  EXPORT_SYMBOL(dget_locked);
  EXPORT_SYMBOL(dput);
Index: kern_ci/include/linux/dcache.h
===================================================================
--- kern_ci.orig/include/linux/dcache.h
+++ kern_ci/include/linux/dcache.h
@@ -231,6 +231,7 @@ extern void d_delete(struct dentry *);
  extern struct dentry * d_alloc(struct dentry *, const struct qstr *);
  extern struct dentry * d_alloc_anon(struct inode *);
  extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
+extern struct dentry * d_add_ci(struct inode *, struct dentry *, struct  
qstr *);
  extern void shrink_dcache_sb(struct super_block *);
  extern void shrink_dcache_parent(struct dentry *);
  extern void shrink_dcache_for_umount(struct super_block *);
