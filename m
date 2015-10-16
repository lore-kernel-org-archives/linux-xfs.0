Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 696117FE6
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:21:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 071FAAC004
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id osWseTz6oM7trjvv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:21 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 25/48] richacl: acl editing helper functions
Date: Fri, 16 Oct 2015 17:18:03 +0200
Message-Id: <1445008706-15115-26-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

The file masks in richacls make chmod and creating new files more
efficient than having to apply file permission bits to the acl directly.
They also allow us to regain permissions from an acl even after a
restrictive chmod, because the permissions in the acl itself are not
being destroyed.  In POSIX ACLs, the mask entry has a similar function.

Protocols like nfsv4 do not understand file masks.  For those protocols,
we need to compute nfs4 acls which represent the effective permissions
granted by a richacl: we need to "apply" the file masks to the acl.

This is the first in a series of richacl transformation patches; it
implements basic richacl editing functions.  The following patches
implement algorithms for transforming a richacl so that it can be
evaluated as a plain nfs4 acl, with identical permission check results.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/Makefile                    |   3 +-
 fs/richacl_compat.c            | 155 +++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl_compat.h |  40 +++++++++++
 3 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 fs/richacl_compat.c
 create mode 100644 include/linux/richacl_compat.h

diff --git a/fs/Makefile b/fs/Makefile
index 35e640d..32b391b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -49,7 +49,8 @@ obj-$(CONFIG_SYSCTL)		+= drop_caches.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 obj-$(CONFIG_FS_RICHACL)	+= richacl.o
-richacl-y			:= richacl_base.o richacl_inode.o richacl_xattr.o
+richacl-y			:= richacl_base.o richacl_inode.o \
+				   richacl_xattr.o richacl_compat.o
 
 obj-y				+= quota/
 
diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
new file mode 100644
index 0000000..341e429
--- /dev/null
+++ b/fs/richacl_compat.c
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2006, 2010  Novell, Inc.
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Written by Andreas Gruenbacher <agruen@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/richacl_compat.h>
+
+/**
+ * richacl_prepare  -  allocate richacl being constructed
+ *
+ * Allocate a richacl which can hold @count entries but which is initially
+ * empty.
+ */
+struct richacl *richacl_prepare(struct richacl_alloc *alloc, unsigned int count)
+{
+	alloc->acl = richacl_alloc(count, GFP_KERNEL);
+	if (!alloc->acl)
+		return NULL;
+	alloc->acl->a_count = 0;
+	alloc->count = count;
+	return alloc->acl;
+}
+EXPORT_SYMBOL_GPL(richacl_prepare);
+
+/**
+ * richacl_delete_entry  -  delete an entry in an acl
+ * @alloc:	acl and number of allocated entries
+ * @ace:	an entry in @alloc->acl
+ *
+ * Updates @ace so that it points to the entry before the deleted entry
+ * on return. (When deleting the first entry, @ace will point to the
+ * (non-existent) entry before the first entry). This behavior is the
+ * expected behavior when deleting entries while forward iterating over
+ * an acl.
+ */
+void
+richacl_delete_entry(struct richacl_alloc *alloc, struct richace **ace)
+{
+	void *end = alloc->acl->a_entries + alloc->acl->a_count;
+
+	memmove(*ace, *ace + 1, end - (void *)(*ace + 1));
+	(*ace)--;
+	alloc->acl->a_count--;
+}
+EXPORT_SYMBOL_GPL(richacl_delete_entry);
+
+/**
+ * richacl_insert_entry  -  insert an entry in an acl
+ * @alloc:	acl and number of allocated entries
+ * @ace:	entry before which the new entry shall be inserted
+ *
+ * Insert a new entry in @alloc->acl at position @ace and zero-initialize
+ * it.  This may require reallocating @alloc->acl.
+ */
+int
+richacl_insert_entry(struct richacl_alloc *alloc, struct richace **ace)
+{
+	struct richacl *acl = alloc->acl;
+	unsigned int index = *ace - acl->a_entries;
+	size_t tail_size = (acl->a_count - index) * sizeof(struct richace);
+
+	if (alloc->count == acl->a_count) {
+		size_t new_size = sizeof(struct richacl) +
+			(acl->a_count + 1) * sizeof(struct richace);
+
+		acl = krealloc(acl, new_size, GFP_KERNEL);
+		if (!acl)
+			return -1;
+		*ace = acl->a_entries + index;
+		alloc->acl = acl;
+		alloc->count++;
+	}
+
+	memmove(*ace + 1, *ace, tail_size);
+	memset(*ace, 0, sizeof(**ace));
+	acl->a_count++;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(richacl_insert_entry);
+
+/**
+ * richacl_append_entry  -  append an entry to an acl
+ * @alloc:		acl and number of allocated entries
+ *
+ * This may require reallocating @alloc->acl.
+ */
+struct richace *richacl_append_entry(struct richacl_alloc *alloc)
+{
+	struct richacl *acl = alloc->acl;
+	struct richace *ace = acl->a_entries + acl->a_count;
+
+	if (alloc->count > alloc->acl->a_count) {
+		acl->a_count++;
+		return ace;
+	}
+	return richacl_insert_entry(alloc, &ace) ? NULL : ace;
+}
+EXPORT_SYMBOL_GPL(richacl_append_entry);
+
+/**
+ * richace_change_mask  -  set the mask of @ace to @mask
+ * @alloc:	acl and number of allocated entries
+ * @ace:	entry to modify
+ * @mask:	new mask for @ace
+ *
+ * If @ace is inheritable, a inherit-only ace is inserted before @ace which
+ * includes the inheritable permissions of @ace and the inheritance flags of
+ * @ace are cleared before changing the mask.
+ *
+ * If @mask is 0, the original ace is turned into an inherit-only entry if
+ * there are any inheritable permissions, and removed otherwise.
+ *
+ * The returned @ace points to the modified or inserted effective-only acl
+ * entry if that entry exists, to the entry that has become inheritable-only,
+ * or else to the previous entry in the acl.
+ */
+static int
+richace_change_mask(struct richacl_alloc *alloc, struct richace **ace,
+			   unsigned int mask)
+{
+	if (mask && (*ace)->e_mask == mask)
+		(*ace)->e_flags &= ~RICHACE_INHERIT_ONLY_ACE;
+	else if (mask & ~RICHACE_POSIX_ALWAYS_ALLOWED) {
+		if (richace_is_inheritable(*ace)) {
+			if (richacl_insert_entry(alloc, ace))
+				return -1;
+			richace_copy(*ace, *ace + 1);
+			(*ace)->e_flags |= RICHACE_INHERIT_ONLY_ACE;
+			(*ace)++;
+			(*ace)->e_flags &= ~RICHACE_INHERITANCE_FLAGS |
+					   RICHACE_INHERITED_ACE;
+		}
+		(*ace)->e_mask = mask;
+	} else {
+		if (richace_is_inheritable(*ace))
+			(*ace)->e_flags |= RICHACE_INHERIT_ONLY_ACE;
+		else
+			richacl_delete_entry(alloc, ace);
+	}
+	return 0;
+}
diff --git a/include/linux/richacl_compat.h b/include/linux/richacl_compat.h
new file mode 100644
index 0000000..a9ff630
--- /dev/null
+++ b/include/linux/richacl_compat.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Written by Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __RICHACL_COMPAT_H
+#define __RICHACL_COMPAT_H
+
+#include <linux/richacl.h>
+
+/**
+ * struct richacl_alloc  -  remember how many entries are actually allocated
+ * @acl:	acl with a_count <= @count
+ * @count:	the actual number of entries allocated in @acl
+ *
+ * We pass around this structure while modifying an acl so that we do
+ * not have to reallocate when we remove existing entries followed by
+ * adding new entries.
+ */
+struct richacl_alloc {
+	struct richacl *acl;
+	unsigned int count;
+};
+
+struct richacl *richacl_prepare(struct richacl_alloc *, unsigned int);
+struct richace *richacl_append_entry(struct richacl_alloc *);
+int richacl_insert_entry(struct richacl_alloc *, struct richace **);
+void richacl_delete_entry(struct richacl_alloc *, struct richace **);
+
+#endif  /* __RICHACL_COMPAT_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
